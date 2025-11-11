# 🚀 FastlyGo - Modern Delivery App

FastlyGo is a modern, feature-rich delivery application built with Flutter. It provides a seamless experience for customers, couriers, and businesses.

## ✨ Features

### For Customers
- 📱 Multi-language support (English, Turkish, Macedonian)
- 📞 Phone number authentication with SMS verification
- 🗺️ Google Maps integration for address selection
- 📦 Real-time order tracking
- 👤 User profile management
- 🔔 Order status notifications

### For Couriers
- 📋 Available orders list
- ✅ Order acceptance
- 📍 Real-time location updates
- 💰 Earnings tracking

### For Businesses
- 💼 Business dashboard
- 📊 Order management
- 💳 Balance tracking
- 📦 Bulk order creation

## 🛠️ Tech Stack

- **Framework:** Flutter 3.24.5
- **Language:** Dart 3.5.4
- **State Management:** Provider
- **Maps:** Google Maps Flutter
- **Location:** Geolocator
- **HTTP:** http package
- **Storage:** SharedPreferences

## 📋 Requirements

- Flutter SDK 3.24.5+
- Dart SDK 3.5.4+
- Android SDK (API 21-35)
- iOS 12.0+ (for iOS builds)

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/fastlygo_app.git
cd fastlygo_app
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure API

Update the API base URL in `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'https://fastlygo1.manus.space';
```

### 4. Configure Google Maps

Add your Google Maps API key in `android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE"/>
```

### 5. Run the app

```bash
# Run on connected device/emulator
flutter run

# Build APK
flutter build apk --release

# Build for iOS
flutter build ios --release
```

## 📱 Build APK

```bash
flutter build apk --release
```

The APK will be located at:
```
build/app/outputs/flutter-apk/app-release.apk
```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── services/
│   └── api_service.dart      # API integration
├── presentation/
│   ├── screens/
│   │   ├── auth/            # Authentication screens
│   │   ├── home/            # Home screens
│   │   ├── order/           # Order screens
│   │   ├── courier/         # Courier screens
│   │   ├── business/        # Business screens
│   │   └── profile/         # Profile screens
│   └── widgets/             # Reusable widgets
└── l10n/                    # Localization files
```

## 🌍 Localization

The app supports multiple languages:
- English (en)
- Turkish (tr)
- Macedonian (mk)

Translations are located in `lib/l10n/app_*.arb` files.

## 🔧 Configuration

### API Endpoints

Base URL: `https://fastlygo1.manus.space`

**Auth:**
- POST `/api/auth/send-verification-code`
- POST `/api/auth/verify-code`

**Order:**
- POST `/api/order/create`
- GET `/api/order/courier-location/:orderId`

**User:**
- GET `/api/user/profile`
- PUT `/api/user/profile`

### Google Maps

API Key is required for:
- Address selection
- Live courier tracking
- Route drawing

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  http: ^1.1.0
  shared_preferences: ^2.2.2
  google_maps_flutter: ^2.5.0
  geolocator: ^9.0.2
  geocoding: ^2.1.0
  flutter_polyline_points: ^2.0.0
```

## 🐛 Known Issues

- Profile picture upload UI is ready but backend integration is pending
- Social login buttons are present but OAuth is not implemented
- Some dashboard features are in demo mode

## 🚧 Roadmap

- [ ] Payment system integration
- [ ] Push notifications
- [ ] Order history screen
- [ ] WebSocket for real-time updates
- [ ] Courier rating system
- [ ] Order cancellation
- [ ] Promo code system

## 📄 License

This project is proprietary software.

## 👥 Contributors

- Development Team

## 📞 Support

For support, please contact the development team.

---

**Version:** 14.2.0  
**Last Updated:** November 2025
