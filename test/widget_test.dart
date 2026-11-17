import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:etwassel_ui/app_lang.dart';
import 'package:etwassel_ui/app_state.dart';
import 'package:etwassel_ui/models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('card model survives a JSON round trip', () {
    final card = demoCards().first;
    final restored = CardModel.fromJson(card.toJson());

    expect(restored.id, card.id);
    expect(restored.fullName, card.fullName);
    expect(restored.number, card.number);
    expect(restored.product, card.product);
    expect(restored.art, card.art);
    expect(restored.status, card.status);
    expect(restored.showQr, card.showQr);
  });

  test('demo data matches the original screens', () {
    final cards = demoCards();
    expect(cards.length, 1);
    expect(cards.first.product, 'eTWASSEL Étudiant');
    expect(cards.first.number, '1262 70');
    expect(cards.first.agency, 'Tramway de Sidi Bel Abbes');
    expect(cards.first.remainingDays, 144);
    expect(demoOrders(), isNotEmpty);
    expect(demoProfile().fullName, 'Setram A.');
  });

  test('translations exist for every language', () {
    for (final lang in AppLang.values) {
      for (final key in [
        'home',
        'my_cards',
        'my_profile',
        'continue_offline',
        'edit_card',
        'card_preview',
        'submit_doleance',
        'position',
        'products',
      ]) {
        expect(lang.t(key), isNotEmpty, reason: '$key missing for $lang');
      }
    }
    expect(AppLang.ar.t('my_cards'), 'بطاقاتي');
    expect(AppLang.en.t('my_cards'), 'My cards');
    expect(AppLang.fr.t('my_cards'), 'Mes cartes');
  });

  test('guest entry and card editing persist in state', () async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.load();

    expect(state.entered, isFalse);
    state.enterGuest();
    expect(state.guest, isTrue);
    expect(state.entered, isTrue);

    final card = state.cards.first.copyWith(
      product: 'eTWASSEL Senior',
      durationLabel: '30 Jours',
      remainingDays: 29,
      art: CardArt.red,
    );
    state.upsertCard(card);
    expect(state.cardById(card.id)?.product, 'eTWASSEL Senior');
    expect(state.cardById(card.id)?.art, CardArt.red);

    state.deleteCard(card.id);
    expect(state.cardById(card.id), isNull);

    state.resetDemo();
    expect(state.entered, isFalse);
    expect(state.cards.length, 1);
  });
}
