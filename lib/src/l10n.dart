import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';

export '../l10n/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Languages offered in Settings, each named in its own language.
const appLanguages = <String, String>{
  'en': 'English',
  'ar': 'العربية',
  'fr': 'Français',
  'es': 'Español',
  'pt': 'Português',
  'de': 'Deutsch',
  'ru': 'Русский',
  'zh': '中文',
  'ja': '日本語',
  'hi': 'हिन्दी',
  'tr': 'Türkçe',
};

const _localeKey = 'app_locale';

/// The language chosen in Settings; null follows the phone's language.
final appLocale = ValueNotifier<Locale?>(null);

Future<void> loadAppLocale() async {
  final prefs = await SharedPreferences.getInstance();
  final code = prefs.getString(_localeKey);
  appLocale.value = code == null ? null : Locale(code);
}

Future<void> setAppLocale(String? code) async {
  final prefs = await SharedPreferences.getInstance();
  if (code == null) {
    await prefs.remove(_localeKey);
  } else {
    await prefs.setString(_localeKey, code);
  }
  appLocale.value = code == null ? null : Locale(code);
}

/// Built-in collections are stored with English names; show them translated.
/// Collections the user created keep the name they typed.
String collectionLabel(AppLocalizations l10n, String id, String name) =>
    switch (id) {
      'all' => l10n.collectionAll,
      'telegram' => l10n.collectionTelegram,
      'whatsapp' => l10n.collectionWhatsapp,
      'facebook' => l10n.collectionFacebook,
      'instagram' => l10n.collectionInstagram,
      'personal' => l10n.collectionPersonal,
      _ => name,
    };
