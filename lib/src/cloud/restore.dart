import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../archive/archive_repository.dart';
import 'google_drive_provider.dart';

/// What can be brought back from the connected accounts.
class RestorePlan {
  const RestorePlan(this.items, this.copies);
  static const empty = RestorePlan([], {});

  /// Each missing item once, with an account to download it from.
  final List<(GoogleDriveProvider, RemoteBackupItem)> items;

  /// Every account's copy of each missing item: {itemId: {email: fileId}}.
  final Map<String, Map<String, String>> copies;

  int get length => items.length;
  bool get isEmpty => items.isEmpty;
}

/// Items in the connected accounts' Memoir folders that are not on this
/// phone, for example after reinstalling the app. Copies of items that are
/// on the phone are recorded too, so they are not uploaded again.
Future<RestorePlan> findRestorableItems(
  List<GoogleDriveProvider> drives,
  ArchiveRepository repository,
) async {
  final local = await repository.itemIds();
  final recorded = await repository.backupsByItem();
  final items = <String, (GoogleDriveProvider, RemoteBackupItem)>{};
  final copies = <String, Map<String, String>>{};
  for (final drive in drives) {
    final email = drive.email!;
    for (final remote in await drive.backupItems()) {
      if (local.contains(remote.itemId)) {
        if (!(recorded[remote.itemId]?.contains(email) ?? false)) {
          await repository.recordBackup(remote.itemId, email, remote.fileId);
        }
        continue;
      }
      items.putIfAbsent(remote.itemId, () => (drive, remote));
      (copies[remote.itemId] ??= {})[email] = remote.fileId;
    }
  }
  return RestorePlan(items.values.toList(), copies);
}

/// Downloads what [plan] found and puts each item back in its chat with its
/// original id, date and album, saved the same way as when first added.
Future<int> restoreItems(
  RestorePlan plan,
  ArchiveRepository repository, {
  required String fallbackCollectionName,
  void Function(int done, int total)? onProgress,
}) async {
  final items = plan.items;
  final docs = await getApplicationDocumentsDirectory();
  final attachments = Directory(p.join(docs.path, 'attachments'));
  await attachments.create(recursive: true);

  // Download in parallel, then insert oldest first so chats keep their order.
  final ready = <_Restored>[];
  var next = 0;
  var done = 0;
  onProgress?.call(0, items.length);
  Future<void> worker() async {
    while (next < items.length) {
      final (drive, item) = items[next++];
      try {
        ready.add(await _download(drive, repository, item, attachments.path));
      } on FormatException {
        // A damaged record is skipped; the rest still comes back.
      }
      onProgress?.call(++done, items.length);
    }
  }

  await Future.wait(List.generate(4, (_) => worker()));
  ready.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  for (final r in ready) {
    final collection = await repository.ensureCollection(
      r.collection,
      r.collectionName,
      fallbackCollectionName,
    );
    await repository.insertRestored(
      id: r.id,
      collection: collection,
      type: r.type,
      createdAt: r.createdAt,
      driveId: r.driveId,
      driveAccount: r.account,
      backups: plan.copies[r.id] ?? const {},
      body: r.body,
      filename: r.filename,
      mimeType: r.extension,
      localPath: r.localPath,
      size: r.size,
      groupId: r.groupId,
      favorite: r.favorite,
      pinned: r.pinned,
    );
  }
  return ready.length;
}

Future<_Restored> _download(
  GoogleDriveProvider drive,
  ArchiveRepository repository,
  RemoteBackupItem item,
  String attachmentsDir,
) async {
  final props = item.properties;
  final flags = props['mvFlags'] ?? '';
  if (item.isTextRecord) {
    // Text and links were uploaded as a JSON record of the whole item.
    final json = jsonDecode(
      utf8.decode(await drive.downloadBytes(item.fileId)),
    ) as Map<String, dynamic>;
    return _Restored(
      id: item.itemId,
      driveId: item.fileId,
      account: drive.email!,
      collection: json['collection'] as String? ?? 'personal',
      collectionName: props['mvCollectionName'],
      type: json['type'] as String? ?? 'text',
      createdAt:
          json['createdAt'] as int? ?? item.createdTime.millisecondsSinceEpoch,
      body: json['body'] as String?,
      favorite: json['favorite'] == true,
      pinned: json['pinned'] == true,
    );
  }
  // Same name as an imported file: attachments/<id>_<original name>.
  final target = p.join(
    attachmentsDir,
    '${item.itemId}_${p.basename(item.name)}',
  );
  final file = File(target);
  if (!await file.exists()) await drive.download(item.fileId, target);
  final ext = p.extension(item.name);
  return _Restored(
    id: item.itemId,
    driveId: item.fileId,
    account: drive.email!,
    collection: props['mvCollection'] ?? 'personal',
    collectionName: props['mvCollectionName'],
    type: props['mvType'] ?? repository.typeFor(item.name),
    createdAt:
        int.tryParse(props['mvCreatedAt'] ?? '') ??
        item.createdTime.millisecondsSinceEpoch,
    filename: item.name,
    extension: ext.isEmpty ? null : ext.substring(1),
    localPath: target,
    size: await file.length(),
    groupId: props['mvGroup'],
    favorite: flags.contains('f'),
    pinned: flags.contains('p'),
  );
}

class _Restored {
  const _Restored({
    required this.id,
    required this.driveId,
    required this.account,
    required this.collection,
    required this.type,
    required this.createdAt,
    this.collectionName,
    this.body,
    this.filename,
    this.extension,
    this.localPath,
    this.size = 0,
    this.groupId,
    this.favorite = false,
    this.pinned = false,
  });
  final String id;
  final String driveId;
  final String account;
  final String collection;
  final String? collectionName;
  final String type;
  final int createdAt;
  final String? body;
  final String? filename;
  final String? extension;
  final String? localPath;
  final int size;
  final String? groupId;
  final bool favorite;
  final bool pinned;
}
