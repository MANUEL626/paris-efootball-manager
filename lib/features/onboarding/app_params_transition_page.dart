import 'package:flutter/material.dart';

import '../../core/l10n/context_l10n.dart';
import '../../core/routes/app_routes.dart';

/// Écran court avant la configuration des paramètres app (`is_params_done` == false).
class AppParamsTransitionPage extends StatefulWidget {
  const AppParamsTransitionPage({super.key});

  @override
  State<AppParamsTransitionPage> createState() =>
      _AppParamsTransitionPageState();
}

class _AppParamsTransitionPageState extends State<AppParamsTransitionPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();

    Future<void>.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.paramsSetup);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const cyan = Color(0xFF00BCD4);
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _opacity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.tune, size: 72, color: cyan.withOpacity(0.95)),
                  const SizedBox(height: 28),
                  Text(
                    l10n.paramsTransitionTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.paramsTransitionSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.78),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: cyan,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
