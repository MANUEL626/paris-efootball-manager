import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'KickFlow - Paris eFootball'**
  String get appTitle;

  /// No description provided for @configuration.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get configuration;

  /// No description provided for @configurationMissingBody.
  ///
  /// In en, this message translates to:
  /// **'Supabase configuration is missing.\n\n• Option A: at the project root, run:\n  dart run tool/sync_env.dart\n  (copies .env.local.json to assets/env.json)\n\n• Option B: flutter run --dart-define-from-file=.env.local.json\n\n• Option C (Android Studio): Run > Edit Configurations > Additional run args:\n  --dart-define-from-file=.env.local.json'**
  String get configurationMissingBody;

  /// No description provided for @profileNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Your profile does not allow you to sign in.'**
  String get profileNotAllowed;

  /// No description provided for @profileCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'We could not verify your profile. You have been signed out. Please try again.'**
  String get profileCheckFailed;

  /// No description provided for @loginWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get loginWelcome;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get loginSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orDivider;

  /// No description provided for @phoneLoginSoon.
  ///
  /// In en, this message translates to:
  /// **'Phone sign-in — coming soon.'**
  String get phoneLoginSoon;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Facebook'**
  String get signInWithFacebook;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'No account yet? '**
  String get noAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @fillEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and password.'**
  String get fillEmailPassword;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in.'**
  String get loginFailed;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get wrongPassword;

  /// No description provided for @serverTemporarilyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Server temporarily unavailable (network error). If you are already signed in, restart the app or try again later.'**
  String get serverTemporarilyUnavailable;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @registerPlayerTitle.
  ///
  /// In en, this message translates to:
  /// **'Player registration'**
  String get registerPlayerTitle;

  /// No description provided for @registerPlayerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account to join the KickFlow community.'**
  String get registerPlayerSubtitle;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @phoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get phoneOptional;

  /// No description provided for @registerFillRequired.
  ///
  /// In en, this message translates to:
  /// **'Fill in email, password, first name, last name and username.'**
  String get registerFillRequired;

  /// No description provided for @passwordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsMismatch;

  /// No description provided for @accountCreatedEmail.
  ///
  /// In en, this message translates to:
  /// **'Account created. Check your inbox to confirm your email.'**
  String get accountCreatedEmail;

  /// No description provided for @accountCreatedOk.
  ///
  /// In en, this message translates to:
  /// **'Account created. You can sign in.'**
  String get accountCreatedOk;

  /// No description provided for @signupFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed.'**
  String get signupFailed;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Challenge the best'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Create eFootball challenges and face players worldwide'**
  String get onboardingSlide1Subtitle;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Earn tokens'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Bet, win and withdraw your earnings safely'**
  String get onboardingSlide2Subtitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navChallenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get navChallenges;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navStreaming.
  ///
  /// In en, this message translates to:
  /// **'Streaming'**
  String get navStreaming;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @homeArenaTitle.
  ///
  /// In en, this message translates to:
  /// **'SkillBet Arena'**
  String get homeArenaTitle;

  /// No description provided for @homeChooseAction.
  ///
  /// In en, this message translates to:
  /// **'Choose your action'**
  String get homeChooseAction;

  /// No description provided for @cardFindChallenge.
  ///
  /// In en, this message translates to:
  /// **'FIND CHALLENGE'**
  String get cardFindChallenge;

  /// No description provided for @cardFindChallengeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create or join a 1v1 challenge and bet your SkillCoins'**
  String get cardFindChallengeSubtitle;

  /// No description provided for @cardHistory.
  ///
  /// In en, this message translates to:
  /// **'HISTORY'**
  String get cardHistory;

  /// No description provided for @cardHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View the history of all your challenges'**
  String get cardHistorySubtitle;

  /// No description provided for @tournamentBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly tournament — 100,000 FCFA'**
  String get tournamentBannerTitle;

  /// No description provided for @tournamentBannerShort.
  ///
  /// In en, this message translates to:
  /// **'The big tournament starts Friday! Total prize: 100,000 FCFA. Reg…'**
  String get tournamentBannerShort;

  /// No description provided for @eventTag.
  ///
  /// In en, this message translates to:
  /// **'EVENT'**
  String get eventTag;

  /// No description provided for @eventModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly tournament — 100,000 FCFA'**
  String get eventModalTitle;

  /// No description provided for @eventModalBody.
  ///
  /// In en, this message translates to:
  /// **'The weekly tournament starts Friday! Total prize: 100,000 FCFA. Registration is open now. Don’t miss this opportunity!'**
  String get eventModalBody;

  /// No description provided for @viewTournaments.
  ///
  /// In en, this message translates to:
  /// **'View tournaments'**
  String get viewTournaments;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @challengesTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get challengesTitle;

  /// No description provided for @findChallenge.
  ///
  /// In en, this message translates to:
  /// **'Find a challenge'**
  String get findChallenge;

  /// No description provided for @findChallengeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create or join a 1v1 challenge and bet your SkillCoins.'**
  String get findChallengeSubtitle;

  /// No description provided for @challengeQuick.
  ///
  /// In en, this message translates to:
  /// **'Quick 1v1'**
  String get challengeQuick;

  /// No description provided for @challengeMedium.
  ///
  /// In en, this message translates to:
  /// **'Intermediate challenge'**
  String get challengeMedium;

  /// No description provided for @challengeExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert challenge'**
  String get challengeExpert;

  /// No description provided for @skillCoins500.
  ///
  /// In en, this message translates to:
  /// **'500 SkillCoins'**
  String get skillCoins500;

  /// No description provided for @skillCoins1000.
  ///
  /// In en, this message translates to:
  /// **'1,000 SkillCoins'**
  String get skillCoins1000;

  /// No description provided for @skillCoins5000.
  ///
  /// In en, this message translates to:
  /// **'5,000 SkillCoins'**
  String get skillCoins5000;

  /// No description provided for @createChallenge.
  ///
  /// In en, this message translates to:
  /// **'Create challenge'**
  String get createChallenge;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historyYourChallenges.
  ///
  /// In en, this message translates to:
  /// **'Your recent challenges'**
  String get historyYourChallenges;

  /// No description provided for @historySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View the history of all your challenges.'**
  String get historySubtitle;

  /// No description provided for @resultWin.
  ///
  /// In en, this message translates to:
  /// **'Win'**
  String get resultWin;

  /// No description provided for @resultLoss.
  ///
  /// In en, this message translates to:
  /// **'Loss'**
  String get resultLoss;

  /// No description provided for @ago2h.
  ///
  /// In en, this message translates to:
  /// **'2h ago'**
  String get ago2h;

  /// No description provided for @ago1d.
  ///
  /// In en, this message translates to:
  /// **'1d ago'**
  String get ago1d;

  /// No description provided for @ago5h.
  ///
  /// In en, this message translates to:
  /// **'5h ago'**
  String get ago5h;

  /// No description provided for @ago1j.
  ///
  /// In en, this message translates to:
  /// **'1d ago'**
  String get ago1j;

  /// No description provided for @streamingTitle.
  ///
  /// In en, this message translates to:
  /// **'Streaming'**
  String get streamingTitle;

  /// No description provided for @noLiveStream.
  ///
  /// In en, this message translates to:
  /// **'No live stream'**
  String get noLiveStream;

  /// No description provided for @streamsAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Live streams will appear here.'**
  String get streamsAppearHere;

  /// No description provided for @tournamentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tournaments'**
  String get tournamentsTitle;

  /// No description provided for @tournamentWeeklyBlurb.
  ///
  /// In en, this message translates to:
  /// **'The weekly tournament starts Friday! Total prize: 100,000 FCFA. Registration is open now.'**
  String get tournamentWeeklyBlurb;

  /// No description provided for @registerTournament.
  ///
  /// In en, this message translates to:
  /// **'Register for tournament'**
  String get registerTournament;

  /// No description provided for @otherTournaments.
  ///
  /// In en, this message translates to:
  /// **'Other tournaments'**
  String get otherTournaments;

  /// No description provided for @tournamentWeekend.
  ///
  /// In en, this message translates to:
  /// **'Weekend tournament'**
  String get tournamentWeekend;

  /// No description provided for @tournamentFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday challenge'**
  String get tournamentFriday;

  /// No description provided for @prize50k.
  ///
  /// In en, this message translates to:
  /// **'50,000 FCFA'**
  String get prize50k;

  /// No description provided for @prize25k.
  ///
  /// In en, this message translates to:
  /// **'25,000 FCFA'**
  String get prize25k;

  /// No description provided for @announcementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get announcementsTitle;

  /// No description provided for @announcementsNews.
  ///
  /// In en, this message translates to:
  /// **'News & updates'**
  String get announcementsNews;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get filterNews;

  /// No description provided for @filterEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get filterEvent;

  /// No description provided for @filterInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get filterInfo;

  /// No description provided for @announcementWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to KickFlow!'**
  String get announcementWelcomeTitle;

  /// No description provided for @announcementWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Thanks for joining the KickFlow community! Challenge your friends, join tournaments and win real money playing eFootball.'**
  String get announcementWelcomeBody;

  /// No description provided for @announcementTournamentTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly tournament — 100,000 FCFA'**
  String get announcementTournamentTitle;

  /// No description provided for @announcementTournamentBody.
  ///
  /// In en, this message translates to:
  /// **'The weekly tournament starts Friday! Total prize: 100,000 FCFA. Registration is open now.'**
  String get announcementTournamentBody;

  /// No description provided for @announcementRewardsTitle.
  ///
  /// In en, this message translates to:
  /// **'New reward system'**
  String get announcementRewardsTitle;

  /// No description provided for @announcementRewardsBody.
  ///
  /// In en, this message translates to:
  /// **'Earn loyalty points every match and unlock exclusive bonuses! The more you play, the more you earn.'**
  String get announcementRewardsBody;

  /// No description provided for @time2h.
  ///
  /// In en, this message translates to:
  /// **'2h ago'**
  String get time2h;

  /// No description provided for @time5h.
  ///
  /// In en, this message translates to:
  /// **'5h ago'**
  String get time5h;

  /// No description provided for @time1d.
  ///
  /// In en, this message translates to:
  /// **'1d ago'**
  String get time1d;

  /// No description provided for @badgeNew.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get badgeNew;

  /// No description provided for @badgeNewUpper.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get badgeNewUpper;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themePreviewDark.
  ///
  /// In en, this message translates to:
  /// **'Preview: dark background (cyan).'**
  String get themePreviewDark;

  /// No description provided for @themePreviewLight.
  ///
  /// In en, this message translates to:
  /// **'Preview: light background (cyan).'**
  String get themePreviewLight;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get notificationsEnabled;

  /// No description provided for @notificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get notificationsDisabled;

  /// No description provided for @langFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get langFrench;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileTitle;

  /// No description provided for @tapPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the image to pick a photo from your gallery.'**
  String get tapPhotoHint;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @imagePickError.
  ///
  /// In en, this message translates to:
  /// **'Could not pick an image on this device. Restart the app after installing plugins.'**
  String get imagePickError;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please sign in again.'**
  String get sessionExpired;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed.'**
  String get updateFailed;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get profileUpdated;

  /// No description provided for @authError.
  ///
  /// In en, this message translates to:
  /// **'Auth error.'**
  String get authError;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required.'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email.'**
  String get emailInvalid;

  /// No description provided for @min6chars.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters.'**
  String get min6chars;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required.'**
  String get usernameRequired;

  /// No description provided for @min3chars.
  ///
  /// In en, this message translates to:
  /// **'At least 3 characters.'**
  String get min3chars;

  /// No description provided for @linkInvalidTitle.
  ///
  /// In en, this message translates to:
  /// **'Invalid link'**
  String get linkInvalidTitle;

  /// No description provided for @linkExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'This link has expired or has already been used.'**
  String get linkExpiredMessage;

  /// No description provided for @linkExpiredHint.
  ///
  /// In en, this message translates to:
  /// **'Request a new confirmation email or sign in again.'**
  String get linkExpiredHint;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToLogin;

  /// No description provided for @paramsTransitionTitle.
  ///
  /// In en, this message translates to:
  /// **'Let’s personalize your experience'**
  String get paramsTransitionTitle;

  /// No description provided for @paramsTransitionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A few settings for language, your region and notifications.'**
  String get paramsTransitionSubtitle;

  /// No description provided for @paramsSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Your preferences'**
  String get paramsSetupTitle;

  /// No description provided for @paramsSetupHint.
  ///
  /// In en, this message translates to:
  /// **'You can change these later in settings.'**
  String get paramsSetupHint;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save.'**
  String get saveFailed;

  /// No description provided for @dash.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get dash;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
