# Truthprenuer User Android Platform (`USERS/ANDROID/`)

## 1. Overview
Target definitions, manifest mappings, and build specifications for the Android mobile client of Truthprenuer.

## 2. Directory Mappings & Canonical Files
- **Canonical Android Root:** [`android/`](../../USERS/ANDROID)
- **Android Manifest:** [`android/app/src/main/AndroidManifest.xml`](../../USERS/ANDROID/app/src/main/AndroidManifest.xml)
- **App Gradle:** [`android/app/build.gradle`](../../USERS/ANDROID/app/build.gradle)
- **Target Specification:** [`android_target_definition.json`](../../USERS/ANDROID/android_target_definition.json)

## 3. Build & Execution Commands
```bash
# Run locally on connected Android device/emulator
flutter run -d android

# Build production APK
flutter build apk --release

# Build production App Bundle for Google Play Store
flutter build appbundle --release
```
