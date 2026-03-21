import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;

/// Configuration : d’abord `--dart-define` / `--dart-define-from-file`, sinon [assetEnvPath].
///
/// Pour Android Studio sans argument : remplir [assetEnvPath] ou lancer `dart run tool/sync_env.dart`.
class AppConfig {
  AppConfig._();

  static const String assetEnvPath = 'assets/env.json';

  static String supabaseUrl = '';
  static String supabaseAnonKey = '';
  static String apiBaseUrl = '';

  /// Même schéma que dans Android / iOS (deep link OAuth + confirmation email).
  static const String oauthRedirectUri =
      'com.example.parisefootballmanager://login-callback';

  /// Image par défaut pour `profile_data.profile_picture` (data URI à l’inscription).
  static const String defaultProfilePictureAsset =
      'assets/image_profile_locale/efootball.jpg';

  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Charge la config (à appeler depuis `main()` après [WidgetsFlutterBinding.ensureInitialized]).
  static Future<void> load() async {
    const fromEnvUrl = String.fromEnvironment('SUPABASE_URL');
    const fromEnvKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    const fromEnvApi = String.fromEnvironment('API_BASE_URL');

    if (fromEnvUrl.isNotEmpty && fromEnvKey.isNotEmpty) {
      supabaseUrl = fromEnvUrl;
      supabaseAnonKey = fromEnvKey;
      apiBaseUrl = fromEnvApi;
      return;
    }

    if (kIsWeb) {
      return;
    }

    try {
      final raw = await rootBundle.loadString(assetEnvPath);
      final j = jsonDecode(raw) as Map<String, dynamic>?;
      if (j == null) return;
      supabaseUrl = (j['SUPABASE_URL'] as String?)?.trim() ?? '';
      supabaseAnonKey = (j['SUPABASE_ANON_KEY'] as String?)?.trim() ?? '';
      apiBaseUrl = (j['API_BASE_URL'] as String?)?.trim() ?? '';
    } catch (_) {
      // Asset absent ou JSON invalide : laisser vide.
    }
  }
}
