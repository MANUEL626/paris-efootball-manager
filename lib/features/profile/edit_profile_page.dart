import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/l10n/context_l10n.dart';
import '../../core/services/auth_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, this.initialProfile});

  final Map<String, dynamic>? initialProfile;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _phoneController;
  late String _profilePictureDataUri;
  bool _saving = false;
  bool _pickingImage = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late final bool _isPlayer;

  String _initialValue(List<String> keys) {
    for (final k in keys) {
      final v = widget.initialProfile?[k];
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    final currentEmail =
        Supabase.instance.client.auth.currentUser?.email?.trim() ?? '';
    _emailController = TextEditingController(
      text: _initialValue(const ['email']).isNotEmpty
          ? _initialValue(const ['email'])
          : currentEmail,
    );
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _firstNameController = TextEditingController(
      text: _initialValue(const ['first_name', 'firstname']),
    );
    _lastNameController = TextEditingController(
      text: _initialValue(const ['last_name', 'lastname']),
    );
    _usernameController = TextEditingController(
      text: _initialValue(const ['username']),
    );
    _phoneController = TextEditingController(
      text: _initialValue(const ['phone']),
    );
    _profilePictureDataUri =
        _initialValue(const ['profile_picture', 'profilepicture']);
    final userType = _initialValue(const ['user_type', 'usertype']);
    _isPlayer = userType.isEmpty || userType == 'player';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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

  String _mimeFromFilePath(String path) {
    final p = path.toLowerCase();
    if (p.endsWith('.png')) return 'image/png';
    if (p.endsWith('.webp')) return 'image/webp';
    if (p.endsWith('.gif')) return 'image/gif';
    return 'image/jpeg';
  }

  Future<void> _pickProfileImage() async {
    if (_saving || _pickingImage) return;
    setState(() => _pickingImage = true);
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
      );
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      final mime = _mimeFromFilePath(picked.path);
      setState(() {
        _profilePictureDataUri =
            'data:$mime;base64,${base64Encode(bytes)}';
      });
    } on PlatformException catch (e, st) {
      AuthService.debugConnection(
        'EditProfile image_picker PlatformException',
        error: e,
        stackTrace: st,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.imagePickError)),
      );
    } finally {
      if (mounted) setState(() => _pickingImage = false);
    }
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    setState(() => _saving = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.sessionExpired)),
        );
        return;
      }
      final email = _emailController.text.trim();
      final first = _firstNameController.text.trim();
      final last = _lastNameController.text.trim();
      final phone = _phoneController.text.trim();
      final username = _usernameController.text.trim();
      final picture = _profilePictureDataUri.trim();
      final pwd = _passwordController.text.trim();

      if (pwd.isNotEmpty) {
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(password: pwd),
        );
      }

      final update = await AuthService.instance.updateUserProfile(
        userId: user.id,
        email: email,
        firstname: first,
        lastname: last,
        phone: phone,
        profilepicture: picture,
        username: _isPlayer ? username : null,
      );

      if (!update.ok) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(update.message ?? l10n.updateFailed)),
        );
        return;
      }
      AuthService.debugConnection(
        'EditProfile saved via API user=${user.id.substring(0, 8)}… '
        'email=${_emailController.text.trim()} '
        'passwordChanged=${_passwordController.text.isNotEmpty} '
        'pictureChanged=${_profilePictureDataUri.isNotEmpty}',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.profileUpdated)),
      );
      Navigator.of(context).pop(true);
    } on AuthException catch (e, st) {
      AuthService.debugConnection(
        'EditProfile updateUser AuthException',
        error: e,
        stackTrace: st,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message.isNotEmpty ? e.message : context.l10n.authError,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pictureBytes = _bytesFromDataUri(_profilePictureDataUri.trim());
    return Scaffold(
      appBar: AppBar(title: Text(l10n.editProfileTitle)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Stack(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(44),
                    onTap: _pickProfileImage,
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: const Color(0xFF00BCD4),
                      backgroundImage:
                          pictureBytes != null ? MemoryImage(pictureBytes) : null,
                      child: pictureBytes == null
                          ? const Icon(Icons.person, size: 42, color: Colors.white)
                          : null,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: const Color(0xFF00BCD4),
                      child: _pickingImage
                          ? const SizedBox(
                              height: 14,
                              width: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.edit, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.tapPhotoHint,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: l10n.email),
              validator: (v) {
                final t = (v ?? '').trim();
                if (t.isEmpty) return l10n.emailRequired;
                if (!t.contains('@')) return l10n.emailInvalid;
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: l10n.newPassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              validator: (v) {
                final t = (v ?? '').trim();
                if (t.isEmpty) return null;
                if (t.length < 6) return l10n.min6chars;
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: l10n.confirmPassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    );
                  },
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
              ),
              validator: (v) {
                if (_passwordController.text.trim().isEmpty) return null;
                if ((v ?? '').trim() != _passwordController.text.trim()) {
                  return l10n.passwordsDoNotMatch;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: l10n.firstName),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: l10n.lastName),
            ),
            const SizedBox(height: 12),
            if (_isPlayer) ...[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: l10n.username),
                validator: (v) {
                  final t = (v ?? '').trim();
                  if (t.isEmpty) return l10n.usernameRequired;
                  if (t.length < 3) return l10n.min3chars;
                  return null;
                },
              ),
              const SizedBox(height: 12),
            ],
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: l10n.phone),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
