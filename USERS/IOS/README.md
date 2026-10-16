# Truthprenuer User iOS Platform (`USERS/IOS/`)

## 1. Overview
Target definitions, manifest mappings, and Xcode configurations for the iOS mobile client of Truthprenuer.

## 2. Directory Mappings & Canonical Files
- **Canonical iOS Root:** [`ios/`](../../USERS/IOS)
- **Runner Project:** [`ios/Runner.xcodeproj`](../../USERS/IOS/Runner.xcodeproj)
- **Info.plist:** [`ios/Runner/Info.plist`](../../USERS/IOS/Runner/Info.plist)
- **CocoaPods Manifest:** [`ios/Podfile`](../../USERS/IOS/Podfile)
- **Target Specification:** [`ios_target_definition.json`](../../USERS/IOS/ios_target_definition.json)

## 3. Build & Execution Commands
```bash
# Run locally on connected iOS Simulator or Device
flutter run -d ios

# Build release IPA for App Store submission
flutter build ipa --release
```
