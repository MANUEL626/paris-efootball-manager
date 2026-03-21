import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

/// Seul le type d’utilisateur **player** est autorisé à rester connecté.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const String _playerType = 'player';

  /// Vérifie `user_metadata` / `app_metadata` puis éventuellement la table `profiles`.
  Future<bool> isUserPlayer(String userId) async {
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    if (user == null || user.id != userId) return false;

    if (_metadataIsPlayer(user.userMetadata) ||
        _metadataIsPlayer(user.appMetadata)) {
      return true;
    }

    try {
      final row = await client
          .from('profiles')
          .select('user_type')
          .eq('id', userId)
          .maybeSingle();
      return row != null && row['user_type'] == _playerType;
    } catch (_) {
      return false;
    }
  }

  bool _metadataIsPlayer(Map<String, dynamic>? m) {
    if (m == null) return false;
    return m['user_type'] == _playerType;
  }

  /// Complétion du profil / onboarding (à adapter selon votre backend).
  Future<bool> isUserParamsDone(String userId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || user.id != userId) return false;
    final meta = user.userMetadata ?? {};
    if (meta['params_done'] == true || meta['onboarding_done'] == true) {
      return true;
    }
    try {
      final row = await Supabase.instance.client
          .from('profiles')
          .select('onboarding_done')
          .eq('id', userId)
          .maybeSingle();
      return row != null && row['onboarding_done'] == true;
    } catch (_) {
      return false;
    }
  }

  /// Photo par défaut : [AppConfig.defaultProfilePictureAsset] → `data:image/jpeg;base64,...`.
  Future<String> defaultProfilePictureDataUri() async {
    final bd = await rootBundle.load(AppConfig.defaultProfilePictureAsset);
    final b64 = base64Encode(bd.buffer.asUint8List());
    return 'data:image/jpeg;base64,$b64';
  }

  /// Inscription via `POST /api/v1/auth/signup` (corps JSON attendu par le backend).
  Future<SignUpPlayerResult> signUpPlayer({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,
    String? phone,
  }) async {
    final base = AppConfig.apiBaseUrl;
    if (base.isEmpty) {
      return SignUpPlayerResult(
        ok: false,
        statusCode: 0,
        message: 'API_BASE_URL non défini (dart-define).',
      );
    }

    final uri = Uri.parse('$base/api/v1/auth/signup');
    final profilePicture = await defaultProfilePictureDataUri();

    final body = <String, dynamic>{
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'user_type': _playerType,
      'phone': (phone == null || phone.trim().isEmpty) ? null : phone.trim(),
      'profile_data': {
        'username': username,
        'profile_picture': profilePicture,
      },
    };

    try {
      final resp = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode(body),
      );

      if (resp.statusCode == 201) {
        Map<String, dynamic>? json;
        try {
          json = jsonDecode(resp.body) as Map<String, dynamic>?;
        } catch (_) {}
        final needsEmail =
            json?['needs_email_confirmation'] as bool? ?? true;
        return SignUpPlayerResult(
          ok: true,
          statusCode: resp.statusCode,
          needsEmailConfirmation: needsEmail,
        );
      }

      String msg = 'Inscription impossible (${resp.statusCode}).';
      try {
        final j = jsonDecode(resp.body);
        if (j is Map && j['detail'] != null) msg = '${j['detail']}';
        if (j is Map && j['message'] != null) msg = '${j['message']}';
      } catch (_) {}

      return SignUpPlayerResult(
        ok: false,
        statusCode: resp.statusCode,
        message: msg,
      );
    } catch (e) {
      return SignUpPlayerResult(
        ok: false,
        statusCode: 0,
        message: e.toString(),
      );
    }
  }
}

class SignUpPlayerResult {
  SignUpPlayerResult({
    required this.ok,
    required this.statusCode,
    this.needsEmailConfirmation = false,
    this.message,
  });

  final bool ok;
  final int statusCode;
  final bool needsEmailConfirmation;
  final String? message;
}
