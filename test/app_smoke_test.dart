import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:etwassel_ui/app_state.dart';
import 'package:etwassel_ui/main.dart';

Future<void> _boot(WidgetTester tester, {bool guest = false}) async {
  SharedPreferences.setMockInitialValues({});
  final state = AppState();
  await state.load();
  if (guest) state.enterGuest();
  await tester.binding.setSurfaceSize(const Size(412, 915));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(EtwasselApp(state: state));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 2700));
  await tester.pump(const Duration(milliseconds: 600));
}

void main() {
  testWidgets('login offers guest entry and reaches the original home', (tester) async {
    await _boot(tester);

    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('Continuer sans connexion'), findsOneWidget);

    await tester.tap(find.text('Continuer sans connexion'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('BONJOUR'), findsOneWidget);
    expect(find.text('Soumettre une doléance'), findsOneWidget);
    expect(find.text('À la une'), findsOneWidget);
    expect(find.text('Accueil'), findsOneWidget);

    await tester.tap(find.text('Horaires'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Exploitation'), findsOneWidget);
    expect(find.text('Intervalle'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Mon Profil'), findsOneWidget);
    expect(find.text('Mes cartes'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('card detail shows the rotated card and opens the editor', (tester) async {
    await _boot(tester, guest: true);

    await tester.tap(find.text('eTWASSEL Étudiant'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('eTWASSEL Étudiant'), findsOneWidget);
    expect(find.text('Précédent'), findsNothing);

    await tester.tap(find.byIcon(Icons.edit_outlined).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Aperçu de la carte'), findsOneWidget);
    expect(find.byIcon(Icons.calendar_month_rounded), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Choisir depuis la galerie'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Choisir depuis la galerie'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Enregistrer'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Enregistrer'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('eTWASSEL Étudiant'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('card spins in and rotates with a horizontal drag', (tester) async {
    await _boot(tester, guest: true);

    await tester.tap(find.text('eTWASSEL Étudiant'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));
    expect(find.byKey(const ValueKey('card-back')), findsNothing);

    await tester.drag(find.byKey(const ValueKey('card-flip')), const Offset(-260, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byKey(const ValueKey('card-back')), findsOneWidget);

    await tester.drag(find.byKey(const ValueKey('card-flip')), const Offset(260, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byKey(const ValueKey('card-back')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('card timestamp shows the live time and ticks', (tester) async {
    var now = DateTime(2026, 1, 1, 22, 52, 23);
    await withClock(Clock(() => now), () async {
      await _boot(tester, guest: true);

      await tester.tap(find.text('eTWASSEL Étudiant'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1100));
      expect(find.text('2026-01-01 22:52:23'), findsOneWidget);

      now = now.add(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('2026-01-01 22:52:24'), findsOneWidget);
      expect(find.text('2026-01-01 22:52:23'), findsNothing);
    });
  });

  testWidgets('bottom navigation opens schedules and products', (tester) async {
    await _boot(tester, guest: true);

    await tester.tap(find.text('Horaires'));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Exploitation'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.storefront_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Nos Produits'), findsOneWidget);
    expect(find.text('Commander • 1200 DA'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
