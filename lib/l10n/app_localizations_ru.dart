// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get navMemories => 'Воспоминания';

  @override
  String get navDrive => 'Google Диск';

  @override
  String get navSettings => 'Настройки';

  @override
  String get archiveSubtitle => 'Ваши сохранённые моменты';

  @override
  String get newCollection => 'Новая коллекция';

  @override
  String get searchHint => 'Поиск по архиву';

  @override
  String archiveError(String error) {
    return 'Не удалось открыть архив: $error';
  }

  @override
  String get noMatches => 'Ничего не найдено';

  @override
  String get addToVault => 'Добавить';

  @override
  String get noMessagesYet => 'Сообщений пока нет';

  @override
  String get photo => 'Фото';

  @override
  String get file => 'Файл';

  @override
  String get video => 'Видео';

  @override
  String get emptyTitle => 'Здесь начинается ваш архив';

  @override
  String get emptyBody =>
      'Сохраните заметку, ссылку, фото или любой файл. Всё остаётся на этом устройстве.';

  @override
  String get savedLink => 'Сохранённая ссылка';

  @override
  String get savedNote => 'Сохранённая заметка';

  @override
  String get attachment => 'Вложение';

  @override
  String get pin => 'Закрепить';

  @override
  String get unpin => 'Открепить';

  @override
  String get favorite => 'В избранное';

  @override
  String get removeFavorite => 'Убрать из избранного';

  @override
  String get savedToMemoir => 'Сохранено в Memoir';

  @override
  String get saveSomething => 'Сохранить';

  @override
  String get writeNote => 'Написать заметку или вставить текст';

  @override
  String get chooseFiles => 'Выбрать файлы';

  @override
  String get chooseFilesSubtitle => 'Фото, видео, PDF и другое';

  @override
  String get newItem => 'Новая запись';

  @override
  String get newItemHint => 'Напишите или вставьте текст или ссылку';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get create => 'Создать';

  @override
  String get collectionName => 'Название коллекции';

  @override
  String filesSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count файлов сохранено на этом устройстве',
      few: '$count файла сохранены на этом устройстве',
      one: '1 файл сохранён на этом устройстве',
    );
    return '$_temp0';
  }

  @override
  String importFailed(String error) {
    return 'Не удалось импортировать файлы: $error';
  }

  @override
  String createCollectionFailed(String error) {
    return 'Не удалось создать коллекцию: $error';
  }

  @override
  String get collectionAll => 'Все записи';

  @override
  String get collectionTelegram => 'Сохранённое из Telegram';

  @override
  String get collectionWhatsapp => 'Архив WhatsApp';

  @override
  String get collectionFacebook => 'Архив Facebook';

  @override
  String get collectionInstagram => 'Архив Instagram';

  @override
  String get collectionPersonal => 'Личный архив';

  @override
  String get chat => 'Чат';

  @override
  String get copy => 'Копировать';

  @override
  String get saveToGallery => 'Сохранить в галерею';

  @override
  String get saveToDevice => 'Сохранить на устройство';

  @override
  String saveAllToGallery(int count) {
    return 'Сохранить все ($count) в галерею';
  }

  @override
  String get delete => 'Удалить';

  @override
  String get deleteTitle => 'Удалить сообщение?';

  @override
  String get deleteBody =>
      'Оно будет удалено с этого устройства. Копия, уже сохранённая на Google Диске, не удаляется.';

  @override
  String get allowPhotos =>
      'Разрешите Memoir доступ к фото, чтобы сохранить их.';

  @override
  String get nothingSaved => 'Ничего не сохранено';

  @override
  String savedToDevice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сохранено элементов: $count',
      one: 'Сохранён 1 элемент',
    );
    return '$_temp0';
  }

  @override
  String saveFailed(String error) {
    return 'Не удалось сохранить: $error';
  }

  @override
  String savedInChat(int count) {
    return 'Сохранено: $count';
  }

  @override
  String get today => 'Сегодня';

  @override
  String get pinnedMessage => 'Закреплённое сообщение';

  @override
  String get emptyChatTitle => 'Здесь пока нет сообщений';

  @override
  String get emptyChatBody =>
      'Напишите сообщение или прикрепите файлы, чтобы сохранить их.';

  @override
  String get composerMessage => 'Сообщение';

  @override
  String get composerMessageEllipsis => 'Сообщение...';

  @override
  String get send => 'Отправить';

  @override
  String photosCount(int count) {
    return 'Фото: $count';
  }

  @override
  String viewerPosition(int index, int total) {
    return '$index из $total';
  }

  @override
  String get play => 'Воспроизвести';

  @override
  String get openWith => 'Открыть в другом приложении';

  @override
  String get openInDrive => 'Открыть в Google Диске';

  @override
  String get noAppToOpen =>
      'На этом телефоне нет приложения, которое может открыть этот файл.';

  @override
  String get couldNotOpen => 'Не удалось открыть этот файл.';

  @override
  String get videoLoadFailed =>
      'Это видео нельзя воспроизвести здесь. Попробуйте открыть его в другом приложении.';

  @override
  String get noInternet =>
      'Нет подключения к интернету. Проверьте соединение и повторите попытку.';

  @override
  String signInClosed(String details) {
    return 'Вход через Google закрыт или отклонён. Если вы его не отменяли, попробуйте снова.$details';
  }

  @override
  String signInMisconfigured(String details) {
    return 'Вход через Google настроен неверно (клиент OAuth / SHA-1).$details';
  }

  @override
  String signInUiUnavailable(String details) {
    return 'Не удалось показать окно входа Google. Попробуйте снова.$details';
  }

  @override
  String signInInterrupted(String details) {
    return 'Вход через Google прерван. Попробуйте снова.$details';
  }

  @override
  String signInFailed(String code, String details) {
    return 'Ошибка входа через Google: $code$details';
  }

  @override
  String get drivePermissionDenied => 'Доступ к Google Диску отклонён.';

  @override
  String get reconnectRequired =>
      'Сеанс Google истёк или доступ к Диску был отозван. Подключитесь снова, чтобы продолжить резервное копирование.';

  @override
  String get backupBusy =>
      'Резервное копирование уже выполняется. Попробуйте чуть позже.';

  @override
  String connectedTo(String email) {
    return 'Подключено: $email';
  }

  @override
  String get everythingBackedUp => 'Всё уже сохранено в резервной копии';

  @override
  String backedUpNew(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сохранено новых записей: $count',
      one: 'Сохранена 1 новая запись',
    );
    return '$_temp0';
  }

  @override
  String alreadyUpToDate(int count) {
    return 'уже актуальны: $count';
  }

  @override
  String skippedMissing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'пропущено отсутствующих файлов: $count',
      one: 'пропущен 1 отсутствующий файл',
    );
    return '$_temp0';
  }

  @override
  String get exportFromMemoir => 'Экспорт из Memoir';

  @override
  String get exportCancelled => 'Экспорт отменён.';

  @override
  String savedForTransfer(String name) {
    return 'Сохранено для переноса: $name';
  }

  @override
  String get thisDevice => 'Это устройство';

  @override
  String get localAvailable =>
      'Ваш архив хранится на устройстве и доступен без интернета.';

  @override
  String get available => 'Доступно';

  @override
  String get yourBackup => 'Ваша резервная копия';

  @override
  String get connected => 'Подключено';

  @override
  String get reconnectNeeded => 'Нужно переподключиться';

  @override
  String get notConnected => 'Не подключено';

  @override
  String get automaticBackup => 'Автоматическое копирование';

  @override
  String get automaticBackupSubtitle =>
      'Загружать новые записи ежедневно при наличии интернета';

  @override
  String get backupTime => 'Время копирования';

  @override
  String get lastBackupNever => 'Последняя копия: ещё нет';

  @override
  String lastBackupAt(String date) {
    return 'Последняя копия: $date';
  }

  @override
  String get iosScheduleNote =>
      'iOS не позволяет приложениям запускаться в заданное время. Копирование выполнится, когда вы в следующий раз откроете Memoir после этого времени.';

  @override
  String get androidScheduleNote =>
      'Android может выполнить его позже выбранного времени, чтобы сэкономить заряд, или дождаться подключения к сети. Принудительная остановка Memoir приостанавливает его до следующего запуска.';

  @override
  String get showDriveFiles => 'Показать файлы Диска';

  @override
  String get backUpArchive => 'Создать резервную копию';

  @override
  String get disconnect => 'Отключить';

  @override
  String get reconnect => 'Подключить снова';

  @override
  String get connectPrompt =>
      'Выберите аккаунт Google, чтобы создать папки Memoir и разрешить доступ к Диску.';

  @override
  String get continueWithGoogle => 'Продолжить с Google';

  @override
  String backingUpProgress(int done, int total) {
    return 'Копирование $done из $total…';
  }

  @override
  String get organizedInDrive => 'Упорядочено на вашем Диске';

  @override
  String get transferHint =>
      'Чтобы перейти на другой телефон, установите на нём Memoir и войдите с тем же аккаунтом Google: Memoir предложит восстановить копию.';

  @override
  String driveFilesCount(int count) {
    return 'Файлы Диска ($count)';
  }

  @override
  String get download => 'Скачать';

  @override
  String get showDriveFilesHint =>
      'Нажмите «Показать файлы Диска», чтобы увидеть всё, что сохранил Memoir.';

  @override
  String get driveStorageNote =>
      'Ваш архив хранится в папке Memoir на вашем Google Диске. Войдите в другой аккаунт Google, чтобы создать там отдельный упорядоченный архив.';

  @override
  String get problemOffline =>
      'Нет подключения к интернету. Memoir повторит попытку автоматически.';

  @override
  String get problemTimeout =>
      'Истекло время ожидания. Memoir повторит попытку автоматически.';

  @override
  String get problemConnectionFailed =>
      'Сбой подключения. Memoir повторит попытку автоматически.';

  @override
  String get problemGoogleUnreachable =>
      'Google недоступен. Memoir повторит попытку автоматически.';

  @override
  String problemRetry(String message) {
    return '$message Memoir повторит попытку автоматически.';
  }

  @override
  String restoreFoundTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'На вашем Диске найдено сохранённых записей: $count',
      one: 'На вашем Диске найдена 1 сохранённая запись',
    );
    return '$_temp0';
  }

  @override
  String get restoreFoundBody =>
      'Они были ранее сохранены из Memoir, но отсутствуют на этом телефоне. Восстановить их в чаты?';

  @override
  String get restore => 'Восстановить';

  @override
  String get notNow => 'Не сейчас';

  @override
  String restoringProgress(int done, int total) {
    return 'Восстановление $done из $total…';
  }

  @override
  String restoredCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Восстановлено записей: $count',
      one: 'Восстановлена 1 запись',
    );
    return '$_temp0';
  }

  @override
  String get restoredCollection => 'Восстановлено';

  @override
  String get settings => 'Настройки';

  @override
  String get appearance => 'Оформление';

  @override
  String get appearanceSubtitle => 'Системная, светлая или тёмная тема';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get language => 'Язык';

  @override
  String get languageSystem => 'Язык телефона';

  @override
  String get appLock => 'Блокировка приложения';

  @override
  String get appLockSubtitle =>
      'Разблокировка Memoir PIN-кодом, графическим ключом или отпечатком пальца';

  @override
  String get driveBackup => 'Резервная копия на Google Диске';

  @override
  String get driveBackupSubtitle =>
      'Подключите аккаунт, чтобы упорядочить и просматривать копии';

  @override
  String get onDeviceArchive => 'Архив на устройстве';

  @override
  String get onDeviceArchiveSubtitle =>
      'Ваши воспоминания доступны на этом устройстве без интернета.';

  @override
  String get privacy => 'Конфиденциальность';

  @override
  String get privacySubtitle =>
      'Импортируется только то, что вы сами сохраняете. Memoir не читает базы данных мессенджеров.';

  @override
  String get developer => 'Разработчик';

  @override
  String get openProfile => 'Открыть профиль разработчика';

  @override
  String get linkFailed => 'Не удалось открыть ссылку.';

  @override
  String get lockNeedsScreenLock =>
      'Сначала установите блокировку экрана (PIN-код, ключ или отпечаток) на этом телефоне.';

  @override
  String get lockNotUnlocked => 'Не разблокировано.';

  @override
  String get lockTooManyAttempts =>
      'Слишком много попыток. Повторите позже или используйте PIN-код.';

  @override
  String lockFailed(String code) {
    return 'Не удалось разблокировать: $code';
  }

  @override
  String get lockConfirmEnable => 'Подтвердите, чтобы заблокировать Memoir';

  @override
  String get lockConfirmDisable => 'Подтвердите, чтобы снять блокировку';

  @override
  String get lockUnlockReason => 'Разблокировать Memoir';

  @override
  String get lockedTitle => 'Memoir заблокирован';

  @override
  String get lockedSubtitle =>
      'Используйте PIN-код, графический ключ или отпечаток пальца';

  @override
  String get unlock => 'Разблокировать';

  @override
  String updateAvailableTitle(String version) {
    return 'Доступна версия $version';
  }

  @override
  String get updateAvailableBody =>
      'Готова новая версия Memoir. Скачайте её и установите поверх текущей — ваши воспоминания останутся на телефоне.';

  @override
  String get updateDownload => 'Скачать';

  @override
  String get updateLater => 'Позже';

  @override
  String get checkForUpdates => 'Проверить обновления';

  @override
  String currentVersion(String version) {
    return 'Версия $version';
  }

  @override
  String get upToDate => 'У вас последняя версия.';

  @override
  String get updateCheckFailed =>
      'Не удалось проверить обновления. Проверьте подключение к интернету.';

  @override
  String get addAccount => 'Добавить ещё аккаунт Google';

  @override
  String get removeAccount => 'Удалить аккаунт';

  @override
  String removeAccountTitle(String email) {
    return 'Удалить $email?';
  }

  @override
  String get removeAccountBody =>
      'Memoir перестанет копировать в этот аккаунт. Файлы, уже лежащие на его Диске, останутся там.';

  @override
  String get backupToAllAccounts =>
      'Каждая копия сохраняется во все аккаунты выше, поэтому воспоминания будут в безопасности, даже если вы потеряете один из них.';

  @override
  String get shareSaveTo => 'Сохранить в Memoir';

  @override
  String shareItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count элементов',
      few: '$count элемента',
      one: '1 элемент',
    );
    return '$_temp0';
  }

  @override
  String sharedSaved(String name) {
    return 'Сохранено в «$name»';
  }

  @override
  String get recentlyDeleted => 'Недавно удалённые';

  @override
  String get recentlyDeletedSubtitle => 'Удалённое хранится здесь 30 дней';

  @override
  String get trashEmpty => 'Здесь пусто';

  @override
  String get deleteForever => 'Удалить навсегда';

  @override
  String get emptyTrash => 'Очистить';

  @override
  String get emptyTrashTitle => 'Удалить всё навсегда?';

  @override
  String get emptyTrashBody =>
      'Они будут удалены с этого телефона. Копии на Google Диске останутся.';

  @override
  String deletedOn(String date) {
    return 'Удалено $date';
  }

  @override
  String get movedToTrash => 'Перемещено в «Недавно удалённые»';

  @override
  String get undo => 'Отменить';
}
