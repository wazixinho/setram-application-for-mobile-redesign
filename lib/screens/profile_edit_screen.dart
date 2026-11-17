import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets/design.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late TextEditingController _email;
  late TextEditingController _phone;
  late TextEditingController _wilaya;
  late TextEditingController _profession;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final profile = AppScope.of(context).profile;
    _firstName = TextEditingController(text: profile.firstName);
    _lastName = TextEditingController(text: profile.lastName);
    _email = TextEditingController(text: profile.email);
    _phone = TextEditingController(text: profile.phone);
    _wilaya = TextEditingController(text: profile.wilaya);
    _profession = TextEditingController(text: profile.profession);
  }

  @override
  void dispose() {
    for (final controller in [_firstName, _lastName, _email, _phone, _wilaya, _profession]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _save() {
    final lang = context.appLang;
    if (_firstName.text.trim().isEmpty ||
        _lastName.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _phone.text.trim().isEmpty) {
      showAppSnack(context, lang.t('required_field'), error: true);
      return;
    }
    final app = context.app;
    app.updateProfile(
      ProfileModel(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        wilaya: _wilaya.text.trim().isEmpty ? 'Alger' : _wilaya.text.trim(),
        profession: _profession.text.trim(),
        memberSince: app.profile.memberSince,
      ),
    );
    showAppSnack(context, lang.t('profile_updated'));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.appLang;
    final text = lang.t;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          NavyHeader(
            title: text('edit_profile'),
            leading: CircleIconButton(
              icon: Icons.arrow_back_rounded,
              background: const Color(0x26FFFFFF),
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                WhiteCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(text('personal_info'), style: AppText.h3),
                      const SizedBox(height: 16),
                      _Field(label: text('first_name'), controller: _firstName),
                      const SizedBox(height: 12),
                      _Field(label: text('last_name'), controller: _lastName),
                      const SizedBox(height: 12),
                      _Field(label: text('email'), controller: _email, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 12),
                      _Field(label: text('phone'), controller: _phone, keyboardType: TextInputType.phone),
                      const SizedBox(height: 12),
                      _Field(label: text('wilaya'), controller: _wilaya),
                      const SizedBox(height: 12),
                      _Field(label: text('profession'), controller: _profession),
                      const SizedBox(height: 22),
                      AppPrimaryButton(
                        label: text('save'),
                        icon: Icons.check_rounded,
                        onPressed: _save,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.controller, this.keyboardType});

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(fontSize: 12.5, color: AppColors.muted, fontWeight: FontWeight.w600),
      ),
    );
  }
}
