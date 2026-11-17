import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_lang.dart';
import 'models.dart';

class AppState extends ChangeNotifier {
  static const _prefsKey = 'etwassel_demo_state_v2';

  AppLang lang = AppLang.fr;
  bool entered = false;
  bool guest = false;
  ProfileModel profile = demoProfile();
  List<CardModel> cards = demoCards();
  List<OrderModel> orders = demoOrders();
  List<Doleance> doleances = demoDoleances();
  List<AppNotification> notifications = demoNotifications();

  SharedPreferences? _prefs;

  int get unreadCount => notifications.where((n) => !n.read).length;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs?.getString(_prefsKey);
    if (raw != null) {
      try {
        final json = jsonDecode(raw) as Map<String, dynamic>;
        lang = AppLang.values.byName(json['lang'] as String? ?? 'fr');
        entered = json['entered'] as bool? ?? false;
        guest = json['guest'] as bool? ?? false;
        final profileJson = json['profile'];
        if (profileJson is Map<String, dynamic>) {
          profile = ProfileModel.fromJson(profileJson);
        }
        final cardsJson = json['cards'];
        if (cardsJson is List) {
          cards = cardsJson.whereType<Map<String, dynamic>>().map(CardModel.fromJson).toList();
        }
        cards.removeWhere((c) => c.id == 'card-classique');
        final doleancesJson = json['doleances'];
        if (doleancesJson is List) {
          doleances = doleancesJson.whereType<Map<String, dynamic>>().map(Doleance.fromJson).toList();
        }
        final notificationsJson = json['notifications'];
        if (notificationsJson is List) {
          notifications =
              notificationsJson.whereType<Map<String, dynamic>>().map(AppNotification.fromJson).toList();
        }
      } catch (_) {
        // Corrupt demo state falls back to the seeded demo data.
      }
    }
    notifyListeners();
  }

  void _persist() {
    final raw = jsonEncode({
      'lang': lang.name,
      'entered': entered,
      'guest': guest,
      'profile': profile.toJson(),
      'cards': cards.map((c) => c.toJson()).toList(),
      'doleances': doleances.map((d) => d.toJson()).toList(),
      'notifications': notifications.map((n) => n.toJson()).toList(),
    });
    _prefs?.setString(_prefsKey, raw);
  }

  void setLang(AppLang value) {
    if (lang == value) return;
    lang = value;
    _persist();
    notifyListeners();
  }

  void enterGuest() {
    entered = true;
    guest = true;
    _persist();
    notifyListeners();
  }

  void signIn() {
    entered = true;
    guest = false;
    _persist();
    notifyListeners();
  }

  void signOut() {
    entered = false;
    guest = false;
    _persist();
    notifyListeners();
  }

  CardModel? cardById(String id) {
    for (final card in cards) {
      if (card.id == id) return card;
    }
    return null;
  }

  void upsertCard(CardModel card) {
    final index = cards.indexWhere((c) => c.id == card.id);
    if (index >= 0) {
      cards[index] = card;
    } else {
      cards.add(card);
    }
    _persist();
    notifyListeners();
  }

  void deleteCard(String id) {
    cards.removeWhere((c) => c.id == id);
    _persist();
    notifyListeners();
  }

  CardModel newCardDraft() {
    return CardModel(
      id: 'card-${DateTime.now().microsecondsSinceEpoch}',
      product: 'eTWASSEL Étudiant',
      lastName: profile.lastName,
      firstName: profile.firstName,
      number: '0000 00',
      expiry: DateTime(2027, 2, 25),
      agency: "Tramway d'Alger",
      durationLabel: '90 Jours',
      remainingDays: 90,
      status: 'ACTIF',
      generatedAt: DateTime.now(),
      photoAsset: 'assets/images/card_photo.png',
      art: CardArt.blue,
    );
  }

  void updateProfile(ProfileModel value) {
    profile = value;
    _persist();
    notifyListeners();
  }

  void addDoleance(Doleance doleance) {
    doleances.insert(0, doleance);
    _persist();
    notifyListeners();
  }

  void markNotificationRead(String id) {
    for (final notification in notifications) {
      if (notification.id == id && !notification.read) {
        notification.read = true;
        _persist();
        notifyListeners();
        return;
      }
    }
  }

  void markAllNotificationsRead() {
    var changed = false;
    for (final notification in notifications) {
      if (!notification.read) {
        notification.read = true;
        changed = true;
      }
    }
    if (changed) {
      _persist();
      notifyListeners();
    }
  }

  void resetDemo() {
    lang = AppLang.fr;
    entered = false;
    guest = false;
    profile = demoProfile();
    cards = demoCards();
    orders = demoOrders();
    doleances = demoDoleances();
    notifications = demoNotifications();
    _persist();
    notifyListeners();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child}) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope is missing above this context');
    return scope!.notifier!;
  }
}
