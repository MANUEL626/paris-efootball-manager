import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../services/auth_service.dart' show PlayerProfileResult;

/// Navigation après [AuthService.assertPlayerProfile] / [assertPlayerProfileWithRetries].
/// [notAllowed] et [error] ne sont pas gérés ici (déconnexion / snackbars côté appelant).
void navigateAfterPlayerProfileCheck({
  required PlayerProfileResult gate,
  GlobalKey<NavigatorState>? navigatorKey,
  BuildContext? context,
}) {
  final nav = _navigator(navigatorKey, context);
  if (nav == null) return;
  switch (gate) {
    case PlayerProfileResult.ok:
      nav.pushReplacementNamed(AppRoutes.home);
    case PlayerProfileResult.okNeedsParams:
      nav.pushReplacementNamed(AppRoutes.paramsTransition);
    case PlayerProfileResult.notAllowed:
    case PlayerProfileResult.error:
      break;
  }
}

/// Variante deep link : pile vidée avant d’aller à l’accueil ou au flux paramètres.
void pushNamedAndRemoveUntilAfterPlayerProfileCheck({
  required PlayerProfileResult gate,
  required GlobalKey<NavigatorState> navigatorKey,
}) {
  final nav = navigatorKey.currentState;
  if (nav == null) return;
  switch (gate) {
    case PlayerProfileResult.ok:
      nav.pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
    case PlayerProfileResult.okNeedsParams:
      nav.pushNamedAndRemoveUntil(AppRoutes.paramsTransition, (_) => false);
    case PlayerProfileResult.notAllowed:
    case PlayerProfileResult.error:
      break;
  }
}

NavigatorState? _navigator(
  GlobalKey<NavigatorState>? key,
  BuildContext? context,
) {
  if (key?.currentState != null) return key!.currentState;
  if (context != null && context.mounted) {
    try {
      return Navigator.of(context);
    } catch (_) {}
  }
  return null;
}
