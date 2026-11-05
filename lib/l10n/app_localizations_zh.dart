// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get navMemories => '回忆';

  @override
  String get navDrive => 'Google 云端硬盘';

  @override
  String get navSettings => '设置';

  @override
  String get archiveSubtitle => '你保存的瞬间';

  @override
  String get newCollection => '新建合集';

  @override
  String get searchHint => '搜索你的存档';

  @override
  String archiveError(String error) {
    return '无法打开存档：$error';
  }

  @override
  String get noMatches => '没有结果';

  @override
  String get addToVault => '添加';

  @override
  String get noMessagesYet => '暂无消息';

  @override
  String get photo => '照片';

  @override
  String get file => '文件';

  @override
  String get video => '视频';

  @override
  String get emptyTitle => '你的存档从这里开始';

  @override
  String get emptyBody => '保存笔记、链接、照片或任何文件。内容只保存在这台设备上。';

  @override
  String get savedLink => '已保存的链接';

  @override
  String get savedNote => '已保存的笔记';

  @override
  String get attachment => '附件';

  @override
  String get pin => '置顶';

  @override
  String get unpin => '取消置顶';

  @override
  String get favorite => '收藏';

  @override
  String get removeFavorite => '取消收藏';

  @override
  String get savedToMemoir => '已保存到 Memoir';

  @override
  String get saveSomething => '保存内容';

  @override
  String get writeNote => '写笔记或粘贴文本';

  @override
  String get chooseFiles => '选择文件';

  @override
  String get chooseFilesSubtitle => '照片、视频、PDF 等';

  @override
  String get newItem => '新内容';

  @override
  String get newItemHint => '输入或粘贴文本或链接';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get create => '创建';

  @override
  String get collectionName => '合集名称';

  @override
  String filesSaved(int count) {
    return '已将 $count 个文件保存到这台设备';
  }

  @override
  String importFailed(String error) {
    return '无法导入文件：$error';
  }

  @override
  String createCollectionFailed(String error) {
    return '无法创建合集：$error';
  }

  @override
  String get collectionAll => '全部内容';

  @override
  String get collectionTelegram => 'Telegram 收藏';

  @override
  String get collectionWhatsapp => 'WhatsApp 存档';

  @override
  String get collectionFacebook => 'Facebook 存档';

  @override
  String get collectionInstagram => 'Instagram 存档';

  @override
  String get collectionPersonal => '个人存档';

  @override
  String get chat => '聊天';

  @override
  String get copy => '复制';

  @override
  String get saveToGallery => '保存到相册';

  @override
  String get saveToDevice => '保存到设备';

  @override
  String saveAllToGallery(int count) {
    return '将全部 $count 项保存到相册';
  }

  @override
  String get delete => '删除';

  @override
  String get deleteTitle => '删除这条消息？';

  @override
  String get deleteBody => '它将从这台设备上删除。已备份到 Google 云端硬盘的副本不会被删除。';

  @override
  String get allowPhotos => '请允许 Memoir 访问你的照片以便保存。';

  @override
  String get nothingSaved => '未保存任何内容';

  @override
  String savedToDevice(int count) {
    return '已将 $count 项保存到你的设备';
  }

  @override
  String saveFailed(String error) {
    return '无法保存：$error';
  }

  @override
  String savedInChat(int count) {
    return '已保存 $count 条';
  }

  @override
  String get today => '今天';

  @override
  String get pinnedMessage => '置顶消息';

  @override
  String get emptyChatTitle => '这里还没有消息';

  @override
  String get emptyChatBody => '输入消息或添加文件来保存。';

  @override
  String get composerMessage => '消息';

  @override
  String get composerMessageEllipsis => '消息...';

  @override
  String get send => '发送';

  @override
  String photosCount(int count) {
    return '$count 张照片';
  }

  @override
  String viewerPosition(int index, int total) {
    return '第 $index / $total 张';
  }

  @override
  String get play => '播放';

  @override
  String get openWith => '用其他应用打开';

  @override
  String get openInDrive => '在 Google 云端硬盘中打开';

  @override
  String get noAppToOpen => '这台手机上没有可以打开此文件的应用。';

  @override
  String get couldNotOpen => '无法打开此文件。';

  @override
  String get videoLoadFailed => '此视频无法在这里播放。请尝试用其他应用打开。';

  @override
  String get noInternet => '没有网络连接。请检查网络后重试。';

  @override
  String signInClosed(String details) {
    return 'Google 登录已关闭或被拒绝。如果不是你取消的，请重试。$details';
  }

  @override
  String signInMisconfigured(String details) {
    return 'Google 登录配置有误（OAuth 客户端 / SHA-1）。$details';
  }

  @override
  String signInUiUnavailable(String details) {
    return '无法显示 Google 登录窗口。请重试。$details';
  }

  @override
  String signInInterrupted(String details) {
    return 'Google 登录被中断。请重试。$details';
  }

  @override
  String signInFailed(String code, String details) {
    return 'Google 登录失败：$code$details';
  }

  @override
  String get drivePermissionDenied => 'Google 云端硬盘权限被拒绝。';

  @override
  String get reconnectRequired => '你的 Google 会话已过期或云端硬盘访问权限已被移除。请重新连接以继续备份。';

  @override
  String get backupBusy => '已有备份正在进行。请稍后再试。';

  @override
  String connectedTo(String email) {
    return '已连接到 $email';
  }

  @override
  String get everythingBackedUp => '所有内容都已备份';

  @override
  String backedUpNew(int count) {
    return '已备份 $count 项新内容';
  }

  @override
  String alreadyUpToDate(int count) {
    return '$count 项已是最新';
  }

  @override
  String skippedMissing(int count) {
    return '跳过了 $count 个缺失的文件';
  }

  @override
  String get exportFromMemoir => '从 Memoir 导出';

  @override
  String get exportCancelled => '已取消导出。';

  @override
  String savedForTransfer(String name) {
    return '已保存以便转移：$name';
  }

  @override
  String get thisDevice => '这台设备';

  @override
  String get localAvailable => '你的存档保存在本地，离线也能使用。';

  @override
  String get available => '可用';

  @override
  String get yourBackup => '你的备份';

  @override
  String get connected => '已连接';

  @override
  String get reconnectNeeded => '需要重新连接';

  @override
  String get notConnected => '未连接';

  @override
  String get automaticBackup => '自动备份';

  @override
  String get automaticBackupSubtitle => '有网络时每天上传新内容';

  @override
  String get backupTime => '备份时间';

  @override
  String get lastBackupNever => '上次备份：尚未备份';

  @override
  String lastBackupAt(String date) {
    return '上次备份：$date';
  }

  @override
  String get iosScheduleNote => 'iOS 不允许应用在指定时间运行。备份会在此时间之后你下次打开 Memoir 时进行。';

  @override
  String get androidScheduleNote =>
      '为节省电量，Android 可能会晚于所选时间执行备份，或等到手机联网后再进行。强行停止 Memoir 会暂停备份，直到你再次打开应用。';

  @override
  String get showDriveFiles => '查看云端硬盘文件';

  @override
  String get backUpArchive => '备份存档';

  @override
  String get disconnect => '断开连接';

  @override
  String get reconnect => '重新连接';

  @override
  String get connectPrompt => '选择一个 Google 账号来创建 Memoir 文件夹并授权访问云端硬盘。';

  @override
  String get continueWithGoogle => '使用 Google 继续';

  @override
  String backingUpProgress(int done, int total) {
    return '正在备份 $done / $total…';
  }

  @override
  String get organizedInDrive => '已整理到你的云端硬盘';

  @override
  String get transferHint =>
      '换新手机时，在新手机上安装 Memoir 并用同一个 Google 账号登录：Memoir 会提示你恢复备份。';

  @override
  String driveFilesCount(int count) {
    return '云端硬盘文件（$count）';
  }

  @override
  String get download => '下载';

  @override
  String get showDriveFilesHint => '选择“查看云端硬盘文件”可查看 Memoir 备份的所有内容。';

  @override
  String get driveStorageNote =>
      '你的存档保存在 Google 云端硬盘的 Memoir 文件夹中。登录另一个 Google 账号即可在那里创建独立、整齐的存档。';

  @override
  String get problemOffline => '没有网络连接。Memoir 会自动重试。';

  @override
  String get problemTimeout => '连接超时。Memoir 会自动重试。';

  @override
  String get problemConnectionFailed => '连接失败。Memoir 会自动重试。';

  @override
  String get problemGoogleUnreachable => '无法连接到 Google。Memoir 会自动重试。';

  @override
  String problemRetry(String message) {
    return '$message Memoir 会自动重试。';
  }

  @override
  String restoreFoundTitle(int count) {
    return '在你的云端硬盘中找到 $count 项已保存的内容';
  }

  @override
  String get restoreFoundBody => '这些内容之前由 Memoir 备份过，但不在这台手机上。要恢复到对应的聊天中吗？';

  @override
  String get restore => '恢复';

  @override
  String get notNow => '以后再说';

  @override
  String restoringProgress(int done, int total) {
    return '正在恢复 $done / $total…';
  }

  @override
  String restoredCount(int count) {
    return '已恢复 $count 项';
  }

  @override
  String get restoredCollection => '已恢复';

  @override
  String get settings => '设置';

  @override
  String get appearance => '外观';

  @override
  String get appearanceSubtitle => '选择跟随系统、浅色或深色主题';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get language => '语言';

  @override
  String get languageSystem => '手机语言';

  @override
  String get appLock => '应用锁';

  @override
  String get appLockSubtitle => '使用手机的 PIN 码、图案或指纹解锁 Memoir';

  @override
  String get driveBackup => 'Google 云端硬盘备份';

  @override
  String get driveBackupSubtitle => '连接账号以整理和浏览你的副本';

  @override
  String get onDeviceArchive => '设备上的存档';

  @override
  String get onDeviceArchiveSubtitle => '你的回忆在这台设备上离线也能使用。';

  @override
  String get privacy => '隐私';

  @override
  String get privacySubtitle => '只会导入你选择保存的内容。Memoir 不会读取聊天应用的数据库。';

  @override
  String get developer => '开发者';

  @override
  String get openProfile => '打开开发者主页';

  @override
  String get linkFailed => '无法打开此链接。';

  @override
  String get lockNeedsScreenLock => '请先在这台手机上设置屏幕锁（PIN 码、图案或指纹）。';

  @override
  String get lockNotUnlocked => '未解锁。';

  @override
  String get lockTooManyAttempts => '尝试次数过多。请稍后再试或使用 PIN 码。';

  @override
  String lockFailed(String code) {
    return '无法解锁：$code';
  }

  @override
  String get lockConfirmEnable => '确认以锁定 Memoir';

  @override
  String get lockConfirmDisable => '确认以移除锁定';

  @override
  String get lockUnlockReason => '解锁 Memoir';

  @override
  String get lockedTitle => 'Memoir 已锁定';

  @override
  String get lockedSubtitle => '使用手机的 PIN 码、图案或指纹';

  @override
  String get unlock => '解锁';
}
