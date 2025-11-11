#!/bin/bash
# FastlyGo Development Environment Setup Script
# Bu script, projeyi sıfırdan kurmak için gerekli tüm adımları içerir

set -e

echo "=========================================="
echo "FastlyGo Development Environment Setup"
echo "=========================================="

# Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Flutter SDK Kurulumu
echo -e "\n${YELLOW}[1/7] Flutter SDK kuruluyor...${NC}"
if [ ! -d "$HOME/flutter" ]; then
    cd $HOME
    git clone https://github.com/flutter/flutter.git -b stable --depth 1
    echo -e "${GREEN}✓ Flutter SDK kuruldu${NC}"
else
    echo -e "${GREEN}✓ Flutter SDK zaten mevcut${NC}"
fi

# PATH'e ekle
export PATH="$PATH:$HOME/flutter/bin"

# 2. Flutter doctor
echo -e "\n${YELLOW}[2/7] Flutter kontrol ediliyor...${NC}"
flutter doctor

# 3. Android SDK Kurulumu
echo -e "\n${YELLOW}[3/7] Android SDK kuruluyor...${NC}"
if [ ! -d "$HOME/android-sdk" ]; then
    cd $HOME
    mkdir -p android-sdk/cmdline-tools
    cd android-sdk/cmdline-tools
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
    unzip -q commandlinetools-linux-11076708_latest.zip
    mv cmdline-tools latest
    rm commandlinetools-linux-11076708_latest.zip
    echo -e "${GREEN}✓ Android SDK command-line tools kuruldu${NC}"
else
    echo -e "${GREEN}✓ Android SDK zaten mevcut${NC}"
fi

# Android SDK PATH
export ANDROID_HOME=$HOME/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# 4. Android SDK Paketlerini Yükleme
echo -e "\n${YELLOW}[4/7] Android SDK paketleri yükleniyor...${NC}"
yes | sdkmanager --licenses > /dev/null 2>&1
sdkmanager "platform-tools" "platforms;android-33" "platforms;android-34" "platforms;android-35" "build-tools;33.0.0" "build-tools;33.0.1"
echo -e "${GREEN}✓ Android SDK paketleri yüklendi${NC}"

# 5. Proje Bağımlılıklarını Yükleme
echo -e "\n${YELLOW}[5/7] Flutter paketleri yükleniyor...${NC}"
cd $HOME/fastlygo_app
flutter pub get
echo -e "${GREEN}✓ Flutter paketleri yüklendi${NC}"

# 6. Geolocator Düzeltmesi
echo -e "\n${YELLOW}[6/7] Geolocator paketi düzeltiliyor...${NC}"
GEOLOCATOR_FILE="$HOME/.pub-cache/hosted/pub.dev/geolocator_android-4.6.2/android/build.gradle"
if [ -f "$GEOLOCATOR_FILE" ]; then
    sed -i 's/compileSdk flutter.compileSdkVersion/compileSdk 35/' "$GEOLOCATOR_FILE"
    sed -i 's/minSdkVersion flutter.minSdkVersion/minSdkVersion 21/' "$GEOLOCATOR_FILE"
    echo -e "${GREEN}✓ Geolocator build.gradle düzeltildi${NC}"
fi

LOCATION_MAPPER="$HOME/.pub-cache/hosted/pub.dev/geolocator_android-4.6.2/android/src/main/java/com/baseflow/geolocator/location/LocationMapper.java"
if [ -f "$LOCATION_MAPPER" ]; then
    # Android 34 API çağrılarını try-catch ile sarma
    sed -i 's/if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE/if (Build.VERSION.SDK_INT >= 34) {\n        try {/' "$LOCATION_MAPPER"
    echo -e "${GREEN}✓ LocationMapper.java düzeltildi${NC}"
fi

# 7. Environment Variables
echo -e "\n${YELLOW}[7/7] Environment variables ayarlanıyor...${NC}"
cat >> $HOME/.bashrc << 'EOF'

# Flutter & Android SDK
export PATH="$PATH:$HOME/flutter/bin"
export ANDROID_HOME=$HOME/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
EOF

echo -e "${GREEN}✓ Environment variables ayarlandı${NC}"

# Özet
echo -e "\n=========================================="
echo -e "${GREEN}Kurulum Tamamlandı!${NC}"
echo -e "=========================================="
echo -e "\nProjeyi build etmek için:"
echo -e "  ${YELLOW}cd ~/fastlygo_app${NC}"
echo -e "  ${YELLOW}flutter build apk --release${NC}"
echo -e "\nYeni terminal açtıktan sonra şunu çalıştırın:"
echo -e "  ${YELLOW}source ~/.bashrc${NC}"
echo -e "\n=========================================="
