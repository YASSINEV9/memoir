import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' show DateFormat;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../main.dart';
import '../cloud/auto_backup.dart';
import '../cloud/cloud_storage_provider.dart';
import '../cloud/drive_accounts.dart';
import '../cloud/google_drive_provider.dart';
import '../cloud/restore.dart';
import '../l10n.dart';

class CloudScreen extends ConsumerStatefulWidget {
  const CloudScreen({super.key});

  @override
  ConsumerState<CloudScreen> createState() => _CloudScreenState();
}

class _CloudScreenState extends ConsumerState<CloudScreen> {
  late final DriveAccounts _accounts;
  bool _loading = true;
  bool _busy = false;
  String? _error;

  /// Drive files of the account picked with "Show Drive files".
  GoogleDriveProvider? _filesAccount;
  List<RemoteArchiveFile> _files = const [];

  /// While a backup runs: the account and (done, total).
  (String, int, int)? _progress;
  bool _automaticBackup = false;
  TimeOfDay _backupTime = const TimeOfDay(hour: 2, minute: 0);
  DateTime? _lastBackup;
  Map<String, String> _problems = const {};

  /// Items in the accounts' Drive that are not on this phone.
  RestorePlan _restorable = RestorePlan.empty;

  /// (done, total) while a restore is running.
  (int, int)? _restoreProgress;

  @override
  void initState() {
    super.initState();
    _accounts = ref.read(driveAccountsProvider);
    _accounts.addListener(_refresh);
    _loadBackupSchedule();
    _restoreAccounts();
  }

  @override
  void dispose() {
    _accounts.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _loadBackupSchedule() async {
    final schedule = await loadBackupSchedule();
    if (!mounted) return;
    setState(() {
      _automaticBackup = schedule.enabled;
      _backupTime = TimeOfDay(hour: schedule.hour, minute: schedule.minute);
      _lastBackup = schedule.lastSuccess;
      _problems = schedule.problems;
    });
  }

  Future<void> _setAutomaticBackup(bool enabled) async {
    try {
      await setBackupSchedule(
        enabled: enabled,
        hour: _backupTime.hour,
        minute: _backupTime.minute,
      );
      if (mounted) setState(() => _automaticBackup = enabled);
    } catch (error) {
      if (mounted) setState(() => _error = _friendlyError(error));
    }
  }

  Future<void> _chooseBackupTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _backupTime,
    );
    if (selected == null) return;
    setState(() => _backupTime = selected);
    try {
      await setBackupSchedule(
        enabled: _automaticBackup,
        hour: selected.hour,
        minute: selected.minute,
      );
    } catch (error) {
      if (mounted) setState(() => _error = _friendlyError(error));
    }
  }

  Future<void> _restoreAccounts() async {
    try {
      if (_accounts.accounts.isEmpty) await _accounts.restoreAll();
      await _findRestorable();
    } catch (error) {
      if (mounted) _error = _friendlyError(error);
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _findRestorable() async {
    final connected = _accounts.connected;
    if (connected.isEmpty) return;
    final plan = await findRestorableItems(
      connected,
      ref.read(repositoryProvider),
    );
    if (mounted) setState(() => _restorable = plan);
  }

  Future<void> _restore() => _run(() async {
    final int restored;
    try {
      restored = await restoreItems(
        _restorable,
        ref.read(repositoryProvider),
        fallbackCollectionName: context.l10n.restoredCollection,
        onProgress: (done, total) {
          if (mounted) setState(() => _restoreProgress = (done, total));
        },
      );
    } finally {
      if (mounted) setState(() => _restoreProgress = null);
    }
    ref.invalidate(archiveControllerProvider);
    await _findRestorable();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.restoredCount(restored))),
    );
  });

  /// After signing in, offers to bring back what the accounts saved before.
  Future<void> _offerRestore() async {
    if (_restorable.isEmpty || !mounted) return;
    final l10n = context.l10n;
    final restore = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.cloud_download_outlined),
        title: Text(l10n.restoreFoundTitle(_restorable.length)),
        content: Text(l10n.restoreFoundBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.notNow),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.restore),
          ),
        ],
      ),
    );
    if (restore == true) await _restore();
  }

  /// Backup problems are saved as codes (see auto_backup.dart).
  String _problemText(String code) {
    final l10n = context.l10n;
    return switch (code) {
      'reconnect' => l10n.reconnectRequired,
      'offline' => l10n.problemOffline,
      'timeout' => l10n.problemTimeout,
      'connection' => l10n.problemConnectionFailed,
      'google' => l10n.problemGoogleUnreachable,
      _ when code.startsWith('retry:') => l10n.problemRetry(code.substring(6)),
      _ when code.startsWith('error:') => code.substring(6),
      // Saved as text by an earlier version.
      _ => code,
    };
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } catch (error) {
      if (mounted) setState(() => _error = _friendlyError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _friendlyError(Object error) {
    final l10n = context.l10n;
    if (error is GoogleSignInException && isGoogleNetworkFailure(error)) {
      return l10n.noInternet;
    }
    if (error is GoogleSignInException) {
      final details = error.description == null
          ? ''
          : ' (${error.description})';
      return switch (error.code) {
        // Credential Manager also reports a SHA-1/package mismatch as
        // "canceled", so do not claim the user cancelled.
        GoogleSignInExceptionCode.canceled => l10n.signInClosed(details),
        GoogleSignInExceptionCode.clientConfigurationError ||
        GoogleSignInExceptionCode.providerConfigurationError =>
          l10n.signInMisconfigured(details),
        GoogleSignInExceptionCode.uiUnavailable => l10n.signInUiUnavailable(
          details,
        ),
        GoogleSignInExceptionCode.interrupted => l10n.signInInterrupted(
          details,
        ),
        _ => l10n.signInFailed(error.code.name, details),
      };
    }
    if (error is DriveReconnectRequired) return l10n.reconnectRequired;
    if (error is BackupBusy) return l10n.backupBusy;
    if (error is SocketException || error is http.ClientException) {
      return l10n.noInternet;
    }
    final text = error.toString().replaceFirst(RegExp(r'^\w+Exception: '), '');
    if (text.contains('access_denied')) return l10n.drivePermissionDenied;
    return text;
  }

  /// Signs in with an account picked in Google's chooser: a new account is
  /// added, an already listed one is reconnected.
  Future<void> _addAccount() => _run(() async {
    final account = await _accounts.add();
    if (_automaticBackup) {
      await setBackupSchedule(
        enabled: true,
        hour: _backupTime.hour,
        minute: _backupTime.minute,
      );
    }
    await _loadBackupSchedule();
    await _findRestorable();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.connectedTo(account.email ?? ''))),
      );
    }
  }).then((_) => _offerRestore());

  Future<void> _removeAccount(GoogleDriveProvider account) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.removeAccountTitle(account.email ?? '')),
        content: Text(l10n.removeAccountBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.removeAccount),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _run(() async {
      if (_filesAccount == account) {
        setState(() {
          _filesAccount = null;
          _files = const [];
        });
      }
      try {
        await _accounts.remove(account);
      } finally {
        // With no account left, nothing can be backed up on a schedule.
        if (_accounts.accounts.isEmpty) {
          await setBackupSchedule(
            enabled: false,
            hour: _backupTime.hour,
            minute: _backupTime.minute,
          );
          if (mounted) setState(() => _automaticBackup = false);
        }
        await _findRestorable();
      }
    });
  }

  Future<void> _showFiles(GoogleDriveProvider account) => _run(() async {
    final files = await account.list();
    if (mounted) {
      setState(() {
        _filesAccount = account;
        _files = files;
      });
    }
  });

  /// Backs up to every connected account, one after the other.
  Future<void> _backupArchive() => _run(() async {
    var uploaded = 0;
    var skipped = 0;
    var upToDate = 0;
    try {
      for (final account in _accounts.connected) {
        final email = account.email!;
        final result = await runBackup(
          account,
          ref.read(repositoryProvider),
          onProgress: (done, total) {
            if (mounted) setState(() => _progress = (email, done, total));
          },
        );
        uploaded += result.uploaded;
        skipped = result.skipped;
        upToDate = result.upToDate;
      }
    } finally {
      if (mounted) setState(() => _progress = null);
      await _loadBackupSchedule();
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          uploaded == 0 && skipped == 0
              ? context.l10n.everythingBackedUp
              : [
                  context.l10n.backedUpNew(uploaded),
                  if (upToDate > 0) context.l10n.alreadyUpToDate(upToDate),
                  if (skipped > 0) context.l10n.skippedMissing(skipped),
                ].join(' · '),
        ),
      ),
    );
    if (_filesAccount case final account?) {
      final files = await account.list();
      if (mounted) setState(() => _files = files);
    }
  });

  Future<void> _download(RemoteArchiveFile file) => _run(() async {
    final account = _filesAccount;
    if (account == null) return;
    final dialogTitle = context.l10n.exportFromMemoir;
    final directory = await getApplicationDocumentsDirectory();
    final safeName = p
        .basename(file.name)
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    final destination = p.join(directory.path, 'drive_downloads', safeName);
    await account.download(file.id, destination);
    final bytes = await File(destination).readAsBytes();
    final saved = await FilePicker.saveFile(
      fileName: safeName,
      bytes: bytes,
      dialogTitle: dialogTitle,
    );
    await File(destination).delete();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            saved == null
                ? context.l10n.exportCancelled
                : context.l10n.savedForTransfer(safeName),
          ),
        ),
      );
    }
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final accounts = _accounts.accounts;
    final anyConnected = _accounts.connected.isNotEmpty;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navDrive)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.phone_android,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        l10n.thisDevice,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.localAvailable),
                  const SizedBox(height: 10),
                  _StatusPill(
                    label: l10n.available,
                    icon: Icons.check_circle_outline,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            l10n.yourBackup,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.add_to_drive_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.navDrive,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      if (_loading || _busy)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else if (accounts.isEmpty)
                        _StatusPill(
                          label: l10n.notConnected,
                          icon: Icons.link_off,
                        ),
                    ],
                  ),
                  if (accounts.isEmpty) ...[
                    const SizedBox(height: 8),
                    Text(l10n.connectPrompt),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _loading || _busy ? null : _addAccount,
                      icon: const Icon(Icons.login),
                      label: Text(l10n.continueWithGoogle),
                    ),
                  ] else ...[
                    const SizedBox(height: 4),
                    for (final account in accounts)
                      _AccountRow(
                        account: account,
                        problem: _problems[account.email] == null
                            ? null
                            : _problemText(_problems[account.email]!),
                        busy: _busy,
                        onReconnect: _addAccount,
                        onShowFiles: () => _showFiles(account),
                        onRemove: () => _removeAccount(account),
                      ),
                    if (DriveAccounts.supportsSeveral) ...[
                      const SizedBox(height: 4),
                      OutlinedButton.icon(
                        onPressed: _busy ? null : _addAccount,
                        icon: const Icon(Icons.person_add_alt_1_outlined),
                        label: Text(l10n.addAccount),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.backupToAllAccounts,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                  if (anyConnected) ...[
                    const Divider(height: 28),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(Icons.backup_outlined),
                      title: Text(l10n.automaticBackup),
                      subtitle: Text(l10n.automaticBackupSubtitle),
                      value: _automaticBackup,
                      onChanged: _setAutomaticBackup,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.schedule_outlined),
                      title: Text(l10n.backupTime),
                      subtitle: Text(_backupTime.format(context)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _chooseBackupTime,
                    ),
                    Text(
                      _lastBackup == null
                          ? l10n.lastBackupNever
                          : l10n.lastBackupAt(
                              DateFormat.yMMMd().add_Hm().format(_lastBackup!),
                            ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    // A problem saved before accounts were tracked separately.
                    if (_problems[''] case final legacy?) ...[
                      const SizedBox(height: 4),
                      Text(
                        _problemText(legacy),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    if (_automaticBackup) ...[
                      const SizedBox(height: 4),
                      Text(
                        defaultTargetPlatform == TargetPlatform.iOS
                            ? l10n.iosScheduleNote
                            : l10n.androidScheduleNote,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _busy ? null : _backupArchive,
                      icon: const Icon(Icons.cloud_upload_outlined),
                      label: Text(l10n.backUpArchive),
                    ),
                  ],
                  if (_progress case (
                    final email,
                    final done,
                    final total,
                  )) ...[
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: total == 0 ? null : done / total,
                    ),
                    const SizedBox(height: 6),
                    Text(email, style: Theme.of(context).textTheme.bodySmall),
                    Text(l10n.backingUpProgress(done, total)),
                  ],
                  if (_restoreProgress case (final done, final total)) ...[
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: total == 0 ? null : done / total,
                    ),
                    const SizedBox(height: 6),
                    Text(l10n.restoringProgress(done, total)),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (!_restorable.isEmpty) ...[
            const SizedBox(height: 8),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.cloud_download_outlined),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.restoreFoundTitle(_restorable.length),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.restoreFoundBody),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _busy ? null : _restore,
                      icon: const Icon(Icons.restore_rounded),
                      label: Text(l10n.restore),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (anyConnected) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.organizedInDrive,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Memoir / Photos · Text · Documents · Videos · Audio · Files',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(l10n.transferHint),
                  ],
                ),
              ),
            ),
          ],
          if (_filesAccount case final account? when _files.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              l10n.driveFilesCount(_files.length),
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              account.email ?? '',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            ..._files.map(
              (file) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(_iconForCategory(file.category)),
                  ),
                  title: Text(
                    file.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${file.category} · ${_formatSize(file.size)} · ${DateFormat.yMMMd().add_Hm().format(file.modifiedAt.toLocal())}',
                  ),
                  trailing: IconButton(
                    tooltip: l10n.download,
                    onPressed: _busy ? null : () => _download(file),
                    icon: const Icon(Icons.download_outlined),
                  ),
                ),
              ),
            ),
          ] else if (anyConnected) ...[
            const SizedBox(height: 8),
            Text(l10n.showDriveFilesHint),
          ],
          const SizedBox(height: 12),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.driveStorageNote),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const VaultNavigation(location: '/cloud'),
    );
  }

  String _formatSize(int size) => size < 1024
      ? '‎$size B'
      : size < 1024 * 1024
      ? '‎${(size / 1024).toStringAsFixed(0)} KB'
      : '‎${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  IconData _iconForCategory(String category) => switch (category) {
    'Photos' => Icons.image_outlined,
    'Videos' => Icons.video_file_outlined,
    'Text' => Icons.notes_rounded,
    'Documents' => Icons.description_outlined,
    'Audio' => Icons.audio_file_outlined,
    _ => Icons.insert_drive_file_outlined,
  };
}

/// One connected Google account with its status and actions.
class _AccountRow extends StatelessWidget {
  const _AccountRow({
    required this.account,
    required this.problem,
    required this.busy,
    required this.onReconnect,
    required this.onShowFiles,
    required this.onRemove,
  });
  final GoogleDriveProvider account;
  final String? problem;
  final bool busy;
  final VoidCallback onReconnect;
  final VoidCallback onShowFiles;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: scheme.primaryContainer,
                child: Text(
                  (account.email ?? '?').characters.first.toUpperCase(),
                  style: TextStyle(color: scheme.onPrimaryContainer),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.email ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      account.needsReconnect
                          ? l10n.reconnectNeeded
                          : l10n.connected,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: account.needsReconnect
                            ? scheme.error
                            : scheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              if (account.needsReconnect)
                TextButton(
                  onPressed: busy ? null : onReconnect,
                  child: Text(l10n.reconnect),
                ),
              PopupMenuButton<String>(
                enabled: !busy,
                onSelected: (value) =>
                    value == 'files' ? onShowFiles() : onRemove(),
                itemBuilder: (_) => [
                  if (account.isConnected)
                    PopupMenuItem(
                      value: 'files',
                      child: ListTile(
                        leading: const Icon(Icons.folder_open_outlined),
                        title: Text(l10n.showDriveFiles),
                      ),
                    ),
                  PopupMenuItem(
                    value: 'remove',
                    child: ListTile(
                      leading: Icon(Icons.logout, color: scheme.error),
                      title: Text(
                        l10n.removeAccount,
                        style: TextStyle(color: scheme.error),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (problem != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 48, top: 2),
              child: Text(
                problem!,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: scheme.error),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Chip(
    avatar: Icon(icon, size: 16),
    label: Text(label),
    visualDensity: VisualDensity.compact,
  );
}
