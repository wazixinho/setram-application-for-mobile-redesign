import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app_lang.dart';
import '../app_state.dart';
import '../theme.dart';
import '../widgets/design.dart';
import 'home_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController(text: 'setramapp@gmail.com');
  final _password = TextEditingController(text: 'demo1234');
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _enter({required bool guest}) {
    final app = AppScope.of(context);
    if (!guest) {
      if (_email.text.trim().isEmpty || _password.text.isEmpty) {
        showAppSnack(context, context.appLang.t('required_field'), error: true);
        return;
      }
      app.signIn();
    } else {
      app.enterGuest();
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => const HomeShell()));
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.appLang;
    return Scaffold(
      backgroundColor: AppColors.navyDeep,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF16205A), Color(0xFF0E1540)],
                ),
              ),
            ),
          ),
          Positioned(top: 90, left: -60, child: _Ring(size: 210)),
          Positioned(top: 260, right: -80, child: _Ring(size: 260)),
          Positioned(bottom: 150, left: -40, child: _Ring(size: 160)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: CircleIconButton(
                      icon: Icons.language_rounded,
                      onTap: () => showLanguageSheet(context),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: SvgPicture.asset('assets/images/E-TWASSEL-enclr.svg', width: 250),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      lang.t('tagline'),
                      style: const TextStyle(color: Color(0xFFB9C6F2), fontSize: 14, letterSpacing: 0.5),
                    ),
                  ),
                  const SizedBox(height: 34),
                  Container(
                    padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(color: Color(0x33000000), blurRadius: 30, offset: Offset(0, 16)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(lang.t('login_title'), style: AppText.h1.copyWith(fontSize: 26)),
                        const SizedBox(height: 6),
                        Text(lang.t('login_hint'), style: AppText.bodyMuted.copyWith(fontSize: 13)),
                        const SizedBox(height: 22),
                        Text(lang.t('email'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'setramapp@gmail.com',
                            prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20, color: AppColors.muted),
                            prefixIconConstraints: const BoxConstraints(minWidth: 46),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(lang.t('password'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _password,
                          obscureText: _obscure,
                          style: const TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: AppColors.muted),
                            prefixIconConstraints: const BoxConstraints(minWidth: 46),
                            suffixIcon: GestureDetector(
                              onTap: () => setState(() => _obscure = !_obscure),
                              child: Icon(
                                _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                size: 20,
                                color: AppColors.muted,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        AppPrimaryButton(
                          label: lang.t('sign_in'),
                          icon: Icons.login_rounded,
                          onPressed: () => _enter(guest: false),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  GestureDetector(
                    onTap: () => _enter(guest: true),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person_outline_rounded, color: Colors.white, size: 19),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              lang.t('continue_offline'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward_rounded, color: AppColors.cyan, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: Text(
                      lang.t('guest_mode'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF8E9BD0), fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      lang.t('demo_note'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF6F7CB5), fontSize: 11, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1.4),
      ),
    );
  }
}
