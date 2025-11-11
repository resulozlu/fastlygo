# FastlyGo Development Guide

Bu kılavuz, FastlyGo projesinde geliştirmeye devam etmek için gereken tüm bilgileri içerir.

---

## 📦 Proje Yapısı

```
fastlygo_app/
├── lib/
│   ├── main.dart                          # Ana giriş noktası
│   ├── l10n/                              # Çoklu dil desteği (280+ anahtar)
│   │   ├── app_en.arb                     # İngilizce
│   │   ├── app_tr.arb                     # Türkçe
│   │   └── app_mk.arb                     # Makedonca
│   ├── models/                            # Veri modelleri
│   │   └── order.dart
│   ├── providers/                         # State management (Provider)
│   │   ├── language_provider.dart
│   │   └── user_provider.dart
│   ├── services/                          # Backend API servisleri
│   │   └── api_service.dart               # ✨ YENİ: Tüm API çağrıları
│   └── presentation/
│       ├── screens/
│       │   ├── splash/
│       │   │   └── splash_screen.dart
│       │   ├── language/
│       │   │   └── language_selection_screen.dart
│       │   ├── auth/
│       │   │   └── login_screen.dart
│       │   ├── home/
│       │   │   └── home_screen.dart
│       │   ├── order/
│       │   │   ├── create_order_screen.dart
│       │   │   ├── address_selection_screen.dart      # ✨ YENİ: Harita ile adres seçimi
│       │   │   ├── courier_searching_screen.dart
│       │   │   ├── order_tracking_screen.dart
│       │   │   └── order_tracking_map_screen.dart     # ✨ YENİ: Canlı kurye takibi
│       │   ├── courier/
│       │   │   └── courier_dashboard_screen.dart
│       │   └── business/
│       │       └── business_dashboard_screen.dart
│       └── widgets/
│           └── custom_button.dart
├── assets/
│   └── images/
│       ├── logo.png
│       ├── splash_logo.png
│       └── ...
├── android/
│   └── app/
│       ├── build.gradle                   # Android build yapılandırması
│       └── src/main/
│           ├── AndroidManifest.xml        # Google Maps API key burada
│           └── res/
├── pubspec.yaml                           # Paket bağımlılıkları
├── SETUP_ENVIRONMENT.sh                   # Ortam kurulum scripti
└── DEVELOPMENT_GUIDE.md                   # Bu dosya
```

---

## 🚀 Hızlı Başlangıç

### 1. Projeyi İndirme
```bash
# Yedek arşivini açma
cd ~
tar -xzf fastlygo_app_backup_v14.1.0.tar.gz
cd fastlygo_app
```

### 2. Ortamı Kurma
```bash
# Otomatik kurulum
./SETUP_ENVIRONMENT.sh

# VEYA Manuel kurulum için aşağıdaki adımları takip edin
```

### 3. Build Etme
```bash
# APK build
flutter build apk --release

# Debug build
flutter build apk --debug

# Belirli bir cihaza yükleme
flutter install
```

---

## 🔧 Manuel Kurulum

### Flutter SDK
```bash
cd ~
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:$HOME/flutter/bin"
flutter doctor
```

### Android SDK
```bash
cd ~
mkdir -p android-sdk/cmdline-tools
cd android-sdk/cmdline-tools
wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip commandlinetools-linux-11076708_latest.zip
mv cmdline-tools latest
rm commandlinetools-linux-11076708_latest.zip

export ANDROID_HOME=$HOME/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-35" "build-tools;33.0.0"
```

### Paketleri Yükleme
```bash
cd ~/fastlygo_app
flutter pub get
```

---

## 🐛 Bilinen Sorunlar ve Çözümleri

### 1. Geolocator Build Hatası
**Hata:** `Could not get unknown property 'flutter' for extension 'android'`

**Çözüm:**
```bash
# build.gradle düzeltme
nano ~/.pub-cache/hosted/pub.dev/geolocator_android-4.6.2/android/build.gradle

# Şu satırları değiştir:
compileSdk flutter.compileSdkVersion  →  compileSdk 35
minSdkVersion flutter.minSdkVersion    →  minSdkVersion 21
```

### 2. Android 34 API Hatası
**Hata:** `cannot find symbol: variable UPSIDE_DOWN_CAKE`

**Çözüm:**
```bash
# LocationMapper.java düzeltme
nano ~/.pub-cache/hosted/pub.dev/geolocator_android-4.6.2/android/src/main/java/com/baseflow/geolocator/location/LocationMapper.java

# 48. satırı değiştir:
if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE
↓
if (Build.VERSION.SDK_INT >= 34) {
  try {
```

### 3. Null Safety Hatası
**Hata:** `A value of type 'String?' can't be assigned to a variable of type 'String'`

**Çözüm:** Zaten düzeltildi, `api_service.dart` dosyasında local variable kullanılıyor.

---

## 🔑 Yapılandırma

### API Base URL Değiştirme
```dart
// lib/services/api_service.dart
static const String baseUrl = 'https://fastlygo1.manus.space';
```

### Google Maps API Key Değiştirme
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyCkPbiBZyWwAoTm_q33mi9oZshjcg9CmcQ"/>
```

### Versiyon Güncelleme
```yaml
# pubspec.yaml
version: 14.1.0+16
```

```gradle
// android/app/build.gradle
versionCode = 16
versionName = "14.1.0"
```

---

## 🎨 Yeni Özellik Ekleme

### Yeni Ekran Ekleme
```dart
// 1. Ekran dosyası oluştur
lib/presentation/screens/yeni_ozellik/yeni_ekran.dart

// 2. Route ekle (main.dart)
'/yeni-ekran': (context) => YeniEkran(),

// 3. Navigation
Navigator.pushNamed(context, '/yeni-ekran');
```

### Yeni API Endpoint Ekleme
```dart
// lib/services/api_service.dart

Future<Map<String, dynamic>> yeniEndpoint(String param) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/yeni-endpoint'),
      headers: _getHeaders(),
      body: json.encode({'param': param}),
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('API Error');
  } catch (e) {
    // Fallback
    return {'success': false, 'error': e.toString()};
  }
}
```

### Yeni Çeviri Ekleme
```json
// lib/l10n/app_en.arb
{
  "yeniAnahtar": "New Text",
  "@yeniAnahtar": {
    "description": "Description of the text"
  }
}

// lib/l10n/app_tr.arb
{
  "yeniAnahtar": "Yeni Metin"
}
```

**Kullanım:**
```dart
Text(AppLocalizations.of(context)!.yeniAnahtar)
```

---

## 🧪 Test Etme

### Debug Modu
```bash
flutter run
```

### Release APK Test
```bash
flutter build apk --release
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Logları İzleme
```bash
flutter logs
# VEYA
adb logcat | grep flutter
```

---

## 📚 Önemli Komutlar

```bash
# Paketleri güncelleme
flutter pub upgrade

# Cache temizleme
flutter clean

# Build temizleme
rm -rf build/

# Paket versiyonlarını kontrol
flutter pub outdated

# Dart kod analizi
flutter analyze

# Kod formatlama
flutter format lib/

# APK boyutunu analiz etme
flutter build apk --analyze-size
```

---

## 🔐 API Endpoints

**Base URL:** `https://fastlygo1.manus.space`

### Auth
- `POST /api/auth/send-verification-code`
- `POST /api/auth/verify-code`

### Order
- `POST /api/order/create`
- `GET /api/order/status/:orderId`
- `GET /api/order/my-orders`
- `GET /api/order/courier-location/:orderId`

### Courier
- `GET /api/courier/available-orders`
- `POST /api/courier/accept-order`
- `POST /api/courier/update-status`
- `POST /api/courier/update-location`
- `GET /api/courier/earnings`

### Business
- `GET /api/business/balance`
- `GET /api/business/orders`
- `POST /api/business/bulk-order`

### User
- `GET /api/user/profile`
- `PUT /api/user/profile`

---

## 📱 Paket Versiyonları

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1
  
  # HTTP
  http: ^1.1.0
  
  # Storage
  shared_preferences: ^2.2.2
  
  # Maps & Location
  google_maps_flutter: ^2.5.0
  geolocator: ^9.0.2
  geocoding: ^2.1.0
  flutter_polyline_points: ^2.0.0
  
  # UI
  intl: any
```

---

## 🎯 Sonraki Adımlar

1. **WebSocket Entegrasyonu**: Gerçek zamanlı kurye konumu için
2. **Push Notifications**: Firebase Cloud Messaging
3. **Sosyal Login**: Google, Apple, Microsoft OAuth
4. **Ödeme Sistemi**: Stripe/PayPal entegrasyonu
5. **Kurye Değerlendirme**: Rating sistemi
6. **Sipariş Geçmişi**: Detaylı geçmiş sayfası
7. **Profil Düzenleme**: Kullanıcı bilgileri güncelleme
8. **İşletme Raporları**: Analytics ve grafikler

---

## 📞 Destek

Sorun yaşarsanız:
1. `flutter doctor` çalıştırın
2. `flutter clean && flutter pub get` deneyin
3. Build hatası için yukarıdaki "Bilinen Sorunlar" bölümüne bakın
4. Yedek APK'yı test edin: `FastlyGo_v14.0.0_BACKUP.apk`

---

**Son Güncelleme:** 7 Kasım 2025  
**Versiyon:** 14.1.0
