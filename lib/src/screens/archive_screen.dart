import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../archive/archive_item.dart';
import '../archive/archive_repository.dart';
import '../chat/chat_style.dart';
import '../l10n.dart';
import '../update/update_prompt.dart';

class ArchiveScreen extends ConsumerStatefulWidget {
  const ArchiveScreen({super.key});

  @override
  ConsumerState<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends ConsumerState<ArchiveScreen> {
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Offer a newer version from GitHub once the first screen is shown.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => promptForUpdateIfDue(context),
    );
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(archiveControllerProvider);
    final repo = ref.watch(repositoryProvider);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Memoir', style: TextStyle(fontWeight: FontWeight.w700)),
            Text(
              l10n.archiveSubtitle,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.newCollection,
            onPressed: () => _createCollection(context),
            icon: const Icon(Icons.create_new_folder_outlined),
          ),
          IconButton(
            tooltip: l10n.navDrive,
            onPressed: () => context.go('/cloud'),
            icon: const Icon(Icons.add_to_drive_outlined),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _MemoryWallpaper(
                Theme.of(context).brightness == Brightness.dark,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                  child: SearchBar(
                    controller: _search,
                    hintText: l10n.searchHint,
                    leading: const Icon(Icons.search),
                    onChanged: (text) {
                      setState(() {});
                      ref.read(archiveControllerProvider.notifier).search(text);
                    },
                    trailing: [
                      if (_search.text.isNotEmpty)
                        IconButton(
                          onPressed: () {
                            _search.clear();
                            setState(() {});
                            ref
                                .read(archiveControllerProvider.notifier)
                                .search('');
                          },
                          icon: const Icon(Icons.close),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: _search.text.trim().isEmpty
                      ? _chatList(context, repo)
                      : items.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, _) =>
                              Center(child: Text(l10n.archiveError('$e'))),
                          data: (rows) => rows.isEmpty
                              ? Center(child: Text(l10n.noMatches))
                              : ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    4,
                                    16,
                                    96,
                                  ),
                                  itemCount: rows.length,
                                  itemBuilder: (context, index) =>
                                      _itemCard(context, rows[index]),
                                ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const VaultNavigation(location: '/archive'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAdd(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.addToVault),
      ),
    );
  }

  Widget _chatList(BuildContext context, ArchiveRepository repo) =>
      FutureBuilder(
        future: Future.wait([repo.collections(), repo.summaries()]),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final collections = (data[0] as List<ArchiveCollection>)
              .where((c) => c.id != 'all')
              .toList();
          final summaries =
              data[1] as Map<String, ({ArchiveItem latest, int count})>;
          if (summaries.isEmpty && collections.isEmpty) return _empty(context);
          // Chats with the newest message come first, like a messenger.
          collections.sort(
            (a, b) => (summaries[b.id]?.latest.position ?? -1).compareTo(
              summaries[a.id]?.latest.position ?? -1,
            ),
          );
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 96),
            itemCount: collections.length,
            itemBuilder: (context, i) =>
                _chatRow(context, collections[i], summaries[collections[i].id]),
          );
        },
      );

  Widget _chatRow(
    BuildContext context,
    ArchiveCollection collection,
    ({ArchiveItem latest, int count})? summary,
  ) {
    final style = ChatStyle.of(collection.id, Theme.of(context).brightness);
    final latest = summary?.latest;
    final l10n = context.l10n;
    final name = collectionLabel(l10n, collection.id, collection.name);
    final preview = latest == null
        ? l10n.noMessagesYet
        : latest.type == 'image'
        ? l10n.photo
        : latest.localPath != null
        ? (latest.filename ?? l10n.file)
        : latest.body ?? '';
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      onTap: () async {
        await context.push('/chat/${collection.id}', extra: name);
        if (mounted) setState(() {});
      },
      leading: CircleAvatar(
        radius: 27,
        backgroundColor: style.avatar,
        child: Icon(style.avatarIcon, color: Colors.white, size: 26),
      ),
      title: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Row(
        children: [
          if (latest?.localPath != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                latest!.type == 'image'
                    ? Icons.image_outlined
                    : Icons.attach_file_rounded,
                size: 16,
                color: muted,
              ),
            ),
          Expanded(
            child: Text(
              preview,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: muted),
            ),
          ),
        ],
      ),
      trailing: latest == null
          ? null
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _listTime(latest.createdAt),
                  style: TextStyle(fontSize: 12, color: muted),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: style.avatar,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${summary!.count}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _listTime(int millis) {
    final date = DateTime.fromMillisecondsSinceEpoch(millis);
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return DateFormat.Hm().format(date);
    }
    return date.year == now.year
        ? DateFormat.MMMd().format(date)
        : DateFormat.yMd().format(date);
  }

  Widget _empty(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_add_outlined,
              size: 38,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.emptyTitle,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.emptyBody,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ),
  );

  Widget _itemCard(BuildContext context, ArchiveItem item) {
    final icon = switch (item.type) {
      'image' => Icons.image_outlined,
      'video' => Icons.video_file_outlined,
      'audio' => Icons.audio_file_outlined,
      'pdf' => Icons.picture_as_pdf_outlined,
      'link' => Icons.link,
      'text' => Icons.notes_rounded,
      _ => Icons.insert_drive_file_outlined,
    };
    final date = DateTime.fromMillisecondsSinceEpoch(item.createdAt);
    final l10n = context.l10n;
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * .91,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10, left: 38),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xff173a43)
                : const Color(0xffd9fdd3),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .04),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white.withValues(alpha: .75),
                    child: Icon(icon, size: 20, color: const Color(0xff118577)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.filename ??
                              (item.type == 'link'
                                  ? l10n.savedLink
                                  : item.type == 'text'
                                  ? l10n.savedNote
                                  : l10n.attachment),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          DateFormat.MMMd().add_Hm().format(date),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'pin')
                        ref
                            .read(archiveControllerProvider.notifier)
                            .toggle(item, 'pinned', !item.pinned);
                      if (value == 'favorite')
                        ref
                            .read(archiveControllerProvider.notifier)
                            .toggle(item, 'favorite', !item.favorite);
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'pin',
                        child: Text(item.pinned ? l10n.unpin : l10n.pin),
                      ),
                      PopupMenuItem(
                        value: 'favorite',
                        child: Text(
                          item.favorite ? l10n.removeFavorite : l10n.favorite,
                        ),
                      ),
                    ],
                    icon: const Icon(Icons.more_horiz, size: 20),
                  ),
                ],
              ),
              if (item.body != null)
                Padding(
                  padding: const EdgeInsets.only(left: 48, top: 8),
                  child: SelectableText(item.body!, maxLines: 5),
                ),
              if (item.localPath != null &&
                  item.type == 'image' &&
                  File(item.localPath!).existsSync())
                Padding(
                  padding: const EdgeInsets.only(left: 48, top: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(item.localPath!),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (item.localPath != null)
                Padding(
                  padding: const EdgeInsets.only(left: 48, top: 8),
                  child: Text(
                    '${_size(item.size)}  ·  ${l10n.savedToMemoir}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _size(int size) => size < 1024
      ? '‎$size B'
      : size < 1024 * 1024
      ? '‎${(size / 1024).toStringAsFixed(0)} KB'
      : '‎${(size / (1024 * 1024)).toStringAsFixed(1)} MB';

  Future<void> _showAdd(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            8,
            20,
            MediaQuery.viewInsetsOf(context).bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.saveSomething,
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              _AddAction(
                icon: Icons.edit_note,
                title: context.l10n.writeNote,
                onTap: () {
                  Navigator.pop(context);
                  _writeNote(context);
                },
              ),
              _AddAction(
                icon: Icons.attach_file,
                title: context.l10n.chooseFiles,
                subtitle: context.l10n.chooseFilesSubtitle,
                onTap: () {
                  Navigator.pop(context);
                  _chooseFiles(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _writeNote(BuildContext context) async {
    final controller = TextEditingController();
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.newItem),
        content: TextField(
          controller: controller,
          autofocus: true,
          minLines: 3,
          maxLines: 7,
          decoration: InputDecoration(hintText: context.l10n.newItemHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value != null)
      await ref.read(archiveControllerProvider.notifier).addText(value);
  }

  Future<void> _chooseFiles(BuildContext context) async {
    try {
      final files = await FilePicker.pickFiles(type: FileType.any);
      if (files.isEmpty) return;
      final count = await ref
          .read(archiveControllerProvider.notifier)
          .importFiles(files);
      if (mounted)
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(content: Text(this.context.l10n.filesSaved(count))),
        );
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(content: Text(this.context.l10n.importFailed('$error'))),
        );
    }
  }

  Future<void> _createCollection(BuildContext context) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.newCollection),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: context.l10n.collectionName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            child: Text(context.l10n.create),
          ),
        ],
      ),
    );
    controller.dispose();
    if (!mounted || name == null || name.trim().isEmpty) return;
    try {
      await ref.read(repositoryProvider).createCollection(name);
      setState(() {});
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            content: Text(this.context.l10n.createCollectionFailed('$error')),
          ),
        );
    }
  }
}

class _AddAction extends StatelessWidget {
  const _AddAction({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon),
    title: Text(title),
    subtitle: subtitle == null ? null : Text(subtitle!),
    onTap: onTap,
  );
}

class _MemoryWallpaper extends CustomPainter {
  const _MemoryWallpaper(this.dark);
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (dark ? const Color(0xffb8d7ce) : const Color(0xff527f72))
          .withValues(alpha: dark ? .055 : .075)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25;
    for (var row = 0; row < (size.height / 84).ceil(); row++) {
      for (var col = 0; col < (size.width / 82).ceil(); col++) {
        final x = col * 82.0 + (row.isEven ? 18 : 50);
        final y = row * 84.0 + 22;
        final shape = (row + col) % 3;
        if (shape == 0) {
          canvas.drawCircle(Offset(x, y), 8, paint);
          canvas.drawLine(Offset(x - 4, y), Offset(x + 4, y), paint);
          canvas.drawLine(Offset(x, y - 4), Offset(x, y + 4), paint);
        } else if (shape == 1) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset(x, y), width: 16, height: 12),
              const Radius.circular(4),
            ),
            paint,
          );
          canvas.drawLine(Offset(x - 4, y + 7), Offset(x - 7, y + 11), paint);
        } else {
          final path = Path()
            ..moveTo(x, y - 9)
            ..lineTo(x + 8, y)
            ..lineTo(x, y + 9)
            ..lineTo(x - 8, y)
            ..close();
          canvas.drawPath(path, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MemoryWallpaper oldDelegate) =>
      oldDelegate.dark != dark;
}
