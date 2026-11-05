// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get navMemories => '思い出';

  @override
  String get navDrive => 'Google ドライブ';

  @override
  String get navSettings => '設定';

  @override
  String get archiveSubtitle => '保存した大切な瞬間';

  @override
  String get newCollection => '新しいコレクション';

  @override
  String get searchHint => 'アーカイブを検索';

  @override
  String archiveError(String error) {
    return 'アーカイブを開けませんでした：$error';
  }

  @override
  String get noMatches => '見つかりません';

  @override
  String get addToVault => '追加';

  @override
  String get noMessagesYet => 'まだメッセージはありません';

  @override
  String get photo => '写真';

  @override
  String get file => 'ファイル';

  @override
  String get video => '動画';

  @override
  String get emptyTitle => 'アーカイブはここから';

  @override
  String get emptyBody => 'メモ、リンク、写真、どんなファイルでも保存できます。データはこの端末に保存されます。';

  @override
  String get savedLink => '保存したリンク';

  @override
  String get savedNote => '保存したメモ';

  @override
  String get attachment => '添付ファイル';

  @override
  String get pin => '固定';

  @override
  String get unpin => '固定を解除';

  @override
  String get favorite => 'お気に入り';

  @override
  String get removeFavorite => 'お気に入りから外す';

  @override
  String get savedToMemoir => 'Memoir に保存済み';

  @override
  String get saveSomething => '保存する';

  @override
  String get writeNote => 'メモを書く・テキストを貼り付ける';

  @override
  String get chooseFiles => 'ファイルを選ぶ';

  @override
  String get chooseFilesSubtitle => '写真、動画、PDF など';

  @override
  String get newItem => '新しい項目';

  @override
  String get newItemHint => 'テキストやリンクを入力または貼り付け';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get create => '作成';

  @override
  String get collectionName => 'コレクション名';

  @override
  String filesSaved(int count) {
    return '$count 件のファイルをこの端末に保存しました';
  }

  @override
  String importFailed(String error) {
    return 'ファイルを取り込めませんでした：$error';
  }

  @override
  String createCollectionFailed(String error) {
    return 'コレクションを作成できませんでした：$error';
  }

  @override
  String get collectionAll => 'すべての項目';

  @override
  String get collectionTelegram => 'Telegram 保存';

  @override
  String get collectionWhatsapp => 'WhatsApp アーカイブ';

  @override
  String get collectionFacebook => 'Facebook アーカイブ';

  @override
  String get collectionInstagram => 'Instagram アーカイブ';

  @override
  String get collectionPersonal => '個人アーカイブ';

  @override
  String get chat => 'チャット';

  @override
  String get copy => 'コピー';

  @override
  String get saveToGallery => 'ギャラリーに保存';

  @override
  String get saveToDevice => '端末に保存';

  @override
  String saveAllToGallery(int count) {
    return '$count 件すべてをギャラリーに保存';
  }

  @override
  String get delete => '削除';

  @override
  String get deleteTitle => 'メッセージを削除しますか？';

  @override
  String get deleteBody => 'この端末から削除されます。Google ドライブにバックアップ済みのコピーは削除されません。';

  @override
  String get allowPhotos => '保存するには Memoir に写真へのアクセスを許可してください。';

  @override
  String get nothingSaved => '何も保存されませんでした';

  @override
  String savedToDevice(int count) {
    return '$count 件を端末に保存しました';
  }

  @override
  String saveFailed(String error) {
    return '保存できませんでした：$error';
  }

  @override
  String savedInChat(int count) {
    return '$count 件保存済み';
  }

  @override
  String get today => '今日';

  @override
  String get pinnedMessage => '固定されたメッセージ';

  @override
  String get emptyChatTitle => 'まだメッセージはありません';

  @override
  String get emptyChatBody => 'メッセージを入力するか、ファイルを添付して保存しましょう。';

  @override
  String get composerMessage => 'メッセージ';

  @override
  String get composerMessageEllipsis => 'メッセージ...';

  @override
  String get send => '送信';

  @override
  String photosCount(int count) {
    return '写真 $count 枚';
  }

  @override
  String viewerPosition(int index, int total) {
    return '$index / $total';
  }

  @override
  String get play => '再生';

  @override
  String get openWith => '他のアプリで開く';

  @override
  String get openInDrive => 'Google ドライブで開く';

  @override
  String get noAppToOpen => 'このファイルを開けるアプリがこの端末にありません。';

  @override
  String get couldNotOpen => 'このファイルを開けませんでした。';

  @override
  String get videoLoadFailed => 'この動画はここで再生できません。他のアプリで開いてみてください。';

  @override
  String get noInternet => 'インターネットに接続されていません。接続を確認してもう一度お試しください。';

  @override
  String signInClosed(String details) {
    return 'Google ログインが閉じられたか拒否されました。キャンセルしていない場合はもう一度お試しください。$details';
  }

  @override
  String signInMisconfigured(String details) {
    return 'Google ログインの設定が正しくありません（OAuth クライアント / SHA-1）。$details';
  }

  @override
  String signInUiUnavailable(String details) {
    return 'Google ログイン画面を表示できませんでした。もう一度お試しください。$details';
  }

  @override
  String signInInterrupted(String details) {
    return 'Google ログインが中断されました。もう一度お試しください。$details';
  }

  @override
  String signInFailed(String code, String details) {
    return 'Google ログインに失敗しました：$code$details';
  }

  @override
  String get drivePermissionDenied => 'Google ドライブへのアクセスが拒否されました。';

  @override
  String get reconnectRequired =>
      'Google のセッションが切れたか、ドライブへのアクセスが取り消されました。バックアップを続けるには再接続してください。';

  @override
  String get backupBusy => 'バックアップを実行中です。しばらくしてからお試しください。';

  @override
  String connectedTo(String email) {
    return '$email に接続済み';
  }

  @override
  String get everythingBackedUp => 'すべてバックアップ済みです';

  @override
  String backedUpNew(int count) {
    return '新しい項目を $count 件バックアップしました';
  }

  @override
  String alreadyUpToDate(int count) {
    return '$count 件は最新です';
  }

  @override
  String skippedMissing(int count) {
    return '見つからないファイル $count 件をスキップしました';
  }

  @override
  String get exportFromMemoir => 'Memoir から書き出す';

  @override
  String get exportCancelled => '書き出しをキャンセルしました。';

  @override
  String savedForTransfer(String name) {
    return '移行用に保存しました：$name';
  }

  @override
  String get thisDevice => 'この端末';

  @override
  String get localAvailable => 'アーカイブは端末に保存され、オフラインでも使えます。';

  @override
  String get available => '利用可能';

  @override
  String get yourBackup => 'バックアップ';

  @override
  String get connected => '接続済み';

  @override
  String get reconnectNeeded => '再接続が必要';

  @override
  String get notConnected => '未接続';

  @override
  String get automaticBackup => '自動バックアップ';

  @override
  String get automaticBackupSubtitle => 'インターネットに接続中、毎日新しい項目をアップロード';

  @override
  String get backupTime => 'バックアップ時刻';

  @override
  String get lastBackupNever => '前回のバックアップ：まだありません';

  @override
  String lastBackupAt(String date) {
    return '前回のバックアップ：$date';
  }

  @override
  String get iosScheduleNote =>
      'iOS ではアプリを指定時刻に実行できません。この時刻以降に Memoir を開いたときにバックアップされます。';

  @override
  String get androidScheduleNote =>
      'Android はバッテリー節約のため指定時刻より遅れて実行したり、オンラインになるまで待つことがあります。Memoir を強制停止すると、次に開くまで停止します。';

  @override
  String get showDriveFiles => 'ドライブのファイルを表示';

  @override
  String get backUpArchive => 'アーカイブをバックアップ';

  @override
  String get disconnect => '接続を解除';

  @override
  String get reconnect => '再接続';

  @override
  String get connectPrompt =>
      'Google アカウントを選んで Memoir フォルダを作成し、ドライブへのアクセスを許可してください。';

  @override
  String get continueWithGoogle => 'Google で続ける';

  @override
  String backingUpProgress(int done, int total) {
    return 'バックアップ中 $done / $total…';
  }

  @override
  String get organizedInDrive => 'ドライブ内で整理されています';

  @override
  String get transferHint =>
      '別のスマホに移るときは、そこに Memoir を入れて同じ Google アカウントでログインしてください。Memoir がバックアップの復元を提案します。';

  @override
  String driveFilesCount(int count) {
    return 'ドライブのファイル（$count）';
  }

  @override
  String get download => 'ダウンロード';

  @override
  String get showDriveFilesHint =>
      '「ドライブのファイルを表示」で Memoir がバックアップしたすべてを確認できます。';

  @override
  String get driveStorageNote =>
      'アーカイブは Google ドライブの Memoir フォルダに保存されます。別の Google アカウントでログインすると、そこに別の整理されたアーカイブを作れます。';

  @override
  String get problemOffline => 'インターネットに接続されていません。Memoir が自動で再試行します。';

  @override
  String get problemTimeout => '接続がタイムアウトしました。Memoir が自動で再試行します。';

  @override
  String get problemConnectionFailed => '接続に失敗しました。Memoir が自動で再試行します。';

  @override
  String get problemGoogleUnreachable =>
      'Google に接続できませんでした。Memoir が自動で再試行します。';

  @override
  String problemRetry(String message) {
    return '$message Memoir が自動で再試行します。';
  }

  @override
  String restoreFoundTitle(int count) {
    return 'ドライブに保存済みの項目が $count 件見つかりました';
  }

  @override
  String get restoreFoundBody =>
      '以前 Memoir からバックアップした項目ですが、このスマホにはありません。元のチャットに復元しますか？';

  @override
  String get restore => '復元';

  @override
  String get notNow => '今はしない';

  @override
  String restoringProgress(int done, int total) {
    return '復元中 $done / $total…';
  }

  @override
  String restoredCount(int count) {
    return '$count 件を復元しました';
  }

  @override
  String get restoredCollection => '復元済み';

  @override
  String get settings => '設定';

  @override
  String get appearance => '外観';

  @override
  String get appearanceSubtitle => 'システム、ライト、ダークから選択';

  @override
  String get themeSystem => 'システム';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get language => '言語';

  @override
  String get languageSystem => '端末の言語';

  @override
  String get appLock => 'アプリのロック';

  @override
  String get appLockSubtitle => '端末の PIN、パターン、指紋で Memoir のロックを解除';

  @override
  String get driveBackup => 'Google ドライブにバックアップ';

  @override
  String get driveBackupSubtitle => 'アカウントを接続してコピーを整理・閲覧';

  @override
  String get onDeviceArchive => '端末内のアーカイブ';

  @override
  String get onDeviceArchiveSubtitle => '思い出はこの端末でオフラインでも見られます。';

  @override
  String get privacy => 'プライバシー';

  @override
  String get privacySubtitle =>
      '保存するものはあなたが選んだものだけです。Memoir はメッセージアプリのデータベースを読みません。';

  @override
  String get developer => '開発者';

  @override
  String get openProfile => '開発者のプロフィールを開く';

  @override
  String get linkFailed => 'このリンクを開けませんでした。';

  @override
  String get lockNeedsScreenLock => 'まずこの端末で画面ロック（PIN、パターン、指紋）を設定してください。';

  @override
  String get lockNotUnlocked => 'ロックを解除できませんでした。';

  @override
  String get lockTooManyAttempts => '試行回数が多すぎます。後でもう一度試すか、PIN を使ってください。';

  @override
  String lockFailed(String code) {
    return 'ロックを解除できませんでした：$code';
  }

  @override
  String get lockConfirmEnable => 'Memoir をロックするには確認してください';

  @override
  String get lockConfirmDisable => 'ロックを解除するには確認してください';

  @override
  String get lockUnlockReason => 'Memoir のロックを解除';

  @override
  String get lockedTitle => 'Memoir はロックされています';

  @override
  String get lockedSubtitle => '端末の PIN、パターン、指紋を使ってください';

  @override
  String get unlock => 'ロックを解除';

  @override
  String updateAvailableTitle(String version) {
    return 'バージョン $version が利用可能です';
  }

  @override
  String get updateAvailableBody =>
      'Memoir の新しいバージョンがあります。ダウンロードしてこのまま上書きインストールしてください。思い出はスマホに残ります。';

  @override
  String get updateDownload => 'ダウンロード';

  @override
  String get updateLater => '後で';

  @override
  String get checkForUpdates => 'アップデートを確認';

  @override
  String currentVersion(String version) {
    return 'バージョン $version';
  }

  @override
  String get upToDate => '最新バージョンです。';

  @override
  String get updateCheckFailed => 'アップデートを確認できませんでした。インターネット接続を確認してください。';
}
