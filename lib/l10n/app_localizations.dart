import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh'),
  ];

  /// No description provided for @navMemories.
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get navMemories;

  /// No description provided for @navDrive.
  ///
  /// In en, this message translates to:
  /// **'Google Drive'**
  String get navDrive;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @archiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your saved moments'**
  String get archiveSubtitle;

  /// No description provided for @newCollection.
  ///
  /// In en, this message translates to:
  /// **'New collection'**
  String get newCollection;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search your archive'**
  String get searchHint;

  /// No description provided for @archiveError.
  ///
  /// In en, this message translates to:
  /// **'Archive could not be opened: {error}'**
  String archiveError(String error);

  /// No description provided for @noMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get noMatches;

  /// No description provided for @addToVault.
  ///
  /// In en, this message translates to:
  /// **'Add to vault'**
  String get addToVault;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessagesYet;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your archive starts here'**
  String get emptyTitle;

  /// No description provided for @emptyBody.
  ///
  /// In en, this message translates to:
  /// **'Save a note, a link, a photo, or any file. Your items stay on this device.'**
  String get emptyBody;

  /// No description provided for @savedLink.
  ///
  /// In en, this message translates to:
  /// **'Saved link'**
  String get savedLink;

  /// No description provided for @savedNote.
  ///
  /// In en, this message translates to:
  /// **'Saved note'**
  String get savedNote;

  /// No description provided for @attachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get attachment;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get pin;

  /// No description provided for @unpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get unpin;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @removeFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove favorite'**
  String get removeFavorite;

  /// No description provided for @savedToMemoir.
  ///
  /// In en, this message translates to:
  /// **'Saved to Memoir'**
  String get savedToMemoir;

  /// No description provided for @saveSomething.
  ///
  /// In en, this message translates to:
  /// **'Save something'**
  String get saveSomething;

  /// No description provided for @writeNote.
  ///
  /// In en, this message translates to:
  /// **'Write a note or paste text'**
  String get writeNote;

  /// No description provided for @chooseFiles.
  ///
  /// In en, this message translates to:
  /// **'Choose files'**
  String get chooseFiles;

  /// No description provided for @chooseFilesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Photos, videos, PDFs, and more'**
  String get chooseFilesSubtitle;

  /// No description provided for @newItem.
  ///
  /// In en, this message translates to:
  /// **'New item'**
  String get newItem;

  /// No description provided for @newItemHint.
  ///
  /// In en, this message translates to:
  /// **'Write or paste text or a link'**
  String get newItemHint;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @collectionName.
  ///
  /// In en, this message translates to:
  /// **'Collection name'**
  String get collectionName;

  /// No description provided for @filesSaved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 file saved to this device} other{{count} files saved to this device}}'**
  String filesSaved(int count);

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not import files: {error}'**
  String importFailed(String error);

  /// No description provided for @createCollectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create collection: {error}'**
  String createCollectionFailed(String error);

  /// No description provided for @collectionAll.
  ///
  /// In en, this message translates to:
  /// **'All Items'**
  String get collectionAll;

  /// No description provided for @collectionTelegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram Saved'**
  String get collectionTelegram;

  /// No description provided for @collectionWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Archive'**
  String get collectionWhatsapp;

  /// No description provided for @collectionFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook Archive'**
  String get collectionFacebook;

  /// No description provided for @collectionInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram Archive'**
  String get collectionInstagram;

  /// No description provided for @collectionPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal Archive'**
  String get collectionPersonal;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @saveToGallery.
  ///
  /// In en, this message translates to:
  /// **'Save to gallery'**
  String get saveToGallery;

  /// No description provided for @saveToDevice.
  ///
  /// In en, this message translates to:
  /// **'Save to device'**
  String get saveToDevice;

  /// No description provided for @saveAllToGallery.
  ///
  /// In en, this message translates to:
  /// **'Save all {count} to gallery'**
  String saveAllToGallery(int count);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete message?'**
  String get deleteTitle;

  /// No description provided for @deleteBody.
  ///
  /// In en, this message translates to:
  /// **'It will be removed from this device. A copy already backed up to Google Drive is not deleted.'**
  String get deleteBody;

  /// No description provided for @allowPhotos.
  ///
  /// In en, this message translates to:
  /// **'Allow Memoir to access your photos to save them.'**
  String get allowPhotos;

  /// No description provided for @nothingSaved.
  ///
  /// In en, this message translates to:
  /// **'Nothing was saved'**
  String get nothingSaved;

  /// No description provided for @savedToDevice.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Saved 1 to your device} other{Saved {count} to your device}}'**
  String savedToDevice(int count);

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save: {error}'**
  String saveFailed(String error);

  /// No description provided for @savedInChat.
  ///
  /// In en, this message translates to:
  /// **'{count} saved'**
  String savedInChat(int count);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @pinnedMessage.
  ///
  /// In en, this message translates to:
  /// **'Pinned message'**
  String get pinnedMessage;

  /// No description provided for @emptyChatTitle.
  ///
  /// In en, this message translates to:
  /// **'No messages here yet'**
  String get emptyChatTitle;

  /// No description provided for @emptyChatBody.
  ///
  /// In en, this message translates to:
  /// **'Type a message or attach files to save them.'**
  String get emptyChatBody;

  /// No description provided for @composerMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get composerMessage;

  /// No description provided for @composerMessageEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Message...'**
  String get composerMessageEllipsis;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @photosCount.
  ///
  /// In en, this message translates to:
  /// **'{count} photos'**
  String photosCount(int count);

  /// No description provided for @viewerPosition.
  ///
  /// In en, this message translates to:
  /// **'{index} of {total}'**
  String viewerPosition(int index, int total);

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @openWith.
  ///
  /// In en, this message translates to:
  /// **'Open with another app'**
  String get openWith;

  /// No description provided for @openInDrive.
  ///
  /// In en, this message translates to:
  /// **'Open in Google Drive'**
  String get openInDrive;

  /// No description provided for @noAppToOpen.
  ///
  /// In en, this message translates to:
  /// **'No app on this phone can open this file.'**
  String get noAppToOpen;

  /// No description provided for @couldNotOpen.
  ///
  /// In en, this message translates to:
  /// **'Could not open this file.'**
  String get couldNotOpen;

  /// No description provided for @videoLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'This video could not be played here. Try opening it with another app.'**
  String get videoLoadFailed;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your connection and try again.'**
  String get noInternet;

  /// No description provided for @signInClosed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in was closed or rejected. If you did not cancel it, try again.{details}'**
  String signInClosed(String details);

  /// No description provided for @signInMisconfigured.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in is misconfigured (OAuth client / SHA-1).{details}'**
  String signInMisconfigured(String details);

  /// No description provided for @signInUiUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in could not show its window. Try again.{details}'**
  String signInUiUnavailable(String details);

  /// No description provided for @signInInterrupted.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in was interrupted. Try again.{details}'**
  String signInInterrupted(String details);

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed: {code}{details}'**
  String signInFailed(String code, String details);

  /// No description provided for @drivePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Google Drive permission was denied.'**
  String get drivePermissionDenied;

  /// No description provided for @reconnectRequired.
  ///
  /// In en, this message translates to:
  /// **'Your Google session expired or Drive access was removed. Reconnect to continue backing up.'**
  String get reconnectRequired;

  /// No description provided for @backupBusy.
  ///
  /// In en, this message translates to:
  /// **'A backup is already running. Try again in a moment.'**
  String get backupBusy;

  /// No description provided for @connectedTo.
  ///
  /// In en, this message translates to:
  /// **'Connected to {email}'**
  String connectedTo(String email);

  /// No description provided for @everythingBackedUp.
  ///
  /// In en, this message translates to:
  /// **'Everything is already backed up'**
  String get everythingBackedUp;

  /// No description provided for @backedUpNew.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Backed up 1 new item} other{Backed up {count} new items}}'**
  String backedUpNew(int count);

  /// No description provided for @alreadyUpToDate.
  ///
  /// In en, this message translates to:
  /// **'{count} already up to date'**
  String alreadyUpToDate(int count);

  /// No description provided for @skippedMissing.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{skipped 1 missing file} other{skipped {count} missing files}}'**
  String skippedMissing(int count);

  /// No description provided for @exportFromMemoir.
  ///
  /// In en, this message translates to:
  /// **'Export from Memoir'**
  String get exportFromMemoir;

  /// No description provided for @exportCancelled.
  ///
  /// In en, this message translates to:
  /// **'Export cancelled.'**
  String get exportCancelled;

  /// No description provided for @savedForTransfer.
  ///
  /// In en, this message translates to:
  /// **'Saved for transfer: {name}'**
  String savedForTransfer(String name);

  /// No description provided for @thisDevice.
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get thisDevice;

  /// No description provided for @localAvailable.
  ///
  /// In en, this message translates to:
  /// **'Your archive is saved locally and remains available offline.'**
  String get localAvailable;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @yourBackup.
  ///
  /// In en, this message translates to:
  /// **'Your backup'**
  String get yourBackup;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @reconnectNeeded.
  ///
  /// In en, this message translates to:
  /// **'Reconnect needed'**
  String get reconnectNeeded;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get notConnected;

  /// No description provided for @automaticBackup.
  ///
  /// In en, this message translates to:
  /// **'Automatic backup'**
  String get automaticBackup;

  /// No description provided for @automaticBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload new items daily when internet is available'**
  String get automaticBackupSubtitle;

  /// No description provided for @backupTime.
  ///
  /// In en, this message translates to:
  /// **'Backup time'**
  String get backupTime;

  /// No description provided for @lastBackupNever.
  ///
  /// In en, this message translates to:
  /// **'Last backup: not yet'**
  String get lastBackupNever;

  /// No description provided for @lastBackupAt.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {date}'**
  String lastBackupAt(String date);

  /// No description provided for @iosScheduleNote.
  ///
  /// In en, this message translates to:
  /// **'iOS does not let apps run at a chosen time. The backup runs the next time you open Memoir after this time.'**
  String get iosScheduleNote;

  /// No description provided for @androidScheduleNote.
  ///
  /// In en, this message translates to:
  /// **'Android may run this later than the chosen time to save battery, or wait until the phone is online. Force-stopping Memoir pauses it until you open the app again.'**
  String get androidScheduleNote;

  /// No description provided for @showDriveFiles.
  ///
  /// In en, this message translates to:
  /// **'Show Drive files'**
  String get showDriveFiles;

  /// No description provided for @backUpArchive.
  ///
  /// In en, this message translates to:
  /// **'Back up archive'**
  String get backUpArchive;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @reconnect.
  ///
  /// In en, this message translates to:
  /// **'Reconnect'**
  String get reconnect;

  /// No description provided for @connectPrompt.
  ///
  /// In en, this message translates to:
  /// **'Choose a Google account to create your Memoir folders and approve Drive access.'**
  String get connectPrompt;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @backingUpProgress.
  ///
  /// In en, this message translates to:
  /// **'Backing up {done} of {total}…'**
  String backingUpProgress(int done, int total);

  /// No description provided for @organizedInDrive.
  ///
  /// In en, this message translates to:
  /// **'Organized in your Drive'**
  String get organizedInDrive;

  /// No description provided for @transferHint.
  ///
  /// In en, this message translates to:
  /// **'To move to another phone, install Memoir there and sign in with the same Google account: Memoir offers to restore your backup.'**
  String get transferHint;

  /// No description provided for @driveFilesCount.
  ///
  /// In en, this message translates to:
  /// **'Drive files ({count})'**
  String driveFilesCount(int count);

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @showDriveFilesHint.
  ///
  /// In en, this message translates to:
  /// **'Choose “Show Drive files” to see everything backed up by Memoir.'**
  String get showDriveFilesHint;

  /// No description provided for @driveStorageNote.
  ///
  /// In en, this message translates to:
  /// **'Your archive is stored under Memoir in your Google Drive. Sign in to another Google account to create a separate, neatly organized archive there.'**
  String get driveStorageNote;

  /// No description provided for @problemOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Memoir will retry automatically.'**
  String get problemOffline;

  /// No description provided for @problemTimeout.
  ///
  /// In en, this message translates to:
  /// **'The connection timed out. Memoir will retry automatically.'**
  String get problemTimeout;

  /// No description provided for @problemConnectionFailed.
  ///
  /// In en, this message translates to:
  /// **'The connection failed. Memoir will retry automatically.'**
  String get problemConnectionFailed;

  /// No description provided for @problemGoogleUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Google could not be reached. Memoir will retry automatically.'**
  String get problemGoogleUnreachable;

  /// No description provided for @problemRetry.
  ///
  /// In en, this message translates to:
  /// **'{message} Memoir will retry automatically.'**
  String problemRetry(String message);

  /// No description provided for @restoreFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 saved item found in your Drive} other{{count} saved items found in your Drive}}'**
  String restoreFoundTitle(int count);

  /// No description provided for @restoreFoundBody.
  ///
  /// In en, this message translates to:
  /// **'These were backed up earlier from Memoir but are not on this phone. Restore them to their chats?'**
  String get restoreFoundBody;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @restoringProgress.
  ///
  /// In en, this message translates to:
  /// **'Restoring {done} of {total}…'**
  String restoringProgress(int done, int total);

  /// No description provided for @restoredCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Restored 1 item} other{Restored {count} items}}'**
  String restoredCount(int count);

  /// No description provided for @restoredCollection.
  ///
  /// In en, this message translates to:
  /// **'Restored'**
  String get restoredCollection;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @appearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose system, light, or dark theme'**
  String get appearanceSubtitle;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Phone language'**
  String get languageSystem;

  /// No description provided for @appLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get appLock;

  /// No description provided for @appLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Memoir with your phone\'s PIN, pattern or fingerprint'**
  String get appLockSubtitle;

  /// No description provided for @driveBackup.
  ///
  /// In en, this message translates to:
  /// **'Google Drive backup'**
  String get driveBackup;

  /// No description provided for @driveBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect your account to organize and browse your copies'**
  String get driveBackupSubtitle;

  /// No description provided for @onDeviceArchive.
  ///
  /// In en, this message translates to:
  /// **'On-device archive'**
  String get onDeviceArchive;

  /// No description provided for @onDeviceArchiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your memories remain available offline on this device.'**
  String get onDeviceArchiveSubtitle;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @privacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Imports happen only when you choose content to save. Memoir does not read messaging app databases.'**
  String get privacySubtitle;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @openProfile.
  ///
  /// In en, this message translates to:
  /// **'Open developer profile'**
  String get openProfile;

  /// No description provided for @linkFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open this link.'**
  String get linkFailed;

  /// No description provided for @lockNeedsScreenLock.
  ///
  /// In en, this message translates to:
  /// **'Set a screen lock (PIN, pattern or fingerprint) on this phone first.'**
  String get lockNeedsScreenLock;

  /// No description provided for @lockNotUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Not unlocked.'**
  String get lockNotUnlocked;

  /// No description provided for @lockTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later or use your PIN.'**
  String get lockTooManyAttempts;

  /// No description provided for @lockFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not unlock: {code}'**
  String lockFailed(String code);

  /// No description provided for @lockConfirmEnable.
  ///
  /// In en, this message translates to:
  /// **'Confirm to lock Memoir'**
  String get lockConfirmEnable;

  /// No description provided for @lockConfirmDisable.
  ///
  /// In en, this message translates to:
  /// **'Confirm to remove the lock'**
  String get lockConfirmDisable;

  /// No description provided for @lockUnlockReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock Memoir'**
  String get lockUnlockReason;

  /// No description provided for @lockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Memoir is locked'**
  String get lockedTitle;

  /// No description provided for @lockedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your phone\'s PIN, pattern or fingerprint'**
  String get lockedSubtitle;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @updateAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Version {version} is available'**
  String updateAvailableTitle(String version);

  /// No description provided for @updateAvailableBody.
  ///
  /// In en, this message translates to:
  /// **'A new version of Memoir is ready. Download it and install it over this one; your memories stay on your phone.'**
  String get updateAvailableBody;

  /// No description provided for @updateDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get updateDownload;

  /// No description provided for @updateLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updateLater;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get checkForUpdates;

  /// No description provided for @currentVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String currentVersion(String version);

  /// No description provided for @upToDate.
  ///
  /// In en, this message translates to:
  /// **'You have the latest version.'**
  String get upToDate;

  /// No description provided for @updateCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not check for updates. Check your internet connection.'**
  String get updateCheckFailed;

  /// No description provided for @addAccount.
  ///
  /// In en, this message translates to:
  /// **'Add another Google account'**
  String get addAccount;

  /// No description provided for @removeAccount.
  ///
  /// In en, this message translates to:
  /// **'Remove account'**
  String get removeAccount;

  /// No description provided for @removeAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {email}?'**
  String removeAccountTitle(String email);

  /// No description provided for @removeAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Memoir stops backing up to this account. Files already in its Drive stay there.'**
  String get removeAccountBody;

  /// No description provided for @backupToAllAccounts.
  ///
  /// In en, this message translates to:
  /// **'Each backup goes to every account above, so your memories stay safe even if you lose one of them.'**
  String get backupToAllAccounts;

  /// No description provided for @shareSaveTo.
  ///
  /// In en, this message translates to:
  /// **'Save to Memoir'**
  String get shareSaveTo;

  /// No description provided for @shareItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String shareItemsCount(int count);

  /// No description provided for @sharedSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to {name}'**
  String sharedSaved(String name);

  /// No description provided for @recentlyDeleted.
  ///
  /// In en, this message translates to:
  /// **'Recently deleted'**
  String get recentlyDeleted;

  /// No description provided for @recentlyDeletedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Deleted items are kept here for 30 days'**
  String get recentlyDeletedSubtitle;

  /// No description provided for @trashEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here'**
  String get trashEmpty;

  /// No description provided for @deleteForever.
  ///
  /// In en, this message translates to:
  /// **'Delete forever'**
  String get deleteForever;

  /// No description provided for @emptyTrash.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get emptyTrash;

  /// No description provided for @emptyTrashTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete everything here forever?'**
  String get emptyTrashTitle;

  /// No description provided for @emptyTrashBody.
  ///
  /// In en, this message translates to:
  /// **'They are removed from this phone. Copies in Google Drive stay.'**
  String get emptyTrashBody;

  /// No description provided for @deletedOn.
  ///
  /// In en, this message translates to:
  /// **'Deleted {date}'**
  String deletedOn(String date);

  /// No description provided for @movedToTrash.
  ///
  /// In en, this message translates to:
  /// **'Moved to Recently deleted'**
  String get movedToTrash;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'ja',
    'pt',
    'ru',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
