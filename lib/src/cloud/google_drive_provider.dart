import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:http/http.dart' as http;

import '../archive/archive_item.dart';
import 'cloud_storage_provider.dart';

/// The Google session expired or Drive access was removed, so the user has to
/// reconnect. Nothing else can recover from this without showing a prompt.
class DriveReconnectRequired implements Exception {
  const DriveReconnectRequired();

  @override
  String toString() =>
      'Your Google session expired or Drive access was removed. '
      'Reconnect to continue backing up.';
}

/// True when Google could not be reached, as opposed to refusing the account.
/// Android reports a network problem as Google Play status code 7.
bool isGoogleNetworkFailure(GoogleSignInException error) => RegExp(
  r'(^|: )7:|network',
  caseSensitive: false,
).hasMatch(error.description ?? '');

/// A Memoir item found in Drive, with what is needed to restore it.
class RemoteBackupItem {
  const RemoteBackupItem({
    required this.fileId,
    required this.itemId,
    required this.name,
    required this.mimeType,
    required this.createdTime,
    required this.properties,
  });
  final String fileId;
  final String itemId;
  final String name;
  final String mimeType;
  final DateTime createdTime;

  /// Drive appProperties; see [GoogleDriveProvider.restoreProperties].
  final Map<String, String> properties;

  /// Text items are uploaded as `memory-vault-<id>.json`.
  bool get isTextRecord =>
      mimeType == 'application/json' && name == 'memory-vault-$itemId.json';
}

/// Google Drive connector for one Google account; see DriveAccounts for the
/// list of connected accounts. The Web OAuth client ID is a public identifier
/// and is used as serverClientId for Android's native Google Sign-In flow.
class GoogleDriveProvider implements CloudStorageProvider {
  GoogleDriveProvider({http.Client? client, this._email})
    : _client = client ?? http.Client();

  static const _webClientId =
      '524434598677-0nfatv4f6o9r0srcm65i25d9snmic46v.apps.googleusercontent.com';
  static const _driveScope = 'https://www.googleapis.com/auth/drive.file';
  static const _scopes = <String>[_driveScope];
  static const _baseUrl = 'https://www.googleapis.com/drive/v3';
  static const _uploadUrl = 'https://www.googleapis.com/upload/drive/v3';

  /// GoogleSignIn may only be initialized once per isolate.
  static Future<void>? _initializing;

  final http.Client _client;
  final GoogleSignIn _signIn = GoogleSignIn.instance;
  GoogleSignInAccount? _account;
  String? _email;
  bool _needsReconnect = false;
  String? _rootFolderId;
  final Map<String, String> _categoryFolders = {};

  /// Backed-up item ids whose Drive file lacks the restore details, filled
  /// by [backedUpItems] so a backup can add them.
  final Set<String> missingRestoreInfo = {};
  Future<void>? _folders;
  String? _token;
  DateTime _tokenExpiry = DateTime.fromMillisecondsSinceEpoch(0);

  /// Files at or below this size go up in one multipart request instead of a
  /// two-step resumable session.
  static const _multipartLimit = 5 * 1024 * 1024;

  static const _categories = <String, String>{
    'image': 'Photos',
    'video': 'Videos',
    'text': 'Text',
    'pdf': 'Documents',
    'document': 'Documents',
    'audio': 'Audio',
    'other': 'Files',
  };

  @override
  String get id => 'google_drive';

  @override
  String get displayName => 'Google Drive';

  String? get email => _email;

  bool get isConnected => _email != null && !_needsReconnect;

  /// True when an account was connected but its session or Drive access is
  /// gone. The UI asks the user to reconnect only in this state.
  bool get needsReconnect => _email != null && _needsReconnect;

  Future<void> initialize() {
    return _initializing ??= _signIn.initialize(serverClientId: _webClientId);
  }

  /// Restores this account's session without showing any UI. On Android this
  /// must not use attemptLightweightAuthentication: that falls back to an
  /// account bottom sheet and needs an Activity, so it fails in background
  /// backups.
  Future<bool> restore() async {
    await initialize();
    _needsReconnect = false;
    if (_email == null) return false;
    try {
      final token = await _silentToken();
      if (token == null) {
        _needsReconnect = true;
        return false;
      }
      _rememberToken(token);
    } on GoogleSignInException catch (error) {
      // While offline nothing can be checked, and that does not mean access
      // was removed, so the session stays. Anything else means it is gone,
      // for example when the account was removed from the phone.
      if (!isGoogleNetworkFailure(error)) {
        _needsReconnect = true;
        return false;
      }
    }
    return true;
  }

  /// A token for the saved account, or null if getting one needs a prompt.
  Future<String?> _silentToken() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final tokens = await GoogleSignInPlatform.instance
          .clientAuthorizationTokensForScopes(
            ClientAuthorizationTokensForScopesParameters(
              request: AuthorizationRequestDetails(
                scopes: _scopes,
                userId: null,
                email: _email,
                promptIfUnauthorized: false,
              ),
            ),
          );
      return tokens?.accessToken;
    }
    // iOS restores its previous sign-in silently and needs the account object.
    final account = _account ??= await _signIn
        .attemptLightweightAuthentication();
    final authorization = await account?.authorizationClient
        .authorizationForScopes(_scopes);
    return authorization?.accessToken;
  }

  void _rememberToken(String token) {
    // Google access tokens last an hour; reuse one instead of asking the
    // platform before every request.
    _token = token;
    _tokenExpiry = DateTime.now().add(const Duration(minutes: 45));
  }

  /// Signs in with whichever account the user picks in Google's chooser.
  @override
  Future<String> connect() async {
    await initialize();
    if (!_signIn.supportsAuthenticate()) {
      throw StateError('Google Sign-In is unavailable on this device.');
    }
    final user = await _signIn.authenticate();
    final authorization = await user.authorizationClient.authorizeScopes(
      _scopes,
    );
    if (_email != user.email) _clearDriveCache();
    _account = user;
    _email = user.email;
    _needsReconnect = false;
    _rememberToken(authorization.accessToken);
    await _ensureFolderStructure();
    return user.email;
  }

  /// Takes over the session of [other], which just signed in to this
  /// provider's account again (a reconnect).
  void adopt(GoogleDriveProvider other) {
    _account = other._account;
    _needsReconnect = false;
    _token = other._token;
    _tokenExpiry = other._tokenExpiry;
  }

  /// Revokes Drive access for this account only. GoogleSignIn's own
  /// disconnect would revoke every connected account at once.
  @override
  Future<void> disconnect() async {
    await initialize();
    try {
      final token = _token ?? await _silentToken();
      if (token != null) {
        await _client.post(
          Uri.parse('https://oauth2.googleapis.com/revoke'),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {'token': token},
        );
        await _signIn.authorizationClient.clearAuthorizationToken(
          accessToken: token,
        );
      }
    } finally {
      // Always forget the account here, even if revoking failed while offline.
      _account = null;
      _needsReconnect = false;
      _clearDriveCache();
    }
  }

  void _clearDriveCache() {
    _rootFolderId = null;
    _categoryFolders.clear();
    _folders = null;
    _token = null;
  }

  Future<String> _accessToken() async {
    if (_email == null) throw StateError('Connect a Google account first.');
    if (_token != null && DateTime.now().isBefore(_tokenExpiry)) {
      return _token!;
    }
    final String? token;
    try {
      token = await _silentToken();
    } on GoogleSignInException catch (error) {
      if (isGoogleNetworkFailure(error)) rethrow;
      throw _reconnectRequired();
    }
    if (token == null) throw _reconnectRequired();
    _rememberToken(token);
    return token;
  }

  DriveReconnectRequired _reconnectRequired() {
    _needsReconnect = true;
    _token = null;
    return const DriveReconnectRequired();
  }

  Future<http.Response> _authorizedRequest(
    Future<http.Response> Function(String token) request,
  ) async {
    final token = await _accessToken();
    var response = await request(token);
    if (response.statusCode == 401) {
      // The cached token may be stale, so ask for a fresh one once.
      _token = null;
      await _signIn.authorizationClient.clearAuthorizationToken(
        accessToken: token,
      );
      response = await request(await _accessToken());
      if (response.statusCode == 401) throw _reconnectRequired();
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final details = _errorMessage(response.body);
      if (response.statusCode == 403 &&
          response.body.contains('insufficient')) {
        throw _reconnectRequired();
      }
      if (response.statusCode == 403) {
        throw StateError('Google Drive denied the request ($details).');
      }
      throw HttpException(
        'Google Drive request failed (${response.statusCode}): $details',
      );
    }
    return response;
  }

  String _errorMessage(String body) {
    try {
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final error = decoded['error'];
      if (error is Map<String, dynamic>) {
        return (error['message'] as String?) ?? body;
      }
    } catch (_) {
      // Use the original response when it is not a JSON error payload.
    }
    return body.isEmpty ? 'Unknown error' : body;
  }

  Future<String> _findOrCreateFolder(String name, String parentId) async {
    final response = await _authorizedRequest(
      (token) => _client.get(
        Uri.parse('$_baseUrl/files').replace(
          queryParameters: {
            'q':
                "name = '${name.replaceAll("'", "\\'")}' and mimeType = 'application/vnd.google-apps.folder' and '$parentId' in parents and trashed = false",
            'pageSize': '1',
            'fields': 'files(id,name)',
          },
        ),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    final files =
        (jsonDecode(response.body) as Map<String, dynamic>)['files']
            as List<dynamic>? ??
        const [];
    if (files.isNotEmpty)
      return (files.first as Map<String, dynamic>)['id'] as String;
    final created = await _authorizedRequest(
      (token) => _client.post(
        Uri.parse('$_baseUrl/files?fields=id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'name': name,
          'mimeType': 'application/vnd.google-apps.folder',
          'parents': [parentId],
        }),
      ),
    );
    return (jsonDecode(created.body) as Map<String, dynamic>)['id'] as String;
  }

  Future<void> _ensureFolderStructure() {
    return _folders ??=
        () async {
          _rootFolderId ??= await _findOrCreateFolder('Memoir', 'root');
          await Future.wait(
            _categories.values.toSet().map((category) async {
              _categoryFolders[category] ??= await _findOrCreateFolder(
                category,
                _rootFolderId!,
              );
            }),
          );
        }().catchError((Object error) {
          _folders = null;
          throw error;
        });
  }

  /// Every Memoir item in Drive. One listing per folder replaces a lookup
  /// request for every uploaded item.
  Future<List<RemoteBackupItem>> backupItems() async {
    await _ensureFolderStructure();
    final found = <RemoteBackupItem>[];
    await Future.wait(
      _categoryFolders.values.map((folder) async {
        String? page;
        do {
          final response = await _authorizedRequest(
            (token) => _client.get(
              Uri.parse('$_baseUrl/files').replace(
                queryParameters: {
                  'q': "'$folder' in parents and trashed = false",
                  'pageSize': '1000',
                  'fields': 'nextPageToken,files(id,name,mimeType,createdTime,appProperties)',
                  'pageToken': ?page,
                },
              ),
              headers: {'Authorization': 'Bearer $token'},
            ),
          );
          final decoded = jsonDecode(response.body) as Map<String, dynamic>;
          for (final value in decoded['files'] as List<dynamic>? ?? const []) {
            final file = value as Map<String, dynamic>;
            final properties = {
              for (final MapEntry(:key, :value)
                  in ((file['appProperties'] as Map<String, dynamic>?) ??
                          const {})
                      .entries)
                key: '$value',
            };
            final itemId = properties['memoryVaultItemId'];
            if (itemId == null) continue;
            found.add(
              RemoteBackupItem(
                fileId: file['id'] as String,
                itemId: itemId,
                name: file['name'] as String? ?? itemId,
                mimeType: file['mimeType'] as String? ?? '',
                createdTime:
                    DateTime.tryParse(file['createdTime'] as String? ?? '') ??
                    DateTime.now(),
                properties: properties,
              ),
            );
          }
          page = decoded['nextPageToken'] as String?;
        } while (page != null);
      }),
    );
    return found;
  }

  /// Memoir item ids already in Drive, mapped to their Drive file ids.
  Future<Map<String, String>> backedUpItems() async {
    final items = await backupItems();
    missingRestoreInfo
      ..clear()
      ..addAll(
        items
            .where((item) => !item.properties.containsKey('mvCreatedAt'))
            .map((item) => item.itemId),
      );
    return {for (final item in items) item.itemId: item.fileId};
  }

  /// Hidden details stored with each file so a restore can put it back in
  /// its chat, album and date. Contents, names and folders are unchanged.
  static Map<String, String> restoreProperties(
    ArchiveItem item,
    String? collectionName,
  ) => {
    'memoryVaultItemId': item.id,
    'mvCollection': item.collection,
    'mvCollectionName': ?_fitProperty('mvCollectionName', collectionName),
    'mvType': item.type,
    'mvCreatedAt': '${item.createdAt}',
    'mvGroup': ?item.groupId,
    'mvFlags': '${item.favorite ? 'f' : ''}${item.pinned ? 'p' : ''}',
  };

  /// Drive limits a property's key plus value to 124 bytes.
  static String? _fitProperty(String key, String? value) {
    if (value == null) return null;
    var fitted = value;
    while (utf8.encode(key).length + utf8.encode(fitted).length > 124) {
      fitted = fitted.substring(0, fitted.length - 1);
    }
    return fitted;
  }

  /// Adds the restore details (and a playable media type) to a file that
  /// was uploaded before they existed. Only metadata changes.
  Future<void> updateRestoreInfo(
    String fileId,
    ArchiveItem item,
    String? collectionName,
  ) async {
    await _authorizedRequest(
      (token) => _client.patch(
        Uri.parse('$_baseUrl/files/${Uri.encodeComponent(fileId)}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'appProperties': restoreProperties(item, collectionName),
          if (item.localPath != null) 'mimeType': _mimeTypeFor(item),
        }),
      ),
    );
    missingRestoreInfo.remove(item.id);
  }

  Future<Uint8List> downloadBytes(String remoteId) async {
    final response = await _authorizedRequest(
      (token) => _client.get(
        Uri.parse('$_baseUrl/files/${Uri.encodeComponent(remoteId)}')
            .replace(queryParameters: {'alt': 'media'}),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    return response.bodyBytes;
  }

  /// The archive stores a file's extension; Drive needs a media type to
  /// preview and play it.
  static String _mimeTypeFor(ArchiveItem item) {
    final stored = item.mimeType ?? '';
    if (stored.contains('/')) return stored;
    final ext = (stored.isNotEmpty ? stored : (item.filename ?? ''))
        .split('.')
        .last
        .toLowerCase();
    return switch (ext) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      'heic' => 'image/heic',
      'mp4' || 'm4v' => 'video/mp4',
      'mov' => 'video/quicktime',
      'mkv' => 'video/x-matroska',
      'webm' => 'video/webm',
      '3gp' => 'video/3gpp',
      'mp3' => 'audio/mpeg',
      'm4a' => 'audio/mp4',
      'wav' => 'audio/wav',
      'ogg' => 'audio/ogg',
      'pdf' => 'application/pdf',
      _ => 'application/octet-stream',
    };
  }

  @override
  Future<List<RemoteArchiveFile>> list() async {
    await _ensureFolderStructure();
    final results = <RemoteArchiveFile>[];
    await Future.wait(
      _categoryFolders.entries.map((entry) async {
        final response = await _authorizedRequest(
          (token) => _client.get(
            Uri.parse('$_baseUrl/files').replace(
              queryParameters: {
                'spaces': 'drive',
                'pageSize': '100',
                'orderBy': 'modifiedTime desc',
                'q': "'${entry.value}' in parents and trashed = false",
                'fields': 'files(id,name,size,modifiedTime),nextPageToken',
              },
            ),
            headers: {'Authorization': 'Bearer $token'},
          ),
        );
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final files = decoded['files'] as List<dynamic>? ?? const [];
        results.addAll(
          files.map((value) {
            final file = value as Map<String, dynamic>;
            return RemoteArchiveFile(
              id: file['id'] as String,
              name: file['name'] as String? ?? 'Untitled file',
              size: int.tryParse(file['size']?.toString() ?? '') ?? 0,
              modifiedAt:
                  DateTime.tryParse(file['modifiedTime'] as String? ?? '') ??
                  DateTime.fromMillisecondsSinceEpoch(0),
              category: entry.key,
            );
          }),
        );
      }),
    );
    results.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
    return results;
  }

  @override
  Future<String> upload(ArchiveItem item, {required String localFilePath}) =>
      uploadItem(item, localFilePath: localFilePath);

  /// Uploads [item]. When [known] (from [backedUpItems]) is given, it decides
  /// whether to update or create without an extra lookup request.
  Future<String> uploadItem(
    ArchiveItem item, {
    required String localFilePath,
    Map<String, String>? known,
    String? collectionName,
  }) async {
    await _ensureFolderStructure();
    final hasLocalFile = localFilePath.isNotEmpty;
    if (hasLocalFile && !await File(localFilePath).exists()) {
      throw FileSystemException(
        'Archive attachment was not found.',
        localFilePath,
      );
    }
    final bytes = hasLocalFile
        ? await File(localFilePath).readAsBytes()
        : utf8.encode(
            jsonEncode({
              'id': item.id,
              'collection': item.collection,
              'type': item.type,
              'body': item.body,
              'createdAt': item.createdAt,
              'favorite': item.favorite,
              'pinned': item.pinned,
            }),
          );
    final name = hasLocalFile
        ? (item.filename ?? File(localFilePath).uri.pathSegments.last)
        : 'memory-vault-${item.id}.json';
    final mimeType = hasLocalFile ? _mimeTypeFor(item) : 'application/json';
    final metadata = jsonEncode({
      'name': name,
      'mimeType': mimeType,
      'description': 'Memoir archive item ${item.id}',
      'parents': [
        _categoryFolders[_categoryFor(item)] ?? _rootFolderId ?? 'root',
      ],
      'appProperties': restoreProperties(item, collectionName),
    });

    String? existingId = known?[item.id];
    if (known == null) {
      final existingResponse = await _authorizedRequest(
        (token) => _client.get(
          Uri.parse('$_baseUrl/files').replace(
            queryParameters: {
              'q':
                  "appProperties has { key='memoryVaultItemId' and value='${item.id}' } and trashed = false",
              'pageSize': '1',
              'fields': 'files(id)',
            },
          ),
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      final existing =
          (jsonDecode(existingResponse.body) as Map<String, dynamic>)['files']
              as List<dynamic>? ??
          const [];
      if (existing.isNotEmpty) {
        existingId = (existing.first as Map<String, dynamic>)['id'] as String;
      }
    }
    if (existingId case final fileId?) {
      await _authorizedRequest(
        (token) => _client.patch(
          Uri.parse('$_uploadUrl/files/${Uri.encodeComponent(fileId)}')
              .replace(queryParameters: {'uploadType': 'media'}),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': mimeType,
            'Content-Length': '${bytes.length}',
          },
          body: bytes,
        ),
      );
      return fileId;
    }

    if (bytes.length <= _multipartLimit) {
      const boundary = 'memoir-upload-boundary';
      final body = <int>[
        ...utf8.encode(
          '--$boundary\r\n'
          'Content-Type: application/json; charset=UTF-8\r\n\r\n'
          '$metadata\r\n'
          '--$boundary\r\n'
          'Content-Type: $mimeType\r\n\r\n',
        ),
        ...bytes,
        ...utf8.encode('\r\n--$boundary--'),
      ];
      final result = await _authorizedRequest(
        (token) => _client.post(
          Uri.parse('$_uploadUrl/files?uploadType=multipart&fields=id'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/related; boundary=$boundary',
          },
          body: body,
        ),
      );
      return (jsonDecode(result.body) as Map<String, dynamic>)['id'] as String;
    }

    final session = await _authorizedRequest(
      (token) => _client.post(
        Uri.parse('$_uploadUrl/files?uploadType=resumable&fields=id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
          'X-Upload-Content-Type': mimeType,
          'X-Upload-Content-Length': '${bytes.length}',
        },
        body: metadata,
      ),
    );
    final uploadUri = session.headers['location'];
    if (uploadUri == null) {
      throw const HttpException('Google Drive did not return an upload URL.');
    }

    final result = await _authorizedRequest(
      (token) => _client.put(
        Uri.parse(uploadUri),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': mimeType,
          'Content-Length': '${bytes.length}',
        },
        body: bytes,
      ),
    );
    return (jsonDecode(result.body) as Map<String, dynamic>)['id'] as String;
  }

  String _categoryFor(ArchiveItem item) {
    if (_categories.containsKey(item.type)) return _categories[item.type]!;
    final mime = item.mimeType ?? '';
    final extension = (item.filename ?? '').split('.').last.toLowerCase();
    if (mime.startsWith('image/')) return 'Photos';
    if (mime.startsWith('video/')) return 'Videos';
    if (mime.startsWith('text/')) return 'Text';
    if (mime.contains('pdf') ||
        mime.contains('document') ||
        mime.contains('word') ||
        const {
          'doc',
          'docx',
          'odt',
          'rtf',
          'xls',
          'xlsx',
          'ppt',
          'pptx',
        }.contains(extension))
      return 'Documents';
    return 'Files';
  }

  @override
  Future<void> download(String remoteId, String destinationPath) async {
    final response = await _authorizedRequest(
      (token) => _client.get(
        Uri.parse('$_baseUrl/files/${Uri.encodeComponent(remoteId)}')
            .replace(queryParameters: {'alt': 'media'}),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    await File(destinationPath).parent.create(recursive: true);
    await File(destinationPath).writeAsBytes(response.bodyBytes, flush: true);
  }

  @override
  Future<void> delete(String remoteId) async {
    await _authorizedRequest(
      (token) => _client.delete(
        Uri.parse('$_baseUrl/files/${Uri.encodeComponent(remoteId)}'),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  @override
  Future<int?> availableBytes() async => null;

  void dispose() => _client.close();
}
