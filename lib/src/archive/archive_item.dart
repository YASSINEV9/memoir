class ArchiveItem {
  const ArchiveItem({
    required this.id,
    required this.collection,
    required this.type,
    required this.createdAt,
    required this.position,
    this.body,
    this.filename,
    this.mimeType,
    this.localPath,
    this.size = 0,
    this.favorite = false,
    this.pinned = false,
    this.groupId,
    this.driveId,
    this.driveAccount,
    this.backedUpTo = const {},
    this.deletedAt,
  });

  final String id;
  final String collection;
  final String type;
  final String? body;
  final String? filename;
  final String? mimeType;
  final String? localPath;
  final int size;
  final int createdAt;
  final int position;
  final bool favorite;
  final bool pinned;

  /// Shared by files that were sent together, shown as one album.
  final String? groupId;

  /// Google Drive file id and account email of the last successful backup.
  final String? driveId;
  final String? driveAccount;

  /// Every Google account this item is backed up to.
  final Set<String> backedUpTo;

  /// When it was moved to Recently deleted; null while it is in a chat.
  final int? deletedAt;

  factory ArchiveItem.fromMap(
    Map<String, Object?> row, {
    Set<String> backedUpTo = const {},
  }) => ArchiveItem(
    id: row['id']! as String,
    collection: row['collection_id']! as String,
    type: row['type']! as String,
    body: row['body'] as String?,
    filename: row['filename'] as String?,
    mimeType: row['mime_type'] as String?,
    localPath: row['local_path'] as String?,
    size: row['size'] as int? ?? 0,
    createdAt: row['created_at']! as int,
    position: row['position']! as int,
    favorite: (row['favorite'] as int? ?? 0) == 1,
    pinned: (row['pinned'] as int? ?? 0) == 1,
    groupId: row['group_id'] as String?,
    driveId: row['drive_id'] as String?,
    driveAccount: row['drive_account'] as String?,
    backedUpTo: backedUpTo,
    deletedAt: row['deleted_at'] as int?,
  );
}

class ArchiveCollection {
  const ArchiveCollection({
    required this.id,
    required this.name,
    required this.position,
  });
  final String id;
  final String name;
  final int position;

  factory ArchiveCollection.fromMap(Map<String, Object?> row) =>
      ArchiveCollection(
        id: row['id']! as String,
        name: row['name']! as String,
        position: row['position']! as int,
      );
}
