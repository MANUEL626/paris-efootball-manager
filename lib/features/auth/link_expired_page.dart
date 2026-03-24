import 'package:flutter/material.dart';

import '../../core/l10n/context_l10n.dart';
import '../../core/routes/app_routes.dart';

/// Lien de confirmation expiré ou invalide (voir guide deep link).
class LinkExpiredPage extends StatelessWidget {
  const LinkExpiredPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.linkInvalidTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.link_off, size: 64, color: Colors.amber.shade200),
              const SizedBox(height: 24),
              Text(
                l10n.linkExpiredMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.linkExpiredHint,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(AppRoutes.login, (_) => false),
                  child: Text(l10n.backToLogin),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
