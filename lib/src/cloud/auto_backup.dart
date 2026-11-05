import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../archive/archive_database.dart';
import '../archive/archive_item.dart';
import '../archive/archive_repository.dart';
import 'drive_accounts.dart';
import 'google_drive_provider.dart';

const autoBackupTaskName = 'memoryVaultDailyBackup';
const _autoBackupTag = 'memoryVaultAutoBackup';
const _legacyPeriodicName = 'memoryVaultDailyBackupSchedule';

const _enabledKey = 'automatic_backup_enabled';
const _minutesKey = 'automatic_backup_minutes';
const _nextRunKey = 'automatic_backup_next_run';
const _lastSuccessKey = 'backup_last_success';
const _lastProblemKey = 'backup_last_problem';

/// Problems of the last backup, per account: {email: code}.
const _problemsKey = 'backup_problems';
const _runningUntilKey = 'backup_running_until';

/// Accounts whose Drive files all carry the restore details already.
const _restoreInfoKey = 'backup_restore_info_accounts';

/// How long one backup holds its claim. Refreshed after every uploaded item,
/// and it expires by itself if Android stops the task partway through.
const _leaseDuration = Duration(minutes: 15);

/// Another backup is running, in the app or in the background.
class BackupBusy implements Exception {
  const BackupBusy();

  @override
  String toString() => 'A backup is already running. Try again in a moment.';
}

/// Items not yet in the Drive of [account].
List<ArchiveItem> pendingBackupItems(List<ArchiveItem> items, String account) =>
    items.where((item) => !item.backedUpTo.contains(account)).toList();

/// The next time the clock shows [hour]:[minute], strictly after [now].
DateTime nextBackupTime(int hour, int minute, DateTime now) {
  final today = DateTime(now.year, now.month, now.day, hour, minute);
  return today.isAfter(now)
      ? today
      : DateTime(now.year, now.month, now.day + 1, hour, minute);
}

class BackupResult {
  const BackupResult({
    required this.uploaded,
    required this.skipped,
    required this.upToDate,
  });
  final int uploaded;
  final int skipped;
  final int upToDate;
}

/// Uploads everything not yet backed up. Used by the backup button and the
/// scheduled task; each item is recorded as soon as it is uploaded, so an
/// interrupted backup continues where it stopped and repeats nothing.
Future<BackupResult> runBackup(
  GoogleDriveProvider drive,
  ArchiveRepository repository, {
  void Function(int done, int total)? onProgress,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  final runningUntil = prefs.getInt(_runningUntilKey) ?? 0;
  if (DateTime.now().millisecondsSinceEpoch < runningUntil) {
    throw const BackupBusy();
  }
  Future<void> holdLease() => prefs.setInt(
    _runningUntilKey,
    DateTime.now().add(_leaseDuration).millisecondsSinceEpoch,
  );
  await holdLease();
  try {
    final account = drive.email ?? '';
    final items = await repository.list();
    final names = await repository.collectionNames();
    final pending = pendingBackupItems(items, account);
    var uploaded = 0;
    var skipped = 0;
    // Files uploaded by older versions lack the details a restore needs;
    // list them once per account to add those details.
    final backfilled = prefs.getStringList(_restoreInfoKey) ?? const [];
    final backfill = !backfilled.contains(account);
    final known = pending.isNotEmpty || backfill
        ? await drive.backedUpItems()
        : const <String, String>{};
    if (pending.isNotEmpty) {
      onProgress?.call(0, pending.length);
      var next = 0;
      // A few uploads in parallel are much faster than one at a time.
      Future<void> worker() async {
        while (next < pending.length) {
          final item = pending[next++];
          final path = item.localPath ?? '';
          if (path.isNotEmpty && !await File(path).exists()) {
            skipped++;
          } else {
            final driveId = await drive.uploadItem(
              item,
              localFilePath: path,
              known: known,
              collectionName: names[item.collection],
            );
            await repository.markBackedUp(item, driveId, account);
            uploaded++;
            await holdLease();
          }
          onProgress?.call(uploaded + skipped, pending.length);
        }
      }

      await Future.wait(List.generate(4, (_) => worker()));
    }
    if (backfill) {
      final byId = {for (final item in items) item.id: item};
      final missing = drive.missingRestoreInfo.toList();
      var next = 0;
      Future<void> worker() async {
        while (next < missing.length) {
          final item = byId[missing[next++]];
          final fileId = item == null ? null : known[item.id];
          if (item == null || fileId == null) continue;
          await drive.updateRestoreInfo(fileId, item, names[item.collection]);
          await holdLease();
        }
      }

      await Future.wait(List.generate(4, (_) => worker()));
      await prefs.setStringList(_restoreInfoKey, [...backfilled, account]);
    }
    await prefs.setInt(_lastSuccessKey, DateTime.now().millisecondsSinceEpoch);
    await _setProblem(prefs, account, null);
    return BackupResult(
      uploaded: uploaded,
      skipped: skipped,
      upToDate: items.length - pending.length,
    );
  } finally {
    await prefs.remove(_runningUntilKey);
  }
}

/// Saved schedule and the outcome of the last backup, for the Drive screen.
class BackupSchedule {
  const BackupSchedule({
    required this.enabled,
    required this.hour,
    required this.minute,
    this.lastSuccess,
    this.problems = const {},
  });
  final bool enabled;
  final int hour;
  final int minute;
  final DateTime? lastSuccess;

  /// Problem codes of the last backup by account email.
  final Map<String, String> problems;
}

Map<String, String> _problems(SharedPreferences prefs) {
  final saved = prefs.getString(_problemsKey);
  if (saved != null) {
    return (jsonDecode(saved) as Map<String, dynamic>).cast<String, String>();
  }
  // Saved without an account by versions before 1.3.0.
  final legacy = prefs.getString(_lastProblemKey);
  return legacy == null ? {} : {'': legacy};
}

Future<void> _setProblem(
  SharedPreferences prefs,
  String account,
  String? code,
) async {
  final problems = _problems(prefs)..remove('');
  code == null ? problems.remove(account) : problems[account] = code;
  await prefs.setString(_problemsKey, jsonEncode(problems));
  await prefs.remove(_lastProblemKey);
}

Future<BackupSchedule> loadBackupSchedule() async {
  final prefs = await SharedPreferences.getInstance();
  // A background backup may have written these from its own isolate.
  await prefs.reload();
  final minutes = prefs.getInt(_minutesKey) ?? 120;
  final lastSuccess = prefs.getInt(_lastSuccessKey);
  return BackupSchedule(
    enabled: prefs.getBool(_enabledKey) ?? false,
    hour: minutes ~/ 60,
    minute: minutes % 60,
    lastSuccess: lastSuccess == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(lastSuccess),
    problems: _problems(prefs),
  );
}

/// Saves the setting and replaces any scheduled run. Android runs one task at
/// a time and each schedules the next: a periodic task would drift later every
/// day, and changing its time does not move it once it has run.
Future<void> setBackupSchedule({
  required bool enabled,
  required int hour,
  required int minute,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(_minutesKey, hour * 60 + minute);
  await prefs.setBool(_enabledKey, enabled);
  if (defaultTargetPlatform == TargetPlatform.android) {
    await Workmanager().cancelByUniqueName(_legacyPeriodicName);
    await Workmanager().cancelByTag(_autoBackupTag);
  }
  if (enabled) {
    await _enqueueBackup(nextBackupTime(hour, minute, DateTime.now()));
  } else {
    await prefs.remove(_nextRunKey);
  }
}

Future<void> _enqueueBackup(DateTime at) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(_nextRunKey, at.millisecondsSinceEpoch);
  if (defaultTargetPlatform != TargetPlatform.android) return;
  final delay = at.difference(DateTime.now());
  await Workmanager().registerOneOffTask(
    '$autoBackupTaskName-${at.millisecondsSinceEpoch}',
    autoBackupTaskName,
    tag: _autoBackupTag,
    initialDelay: delay.isNegative ? Duration.zero : delay,
    // Waits for internet by itself if the phone is offline at the chosen time.
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingWorkPolicy.keep,
    backoffPolicy: BackoffPolicy.exponential,
    backoffPolicyDelay: const Duration(minutes: 5),
  );
}

/// Called when the app starts, to catch up on a backup that did not run: iOS
/// has no scheduled task here, and on Android force-stopping the app or an
/// aggressive battery saver can cancel one.
Future<void> resumeAutomaticBackup() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  if (!(prefs.getBool(_enabledKey) ?? false)) return;
  final minutes = prefs.getInt(_minutesKey) ?? 120;
  final nextRun = prefs.getInt(_nextRunKey);
  final now = DateTime.now();
  if (nextRun == null) {
    await _enqueueBackup(nextBackupTime(minutes ~/ 60, minutes % 60, now));
    return;
  }
  final due = DateTime.fromMillisecondsSinceEpoch(nextRun);
  if (defaultTargetPlatform == TargetPlatform.android) {
    // Android may be a little late, or waiting for internet, on its own.
    if (now.isAfter(due.add(const Duration(hours: 1)))) {
      await _enqueueBackup(now);
    }
  } else if (now.isAfter(due)) {
    await runAutomaticBackup();
  }
}

/// Runs the daily backup to every connected account. Returns false when it
/// should be retried later.
Future<bool> runAutomaticBackup() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  if (!(prefs.getBool(_enabledKey) ?? false)) return true;
  var finished = true;
  for (final email in await DriveAccounts.savedEmails()) {
    final drive = GoogleDriveProvider(email: email);
    // Saved as a code; the Drive screen shows it in the app's language.
    Future<void> problem(String code) => _setProblem(prefs, email, code);
    try {
      if (await drive.restore()) {
        await runBackup(drive, ArchiveRepository(ArchiveDatabase.instance));
      } else {
        await problem('reconnect');
      }
    } on DriveReconnectRequired {
      await problem('reconnect');
    } on BackupBusy {
      finished = false;
    } on SocketException {
      await problem('offline');
      finished = false;
    } on TimeoutException {
      await problem('timeout');
      finished = false;
    } on http.ClientException {
      await problem('connection');
      finished = false;
    } on HttpException catch (error) {
      await problem('retry:$error');
      finished = false;
    } on GoogleSignInException {
      await problem('google');
      finished = false;
    } catch (error) {
      // Retrying right away will not help, for example when Drive is full.
      await problem('error:$error');
    } finally {
      drive.dispose();
    }
  }
  if (finished) {
    final minutes = prefs.getInt(_minutesKey) ?? 120;
    await _enqueueBackup(
      nextBackupTime(minutes ~/ 60, minutes % 60, DateTime.now()),
    );
  }
  return finished;
}
