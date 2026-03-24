import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/l10n/context_l10n.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/auth_service.dart';
import '../../core/state/app_country_options.dart';
import '../../core/state/app_settings_scope.dart';
import '../../core/state/user_params_api.dart';

/// Sélection langue, pays, thème, notifications puis `is_params_done: true` côté API.
class AppParamsSetupPage extends StatefulWidget {
  const AppParamsSetupPage({super.key});

  @override
  State<AppParamsSetupPage> createState() => _AppParamsSetupPageState();
}

class _AppParamsSetupPageState extends State<AppParamsSetupPage> {
  bool _submitting = false;

  Future<void> _submit() async {
    if (_submitting) return;
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      return;
    }

    final scope = AppSettingsScope.of(context);
    final v = userParamsApiValuesFromScope(scope);

    setState(() => _submitting = true);
    try {
      final result = await AuthService.instance.updateUserParams(
        userId: session.user.id,
        country: v.country,
        languageSetting: v.languageSetting,
        notification: v.notification,
        theme: v.theme,
        isParamsDone: true,
      );
      if (!mounted) return;
      if (!result.ok) {
        final msg = result.message;
        final l10n = context.l10n;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              (msg != null && msg.isNotEmpty) ? msg : l10n.saveFailed,
            ),
          ),
        );
        return;
      }
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppSettingsScope.of(context);
    const cyan = Color(0xFF00BCD4);
    final l10n = context.l10n;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              Text(
                l10n.paramsSetupTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.paramsSetupHint,
                style: TextStyle(color: Colors.white.withOpacity(0.75)),
              ),
              const SizedBox(height: 28),
              Text(
                l10n.language,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<String>(
                valueListenable: scope.languageCode,
                builder: (context, code, _) {
                  return Column(
                    children: [
                      RadioListTile<String>(
                        value: 'fr',
                        groupValue: code,
                        title: Text(l10n.langFrench),
                        onChanged: (v) {
                          if (v == null) return;
                          scope.languageCode.value = v;
                        },
                      ),
                      RadioListTile<String>(
                        value: 'en',
                        groupValue: code,
                        title: Text(l10n.langEnglish),
                        onChanged: (v) {
                          if (v == null) return;
                          scope.languageCode.value = v;
                        },
                      ),
                    ],
                  );
                },
              ),
              const Divider(height: 32),
              Text(
                l10n.country,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<String>(
                valueListenable: scope.countryCode,
                builder: (context, code, _) {
                  return ValueListenableBuilder<String>(
                    valueListenable: scope.languageCode,
                    builder: (context, lang, _) {
                      return DropdownButtonFormField<String>(
                        value: kAppCountryOptions.any((c) => c.code == code)
                            ? code
                            : kAppCountryOptions.first.code,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: [
                          for (final c in kAppCountryOptions)
                            DropdownMenuItem(
                              value: c.code,
                              child: Text(
                                lang == 'en' ? c.labelEn : c.labelFr,
                              ),
                            ),
                        ],
                        onChanged: (v) {
                          if (v == null) return;
                          scope.countryCode.value = v;
                        },
                      );
                    },
                  );
                },
              ),
              const Divider(height: 32),
              Text(
                l10n.theme,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<ThemeMode>(
                valueListenable: scope.themeMode,
                builder: (context, themeMode, _) {
                  return Column(
                    children: [
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.dark,
                        groupValue: themeMode,
                        title: Text(l10n.themeDark),
                        onChanged: (v) {
                          if (v == null) return;
                          scope.themeMode.value = v;
                        },
                      ),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.light,
                        groupValue: themeMode,
                        title: Text(l10n.themeLight),
                        onChanged: (v) {
                          if (v == null) return;
                          scope.themeMode.value = v;
                        },
                      ),
                    ],
                  );
                },
              ),
              const Divider(height: 32),
              Text(
                l10n.notifications,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<bool>(
                valueListenable: scope.notificationsEnabled,
                builder: (context, enabled, _) {
                  return SwitchListTile(
                    value: enabled,
                    title: Text(
                      enabled
                          ? l10n.notificationsEnabled
                          : l10n.notificationsDisabled,
                    ),
                    onChanged: (v) => scope.notificationsEnabled.value = v,
                  );
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: cyan,
                    foregroundColor: Colors.black87,
                  ),
                  child: _submitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          l10n.continueButton,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
