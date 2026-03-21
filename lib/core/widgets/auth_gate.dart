import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/deep_link_handler.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';

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

    if (!await AuthService.instance.isUserPlayer(session.user.id)) {
      await Supabase.instance.client.auth.signOut();
      if (!mounted) return;
      widget.navigatorKey.currentState?.pushReplacementNamed(AppRoutes.login);
      return;
    }

    // Session joueur : accueil direct (onboarding réservé aux non-connectés).
    if (!mounted) return;
    widget.navigatorKey.currentState?.pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
