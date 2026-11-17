# SETRAM Mobile — e-TWASSEL Redesign

[![Release](https://img.shields.io/github/v/release/wazixinho/setram-application-for-mobile-redesign?include_prereleases&style=flat-square)](https://github.com/wazixinho/setram-application-for-mobile-redesign/releases)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&style=flat-square)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.14+-0175C2?logo=dart&style=flat-square)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android&style=flat-square)](https://developer.android.com)

A modern, fluid redesign of the official **SETRAM** (Société d'Exploitation des Tramways d'Algérie) **e-TWASSEL** mobile application. Built for tramway passengers across Algerian networks (Algiers, Oran, Constantine, Sidi Bel Abbès, Ouargla, Mostaganem, and Sétif).

---

## 🚀 Download & Installation

The compiled release `.apk` is available on GitHub Releases:

1. Go to the [**Releases**](https://github.com/wazixinho/setram-application-for-mobile-redesign/releases) section.
2. Under **Assets** of the latest release (`v1.0.0`), download **`app-release.apk`**.
3. Open the downloaded `.apk` on your Android device and confirm installation (allow installation from unknown sources if prompted).

---

## ✨ Key Features

- **🌐 Bilingual & Bi-directional (i18n):** Native support for French (LTR) and Arabic (RTL) with dynamic runtime switching.
- **💳 Smart Card Management:** Track, inspect, and manage tramway cards (Tawassol, subscriptions) with visual card faces and quick details.
- **🕒 Timetables & Schedules:** Instant consultation of tram passage frequencies, departure schedules, and transit operational hours.
- **🗺️ Network & Stations:** Browse tram lines, key transfer hubs, and nearby station locations.
- **🛒 Orders & Recharges:** Review transit ticket orders, subscription requests, and reload history.
- **📝 Doléances & Customer Support:** File claims, suggestions, or incident reports directly to SETRAM service teams.
- **🔔 Real-time Transit Notifications:** Keep updated on network alerts, service disruptions, and promotions.
- **👤 Guest & User Profiles:** Flexible access enabling instant consultation as a guest or personalized account features.

---

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev) (Dart SDK `^3.14.0`)
- **UI & Design:** Material Design 3, custom typography (Poppins, Montserrat), SVG assets (`flutter_svg`)
- **State & Storage:** Change-notifier application state architecture, persisted with `shared_preferences`
- **Target OS:** Android (SDK API 35 compatibility)

---

## 💻 Building from Source

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>= 3.14.0)
- Android SDK with command-line tools / Android Studio
- Java Development Kit (JDK 17+)

### Steps
```bash
# Clone the repository
git clone https://github.com/wazixinho/setram-application-for-mobile-redesign.git
cd setram-application-for-mobile-redesign

# Fetch dependencies
flutter pub get

# Run on a connected device / emulator
flutter run

# Build a release APK
flutter build apk --release
```
The compiled APK will be output to:
`build/app/outputs/flutter-apk/app-release.apk`

---

## 📄 License
This project is an independent mobile UI redesign for SETRAM e-TWASSEL. All trademarks and branding rights belong to SETRAM.
