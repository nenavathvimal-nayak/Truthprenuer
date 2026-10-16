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
| `USERS/WEB/` | Cloudflare Pages web build, PWA manifest, service workers | [`web/`](../USERS/WEB) |
| `USERS/ANDROID/` | Native Android configuration, Gradle, manifests, proguard | [`android/`](../USERS/ANDROID) |
| `USERS/IOS/` | Native iOS Xcode project, Podfile, capabilities | [`ios/`](../USERS/IOS) |
| `USERS/DESKTOP/` | Desktop platform runners | [`macos/`](../macos), [`windows/`](../windows), [`linux/`](../linux) |
| `USERS/BACKEND/` | Public user endpoints (Auth, Claims, Feeds, AI Verification) | [`backend/app/api/v1/`](../backend/app/api/v1) |
| `USERS/ALGORITHMS/` | Consensus algorithms, Truth Score verification, AI defense | [`backend/app/services/`](../backend/app/services) & [`lib/core/`](../USERS/lib/core) |
| `USERS/SHARED/` | Dart models, Riverpod providers, offline repositories | [`lib/`](../USERS/lib) |
| `USERS/INFRASTRUCTURE/` | Cloudflare Pages, Docker, reverse proxy configurations | [`docker/`](../docker) & [`deploy/`](../deploy) |
| `USERS/DOCUMENTATION/` | User documentation and public API specifications | [`USERS/DOCUMENTATION/PUBLIC_API_GUIDE.md`](../USERS/DOCUMENTATION/PUBLIC_API_GUIDE.md) |

## 3. Security Boundary
User applications run across public internet and local environments. All communications are TLS 1.3 encrypted, authenticated via scoped JWTs, and subject to client-side origin checking and strict rate-limiting.
Under zero circumstances do User applications have access to Admin Console routes or elevated privileges.
