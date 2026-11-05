import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Where new versions are published.
const _latestReleaseUrl =
    'https://api.github.com/repos/YASSINEV9/memoir/releases/latest';
const _lastCheckKey = 'update_last_check';

/// Automatic checks happen at most this often; Settings can check any time.
const _checkInterval = Duration(days: 1);

class AppUpdate {
  const AppUpdate({required this.version, required this.downloadUrl});
  final String version;

  /// The APK built for this phone's processor, or the release page.
  final String downloadUrl;
}

/// The newer release on GitHub, or null when this is the latest version.
/// Throws when GitHub cannot be reached (only shown for a manual check).
Future<AppUpdate?> checkForUpdate({bool force = false}) async {
  // iOS builds are not published as downloads yet.
  if (defaultTargetPlatform != TargetPlatform.android) return null;
  final prefs = await SharedPreferences.getInstance();
  final now = DateTime.now().millisecondsSinceEpoch;
  if (!force &&
      now - (prefs.getInt(_lastCheckKey) ?? 0) <
          _checkInterval.inMilliseconds) {
    return null;
  }
  final response = await http
      .get(
        Uri.parse(_latestReleaseUrl),
        headers: {
          'Accept': 'application/vnd.github+json',
          'User-Agent': 'Memoir-app',
        },
      )
      .timeout(const Duration(seconds: 15));
  if (response.statusCode != 200) {
    throw HttpException('GitHub answered ${response.statusCode}');
  }
  await prefs.setInt(_lastCheckKey, now);
  final release = jsonDecode(response.body) as Map<String, dynamic>;
  final latest = (release['tag_name'] as String? ?? '').replaceFirst('v', '');
  final current = (await PackageInfo.fromPlatform()).version;
  if (!isNewerVersion(latest, current)) return null;
  final assets = {
    for (final asset in release['assets'] as List<dynamic>? ?? const [])
      (asset as Map<String, dynamic>)['name'] as String:
          asset['browser_download_url'] as String,
  };
  return AppUpdate(
    version: latest,
    downloadUrl:
        assets[apkNameFor(Platform.version)] ??
        release['html_url'] as String? ??
        'https://github.com/YASSINEV9/memoir/releases/latest',
  );
}

/// Whether [latest] (like "1.3.0") is a higher version than [current].
bool isNewerVersion(String latest, String current) {
  List<int> parts(String v) =>
      v.split('+').first.split('.').map((p) => int.tryParse(p) ?? 0).toList();
  final a = parts(latest);
  final b = parts(current);
  for (var i = 0; i < 3; i++) {
    final x = i < a.length ? a[i] : 0;
    final y = i < b.length ? b[i] : 0;
    if (x != y) return x > y;
  }
  return false;
}

/// The release APK matching this phone's processor. A phone that installed
/// a per-processor APK cannot update from the universal one (its version
/// code is lower), so the matching file is always preferred.
String apkNameFor(String dartPlatformVersion) {
  if (dartPlatformVersion.contains('android_arm64')) {
    return 'Memoir-arm64-release.apk';
  }
  if (dartPlatformVersion.contains('android_arm')) {
    return 'Memoir-armv7-release.apk';
  }
  return 'Memoir-universal-release.apk';
}
