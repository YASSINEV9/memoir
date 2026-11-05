import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';

import 'archive/archive_item.dart';
import 'l10n.dart';

/// Hands the saved copy of [item] to another app on the phone (a video
/// player, PDF reader, ...).
Future<void> openWithOtherApp(BuildContext context, ArchiveItem item) async {
  final path = item.localPath;
  final result = path == null
      ? null
      : await OpenFilex.open(path, type: _mimeType(item));
  if (!context.mounted || result?.type == ResultType.done) return;
  _toast(
    context,
    result?.type == ResultType.noAppToOpen
        ? context.l10n.noAppToOpen
        : context.l10n.couldNotOpen,
  );
}

/// Opens the backed-up copy in Google Drive (its app if installed, otherwise
/// the browser), which can also stream videos.
Future<void> openInDrive(BuildContext context, ArchiveItem item) async {
  final id = item.driveId;
  if (id == null) return;
  final opened = await launchUrl(
    Uri.parse('https://drive.google.com/file/d/$id/view'),
    mode: LaunchMode.externalApplication,
  );
  if (!opened && context.mounted) _toast(context, context.l10n.linkFailed);
}

void _toast(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));

/// The archive stores the file extension, not a MIME type; give the opening
/// app a real type so the right players are offered.
String? _mimeType(ArchiveItem item) {
  final ext = (item.mimeType ?? item.filename?.split('.').last ?? '')
      .toLowerCase();
  if (item.type == 'video') {
    return switch (ext) {
      'mov' => 'video/quicktime',
      'mkv' => 'video/x-matroska',
      'webm' => 'video/webm',
      _ => 'video/mp4',
    };
  }
  if (item.type == 'audio') return 'audio/*';
  if (item.type == 'image') return 'image/*';
  if (ext == 'pdf') return 'application/pdf';
  return null;
}
