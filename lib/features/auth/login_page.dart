import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/profile_gate_navigation.dart';
import '../../core/config/app_config.dart';
import '../../core/l10n/context_l10n.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/auth_service.dart';

/// Connexion email / mot de passe + OAuth. Seuls les comptes **player** sont acceptés.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;

  /// Évite les navigations doubles (listener auth + post-frame + délais).
  bool _redirecting = false;

  StreamSubscription<AuthState>? _authSub;

  @override
  void initState() {
    super.initState();
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.session == null || !mounted) return;
      switch (data.event) {
        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.initialSession:
          _tryEnterAppIfPlayer();
          break;
        default:
          break;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryEnterAppIfPlayer();
      Future<void>.delayed(const Duration(milliseconds: 400), () {
        if (mounted) _tryEnterAppIfPlayer();
      });
      Future<void>.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) _tryEnterAppIfPlayer();
      });
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Session présente : vérifie le profil (RPC avec retries). Échec → déconnexion.
  /// Pendant « Se connecter », le listener auth ne doit pas lancer une 2ᵉ vérif en parallèle.
  Future<void> _tryEnterAppIfPlayer() async {
    if (_loading) return;
    if (_redirecting || !mounted) return;
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) return;

    _redirecting = true;
    try {
      final gate = await AuthService.instance.assertPlayerProfileWithRetries(
        session.user.id,
        context: 'login_session_listener',
      );
      if (!mounted) return;

      if (gate == PlayerProfileResult.ok ||
          gate == PlayerProfileResult.okNeedsParams) {
        navigateAfterPlayerProfileCheck(gate: gate, context: context);
        return;
      }
      if (gate == PlayerProfileResult.notAllowed) {
        await AuthService.signOutSafe();
        if (!mounted) return;
        _toast(context.l10n.profileNotAllowed);
        return;
      }

      await AuthService.signOutSafe();
      if (!mounted) return;
      _toast(context.l10n.profileCheckFailed);
    } finally {
      if (mounted) _redirecting = false;
    }
  }

  Future<void> _onLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _toast(context.l10n.fillEmailPassword);
      return;
    }

    setState(() => _loading = true);
    try {
      AuthService.debugConnection('signInWithPassword démarrage');
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (!mounted) return;
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        AuthService.debugConnection(
          'signInWithPassword : currentUser null après succès apparent',
        );
        _toast(context.l10n.loginFailed);
        return;
      }

      AuthService.debugConnection(
        'signInWithPassword OK → vérification profil (user=${user.id.substring(0, 8)}…)',
      );
      final gate = await AuthService.instance.assertPlayerProfileWithRetries(
        user.id,
        context: 'login_password_submit',
      );
      if (!mounted) return;

      if (gate == PlayerProfileResult.ok ||
          gate == PlayerProfileResult.okNeedsParams) {
        navigateAfterPlayerProfileCheck(gate: gate, context: context);
        return;
      }
      if (gate == PlayerProfileResult.notAllowed) {
        await AuthService.signOutSafe();
        if (!mounted) return;
        _toast(context.l10n.profileNotAllowed);
        return;
      }

      await AuthService.signOutSafe();
      if (!mounted) return;
      _toast(context.l10n.profileCheckFailed);
    } on AuthException catch (e, st) {
      AuthService.debugConnection(
        'signInWithPassword AuthException',
        error: e,
        stackTrace: st,
      );
      _toast(e.message.isNotEmpty ? e.message : context.l10n.wrongPassword);
    } catch (e, st) {
      AuthService.debugConnection(
        'signInWithPassword erreur inattendue',
        error: e,
        stackTrace: st,
      );
      final s = e.toString();
      if (s.contains('520') || s.contains('502') || s.contains('503')) {
        _toast(context.l10n.serverTemporarilyUnavailable);
      } else {
        _toast(s);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _oauth(OAuthProvider provider) async {
    setState(() => _loading = true);
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        provider,
        redirectTo: AppConfig.oauthRedirectUri,
      );
    } catch (e) {
      if (mounted) _toast(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    const cyan = Color(0xFF00BCD4);
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              Icon(Icons.sports_soccer, size: 64, color: cyan),
              const SizedBox(height: 24),
              Text(
                l10n.loginWelcome,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.loginSubtitle,
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.email,
                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.white54),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: l10n.password,
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.white54),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white54,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _onLogin,
                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.signIn),
                ),
              ),
              const SizedBox(height: 24),
              Text(l10n.orDivider, style: TextStyle(color: Colors.white.withOpacity(0.6))),
              const SizedBox(height: 24),
              _SocialButton(
                icon: Icons.phone,
                label: l10n.phoneLoginSoon,
                onPressed: _loading
                    ? null
                    : () => _toast(l10n.phoneLoginSoon),
              ),
              const SizedBox(height: 12),
              _SocialButton(
                icon: Icons.g_mobiledata,
                label: l10n.signInWithGoogle,
                onPressed: _loading ? null : () => _oauth(OAuthProvider.google),
              ),
              const SizedBox(height: 12),
              _SocialButton(
                icon: Icons.facebook,
                label: l10n.signInWithFacebook,
                onPressed: _loading ? null : () => _oauth(OAuthProvider.facebook),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.noAccount, style: TextStyle(color: Colors.white.withOpacity(0.8))),
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () => Navigator.of(context).pushNamed(AppRoutes.register),
                    child: Text(l10n.signUp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFF00BCD4)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}
