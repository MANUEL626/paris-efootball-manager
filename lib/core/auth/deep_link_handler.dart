import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../routes/app_routes.dart';
import '../services/auth_service.dart';

/// Erreurs dans l’URL (lien expiré, refus, etc.).
bool isAuthDeepLinkError(Uri uri) {
  final q = uri.queryParameters;
  if (q['error'] != null || q['error_code'] != null) return true;
  final frag = uri.fragment;
  if (frag.isEmpty) return false;
  if (frag.contains('error=') ||
      frag.contains('otp_expired') ||
      frag.contains('access_denied')) {
    return true;
  }
  final s = uri.toString();
  return s.contains('otp_expired') || s.contains('access_denied');
}

/// Lien de confirmation OAuth / email Supabase.
bool looksLikeAuthCallback(Uri uri) {
  final s = uri.toString();
  if (s.contains('login-callback')) return true;
  if (uri.queryParameters.containsKey('code')) return true;
  if (uri.fragment.contains('access_token') ||
      uri.queryParameters.containsKey('access_token')) {
    return true;
  }
  return uri.fragment.contains('refresh_token') ||
      uri.queryParameters.containsKey('refresh_token');
}

/// Après [getSessionFromUrl] : vérifie **player**, puis accueil (onboarding = invités uniquement).
Future<void> navigateAfterSessionFromUrl(
  GlobalKey<NavigatorState> navigatorKey,
) async {
  final nav = navigatorKey.currentState;
  if (nav == null) return;

  final session = Supabase.instance.client.auth.currentSession;
  if (session == null) return;

  final userId = session.user.id;
  if (!await AuthService.instance.isUserPlayer(userId)) {
    await Supabase.instance.client.auth.signOut();
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.login,
      (_) => false,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = navigatorKey.currentContext;
      if (ctx != null && ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Ce compte n’est pas un compte joueur.'),
          ),
        );
      }
    });
    return;
  }

  navigatorKey.currentState?.pushNamedAndRemoveUntil(
    AppRoutes.home,
    (_) => false,
  );
}

Future<void> handleAuthDeepLink(
  Uri uri,
  GlobalKey<NavigatorState> navigatorKey,
) async {
  if (!looksLikeAuthCallback(uri)) return;

  if (isAuthDeepLinkError(uri)) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.linkExpired,
      (_) => false,
    );
    return;
  }

  try {
    await Supabase.instance.client.auth.getSessionFromUrl(uri);
    await navigateAfterSessionFromUrl(navigatorKey);
  } on AuthException {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.linkExpired,
      (_) => false,
    );
  } catch (_) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.linkExpired,
      (_) => false,
    );
  }
}
