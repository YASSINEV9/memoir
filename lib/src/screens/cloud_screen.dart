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
import '../cloud/cloud_storage_provider.dart';
import '../cloud/auto_backup.dart';
import '../cloud/google_drive_provider.dart';
import '../cloud/restore.dart';
import '../l10n.dart';

class CloudScreen extends ConsumerStatefulWidget {
  const CloudScreen({super.key});

  @override
  ConsumerState<CloudScreen> createState() => _CloudScreenState();
}

class _CloudScreenState extends ConsumerState<CloudScreen> {
  late final GoogleDriveProvider _drive;
  bool _loading = true;
  bool _busy = false;
  List<RemoteArchiveFile> _files = const [];
  String? _error;

  /// (done, total) while a backup is running.
  (int, int)? _progress;
  bool _automaticBackup = false;
  TimeOfDay _backupTime = const TimeOfDay(hour: 2, minute: 0);
  DateTime? _lastBackup;
  String? _backupProblem;

  /// Items in Drive that are not on this phone (after a reinstall).
  List<RemoteBackupItem> _restorable = const [];

  /// (done, total) while a restore is running.
  (int, int)? _restoreProgress;

  @override
  void initState() {
    super.initState();
    _drive = ref.read(googleDriveProvider);
    _loadBackupSchedule();
    _restoreGoogleAccount();
  }

  Future<void> _loadBackupSchedule() async {
    final schedule = await loadBackupSchedule();
    if (!mounted) return;
    setState(() {
      _automaticBackup = schedule.enabled;
      _backupTime = TimeOfDay(hour: schedule.hour, minute: schedule.minute);
      _lastBackup = schedule.lastSuccess;
      _backupProblem = schedule.lastProblem;
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

  Future<void> _restoreGoogleAccount() async {
    try {
      if (!_drive.isConnected) await _drive.restore();
      if (_drive.isConnected) {
        _files = await _drive.list();
        _restorable = await findRestorableItems(
          _drive,
          ref.read(repositoryProvider),
        );
      }
    } catch (error) {
      if (mounted) _error = _friendlyError(error);
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _restore() => _run(() async {
    final items = _restorable;
    final int restored;
    try {
      restored = await restoreItems(
        _drive,
        ref.read(repositoryProvider),
        items,
        fallbackCollectionName: context.l10n.restoredCollection,
        onProgress: (done, total) {
          if (mounted) setState(() => _restoreProgress = (done, total));
        },
      );
    } finally {
      if (mounted) setState(() => _restoreProgress = null);
    }
    ref.invalidate(archiveControllerProvider);
    final remaining = await findRestorableItems(
      _drive,
      ref.read(repositoryProvider),
    );
    if (!mounted) return;
    setState(() => _restorable = remaining);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.restoredCount(restored))),
    );
  });

  /// After signing in, offers to bring back what this account saved before.
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

  /// Background backup problems are saved as codes (see auto_backup.dart).
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

  Future<void> _connect() => _run(() async {
    await _drive.connect();
    final files = await _drive.list();
    if (_automaticBackup) {
      await setBackupSchedule(
        enabled: true,
        hour: _backupTime.hour,
        minute: _backupTime.minute,
      );
    }
    await _loadBackupSchedule();
    final restorable = await findRestorableItems(
      _drive,
      ref.read(repositoryProvider),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.connectedTo(_drive.email ?? ''))),
      );
      setState(() {
        _files = files;
        _restorable = restorable;
      });
    }
  }).then((_) => _offerRestore());

  Future<void> _disconnect() => _run(() async {
    // Clear the schedule first: disconnect reports an error if revoking fails
    // while offline, even though the account is forgotten here.
    await setBackupSchedule(
      enabled: false,
      hour: _backupTime.hour,
      minute: _backupTime.minute,
    );
    if (mounted) {
      setState(() {
        _automaticBackup = false;
        _files = const [];
        _restorable = const [];
      });
    }
    await _drive.disconnect();
  });

  Future<void> _refreshFiles() => _run(() async {
    final files = await _drive.list();
    if (mounted) setState(() => _files = files);
  });

  Future<void> _backupArchive() => _run(() async {
    final BackupResult result;
    try {
      result = await runBackup(
        _drive,
        ref.read(repositoryProvider),
        onProgress: (done, total) {
          if (mounted) setState(() => _progress = (done, total));
        },
      );
    } finally {
      if (mounted) setState(() => _progress = null);
    }
    await _loadBackupSchedule();
    final BackupResult(:uploaded, :skipped, :upToDate) = result;
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
    if (_files.isNotEmpty) {
      final files = await _drive.list();
      if (mounted) setState(() => _files = files);
    }
  });

  Future<void> _download(RemoteArchiveFile file) => _run(() async {
    final dialogTitle = context.l10n.exportFromMemoir;
    final directory = await getApplicationDocumentsDirectory();
    final safeName = p
        .basename(file.name)
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    final destination = p.join(directory.path, 'drive_downloads', safeName);
    await _drive.download(file.id, destination);
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
    final connected = _drive.isConnected;
    final l10n = context.l10n;
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
                      else
                        _StatusPill(
                          label: connected
                              ? l10n.connected
                              : _drive.needsReconnect
                              ? l10n.reconnectNeeded
                              : l10n.notConnected,
                          icon: connected ? Icons.link : Icons.link_off,
                        ),
                    ],
                  ),
                  if (connected) ...[
                    const SizedBox(height: 8),
                    Text(_drive.email ?? ''),
                    const SizedBox(height: 8),
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
                    if (_backupProblem != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _problemText(_backupProblem!),
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
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _busy ? null : _refreshFiles,
                          icon: const Icon(Icons.refresh),
                          label: Text(l10n.showDriveFiles),
                        ),
                        FilledButton.icon(
                          onPressed: _busy ? null : _backupArchive,
                          icon: const Icon(Icons.cloud_upload_outlined),
                          label: Text(l10n.backUpArchive),
                        ),
                        TextButton.icon(
                          onPressed: _busy ? null : _disconnect,
                          icon: const Icon(Icons.logout),
                          label: Text(l10n.disconnect),
                        ),
                      ],
                    ),
                  ] else if (_drive.needsReconnect) ...[
                    const SizedBox(height: 8),
                    Text(_drive.email ?? ''),
                    const SizedBox(height: 8),
                    Text(l10n.reconnectRequired),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton.icon(
                          onPressed: _loading || _busy ? null : _connect,
                          icon: const Icon(Icons.login),
                          label: Text(l10n.reconnect),
                        ),
                        TextButton.icon(
                          onPressed: _busy ? null : _disconnect,
                          icon: const Icon(Icons.logout),
                          label: Text(l10n.disconnect),
                        ),
                      ],
                    ),
                  ] else ...[
                    const SizedBox(height: 8),
                    Text(l10n.connectPrompt),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _loading || _busy ? null : _connect,
                      icon: const Icon(Icons.login),
                      label: Text(l10n.continueWithGoogle),
                    ),
                  ],
                  if (_progress case (final done, final total)) ...[
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: total == 0 ? null : done / total,
                    ),
                    const SizedBox(height: 6),
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
          if (connected && _restorable.isNotEmpty) ...[
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
          if (connected) ...[
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
          if (_files.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              l10n.driveFilesCount(_files.length),
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
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
          ] else if (connected) ...[
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
