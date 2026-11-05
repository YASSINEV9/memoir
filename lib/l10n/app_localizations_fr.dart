// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get navMemories => 'Souvenirs';

  @override
  String get navDrive => 'Google Drive';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get archiveSubtitle => 'Vos moments enregistrés';

  @override
  String get newCollection => 'Nouvelle collection';

  @override
  String get searchHint => 'Rechercher dans vos archives';

  @override
  String archiveError(String error) {
    return 'Impossible d\'ouvrir les archives : $error';
  }

  @override
  String get noMatches => 'Aucun résultat';

  @override
  String get addToVault => 'Ajouter';

  @override
  String get noMessagesYet => 'Aucun message pour l\'instant';

  @override
  String get photo => 'Photo';

  @override
  String get file => 'Fichier';

  @override
  String get video => 'Vidéo';

  @override
  String get emptyTitle => 'Vos archives commencent ici';

  @override
  String get emptyBody =>
      'Enregistrez une note, un lien, une photo ou n\'importe quel fichier. Vos éléments restent sur cet appareil.';

  @override
  String get savedLink => 'Lien enregistré';

  @override
  String get savedNote => 'Note enregistrée';

  @override
  String get attachment => 'Pièce jointe';

  @override
  String get pin => 'Épingler';

  @override
  String get unpin => 'Désépingler';

  @override
  String get favorite => 'Favori';

  @override
  String get removeFavorite => 'Retirer des favoris';

  @override
  String get savedToMemoir => 'Enregistré dans Memoir';

  @override
  String get saveSomething => 'Enregistrer quelque chose';

  @override
  String get writeNote => 'Écrire une note ou coller du texte';

  @override
  String get chooseFiles => 'Choisir des fichiers';

  @override
  String get chooseFilesSubtitle => 'Photos, vidéos, PDF et plus';

  @override
  String get newItem => 'Nouvel élément';

  @override
  String get newItemHint => 'Écrivez ou collez du texte ou un lien';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get create => 'Créer';

  @override
  String get collectionName => 'Nom de la collection';

  @override
  String filesSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers enregistrés sur cet appareil',
      one: '1 fichier enregistré sur cet appareil',
    );
    return '$_temp0';
  }

  @override
  String importFailed(String error) {
    return 'Impossible d\'importer les fichiers : $error';
  }

  @override
  String createCollectionFailed(String error) {
    return 'Impossible de créer la collection : $error';
  }

  @override
  String get collectionAll => 'Tous les éléments';

  @override
  String get collectionTelegram => 'Telegram enregistré';

  @override
  String get collectionWhatsapp => 'Archives WhatsApp';

  @override
  String get collectionFacebook => 'Archives Facebook';

  @override
  String get collectionInstagram => 'Archives Instagram';

  @override
  String get collectionPersonal => 'Archives personnelles';

  @override
  String get chat => 'Discussion';

  @override
  String get copy => 'Copier';

  @override
  String get saveToGallery => 'Enregistrer dans la galerie';

  @override
  String get saveToDevice => 'Enregistrer sur l\'appareil';

  @override
  String saveAllToGallery(int count) {
    return 'Enregistrer les $count dans la galerie';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteTitle => 'Supprimer le message ?';

  @override
  String get deleteBody =>
      'Il sera supprimé de cet appareil. La copie déjà sauvegardée sur Google Drive n\'est pas supprimée.';

  @override
  String get allowPhotos =>
      'Autorisez Memoir à accéder à vos photos pour les enregistrer.';

  @override
  String get nothingSaved => 'Rien n\'a été enregistré';

  @override
  String savedToDevice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments enregistrés sur votre appareil',
      one: '1 élément enregistré sur votre appareil',
    );
    return '$_temp0';
  }

  @override
  String saveFailed(String error) {
    return 'Impossible d\'enregistrer : $error';
  }

  @override
  String savedInChat(int count) {
    return '$count enregistrés';
  }

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get pinnedMessage => 'Message épinglé';

  @override
  String get emptyChatTitle => 'Aucun message ici pour l\'instant';

  @override
  String get emptyChatBody =>
      'Écrivez un message ou joignez des fichiers pour les enregistrer.';

  @override
  String get composerMessage => 'Message';

  @override
  String get composerMessageEllipsis => 'Message...';

  @override
  String get send => 'Envoyer';

  @override
  String photosCount(int count) {
    return '$count photos';
  }

  @override
  String viewerPosition(int index, int total) {
    return '$index sur $total';
  }

  @override
  String get play => 'Lire';

  @override
  String get openWith => 'Ouvrir avec une autre application';

  @override
  String get openInDrive => 'Ouvrir dans Google Drive';

  @override
  String get noAppToOpen =>
      'Aucune application de ce téléphone ne peut ouvrir ce fichier.';

  @override
  String get couldNotOpen => 'Impossible d\'ouvrir ce fichier.';

  @override
  String get videoLoadFailed =>
      'Cette vidéo ne peut pas être lue ici. Essayez de l\'ouvrir avec une autre application.';

  @override
  String get noInternet =>
      'Pas de connexion Internet. Vérifiez votre connexion et réessayez.';

  @override
  String signInClosed(String details) {
    return 'La connexion Google a été fermée ou refusée. Si vous ne l\'avez pas annulée, réessayez.$details';
  }

  @override
  String signInMisconfigured(String details) {
    return 'La connexion Google est mal configurée (client OAuth / SHA-1).$details';
  }

  @override
  String signInUiUnavailable(String details) {
    return 'La fenêtre de connexion Google n\'a pas pu s\'afficher. Réessayez.$details';
  }

  @override
  String signInInterrupted(String details) {
    return 'La connexion Google a été interrompue. Réessayez.$details';
  }

  @override
  String signInFailed(String code, String details) {
    return 'Échec de la connexion Google : $code$details';
  }

  @override
  String get drivePermissionDenied =>
      'L\'autorisation Google Drive a été refusée.';

  @override
  String get reconnectRequired =>
      'Votre session Google a expiré ou l\'accès à Drive a été retiré. Reconnectez-vous pour continuer la sauvegarde.';

  @override
  String get backupBusy =>
      'Une sauvegarde est déjà en cours. Réessayez dans un instant.';

  @override
  String connectedTo(String email) {
    return 'Connecté à $email';
  }

  @override
  String get everythingBackedUp => 'Tout est déjà sauvegardé';

  @override
  String backedUpNew(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nouveaux éléments sauvegardés',
      one: '1 nouvel élément sauvegardé',
    );
    return '$_temp0';
  }

  @override
  String alreadyUpToDate(int count) {
    return '$count déjà à jour';
  }

  @override
  String skippedMissing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fichiers manquants ignorés',
      one: '1 fichier manquant ignoré',
    );
    return '$_temp0';
  }

  @override
  String get exportFromMemoir => 'Exporter depuis Memoir';

  @override
  String get exportCancelled => 'Export annulé.';

  @override
  String savedForTransfer(String name) {
    return 'Enregistré pour le transfert : $name';
  }

  @override
  String get thisDevice => 'Cet appareil';

  @override
  String get localAvailable =>
      'Vos archives sont enregistrées localement et restent disponibles hors ligne.';

  @override
  String get available => 'Disponible';

  @override
  String get yourBackup => 'Votre sauvegarde';

  @override
  String get connected => 'Connecté';

  @override
  String get reconnectNeeded => 'Reconnexion nécessaire';

  @override
  String get notConnected => 'Non connecté';

  @override
  String get automaticBackup => 'Sauvegarde automatique';

  @override
  String get automaticBackupSubtitle =>
      'Envoyer les nouveaux éléments chaque jour quand Internet est disponible';

  @override
  String get backupTime => 'Heure de sauvegarde';

  @override
  String get lastBackupNever => 'Dernière sauvegarde : jamais';

  @override
  String lastBackupAt(String date) {
    return 'Dernière sauvegarde : $date';
  }

  @override
  String get iosScheduleNote =>
      'iOS ne permet pas aux applications de s\'exécuter à une heure précise. La sauvegarde a lieu la prochaine fois que vous ouvrez Memoir après cette heure.';

  @override
  String get androidScheduleNote =>
      'Android peut la lancer plus tard que l\'heure choisie pour économiser la batterie, ou attendre que le téléphone soit en ligne. Forcer l\'arrêt de Memoir la suspend jusqu\'à la prochaine ouverture.';

  @override
  String get showDriveFiles => 'Afficher les fichiers Drive';

  @override
  String get backUpArchive => 'Sauvegarder les archives';

  @override
  String get disconnect => 'Déconnecter';

  @override
  String get reconnect => 'Se reconnecter';

  @override
  String get connectPrompt =>
      'Choisissez un compte Google pour créer vos dossiers Memoir et autoriser l\'accès à Drive.';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String backingUpProgress(int done, int total) {
    return 'Sauvegarde $done sur $total…';
  }

  @override
  String get organizedInDrive => 'Organisé dans votre Drive';

  @override
  String get transferHint =>
      'Pour changer de téléphone, installez Memoir et connectez-vous avec le même compte Google : Memoir proposera de restaurer votre sauvegarde.';

  @override
  String driveFilesCount(int count) {
    return 'Fichiers Drive ($count)';
  }

  @override
  String get download => 'Télécharger';

  @override
  String get showDriveFilesHint =>
      'Choisissez « Afficher les fichiers Drive » pour voir tout ce que Memoir a sauvegardé.';

  @override
  String get driveStorageNote =>
      'Vos archives sont stockées dans le dossier Memoir de votre Google Drive. Connectez-vous à un autre compte Google pour y créer des archives séparées et bien organisées.';

  @override
  String get problemOffline =>
      'Pas de connexion Internet. Memoir réessaiera automatiquement.';

  @override
  String get problemTimeout =>
      'La connexion a expiré. Memoir réessaiera automatiquement.';

  @override
  String get problemConnectionFailed =>
      'La connexion a échoué. Memoir réessaiera automatiquement.';

  @override
  String get problemGoogleUnreachable =>
      'Google est injoignable. Memoir réessaiera automatiquement.';

  @override
  String problemRetry(String message) {
    return '$message Memoir réessaiera automatiquement.';
  }

  @override
  String restoreFoundTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments enregistrés trouvés dans votre Drive',
      one: '1 élément enregistré trouvé dans votre Drive',
    );
    return '$_temp0';
  }

  @override
  String get restoreFoundBody =>
      'Ils ont été sauvegardés auparavant depuis Memoir mais ne sont pas sur ce téléphone. Les restaurer dans leurs discussions ?';

  @override
  String get restore => 'Restaurer';

  @override
  String get notNow => 'Plus tard';

  @override
  String restoringProgress(int done, int total) {
    return 'Restauration $done sur $total…';
  }

  @override
  String restoredCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments restaurés',
      one: '1 élément restauré',
    );
    return '$_temp0';
  }

  @override
  String get restoredCollection => 'Restauré';

  @override
  String get settings => 'Paramètres';

  @override
  String get appearance => 'Apparence';

  @override
  String get appearanceSubtitle =>
      'Choisissez le thème système, clair ou sombre';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get language => 'Langue';

  @override
  String get languageSystem => 'Langue du téléphone';

  @override
  String get appLock => 'Verrouillage';

  @override
  String get appLockSubtitle =>
      'Déverrouiller Memoir avec le code, le schéma ou l\'empreinte du téléphone';

  @override
  String get driveBackup => 'Sauvegarde Google Drive';

  @override
  String get driveBackupSubtitle =>
      'Connectez votre compte pour organiser et parcourir vos copies';

  @override
  String get onDeviceArchive => 'Archives sur l\'appareil';

  @override
  String get onDeviceArchiveSubtitle =>
      'Vos souvenirs restent disponibles hors ligne sur cet appareil.';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get privacySubtitle =>
      'Rien n\'est importé sans votre choix. Memoir ne lit pas les bases de données des messageries.';

  @override
  String get developer => 'Développeur';

  @override
  String get openProfile => 'Ouvrir le profil du développeur';

  @override
  String get linkFailed => 'Impossible d\'ouvrir ce lien.';

  @override
  String get lockNeedsScreenLock =>
      'Définissez d\'abord un verrouillage d\'écran (code, schéma ou empreinte) sur ce téléphone.';

  @override
  String get lockNotUnlocked => 'Non déverrouillé.';

  @override
  String get lockTooManyAttempts =>
      'Trop de tentatives. Réessayez plus tard ou utilisez votre code.';

  @override
  String lockFailed(String code) {
    return 'Déverrouillage impossible : $code';
  }

  @override
  String get lockConfirmEnable => 'Confirmez pour verrouiller Memoir';

  @override
  String get lockConfirmDisable => 'Confirmez pour retirer le verrouillage';

  @override
  String get lockUnlockReason => 'Déverrouiller Memoir';

  @override
  String get lockedTitle => 'Memoir est verrouillé';

  @override
  String get lockedSubtitle =>
      'Utilisez le code, le schéma ou l\'empreinte de votre téléphone';

  @override
  String get unlock => 'Déverrouiller';

  @override
  String updateAvailableTitle(String version) {
    return 'La version $version est disponible';
  }

  @override
  String get updateAvailableBody =>
      'Une nouvelle version de Memoir est prête. Téléchargez-la et installez-la par-dessus celle-ci ; vos souvenirs restent sur votre téléphone.';

  @override
  String get updateDownload => 'Télécharger';

  @override
  String get updateLater => 'Plus tard';

  @override
  String get checkForUpdates => 'Rechercher des mises à jour';

  @override
  String currentVersion(String version) {
    return 'Version $version';
  }

  @override
  String get upToDate => 'Vous avez la dernière version.';

  @override
  String get updateCheckFailed =>
      'Impossible de rechercher des mises à jour. Vérifiez votre connexion Internet.';
}
