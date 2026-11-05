import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'google_drive_provider.dart';

/// The Google accounts Memoir backs up to. Each backup goes to every one of
/// them, so losing one account does not lose the archive.
class DriveAccounts extends ChangeNotifier {
  static const _accountsKey = 'google_drive_accounts';

  /// The single account saved by versions before 1.3.0.
  static const _legacyKey = 'google_drive_email';

  final List<GoogleDriveProvider> _accounts = [];

  List<GoogleDriveProvider> get accounts => List.unmodifiable(_accounts);
  List<GoogleDriveProvider> get connected =>
      _accounts.where((a) => a.isConnected).toList();

  /// iOS keeps one Google sign-in at a time, so it supports one account.
  static bool get supportsSeveral =>
      defaultTargetPlatform == TargetPlatform.android;

  /// Saved account emails, oldest first. Usable from the background task.
  static Future<List<String>> savedEmails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final saved = prefs.getStringList(_accountsKey);
    if (saved != null) return saved;
    final legacy = prefs.getString(_legacyKey);
    return legacy == null ? const [] : [legacy];
  }

  static Future<void> _save(List<String> emails) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_accountsKey, emails);
    await prefs.remove(_legacyKey);
  }

  /// Restores every saved account's session without showing any UI.
  Future<void> restoreAll() async {
    final emails = await savedEmails();
    _accounts.removeWhere((a) => !emails.contains(a.email));
    for (final email in emails) {
      var account = _byEmail(email);
      if (account == null) {
        account = GoogleDriveProvider(email: email);
        _accounts.add(account);
      }
      try {
        await account.restore();
      } on GoogleSignInException {
        // Shown as "reconnect needed" by the account's own state.
      }
    }
    notifyListeners();
  }

  /// Signs in with the account picked in Google's chooser. Picking an
  /// account that is already listed reconnects it.
  Future<GoogleDriveProvider> add() async {
    final fresh = GoogleDriveProvider();
    final email = await fresh.connect();
    final existing = _byEmail(email);
    if (existing != null) {
      existing.adopt(fresh);
      fresh.dispose();
    } else {
      if (!supportsSeveral) {
        for (final old in [..._accounts]) {
          await _forget(old);
        }
      }
      _accounts.add(fresh);
    }
    await _save([for (final a in _accounts) a.email!]);
    notifyListeners();
    return existing ?? fresh;
  }

  Future<void> remove(GoogleDriveProvider account) async {
    try {
      await account.disconnect();
    } finally {
      await _forget(account);
      await _save([for (final a in _accounts) a.email!]);
      notifyListeners();
    }
  }

  Future<void> _forget(GoogleDriveProvider account) async {
    _accounts.remove(account);
    account.dispose();
  }

  GoogleDriveProvider? _byEmail(String email) =>
      _accounts.where((a) => a.email == email).firstOrNull;

  @override
  void dispose() {
    for (final account in _accounts) {
      account.dispose();
    }
    super.dispose();
  }
}
