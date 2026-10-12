# Truthprenuer User Web Platform (`USERS/WEB/`)

## 1. Overview
Target definitions, manifest mappings, and deployment specifications for the Flutter Web client of Truthprenuer.

## 2. Directory Mappings & Canonical Files
- **Canonical Web Shell:** [`web/index.html`](file:///Volumes/NAYAK/taeed_flutter_source/web/index.html)
- **Web App Manifest:** [`web/manifest.json`](file:///Volumes/NAYAK/taeed_flutter_source/web/manifest.json)
- **Favicon & Brand Assets:** [`web/favicon.png`](file:///Volumes/NAYAK/taeed_flutter_source/web/favicon.png)
- **Target Specification:** [`web_target_definition.json`](file:///Volumes/NAYAK/taeed_flutter_source/USERS/WEB/web_target_definition.json)

## 3. Build & Execution Commands
```bash
# Run locally in Chrome with hot restart
flutter run -d chrome

# Build production bundle with CanvasKit renderer
flutter build web --release --web-renderer canvaskit
```
