import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/auth/deep_link_handler.dart';
import 'core/config/app_config.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/auth_gate.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.load();

  if (!AppConfig.isSupabaseConfigured) {
    runApp(const _MissingSupabaseConfigApp());
    return;
  }

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      detectSessionInUri: false,
    ),
  );

  runApp(const KickFlowApp());
}

class _MissingSupabaseConfigApp extends StatelessWidget {
  const _MissingSupabaseConfigApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KickFlow - Paris eFootball',
      theme: AppTheme.dark,
      home: Scaffold(
        appBar: AppBar(title: const Text('Configuration')),
        body: const Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Configuration Supabase manquante.\n\n'
            '• Option A : à la racine du projet, exécutez :\n'
            '  dart run tool/sync_env.dart\n'
            '  (copie .env.local.json vers assets/env.json)\n\n'
            '• Option B : flutter run --dart-define-from-file=.env.local.json\n\n'
            '• Option C (Android Studio) : Run > Edit Configurations > '
            'Additional run args :\n'
            '  --dart-define-from-file=.env.local.json',
          ),
        ),
      ),
    );
  }
}

class KickFlowApp extends StatefulWidget {
  const KickFlowApp({super.key});

  @override
  State<KickFlowApp> createState() => _KickFlowAppState();
}

class _KickFlowAppState extends State<KickFlowApp> {
  StreamSubscription<Uri?>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _linkSubscription = AppLinks().uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        handleAuthDeepLink(uri, rootNavigatorKey);
      }
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KickFlow - Paris eFootball',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      navigatorKey: rootNavigatorKey,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      home: AuthGate(navigatorKey: rootNavigatorKey),
    );
  }
}
