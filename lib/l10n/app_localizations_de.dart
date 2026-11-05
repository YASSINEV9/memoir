// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get navMemories => 'Erinnerungen';

  @override
  String get navDrive => 'Google Drive';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get archiveSubtitle => 'Deine gespeicherten Momente';

  @override
  String get newCollection => 'Neue Sammlung';

  @override
  String get searchHint => 'Archiv durchsuchen';

  @override
  String archiveError(String error) {
    return 'Archiv konnte nicht geöffnet werden: $error';
  }

  @override
  String get noMatches => 'Keine Treffer';

  @override
  String get addToVault => 'Hinzufügen';

  @override
  String get noMessagesYet => 'Noch keine Nachrichten';

  @override
  String get photo => 'Foto';

  @override
  String get file => 'Datei';

  @override
  String get video => 'Video';

  @override
  String get emptyTitle => 'Hier beginnt dein Archiv';

  @override
  String get emptyBody =>
      'Speichere eine Notiz, einen Link, ein Foto oder eine beliebige Datei. Deine Einträge bleiben auf diesem Gerät.';

  @override
  String get savedLink => 'Gespeicherter Link';

  @override
  String get savedNote => 'Gespeicherte Notiz';

  @override
  String get attachment => 'Anhang';

  @override
  String get pin => 'Anheften';

  @override
  String get unpin => 'Lösen';

  @override
  String get favorite => 'Favorit';

  @override
  String get removeFavorite => 'Aus Favoriten entfernen';

  @override
  String get savedToMemoir => 'In Memoir gespeichert';

  @override
  String get saveSomething => 'Etwas speichern';

  @override
  String get writeNote => 'Notiz schreiben oder Text einfügen';

  @override
  String get chooseFiles => 'Dateien auswählen';

  @override
  String get chooseFilesSubtitle => 'Fotos, Videos, PDFs und mehr';

  @override
  String get newItem => 'Neuer Eintrag';

  @override
  String get newItemHint => 'Text oder Link schreiben oder einfügen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get create => 'Erstellen';

  @override
  String get collectionName => 'Name der Sammlung';

  @override
  String filesSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dateien auf diesem Gerät gespeichert',
      one: '1 Datei auf diesem Gerät gespeichert',
    );
    return '$_temp0';
  }

  @override
  String importFailed(String error) {
    return 'Dateien konnten nicht importiert werden: $error';
  }

  @override
  String createCollectionFailed(String error) {
    return 'Sammlung konnte nicht erstellt werden: $error';
  }

  @override
  String get collectionAll => 'Alle Einträge';

  @override
  String get collectionTelegram => 'Telegram gespeichert';

  @override
  String get collectionWhatsapp => 'WhatsApp-Archiv';

  @override
  String get collectionFacebook => 'Facebook-Archiv';

  @override
  String get collectionInstagram => 'Instagram-Archiv';

  @override
  String get collectionPersonal => 'Persönliches Archiv';

  @override
  String get chat => 'Chat';

  @override
  String get copy => 'Kopieren';

  @override
  String get saveToGallery => 'In der Galerie speichern';

  @override
  String get saveToDevice => 'Auf dem Gerät speichern';

  @override
  String saveAllToGallery(int count) {
    return 'Alle $count in der Galerie speichern';
  }

  @override
  String get delete => 'Löschen';

  @override
  String get deleteTitle => 'Nachricht löschen?';

  @override
  String get deleteBody =>
      'Sie wird von diesem Gerät entfernt. Eine bereits in Google Drive gesicherte Kopie wird nicht gelöscht.';

  @override
  String get allowPhotos =>
      'Erlaube Memoir den Zugriff auf deine Fotos, um sie zu speichern.';

  @override
  String get nothingSaved => 'Nichts wurde gespeichert';

  @override
  String savedToDevice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge auf deinem Gerät gespeichert',
      one: '1 Eintrag auf deinem Gerät gespeichert',
    );
    return '$_temp0';
  }

  @override
  String saveFailed(String error) {
    return 'Speichern fehlgeschlagen: $error';
  }

  @override
  String savedInChat(int count) {
    return '$count gespeichert';
  }

  @override
  String get today => 'Heute';

  @override
  String get pinnedMessage => 'Angeheftete Nachricht';

  @override
  String get emptyChatTitle => 'Hier gibt es noch keine Nachrichten';

  @override
  String get emptyChatBody =>
      'Schreibe eine Nachricht oder hänge Dateien an, um sie zu speichern.';

  @override
  String get composerMessage => 'Nachricht';

  @override
  String get composerMessageEllipsis => 'Nachricht...';

  @override
  String get send => 'Senden';

  @override
  String photosCount(int count) {
    return '$count Fotos';
  }

  @override
  String viewerPosition(int index, int total) {
    return '$index von $total';
  }

  @override
  String get play => 'Abspielen';

  @override
  String get openWith => 'Mit anderer App öffnen';

  @override
  String get openInDrive => 'In Google Drive öffnen';

  @override
  String get noAppToOpen =>
      'Keine App auf diesem Telefon kann diese Datei öffnen.';

  @override
  String get couldNotOpen => 'Diese Datei konnte nicht geöffnet werden.';

  @override
  String get videoLoadFailed =>
      'Dieses Video kann hier nicht abgespielt werden. Versuche, es mit einer anderen App zu öffnen.';

  @override
  String get noInternet =>
      'Keine Internetverbindung. Prüfe deine Verbindung und versuche es erneut.';

  @override
  String signInClosed(String details) {
    return 'Die Google-Anmeldung wurde geschlossen oder abgelehnt. Wenn du sie nicht abgebrochen hast, versuche es erneut.$details';
  }

  @override
  String signInMisconfigured(String details) {
    return 'Die Google-Anmeldung ist falsch eingerichtet (OAuth-Client / SHA-1).$details';
  }

  @override
  String signInUiUnavailable(String details) {
    return 'Das Google-Anmeldefenster konnte nicht angezeigt werden. Versuche es erneut.$details';
  }

  @override
  String signInInterrupted(String details) {
    return 'Die Google-Anmeldung wurde unterbrochen. Versuche es erneut.$details';
  }

  @override
  String signInFailed(String code, String details) {
    return 'Google-Anmeldung fehlgeschlagen: $code$details';
  }

  @override
  String get drivePermissionDenied =>
      'Die Google-Drive-Berechtigung wurde verweigert.';

  @override
  String get reconnectRequired =>
      'Deine Google-Sitzung ist abgelaufen oder der Drive-Zugriff wurde entfernt. Verbinde dich erneut, um weiter zu sichern.';

  @override
  String get backupBusy =>
      'Es läuft bereits eine Sicherung. Versuche es gleich noch einmal.';

  @override
  String connectedTo(String email) {
    return 'Verbunden mit $email';
  }

  @override
  String get everythingBackedUp => 'Alles ist bereits gesichert';

  @override
  String backedUpNew(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count neue Einträge gesichert',
      one: '1 neuer Eintrag gesichert',
    );
    return '$_temp0';
  }

  @override
  String alreadyUpToDate(int count) {
    return '$count bereits aktuell';
  }

  @override
  String skippedMissing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fehlende Dateien übersprungen',
      one: '1 fehlende Datei übersprungen',
    );
    return '$_temp0';
  }

  @override
  String get exportFromMemoir => 'Aus Memoir exportieren';

  @override
  String get exportCancelled => 'Export abgebrochen.';

  @override
  String savedForTransfer(String name) {
    return 'Zum Übertragen gespeichert: $name';
  }

  @override
  String get thisDevice => 'Dieses Gerät';

  @override
  String get localAvailable =>
      'Dein Archiv ist lokal gespeichert und bleibt offline verfügbar.';

  @override
  String get available => 'Verfügbar';

  @override
  String get yourBackup => 'Deine Sicherung';

  @override
  String get connected => 'Verbunden';

  @override
  String get reconnectNeeded => 'Neu verbinden nötig';

  @override
  String get notConnected => 'Nicht verbunden';

  @override
  String get automaticBackup => 'Automatische Sicherung';

  @override
  String get automaticBackupSubtitle =>
      'Neue Einträge täglich hochladen, wenn Internet verfügbar ist';

  @override
  String get backupTime => 'Sicherungszeit';

  @override
  String get lastBackupNever => 'Letzte Sicherung: noch keine';

  @override
  String lastBackupAt(String date) {
    return 'Letzte Sicherung: $date';
  }

  @override
  String get iosScheduleNote =>
      'iOS lässt Apps nicht zu einer gewählten Uhrzeit laufen. Die Sicherung erfolgt beim nächsten Öffnen von Memoir nach dieser Uhrzeit.';

  @override
  String get androidScheduleNote =>
      'Android kann sie später als gewählt ausführen, um Akku zu sparen, oder warten, bis das Telefon online ist. Wenn du Memoir zwangsweise beendest, pausiert sie bis zum nächsten Öffnen.';

  @override
  String get showDriveFiles => 'Drive-Dateien anzeigen';

  @override
  String get backUpArchive => 'Archiv sichern';

  @override
  String get disconnect => 'Trennen';

  @override
  String get reconnect => 'Neu verbinden';

  @override
  String get connectPrompt =>
      'Wähle ein Google-Konto, um deine Memoir-Ordner zu erstellen und den Drive-Zugriff zu erlauben.';

  @override
  String get continueWithGoogle => 'Weiter mit Google';

  @override
  String backingUpProgress(int done, int total) {
    return 'Sichere $done von $total…';
  }

  @override
  String get organizedInDrive => 'Geordnet in deinem Drive';

  @override
  String get transferHint =>
      'Um auf ein anderes Telefon umzuziehen, installiere Memoir dort und melde dich mit demselben Google-Konto an: Memoir bietet an, deine Sicherung wiederherzustellen.';

  @override
  String driveFilesCount(int count) {
    return 'Drive-Dateien ($count)';
  }

  @override
  String get download => 'Herunterladen';

  @override
  String get showDriveFilesHint =>
      'Wähle „Drive-Dateien anzeigen“, um alles zu sehen, was Memoir gesichert hat.';

  @override
  String get driveStorageNote =>
      'Dein Archiv liegt im Ordner Memoir in deinem Google Drive. Melde dich mit einem anderen Google-Konto an, um dort ein separates, geordnetes Archiv anzulegen.';

  @override
  String get problemOffline =>
      'Keine Internetverbindung. Memoir versucht es automatisch erneut.';

  @override
  String get problemTimeout =>
      'Zeitüberschreitung der Verbindung. Memoir versucht es automatisch erneut.';

  @override
  String get problemConnectionFailed =>
      'Die Verbindung ist fehlgeschlagen. Memoir versucht es automatisch erneut.';

  @override
  String get problemGoogleUnreachable =>
      'Google war nicht erreichbar. Memoir versucht es automatisch erneut.';

  @override
  String problemRetry(String message) {
    return '$message Memoir versucht es automatisch erneut.';
  }

  @override
  String restoreFoundTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gespeicherte Einträge in deinem Drive gefunden',
      one: '1 gespeicherter Eintrag in deinem Drive gefunden',
    );
    return '$_temp0';
  }

  @override
  String get restoreFoundBody =>
      'Sie wurden früher von Memoir gesichert, sind aber nicht auf diesem Telefon. In ihre Chats wiederherstellen?';

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get notNow => 'Nicht jetzt';

  @override
  String restoringProgress(int done, int total) {
    return 'Stelle $done von $total wieder her…';
  }

  @override
  String restoredCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge wiederhergestellt',
      one: '1 Eintrag wiederhergestellt',
    );
    return '$_temp0';
  }

  @override
  String get restoredCollection => 'Wiederhergestellt';

  @override
  String get settings => 'Einstellungen';

  @override
  String get appearance => 'Darstellung';

  @override
  String get appearanceSubtitle => 'System-, helles oder dunkles Design wählen';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get language => 'Sprache';

  @override
  String get languageSystem => 'Sprache des Telefons';

  @override
  String get appLock => 'App-Sperre';

  @override
  String get appLockSubtitle =>
      'Memoir mit PIN, Muster oder Fingerabdruck des Telefons entsperren';

  @override
  String get driveBackup => 'Google-Drive-Sicherung';

  @override
  String get driveBackupSubtitle =>
      'Verbinde dein Konto, um deine Kopien zu ordnen und anzusehen';

  @override
  String get onDeviceArchive => 'Archiv auf dem Gerät';

  @override
  String get onDeviceArchiveSubtitle =>
      'Deine Erinnerungen bleiben auf diesem Gerät offline verfügbar.';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get privacySubtitle =>
      'Importiert wird nur, was du speichern willst. Memoir liest keine Datenbanken von Messenger-Apps.';

  @override
  String get developer => 'Entwickler';

  @override
  String get openProfile => 'Entwicklerprofil öffnen';

  @override
  String get linkFailed => 'Dieser Link konnte nicht geöffnet werden.';

  @override
  String get lockNeedsScreenLock =>
      'Richte zuerst eine Displaysperre (PIN, Muster oder Fingerabdruck) auf diesem Telefon ein.';

  @override
  String get lockNotUnlocked => 'Nicht entsperrt.';

  @override
  String get lockTooManyAttempts =>
      'Zu viele Versuche. Versuche es später oder nutze deine PIN.';

  @override
  String lockFailed(String code) {
    return 'Entsperren fehlgeschlagen: $code';
  }

  @override
  String get lockConfirmEnable => 'Bestätigen, um Memoir zu sperren';

  @override
  String get lockConfirmDisable => 'Bestätigen, um die Sperre zu entfernen';

  @override
  String get lockUnlockReason => 'Memoir entsperren';

  @override
  String get lockedTitle => 'Memoir ist gesperrt';

  @override
  String get lockedSubtitle =>
      'Nutze PIN, Muster oder Fingerabdruck deines Telefons';

  @override
  String get unlock => 'Entsperren';

  @override
  String updateAvailableTitle(String version) {
    return 'Version $version ist verfügbar';
  }

  @override
  String get updateAvailableBody =>
      'Eine neue Version von Memoir ist bereit. Lade sie herunter und installiere sie über diese; deine Erinnerungen bleiben auf deinem Telefon.';

  @override
  String get updateDownload => 'Herunterladen';

  @override
  String get updateLater => 'Später';

  @override
  String get checkForUpdates => 'Nach Updates suchen';

  @override
  String currentVersion(String version) {
    return 'Version $version';
  }

  @override
  String get upToDate => 'Du hast die neueste Version.';

  @override
  String get updateCheckFailed =>
      'Suche nach Updates fehlgeschlagen. Prüfe deine Internetverbindung.';

  @override
  String get addAccount => 'Weiteres Google-Konto hinzufügen';

  @override
  String get removeAccount => 'Konto entfernen';

  @override
  String removeAccountTitle(String email) {
    return '$email entfernen?';
  }

  @override
  String get removeAccountBody =>
      'Memoir sichert nicht mehr in dieses Konto. Dateien, die schon in seinem Drive sind, bleiben dort.';

  @override
  String get backupToAllAccounts =>
      'Jede Sicherung geht an alle Konten oben – so bleiben deine Erinnerungen sicher, auch wenn du eines verlierst.';

  @override
  String get shareSaveTo => 'In Memoir speichern';

  @override
  String shareItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge',
      one: '1 Eintrag',
    );
    return '$_temp0';
  }

  @override
  String sharedSaved(String name) {
    return 'In $name gespeichert';
  }

  @override
  String get recentlyDeleted => 'Zuletzt gelöscht';

  @override
  String get recentlyDeletedSubtitle =>
      'Gelöschte Einträge bleiben hier 30 Tage';

  @override
  String get trashEmpty => 'Hier ist nichts';

  @override
  String get deleteForever => 'Endgültig löschen';

  @override
  String get emptyTrash => 'Leeren';

  @override
  String get emptyTrashTitle => 'Alles hier endgültig löschen?';

  @override
  String get emptyTrashBody =>
      'Sie werden von diesem Telefon entfernt. Kopien in Google Drive bleiben.';

  @override
  String deletedOn(String date) {
    return 'Gelöscht am $date';
  }

  @override
  String get movedToTrash => 'In „Zuletzt gelöscht“ verschoben';

  @override
  String get undo => 'Rückgängig';
}
