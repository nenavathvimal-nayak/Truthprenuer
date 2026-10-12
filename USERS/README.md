# Truthprenuer User Applications Architecture (`USERS/`)

## 1. Overview
The `USERS/` subsystem represents all public and user-facing surfaces of the Truthprenuer ecosystem:
- **Web App (Production):** Hosted on Cloudflare Pages (`https://truthprenuer.pages.dev`).
- **Mobile (iOS & Android):** Flutter cross-platform client with native performance.
- **Desktop (macOS, Windows, Linux):** Flutter desktop build targets.
- **Backend Services:** FastAPI asynchronous high-throughput REST API.
- **Shared Architecture:** Models, offline cache, state providers, and consensus algorithms.

## 2. Directory Structure and Implementation Mapping

| Module Directory | Logical Purpose | Primary Implementation Target |
| :--- | :--- | :--- |
| `USERS/WEB/` | Cloudflare Pages web build, PWA manifest, service workers | [`web/`](file:///Volumes/NAYAK/taeed_flutter_source/web/) |
| `USERS/ANDROID/` | Native Android configuration, Gradle, manifests, proguard | [`android/`](file:///Volumes/NAYAK/taeed_flutter_source/android/) |
| `USERS/IOS/` | Native iOS Xcode project, Podfile, capabilities | [`ios/`](file:///Volumes/NAYAK/taeed_flutter_source/ios/) |
| `USERS/DESKTOP/` | Desktop platform runners | [`macos/`](file:///Volumes/NAYAK/taeed_flutter_source/macos/), [`windows/`](file:///Volumes/NAYAK/taeed_flutter_source/windows/), [`linux/`](file:///Volumes/NAYAK/taeed_flutter_source/linux/) |
| `USERS/BACKEND/` | Public user endpoints (Auth, Claims, Feeds, AI Verification) | [`backend/app/api/v1/`](file:///Volumes/NAYAK/taeed_flutter_source/backend/app/api/v1/) |
| `USERS/ALGORITHMS/` | Consensus algorithms, Truth Score verification, AI defense | [`backend/app/services/`](file:///Volumes/NAYAK/taeed_flutter_source/backend/app/services/) & [`lib/core/`](file:///Volumes/NAYAK/taeed_flutter_source/lib/core/) |
| `USERS/SHARED/` | Dart models, Riverpod providers, offline repositories | [`lib/`](file:///Volumes/NAYAK/taeed_flutter_source/lib/) |
| `USERS/INFRASTRUCTURE/` | Cloudflare Pages, Docker, reverse proxy configurations | [`docker/`](file:///Volumes/NAYAK/taeed_flutter_source/docker/) & [`deploy/`](file:///Volumes/NAYAK/taeed_flutter_source/deploy/) |
| `USERS/DOCUMENTATION/` | User documentation and public API specifications | [`USERS/DOCUMENTATION/PUBLIC_API_GUIDE.md`](file:///Volumes/NAYAK/taeed_flutter_source/USERS/DOCUMENTATION/PUBLIC_API_GUIDE.md) |

## 3. Security Boundary
User applications run across public internet and local environments. All communications are TLS 1.3 encrypted, authenticated via scoped JWTs, and subject to client-side origin checking and strict rate-limiting.
Under zero circumstances do User applications have access to Admin Console routes or elevated privileges.
