import 'package:flutter_test/flutter_test.dart';
import 'package:memory_vault/src/archive/archive_item.dart';
import 'package:memory_vault/src/cloud/auto_backup.dart';

ArchiveItem _item(String id, {String? driveId, String? driveAccount}) =>
    ArchiveItem(
      id: id,
      collection: 'personal',
      type: 'text',
      createdAt: 0,
      position: 0,
      driveId: driveId,
      driveAccount: driveAccount,
      backedUpTo: {?driveAccount},
    );

void main() {
  group('nextBackupTime', () {
    test('uses today when the time is still ahead', () {
      expect(
        nextBackupTime(20, 30, DateTime(2026, 11, 5, 8)),
        DateTime(2026, 11, 5, 20, 30),
      );
    });

    test('uses tomorrow when the time has passed or is now', () {
      expect(
        nextBackupTime(8, 0, DateTime(2026, 11, 5, 8)),
        DateTime(2026, 11, 6, 8),
      );
    });

    test('rolls over the end of a month', () {
      expect(
        nextBackupTime(2, 0, DateTime(2026, 11, 30, 23)),
        DateTime(2026, 12, 1, 2),
      );
    });
  });

  group('pendingBackupItems', () {
    test('an item backed up to one account is still due for another', () {
      const item = ArchiveItem(
        id: 'both',
        collection: 'personal',
        type: 'text',
        createdAt: 0,
        position: 0,
        backedUpTo: {'a@example.com'},
      );
      expect(pendingBackupItems([item], 'a@example.com'), isEmpty);
      expect(pendingBackupItems([item], 'b@example.com'), [item]);
    });

    test('skips items already backed up to this account', () {
      final items = [
        _item('new'),
        _item('done', driveId: 'd1', driveAccount: 'a@example.com'),
        _item('other', driveId: 'd2', driveAccount: 'b@example.com'),
      ];
      expect(
        pendingBackupItems(items, 'a@example.com').map((item) => item.id),
        ['new', 'other'],
      );
    });
  });
}
