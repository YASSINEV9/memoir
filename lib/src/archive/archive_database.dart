import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ArchiveDatabase {
  ArchiveDatabase._();
  static final instance = ArchiveDatabase._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final directory = await getApplicationDocumentsDirectory();
    _database = await openDatabase(
      p.join(directory.path, 'memory_vault.db'),
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE collections (
          id TEXT PRIMARY KEY, name TEXT NOT NULL UNIQUE, position INTEGER NOT NULL,
          created_at INTEGER NOT NULL)''');
        await db.execute('''CREATE TABLE archive_items (
          id TEXT PRIMARY KEY, collection_id TEXT NOT NULL, type TEXT NOT NULL,
          body TEXT, filename TEXT, mime_type TEXT, local_path TEXT,
          size INTEGER NOT NULL DEFAULT 0, created_at INTEGER NOT NULL,
          position INTEGER NOT NULL UNIQUE, favorite INTEGER NOT NULL DEFAULT 0,
          pinned INTEGER NOT NULL DEFAULT 0, group_id TEXT, drive_id TEXT,
          drive_account TEXT,
          FOREIGN KEY(collection_id) REFERENCES collections(id))''');
        await db.execute(
          'CREATE INDEX archive_created_idx ON archive_items(created_at, position)',
        );
        await db.execute(
          'CREATE INDEX archive_collection_idx ON archive_items(collection_id, position)',
        );
        final now = DateTime.now().millisecondsSinceEpoch;
        const defaults = [
          ('all', 'All Items'),
          ('telegram', 'Telegram Saved'),
          ('whatsapp', 'WhatsApp Archive'),
          ('facebook', 'Facebook Archive'),
          ('instagram', 'Instagram Archive'),
          ('personal', 'Personal Archive'),
        ];
        final batch = db.batch();
        for (var i = 0; i < defaults.length; i++) {
          final item = defaults[i];
          batch.insert('collections', {
            'id': item.$1,
            'name': item.$2,
            'position': i,
            'created_at': now,
          });
        }
        await batch.commit(noResult: true);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // group_id ties files sent together into one album; drive_id and
          // drive_account record what is already backed up, and where.
          await db.execute(
            'ALTER TABLE archive_items ADD COLUMN group_id TEXT',
          );
          await db.execute(
            'ALTER TABLE archive_items ADD COLUMN drive_id TEXT',
          );
          await db.execute(
            'ALTER TABLE archive_items ADD COLUMN drive_account TEXT',
          );
        }
      },
      onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
    );
    return _database!;
  }
}
