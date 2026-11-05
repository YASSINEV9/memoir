// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get navMemories => 'Anılar';

  @override
  String get navDrive => 'Google Drive';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get archiveSubtitle => 'Kaydettiğin anlar';

  @override
  String get newCollection => 'Yeni koleksiyon';

  @override
  String get searchHint => 'Arşivinde ara';

  @override
  String archiveError(String error) {
    return 'Arşiv açılamadı: $error';
  }

  @override
  String get noMatches => 'Sonuç yok';

  @override
  String get addToVault => 'Ekle';

  @override
  String get noMessagesYet => 'Henüz mesaj yok';

  @override
  String get photo => 'Fotoğraf';

  @override
  String get file => 'Dosya';

  @override
  String get video => 'Video';

  @override
  String get emptyTitle => 'Arşivin burada başlıyor';

  @override
  String get emptyBody =>
      'Bir not, bağlantı, fotoğraf ya da herhangi bir dosya kaydet. Öğelerin bu cihazda kalır.';

  @override
  String get savedLink => 'Kayıtlı bağlantı';

  @override
  String get savedNote => 'Kayıtlı not';

  @override
  String get attachment => 'Ek';

  @override
  String get pin => 'Sabitle';

  @override
  String get unpin => 'Sabitlemeyi kaldır';

  @override
  String get favorite => 'Favori';

  @override
  String get removeFavorite => 'Favorilerden çıkar';

  @override
  String get savedToMemoir => 'Memoir\'e kaydedildi';

  @override
  String get saveSomething => 'Bir şey kaydet';

  @override
  String get writeNote => 'Not yaz veya metin yapıştır';

  @override
  String get chooseFiles => 'Dosya seç';

  @override
  String get chooseFilesSubtitle =>
      'Fotoğraflar, videolar, PDF\'ler ve daha fazlası';

  @override
  String get newItem => 'Yeni öğe';

  @override
  String get newItemHint => 'Metin veya bağlantı yaz ya da yapıştır';

  @override
  String get cancel => 'İptal';

  @override
  String get save => 'Kaydet';

  @override
  String get create => 'Oluştur';

  @override
  String get collectionName => 'Koleksiyon adı';

  @override
  String filesSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dosya bu cihaza kaydedildi',
      one: '1 dosya bu cihaza kaydedildi',
    );
    return '$_temp0';
  }

  @override
  String importFailed(String error) {
    return 'Dosyalar içe aktarılamadı: $error';
  }

  @override
  String createCollectionFailed(String error) {
    return 'Koleksiyon oluşturulamadı: $error';
  }

  @override
  String get collectionAll => 'Tüm öğeler';

  @override
  String get collectionTelegram => 'Telegram kayıtları';

  @override
  String get collectionWhatsapp => 'WhatsApp arşivi';

  @override
  String get collectionFacebook => 'Facebook arşivi';

  @override
  String get collectionInstagram => 'Instagram arşivi';

  @override
  String get collectionPersonal => 'Kişisel arşiv';

  @override
  String get chat => 'Sohbet';

  @override
  String get copy => 'Kopyala';

  @override
  String get saveToGallery => 'Galeriye kaydet';

  @override
  String get saveToDevice => 'Cihaza kaydet';

  @override
  String saveAllToGallery(int count) {
    return '$count öğenin tümünü galeriye kaydet';
  }

  @override
  String get delete => 'Sil';

  @override
  String get deleteTitle => 'Mesaj silinsin mi?';

  @override
  String get deleteBody =>
      'Bu cihazdan kaldırılacak. Google Drive\'a daha önce yedeklenen kopya silinmez.';

  @override
  String get allowPhotos =>
      'Kaydetmek için Memoir\'in fotoğraflarına erişmesine izin ver.';

  @override
  String get nothingSaved => 'Hiçbir şey kaydedilmedi';

  @override
  String savedToDevice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe cihazına kaydedildi',
      one: '1 öğe cihazına kaydedildi',
    );
    return '$_temp0';
  }

  @override
  String saveFailed(String error) {
    return 'Kaydedilemedi: $error';
  }

  @override
  String savedInChat(int count) {
    return '$count kayıtlı';
  }

  @override
  String get today => 'Bugün';

  @override
  String get pinnedMessage => 'Sabitlenmiş mesaj';

  @override
  String get emptyChatTitle => 'Burada henüz mesaj yok';

  @override
  String get emptyChatBody => 'Kaydetmek için bir mesaj yaz veya dosya ekle.';

  @override
  String get composerMessage => 'Mesaj';

  @override
  String get composerMessageEllipsis => 'Mesaj...';

  @override
  String get send => 'Gönder';

  @override
  String photosCount(int count) {
    return '$count fotoğraf';
  }

  @override
  String viewerPosition(int index, int total) {
    return '$index / $total';
  }

  @override
  String get play => 'Oynat';

  @override
  String get openWith => 'Başka bir uygulamayla aç';

  @override
  String get openInDrive => 'Google Drive\'da aç';

  @override
  String get noAppToOpen =>
      'Bu telefondaki hiçbir uygulama bu dosyayı açamıyor.';

  @override
  String get couldNotOpen => 'Bu dosya açılamadı.';

  @override
  String get videoLoadFailed =>
      'Bu video burada oynatılamıyor. Başka bir uygulamayla açmayı dene.';

  @override
  String get noInternet =>
      'İnternet bağlantısı yok. Bağlantını kontrol edip tekrar dene.';

  @override
  String signInClosed(String details) {
    return 'Google ile giriş kapatıldı veya reddedildi. İptal etmediysen tekrar dene.$details';
  }

  @override
  String signInMisconfigured(String details) {
    return 'Google ile giriş yanlış yapılandırılmış (OAuth istemcisi / SHA-1).$details';
  }

  @override
  String signInUiUnavailable(String details) {
    return 'Google giriş penceresi gösterilemedi. Tekrar dene.$details';
  }

  @override
  String signInInterrupted(String details) {
    return 'Google ile giriş kesildi. Tekrar dene.$details';
  }

  @override
  String signInFailed(String code, String details) {
    return 'Google ile giriş başarısız: $code$details';
  }

  @override
  String get drivePermissionDenied => 'Google Drive izni reddedildi.';

  @override
  String get reconnectRequired =>
      'Google oturumun sona erdi veya Drive erişimi kaldırıldı. Yedeklemeye devam etmek için yeniden bağlan.';

  @override
  String get backupBusy =>
      'Zaten bir yedekleme çalışıyor. Birazdan tekrar dene.';

  @override
  String connectedTo(String email) {
    return '$email hesabına bağlı';
  }

  @override
  String get everythingBackedUp => 'Her şey zaten yedeklendi';

  @override
  String backedUpNew(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yeni öğe yedeklendi',
      one: '1 yeni öğe yedeklendi',
    );
    return '$_temp0';
  }

  @override
  String alreadyUpToDate(int count) {
    return '$count zaten güncel';
  }

  @override
  String skippedMissing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count eksik dosya atlandı',
      one: '1 eksik dosya atlandı',
    );
    return '$_temp0';
  }

  @override
  String get exportFromMemoir => 'Memoir\'den dışa aktar';

  @override
  String get exportCancelled => 'Dışa aktarma iptal edildi.';

  @override
  String savedForTransfer(String name) {
    return 'Aktarım için kaydedildi: $name';
  }

  @override
  String get thisDevice => 'Bu cihaz';

  @override
  String get localAvailable =>
      'Arşivin cihazda kayıtlı ve çevrimdışı da kullanılabilir.';

  @override
  String get available => 'Kullanılabilir';

  @override
  String get yourBackup => 'Yedeğin';

  @override
  String get connected => 'Bağlı';

  @override
  String get reconnectNeeded => 'Yeniden bağlanmak gerekiyor';

  @override
  String get notConnected => 'Bağlı değil';

  @override
  String get automaticBackup => 'Otomatik yedekleme';

  @override
  String get automaticBackupSubtitle =>
      'İnternet olduğunda yeni öğeleri her gün yükle';

  @override
  String get backupTime => 'Yedekleme saati';

  @override
  String get lastBackupNever => 'Son yedekleme: henüz yok';

  @override
  String lastBackupAt(String date) {
    return 'Son yedekleme: $date';
  }

  @override
  String get iosScheduleNote =>
      'iOS, uygulamaların seçilen saatte çalışmasına izin vermez. Yedekleme, bu saatten sonra Memoir\'i ilk açtığında yapılır.';

  @override
  String get androidScheduleNote =>
      'Android, pil tasarrufu için yedeklemeyi seçilen saatten sonra yapabilir veya telefonun çevrimiçi olmasını bekleyebilir. Memoir\'i zorla durdurmak, uygulamayı tekrar açana kadar yedeklemeyi duraklatır.';

  @override
  String get showDriveFiles => 'Drive dosyalarını göster';

  @override
  String get backUpArchive => 'Arşivi yedekle';

  @override
  String get disconnect => 'Bağlantıyı kes';

  @override
  String get reconnect => 'Yeniden bağlan';

  @override
  String get connectPrompt =>
      'Memoir klasörlerini oluşturmak ve Drive erişimini onaylamak için bir Google hesabı seç.';

  @override
  String get continueWithGoogle => 'Google ile devam et';

  @override
  String backingUpProgress(int done, int total) {
    return '$done/$total yedekleniyor…';
  }

  @override
  String get organizedInDrive => 'Drive\'ında düzenli';

  @override
  String get transferHint =>
      'Başka bir telefona geçmek için Memoir\'i oraya kur ve aynı Google hesabıyla giriş yap: Memoir yedeğini geri yüklemeyi önerir.';

  @override
  String driveFilesCount(int count) {
    return 'Drive dosyaları ($count)';
  }

  @override
  String get download => 'İndir';

  @override
  String get showDriveFilesHint =>
      'Memoir\'in yedeklediği her şeyi görmek için “Drive dosyalarını göster”i seç.';

  @override
  String get driveStorageNote =>
      'Arşivin Google Drive\'ındaki Memoir klasöründe saklanır. Orada ayrı ve düzenli bir arşiv oluşturmak için başka bir Google hesabıyla giriş yap.';

  @override
  String get problemOffline =>
      'İnternet bağlantısı yok. Memoir otomatik olarak tekrar deneyecek.';

  @override
  String get problemTimeout =>
      'Bağlantı zaman aşımına uğradı. Memoir otomatik olarak tekrar deneyecek.';

  @override
  String get problemConnectionFailed =>
      'Bağlantı başarısız oldu. Memoir otomatik olarak tekrar deneyecek.';

  @override
  String get problemGoogleUnreachable =>
      'Google\'a ulaşılamadı. Memoir otomatik olarak tekrar deneyecek.';

  @override
  String problemRetry(String message) {
    return '$message Memoir otomatik olarak tekrar deneyecek.';
  }

  @override
  String restoreFoundTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Drive\'ında $count kayıtlı öğe bulundu',
      one: 'Drive\'ında 1 kayıtlı öğe bulundu',
    );
    return '$_temp0';
  }

  @override
  String get restoreFoundBody =>
      'Bunlar daha önce Memoir\'den yedeklendi ama bu telefonda yok. Sohbetlerine geri yüklensin mi?';

  @override
  String get restore => 'Geri yükle';

  @override
  String get notNow => 'Şimdi değil';

  @override
  String restoringProgress(int done, int total) {
    return '$done/$total geri yükleniyor…';
  }

  @override
  String restoredCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe geri yüklendi',
      one: '1 öğe geri yüklendi',
    );
    return '$_temp0';
  }

  @override
  String get restoredCollection => 'Geri yüklenen';

  @override
  String get settings => 'Ayarlar';

  @override
  String get appearance => 'Görünüm';

  @override
  String get appearanceSubtitle => 'Sistem, açık veya koyu tema seç';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get language => 'Dil';

  @override
  String get languageSystem => 'Telefon dili';

  @override
  String get appLock => 'Uygulama kilidi';

  @override
  String get appLockSubtitle =>
      'Memoir\'in kilidini telefonunun PIN\'i, deseni veya parmak izi ile aç';

  @override
  String get driveBackup => 'Google Drive yedeği';

  @override
  String get driveBackupSubtitle =>
      'Kopyalarını düzenlemek ve görmek için hesabını bağla';

  @override
  String get onDeviceArchive => 'Cihazdaki arşiv';

  @override
  String get onDeviceArchiveSubtitle =>
      'Anıların bu cihazda çevrimdışı da kullanılabilir.';

  @override
  String get privacy => 'Gizlilik';

  @override
  String get privacySubtitle =>
      'Yalnızca kaydetmeyi seçtiğin şeyler içe aktarılır. Memoir mesajlaşma uygulamalarının veritabanlarını okumaz.';

  @override
  String get developer => 'Geliştirici';

  @override
  String get openProfile => 'Geliştirici profilini aç';

  @override
  String get linkFailed => 'Bu bağlantı açılamadı.';

  @override
  String get lockNeedsScreenLock =>
      'Önce bu telefonda bir ekran kilidi (PIN, desen veya parmak izi) ayarla.';

  @override
  String get lockNotUnlocked => 'Kilit açılmadı.';

  @override
  String get lockTooManyAttempts =>
      'Çok fazla deneme. Daha sonra tekrar dene veya PIN\'ini kullan.';

  @override
  String lockFailed(String code) {
    return 'Kilit açılamadı: $code';
  }

  @override
  String get lockConfirmEnable => 'Memoir\'i kilitlemek için onayla';

  @override
  String get lockConfirmDisable => 'Kilidi kaldırmak için onayla';

  @override
  String get lockUnlockReason => 'Memoir\'in kilidini aç';

  @override
  String get lockedTitle => 'Memoir kilitli';

  @override
  String get lockedSubtitle =>
      'Telefonunun PIN\'ini, desenini veya parmak izini kullan';

  @override
  String get unlock => 'Kilidi aç';
}
