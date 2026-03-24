// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'KickFlow - Paris eFootball';

  @override
  String get configuration => 'Configuration';

  @override
  String get configurationMissingBody =>
      'Supabase configuration is missing.\n\n• Option A: at the project root, run:\n  dart run tool/sync_env.dart\n  (copies .env.local.json to assets/env.json)\n\n• Option B: flutter run --dart-define-from-file=.env.local.json\n\n• Option C (Android Studio): Run > Edit Configurations > Additional run args:\n  --dart-define-from-file=.env.local.json';

  @override
  String get profileNotAllowed => 'Your profile does not allow you to sign in.';

  @override
  String get profileCheckFailed =>
      'We could not verify your profile. You have been signed out. Please try again.';

  @override
  String get loginWelcome => 'Welcome!';

  @override
  String get loginSubtitle => 'Sign in to continue';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String get orDivider => 'OR';

  @override
  String get phoneLoginSoon => 'Phone sign-in — coming soon.';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithFacebook => 'Sign in with Facebook';

  @override
  String get noAccount => 'No account yet? ';

  @override
  String get signUp => 'Sign up';

  @override
  String get fillEmailPassword => 'Enter your email and password.';

  @override
  String get loginFailed => 'Could not sign in.';

  @override
  String get wrongPassword => 'Incorrect email or password.';

  @override
  String get serverTemporarilyUnavailable =>
      'Server temporarily unavailable (network error). If you are already signed in, restart the app or try again later.';

  @override
  String get createAccount => 'Create account';

  @override
  String get registerPlayerTitle => 'Player registration';

  @override
  String get registerPlayerSubtitle =>
      'Create your account to join the KickFlow community.';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get username => 'Username';

  @override
  String get phoneOptional => 'Phone (optional)';

  @override
  String get registerFillRequired =>
      'Fill in email, password, first name, last name and username.';

  @override
  String get passwordsMismatch => 'Passwords do not match.';

  @override
  String get accountCreatedEmail =>
      'Account created. Check your inbox to confirm your email.';

  @override
  String get accountCreatedOk => 'Account created. You can sign in.';

  @override
  String get signupFailed => 'Registration failed.';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get onboardingSlide1Title => 'Challenge the best';

  @override
  String get onboardingSlide1Subtitle =>
      'Create eFootball challenges and face players worldwide';

  @override
  String get onboardingSlide2Title => 'Earn tokens';

  @override
  String get onboardingSlide2Subtitle =>
      'Bet, win and withdraw your earnings safely';

  @override
  String get navHome => 'Home';

  @override
  String get navChallenges => 'Challenges';

  @override
  String get navHistory => 'History';

  @override
  String get navStreaming => 'Streaming';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeArenaTitle => 'SkillBet Arena';

  @override
  String get homeChooseAction => 'Choose your action';

  @override
  String get cardFindChallenge => 'FIND CHALLENGE';

  @override
  String get cardFindChallengeSubtitle =>
      'Create or join a 1v1 challenge and bet your SkillCoins';

  @override
  String get cardHistory => 'HISTORY';

  @override
  String get cardHistorySubtitle => 'View the history of all your challenges';

  @override
  String get tournamentBannerTitle => 'Weekly tournament — 100,000 FCFA';

  @override
  String get tournamentBannerShort =>
      'The big tournament starts Friday! Total prize: 100,000 FCFA. Reg…';

  @override
  String get eventTag => 'EVENT';

  @override
  String get eventModalTitle => 'Weekly tournament — 100,000 FCFA';

  @override
  String get eventModalBody =>
      'The weekly tournament starts Friday! Total prize: 100,000 FCFA. Registration is open now. Don’t miss this opportunity!';

  @override
  String get viewTournaments => 'View tournaments';

  @override
  String get later => 'Later';

  @override
  String get challengesTitle => 'Challenges';

  @override
  String get findChallenge => 'Find a challenge';

  @override
  String get findChallengeSubtitle =>
      'Create or join a 1v1 challenge and bet your SkillCoins.';

  @override
  String get challengeQuick => 'Quick 1v1';

  @override
  String get challengeMedium => 'Intermediate challenge';

  @override
  String get challengeExpert => 'Expert challenge';

  @override
  String get skillCoins500 => '500 SkillCoins';

  @override
  String get skillCoins1000 => '1,000 SkillCoins';

  @override
  String get skillCoins5000 => '5,000 SkillCoins';

  @override
  String get createChallenge => 'Create challenge';

  @override
  String get join => 'Join';

  @override
  String get historyTitle => 'History';

  @override
  String get historyYourChallenges => 'Your recent challenges';

  @override
  String get historySubtitle => 'View the history of all your challenges.';

  @override
  String get resultWin => 'Win';

  @override
  String get resultLoss => 'Loss';

  @override
  String get ago2h => '2h ago';

  @override
  String get ago1d => '1d ago';

  @override
  String get ago5h => '5h ago';

  @override
  String get ago1j => '1d ago';

  @override
  String get streamingTitle => 'Streaming';

  @override
  String get noLiveStream => 'No live stream';

  @override
  String get streamsAppearHere => 'Live streams will appear here.';

  @override
  String get tournamentsTitle => 'Tournaments';

  @override
  String get tournamentWeeklyBlurb =>
      'The weekly tournament starts Friday! Total prize: 100,000 FCFA. Registration is open now.';

  @override
  String get registerTournament => 'Register for tournament';

  @override
  String get otherTournaments => 'Other tournaments';

  @override
  String get tournamentWeekend => 'Weekend tournament';

  @override
  String get tournamentFriday => 'Friday challenge';

  @override
  String get prize50k => '50,000 FCFA';

  @override
  String get prize25k => '25,000 FCFA';

  @override
  String get announcementsTitle => 'Announcements';

  @override
  String get announcementsNews => 'News & updates';

  @override
  String get filterAll => 'All';

  @override
  String get filterNews => 'News';

  @override
  String get filterEvent => 'Event';

  @override
  String get filterInfo => 'Info';

  @override
  String get announcementWelcomeTitle => 'Welcome to KickFlow!';

  @override
  String get announcementWelcomeBody =>
      'Thanks for joining the KickFlow community! Challenge your friends, join tournaments and win real money playing eFootball.';

  @override
  String get announcementTournamentTitle => 'Weekly tournament — 100,000 FCFA';

  @override
  String get announcementTournamentBody =>
      'The weekly tournament starts Friday! Total prize: 100,000 FCFA. Registration is open now.';

  @override
  String get announcementRewardsTitle => 'New reward system';

  @override
  String get announcementRewardsBody =>
      'Earn loyalty points every match and unlock exclusive bonuses! The more you play, the more you earn.';

  @override
  String get time2h => '2h ago';

  @override
  String get time5h => '5h ago';

  @override
  String get time1d => '1d ago';

  @override
  String get badgeNew => 'NEW';

  @override
  String get badgeNewUpper => 'NEW';

  @override
  String get profileTitle => 'Profile';

  @override
  String get usernameLabel => 'Username';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get settings => 'Settings';

  @override
  String get help => 'Help';

  @override
  String get signOut => 'Sign out';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get country => 'Country';

  @override
  String get theme => 'Theme';

  @override
  String get notifications => 'Notifications';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get themePreviewDark => 'Preview: dark background (cyan).';

  @override
  String get themePreviewLight => 'Preview: light background (cyan).';

  @override
  String get notificationsEnabled => 'Enabled';

  @override
  String get notificationsDisabled => 'Disabled';

  @override
  String get langFrench => 'Français';

  @override
  String get langEnglish => 'English';

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get tapPhotoHint => 'Tap the image to pick a photo from your gallery.';

  @override
  String get newPassword => 'New password';

  @override
  String get phone => 'Phone';

  @override
  String get save => 'Save';

  @override
  String get imagePickError =>
      'Could not pick an image on this device. Restart the app after installing plugins.';

  @override
  String get sessionExpired => 'Session expired. Please sign in again.';

  @override
  String get updateFailed => 'Update failed.';

  @override
  String get profileUpdated => 'Profile updated successfully.';

  @override
  String get authError => 'Auth error.';

  @override
  String get emailRequired => 'Email is required.';

  @override
  String get emailInvalid => 'Invalid email.';

  @override
  String get min6chars => 'At least 6 characters.';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String get usernameRequired => 'Username is required.';

  @override
  String get min3chars => 'At least 3 characters.';

  @override
  String get linkInvalidTitle => 'Invalid link';

  @override
  String get linkExpiredMessage =>
      'This link has expired or has already been used.';

  @override
  String get linkExpiredHint =>
      'Request a new confirmation email or sign in again.';

  @override
  String get backToLogin => 'Back to sign in';

  @override
  String get paramsTransitionTitle => 'Let’s personalize your experience';

  @override
  String get paramsTransitionSubtitle =>
      'A few settings for language, your region and notifications.';

  @override
  String get paramsSetupTitle => 'Your preferences';

  @override
  String get paramsSetupHint => 'You can change these later in settings.';

  @override
  String get continueButton => 'Continue';

  @override
  String get saveFailed => 'Could not save.';

  @override
  String get dash => '—';
}
