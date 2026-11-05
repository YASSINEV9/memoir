// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get navMemories => 'الذكريات';

  @override
  String get navDrive => 'Google Drive';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get archiveSubtitle => 'لحظاتك المحفوظة';

  @override
  String get newCollection => 'مجموعة جديدة';

  @override
  String get searchHint => 'ابحث في أرشيفك';

  @override
  String archiveError(String error) {
    return 'تعذّر فتح الأرشيف: $error';
  }

  @override
  String get noMatches => 'لا توجد نتائج';

  @override
  String get addToVault => 'أضف إلى الأرشيف';

  @override
  String get noMessagesYet => 'لا توجد رسائل بعد';

  @override
  String get photo => 'صورة';

  @override
  String get file => 'ملف';

  @override
  String get video => 'فيديو';

  @override
  String get emptyTitle => 'أرشيفك يبدأ من هنا';

  @override
  String get emptyBody =>
      'احفظ ملاحظة أو رابطًا أو صورة أو أي ملف. تبقى عناصرك على هذا الجهاز.';

  @override
  String get savedLink => 'رابط محفوظ';

  @override
  String get savedNote => 'ملاحظة محفوظة';

  @override
  String get attachment => 'مرفق';

  @override
  String get pin => 'تثبيت';

  @override
  String get unpin => 'إلغاء التثبيت';

  @override
  String get favorite => 'مفضّلة';

  @override
  String get removeFavorite => 'إزالة من المفضّلة';

  @override
  String get savedToMemoir => 'محفوظ في Memoir';

  @override
  String get saveSomething => 'احفظ شيئًا';

  @override
  String get writeNote => 'اكتب ملاحظة أو الصق نصًا';

  @override
  String get chooseFiles => 'اختر ملفات';

  @override
  String get chooseFilesSubtitle => 'صور، فيديوهات، ملفات PDF والمزيد';

  @override
  String get newItem => 'عنصر جديد';

  @override
  String get newItemHint => 'اكتب أو الصق نصًا أو رابطًا';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get create => 'إنشاء';

  @override
  String get collectionName => 'اسم المجموعة';

  @override
  String filesSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم حفظ $count ملفات على هذا الجهاز',
      two: 'تم حفظ ملفين على هذا الجهاز',
      one: 'تم حفظ ملف واحد على هذا الجهاز',
    );
    return '$_temp0';
  }

  @override
  String importFailed(String error) {
    return 'تعذّر استيراد الملفات: $error';
  }

  @override
  String createCollectionFailed(String error) {
    return 'تعذّر إنشاء المجموعة: $error';
  }

  @override
  String get collectionAll => 'كل العناصر';

  @override
  String get collectionTelegram => 'محفوظات تيليجرام';

  @override
  String get collectionWhatsapp => 'أرشيف واتساب';

  @override
  String get collectionFacebook => 'أرشيف فيسبوك';

  @override
  String get collectionInstagram => 'أرشيف إنستغرام';

  @override
  String get collectionPersonal => 'الأرشيف الشخصي';

  @override
  String get chat => 'محادثة';

  @override
  String get copy => 'نسخ';

  @override
  String get saveToGallery => 'حفظ في المعرض';

  @override
  String get saveToDevice => 'حفظ على الجهاز';

  @override
  String saveAllToGallery(int count) {
    return 'حفظ الكل ($count) في المعرض';
  }

  @override
  String get delete => 'حذف';

  @override
  String get deleteTitle => 'حذف الرسالة؟';

  @override
  String get deleteBody =>
      'ستُحذف من هذا الجهاز. النسخة المحفوظة سابقًا في Google Drive لن تُحذف.';

  @override
  String get allowPhotos => 'اسمح لـ Memoir بالوصول إلى صورك لحفظها.';

  @override
  String get nothingSaved => 'لم يُحفظ شيء';

  @override
  String savedToDevice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم حفظ $count عناصر على جهازك',
      one: 'تم حفظ عنصر واحد على جهازك',
    );
    return '$_temp0';
  }

  @override
  String saveFailed(String error) {
    return 'تعذّر الحفظ: $error';
  }

  @override
  String savedInChat(int count) {
    return '$count محفوظ';
  }

  @override
  String get today => 'اليوم';

  @override
  String get pinnedMessage => 'رسالة مثبّتة';

  @override
  String get emptyChatTitle => 'لا توجد رسائل هنا بعد';

  @override
  String get emptyChatBody => 'اكتب رسالة أو أرفق ملفات لحفظها.';

  @override
  String get composerMessage => 'رسالة';

  @override
  String get composerMessageEllipsis => 'رسالة...';

  @override
  String get send => 'إرسال';

  @override
  String photosCount(int count) {
    return '$count صور';
  }

  @override
  String viewerPosition(int index, int total) {
    return '$index من $total';
  }

  @override
  String get play => 'تشغيل';

  @override
  String get openWith => 'فتح بتطبيق آخر';

  @override
  String get openInDrive => 'فتح في Google Drive';

  @override
  String get noAppToOpen =>
      'لا يوجد تطبيق على هذا الهاتف يستطيع فتح هذا الملف.';

  @override
  String get couldNotOpen => 'تعذّر فتح هذا الملف.';

  @override
  String get videoLoadFailed =>
      'تعذّر تشغيل هذا الفيديو هنا. جرّب فتحه بتطبيق آخر.';

  @override
  String get noInternet =>
      'لا يوجد اتصال بالإنترنت. تحقّق من اتصالك وحاول مجددًا.';

  @override
  String signInClosed(String details) {
    return 'أُغلق تسجيل الدخول بجوجل أو رُفض. إن لم تلغِه أنت، حاول مجددًا.$details';
  }

  @override
  String signInMisconfigured(String details) {
    return 'إعدادات تسجيل الدخول بجوجل غير صحيحة (OAuth / SHA-1).$details';
  }

  @override
  String signInUiUnavailable(String details) {
    return 'تعذّر عرض نافذة تسجيل الدخول بجوجل. حاول مجددًا.$details';
  }

  @override
  String signInInterrupted(String details) {
    return 'انقطع تسجيل الدخول بجوجل. حاول مجددًا.$details';
  }

  @override
  String signInFailed(String code, String details) {
    return 'فشل تسجيل الدخول بجوجل: $code$details';
  }

  @override
  String get drivePermissionDenied => 'تم رفض صلاحية Google Drive.';

  @override
  String get reconnectRequired =>
      'انتهت جلسة جوجل أو أُزيلت صلاحية Drive. أعد الاتصال لمتابعة النسخ الاحتياطي.';

  @override
  String get backupBusy => 'يوجد نسخ احتياطي قيد التشغيل. حاول بعد لحظة.';

  @override
  String connectedTo(String email) {
    return 'متصل بـ $email';
  }

  @override
  String get everythingBackedUp => 'كل شيء منسوخ احتياطيًا بالفعل';

  @override
  String backedUpNew(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم نسخ $count عناصر جديدة',
      one: 'تم نسخ عنصر جديد واحد',
    );
    return '$_temp0';
  }

  @override
  String alreadyUpToDate(int count) {
    return '$count محدّثة مسبقًا';
  }

  @override
  String skippedMissing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم تخطّي $count ملفات مفقودة',
      one: 'تم تخطّي ملف مفقود واحد',
    );
    return '$_temp0';
  }

  @override
  String get exportFromMemoir => 'تصدير من Memoir';

  @override
  String get exportCancelled => 'تم إلغاء التصدير.';

  @override
  String savedForTransfer(String name) {
    return 'تم الحفظ للنقل: $name';
  }

  @override
  String get thisDevice => 'هذا الجهاز';

  @override
  String get localAvailable => 'أرشيفك محفوظ على الجهاز ومتاح دون إنترنت.';

  @override
  String get available => 'متاح';

  @override
  String get yourBackup => 'نسختك الاحتياطية';

  @override
  String get connected => 'متصل';

  @override
  String get reconnectNeeded => 'يلزم إعادة الاتصال';

  @override
  String get notConnected => 'غير متصل';

  @override
  String get automaticBackup => 'نسخ احتياطي تلقائي';

  @override
  String get automaticBackupSubtitle =>
      'رفع العناصر الجديدة يوميًا عند توفّر الإنترنت';

  @override
  String get backupTime => 'وقت النسخ الاحتياطي';

  @override
  String get lastBackupNever => 'آخر نسخة: لم تتم بعد';

  @override
  String lastBackupAt(String date) {
    return 'آخر نسخة: $date';
  }

  @override
  String get iosScheduleNote =>
      'نظام iOS لا يسمح للتطبيقات بالعمل في وقت محدد. يتم النسخ عند فتح Memoir في المرة التالية بعد هذا الوقت.';

  @override
  String get androidScheduleNote =>
      'قد يؤخّر أندرويد النسخ عن الوقت المحدد لتوفير البطارية، أو ينتظر اتصال الهاتف بالإنترنت. إيقاف Memoir بالقوة يوقف النسخ حتى تفتح التطبيق مجددًا.';

  @override
  String get showDriveFiles => 'عرض ملفات Drive';

  @override
  String get backUpArchive => 'نسخ الأرشيف احتياطيًا';

  @override
  String get disconnect => 'قطع الاتصال';

  @override
  String get reconnect => 'إعادة الاتصال';

  @override
  String get connectPrompt =>
      'اختر حساب جوجل لإنشاء مجلدات Memoir والموافقة على الوصول إلى Drive.';

  @override
  String get continueWithGoogle => 'المتابعة باستخدام جوجل';

  @override
  String backingUpProgress(int done, int total) {
    return 'جارٍ نسخ $done من $total…';
  }

  @override
  String get organizedInDrive => 'منظّم في Drive الخاص بك';

  @override
  String get transferHint =>
      'للانتقال إلى هاتف آخر، ثبّت Memoir عليه وسجّل الدخول بنفس حساب جوجل: سيعرض عليك Memoir استرجاع نسختك.';

  @override
  String driveFilesCount(int count) {
    return 'ملفات Drive ($count)';
  }

  @override
  String get download => 'تنزيل';

  @override
  String get showDriveFilesHint =>
      'اختر «عرض ملفات Drive» لرؤية كل ما نسخه Memoir.';

  @override
  String get driveStorageNote =>
      'أرشيفك محفوظ داخل مجلد Memoir في Google Drive الخاص بك. سجّل الدخول بحساب جوجل آخر لإنشاء أرشيف منفصل ومنظّم هناك.';

  @override
  String get problemOffline =>
      'لا يوجد اتصال بالإنترنت. سيعيد Memoir المحاولة تلقائيًا.';

  @override
  String get problemTimeout =>
      'انتهت مهلة الاتصال. سيعيد Memoir المحاولة تلقائيًا.';

  @override
  String get problemConnectionFailed =>
      'فشل الاتصال. سيعيد Memoir المحاولة تلقائيًا.';

  @override
  String get problemGoogleUnreachable =>
      'تعذّر الوصول إلى جوجل. سيعيد Memoir المحاولة تلقائيًا.';

  @override
  String problemRetry(String message) {
    return '$message سيعيد Memoir المحاولة تلقائيًا.';
  }

  @override
  String restoreFoundTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'وُجد $count عنصر محفوظ في Drive الخاص بك',
      one: 'وُجد عنصر محفوظ واحد في Drive الخاص بك',
    );
    return '$_temp0';
  }

  @override
  String get restoreFoundBody =>
      'هذه العناصر نُسخت سابقًا من Memoir لكنها غير موجودة على هذا الهاتف. هل تريد استرجاعها إلى محادثاتها؟';

  @override
  String get restore => 'استرجاع';

  @override
  String get notNow => 'ليس الآن';

  @override
  String restoringProgress(int done, int total) {
    return 'جارٍ استرجاع $done من $total…';
  }

  @override
  String restoredCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم استرجاع $count عناصر',
      one: 'تم استرجاع عنصر واحد',
    );
    return '$_temp0';
  }

  @override
  String get restoredCollection => 'مُسترجع';

  @override
  String get settings => 'الإعدادات';

  @override
  String get appearance => 'المظهر';

  @override
  String get appearanceSubtitle => 'اختر مظهر النظام أو الفاتح أو الداكن';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get language => 'اللغة';

  @override
  String get languageSystem => 'لغة الهاتف';

  @override
  String get appLock => 'قفل التطبيق';

  @override
  String get appLockSubtitle =>
      'افتح Memoir برمز هاتفك أو النمط أو بصمة الإصبع';

  @override
  String get driveBackup => 'النسخ الاحتياطي إلى Google Drive';

  @override
  String get driveBackupSubtitle => 'اربط حسابك لتنظيم نسخك وتصفّحها';

  @override
  String get onDeviceArchive => 'الأرشيف على الجهاز';

  @override
  String get onDeviceArchiveSubtitle =>
      'تبقى ذكرياتك متاحة دون إنترنت على هذا الجهاز.';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get privacySubtitle =>
      'لا يُحفظ شيء إلا ما تختاره أنت. Memoir لا يقرأ قواعد بيانات تطبيقات المراسلة.';

  @override
  String get developer => 'المطوّر';

  @override
  String get openProfile => 'فتح صفحة المطوّر';

  @override
  String get linkFailed => 'تعذّر فتح هذا الرابط.';

  @override
  String get lockNeedsScreenLock =>
      'اضبط قفل شاشة (رمز أو نمط أو بصمة) على هذا الهاتف أولًا.';

  @override
  String get lockNotUnlocked => 'لم يتم فتح القفل.';

  @override
  String get lockTooManyAttempts =>
      'محاولات كثيرة. حاول لاحقًا أو استخدم الرمز.';

  @override
  String lockFailed(String code) {
    return 'تعذّر فتح القفل: $code';
  }

  @override
  String get lockConfirmEnable => 'أكّد لقفل Memoir';

  @override
  String get lockConfirmDisable => 'أكّد لإزالة القفل';

  @override
  String get lockUnlockReason => 'افتح Memoir';

  @override
  String get lockedTitle => 'Memoir مقفل';

  @override
  String get lockedSubtitle => 'استخدم رمز هاتفك أو النمط أو بصمة الإصبع';

  @override
  String get unlock => 'فتح القفل';
}
