import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/auth/deep_link_handler.dart';
import 'core/config/app_config.dart';
import 'core/state/app_settings_scope.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/auth_gate.dart';
import 'l10n/app_localizations.dart';

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
    final lang = PlatformDispatcher.instance.locale.languageCode;
    final locale = lang == 'en' ? const Locale('en') : const Locale('fr');
    return MaterialApp(
      title: 'KickFlow - Paris eFootball',
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.dark,
      home: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            appBar: AppBar(title: Text(l10n.configuration)),
            body: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l10n.configurationMissingBody),
            ),
          );
        },
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
  final ValueNotifier<ThemeMode> _themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.dark);
  final ValueNotifier<String> _languageCode = ValueNotifier<String>('fr');
  final ValueNotifier<String> _countryCode = ValueNotifier<String>('FR');
  final ValueNotifier<bool> _notificationsEnabled = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    final lang = PlatformDispatcher.instance.locale.languageCode;
    if (lang == 'en') _languageCode.value = 'en';
    _linkSubscription = AppLinks().uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        handleAuthDeepLink(uri, rootNavigatorKey);
      }
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _themeMode.dispose();
    _languageCode.dispose();
    _countryCode.dispose();
    _notificationsEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsScope(
      themeMode: _themeMode,
      languageCode: _languageCode,
      countryCode: _countryCode,
      notificationsEnabled: _notificationsEnabled,
      child: ValueListenableBuilder<String>(
        valueListenable: _languageCode,
        builder: (context, lang, _) {
          return ValueListenableBuilder<ThemeMode>(
            valueListenable: _themeMode,
            builder: (context, themeMode, _) {
              return MaterialApp(
                title: 'KickFlow - Paris eFootball',
                debugShowCheckedModeBanner: false,
                locale: Locale(lang),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                themeMode: themeMode,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                navigatorKey: rootNavigatorKey,
                onGenerateRoute: AppRoutes.onGenerateRoute,
                home: AuthGate(navigatorKey: rootNavigatorKey),
              );
            },
          );
        },
      ),
    );
  }
}
