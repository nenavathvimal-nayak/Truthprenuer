# Truthprenuer User Desktop Platform (`USERS/DESKTOP/`)

## 1. Overview
Target definitions and build manifests for macOS, Linux, and Windows desktop clients.

## 2. Directory Mappings & Canonical Files
- **macOS Root:** [`macos/`](../../macos) (Runner project & entitlements)
- **Linux Root:** [`linux/`](../../linux) (CMakeLists & GTK shell)
- **Windows Root:** [`windows/`](../../windows) (Win32 runner & CMakeLists)
- **Target Definitions:** [`desktop_targets.json`](../../USERS/DESKTOP/desktop_targets.json)

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
