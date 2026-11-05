import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n.dart';
import 'update_checker.dart';

bool _promptedThisLaunch = false;

/// Checks GitHub at most once a day and offers a newer version if there is
/// one. Failures stay silent; this runs on its own when the app opens.
Future<void> promptForUpdateIfDue(BuildContext context) async {
  if (_promptedThisLaunch) return;
  _promptedThisLaunch = true;
  try {
    final update = await checkForUpdate();
    if (update != null && context.mounted) {
      await _showUpdateDialog(context, update);
    }
  } catch (_) {
    // Offline or GitHub unavailable: try again on another day.
  }
}

/// The "Check for updates" row in Settings: always asks and always answers.
Future<void> checkForUpdateNow(BuildContext context) async {
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  try {
    final update = await checkForUpdate(force: true);
    if (!context.mounted) return;
    if (update == null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.upToDate)));
    } else {
      await _showUpdateDialog(context, update);
    }
  } catch (_) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.updateCheckFailed)));
  }
}

Future<void> _showUpdateDialog(BuildContext context, AppUpdate update) async {
  final l10n = context.l10n;
  final download = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.system_update_rounded),
      title: Text(l10n.updateAvailableTitle(update.version)),
      content: Text(l10n.updateAvailableBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.updateLater),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.download_rounded),
          label: Text(l10n.updateDownload),
        ),
      ],
    ),
  );
  if (download != true) return;
  // The browser downloads the APK; Android then asks to install it.
  await launchUrl(
    Uri.parse(update.downloadUrl),
    mode: LaunchMode.externalApplication,
  );
}
