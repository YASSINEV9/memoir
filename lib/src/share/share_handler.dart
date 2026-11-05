import 'dart:io';

import 'package:cross_file/cross_file.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../archive/archive_item.dart';
import '../chat/chat_style.dart';
import '../l10n.dart';
import '../security/app_lock.dart';

/// Text and files another app shared with Memoir ("Share" → Memoir).
class _Shared {
  const _Shared(this.text, this.files);
  final String? text;
  final List<PlatformFile> files;
  int get count => files.length + (text == null ? 0 : 1);
}

/// Receives shares from MainActivity and asks which chat to save them in,
/// once the app is unlocked.
class ShareHandler extends ConsumerStatefulWidget {
  const ShareHandler({
    required this.navigatorKey,
    required this.child,
    super.key,
  });
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  ConsumerState<ShareHandler> createState() => _ShareHandlerState();
}

class _ShareHandlerState extends ConsumerState<ShareHandler> {
  static const _channel = MethodChannel('memoir/share');
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    if (!Platform.isAndroid) return;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'shared') _check();
    });
    AppLock.instance.locked.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    AppLock.instance.locked.removeListener(_check);
    super.dispose();
  }

  Future<void> _check() async {
    if (_checking || AppLock.instance.locked.value) return;
    _checking = true;
    try {
      final shared = await _take();
      final context = widget.navigatorKey.currentContext;
      if (shared != null && context != null && context.mounted) {
        await _ask(context, shared);
      }
    } finally {
      _checking = false;
    }
  }

  Future<_Shared?> _take() async {
    final data = await _channel.invokeMapMethod<String, Object?>('takeShared');
    if (data == null) return null;
    final files = [
      for (final file in (data['files'] as List<Object?>? ?? const []))
        if (file case {'path': final String path, 'name': final String name})
          _SharedFile(path, name),
    ];
    final text = (data['text'] as String?)?.trim();
    final shared = _Shared(text == null || text.isEmpty ? null : text, files);
    return shared.count == 0 ? null : shared;
  }

  Future<void> _ask(BuildContext context, _Shared shared) async {
    final repo = ref.read(repositoryProvider);
    final l10n = context.l10n;
    final collections = (await repo.collections())
        .where((c) => c.id != 'all')
        .toList();
    if (!context.mounted) return;
    final target = await showModalBottomSheet<ArchiveCollection>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * .7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                child: Text(
                  l10n.shareSaveTo,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Text(
                  shared.text ?? l10n.shareItemsCount(shared.count),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final c in collections)
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: ChatStyle.of(
                            c.id,
                            Theme.of(context).brightness,
                          ).avatar,
                          child: Icon(
                            ChatStyle.of(
                              c.id,
                              Theme.of(context).brightness,
                            ).avatarIcon,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text(collectionLabel(l10n, c.id, c.name)),
                        onTap: () => Navigator.pop(context, c),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    try {
      if (target != null) {
        if (shared.text case final text?) {
          await repo.addText(text, collection: target.id);
        }
        if (shared.files.isNotEmpty) {
          await repo.importFiles(shared.files, collection: target.id);
        }
        ref.invalidate(archiveControllerProvider);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.sharedSaved(collectionLabel(l10n, target.id, target.name)),
              ),
            ),
          );
        }
      }
    } finally {
      // The cache copies are no longer needed: saved files were copied.
      for (final file in shared.files) {
        await File(file.path!).delete().catchError((Object _) => File(''));
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// A shared file copied into the app cache, in the form the archive imports.
final class _SharedFile extends PlatformFile {
  _SharedFile(this._path, this.name);
  final String _path;

  @override
  final String name;

  @override
  Uri get uri => Uri.file(_path);

  @override
  XFile get xFile => XFile(_path, name: name);

  @override
  int? lengthSync() => File(_path).lengthSync();

  @override
  Future<int?> length() => File(_path).length();

  @override
  Future<Uint8List> readAsBytes() => File(_path).readAsBytes();

  @override
  Stream<Uint8List> readAsByteStream() =>
      File(_path).openRead().map(Uint8List.fromList);
}
