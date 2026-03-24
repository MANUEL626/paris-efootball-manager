import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/l10n/context_l10n.dart';
import '../../core/services/auth_service.dart';
import '../../core/state/app_country_options.dart';
import '../../core/state/app_settings_scope.dart';
import '../../core/state/user_params_api.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Timer? _debounce;
  bool _syncing = false;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _scheduleSyncToApi() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _syncToApi);
  }

  Future<void> _syncToApi() async {
    if (!mounted || _syncing) return;
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) return;

    final scope = AppSettingsScope.of(context);
    final v = userParamsApiValuesFromScope(scope);

    setState(() => _syncing = true);
    try {
      final result = await AuthService.instance.updateUserParams(
        userId: session.user.id,
        country: v.country,
        languageSetting: v.languageSetting,
        notification: v.notification,
        theme: v.theme,
      );
      if (!mounted) return;
      if (!result.ok) {
        final msg = result.message;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              (msg != null && msg.isNotEmpty) ? msg : context.l10n.updateFailed,
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppSettingsScope.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        actions: [
          if (_syncing)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.language,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<String>(
              valueListenable: scope.languageCode,
              builder: (context, lang, _) {
                return Column(
                  children: [
                    RadioListTile<String>(
                      value: 'fr',
                      groupValue: lang,
                      title: Text(l10n.langFrench),
                      onChanged: (v) {
                        if (v == null) return;
                        scope.languageCode.value = v;
                        _scheduleSyncToApi();
                      },
                    ),
                    RadioListTile<String>(
                      value: 'en',
                      groupValue: lang,
                      title: Text(l10n.langEnglish),
                      onChanged: (v) {
                        if (v == null) return;
                        scope.languageCode.value = v;
                        _scheduleSyncToApi();
                      },
                    ),
                  ],
                );
              },
            ),
            const Divider(height: 32),
            Text(
              l10n.country,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
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
                        _scheduleSyncToApi();
                      },
                    );
                  },
                );
              },
            ),
            const Divider(height: 32),
            Text(
              l10n.theme,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<ThemeMode>(
              valueListenable: scope.themeMode,
              builder: (context, themeMode, _) {
                final isDark = themeMode == ThemeMode.dark;
                return Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.dark,
                      groupValue: themeMode,
                      title: Text(l10n.themeDark),
                      onChanged: (v) {
                        if (v == null) return;
                        scope.themeMode.value = v;
                        _scheduleSyncToApi();
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.light,
                      groupValue: themeMode,
                      title: Text(l10n.themeLight),
                      onChanged: (v) {
                        if (v == null) return;
                        scope.themeMode.value = v;
                        _scheduleSyncToApi();
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isDark ? l10n.themePreviewDark : l10n.themePreviewLight,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            color: isDark
                                ? Colors.white70
                                : Colors.black.withOpacity(0.7),
                          ),
                    ),
                  ],
                );
              },
            ),
            const Divider(height: 32),
            Text(
              l10n.notifications,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
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
                  onChanged: (v) {
                    scope.notificationsEnabled.value = v;
                    _scheduleSyncToApi();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
