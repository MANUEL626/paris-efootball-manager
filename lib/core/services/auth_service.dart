import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

const String _authLogName = 'KickFlowAuth';

void _authLog(
  String message, {
  Object? error,
  StackTrace? stackTrace,
}) {
  if (!kDebugMode) return;
  developer.log(
    message,
    name: _authLogName,
    error: error,
    stackTrace: stackTrace,
  );
}

String _shortId(String id) =>
    id.length <= 12 ? id : '${id.substring(0, 8)}…';

String _previewRaw(dynamic raw, {int max = 240}) {
  if (raw == null) return 'null';
  final s = raw.toString();
  if (s.length <= max) return s;
  return '${s.substring(0, max)}… (len=${s.length})';
}

/// Résultat de [AuthService.assertPlayerProfile].
enum PlayerProfileResult {
  ok,
  /// Player confirmé mais `is_params_done` == false → flux paramètres app.
  okNeedsParams,
  /// Profil absent ou `user_type` ≠ player
  notAllowed,
  /// Erreur API profil / réseau
  error,
}

/// Seul le type d’utilisateur **player** est autorisé (vérifié via `GET /api/v1/auth/profile/...`).
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  /// Une seule série de tentatives à la fois par utilisateur (évite appels concurrents doublés).
  static final Map<String, Future<PlayerProfileResult>> _profileCheckInFlight = {};

  static const String _playerType = 'player';

  static const String messageProfileNotAllowed =
      'Votre profil ne vous permet pas de vous connecter.';
  /// API profil en erreur après tentatives : l’utilisateur est déconnecté.
  static const String messageProfileCheckFailed =
      'Impossible de vérifier votre profil. Vous avez été déconnecté. Réessayez.';

  /// Log de diagnostic depuis l’UI (connexion, erreurs catch). Debug uniquement.
  static void debugConnection(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _authLog('[connexion] $message', error: error, stackTrace: stackTrace);
  }

  /// Déconnexion : GoTrue efface d’abord la session **locale**, puis appelle l’API.
  /// Un 520 / timeout sur l’invalidation serveur ne doit pas faire planter l’app.
  static Future<void> signOutSafe() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (_) {
      // Ignoré : session locale déjà supprimée ; échec réseau sur la révocation distante.
    }
  }

  static String _apiBaseTrimmed() =>
      AppConfig.apiBaseUrl.trim().replaceAll(RegExp(r'/+$'), '');

  static Uri _authProfileUri(String userId) =>
      Uri.parse('${_apiBaseTrimmed()}/api/v1/auth/profile/$userId');

  static Uri _updateUserUri(String userId) =>
      Uri.parse('${_apiBaseTrimmed()}/api/v1/users/$userId');

  static Uri _updateUserParamsUri(String userId) =>
      Uri.parse('${_apiBaseTrimmed()}/api/v1/users/$userId/params');

  /// Corps JSON décodé → carte profil (liste d’une ligne, chaîne JSON, etc.).
  Map<String, dynamic>? _profileMapFromDecoded(dynamic raw) {
    if (raw == null) return null;
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    if (raw is String) {
      try {
        final decoded = jsonDecode(raw);
        return _profileMapFromDecoded(decoded);
      } catch (_) {
        return null;
      }
    }
    if (raw is List && raw.isNotEmpty) {
      final first = raw.first;
      if (first is Map<String, dynamic>) return first;
      if (first is Map) return Map<String, dynamic>.from(first);
    }
    return null;
  }

  /// Réponse `GET /api/v1/auth/profile/...` : supporte enveloppe `data` et `profile_data`.
  Map<String, dynamic>? _profileMapFromApiBody(String body) {
    dynamic decoded;
    try {
      decoded = jsonDecode(body);
    } catch (_) {
      return null;
    }
    var map = _profileMapFromDecoded(decoded);
    if (map == null) return null;
    final data = map['data'];
    if (data is Map) {
      map = Map<String, dynamic>.from(data);
    }
    final flat = Map<String, dynamic>.from(map);
    final pd = flat['profile_data'];
    if (pd is Map) {
      for (final e in pd.entries) {
        if (!flat.containsKey(e.key)) {
          flat[e.key] = e.value;
        }
      }
    }
    return flat;
  }

  /// `true` si les paramètres app sont considérés comme faits (défaut : oui si champ absent).
  bool _parseIsParamsDone(Map<String, dynamic> map) {
    if (!map.containsKey('is_params_done') &&
        !map.containsKey('isParamsDone')) {
      return true;
    }
    final v = map['is_params_done'] ?? map['isParamsDone'];
    if (v == null) return true;
    if (v is bool) return v;
    if (v is String) return v.toLowerCase() == 'true' || v == '1';
    return true;
  }

  /// Profil via backend : `GET /api/v1/auth/profile/<uuid>` +
  /// `Authorization: Bearer <INTERNAL_API_BEARER>` (voir [AppConfig.effectiveInternalApiBearer]).
  Future<Map<String, dynamic>?> fetchUserProfileById(String userId) async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      _authLog('fetchUserProfileById : pas de session, requête ignorée');
      return null;
    }
    final uid = session.user.id;
    if (uid != userId) {
      _authLog(
        'fetchUserProfileById : userId≠session.user.id '
        '(demandé=${_shortId(userId)}, session=${_shortId(uid)})',
      );
      return null;
    }
    final base = _apiBaseTrimmed();
    if (base.isEmpty) {
      _authLog('fetchUserProfileById : API_BASE_URL vide');
      return null;
    }
    try {
      final resp = await http.get(
        _authProfileUri(uid),
        headers: {
          'Authorization':
              'Bearer ${AppConfig.effectiveInternalApiBearer}',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      );
      if (resp.statusCode != 200) {
        _authLog(
          'fetchUserProfileById : HTTP ${resp.statusCode} ${_previewRaw(resp.body)}',
        );
        return null;
      }
      return _profileMapFromApiBody(resp.body);
    } catch (e, st) {
      _authLog('fetchUserProfileById : exception', error: e, stackTrace: st);
      return null;
    }
  }

  /// Vérifie le profil via l’API : `user_type == player`.
  Future<PlayerProfileResult> assertPlayerProfile(
    String userId, {
    String context = '',
  }) async {
    final ctx = context.isEmpty ? '' : ' [$context]';
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    final session = client.auth.currentSession;
    if (user == null || session == null || user.id != userId) {
      _authLog(
        'assertPlayerProfile$ctx → notAllowed : pas de session ou user.id≠userId '
        '(courant=${user == null ? "null" : _shortId(user.id)}, attendu=${_shortId(userId)})',
      );
      return PlayerProfileResult.notAllowed;
    }
    final base = _apiBaseTrimmed();
    if (base.isEmpty) {
      _authLog('assertPlayerProfile$ctx → error : API_BASE_URL vide');
      return PlayerProfileResult.error;
    }
    try {
      _authLog(
        'assertPlayerProfile$ctx → GET /api/v1/auth/profile/${_shortId(userId)}',
      );
      final resp = await http.get(
        _authProfileUri(user.id),
        headers: {
          'Authorization':
              'Bearer ${AppConfig.effectiveInternalApiBearer}',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      );
      if (resp.statusCode == 200) {
        final map = _profileMapFromApiBody(resp.body);
        if (map == null) {
          _authLog(
            'assertPlayerProfile$ctx → notAllowed : JSON profil illisible '
            '(aperçu=${_previewRaw(resp.body)})',
          );
          return PlayerProfileResult.notAllowed;
        }
        final ut = map['user_type'];
        if (ut != _playerType) {
          _authLog(
            'assertPlayerProfile$ctx → notAllowed : user_type="$ut" (attendu "$_playerType")',
          );
          return PlayerProfileResult.notAllowed;
        }
        final paramsDone = _parseIsParamsDone(map);
        if (!paramsDone) {
          _authLog(
            'assertPlayerProfile$ctx → okNeedsParams (is_params_done=false)',
          );
          return PlayerProfileResult.okNeedsParams;
        }
        _authLog('assertPlayerProfile$ctx → ok (player confirmé)');
        return PlayerProfileResult.ok;
      }
      if (resp.statusCode == 404 || resp.statusCode == 403) {
        _authLog(
          'assertPlayerProfile$ctx → notAllowed : HTTP ${resp.statusCode}',
        );
        return PlayerProfileResult.notAllowed;
      }
      _authLog(
        'assertPlayerProfile$ctx → error : HTTP ${resp.statusCode} '
        '${_previewRaw(resp.body)}',
      );
      return PlayerProfileResult.error;
    } catch (e, st) {
      _authLog(
        'assertPlayerProfile$ctx → error : exception requête / parse',
        error: e,
        stackTrace: st,
      );
      return PlayerProfileResult.error;
    }
  }

  /// Plusieurs tentatives en cas d’erreur réseau / HTTP 5xx.
  /// Appels concurrents pour le même [userId] partagent une seule exécution.
  Future<PlayerProfileResult> assertPlayerProfileWithRetries(
    String userId, {
    String context = 'profile_check',
  }) async {
    final existing = _profileCheckInFlight[userId];
    if (existing != null) {
      _authLog(
        'assertPlayerProfileWithRetries dédoublonnage → attente résultat partagé '
        '(context=$context user=${_shortId(userId)})',
      );
      return existing;
    }
    final run = _runAssertPlayerProfileWithRetries(userId, context: context);
    _profileCheckInFlight[userId] = run;
    try {
      return await run;
    } finally {
      _profileCheckInFlight.remove(userId);
    }
  }

  Future<PlayerProfileResult> _runAssertPlayerProfileWithRetries(
    String userId, {
    required String context,
  }) async {
    const maxAttempts = 3;
    const delay = Duration(milliseconds: 500);
    _authLog(
      'assertPlayerProfileWithRetries démarrage context=$context user=${_shortId(userId)}',
    );
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      if (attempt > 0) await Future<void>.delayed(delay);
      _authLog(
        'assertPlayerProfileWithRetries tentative ${attempt + 1}/$maxAttempts context=$context',
      );
      final r = await assertPlayerProfile(userId, context: context);
      if (r != PlayerProfileResult.error) {
        _authLog(
          'assertPlayerProfileWithRetries → $r (context=$context, après ${attempt + 1} tentative(s))',
        );
        return r;
      }
    }
    _authLog(
      'assertPlayerProfileWithRetries → error définitif après $maxAttempts tentatives (context=$context)',
    );
    return PlayerProfileResult.error;
  }

  /// Compatibilité : vrai uniquement si l’API confirme un joueur.
  Future<bool> isUserPlayer(String userId) async {
    final r = await assertPlayerProfile(userId);
    return r == PlayerProfileResult.ok || r == PlayerProfileResult.okNeedsParams;
  }

  /// Met à jour un utilisateur via backend :
  /// `PATCH /api/v1/users/{userId}` avec bearer interne.
  Future<UpdateUserResult> updateUserProfile({
    required String userId,
    String? email,
    String? firstname,
    String? lastname,
    String? phone,
    bool? activitystatus,
    String? profilepicture,
    String? username,
    /// Marque la fin du flux paramètres app (`PATCH` : `is_params_done`).
    bool? isParamsDone,
  }) async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null || session.user.id != userId) {
      return UpdateUserResult(
        ok: false,
        statusCode: 401,
        message: 'Session invalide pour la mise à jour du profil.',
      );
    }
    final base = _apiBaseTrimmed();
    if (base.isEmpty) {
      return UpdateUserResult(
        ok: false,
        statusCode: 0,
        message: 'API_BASE_URL non défini.',
      );
    }

    final payload = <String, dynamic>{};
    void putString(String key, String? value) {
      if (value == null) return;
      payload[key] = value.trim();
    }

    putString('email', email);
    putString('firstname', firstname);
    putString('lastname', lastname);
    putString('phone', phone);
    if (activitystatus != null) payload['activitystatus'] = activitystatus;
    putString('profilepicture', profilepicture);
    putString('username', username);
    if (isParamsDone != null) payload['is_params_done'] = isParamsDone;

    if (payload.isEmpty) {
      return UpdateUserResult(
        ok: true,
        statusCode: 200,
        data: const <String, dynamic>{},
      );
    }

    try {
      final resp = await http.patch(
        _updateUserUri(userId),
        headers: {
          'Authorization': 'Bearer ${AppConfig.effectiveInternalApiBearer}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode(payload),
      );

      Map<String, dynamic>? data;
      try {
        final decoded = jsonDecode(resp.body);
        if (decoded is Map) data = Map<String, dynamic>.from(decoded);
      } catch (_) {}

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return UpdateUserResult(
          ok: true,
          statusCode: resp.statusCode,
          data: data,
        );
      }

      var message = 'Mise à jour impossible (${resp.statusCode}).';
      if (data != null) {
        if (data['detail'] != null) message = '${data['detail']}';
        if (data['message'] != null) message = '${data['message']}';
      }
      return UpdateUserResult(
        ok: false,
        statusCode: resp.statusCode,
        message: message,
      );
    } catch (e, st) {
      _authLog('updateUserProfile : exception', error: e, stackTrace: st);
      return UpdateUserResult(
        ok: false,
        statusCode: 0,
        message: e.toString(),
      );
    }
  }

  /// Mise à jour des paramètres app (`user_params`) via :
  /// `PATCH /api/v1/users/{user_id}/params`
  Future<UpdateUserResult> updateUserParams({
    required String userId,
    required String country,
    required String languageSetting,
    required bool notification,
    required String theme,
    /// Omis si `null` (ex. simple MAJ depuis Paramètres).
    bool? isParamsDone,
  }) async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null || session.user.id != userId) {
      return UpdateUserResult(
        ok: false,
        statusCode: 401,
        message: 'Session invalide pour la mise à jour des paramètres.',
      );
    }
    final base = _apiBaseTrimmed();
    if (base.isEmpty) {
      return UpdateUserResult(
        ok: false,
        statusCode: 0,
        message: 'API_BASE_URL non défini.',
      );
    }

    final payload = <String, dynamic>{
      'country': country.trim(),
      'language_setting': languageSetting.trim(),
      'notification': notification,
      'theme': theme.trim(),
    };
    if (isParamsDone != null) payload['is_params_done'] = isParamsDone;

    try {
      final resp = await http.patch(
        _updateUserParamsUri(userId),
        headers: {
          'Authorization': 'Bearer ${AppConfig.effectiveInternalApiBearer}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode(payload),
      );

      Map<String, dynamic>? data;
      try {
        final decoded = jsonDecode(resp.body);
        if (decoded is Map) data = Map<String, dynamic>.from(decoded);
      } catch (_) {}

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        return UpdateUserResult(
          ok: true,
          statusCode: resp.statusCode,
          data: data,
        );
      }

      var message = 'Mise à jour impossible (${resp.statusCode}).';
      if (data != null) {
        if (data['detail'] != null) message = '${data['detail']}';
        if (data['message'] != null) message = '${data['message']}';
      }
      return UpdateUserResult(
        ok: false,
        statusCode: resp.statusCode,
        message: message,
      );
    } catch (e, st) {
      _authLog('updateUserParams : exception', error: e, stackTrace: st);
      return UpdateUserResult(
        ok: false,
        statusCode: 0,
        message: e.toString(),
      );
    }
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

class UpdateUserResult {
  UpdateUserResult({
    required this.ok,
    required this.statusCode,
    this.message,
    this.data,
  });

  final bool ok;
  final int statusCode;
  final String? message;
  final Map<String, dynamic>? data;
}
