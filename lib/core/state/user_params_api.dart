import 'package:flutter/material.dart';

import 'app_country_options.dart';
import 'app_settings_scope.dart';

/// Valeurs pour `PATCH /api/v1/users/{id}/params` (aligné backend).
class UserParamsApiValues {
  const UserParamsApiValues({
    required this.country,
    required this.languageSetting,
    required this.notification,
    required this.theme,
  });

  final String country;
  final String languageSetting;
  final bool notification;
  final String theme;
}

/// Dérive [country] (libellé), [languageSetting] (`fr-FR` / `en-US`) et [theme] (`light`/`dark`).
UserParamsApiValues userParamsApiValuesFromScope(AppSettingsScope scope) {
  final language = scope.languageCode.value;
  final countryOpt = kAppCountryOptions.firstWhere(
    (c) => c.code == scope.countryCode.value,
    orElse: () => kAppCountryOptions.first,
  );
  final country = language == 'en' ? countryOpt.labelEn : countryOpt.labelFr;
  final languageSetting = language == 'en' ? 'en-US' : 'fr-FR';
  final theme = scope.themeMode.value == ThemeMode.dark ? 'dark' : 'light';
  return UserParamsApiValues(
    country: country,
    languageSetting: languageSetting,
    notification: scope.notificationsEnabled.value,
    theme: theme,
  );
}
