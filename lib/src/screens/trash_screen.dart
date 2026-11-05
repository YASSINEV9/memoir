import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../main.dart';
import '../archive/archive_item.dart';
import '../l10n.dart';

/// Recently deleted: items are kept here for 30 days before they are removed
/// from the phone for good.
class TrashScreen extends ConsumerStatefulWidget {
  const TrashScreen({super.key});

  @override
  ConsumerState<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends ConsumerState<TrashScreen> {
  List<ArchiveItem>? _items;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final items = await ref.read(repositoryProvider).trash();
    if (mounted) setState(() => _items = items);
  }

  Future<void> _changed() async {
    ref.invalidate(archiveControllerProvider);
    await _reload();
  }

  Future<void> _restore(ArchiveItem item) async {
    await ref.read(repositoryProvider).restoreFromTrash(item);
    await _changed();
  }

  Future<bool> _confirm(String title) async {
    final l10n = context.l10n;
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(l10n.emptyTrashBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.deleteForever),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _deleteForever(ArchiveItem item) async {
    if (!await _confirm(context.l10n.deleteForever)) return;
    await ref.read(repositoryProvider).delete(item);
    await _changed();
  }

  Future<void> _emptyTrash() async {
    if (!await _confirm(context.l10n.emptyTrashTitle)) return;
    final repo = ref.read(repositoryProvider);
    for (final item in _items ?? const <ArchiveItem>[]) {
      await repo.delete(item);
    }
    await _changed();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = _items;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.recentlyDeleted),
        actions: [
          if (items != null && items.isNotEmpty)
            TextButton(onPressed: _emptyTrash, child: Text(l10n.emptyTrash)),
        ],
      ),
      body: items == null
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    size: 56,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 12),
                  Text(l10n.trashEmpty),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    l10n.recentlyDeletedSubtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                for (final item in items)
                  Card(
                    child: ListTile(
                      leading: _Preview(item: item),
                      title: Text(
                        item.body ?? item.filename ?? l10n.attachment,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        l10n.deletedOn(
                          DateFormat.yMMMd().format(
                            DateTime.fromMillisecondsSinceEpoch(
                              item.deletedAt ?? item.createdAt,
                            ),
                          ),
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) => value == 'restore'
                            ? _restore(item)
                            : _deleteForever(item),
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: 'restore',
                            child: ListTile(
                              leading: const Icon(Icons.restore_rounded),
                              title: Text(l10n.restore),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: ListTile(
                              leading: Icon(
                                Icons.delete_forever_outlined,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              title: Text(
                                l10n.deleteForever,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.item});
  final ArchiveItem item;

  @override
  Widget build(BuildContext context) {
    final path = item.localPath;
    if (item.type == 'image' && path != null && File(path).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(path),
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          cacheWidth: 144,
        ),
      );
    }
    return CircleAvatar(
      child: Icon(switch (item.type) {
        'video' => Icons.videocam_outlined,
        'audio' => Icons.audio_file_outlined,
        'pdf' => Icons.picture_as_pdf_outlined,
        'link' => Icons.link,
        'text' => Icons.notes_rounded,
        _ => Icons.insert_drive_file_outlined,
      }),
    );
  }
}
