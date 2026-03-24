import 'package:flutter/material.dart';

import '../../core/l10n/context_l10n.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/auth_service.dart';

/// Inscription joueur via API backend (`signUpPlayer`), pas `signUp` Supabase direct.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    final username = _usernameController.text.trim();
    final phone = _phoneController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        first.isEmpty ||
        last.isEmpty ||
        username.isEmpty) {
      _toast(l10n.registerFillRequired);
      return;
    }
    if (password != confirm) {
      _toast(l10n.passwordsMismatch);
      return;
    }

    setState(() => _loading = true);
    final result = await AuthService.instance.signUpPlayer(
      email: email,
      password: password,
      firstName: first,
      lastName: last,
      username: username,
      phone: phone.isEmpty ? null : phone,
    );
    if (!mounted) return;
    setState(() => _loading = false);

    if (result.ok) {
      final msg = result.needsEmailConfirmation
          ? l10n.accountCreatedEmail
          : l10n.accountCreatedOk;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    } else {
      _toast(result.message ?? l10n.signupFailed);
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l10n.createAccount),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Icon(Icons.sports_soccer, size: 56, color: cyan),
              const SizedBox(height: 24),
              Text(
                l10n.registerPlayerTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.registerPlayerSubtitle,
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: l10n.email,
                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.white54),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: l10n.password,
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.white54),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmController,
                decoration: InputDecoration(
                  labelText: l10n.confirmPassword,
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.white54),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: l10n.firstName,
                  prefixIcon: const Icon(Icons.person_outline, color: Colors.white54),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: l10n.lastName,
                  prefixIcon: const Icon(Icons.badge_outlined, color: Colors.white54),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: l10n.username,
                  prefixIcon: const Icon(Icons.alternate_email, color: Colors.white54),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: l10n.phoneOptional,
                  prefixIcon: const Icon(Icons.phone_outlined, color: Colors.white54),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.signUp),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.alreadyHaveAccount, style: TextStyle(color: Colors.white.withOpacity(0.8))),
                  TextButton(
                    onPressed: _loading ? null : () => Navigator.of(context).pop(),
                    child: Text(l10n.signIn),
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
