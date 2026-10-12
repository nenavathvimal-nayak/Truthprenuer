# Truthprenuer User Desktop Platform (`USERS/DESKTOP/`)

## 1. Overview
Target definitions and build manifests for macOS, Linux, and Windows desktop clients.

## 2. Directory Mappings & Canonical Files
- **macOS Root:** [`macos/`](file:///Volumes/NAYAK/taeed_flutter_source/macos/) (Runner project & entitlements)
- **Linux Root:** [`linux/`](file:///Volumes/NAYAK/taeed_flutter_source/linux/) (CMakeLists & GTK shell)
- **Windows Root:** [`windows/`](file:///Volumes/NAYAK/taeed_flutter_source/windows/) (Win32 runner & CMakeLists)
- **Target Definitions:** [`desktop_targets.json`](file:///Volumes/NAYAK/taeed_flutter_source/USERS/DESKTOP/desktop_targets.json)

## 3. Build Commands
```bash
# macOS
flutter run -d macos
flutter build macos --release

# Linux
flutter run -d linux
flutter build linux --release

# Windows
flutter run -d windows
flutter build windows --release
```
