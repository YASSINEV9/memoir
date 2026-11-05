import '../archive/archive_item.dart';

enum SyncState { pending, syncing, synced, failed, disconnected }

class RemoteArchiveFile {
  const RemoteArchiveFile({
    required this.id,
    required this.name,
    required this.size,
    required this.modifiedAt,
    this.category = 'Files',
  });
  final String id;
  final String name;
  final int size;
  final DateTime modifiedAt;
  final String category;
}

/// Provider boundary. A provider must only report connected or synced after the
/// remote account or operation has been verified successfully.
abstract interface class CloudStorageProvider {
  String get id;
  String get displayName;
  Future<String> connect();
  Future<void> disconnect();
  Future<List<RemoteArchiveFile>> list();
  Future<String> upload(ArchiveItem item, {required String localFilePath});
  Future<void> download(String remoteId, String destinationPath);
  Future<void> delete(String remoteId);
  Future<int?> availableBytes();
}
