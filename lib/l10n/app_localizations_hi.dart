// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get navMemories => 'यादें';

  @override
  String get navDrive => 'Google Drive';

  @override
  String get navSettings => 'सेटिंग';

  @override
  String get archiveSubtitle => 'आपके सहेजे गए पल';

  @override
  String get newCollection => 'नया संग्रह';

  @override
  String get searchHint => 'अपने संग्रह में खोजें';

  @override
  String archiveError(String error) {
    return 'संग्रह नहीं खुल सका: $error';
  }

  @override
  String get noMatches => 'कोई नतीजा नहीं';

  @override
  String get addToVault => 'जोड़ें';

  @override
  String get noMessagesYet => 'अभी कोई संदेश नहीं';

  @override
  String get photo => 'फ़ोटो';

  @override
  String get file => 'फ़ाइल';

  @override
  String get video => 'वीडियो';

  @override
  String get emptyTitle => 'आपका संग्रह यहीं से शुरू होता है';

  @override
  String get emptyBody =>
      'नोट, लिंक, फ़ोटो या कोई भी फ़ाइल सहेजें। आपकी चीज़ें इसी डिवाइस पर रहती हैं।';

  @override
  String get savedLink => 'सहेजा गया लिंक';

  @override
  String get savedNote => 'सहेजा गया नोट';

  @override
  String get attachment => 'अटैचमेंट';

  @override
  String get pin => 'पिन करें';

  @override
  String get unpin => 'पिन हटाएँ';

  @override
  String get favorite => 'पसंदीदा';

  @override
  String get removeFavorite => 'पसंदीदा से हटाएँ';

  @override
  String get savedToMemoir => 'Memoir में सहेजा गया';

  @override
  String get saveSomething => 'कुछ सहेजें';

  @override
  String get writeNote => 'नोट लिखें या टेक्स्ट चिपकाएँ';

  @override
  String get chooseFiles => 'फ़ाइलें चुनें';

  @override
  String get chooseFilesSubtitle => 'फ़ोटो, वीडियो, PDF और बहुत कुछ';

  @override
  String get newItem => 'नई चीज़';

  @override
  String get newItemHint => 'टेक्स्ट या लिंक लिखें या चिपकाएँ';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सहेजें';

  @override
  String get create => 'बनाएँ';

  @override
  String get collectionName => 'संग्रह का नाम';

  @override
  String filesSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़ाइलें इस डिवाइस पर सहेजी गईं',
      one: '1 फ़ाइल इस डिवाइस पर सहेजी गई',
    );
    return '$_temp0';
  }

  @override
  String importFailed(String error) {
    return 'फ़ाइलें आयात नहीं हो सकीं: $error';
  }

  @override
  String createCollectionFailed(String error) {
    return 'संग्रह नहीं बन सका: $error';
  }

  @override
  String get collectionAll => 'सभी चीज़ें';

  @override
  String get collectionTelegram => 'Telegram सहेजे गए';

  @override
  String get collectionWhatsapp => 'WhatsApp संग्रह';

  @override
  String get collectionFacebook => 'Facebook संग्रह';

  @override
  String get collectionInstagram => 'Instagram संग्रह';

  @override
  String get collectionPersonal => 'निजी संग्रह';

  @override
  String get chat => 'चैट';

  @override
  String get copy => 'कॉपी करें';

  @override
  String get saveToGallery => 'गैलरी में सहेजें';

  @override
  String get saveToDevice => 'डिवाइस पर सहेजें';

  @override
  String saveAllToGallery(int count) {
    return 'सभी $count गैलरी में सहेजें';
  }

  @override
  String get delete => 'हटाएँ';

  @override
  String get deleteTitle => 'संदेश हटाएँ?';

  @override
  String get deleteBody =>
      'यह इस डिवाइस से हट जाएगा। Google Drive पर पहले से बैकअप की गई कॉपी नहीं हटेगी।';

  @override
  String get allowPhotos => 'सहेजने के लिए Memoir को अपनी फ़ोटो तक पहुँच दें।';

  @override
  String get nothingSaved => 'कुछ भी नहीं सहेजा गया';

  @override
  String savedToDevice(int count) {
    return '$count चीज़ें आपके डिवाइस पर सहेजी गईं';
  }

  @override
  String saveFailed(String error) {
    return 'सहेजा नहीं जा सका: $error';
  }

  @override
  String savedInChat(int count) {
    return '$count सहेजे गए';
  }

  @override
  String get today => 'आज';

  @override
  String get pinnedMessage => 'पिन किया गया संदेश';

  @override
  String get emptyChatTitle => 'यहाँ अभी कोई संदेश नहीं है';

  @override
  String get emptyChatBody => 'सहेजने के लिए संदेश लिखें या फ़ाइलें जोड़ें।';

  @override
  String get composerMessage => 'संदेश';

  @override
  String get composerMessageEllipsis => 'संदेश...';

  @override
  String get send => 'भेजें';

  @override
  String photosCount(int count) {
    return '$count फ़ोटो';
  }

  @override
  String viewerPosition(int index, int total) {
    return '$total में से $index';
  }

  @override
  String get play => 'चलाएँ';

  @override
  String get openWith => 'किसी दूसरे ऐप से खोलें';

  @override
  String get openInDrive => 'Google Drive में खोलें';

  @override
  String get noAppToOpen => 'इस फ़ोन पर कोई ऐप यह फ़ाइल नहीं खोल सकता।';

  @override
  String get couldNotOpen => 'यह फ़ाइल नहीं खुल सकी।';

  @override
  String get videoLoadFailed =>
      'यह वीडियो यहाँ नहीं चल सकता। इसे किसी दूसरे ऐप से खोलकर देखें।';

  @override
  String get noInternet =>
      'इंटरनेट कनेक्शन नहीं है। कनेक्शन जाँचकर फिर से कोशिश करें।';

  @override
  String signInClosed(String details) {
    return 'Google साइन-इन बंद हो गया या अस्वीकार हुआ। अगर आपने रद्द नहीं किया, तो फिर से कोशिश करें।$details';
  }

  @override
  String signInMisconfigured(String details) {
    return 'Google साइन-इन की सेटिंग गलत है (OAuth क्लाइंट / SHA-1)।$details';
  }

  @override
  String signInUiUnavailable(String details) {
    return 'Google साइन-इन विंडो नहीं दिख सकी। फिर से कोशिश करें।$details';
  }

  @override
  String signInInterrupted(String details) {
    return 'Google साइन-इन बीच में रुक गया। फिर से कोशिश करें।$details';
  }

  @override
  String signInFailed(String code, String details) {
    return 'Google साइन-इन विफल: $code$details';
  }

  @override
  String get drivePermissionDenied => 'Google Drive की अनुमति नहीं मिली।';

  @override
  String get reconnectRequired =>
      'आपका Google सत्र खत्म हो गया या Drive की पहुँच हटा दी गई। बैकअप जारी रखने के लिए फिर से कनेक्ट करें।';

  @override
  String get backupBusy =>
      'एक बैकअप पहले से चल रहा है। थोड़ी देर बाद कोशिश करें।';

  @override
  String connectedTo(String email) {
    return '$email से कनेक्ट है';
  }

  @override
  String get everythingBackedUp => 'सब कुछ पहले से बैकअप में है';

  @override
  String backedUpNew(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count नई चीज़ों का बैकअप हुआ',
      one: '1 नई चीज़ का बैकअप हुआ',
    );
    return '$_temp0';
  }

  @override
  String alreadyUpToDate(int count) {
    return '$count पहले से अप-टू-डेट';
  }

  @override
  String skippedMissing(int count) {
    return '$count गायब फ़ाइलें छोड़ी गईं';
  }

  @override
  String get exportFromMemoir => 'Memoir से निर्यात करें';

  @override
  String get exportCancelled => 'निर्यात रद्द हुआ।';

  @override
  String savedForTransfer(String name) {
    return 'ट्रांसफ़र के लिए सहेजा गया: $name';
  }

  @override
  String get thisDevice => 'यह डिवाइस';

  @override
  String get localAvailable =>
      'आपका संग्रह डिवाइस पर सहेजा है और बिना इंटरनेट भी उपलब्ध है।';

  @override
  String get available => 'उपलब्ध';

  @override
  String get yourBackup => 'आपका बैकअप';

  @override
  String get connected => 'कनेक्ट है';

  @override
  String get reconnectNeeded => 'फिर से कनेक्ट करना ज़रूरी';

  @override
  String get notConnected => 'कनेक्ट नहीं';

  @override
  String get automaticBackup => 'अपने-आप बैकअप';

  @override
  String get automaticBackupSubtitle =>
      'इंटरनेट होने पर हर दिन नई चीज़ें अपलोड करें';

  @override
  String get backupTime => 'बैकअप का समय';

  @override
  String get lastBackupNever => 'पिछला बैकअप: अभी नहीं';

  @override
  String lastBackupAt(String date) {
    return 'पिछला बैकअप: $date';
  }

  @override
  String get iosScheduleNote =>
      'iOS ऐप्स को चुने हुए समय पर चलने नहीं देता। इस समय के बाद अगली बार Memoir खोलने पर बैकअप होगा।';

  @override
  String get androidScheduleNote =>
      'बैटरी बचाने के लिए Android इसे चुने हुए समय से देर से चला सकता है, या फ़ोन के ऑनलाइन होने का इंतज़ार कर सकता है। Memoir को ज़बरदस्ती बंद करने पर यह ऐप दोबारा खोलने तक रुक जाता है।';

  @override
  String get showDriveFiles => 'Drive की फ़ाइलें दिखाएँ';

  @override
  String get backUpArchive => 'संग्रह का बैकअप लें';

  @override
  String get disconnect => 'डिस्कनेक्ट करें';

  @override
  String get reconnect => 'फिर से कनेक्ट करें';

  @override
  String get connectPrompt =>
      'Memoir फ़ोल्डर बनाने और Drive की पहुँच देने के लिए Google खाता चुनें।';

  @override
  String get continueWithGoogle => 'Google के साथ जारी रखें';

  @override
  String backingUpProgress(int done, int total) {
    return '$total में से $done का बैकअप हो रहा है…';
  }

  @override
  String get organizedInDrive => 'आपके Drive में व्यवस्थित';

  @override
  String get transferHint =>
      'दूसरे फ़ोन पर जाने के लिए वहाँ Memoir इंस्टॉल करें और उसी Google खाते से साइन इन करें: Memoir आपका बैकअप वापस लाने का विकल्प देगा।';

  @override
  String driveFilesCount(int count) {
    return 'Drive फ़ाइलें ($count)';
  }

  @override
  String get download => 'डाउनलोड करें';

  @override
  String get showDriveFilesHint =>
      'Memoir का पूरा बैकअप देखने के लिए “Drive की फ़ाइलें दिखाएँ” चुनें।';

  @override
  String get driveStorageNote =>
      'आपका संग्रह आपके Google Drive के Memoir फ़ोल्डर में रखा है। वहाँ अलग, व्यवस्थित संग्रह बनाने के लिए दूसरे Google खाते से साइन इन करें।';

  @override
  String get problemOffline =>
      'इंटरनेट कनेक्शन नहीं है। Memoir अपने-आप फिर से कोशिश करेगा।';

  @override
  String get problemTimeout =>
      'कनेक्शन का समय खत्म हुआ। Memoir अपने-आप फिर से कोशिश करेगा।';

  @override
  String get problemConnectionFailed =>
      'कनेक्शन विफल रहा। Memoir अपने-आप फिर से कोशिश करेगा।';

  @override
  String get problemGoogleUnreachable =>
      'Google तक नहीं पहुँच सके। Memoir अपने-आप फिर से कोशिश करेगा।';

  @override
  String problemRetry(String message) {
    return '$message Memoir अपने-आप फिर से कोशिश करेगा।';
  }

  @override
  String restoreFoundTitle(int count) {
    return 'आपके Drive में $count सहेजी गई चीज़ें मिलीं';
  }

  @override
  String get restoreFoundBody =>
      'इनका बैकअप पहले Memoir से लिया गया था, पर ये इस फ़ोन पर नहीं हैं। क्या इन्हें इनकी चैट में वापस लाएँ?';

  @override
  String get restore => 'वापस लाएँ';

  @override
  String get notNow => 'अभी नहीं';

  @override
  String restoringProgress(int done, int total) {
    return '$total में से $done वापस लाई जा रही है…';
  }

  @override
  String restoredCount(int count) {
    return '$count चीज़ें वापस लाई गईं';
  }

  @override
  String get restoredCollection => 'वापस लाई गई';

  @override
  String get settings => 'सेटिंग';

  @override
  String get appearance => 'रूप';

  @override
  String get appearanceSubtitle => 'सिस्टम, हल्की या गहरी थीम चुनें';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeLight => 'हल्की';

  @override
  String get themeDark => 'गहरी';

  @override
  String get language => 'भाषा';

  @override
  String get languageSystem => 'फ़ोन की भाषा';

  @override
  String get appLock => 'ऐप लॉक';

  @override
  String get appLockSubtitle =>
      'फ़ोन के PIN, पैटर्न या फ़िंगरप्रिंट से Memoir खोलें';

  @override
  String get driveBackup => 'Google Drive बैकअप';

  @override
  String get driveBackupSubtitle =>
      'अपनी कॉपियाँ व्यवस्थित करने और देखने के लिए खाता कनेक्ट करें';

  @override
  String get onDeviceArchive => 'डिवाइस पर संग्रह';

  @override
  String get onDeviceArchiveSubtitle =>
      'आपकी यादें इस डिवाइस पर बिना इंटरनेट भी उपलब्ध रहती हैं।';

  @override
  String get privacy => 'निजता';

  @override
  String get privacySubtitle =>
      'सिर्फ़ वही आयात होता है जो आप सहेजना चुनते हैं। Memoir मैसेजिंग ऐप्स के डेटाबेस नहीं पढ़ता।';

  @override
  String get developer => 'डेवलपर';

  @override
  String get openProfile => 'डेवलपर की प्रोफ़ाइल खोलें';

  @override
  String get linkFailed => 'यह लिंक नहीं खुल सका।';

  @override
  String get lockNeedsScreenLock =>
      'पहले इस फ़ोन पर स्क्रीन लॉक (PIN, पैटर्न या फ़िंगरप्रिंट) सेट करें।';

  @override
  String get lockNotUnlocked => 'अनलॉक नहीं हुआ।';

  @override
  String get lockTooManyAttempts =>
      'बहुत ज़्यादा कोशिशें। बाद में कोशिश करें या PIN इस्तेमाल करें।';

  @override
  String lockFailed(String code) {
    return 'अनलॉक नहीं हो सका: $code';
  }

  @override
  String get lockConfirmEnable => 'Memoir लॉक करने के लिए पुष्टि करें';

  @override
  String get lockConfirmDisable => 'लॉक हटाने के लिए पुष्टि करें';

  @override
  String get lockUnlockReason => 'Memoir अनलॉक करें';

  @override
  String get lockedTitle => 'Memoir लॉक है';

  @override
  String get lockedSubtitle =>
      'अपने फ़ोन का PIN, पैटर्न या फ़िंगरप्रिंट इस्तेमाल करें';

  @override
  String get unlock => 'अनलॉक करें';

  @override
  String updateAvailableTitle(String version) {
    return 'संस्करण $version उपलब्ध है';
  }

  @override
  String get updateAvailableBody =>
      'Memoir का नया संस्करण तैयार है। इसे डाउनलोड करके इसी के ऊपर इंस्टॉल करें; आपकी यादें आपके फ़ोन पर ही रहेंगी।';

  @override
  String get updateDownload => 'डाउनलोड करें';

  @override
  String get updateLater => 'बाद में';

  @override
  String get checkForUpdates => 'अपडेट जाँचें';

  @override
  String currentVersion(String version) {
    return 'संस्करण $version';
  }

  @override
  String get upToDate => 'आपके पास नवीनतम संस्करण है।';

  @override
  String get updateCheckFailed =>
      'अपडेट नहीं जाँच सके। अपना इंटरनेट कनेक्शन जाँचें।';
}
