import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import 'archive_item.dart';

class ArchiveController extends AsyncNotifier<List<ArchiveItem>> {
  String _query = '';
  String _collection = 'all';

  @override
  Future<List<ArchiveItem>> build() => ref.read(repositoryProvider).list();

  Future<void> search(String value) async {
    _query = value;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(repositoryProvider)
          .list(query: _query, collection: _collection),
    );
  }

  Future<void> selectCollection(String value) async {
    _collection = value;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(repositoryProvider)
          .list(query: _query, collection: _collection),
    );
  }

  Future<void> addText(String value) async {
    await ref.read(repositoryProvider).addText(value);
    await search(_query);
  }

  Future<int> importFiles(List<PlatformFile> files) async {
    final count = await ref.read(repositoryProvider).importFiles(files);
    await search(_query);
    return count;
  }

  Future<void> toggle(ArchiveItem item, String flag, bool value) async {
    await ref.read(repositoryProvider).setFlag(item, flag, value);
    await search(_query);
  }
}
