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
      if (_drive.isConnected) _files = await _drive.list();
    } catch (error) {
      _error = _friendlyError(error);
    }
    if (mounted) setState(() => _loading = false);
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
    if (error is GoogleSignInException && isGoogleNetworkFailure(error)) {
      return 'No internet connection. Check your connection and try again.';
    }
    if (error is GoogleSignInException) {
      final details = error.description == null
          ? ''
          : ' (${error.description})';
      return switch (error.code) {
        // Credential Manager also reports a SHA-1/package mismatch or a
        // non-test account as "canceled", so do not claim the user cancelled.
        GoogleSignInExceptionCode.canceled =>
          'Google sign-in was closed or rejected. If you did not cancel it, '
              'check that this account is a test user and that the app\'s '
              'SHA-1 is registered in Google Cloud Console.$details',
        GoogleSignInExceptionCode.clientConfigurationError ||
        GoogleSignInExceptionCode.providerConfigurationError =>
          'Google sign-in is misconfigured (OAuth client / SHA-1).$details',
        GoogleSignInExceptionCode.uiUnavailable =>
          'Google sign-in could not show its window. Try again.$details',
        GoogleSignInExceptionCode.interrupted =>
          'Google sign-in was interrupted. Try again.$details',
        _ => 'Google sign-in failed: ${error.code.name}$details',
      };
    }
    if (error is SocketException || error is http.ClientException) {
      return 'No internet connection. Check your connection and try again.';
    }
    final text = error.toString().replaceFirst(RegExp(r'^\w+Exception: '), '');
    if (text.contains('access_denied')) {
      return 'Google Drive permission was denied.';
    }
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
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Connected to ${_drive.email}')));
      setState(() => _files = files);
    }
  });

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
              ? 'Everything is already backed up'
              : 'Backed up $uploaded new item${uploaded == 1 ? '' : 's'}'
                    '${upToDate == 0 ? '' : ' · $upToDate already up to date'}'
                    '${skipped == 0 ? '' : ' · skipped $skipped missing file${skipped == 1 ? '' : 's'}'}',
        ),
      ),
    );
    if (_files.isNotEmpty) {
      final files = await _drive.list();
      if (mounted) setState(() => _files = files);
    }
  });

  Future<void> _download(RemoteArchiveFile file) => _run(() async {
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
      dialogTitle: 'Export from Memoir',
    );
    await File(destination).delete();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            saved == null
                ? 'Export cancelled.'
                : 'Saved for transfer: $safeName',
          ),
        ),
      );
    }
  });

  @override
  Widget build(BuildContext context) {
    final connected = _drive.isConnected;
    return Scaffold(
      appBar: AppBar(title: const Text('Google Drive')),
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
                      const Text(
                        'This device',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your archive is saved locally and remains available offline.',
                  ),
                  const SizedBox(height: 10),
                  const _StatusPill(
                    label: 'Available',
                    icon: Icons.check_circle_outline,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Your backup',
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
                      const Expanded(
                        child: Text(
                          'Google Drive',
                          style: TextStyle(fontWeight: FontWeight.w700),
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
                              ? 'Connected'
                              : _drive.needsReconnect
                              ? 'Reconnect needed'
                              : 'Not connected',
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
                      title: const Text('Automatic backup'),
                      subtitle: const Text(
                        'Upload new items daily when internet is available',
                      ),
                      value: _automaticBackup,
                      onChanged: _setAutomaticBackup,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.schedule_outlined),
                      title: const Text('Backup time'),
                      subtitle: Text(_backupTime.format(context)),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _chooseBackupTime,
                    ),
                    Text(
                      _lastBackup == null
                          ? 'Last backup: not yet'
                          : 'Last backup: ${DateFormat.yMMMd().add_Hm().format(_lastBackup!)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (_backupProblem != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _backupProblem!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    if (_automaticBackup) ...[
                      const SizedBox(height: 4),
                      Text(
                        defaultTargetPlatform == TargetPlatform.iOS
                            ? 'iOS does not let apps run at a chosen time. '
                                  'The backup runs the next time you open '
                                  'Memoir after this time.'
                            : 'Android may run this later than the chosen '
                                  'time to save battery, or wait until the '
                                  'phone is online. Force-stopping Memoir '
                                  'pauses it until you open the app again.',
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
                          label: const Text('Show Drive files'),
                        ),
                        FilledButton.icon(
                          onPressed: _busy ? null : _backupArchive,
                          icon: const Icon(Icons.cloud_upload_outlined),
                          label: const Text('Back up archive'),
                        ),
                        TextButton.icon(
                          onPressed: _busy ? null : _disconnect,
                          icon: const Icon(Icons.logout),
                          label: const Text('Disconnect'),
                        ),
                      ],
                    ),
                  ] else if (_drive.needsReconnect) ...[
                    const SizedBox(height: 8),
                    Text(_drive.email ?? ''),
                    const SizedBox(height: 8),
                    const Text(
                      'Your Google session expired or Drive access was removed. '
                      'Reconnect to continue backing up.',
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton.icon(
                          onPressed: _loading || _busy ? null : _connect,
                          icon: const Icon(Icons.login),
                          label: const Text('Reconnect'),
                        ),
                        TextButton.icon(
                          onPressed: _busy ? null : _disconnect,
                          icon: const Icon(Icons.logout),
                          label: const Text('Disconnect'),
                        ),
                      ],
                    ),
                  ] else ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Choose a Google account to create your Memoir folders and approve Drive access.',
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _loading || _busy ? null : _connect,
                      icon: const Icon(Icons.login),
                      label: const Text('Continue with Google'),
                    ),
                  ],
                  if (_progress case (final done, final total)) ...[
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: total == 0 ? null : done / total,
                    ),
                    const SizedBox(height: 6),
                    Text('Backing up $done of $total…'),
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
          if (connected) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Organized in your Drive',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Memoir / Photos · Text · Documents · Videos · Audio · Files',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'To transfer accounts, export these files to your device, connect the other Google account, import them from “Add to vault”, then back up the archive.',
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (_files.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              'Drive files (${_files.length})',
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
                    '${file.category} · ${_formatSize(file.size)} · ${file.modifiedAt.toLocal()}',
                  ),
                  trailing: IconButton(
                    tooltip: 'Download',
                    onPressed: _busy ? null : () => _download(file),
                    icon: const Icon(Icons.download_outlined),
                  ),
                ),
              ),
            ),
          ] else if (connected) ...[
            const SizedBox(height: 8),
            const Text(
              'Choose “Show Drive files” to see everything backed up by Memoir.',
            ),
          ],
          const SizedBox(height: 12),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Your archive is stored under Memoir in your Google Drive. Sign in to another Google account to create a separate, neatly organized archive there.',
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const VaultNavigation(location: '/cloud'),
    );
  }

  String _formatSize(int size) => size < 1024
      ? '$size B'
      : size < 1024 * 1024
      ? '${(size / 1024).toStringAsFixed(0)} KB'
      : '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
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
