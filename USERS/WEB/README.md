# Truthprenuer User Web Platform (`USERS/WEB/`)

## 1. Overview
Target definitions, manifest mappings, and deployment specifications for the Flutter Web client of Truthprenuer.

## 2. Directory Mappings & Canonical Files
- **Canonical Web Shell:** [`web/index.html`](../../USERS/WEB/index.html)
- **Web App Manifest:** [`web/manifest.json`](../../USERS/WEB/manifest.json)
- **Favicon & Brand Assets:** [`web/favicon.png`](../../USERS/WEB/favicon.png)
- **Target Specification:** [`web_target_definition.json`](../../USERS/WEB/web_target_definition.json)

## 3. Build & Execution Commands
```bash
# Run locally in Chrome with hot restart
flutter run -d chrome

# Build production bundle with CanvasKit renderer
flutter build web --release --web-renderer canvaskit
```
