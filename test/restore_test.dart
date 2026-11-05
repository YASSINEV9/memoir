import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:memory_vault/src/archive/archive_item.dart';
import 'package:memory_vault/src/cloud/google_drive_provider.dart';

void main() {
  const item = ArchiveItem(
    id: 'item-1',
    collection: 'telegram',
    type: 'image',
    createdAt: 1700000000000,
    position: 3,
    groupId: 'album-7',
    favorite: true,
  );

  test('restore details record where an item belongs', () {
    final props = GoogleDriveProvider.restoreProperties(item, 'Telegram Saved');
    expect(props['memoryVaultItemId'], 'item-1');
    expect(props['mvCollection'], 'telegram');
    expect(props['mvCollectionName'], 'Telegram Saved');
    expect(props['mvType'], 'image');
    expect(props['mvCreatedAt'], '1700000000000');
    expect(props['mvGroup'], 'album-7');
    expect(props['mvFlags'], 'f');
  });

  test('a long collection name fits the Drive property limit', () {
    final props = GoogleDriveProvider.restoreProperties(item, 'مجموعة' * 40);
    final name = props['mvCollectionName']!;
    expect(name, isNotEmpty);
    expect(
      utf8.encode('mvCollectionName').length + utf8.encode(name).length,
      lessThanOrEqualTo(124),
    );
  });

  test('items without an album or name leave those details out', () {
    const plain = ArchiveItem(
      id: 'item-2',
      collection: 'personal',
      type: 'text',
      createdAt: 1,
      position: 1,
    );
    final props = GoogleDriveProvider.restoreProperties(plain, null);
    expect(props.containsKey('mvGroup'), isFalse);
    expect(props.containsKey('mvCollectionName'), isFalse);
    expect(props['mvFlags'], '');
  });

  test('a text record is recognised by its file name', () {
    final record = RemoteBackupItem(
      fileId: 'f',
      itemId: 'item-2',
      name: 'memory-vault-item-2.json',
      mimeType: 'application/json',
      createdTime: DateTime(2026),
      properties: const {},
    );
    expect(record.isTextRecord, isTrue);
  });
}
