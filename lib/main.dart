import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_lang.dart';
import 'app_state.dart';
import 'screens/splash_screen.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState();
  await state.load();
  runApp(EtwasselApp(state: state));
}

class EtwasselApp extends StatelessWidget {
  const EtwasselApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: AnimatedBuilder(
        animation: state,
        builder: (context, _) {
          final lang = state.lang;
          return MaterialApp(
            title: 'e-TWASSEL',
            debugShowCheckedModeBanner: false,
            theme: buildTheme(lang),
            locale: Locale(lang.code),
            supportedLocales: AppLang.values.map((l) => Locale(l.code)).toList(),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) => Directionality(
              textDirection: lang.isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: child ?? const SizedBox.shrink(),
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
