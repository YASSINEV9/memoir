// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get navMemories => 'Memórias';

  @override
  String get navDrive => 'Google Drive';

  @override
  String get navSettings => 'Configurações';

  @override
  String get archiveSubtitle => 'Seus momentos salvos';

  @override
  String get newCollection => 'Nova coleção';

  @override
  String get searchHint => 'Pesquise no seu arquivo';

  @override
  String archiveError(String error) {
    return 'Não foi possível abrir o arquivo: $error';
  }

  @override
  String get noMatches => 'Nenhum resultado';

  @override
  String get addToVault => 'Adicionar';

  @override
  String get noMessagesYet => 'Ainda não há mensagens';

  @override
  String get photo => 'Foto';

  @override
  String get file => 'Arquivo';

  @override
  String get video => 'Vídeo';

  @override
  String get emptyTitle => 'Seu arquivo começa aqui';

  @override
  String get emptyBody =>
      'Salve uma nota, um link, uma foto ou qualquer arquivo. Seus itens ficam neste aparelho.';

  @override
  String get savedLink => 'Link salvo';

  @override
  String get savedNote => 'Nota salva';

  @override
  String get attachment => 'Anexo';

  @override
  String get pin => 'Fixar';

  @override
  String get unpin => 'Desafixar';

  @override
  String get favorite => 'Favorito';

  @override
  String get removeFavorite => 'Remover dos favoritos';

  @override
  String get savedToMemoir => 'Salvo no Memoir';

  @override
  String get saveSomething => 'Salvar algo';

  @override
  String get writeNote => 'Escreva uma nota ou cole um texto';

  @override
  String get chooseFiles => 'Escolher arquivos';

  @override
  String get chooseFilesSubtitle => 'Fotos, vídeos, PDFs e mais';

  @override
  String get newItem => 'Novo item';

  @override
  String get newItemHint => 'Escreva ou cole um texto ou um link';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get create => 'Criar';

  @override
  String get collectionName => 'Nome da coleção';

  @override
  String filesSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos salvos neste aparelho',
      one: '1 arquivo salvo neste aparelho',
    );
    return '$_temp0';
  }

  @override
  String importFailed(String error) {
    return 'Não foi possível importar os arquivos: $error';
  }

  @override
  String createCollectionFailed(String error) {
    return 'Não foi possível criar a coleção: $error';
  }

  @override
  String get collectionAll => 'Todos os itens';

  @override
  String get collectionTelegram => 'Salvos do Telegram';

  @override
  String get collectionWhatsapp => 'Arquivo do WhatsApp';

  @override
  String get collectionFacebook => 'Arquivo do Facebook';

  @override
  String get collectionInstagram => 'Arquivo do Instagram';

  @override
  String get collectionPersonal => 'Arquivo pessoal';

  @override
  String get chat => 'Conversa';

  @override
  String get copy => 'Copiar';

  @override
  String get saveToGallery => 'Salvar na galeria';

  @override
  String get saveToDevice => 'Salvar no aparelho';

  @override
  String saveAllToGallery(int count) {
    return 'Salvar os $count na galeria';
  }

  @override
  String get delete => 'Excluir';

  @override
  String get deleteTitle => 'Excluir a mensagem?';

  @override
  String get deleteBody =>
      'Ela será removida deste aparelho. A cópia já salva no Google Drive não é excluída.';

  @override
  String get allowPhotos =>
      'Permita que o Memoir acesse suas fotos para salvá-las.';

  @override
  String get nothingSaved => 'Nada foi salvo';

  @override
  String savedToDevice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens salvos no seu aparelho',
      one: '1 item salvo no seu aparelho',
    );
    return '$_temp0';
  }

  @override
  String saveFailed(String error) {
    return 'Não foi possível salvar: $error';
  }

  @override
  String savedInChat(int count) {
    return '$count salvos';
  }

  @override
  String get today => 'Hoje';

  @override
  String get pinnedMessage => 'Mensagem fixada';

  @override
  String get emptyChatTitle => 'Ainda não há mensagens aqui';

  @override
  String get emptyChatBody =>
      'Escreva uma mensagem ou anexe arquivos para salvá-los.';

  @override
  String get composerMessage => 'Mensagem';

  @override
  String get composerMessageEllipsis => 'Mensagem...';

  @override
  String get send => 'Enviar';

  @override
  String photosCount(int count) {
    return '$count fotos';
  }

  @override
  String viewerPosition(int index, int total) {
    return '$index de $total';
  }

  @override
  String get play => 'Reproduzir';

  @override
  String get openWith => 'Abrir com outro app';

  @override
  String get openInDrive => 'Abrir no Google Drive';

  @override
  String get noAppToOpen =>
      'Nenhum app deste telefone consegue abrir este arquivo.';

  @override
  String get couldNotOpen => 'Não foi possível abrir este arquivo.';

  @override
  String get videoLoadFailed =>
      'Este vídeo não pode ser reproduzido aqui. Tente abri-lo com outro app.';

  @override
  String get noInternet =>
      'Sem conexão com a Internet. Verifique a conexão e tente de novo.';

  @override
  String signInClosed(String details) {
    return 'O login do Google foi fechado ou recusado. Se você não o cancelou, tente de novo.$details';
  }

  @override
  String signInMisconfigured(String details) {
    return 'O login do Google está mal configurado (cliente OAuth / SHA-1).$details';
  }

  @override
  String signInUiUnavailable(String details) {
    return 'Não foi possível mostrar a janela de login do Google. Tente de novo.$details';
  }

  @override
  String signInInterrupted(String details) {
    return 'O login do Google foi interrompido. Tente de novo.$details';
  }

  @override
  String signInFailed(String code, String details) {
    return 'Falha no login do Google: $code$details';
  }

  @override
  String get drivePermissionDenied => 'A permissão do Google Drive foi negada.';

  @override
  String get reconnectRequired =>
      'Sua sessão do Google expirou ou o acesso ao Drive foi removido. Conecte-se de novo para continuar o backup.';

  @override
  String get backupBusy => 'Já há um backup em andamento. Tente daqui a pouco.';

  @override
  String connectedTo(String email) {
    return 'Conectado a $email';
  }

  @override
  String get everythingBackedUp => 'Tudo já está no backup';

  @override
  String backedUpNew(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens novos no backup',
      one: '1 item novo no backup',
    );
    return '$_temp0';
  }

  @override
  String alreadyUpToDate(int count) {
    return '$count já atualizados';
  }

  @override
  String skippedMissing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos ausentes ignorados',
      one: '1 arquivo ausente ignorado',
    );
    return '$_temp0';
  }

  @override
  String get exportFromMemoir => 'Exportar do Memoir';

  @override
  String get exportCancelled => 'Exportação cancelada.';

  @override
  String savedForTransfer(String name) {
    return 'Salvo para transferência: $name';
  }

  @override
  String get thisDevice => 'Este aparelho';

  @override
  String get localAvailable =>
      'Seu arquivo é salvo localmente e continua disponível off-line.';

  @override
  String get available => 'Disponível';

  @override
  String get yourBackup => 'Seu backup';

  @override
  String get connected => 'Conectado';

  @override
  String get reconnectNeeded => 'É preciso reconectar';

  @override
  String get notConnected => 'Não conectado';

  @override
  String get automaticBackup => 'Backup automático';

  @override
  String get automaticBackupSubtitle =>
      'Enviar itens novos todo dia quando houver Internet';

  @override
  String get backupTime => 'Horário do backup';

  @override
  String get lastBackupNever => 'Último backup: ainda não';

  @override
  String lastBackupAt(String date) {
    return 'Último backup: $date';
  }

  @override
  String get iosScheduleNote =>
      'O iOS não permite que apps rodem num horário escolhido. O backup acontece na próxima vez que você abrir o Memoir depois desse horário.';

  @override
  String get androidScheduleNote =>
      'O Android pode fazê-lo depois do horário escolhido para poupar bateria, ou esperar o telefone ficar on-line. Forçar a parada do Memoir pausa o backup até você abrir o app de novo.';

  @override
  String get showDriveFiles => 'Ver arquivos do Drive';

  @override
  String get backUpArchive => 'Fazer backup';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get reconnect => 'Reconectar';

  @override
  String get connectPrompt =>
      'Escolha uma conta do Google para criar suas pastas do Memoir e autorizar o acesso ao Drive.';

  @override
  String get continueWithGoogle => 'Continuar com o Google';

  @override
  String backingUpProgress(int done, int total) {
    return 'Fazendo backup $done de $total…';
  }

  @override
  String get organizedInDrive => 'Organizado no seu Drive';

  @override
  String get transferHint =>
      'Para mudar de telefone, instale o Memoir nele e entre com a mesma conta do Google: o Memoir vai oferecer restaurar seu backup.';

  @override
  String driveFilesCount(int count) {
    return 'Arquivos do Drive ($count)';
  }

  @override
  String get download => 'Baixar';

  @override
  String get showDriveFilesHint =>
      'Escolha «Ver arquivos do Drive» para ver tudo o que o Memoir salvou.';

  @override
  String get driveStorageNote =>
      'Seu arquivo fica na pasta Memoir do seu Google Drive. Entre com outra conta do Google para criar lá um arquivo separado e organizado.';

  @override
  String get problemOffline =>
      'Sem conexão com a Internet. O Memoir tentará de novo automaticamente.';

  @override
  String get problemTimeout =>
      'A conexão expirou. O Memoir tentará de novo automaticamente.';

  @override
  String get problemConnectionFailed =>
      'A conexão falhou. O Memoir tentará de novo automaticamente.';

  @override
  String get problemGoogleUnreachable =>
      'Não foi possível acessar o Google. O Memoir tentará de novo automaticamente.';

  @override
  String problemRetry(String message) {
    return '$message O Memoir tentará de novo automaticamente.';
  }

  @override
  String restoreFoundTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens salvos encontrados no seu Drive',
      one: '1 item salvo encontrado no seu Drive',
    );
    return '$_temp0';
  }

  @override
  String get restoreFoundBody =>
      'Eles foram salvos antes pelo Memoir mas não estão neste telefone. Restaurá-los nas conversas?';

  @override
  String get restore => 'Restaurar';

  @override
  String get notNow => 'Agora não';

  @override
  String restoringProgress(int done, int total) {
    return 'Restaurando $done de $total…';
  }

  @override
  String restoredCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens restaurados',
      one: '1 item restaurado',
    );
    return '$_temp0';
  }

  @override
  String get restoredCollection => 'Restaurado';

  @override
  String get settings => 'Configurações';

  @override
  String get appearance => 'Aparência';

  @override
  String get appearanceSubtitle => 'Escolha o tema do sistema, claro ou escuro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Idioma do telefone';

  @override
  String get appLock => 'Bloqueio do app';

  @override
  String get appLockSubtitle =>
      'Desbloqueie o Memoir com o PIN, o padrão ou a digital do telefone';

  @override
  String get driveBackup => 'Backup no Google Drive';

  @override
  String get driveBackupSubtitle =>
      'Conecte sua conta para organizar e ver suas cópias';

  @override
  String get onDeviceArchive => 'Arquivo no aparelho';

  @override
  String get onDeviceArchiveSubtitle =>
      'Suas memórias continuam disponíveis off-line neste aparelho.';

  @override
  String get privacy => 'Privacidade';

  @override
  String get privacySubtitle =>
      'Só é importado o que você escolhe salvar. O Memoir não lê os bancos de dados dos apps de mensagens.';

  @override
  String get developer => 'Desenvolvedor';

  @override
  String get openProfile => 'Abrir perfil do desenvolvedor';

  @override
  String get linkFailed => 'Não foi possível abrir este link.';

  @override
  String get lockNeedsScreenLock =>
      'Primeiro defina um bloqueio de tela (PIN, padrão ou digital) neste telefone.';

  @override
  String get lockNotUnlocked => 'Não desbloqueado.';

  @override
  String get lockTooManyAttempts =>
      'Tentativas demais. Tente mais tarde ou use seu PIN.';

  @override
  String lockFailed(String code) {
    return 'Não foi possível desbloquear: $code';
  }

  @override
  String get lockConfirmEnable => 'Confirme para bloquear o Memoir';

  @override
  String get lockConfirmDisable => 'Confirme para remover o bloqueio';

  @override
  String get lockUnlockReason => 'Desbloquear o Memoir';

  @override
  String get lockedTitle => 'O Memoir está bloqueado';

  @override
  String get lockedSubtitle =>
      'Use o PIN, o padrão ou a digital do seu telefone';

  @override
  String get unlock => 'Desbloquear';
}
