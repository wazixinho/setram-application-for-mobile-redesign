import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:etwassel_ui/app_lang.dart';
import 'package:etwassel_ui/app_state.dart';
import 'package:etwassel_ui/screens/card_detail_screen.dart';
import 'package:etwassel_ui/screens/card_edit_screen.dart';
import 'package:etwassel_ui/screens/doleance_screen.dart';
import 'package:etwassel_ui/screens/home_shell.dart';
import 'package:etwassel_ui/screens/login_screen.dart';
import 'package:etwassel_ui/screens/notifications_screen.dart';
import 'package:etwassel_ui/screens/order_request_screen.dart';
import 'package:etwassel_ui/screens/products_screen.dart';
import 'package:etwassel_ui/theme.dart';

Future<void> _loadFont(String family, List<String> assets) async {
  final loader = FontLoader(family);
  for (final asset in assets) {
    loader.addFont(rootBundle.load(asset));
  }
  await loader.load();
}

Future<AppState> _state() async {
  SharedPreferences.setMockInitialValues({});
  final state = AppState();
  await state.load();
  state.enterGuest();
  return state;
}

Future<void> _pump(WidgetTester tester, AppState state, Widget child) async {
  tester.view.physicalSize = const Size(412, 915);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    AppScope(
      state: state,
      child: AnimatedBuilder(
        animation: state,
        builder: (context, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildTheme(state.lang),
          locale: Locale(state.lang.code),
          supportedLocales: AppLang.values.map((l) => Locale(l.code)).toList(),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) => Directionality(
            textDirection: state.lang.isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: child ?? const SizedBox.shrink(),
          ),
          home: child,
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 400)));
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  setUpAll(() async {
    await _loadFont('Poppins', [
      'assets/fonts/Poppins-Regular.ttf',
      'assets/fonts/Poppins-Medium.ttf',
      'assets/fonts/Poppins-SemiBold.ttf',
      'assets/fonts/Poppins-Bold.ttf',
      'assets/fonts/Poppins-ExtraBold.ttf',
    ]);
    await _loadFont('Amiri', ['assets/fonts/Amiri-Regular.ttf']);
    await _loadFont('MaterialIcons', ['fonts/MaterialIcons-Regular.otf']);
  });

  testWidgets('login', (tester) async {
    final state = await _state();
    await _pump(tester, state, const LoginScreen());
    await expectLater(find.byType(LoginScreen), matchesGoldenFile('goldens/login.png'));
  });

  testWidgets('home tabs', (tester) async {
    final state = await _state();
    await _pump(tester, state, const HomeShell());
    await expectLater(find.byType(HomeShell), matchesGoldenFile('goldens/home.png'));

    await tester.tap(find.text('Profil'));
    await tester.pump(const Duration(milliseconds: 400));
    await expectLater(find.byType(HomeShell), matchesGoldenFile('goldens/profile.png'));

    await tester.tap(find.text('Horaires'));
    await tester.pump(const Duration(milliseconds: 400));
    await expectLater(find.byType(HomeShell), matchesGoldenFile('goldens/horaires.png'));

    await tester.tap(find.text('Location'));
    await tester.pump(const Duration(milliseconds: 400));
    await expectLater(find.byType(HomeShell), matchesGoldenFile('goldens/location.png'));
  });

  testWidgets('card detail', (tester) async {
    await withClock(Clock.fixed(DateTime(2026, 10, 4, 21, 28, 47)), () async {
      final state = await _state();
      await _pump(tester, state, const CardDetailScreen());
      await expectLater(find.byType(CardDetailScreen), matchesGoldenFile('goldens/card_detail.png'));
    });
  });

  testWidgets('card edit', (tester) async {
    await withClock(Clock.fixed(DateTime(2026, 10, 4, 21, 28, 47)), () async {
      final state = await _state();
      await _pump(tester, state, CardEditScreen(card: state.cards.first));
      await expectLater(find.byType(CardEditScreen), matchesGoldenFile('goldens/card_edit.png'));
    });
  });

  testWidgets('products', (tester) async {
    final state = await _state();
    await _pump(tester, state, const ProductsScreen());
    await expectLater(find.byType(ProductsScreen), matchesGoldenFile('goldens/products.png'));
  });

  testWidgets('order request', (tester) async {
    final state = await _state();
    await _pump(
      tester,
      state,
      const OrderRequestScreen(
        typeName: 'Abonnement Classique',
        planLabel: 'Hebdomadaire',
        days: 7,
        price: '350 DA',
        agency: "Tramway d'Alger",
      ),
    );
    await expectLater(find.byType(OrderRequestScreen), matchesGoldenFile('goldens/order_request.png'));
  });

  testWidgets('doleance', (tester) async {
    final state = await _state();
    await _pump(tester, state, const DoleanceScreen());
    await expectLater(find.byType(DoleanceScreen), matchesGoldenFile('goldens/doleance.png'));
  });

  testWidgets('notifications', (tester) async {
    final state = await _state();
    await _pump(tester, state, const NotificationsScreen());
    await expectLater(find.byType(NotificationsScreen), matchesGoldenFile('goldens/notifications.png'));
  });

  testWidgets('arabic home', (tester) async {
    final state = await _state();
    state.setLang(AppLang.ar);
    await _pump(tester, state, const HomeShell());
    await expectLater(find.byType(HomeShell), matchesGoldenFile('goldens/home_ar.png'));
  });
}
