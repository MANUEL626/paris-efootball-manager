import 'package:flutter/material.dart';

import '../../features/announcements/announcements_page.dart';
import '../../features/auth/link_expired_page.dart';
import '../../features/auth/login_page.dart';
import '../../features/auth/register_page.dart';
import '../../features/challenges/challenges_page.dart';
import '../../features/history/history_page.dart';
import '../../features/home/main_shell.dart';
import '../../features/onboarding/onboarding_page.dart';
import '../../features/profile/profile_page.dart';
import '../../features/streaming/streaming_page.dart';
import '../../features/tournaments/tournaments_page.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String announcements = '/announcements';
  static const String tournaments = '/tournaments';
  static const String challenges = '/challenges';
  static const String history = '/history';
  static const String streaming = '/streaming';
  static const String profile = '/profile';
  static const String linkExpired = '/link-expired';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return _build(const OnboardingPage());
      case login:
        return _build(const LoginPage());
      case register:
        return _build(const RegisterPage());
      case home:
        return _build(const MainShell());
      case announcements:
        return _build(const AnnouncementsPage());
      case tournaments:
        return _build(const TournamentsPage());
      case challenges:
        return _build(const ChallengesPage());
      case history:
        return _build(const HistoryPage());
      case streaming:
        return _build(const StreamingPage());
      case profile:
        return _build(const ProfilePage());
      case linkExpired:
        return _build(const LinkExpiredPage());
      default:
        return _build(const LoginPage());
    }
  }

  static MaterialPageRoute<void> _build(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }
}
