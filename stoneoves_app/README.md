# 📱 Stone Oves — Flutter App

## Prerequisites — Pehle Yeh Install Karo

### 1. Flutter SDK
- VS Code kholo
- `Ctrl + Shift + P` press karo
- `Flutter: New Project` type karo
- `Download SDK` click karo → `C:\flutter` mein install karo
- VS Code restart karo

### 2. Verify Flutter
```bash
flutter doctor
```
Sab green hone chahiye ✅

### 3. Android Studio (Android ke liye)
- Download: https://developer.android.com/studio
- Install karo
- SDK Manager → SDK Tools → Android SDK Command-line Tools install karo

```bash
flutter doctor --android-licenses
# Har jagah 'y' press karo
```

---

## Project Setup

### 1. Repo Clone karo
```bash
git clone <your-repo-url>
cd Food-Delivery-App/stoneoves_app
```

### 2. Dependencies Install karo
```bash
flutter pub get
```

### 3. Backend URL set karo
`lib/services/api_service.dart` mein:
```dart
// Windows pe run karte waqt
static const String baseUrl = 'http://localhost:3000/api';

// Android Emulator pe
static const String baseUrl = 'http://10.0.2.2:3000/api';

// Real Android Device pe (apna PC ka IP daalo)
static const String baseUrl = 'http://192.168.x.x:3000/api';
```

### 4. Run karo
```bash
flutter run
```
- `1` → Windows
- `2` → Chrome
- `3` → Edge

---

## Important Notes
- Backend pehle start hona chahiye
- `assets/images/` mein food images khud add karni hain (git ignore mein hain)
- Windows Long Path enable karoagar build fail ho:
```bash
# Run as Administrator
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f
```
Phir PC restart karo.

---

## Folder Structure
```
lib/
├── core/
│   ├── constants/    → Colors, TextStyles, Constants
│   ├── theme/        → App Theme
│   └── router/       → Navigation
├── features/
│   ├── home/         → Home Screen + Widgets
│   ├── menu/         → Menu Screen + Widgets
│   ├── cart/         → Cart Screen
│   └── orders/       → Orders Screen
├── models/           → Data Models
├── services/         → API Service + Riverpod Providers
└── widgets/          → Shared Widgets
```