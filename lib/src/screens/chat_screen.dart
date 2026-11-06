import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:path/path.dart' as p;

import '../../main.dart';
import '../archive/archive_item.dart';
import '../chat/chat_style.dart';
import '../l10n.dart';
import '../media_actions.dart';
import 'video_player_screen.dart';

/// One collection shown as a chat, styled after the app it archives.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({required this.collectionId, this.name, super.key});
  final String collectionId;
  final String? name;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _composer = TextEditingController();
  List<ArchiveItem> _items = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _composer.addListener(() => setState(() {}));
    _reload();
  }

  ScaffoldMessengerState? _messenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _messenger = ScaffoldMessenger.maybeOf(context);
  }

  @override
  void dispose() {
    // Its Undo belongs to this chat; it should not follow to other screens.
    if (_undoShown) _messenger?.hideCurrentSnackBar();
    _composer.dispose();
    super.dispose();
  }

  bool _undoShown = false;

  Future<void> _reload() async {
    final items = await ref
        .read(repositoryProvider)
        .list(collection: widget.collectionId);
    if (mounted) {
      setState(() {
        _items = items;
        _loading = false;
      });
    }
  }

  Future<void> _changed() async {
    ref.invalidate(archiveControllerProvider);
    await _reload();
  }

  Future<void> _send() async {
    final text = _composer.text;
    if (text.trim().isEmpty) return;
    _composer.clear();
    await ref
        .read(repositoryProvider)
        .addText(text, collection: widget.collectionId);
    await _changed();
  }

  Future<void> _attach() async {
    try {
      final files = await FilePicker.pickFiles(type: FileType.any);
      if (files.isEmpty) return;
      await ref
          .read(repositoryProvider)
          .importFiles(files, collection: widget.collectionId);
      await _changed();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.importFailed('$error'))),
        );
      }
    }
  }

  Future<void> _showActions(
    ArchiveItem item, {
    List<ArchiveItem> group = const [],
  }) async {
    final media = item.type == 'image' || item.type == 'video';
    final hasFile =
        item.localPath != null && File(item.localPath!).existsSync();
    final l10n = context.l10n;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.body != null)
              _action(context, Icons.copy_rounded, l10n.copy, 'copy'),
            if (item.type == 'video' && hasFile)
              _action(context, Icons.play_circle_outline, l10n.play, 'play'),
            if (hasFile && item.type != 'image')
              _action(
                context,
                Icons.open_in_new_rounded,
                l10n.openWith,
                'open_with',
              ),
            if (item.driveId != null && item.localPath != null)
              _action(
                context,
                Icons.add_to_drive_outlined,
                l10n.openInDrive,
                'open_drive',
              ),
            if (item.localPath != null)
              _action(
                context,
                Icons.download_rounded,
                media ? l10n.saveToGallery : l10n.saveToDevice,
                'save',
              ),
            if (group.length > 1)
              _action(
                context,
                Icons.download_for_offline_outlined,
                l10n.saveAllToGallery(group.length),
                'save_all',
              ),
            _action(
              context,
              item.pinned ? Icons.push_pin_outlined : Icons.push_pin_rounded,
              item.pinned ? l10n.unpin : l10n.pin,
              'pin',
            ),
            _action(
              context,
              item.favorite ? Icons.star_outline_rounded : Icons.star_rounded,
              item.favorite ? l10n.removeFavorite : l10n.favorite,
              'favorite',
            ),
            _action(
              context,
              Icons.delete_outline_rounded,
              l10n.delete,
              'delete',
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
    if (!mounted || action == null) return;
    final repo = ref.read(repositoryProvider);
    switch (action) {
      case 'copy':
        await Clipboard.setData(ClipboardData(text: item.body!));
        return;
      case 'save':
        await _save([item]);
        return;
      case 'save_all':
        await _save(group);
        return;
      case 'play':
        _openViewer(item);
        return;
      case 'open_with':
        await openWithOtherApp(context, item);
        return;
      case 'open_drive':
        await openInDrive(context, item);
        return;
      case 'pin':
        await repo.setFlag(item, 'pinned', !item.pinned);
      case 'favorite':
        await repo.setFlag(item, 'favorite', !item.favorite);
      case 'delete':
        // Recently deleted keeps it for 30 days, so no confirmation needed.
        await repo.moveToTrash(item);
        await _changed();
        if (!mounted) return;
        _undoShown = true;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(l10n.movedToTrash),
              // A SnackBar with an action otherwise stays until closed.
              persist: false,
              action: SnackBarAction(
                label: l10n.undo,
                onPressed: () async {
                  await repo.restoreFromTrash(item);
                  if (mounted) await _changed();
                },
              ),
            ),
          ).closed.then((_) => _undoShown = false);
        return;
    }
    await _changed();
  }

  /// Photos and videos go to the gallery (album "Memoir"); other files open
  /// the system "Save as" dialog.
  Future<void> _save(List<ArchiveItem> items) async {
    var saved = 0;
    try {
      for (final item in items) {
        final path = item.localPath;
        if (path == null || !await File(path).exists()) continue;
        if (item.type == 'image' || item.type == 'video') {
          if (!await Gal.hasAccess(toAlbum: true) &&
              !await Gal.requestAccess(toAlbum: true)) {
            if (mounted) _toast(context.l10n.allowPhotos);
            return;
          }
          item.type == 'image'
              ? await Gal.putImage(path, album: 'Memoir')
              : await Gal.putVideo(path, album: 'Memoir');
        } else {
          final uri = await FilePicker.saveFile(
            fileName: item.filename ?? p.basename(path),
            bytes: await File(path).readAsBytes(),
          );
          if (uri == null) continue;
        }
        saved++;
      }
      if (!mounted) return;
      _toast(
        saved == 0
            ? context.l10n.nothingSaved
            : context.l10n.savedToDevice(saved),
      );
    } on GalException catch (error) {
      if (mounted) _toast(context.l10n.saveFailed(error.type.message));
    } catch (error) {
      if (mounted) _toast(context.l10n.saveFailed('$error'));
    }
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _openViewer(ArchiveItem item) {
    if (item.type == 'video') {
      if (item.localPath == null || !File(item.localPath!).existsSync()) {
        return;
      }
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              VideoPlayerScreen(item: item, onSave: (i) => _save([i])),
        ),
      );
      return;
    }
    // Oldest first, so swiping forward moves forward in time like the chat.
    final images = _items.reversed
        .where(
          (i) =>
              i.type == 'image' &&
              i.localPath != null &&
              File(i.localPath!).existsSync(),
        )
        .toList();
    final index = images.indexWhere((i) => i.id == item.id);
    if (index < 0) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _MediaViewer(
          items: images,
          initialIndex: index,
          onSave: (i) => _save([i]),
        ),
      ),
    );
  }

  /// Consecutive photos/videos sent together collapse into one album entry.
  List<List<ArchiveItem>> get _entries {
    final entries = <List<ArchiveItem>>[];
    for (final item in _items) {
      final last = entries.lastOrNull;
      final media = item.type == 'image' || item.type == 'video';
      if (media &&
          item.groupId != null &&
          last != null &&
          last.first.groupId == item.groupId) {
        last.add(item);
      } else {
        entries.add([item]);
      }
    }
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final entries = _entries;
    final style = ChatStyle.of(
      widget.collectionId,
      Theme.of(context).brightness,
    );
    final pinned = _items.where((item) => item.pinned).firstOrNull;
    final lightBar = style.appBar.computeLuminance() > .5;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: lightBar ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: style.background.first,
        appBar: AppBar(
          backgroundColor: style.appBar,
          foregroundColor: style.appBarForeground,
          surfaceTintColor: Colors.transparent,
          elevation: lightBar ? .5 : 0,
          shadowColor: Colors.black26,
          titleSpacing: 0,
          title: Row(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: style.avatar,
                child: Icon(style.avatarIcon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name ?? context.l10n.chat,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      context.l10n.savedInChat(_items.length),
                      style: TextStyle(
                        fontSize: 13,
                        color: style.appBarForeground.withValues(alpha: .7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(child: ChatWallpaper(style: style)),
            Column(
              children: [
                if (pinned != null) _PinnedBar(item: pinned, style: style),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _items.isEmpty
                      ? _EmptyChat(style: style)
                      : ListView.builder(
                          reverse: true,
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          itemCount: entries.length,
                          itemBuilder: (context, i) {
                            final entry = entries[i];
                            final item = entry.first;
                            final bubble = entry.length > 1
                                ? _AlbumBubble(
                                    // Shown in the order they were sent.
                                    items: entry.reversed.toList(),
                                    style: style,
                                    onTap: _openViewer,
                                    onLongPress: (tapped) =>
                                        _showActions(tapped, group: entry),
                                  )
                                : _Bubble(
                                    item: item,
                                    style: style,
                                    onTap: () => _openViewer(item),
                                    onLongPress: () => _showActions(item),
                                  );
                            final older = i + 1 < entries.length
                                ? entries[i + 1].first
                                : null;
                            if (older != null &&
                                _sameDay(older.createdAt, item.createdAt)) {
                              return bubble;
                            }
                            return Column(
                              children: [
                                _DateChip(millis: item.createdAt, style: style),
                                bubble,
                              ],
                            );
                          },
                        ),
                ),
                _Composer(
                  controller: _composer,
                  style: style,
                  onSend: _send,
                  onAttach: _attach,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static bool _sameDay(int a, int b) {
    final x = DateTime.fromMillisecondsSinceEpoch(a);
    final y = DateTime.fromMillisecondsSinceEpoch(b);
    return x.year == y.year && x.month == y.month && x.day == y.day;
  }
}

Widget _action(
  BuildContext context,
  IconData icon,
  String label,
  String value, {
  Color? color,
}) => ListTile(
  leading: Icon(icon, color: color),
  title: Text(label, style: TextStyle(color: color)),
  onTap: () => Navigator.pop(context, value),
);

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.item,
    required this.style,
    required this.onTap,
    required this.onLongPress,
  });
  final ArchiveItem item;
  final ChatStyle style;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hm().format(
      DateTime.fromMillisecondsSinceEpoch(item.createdAt),
    );
    final file = item.localPath == null ? null : File(item.localPath!);
    final isImage = item.type == 'image' && (file?.existsSync() ?? false);
    final isVideo = item.type == 'video' && (file?.existsSync() ?? false);
    final tailSpace = style.tail == TailSide.none ? 0.0 : 7.0;

    // Messenger and Instagram show times only between messages.
    final showMeta = style.outgoingGradient == null;
    final meta = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item.favorite)
          Padding(
            padding: const EdgeInsets.only(right: 3),
            child: Icon(Icons.star_rounded, size: 13, color: style.meta),
          ),
        Text(time, style: TextStyle(fontSize: 11.5, color: style.meta)),
        if (style.checks != null) ...[
          const SizedBox(width: 3),
          Icon(Icons.done_all_rounded, size: 16, color: style.checks),
        ],
      ],
    );

    final Widget content;
    if (isImage) {
      content = Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(style.radius - 3),
            child: Image.file(
              file!,
              width: 260,
              fit: BoxFit.cover,
              cacheWidth: 780,
            ),
          ),
          Positioned(
            right: 6,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                time,
                style: const TextStyle(fontSize: 11.5, color: Colors.white),
              ),
            ),
          ),
        ],
      );
    } else if (item.localPath != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isVideo) ...[
            _VideoTile(radius: style.radius - 3),
            const SizedBox(height: 6),
          ],
          _FileRow(item: item, style: style),
          if (showMeta) const SizedBox(height: 2),
          if (showMeta) meta,
        ],
      );
    } else {
      final isLink = item.type == 'link';
      final uri = isLink ? Uri.tryParse(item.body!.trim()) : null;
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.body ?? '',
            style: TextStyle(
              fontSize: 16,
              height: 1.3,
              color: isLink ? style.link : style.outgoingText,
              decoration: isLink ? TextDecoration.underline : null,
              decorationColor: style.link,
            ),
          ),
          if (uri != null && uri.host.isNotEmpty) ...[
            const SizedBox(height: 6),
            _LinkCard(host: uri.host, style: style),
          ],
          if (showMeta) meta,
        ],
      );
    }

    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * .8,
        ),
        child: GestureDetector(
          onTap: isImage || isVideo ? onTap : null,
          onLongPress: onLongPress,
          child: Container(
            margin: const EdgeInsets.only(bottom: 4, top: 2),
            padding: EdgeInsets.fromLTRB(
              isImage ? 3 : 10,
              isImage ? 3 : 7,
              (isImage ? 3 : 10) + tailSpace,
              isImage ? 3 : 5,
            ),
            decoration: ShapeDecoration(
              color: style.outgoingGradient == null ? style.outgoing : null,
              gradient: style.outgoingGradient,
              shadows: style.tail == TailSide.none
                  ? null
                  : const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
              shape: _BubbleBorder(radius: style.radius, tail: style.tail),
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

class _FileRow extends StatelessWidget {
  const _FileRow({required this.item, required this.style});
  final ArchiveItem item;
  final ChatStyle style;

  @override
  Widget build(BuildContext context) {
    final icon = switch (item.type) {
      'video' => Icons.play_arrow_rounded,
      'audio' => Icons.music_note_rounded,
      'pdf' => Icons.picture_as_pdf_rounded,
      'image' => Icons.image_rounded,
      _ => Icons.insert_drive_file_rounded,
    };
    final onColor = style.outgoingGradient != null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: onColor ? Colors.white24 : style.accent,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.filename ?? context.l10n.file,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: style.outgoingText,
                ),
              ),
              Text(
                _size(item.size),
                style: TextStyle(fontSize: 13, color: style.meta),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _size(int size) => size < 1024
      ? '‎$size B'
      : size < 1024 * 1024
      ? '‎${(size / 1024).toStringAsFixed(0)} KB'
      : '‎${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
}

class _LinkCard extends StatelessWidget {
  const _LinkCard({required this.host, required this.style});
  final String host;
  final ChatStyle style;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
    decoration: BoxDecoration(
      border: BorderDirectional(start: BorderSide(color: style.link, width: 3)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.public_rounded, size: 16, color: style.link),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            host,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: style.link,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );
}

class _DateChip extends StatelessWidget {
  const _DateChip({required this.millis, required this.style});
  final int millis;
  final ChatStyle style;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(millis);
    final now = DateTime.now();
    final label =
        date.year == now.year && date.month == now.month && date.day == now.day
        ? context.l10n.today
        : date.year == now.year
        ? DateFormat.MMMMd().format(date)
        : DateFormat.yMMMMd().format(date);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: style.dateChip,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: style.dateChipText,
          ),
        ),
      ),
    );
  }
}

class _PinnedBar extends StatelessWidget {
  const _PinnedBar({required this.item, required this.style});
  final ArchiveItem item;
  final ChatStyle style;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    return Material(
      color: surface,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
        child: Row(
          children: [
            Container(width: 2.5, height: 34, color: style.accent),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.pinnedMessage,
                    style: TextStyle(
                      color: style.accent,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                    ),
                  ),
                  Text(
                    item.body ?? item.filename ?? context.l10n.attachment,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(Icons.push_pin_outlined, size: 20, color: style.composerHint),
          ],
        ),
      ),
    );
  }
}

class _EmptyChat extends StatelessWidget {
  const _EmptyChat({required this.style});
  final ChatStyle style;

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      margin: const EdgeInsets.all(32),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.bookmark_add_outlined,
            color: Colors.white,
            size: 44,
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.emptyChatTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.emptyChatBody,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    ),
  );
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.style,
    required this.onSend,
    required this.onAttach,
  });
  final TextEditingController controller;
  final ChatStyle style;
  final VoidCallback onSend;
  final VoidCallback onAttach;

  @override
  Widget build(BuildContext context) {
    final hasText = controller.text.trim().isNotEmpty;
    final field = TextField(
      controller: controller,
      minLines: 1,
      maxLines: 6,
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(
        fontSize: 16,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: switch (style.hint) {
          'Message' => context.l10n.composerMessage,
          'Message...' => context.l10n.composerMessageEllipsis,
          final hint => hint,
        },
        hintStyle: TextStyle(color: style.composerHint, fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
    final attach = IconButton(
      onPressed: onAttach,
      icon: Transform.rotate(
        angle: style.separateSendButton ? -.6 : .6,
        child: Icon(Icons.attach_file_rounded, color: style.composerHint),
      ),
    );
    final sendIcon = Icon(
      hasText ? Icons.send_rounded : Icons.mic_none_rounded,
      color: style.separateSendButton ? Colors.white : style.accent,
    );

    final Widget bar;
    if (style.separateSendButton) {
      // WhatsApp: floating pill plus a round green button.
      bar = Padding(
        padding: const EdgeInsets.fromLTRB(6, 4, 6, 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: style.composerPill,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: style.composerHint,
                      ),
                    ),
                    Expanded(child: field),
                    attach,
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              width: 50,
              height: 50,
              child: FloatingActionButton(
                heroTag: null,
                elevation: 0,
                backgroundColor: style.accent,
                shape: const CircleBorder(),
                onPressed: hasText ? onSend : null,
                child: sendIcon,
              ),
            ),
          ],
        ),
      );
    } else if (style.hint == 'Aa') {
      // Messenger: action icons, grey pill, blue send arrow.
      bar = Padding(
        padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: onAttach,
              icon: Icon(Icons.add_circle_rounded, color: style.accent),
            ),
            IconButton(
              onPressed: onAttach,
              icon: Icon(Icons.image_rounded, color: style.accent),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: style.composerPill,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: field,
              ),
            ),
            IconButton(
              onPressed: hasText ? onSend : null,
              icon: Icon(
                hasText ? Icons.send_rounded : Icons.thumb_up_rounded,
                color: style.accent,
              ),
            ),
          ],
        ),
      );
    } else if (style.composerOutlined || style.hint == 'Message...') {
      // Instagram: rounded pill with a blue camera circle and a "Send" label.
      bar = Padding(
        padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
        child: Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 6, 0),
          decoration: BoxDecoration(
            color: style.composerPill,
            borderRadius: BorderRadius.circular(26),
            border: style.composerOutlined
                ? Border.all(color: const Color(0xffdbdbdb))
                : null,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: onAttach,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: style.accent,
                  child: const Icon(
                    Icons.photo_camera_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: field),
              if (hasText)
                TextButton(
                  onPressed: onSend,
                  child: Text(
                    context.l10n.send,
                    style: TextStyle(
                      color: style.accent,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                )
              else
                IconButton(
                  onPressed: onAttach,
                  icon: Icon(
                    Icons.image_outlined,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
            ],
          ),
        ),
      );
    } else {
      // Telegram / personal: flat full-width bar.
      bar = Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.emoji_emotions_outlined,
              color: style.composerHint,
            ),
          ),
          Expanded(child: field),
          attach,
          IconButton(onPressed: hasText ? onSend : null, icon: sendIcon),
        ],
      );
    }

    return Material(
      color: style.composerBar,
      child: SafeArea(top: false, child: bar),
    );
  }
}

/// Rounded bubble with an optional tail on the trailing side.
class _BubbleBorder extends ShapeBorder {
  const _BubbleBorder({required this.radius, required this.tail});
  final double radius;
  final TailSide tail;

  static const _tail = 7.0;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final rtl = textDirection == TextDirection.rtl;
    final body = tail == TailSide.none
        ? rect
        : Rect.fromLTRB(
            rtl ? rect.left + _tail : rect.left,
            rect.top,
            rtl ? rect.right : rect.right - _tail,
            rect.bottom,
          );
    final r = Radius.circular(radius);
    const small = Radius.zero;
    final RRect rrect = switch (tail) {
      TailSide.none => RRect.fromRectAndRadius(body, r),
      TailSide.bottom => RRect.fromRectAndCorners(
        body,
        topLeft: r,
        topRight: r,
        bottomLeft: rtl ? small : r,
        bottomRight: rtl ? r : small,
      ),
      TailSide.top => RRect.fromRectAndCorners(
        body,
        topLeft: rtl ? Radius.zero : r,
        topRight: rtl ? r : Radius.zero,
        bottomLeft: r,
        bottomRight: r,
      ),
    };
    final path = Path()..addRRect(rrect);
    final edge = rtl ? body.left : body.right;
    final out = rtl ? -_tail : _tail;
    if (tail == TailSide.bottom) {
      path.addPath(
        Path()
          ..moveTo(edge, body.bottom - 16)
          ..quadraticBezierTo(
            edge + out * .15,
            body.bottom - 3,
            edge + out,
            body.bottom,
          )
          ..lineTo(edge - out * 2, body.bottom)
          ..close(),
        Offset.zero,
      );
    } else if (tail == TailSide.top) {
      path.addPath(
        Path()
          ..moveTo(edge, body.top)
          ..lineTo(edge + out, body.top)
          ..lineTo(edge, body.top + 11)
          ..close(),
        Offset.zero,
      );
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => _BubbleBorder(radius: radius * t, tail: tail);
}

/// Several photos/videos sent together, laid out as a grid in one bubble.
class _AlbumBubble extends StatelessWidget {
  const _AlbumBubble({
    required this.items,
    required this.style,
    required this.onTap,
    required this.onLongPress,
  });
  final List<ArchiveItem> items;
  final ChatStyle style;
  final ValueChanged<ArchiveItem> onTap;
  final ValueChanged<ArchiveItem> onLongPress;

  static const _width = 270.0;
  static const _gap = 2.0;

  @override
  Widget build(BuildContext context) {
    // Rows of two; an odd count puts one wide photo on top.
    final rows = <List<ArchiveItem>>[];
    var start = 0;
    if (items.length.isOdd) {
      rows.add([items.first]);
      start = 1;
    }
    for (var i = start; i < items.length; i += 2) {
      rows.add(items.sublist(i, i + 2));
    }
    final time = DateFormat.Hm().format(
      DateTime.fromMillisecondsSinceEpoch(items.last.createdAt),
    );
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4, top: 2),
        padding: EdgeInsets.fromLTRB(
          3,
          3,
          3 + (style.tail == TailSide.none ? 0 : 7),
          3,
        ),
        decoration: ShapeDecoration(
          color: style.outgoingGradient == null ? style.outgoing : null,
          gradient: style.outgoingGradient,
          shape: _BubbleBorder(radius: style.radius, tail: style.tail),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(style.radius - 3),
          child: SizedBox(
            width: _width,
            child: Stack(
              children: [
                Column(
                  children: [
                    for (final (r, row) in rows.indexed)
                      Padding(
                        padding: EdgeInsets.only(top: r == 0 ? 0 : _gap),
                        child: Row(
                          children: [
                            for (final (c, item) in row.indexed) ...[
                              if (c > 0) const SizedBox(width: _gap),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => onTap(item),
                                  onLongPress: () => onLongPress(item),
                                  child: _Thumb(
                                    item: item,
                                    height: row.length == 1 ? 180 : 135,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
                Positioned(
                  right: 6,
                  bottom: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      style.outgoingGradient == null
                          ? time
                          : context.l10n.photosCount(items.length),
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.item, required this.height});
  final ArchiveItem item;
  final double height;

  @override
  Widget build(BuildContext context) {
    final path = item.localPath;
    if (item.type == 'image' && path != null && File(path).existsSync()) {
      return Image.file(
        File(path),
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        cacheWidth: 540,
      );
    }
    return Container(
      height: height,
      color: Colors.black87,
      alignment: Alignment.center,
      child: const CircleAvatar(
        radius: 22,
        backgroundColor: Colors.black54,
        child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30),
      ),
    );
  }
}

/// Full-screen photo viewer with pinch-zoom, swipe and save.
class _MediaViewer extends StatefulWidget {
  const _MediaViewer({
    required this.items,
    required this.initialIndex,
    required this.onSave,
  });
  final List<ArchiveItem> items;
  final int initialIndex;
  final Future<void> Function(ArchiveItem) onSave;

  @override
  State<_MediaViewer> createState() => _MediaViewerState();
}

class _MediaViewerState extends State<_MediaViewer> {
  late final _pages = PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.items[_index];
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.viewerPosition(_index + 1, widget.items.length),
              style: const TextStyle(fontSize: 17),
            ),
            Text(
              DateFormat.MMMd().add_Hm().format(
                DateTime.fromMillisecondsSinceEpoch(item.createdAt),
              ),
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: context.l10n.saveToGallery,
            onPressed: () => widget.onSave(item),
            icon: const Icon(Icons.download_rounded),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pages,
        itemCount: widget.items.length,
        onPageChanged: (i) => setState(() => _index = i),
        itemBuilder: (context, i) => InteractiveViewer(
          maxScale: 5,
          child: Center(child: Image.file(File(widget.items[i].localPath!))),
        ),
      ),
    );
  }
}

/// Video preview in a bubble: a dark 16:9 frame with a play button.
class _VideoTile extends StatelessWidget {
  const _VideoTile({required this.radius});
  final double radius;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Container(
      width: 240,
      height: 135,
      color: Colors.black87,
      alignment: Alignment.center,
      child: const CircleAvatar(
        radius: 26,
        backgroundColor: Colors.black54,
        child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
      ),
    ),
  );
}
