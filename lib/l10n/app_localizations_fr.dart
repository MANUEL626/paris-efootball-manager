// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'KickFlow - Paris eFootball';

  @override
  String get configuration => 'Configuration';

  @override
  String get configurationMissingBody =>
      'Configuration Supabase manquante.\n\n• Option A : à la racine du projet, exécutez :\n  dart run tool/sync_env.dart\n  (copie .env.local.json vers assets/env.json)\n\n• Option B : flutter run --dart-define-from-file=.env.local.json\n\n• Option C (Android Studio) : Run > Edit Configurations > Additional run args :\n  --dart-define-from-file=.env.local.json';

  @override
  String get profileNotAllowed =>
      'Votre profil ne vous permet pas de vous connecter.';

  @override
  String get profileCheckFailed =>
      'Impossible de vérifier votre profil. Vous avez été déconnecté. Réessayez.';

  @override
  String get loginWelcome => 'Bienvenue !';

  @override
  String get loginSubtitle => 'Connectez-vous pour continuer';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get signIn => 'Se connecter';

  @override
  String get orDivider => 'OU';

  @override
  String get phoneLoginSoon => 'Connexion par téléphone — bientôt disponible.';

  @override
  String get signInWithGoogle => 'Connexion avec Google';

  @override
  String get signInWithFacebook => 'Connexion avec Facebook';

  @override
  String get noAccount => 'Pas encore de compte ? ';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get fillEmailPassword => 'Renseignez l\'email et le mot de passe.';

  @override
  String get loginFailed => 'Connexion impossible.';

  @override
  String get wrongPassword => 'Email ou mot de passe incorrect.';

  @override
  String get serverTemporarilyUnavailable =>
      'Serveur temporairement indisponible (erreur réseau). Si vous êtes déjà connecté, redémarrez l\'app ou réessayez plus tard.';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get registerPlayerTitle => 'Inscription joueur';

  @override
  String get registerPlayerSubtitle =>
      'Créez votre compte pour rejoindre la communauté KickFlow.';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get firstName => 'Prénom';

  @override
  String get lastName => 'Nom';

  @override
  String get username => 'Pseudo';

  @override
  String get phoneOptional => 'Téléphone (optionnel)';

  @override
  String get registerFillRequired =>
      'Renseignez l\'email, le mot de passe, le prénom, le nom et le pseudo.';

  @override
  String get passwordsMismatch => 'Les mots de passe ne correspondent pas.';

  @override
  String get accountCreatedEmail =>
      'Compte créé. Vérifiez votre boîte mail pour confirmer l\'adresse.';

  @override
  String get accountCreatedOk => 'Compte créé. Vous pouvez vous connecter.';

  @override
  String get signupFailed => 'Inscription impossible.';

  @override
  String get alreadyHaveAccount => 'Déjà un compte ? ';

  @override
  String get skip => 'Passer';

  @override
  String get next => 'Suivant';

  @override
  String get onboardingSlide1Title => 'Défiez les Meilleurs';

  @override
  String get onboardingSlide1Subtitle =>
      'Créez des défis eFootball et affrontez des joueurs du monde entier';

  @override
  String get onboardingSlide2Title => 'Gagnez des Tokens';

  @override
  String get onboardingSlide2Subtitle =>
      'Pariez, gagnez et retirez vos gains en toute sécurité';

  @override
  String get navHome => 'Accueil';

  @override
  String get navChallenges => 'Défis';

  @override
  String get navHistory => 'Historique';

  @override
  String get navStreaming => 'Streaming';

  @override
  String get navProfile => 'Profil';

  @override
  String get homeArenaTitle => 'Arène SkillBet';

  @override
  String get homeChooseAction => 'Choisissez votre action';

  @override
  String get cardFindChallenge => 'TROUVER DÉFI';

  @override
  String get cardFindChallengeSubtitle =>
      'Créez ou rejoignez un défi 1v1 et misez vos SkillCoins';

  @override
  String get cardHistory => 'HISTORIQUE';

  @override
  String get cardHistorySubtitle => 'Consultez l\'historique de tous vos défis';

  @override
  String get tournamentBannerTitle => 'Tournoi Hebdomadaire - 100 000 FCFA';

  @override
  String get tournamentBannerShort =>
      'Le grand tournoi commence vendredi ! Prix total : 100 000 FCFA. In...';

  @override
  String get eventTag => 'ÉVÉNEMENT';

  @override
  String get eventModalTitle => 'Tournoi Hebdomadaire - 100 000 FCFA';

  @override
  String get eventModalBody =>
      'Le grand tournoi hebdomadaire commence vendredi ! Prix total : 100 000 FCFA. Inscriptions ouvertes dès maintenant. Ne rate pas cette opportunité !';

  @override
  String get viewTournaments => 'Voir les tournois';

  @override
  String get later => 'Plus tard';

  @override
  String get challengesTitle => 'Défis';

  @override
  String get findChallenge => 'Trouver un défi';

  @override
  String get findChallengeSubtitle =>
      'Créez ou rejoignez un défi 1v1 et misez vos SkillCoins.';

  @override
  String get challengeQuick => 'Défi rapide 1v1';

  @override
  String get challengeMedium => 'Défi intermédiaire';

  @override
  String get challengeExpert => 'Défi expert';

  @override
  String get skillCoins500 => '500 SkillCoins';

  @override
  String get skillCoins1000 => '1 000 SkillCoins';

  @override
  String get skillCoins5000 => '5 000 SkillCoins';

  @override
  String get createChallenge => 'Créer un défi';

  @override
  String get join => 'Rejoindre';

  @override
  String get historyTitle => 'Historique';

  @override
  String get historyYourChallenges => 'Vos derniers défis';

  @override
  String get historySubtitle => 'Consultez l\'historique de tous vos défis.';

  @override
  String get resultWin => 'Victoire';

  @override
  String get resultLoss => 'Défaite';

  @override
  String get ago2h => 'Il y a 2h';

  @override
  String get ago1d => 'Il y a 1j';

  @override
  String get ago5h => 'Il y a 5h';

  @override
  String get ago1j => 'Il y a 1j';

  @override
  String get streamingTitle => 'Streaming';

  @override
  String get noLiveStream => 'Aucun stream en direct';

  @override
  String get streamsAppearHere => 'Les lives apparaîtront ici.';

  @override
  String get tournamentsTitle => 'Tournois';

  @override
  String get tournamentWeeklyBlurb =>
      'Le grand tournoi hebdomadaire commence vendredi ! Prix total : 100 000 FCFA. Inscriptions ouvertes dès maintenant.';

  @override
  String get registerTournament => 'S\'inscrire au tournoi';

  @override
  String get otherTournaments => 'Autres tournois';

  @override
  String get tournamentWeekend => 'Tournoi du week-end';

  @override
  String get tournamentFriday => 'Défi du vendredi';

  @override
  String get prize50k => '50 000 FCFA';

  @override
  String get prize25k => '25 000 FCFA';

  @override
  String get announcementsTitle => 'Annonces';

  @override
  String get announcementsNews => 'Infos & Nouveautés';

  @override
  String get filterAll => 'Tout';

  @override
  String get filterNews => 'Nouveauté';

  @override
  String get filterEvent => 'Événement';

  @override
  String get filterInfo => 'Info';

  @override
  String get announcementWelcomeTitle => 'Bienvenue sur KickFlow !';

  @override
  String get announcementWelcomeBody =>
      'Merci de rejoindre la communauté KickFlow ! Défie tes amis, participe à des tournois et gagne de l\'argent réel en jouant à eFootball.';

  @override
  String get announcementTournamentTitle =>
      'Tournoi Hebdomadaire - 100 000 FCFA';

  @override
  String get announcementTournamentBody =>
      'Le grand tournoi hebdomadaire commence vendredi ! Prix total : 100 000 FCFA. Inscriptions ouvertes dès maintenant.';

  @override
  String get announcementRewardsTitle => 'Nouveau système de récompenses';

  @override
  String get announcementRewardsBody =>
      'Gagne des points de fidélité à chaque match et débloque des bonus exclusifs ! Plus tu joues, plus tu gagnes.';

  @override
  String get time2h => 'Il y a 2h';

  @override
  String get time5h => 'Il y a 5h';

  @override
  String get time1d => 'Il y a 1j';

  @override
  String get badgeNew => 'NEW Nouveauté';

  @override
  String get badgeNewUpper => 'NOUVEAU';

  @override
  String get profileTitle => 'Profil';

  @override
  String get usernameLabel => 'Username';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get settings => 'Paramètres';

  @override
  String get help => 'Aide';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get country => 'Pays';

  @override
  String get theme => 'Thème';

  @override
  String get notifications => 'Notifications';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeLight => 'Clair';

  @override
  String get themePreviewDark => 'Aperçu : fond sombre (cyan).';

  @override
  String get themePreviewLight => 'Aperçu : fond clair (cyan).';

  @override
  String get notificationsEnabled => 'Activées';

  @override
  String get notificationsDisabled => 'Désactivées';

  @override
  String get langFrench => 'Français';

  @override
  String get langEnglish => 'English';

  @override
  String get editProfileTitle => 'Modifier le profil';

  @override
  String get tapPhotoHint =>
      'Touchez l\'image pour choisir une photo depuis votre galerie.';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get phone => 'Téléphone';

  @override
  String get save => 'Enregistrer';

  @override
  String get imagePickError =>
      'Impossible de sélectionner une image sur cet appareil. Redémarre l\'app après installation des plugins.';

  @override
  String get sessionExpired => 'Session expirée. Reconnectez-vous.';

  @override
  String get updateFailed => 'Mise à jour impossible.';

  @override
  String get profileUpdated => 'Profil mis à jour avec succès.';

  @override
  String get authError => 'Erreur auth.';

  @override
  String get emailRequired => 'Email requis.';

  @override
  String get emailInvalid => 'Email invalide.';

  @override
  String get min6chars => 'Minimum 6 caractères.';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas.';

  @override
  String get usernameRequired => 'Le username est requis.';

  @override
  String get min3chars => 'Minimum 3 caractères.';

  @override
  String get linkInvalidTitle => 'Lien invalide';

  @override
  String get linkExpiredMessage => 'Ce lien a expiré ou a déjà été utilisé.';

  @override
  String get linkExpiredHint =>
      'Demandez un nouveau mail de confirmation ou reconnectez-vous.';

  @override
  String get backToLogin => 'Retour à la connexion';

  @override
  String get paramsTransitionTitle => 'Personnalisons votre expérience';

  @override
  String get paramsTransitionSubtitle =>
      'Quelques réglages pour la langue, votre région et les notifications.';

  @override
  String get paramsSetupTitle => 'Vos préférences';

  @override
  String get paramsSetupHint =>
      'Vous pourrez modifier ces choix plus tard dans les réglages.';

  @override
  String get continueButton => 'Continuer';

  @override
  String get saveFailed => 'Enregistrement impossible.';

  @override
  String get dash => '—';
}
