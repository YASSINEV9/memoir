// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get navMemories => 'Recuerdos';

  @override
  String get navDrive => 'Google Drive';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get archiveSubtitle => 'Tus momentos guardados';

  @override
  String get newCollection => 'Nueva colección';

  @override
  String get searchHint => 'Busca en tu archivo';

  @override
  String archiveError(String error) {
    return 'No se pudo abrir el archivo: $error';
  }

  @override
  String get noMatches => 'Sin resultados';

  @override
  String get addToVault => 'Añadir';

  @override
  String get noMessagesYet => 'Aún no hay mensajes';

  @override
  String get photo => 'Foto';

  @override
  String get file => 'Archivo';

  @override
  String get video => 'Vídeo';

  @override
  String get emptyTitle => 'Tu archivo empieza aquí';

  @override
  String get emptyBody =>
      'Guarda una nota, un enlace, una foto o cualquier archivo. Tus elementos se quedan en este dispositivo.';

  @override
  String get savedLink => 'Enlace guardado';

  @override
  String get savedNote => 'Nota guardada';

  @override
  String get attachment => 'Adjunto';

  @override
  String get pin => 'Fijar';

  @override
  String get unpin => 'Desfijar';

  @override
  String get favorite => 'Favorito';

  @override
  String get removeFavorite => 'Quitar de favoritos';

  @override
  String get savedToMemoir => 'Guardado en Memoir';

  @override
  String get saveSomething => 'Guardar algo';

  @override
  String get writeNote => 'Escribe una nota o pega texto';

  @override
  String get chooseFiles => 'Elegir archivos';

  @override
  String get chooseFilesSubtitle => 'Fotos, vídeos, PDF y más';

  @override
  String get newItem => 'Nuevo elemento';

  @override
  String get newItemHint => 'Escribe o pega texto o un enlace';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get create => 'Crear';

  @override
  String get collectionName => 'Nombre de la colección';

  @override
  String filesSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count archivos guardados en este dispositivo',
      one: '1 archivo guardado en este dispositivo',
    );
    return '$_temp0';
  }

  @override
  String importFailed(String error) {
    return 'No se pudieron importar los archivos: $error';
  }

  @override
  String createCollectionFailed(String error) {
    return 'No se pudo crear la colección: $error';
  }

  @override
  String get collectionAll => 'Todos los elementos';

  @override
  String get collectionTelegram => 'Guardados de Telegram';

  @override
  String get collectionWhatsapp => 'Archivo de WhatsApp';

  @override
  String get collectionFacebook => 'Archivo de Facebook';

  @override
  String get collectionInstagram => 'Archivo de Instagram';

  @override
  String get collectionPersonal => 'Archivo personal';

  @override
  String get chat => 'Chat';

  @override
  String get copy => 'Copiar';

  @override
  String get saveToGallery => 'Guardar en la galería';

  @override
  String get saveToDevice => 'Guardar en el dispositivo';

  @override
  String saveAllToGallery(int count) {
    return 'Guardar los $count en la galería';
  }

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteTitle => '¿Eliminar el mensaje?';

  @override
  String get deleteBody =>
      'Se eliminará de este dispositivo. La copia ya guardada en Google Drive no se elimina.';

  @override
  String get allowPhotos =>
      'Permite que Memoir acceda a tus fotos para guardarlas.';

  @override
  String get nothingSaved => 'No se guardó nada';

  @override
  String savedToDevice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se guardaron $count en tu dispositivo',
      one: 'Se guardó 1 en tu dispositivo',
    );
    return '$_temp0';
  }

  @override
  String saveFailed(String error) {
    return 'No se pudo guardar: $error';
  }

  @override
  String savedInChat(int count) {
    return '$count guardados';
  }

  @override
  String get today => 'Hoy';

  @override
  String get pinnedMessage => 'Mensaje fijado';

  @override
  String get emptyChatTitle => 'Aún no hay mensajes aquí';

  @override
  String get emptyChatBody =>
      'Escribe un mensaje o adjunta archivos para guardarlos.';

  @override
  String get composerMessage => 'Mensaje';

  @override
  String get composerMessageEllipsis => 'Mensaje...';

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
  String get play => 'Reproducir';

  @override
  String get openWith => 'Abrir con otra aplicación';

  @override
  String get openInDrive => 'Abrir en Google Drive';

  @override
  String get noAppToOpen =>
      'Ninguna aplicación de este teléfono puede abrir este archivo.';

  @override
  String get couldNotOpen => 'No se pudo abrir este archivo.';

  @override
  String get videoLoadFailed =>
      'Este vídeo no se puede reproducir aquí. Prueba a abrirlo con otra aplicación.';

  @override
  String get noInternet =>
      'Sin conexión a Internet. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String signInClosed(String details) {
    return 'El inicio de sesión de Google se cerró o fue rechazado. Si no lo cancelaste, inténtalo de nuevo.$details';
  }

  @override
  String signInMisconfigured(String details) {
    return 'El inicio de sesión de Google está mal configurado (cliente OAuth / SHA-1).$details';
  }

  @override
  String signInUiUnavailable(String details) {
    return 'No se pudo mostrar la ventana de inicio de sesión de Google. Inténtalo de nuevo.$details';
  }

  @override
  String signInInterrupted(String details) {
    return 'Se interrumpió el inicio de sesión de Google. Inténtalo de nuevo.$details';
  }

  @override
  String signInFailed(String code, String details) {
    return 'Falló el inicio de sesión de Google: $code$details';
  }

  @override
  String get drivePermissionDenied => 'Se denegó el permiso de Google Drive.';

  @override
  String get reconnectRequired =>
      'Tu sesión de Google caducó o se retiró el acceso a Drive. Vuelve a conectarte para seguir con las copias.';

  @override
  String get backupBusy =>
      'Ya hay una copia en curso. Inténtalo en un momento.';

  @override
  String connectedTo(String email) {
    return 'Conectado a $email';
  }

  @override
  String get everythingBackedUp => 'Todo está ya respaldado';

  @override
  String backedUpNew(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se respaldaron $count elementos nuevos',
      one: 'Se respaldó 1 elemento nuevo',
    );
    return '$_temp0';
  }

  @override
  String alreadyUpToDate(int count) {
    return '$count ya al día';
  }

  @override
  String skippedMissing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'se omitieron $count archivos que faltan',
      one: 'se omitió 1 archivo que falta',
    );
    return '$_temp0';
  }

  @override
  String get exportFromMemoir => 'Exportar desde Memoir';

  @override
  String get exportCancelled => 'Exportación cancelada.';

  @override
  String savedForTransfer(String name) {
    return 'Guardado para transferir: $name';
  }

  @override
  String get thisDevice => 'Este dispositivo';

  @override
  String get localAvailable =>
      'Tu archivo se guarda localmente y sigue disponible sin conexión.';

  @override
  String get available => 'Disponible';

  @override
  String get yourBackup => 'Tu copia de seguridad';

  @override
  String get connected => 'Conectado';

  @override
  String get reconnectNeeded => 'Hay que volver a conectar';

  @override
  String get notConnected => 'No conectado';

  @override
  String get automaticBackup => 'Copia automática';

  @override
  String get automaticBackupSubtitle =>
      'Sube los elementos nuevos cada día cuando haya Internet';

  @override
  String get backupTime => 'Hora de la copia';

  @override
  String get lastBackupNever => 'Última copia: aún no';

  @override
  String lastBackupAt(String date) {
    return 'Última copia: $date';
  }

  @override
  String get iosScheduleNote =>
      'iOS no permite que las apps se ejecuten a una hora elegida. La copia se hace la próxima vez que abras Memoir después de esa hora.';

  @override
  String get androidScheduleNote =>
      'Android puede hacerla más tarde de la hora elegida para ahorrar batería, o esperar a que el teléfono tenga conexión. Forzar la detención de Memoir la pausa hasta que vuelvas a abrir la app.';

  @override
  String get showDriveFiles => 'Ver archivos de Drive';

  @override
  String get backUpArchive => 'Respaldar archivo';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get reconnect => 'Volver a conectar';

  @override
  String get connectPrompt =>
      'Elige una cuenta de Google para crear tus carpetas de Memoir y aprobar el acceso a Drive.';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String backingUpProgress(int done, int total) {
    return 'Respaldando $done de $total…';
  }

  @override
  String get organizedInDrive => 'Organizado en tu Drive';

  @override
  String get transferHint =>
      'Para pasar a otro teléfono, instala Memoir allí e inicia sesión con la misma cuenta de Google: Memoir te ofrecerá restaurar tu copia.';

  @override
  String driveFilesCount(int count) {
    return 'Archivos de Drive ($count)';
  }

  @override
  String get download => 'Descargar';

  @override
  String get showDriveFilesHint =>
      'Elige «Ver archivos de Drive» para ver todo lo que Memoir ha respaldado.';

  @override
  String get driveStorageNote =>
      'Tu archivo se guarda en la carpeta Memoir de tu Google Drive. Inicia sesión con otra cuenta de Google para crear allí un archivo separado y ordenado.';

  @override
  String get problemOffline =>
      'Sin conexión a Internet. Memoir lo reintentará automáticamente.';

  @override
  String get problemTimeout =>
      'Se agotó el tiempo de conexión. Memoir lo reintentará automáticamente.';

  @override
  String get problemConnectionFailed =>
      'La conexión falló. Memoir lo reintentará automáticamente.';

  @override
  String get problemGoogleUnreachable =>
      'No se pudo contactar con Google. Memoir lo reintentará automáticamente.';

  @override
  String problemRetry(String message) {
    return '$message Memoir lo reintentará automáticamente.';
  }

  @override
  String restoreFoundTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se encontraron $count elementos guardados en tu Drive',
      one: 'Se encontró 1 elemento guardado en tu Drive',
    );
    return '$_temp0';
  }

  @override
  String get restoreFoundBody =>
      'Se respaldaron antes desde Memoir pero no están en este teléfono. ¿Restaurarlos a sus chats?';

  @override
  String get restore => 'Restaurar';

  @override
  String get notNow => 'Ahora no';

  @override
  String restoringProgress(int done, int total) {
    return 'Restaurando $done de $total…';
  }

  @override
  String restoredCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se restauraron $count elementos',
      one: 'Se restauró 1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get restoredCollection => 'Restaurado';

  @override
  String get settings => 'Ajustes';

  @override
  String get appearance => 'Apariencia';

  @override
  String get appearanceSubtitle => 'Elige el tema del sistema, claro u oscuro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Idioma del teléfono';

  @override
  String get appLock => 'Bloqueo de la app';

  @override
  String get appLockSubtitle =>
      'Desbloquea Memoir con el PIN, el patrón o la huella del teléfono';

  @override
  String get driveBackup => 'Copia en Google Drive';

  @override
  String get driveBackupSubtitle =>
      'Conecta tu cuenta para organizar y ver tus copias';

  @override
  String get onDeviceArchive => 'Archivo en el dispositivo';

  @override
  String get onDeviceArchiveSubtitle =>
      'Tus recuerdos siguen disponibles sin conexión en este dispositivo.';

  @override
  String get privacy => 'Privacidad';

  @override
  String get privacySubtitle =>
      'Solo se importa lo que tú eliges guardar. Memoir no lee las bases de datos de las apps de mensajería.';

  @override
  String get developer => 'Desarrollador';

  @override
  String get openProfile => 'Abrir el perfil del desarrollador';

  @override
  String get linkFailed => 'No se pudo abrir este enlace.';

  @override
  String get lockNeedsScreenLock =>
      'Primero configura un bloqueo de pantalla (PIN, patrón o huella) en este teléfono.';

  @override
  String get lockNotUnlocked => 'No desbloqueado.';

  @override
  String get lockTooManyAttempts =>
      'Demasiados intentos. Inténtalo más tarde o usa tu PIN.';

  @override
  String lockFailed(String code) {
    return 'No se pudo desbloquear: $code';
  }

  @override
  String get lockConfirmEnable => 'Confirma para bloquear Memoir';

  @override
  String get lockConfirmDisable => 'Confirma para quitar el bloqueo';

  @override
  String get lockUnlockReason => 'Desbloquear Memoir';

  @override
  String get lockedTitle => 'Memoir está bloqueado';

  @override
  String get lockedSubtitle =>
      'Usa el PIN, el patrón o la huella de tu teléfono';

  @override
  String get unlock => 'Desbloquear';

  @override
  String updateAvailableTitle(String version) {
    return 'La versión $version está disponible';
  }

  @override
  String get updateAvailableBody =>
      'Hay una nueva versión de Memoir. Descárgala e instálala sobre esta; tus recuerdos se quedan en tu teléfono.';

  @override
  String get updateDownload => 'Descargar';

  @override
  String get updateLater => 'Más tarde';

  @override
  String get checkForUpdates => 'Buscar actualizaciones';

  @override
  String currentVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get upToDate => 'Tienes la última versión.';

  @override
  String get updateCheckFailed =>
      'No se pudieron buscar actualizaciones. Comprueba tu conexión a Internet.';

  @override
  String get addAccount => 'Añadir otra cuenta de Google';

  @override
  String get removeAccount => 'Quitar cuenta';

  @override
  String removeAccountTitle(String email) {
    return '¿Quitar $email?';
  }

  @override
  String get removeAccountBody =>
      'Memoir deja de hacer copias en esta cuenta. Los archivos que ya están en su Drive se quedan allí.';

  @override
  String get backupToAllAccounts =>
      'Cada copia va a todas las cuentas de arriba, así tus recuerdos siguen a salvo aunque pierdas una.';

  @override
  String get shareSaveTo => 'Guardar en Memoir';

  @override
  String shareItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '1 elemento',
    );
    return '$_temp0';
  }

  @override
  String sharedSaved(String name) {
    return 'Guardado en $name';
  }

  @override
  String get recentlyDeleted => 'Eliminados recientemente';

  @override
  String get recentlyDeletedSubtitle =>
      'Los elementos eliminados se guardan aquí 30 días';

  @override
  String get trashEmpty => 'No hay nada';

  @override
  String get deleteForever => 'Eliminar para siempre';

  @override
  String get emptyTrash => 'Vaciar';

  @override
  String get emptyTrashTitle => '¿Eliminar todo para siempre?';

  @override
  String get emptyTrashBody =>
      'Se quitan de este teléfono. Las copias en Google Drive se quedan.';

  @override
  String deletedOn(String date) {
    return 'Eliminado el $date';
  }

  @override
  String get movedToTrash => 'Movido a Eliminados recientemente';

  @override
  String get undo => 'Deshacer';
}
