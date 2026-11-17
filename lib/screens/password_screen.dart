import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/design.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _current = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _save() {
    final lang = context.appLang;
    if (_current.text.isEmpty || _new.text.isEmpty || _confirm.text.isEmpty) {
      showAppSnack(context, lang.t('required_field'), error: true);
      return;
    }
    if (_new.text.length < 6) {
      showAppSnack(context, lang.t('min_chars'), error: true);
      return;
    }
    if (_new.text != _confirm.text) {
      showAppSnack(context, lang.t('password_mismatch'), error: true);
      return;
    }
    showAppSnack(context, lang.t('password_changed'));
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
            title: text('change_password'),
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
                      _PasswordField(label: text('current_password'), controller: _current),
                      const SizedBox(height: 14),
                      _PasswordField(label: text('new_password'), controller: _new),
                      const SizedBox(height: 14),
                      _PasswordField(label: text('confirm_password'), controller: _confirm),
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

class _PasswordField extends StatefulWidget {
  const _PasswordField({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          obscureText: _obscure,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: '••••••••',
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(
                _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: 20,
                color: AppColors.muted,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
