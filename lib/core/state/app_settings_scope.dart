import 'package:flutter/material.dart';

/// Expose les préférences app (thème + langue) sans dépendance externe.
class AppSettingsScope extends InheritedWidget {
  const AppSettingsScope({
    super.key,
    required this.themeMode,
    required this.languageCode,
    required this.countryCode,
    required this.notificationsEnabled,
    required super.child,
  });

  final ValueNotifier<ThemeMode> themeMode;
  final ValueNotifier<String> languageCode;
  /// Code pays ISO (ex. `FR`, `BE`) pour préférences affichées / futures synchros API.
  final ValueNotifier<String> countryCode;
  final ValueNotifier<bool> notificationsEnabled;

  @override
  bool updateShouldNotify(covariant AppSettingsScope oldWidget) => false;

  static AppSettingsScope of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppSettingsScope>();
    assert(scope != null, 'AppSettingsScope manquant dans l’arbre de widgets');
    return scope!;
  }
}

