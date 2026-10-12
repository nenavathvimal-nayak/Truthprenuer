# Truthprenuer User iOS Platform (`USERS/IOS/`)

## 1. Overview
Target definitions, manifest mappings, and Xcode configurations for the iOS mobile client of Truthprenuer.

## 2. Directory Mappings & Canonical Files
- **Canonical iOS Root:** [`ios/`](file:///Volumes/NAYAK/taeed_flutter_source/ios/)
- **Runner Project:** [`ios/Runner.xcodeproj`](file:///Volumes/NAYAK/taeed_flutter_source/ios/Runner.xcodeproj)
- **Info.plist:** [`ios/Runner/Info.plist`](file:///Volumes/NAYAK/taeed_flutter_source/ios/Runner/Info.plist)
- **CocoaPods Manifest:** [`ios/Podfile`](file:///Volumes/NAYAK/taeed_flutter_source/ios/Podfile)
- **Target Specification:** [`ios_target_definition.json`](file:///Volumes/NAYAK/taeed_flutter_source/USERS/IOS/ios_target_definition.json)

## 3. Build & Execution Commands
```bash
# Run locally on connected iOS Simulator or Device
flutter run -d ios

# Build release IPA for App Store submission
flutter build ipa --release
```
