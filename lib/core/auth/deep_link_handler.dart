import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'profile_gate_navigation.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart' show AuthService, PlayerProfileResult;
import '../../l10n/app_localizations.dart';

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
  final gate = await AuthService.instance.assertPlayerProfileWithRetries(
    userId,
    context: 'deep_link_after_oauth',
  );
  if (gate == PlayerProfileResult.ok ||
      gate == PlayerProfileResult.okNeedsParams) {
    pushNamedAndRemoveUntilAfterPlayerProfileCheck(
      gate: gate,
      navigatorKey: navigatorKey,
    );
    return;
  }
  if (gate == PlayerProfileResult.notAllowed) {
    await AuthService.signOutSafe();
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.login,
      (_) => false,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = navigatorKey.currentContext;
      if (ctx != null && ctx.mounted) {
        final l10n = AppLocalizations.of(ctx);
        if (l10n != null) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text(l10n.profileNotAllowed)),
          );
        }
      }
    });
    return;
  }

  await AuthService.signOutSafe();
  navigatorKey.currentState?.pushNamedAndRemoveUntil(
    AppRoutes.login,
    (_) => false,
  );
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final ctx = navigatorKey.currentContext;
    if (ctx != null && ctx.mounted) {
      final l10n = AppLocalizations.of(ctx);
      if (l10n != null) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text(l10n.profileCheckFailed)),
        );
      }
    }
  });
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
