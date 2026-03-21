import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/app_config.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirectIfAlreadyLoggedIn());
  }

  /// Session déjà présente (stockage local Supabase) : pas besoin de se reconnecter → accueil.
  Future<void> _redirectIfAlreadyLoggedIn() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null || !mounted) return;

    if (await AuthService.instance.isUserPlayer(session.user.id)) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _toast('Renseignez l’email et le mot de passe.');
      return;
    }

    setState(() => _loading = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        _toast('Connexion impossible.');
        return;
      }

      if (!await AuthService.instance.isUserPlayer(user.id)) {
        await Supabase.instance.client.auth.signOut();
        if (!mounted) return;
        _toast('Seuls les comptes joueur peuvent se connecter.');
        return;
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } on AuthException catch (e) {
      _toast(e.message.isNotEmpty ? e.message : 'Email ou mot de passe incorrect.');
    } catch (e) {
      final s = e.toString();
      if (s.contains('520') || s.contains('502') || s.contains('503')) {
        _toast(
          'Serveur temporairement indisponible (erreur réseau). '
          'Si vous êtes déjà connecté, redémarrez l’app ou réessayez plus tard.',
        );
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
                'Bienvenue !',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Connectez-vous pour continuer',
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined, color: Colors.white54),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
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
                      : const Text('Se connecter'),
                ),
              ),
              const SizedBox(height: 24),
              Text('OU', style: TextStyle(color: Colors.white.withOpacity(0.6))),
              const SizedBox(height: 24),
              _SocialButton(
                icon: Icons.phone,
                label: 'Connexion par téléphone',
                onPressed: _loading
                    ? null
                    : () => _toast('Bientôt disponible.'),
              ),
              const SizedBox(height: 12),
              _SocialButton(
                icon: Icons.g_mobiledata,
                label: 'Connexion avec Google',
                onPressed: _loading ? null : () => _oauth(OAuthProvider.google),
              ),
              const SizedBox(height: 12),
              _SocialButton(
                icon: Icons.facebook,
                label: 'Connexion avec Facebook',
                onPressed: _loading ? null : () => _oauth(OAuthProvider.facebook),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Pas encore de compte ? ', style: TextStyle(color: Colors.white.withOpacity(0.8))),
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () => Navigator.of(context).pushNamed(AppRoutes.register),
                    child: const Text("S'inscrire"),
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
