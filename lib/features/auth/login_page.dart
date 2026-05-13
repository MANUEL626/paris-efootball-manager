import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';

/// Page de connexion (auth).
/// Pour l'instant : le bouton "Se connecter" mène directement à l'accueil.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    // Pas de logique pour l'instant : navigation directe vers l'accueil
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
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
                  onPressed: _onLogin,
                  child: const Text('Se connecter'),
                ),
              ),
              const SizedBox(height: 24),
              Text('OU', style: TextStyle(color: Colors.white.withOpacity(0.6))),
              const SizedBox(height: 24),
              _SocialButton(icon: Icons.phone, label: 'Connexion par téléphone'),
              const SizedBox(height: 12),
              _SocialButton(icon: Icons.g_mobiledata, label: 'Connexion avec Google'),
              const SizedBox(height: 12),
              _SocialButton(icon: Icons.facebook, label: 'Connexion avec Facebook'),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Pas encore de compte ? ', style: TextStyle(color: Colors.white.withOpacity(0.8))),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.register),
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
  const _SocialButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
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
