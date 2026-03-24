import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/deep_link_handler.dart';
import '../auth/profile_gate_navigation.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart' show AuthService, PlayerProfileResult;
import '../../l10n/app_localizations.dart';

/// Premier écran : deep link d’auth, puis session existante, sinon onboarding.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key, required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _boot());
  }

  Future<void> _boot() async {
    final initial = await AppLinks().getInitialLink();
    if (!mounted) return;
    if (initial != null && looksLikeAuthCallback(initial)) {
      await handleAuthDeepLink(initial, widget.navigatorKey);
      return;
    }

    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      widget.navigatorKey.currentState
          ?.pushReplacementNamed(AppRoutes.onboarding);
      return;
    }

    final gate = await AuthService.instance.assertPlayerProfileWithRetries(
      session.user.id,
      context: 'auth_gate_cold_start',
    );
    if (gate == PlayerProfileResult.ok ||
        gate == PlayerProfileResult.okNeedsParams) {
      if (!mounted) return;
      navigateAfterPlayerProfileCheck(
        gate: gate,
        navigatorKey: widget.navigatorKey,
      );
      return;
    }
    if (gate == PlayerProfileResult.notAllowed) {
      await AuthService.signOutSafe();
      if (!mounted) return;
      widget.navigatorKey.currentState?.pushReplacementNamed(AppRoutes.login);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = widget.navigatorKey.currentContext;
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

    // Erreur RPC persistante : pas d’accès sans vérification → déconnexion + login.
    await AuthService.signOutSafe();
    if (!mounted) return;
    widget.navigatorKey.currentState?.pushReplacementNamed(AppRoutes.login);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = widget.navigatorKey.currentContext;
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

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
