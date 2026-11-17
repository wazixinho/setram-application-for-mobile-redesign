import 'dart:async';

import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme.dart';
import 'home_shell.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2400), _go);
  }

  void _go() {
    if (!mounted) return;
    final app = AppScope.of(context);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => app.entered ? const HomeShell() : const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyDeep,
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/launch.gif',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) => const Center(
            child: Text(
              'e-TWASSEL',
              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
