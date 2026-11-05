import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'archive_database.dart';
import 'archive_item.dart';

class ArchiveRepository {
  ArchiveRepository(this._source);
  final ArchiveDatabase _source;
  static const _uuid = Uuid();

  Future<List<ArchiveItem>> list({
    String query = '',
    String collection = 'all',
  }) async {
    final db = await _source.database;
    final filter = query.trim();
    final rows = await db.query(
      'archive_items',
      where:
          [
            if (collection != 'all') 'collection_id = ?',
            if (filter.isNotEmpty)
              '(body LIKE ? OR filename LIKE ? OR mime_type LIKE ?)',
          ].join(' AND ').isEmpty
          ? null
          : [
              if (collection != 'all') 'collection_id = ?',
              if (filter.isNotEmpty)
                '(body LIKE ? OR filename LIKE ? OR mime_type LIKE ?)',
            ].join(' AND '),
      whereArgs: [
        if (collection != 'all') collection,
        if (filter.isNotEmpty) ...['%$filter%', '%$filter%', '%$filter%'],
      ],
      orderBy: 'position DESC',
    );
    return rows.map(ArchiveItem.fromMap).toList();
  }

  Future<List<ArchiveCollection>> collections() async {
    final db = await _source.database;
    return (await db.query(
      'collections',
      orderBy: 'position',
    )).map(ArchiveCollection.fromMap).toList();
  }

  /// Latest item and item count for every collection that has items.
  Future<Map<String, ({ArchiveItem latest, int count})>> summaries() async {
    final db = await _source.database;
    final rows = await db.rawQuery('''SELECT a.*, s.cnt FROM archive_items a
      JOIN (SELECT collection_id, MAX(position) AS top, COUNT(*) AS cnt
            FROM archive_items GROUP BY collection_id) s
      ON a.collection_id = s.collection_id AND a.position = s.top''');
    return {
      for (final row in rows)
        row['collection_id']! as String: (
          latest: ArchiveItem.fromMap(row),
          count: row['cnt']! as int,
        ),
    };
  }

  Future<void> delete(ArchiveItem item) async {
    final db = await _source.database;
    await db.delete('archive_items', where: 'id = ?', whereArgs: [item.id]);
    final path = item.localPath;
    if (path != null && await File(path).exists()) await File(path).delete();
  }

  Future<void> createCollection(String name) async {
    final db = await _source.database;
    final rows = await db.rawQuery(
      'SELECT COALESCE(MAX(position), -1) + 1 AS next FROM collections',
    );
    await db.insert('collections', {
      'id': _uuid.v4(),
      'name': name.trim(),
      'position': rows.first['next'],
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> addText(String text, {String collection = 'personal'}) async {
    final value = text.trim();
    if (value.isEmpty) return;
    final db = await _source.database;
    await db.transaction((txn) async {
      final rows = await txn.rawQuery(
        'SELECT COALESCE(MAX(position), -1) + 1 AS next FROM archive_items',
      );
      await txn.insert('archive_items', {
        'id': _uuid.v4(),
        'collection_id': collection,
        'type': Uri.tryParse(value)?.hasScheme == true ? 'link' : 'text',
        'body': value,
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'position': rows.first['next'],
      });
    });
  }

  Future<int> importFiles(
    List<PlatformFile> files, {
    String collection = 'personal',
  }) async {
    final docs = await getApplicationDocumentsDirectory();
    final managed = Directory(p.join(docs.path, 'attachments'));
    await managed.create(recursive: true);
    final db = await _source.database;
    // Several files picked at once are kept together as one album.
    final groupId = files.length > 1 ? _uuid.v4() : null;
    var imported = 0;
    for (final file in files) {
      if (file.path == null) continue;
      if (p.extension(file.name).toLowerCase() == '.json' &&
          await _restoreTextExport(file.path!, collection)) {
        imported++;
        continue;
      }
      final id = _uuid.v4();
      final target = p.join(managed.path, '${id}_${p.basename(file.name)}');
      await File(file.path!).copy(target);
      final size = file.lengthSync() ?? await file.length() ?? 0;
      try {
        await db.transaction((txn) async {
          final rows = await txn.rawQuery(
            'SELECT COALESCE(MAX(position), -1) + 1 AS next FROM archive_items',
          );
          await txn.insert('archive_items', {
            'id': id,
            'collection_id': collection,
            'type': _typeFor(file.name),
            'filename': file.name,
            'mime_type': file.extension,
            'local_path': target,
            'size': size,
            'group_id': groupId,
            'created_at': DateTime.now().millisecondsSinceEpoch,
            'position': rows.first['next'],
          });
        });
        imported++;
      } catch (_) {
        await File(target).delete();
        rethrow;
      }
    }
    return imported;
  }

  Future<bool> _restoreTextExport(String path, String collection) async {
    dynamic decoded;
    try {
      decoded = jsonDecode(await File(path).readAsString());
    } on FormatException {
      return false;
    }
    if (decoded is! Map<String, dynamic> || decoded['body'] is! String) {
      return false;
    }
    final db = await _source.database;
    await db.transaction((txn) async {
      final rows = await txn.rawQuery(
        'SELECT COALESCE(MAX(position), -1) + 1 AS next FROM archive_items',
      );
      await txn.insert('archive_items', {
        'id': _uuid.v4(),
        'collection_id': collection,
        'type': decoded['type'] == 'link' ? 'link' : 'text',
        'body': decoded['body'],
        'created_at': decoded['createdAt'] is int
            ? decoded['createdAt']
            : DateTime.now().millisecondsSinceEpoch,
        'position': rows.first['next'],
        'favorite': decoded['favorite'] == true ? 1 : 0,
        'pinned': decoded['pinned'] == true ? 1 : 0,
      });
    });
    return true;
  }

  String _typeFor(String name) {
    final ext = p.extension(name).toLowerCase();
    if (['.jpg', '.jpeg', '.png', '.webp', '.gif'].contains(ext))
      return 'image';
    if (['.mp4', '.mov', '.mkv', '.webm'].contains(ext)) return 'video';
    if (['.mp3', '.m4a', '.wav', '.ogg'].contains(ext)) return 'audio';
    if (ext == '.pdf') return 'pdf';
    return 'file';
  }

  Future<void> markBackedUp(
    ArchiveItem item,
    String driveId,
    String account,
  ) async {
    final db = await _source.database;
    await db.update(
      'archive_items',
      {'drive_id': driveId, 'drive_account': account},
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> setFlag(ArchiveItem item, String flag, bool value) async {
    final db = await _source.database;
    await db.update(
      'archive_items',
      {flag: value ? 1 : 0},
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }
}
