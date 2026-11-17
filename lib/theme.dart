import 'package:flutter/material.dart';

import 'app_lang.dart';
import 'app_state.dart';

export 'app_lang.dart';
export 'app_state.dart';

class AppColors {
  static const navy = Color(0xFF1B2A63);
  static const navyDeep = Color(0xFF141C4E);
  static const navyHeader = Color(0xFF22306E);
  static const navyCard = Color(0xFF283B8F);
  static const cyan = Color(0xFF1FBDE9);
  static const cyanDeep = Color(0xFF0FA9D6);
  static const cyanSoft = Color(0xFFD9F3FB);
  static const orange = Color(0xFFF7A21B);
  static const orangeDeep = Color(0xFFF28A3A);
  static const orangeSoft = Color(0xFFFDEBD2);
  static const green = Color(0xFF2FBF71);
  static const greenSoft = Color(0xFFE2F6EA);
  static const red = Color(0xFFE53935);
  static const bg = Color(0xFFF4F5FA);
  static const surface = Colors.white;
  static const text = Color(0xFF1B2A63);
  static const muted = Color(0xFF8A93B2);
  static const line = Color(0xFFE8EBF5);
  static const field = Color(0xFFF2F4FA);
}

ThemeData buildTheme(AppLang lang) {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: lang.isArabic ? 'Amiri' : 'Poppins',
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.navy, primary: AppColors.navy),
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: AppColors.text, displayColor: AppColors.text),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.field,
      hintStyle: const TextStyle(color: AppColors.muted, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.cyan, width: 1.4),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: const StadiumBorder(),
        textStyle: TextStyle(
          fontFamily: lang.isArabic ? 'Amiri' : 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    dividerTheme: const DividerThemeData(color: AppColors.line, thickness: 1, space: 1),
  );
}

class AppText {
  static const h1 = TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.navy, height: 1.2);
  static const h2 = TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.navy, height: 1.25);
  static const h3 = TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy);
  static const body = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.text, height: 1.4);
  static const bodyMuted = TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.muted, height: 1.4);
  static const label = TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.navy);
  static const pill = TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.3);
  static const whiteTitle = TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white);
}

extension AppLangContext on BuildContext {
  AppState get app => AppScope.of(this);

  AppLang get appLang => AppScope.of(this).lang;
}
