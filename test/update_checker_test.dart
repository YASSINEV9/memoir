import 'package:flutter_test/flutter_test.dart';
import 'package:memory_vault/src/update/update_checker.dart';

void main() {
  test('compares versions number by number', () {
    expect(isNewerVersion('1.3.0', '1.2.0'), isTrue);
    expect(isNewerVersion('1.10.0', '1.9.3'), isTrue);
    expect(isNewerVersion('2.0', '1.9.9'), isTrue);
    expect(isNewerVersion('1.2.0', '1.2.0'), isFalse);
    expect(isNewerVersion('1.1.0', '1.2.0'), isFalse);
    expect(isNewerVersion('1.2.0', '1.2.0+3'), isFalse);
  });

  test('picks the APK for the phone processor', () {
    expect(
      apkNameFor('3.13.7 (stable) on "android_arm64"'),
      'Memoir-arm64-release.apk',
    );
    expect(
      apkNameFor('3.13.7 (stable) on "android_arm"'),
      'Memoir-armv7-release.apk',
    );
    expect(
      apkNameFor('3.13.7 (stable) on "android_x64"'),
      'Memoir-universal-release.apk',
    );
  });
}
