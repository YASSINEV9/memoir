import 'package:flutter_test/flutter_test.dart';
import 'package:memory_vault/src/archive/archive_item.dart';

void main() {
  test(
    'archive records retain stable position and flags when read from SQLite',
    () {
      final item = ArchiveItem.fromMap({
        'id': 'record-2',
        'collection_id': 'personal',
        'type': 'text',
        'body': 'A saved thought',
        'filename': null,
        'mime_type': null,
        'local_path': null,
        'size': 0,
        'created_at': 1700000000000,
        'position': 42,
        'favorite': 1,
        'pinned': 0,
      });
      expect(item.position, 42);
      expect(item.body, 'A saved thought');
      expect(item.favorite, isTrue);
      expect(item.pinned, isFalse);
    },
  );

  test('collections preserve their display order', () {
    final collection = ArchiveCollection.fromMap({
      'id': 'work',
      'name': 'Work',
      'position': 7,
    });
    expect(collection.id, 'work');
    expect(collection.position, 7);
  });
}
