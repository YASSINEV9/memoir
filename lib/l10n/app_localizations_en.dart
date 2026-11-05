// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navMemories => 'Memories';

  @override
  String get navDrive => 'Google Drive';

  @override
  String get navSettings => 'Settings';

  @override
  String get archiveSubtitle => 'Your saved moments';

  @override
  String get newCollection => 'New collection';

  @override
  String get searchHint => 'Search your archive';

  @override
  String archiveError(String error) {
    return 'Archive could not be opened: $error';
  }

  @override
  String get noMatches => 'No matches';

  @override
  String get addToVault => 'Add to vault';

  @override
  String get noMessagesYet => 'No messages yet';

  @override
  String get photo => 'Photo';

  @override
  String get file => 'File';

  @override
  String get video => 'Video';

  @override
  String get emptyTitle => 'Your archive starts here';

  @override
  String get emptyBody =>
      'Save a note, a link, a photo, or any file. Your items stay on this device.';

  @override
  String get savedLink => 'Saved link';

  @override
  String get savedNote => 'Saved note';

  @override
  String get attachment => 'Attachment';

  @override
  String get pin => 'Pin';

  @override
  String get unpin => 'Unpin';

  @override
  String get favorite => 'Favorite';

  @override
  String get removeFavorite => 'Remove favorite';

  @override
  String get savedToMemoir => 'Saved to Memoir';

  @override
  String get saveSomething => 'Save something';

  @override
  String get writeNote => 'Write a note or paste text';

  @override
  String get chooseFiles => 'Choose files';

  @override
  String get chooseFilesSubtitle => 'Photos, videos, PDFs, and more';

  @override
  String get newItem => 'New item';

  @override
  String get newItemHint => 'Write or paste text or a link';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get create => 'Create';

  @override
  String get collectionName => 'Collection name';

  @override
  String filesSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files saved to this device',
      one: '1 file saved to this device',
    );
    return '$_temp0';
  }

  @override
  String importFailed(String error) {
    return 'Could not import files: $error';
  }

  @override
  String createCollectionFailed(String error) {
    return 'Could not create collection: $error';
  }

  @override
  String get collectionAll => 'All Items';

  @override
  String get collectionTelegram => 'Telegram Saved';

  @override
  String get collectionWhatsapp => 'WhatsApp Archive';

  @override
  String get collectionFacebook => 'Facebook Archive';

  @override
  String get collectionInstagram => 'Instagram Archive';

  @override
  String get collectionPersonal => 'Personal Archive';

  @override
  String get chat => 'Chat';

  @override
  String get copy => 'Copy';

  @override
  String get saveToGallery => 'Save to gallery';

  @override
  String get saveToDevice => 'Save to device';

  @override
  String saveAllToGallery(int count) {
    return 'Save all $count to gallery';
  }

  @override
  String get delete => 'Delete';

  @override
  String get deleteTitle => 'Delete message?';

  @override
  String get deleteBody =>
      'It will be removed from this device. A copy already backed up to Google Drive is not deleted.';

  @override
  String get allowPhotos => 'Allow Memoir to access your photos to save them.';

  @override
  String get nothingSaved => 'Nothing was saved';

  @override
  String savedToDevice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Saved $count to your device',
      one: 'Saved 1 to your device',
    );
    return '$_temp0';
  }

  @override
  String saveFailed(String error) {
    return 'Could not save: $error';
  }

  @override
  String savedInChat(int count) {
    return '$count saved';
  }

  @override
  String get today => 'Today';

  @override
  String get pinnedMessage => 'Pinned message';

  @override
  String get emptyChatTitle => 'No messages here yet';

  @override
  String get emptyChatBody => 'Type a message or attach files to save them.';

  @override
  String get composerMessage => 'Message';

  @override
  String get composerMessageEllipsis => 'Message...';

  @override
  String get send => 'Send';

  @override
  String photosCount(int count) {
    return '$count photos';
  }

  @override
  String viewerPosition(int index, int total) {
    return '$index of $total';
  }

  @override
  String get play => 'Play';

  @override
  String get openWith => 'Open with another app';

  @override
  String get openInDrive => 'Open in Google Drive';

  @override
  String get noAppToOpen => 'No app on this phone can open this file.';

  @override
  String get couldNotOpen => 'Could not open this file.';

  @override
  String get videoLoadFailed =>
      'This video could not be played here. Try opening it with another app.';

  @override
  String get noInternet =>
      'No internet connection. Check your connection and try again.';

  @override
  String signInClosed(String details) {
    return 'Google sign-in was closed or rejected. If you did not cancel it, try again.$details';
  }

  @override
  String signInMisconfigured(String details) {
    return 'Google sign-in is misconfigured (OAuth client / SHA-1).$details';
  }

  @override
  String signInUiUnavailable(String details) {
    return 'Google sign-in could not show its window. Try again.$details';
  }

  @override
  String signInInterrupted(String details) {
    return 'Google sign-in was interrupted. Try again.$details';
  }

  @override
  String signInFailed(String code, String details) {
    return 'Google sign-in failed: $code$details';
  }

  @override
  String get drivePermissionDenied => 'Google Drive permission was denied.';

  @override
  String get reconnectRequired =>
      'Your Google session expired or Drive access was removed. Reconnect to continue backing up.';

  @override
  String get backupBusy =>
      'A backup is already running. Try again in a moment.';

  @override
  String connectedTo(String email) {
    return 'Connected to $email';
  }

  @override
  String get everythingBackedUp => 'Everything is already backed up';

  @override
  String backedUpNew(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Backed up $count new items',
      one: 'Backed up 1 new item',
    );
    return '$_temp0';
  }

  @override
  String alreadyUpToDate(int count) {
    return '$count already up to date';
  }

  @override
  String skippedMissing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'skipped $count missing files',
      one: 'skipped 1 missing file',
    );
    return '$_temp0';
  }

  @override
  String get exportFromMemoir => 'Export from Memoir';

  @override
  String get exportCancelled => 'Export cancelled.';

  @override
  String savedForTransfer(String name) {
    return 'Saved for transfer: $name';
  }

  @override
  String get thisDevice => 'This device';

  @override
  String get localAvailable =>
      'Your archive is saved locally and remains available offline.';

  @override
  String get available => 'Available';

  @override
  String get yourBackup => 'Your backup';

  @override
  String get connected => 'Connected';

  @override
  String get reconnectNeeded => 'Reconnect needed';

  @override
  String get notConnected => 'Not connected';

  @override
  String get automaticBackup => 'Automatic backup';

  @override
  String get automaticBackupSubtitle =>
      'Upload new items daily when internet is available';

  @override
  String get backupTime => 'Backup time';

  @override
  String get lastBackupNever => 'Last backup: not yet';

  @override
  String lastBackupAt(String date) {
    return 'Last backup: $date';
  }

  @override
  String get iosScheduleNote =>
      'iOS does not let apps run at a chosen time. The backup runs the next time you open Memoir after this time.';

  @override
  String get androidScheduleNote =>
      'Android may run this later than the chosen time to save battery, or wait until the phone is online. Force-stopping Memoir pauses it until you open the app again.';

  @override
  String get showDriveFiles => 'Show Drive files';

  @override
  String get backUpArchive => 'Back up archive';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get reconnect => 'Reconnect';

  @override
  String get connectPrompt =>
      'Choose a Google account to create your Memoir folders and approve Drive access.';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String backingUpProgress(int done, int total) {
    return 'Backing up $done of $total…';
  }

  @override
  String get organizedInDrive => 'Organized in your Drive';

  @override
  String get transferHint =>
      'To move to another phone, install Memoir there and sign in with the same Google account: Memoir offers to restore your backup.';

  @override
  String driveFilesCount(int count) {
    return 'Drive files ($count)';
  }

  @override
  String get download => 'Download';

  @override
  String get showDriveFilesHint =>
      'Choose “Show Drive files” to see everything backed up by Memoir.';

  @override
  String get driveStorageNote =>
      'Your archive is stored under Memoir in your Google Drive. Sign in to another Google account to create a separate, neatly organized archive there.';

  @override
  String get problemOffline =>
      'No internet connection. Memoir will retry automatically.';

  @override
  String get problemTimeout =>
      'The connection timed out. Memoir will retry automatically.';

  @override
  String get problemConnectionFailed =>
      'The connection failed. Memoir will retry automatically.';

  @override
  String get problemGoogleUnreachable =>
      'Google could not be reached. Memoir will retry automatically.';

  @override
  String problemRetry(String message) {
    return '$message Memoir will retry automatically.';
  }

  @override
  String restoreFoundTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saved items found in your Drive',
      one: '1 saved item found in your Drive',
    );
    return '$_temp0';
  }

  @override
  String get restoreFoundBody =>
      'These were backed up earlier from Memoir but are not on this phone. Restore them to their chats?';

  @override
  String get restore => 'Restore';

  @override
  String get notNow => 'Not now';

  @override
  String restoringProgress(int done, int total) {
    return 'Restoring $done of $total…';
  }

  @override
  String restoredCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Restored $count items',
      one: 'Restored 1 item',
    );
    return '$_temp0';
  }

  @override
  String get restoredCollection => 'Restored';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get appearanceSubtitle => 'Choose system, light, or dark theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Phone language';

  @override
  String get appLock => 'App lock';

  @override
  String get appLockSubtitle =>
      'Unlock Memoir with your phone\'s PIN, pattern or fingerprint';

  @override
  String get driveBackup => 'Google Drive backup';

  @override
  String get driveBackupSubtitle =>
      'Connect your account to organize and browse your copies';

  @override
  String get onDeviceArchive => 'On-device archive';

  @override
  String get onDeviceArchiveSubtitle =>
      'Your memories remain available offline on this device.';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacySubtitle =>
      'Imports happen only when you choose content to save. Memoir does not read messaging app databases.';

  @override
  String get developer => 'Developer';

  @override
  String get openProfile => 'Open developer profile';

  @override
  String get linkFailed => 'Could not open this link.';

  @override
  String get lockNeedsScreenLock =>
      'Set a screen lock (PIN, pattern or fingerprint) on this phone first.';

  @override
  String get lockNotUnlocked => 'Not unlocked.';

  @override
  String get lockTooManyAttempts =>
      'Too many attempts. Try again later or use your PIN.';

  @override
  String lockFailed(String code) {
    return 'Could not unlock: $code';
  }

  @override
  String get lockConfirmEnable => 'Confirm to lock Memoir';

  @override
  String get lockConfirmDisable => 'Confirm to remove the lock';

  @override
  String get lockUnlockReason => 'Unlock Memoir';

  @override
  String get lockedTitle => 'Memoir is locked';

  @override
  String get lockedSubtitle => 'Use your phone\'s PIN, pattern or fingerprint';

  @override
  String get unlock => 'Unlock';
}
