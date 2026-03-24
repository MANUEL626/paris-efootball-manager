import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/l10n/context_l10n.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/auth_service.dart';

/// Page Profil utilisateur (username + photo depuis l'API, déconnexion Supabase).
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _profile;
  bool _loading = true;
  bool _signingOut = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    final p = await AuthService.instance.fetchUserProfileById(user.id);
    if (!mounted) return;
    setState(() {
      _profile = p;
      _loading = false;
    });
  }

  /// `profile_picture` attendu : `data:image/jpeg;base64,...` ou `data:image/png;base64,...`
  static Uint8List? _bytesFromDataUri(String? dataUri) {
    if (dataUri == null || dataUri.isEmpty) return null;
    final comma = dataUri.indexOf(',');
    if (comma < 0 || comma >= dataUri.length - 1) return null;
    try {
      return base64Decode(dataUri.substring(comma + 1).trim());
    } catch (_) {
      return null;
    }
  }

  Future<void> _logout() async {
    setState(() => _signingOut = true);
    try {
      await AuthService.signOutSafe();
    } finally {
      if (mounted) setState(() => _signingOut = false);
    }
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (r) => false,
    );
  }

  Future<void> _goToEditProfile() async {
    final updated = await Navigator.of(context).pushNamed(
      AppRoutes.editProfile,
      arguments: _profile,
    );
    if (updated == true && mounted) {
      setState(() => _loading = true);
      await _loadProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final user = Supabase.instance.client.auth.currentUser;
    final username = _profile?['username'] as String?;
    final pictureBytes = _bytesFromDataUri(_profile?['profile_picture'] as String?);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: const Color(0xFF00BCD4),
                    backgroundImage: pictureBytes != null
                        ? MemoryImage(pictureBytes)
                        : null,
                    child: pictureBytes == null
                        ? const Icon(Icons.person, size: 48, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.usernameLabel,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  username?.isNotEmpty == true
                      ? username!
                      : (user?.email ?? l10n.dash),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 32),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(l10n.editProfile),
                  textColor: Colors.white,
                  onTap: _goToEditProfile,
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(l10n.settings),
                  textColor: Colors.white,
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.settingsRoute);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: Text(l10n.help),
                  textColor: Colors.white,
                  onTap: () {},
                ),
                const Divider(color: Colors.white24),
                ListTile(
                  leading: _signingOut
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    l10n.signOut,
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: _signingOut ? null : _logout,
                ),
              ],
            ),
    );
  }
}
