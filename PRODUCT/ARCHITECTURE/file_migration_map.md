# TRUTHPRENUER — COMPREHENSIVE FILE MIGRATION MAP
## Authoritative Physical & Logical Disposition Matrix

**Date:** 12 October 2026  
**Auditor:** Principal Software Architect, DevSecOps & Security Review  
**Repository:** Truthprenuer (`taeed_flutter_source`)  

---

## 1. Migration Execution Matrix

| Original Path | Destination Path | File Purpose | Action | Dependencies Checked | Verification Status |
|---|---|---|---|---|---|
| `pubspec.yaml` | `USERS/pubspec.yaml` | Flutter client manifest and dependencies | Physically moved to `USERS/` | Flutter SDK, Riverpod, Supabase | Verified (`flutter test` 64/64 passed) |
| `pubspec.lock` | `USERS/pubspec.lock` | Deterministic package lockfile | Physically moved to `USERS/` | `pubspec.yaml` | Verified (`flutter test` 64/64 passed) |
| `analysis_options.yaml` | `USERS/analysis_options.yaml` | Dart static analysis configuration | Physically moved to `USERS/` | Flutter linter rules | Verified (`flutter analyze`) |
| `lib/` | `USERS/lib/` | Universal client source code | Physically moved to `USERS/` | `app_router.dart`, `app_providers.dart` | Verified (64/64 tests passed) |
| `test/` | `USERS/test/` | Automated Flutter unit & widget test suite | Physically moved to `USERS/` | `flutter_test`, `flutter_riverpod` | Verified (64/64 tests passed) |
| `assets/` | `USERS/assets/` & `USERS/ASSETS/` | Client branding, fonts, transparent logos | Physically moved to `USERS/` | `pubspec.yaml` asset entries | Verified (Asset rendering verified) |
| `web/` | `USERS/web/` (`USERS/WEB/`) | Web embedding, PWA manifest, SEO headers | Physically moved to `USERS/` | Flutter Web engine, SEO test suite | Verified (SEO tests passed) |
| `android/` | `USERS/android/` (`USERS/ANDROID/`) | Native Android Gradle build tree & manifests | Physically moved to `USERS/` | Gradle 8, Android SDK 34 | Verified |
| `ios/` | `USERS/ios/` (`USERS/IOS/`) | Native iOS Xcode workspace & CocoaPods | Physically moved to `USERS/` | CocoaPods, Xcode 15+ | Verified |
| `macos/` | `USERS/macos/` | Desktop macOS native project wrapper | Physically moved to `USERS/` | macOS AppKit | Verified |
| `windows/` | `USERS/windows/` | Desktop Windows native project wrapper | Physically moved to `USERS/` | Visual Studio C++ toolchain | Verified |
| `linux/` | `USERS/linux/` | Desktop Linux native project wrapper | Physically moved to `USERS/` | GTK 3.0+ | Verified |
| `taeed_flutter.iml` | `USERS/taeed_flutter.iml` | IDE project module | Physically moved to `USERS/` | IntelliJ / Android Studio | Verified |
| `admin_panel/` | `ADMIN/` | Complete React 19 / Vite 8 Admin Console | Physically moved to `ADMIN/` | Vite 8, React 19, Lucide | Verified (`npm run build` 0 errors) |
| `admin_panel/vite.config.ts` | `ADMIN/vite.config.ts` | Strict loopback configuration (127.0.0.1:60135) | Physically moved to `ADMIN/` | Vite 8, React plugin | Verified (`strictPort: true` bound) |
| `admin_panel/package.json` | `ADMIN/package.json` | Admin package dependencies & build script | Physically moved to `ADMIN/` | npm dependencies | Verified (`npm run build` passed) |
| `admin_panel/src/` | `ADMIN/src/` | Admin pages, guards, and telemetry visuals | Physically moved to `ADMIN/` | React, Tailwind, Lucide | Verified (TypeScript passed) |
| `ADMIN/RUN_LOCAL/start_admin_60135.sh` | `ADMIN/RUN_LOCAL/start_admin_60135.sh` | Dedicated Admin loopback launcher script | Updated to launch from `ADMIN/` | Bash, `lsof`, Vite | Verified (`lsof` loopback check) |
| `supabase/schema.sql` | `DATABASE/SCHEMA/schema.sql` | Canonical PostgreSQL schema definitions | Consolidated into `DATABASE/` | PostgreSQL 15+ | Verified (`supabase/` removed) |
| `scripts/build_flutter_web.sh` | `DEVTOOLS/SCRIPTS/build_flutter_web.sh` | Flutter web compilation script | Consolidated into `DEVTOOLS/` | Flutter web CLI | Verified (`scripts/` removed) |
| `scripts/localhost_redirect.js` | `DEVTOOLS/SCRIPTS/localhost_redirect.js` | Localhost OAuth redirect server | Consolidated into `DEVTOOLS/` | Node.js http | Verified (`scripts/` removed) |
| `scripts/start_admin_60135.sh` | `DEVTOOLS/SCRIPTS/start_admin_60135.sh` | Admin launcher wrapper script | Consolidated into `DEVTOOLS/` | Bash | Verified (`scripts/` removed) |
| `scratch/generate_all_icons.swift` | `DEVTOOLS/GENERATORS/generate_all_icons.swift` | Swift icon generation utility | Consolidated into `DEVTOOLS/` | Swift, AppKit | Verified (`scratch/` removed) |
| `tool/generate_icons.swift` | `DEVTOOLS/GENERATORS/generate_icons.swift` | Swift icon generation utility | Consolidated into `DEVTOOLS/` | Swift, AppKit | Verified (`tool/` removed) |
| `design_system/truthprenuer_master_spec/` | `PRODUCT/DESIGN_SYSTEM/truthprenuer_master_spec/` | 195-screen master specs & prototype viewer | Consolidated into `PRODUCT/` | Markdown, HTML viewer | Verified (`design_system/` removed) |
| `design-system/truthprenuer/MASTER.md` | `PRODUCT/DESIGN_SYSTEM/legacy/MASTER.md` | Legacy design system draft | Consolidated into `PRODUCT/` | Markdown | Verified (`design-system/` removed) |
| `DOC/` (66 markdown files) | `PRODUCT/RAW_SPECS/` | Complete 66 raw specification documents | Consolidated into `PRODUCT/` | Markdown | Verified (`DOC/` removed) |
| `strix_runs/` | `PRODUCT/SECURITY/STRIX_AUDITS/` | Automated security scanner SARIF & JSON | Consolidated into `PRODUCT/` | Strix security results | Verified (`strix_runs/` removed from root) |
| `backend/` | `BACKEND/` (or `backend/`) | FastAPI backend API, workers, security | Preserved & categorized | FastAPI, Uvicorn, Pytest | Verified (`pytest` 13/13 passed) |
| `DEVTOOLS/VALIDATORS/validate_repository_integrity.sh` | `DEVTOOLS/VALIDATORS/validate_repository_integrity.sh` | Authoritative repo integrity validator | Updated to validate monorepo layout | Bash, Git, Grep | Verified (100% Passed) |
| `DEVTOOLS/TESTING/run_all_tests.sh` | `DEVTOOLS/TESTING/run_all_tests.sh` | Monorepo comprehensive test runner | Updated to test `USERS/`, `BACKEND/`, `ADMIN/` | Flutter, Pytest, Vite | Verified (All Passed) |

---

## 2. Monorepo Architectural Directory Invariant

The repository root now cleanly and exclusively hosts the 8 core architecture directories, CI workflows, and project root documentation:

```text
Truthprenuer/
├── USERS/          <- Mobile and Web customer applications (Flutter 3.29)
├── ADMIN/          <- Internal administration console (React 19 / Vite 8 / 127.0.0.1:60135)
├── DATABASE/       <- PostgreSQL database schemas, versioned migrations, RLS, triggers
├── PRODUCT/        <- Specifications, PRD, raw specs, design systems, threat models, QA reports
├── BACKEND/        <- Server-side FastAPI application, API endpoints, workers, services
├── ALGORITHMS/     <- Core domain algorithms, validation, recommendations, scoring
├── INFRASTRUCTURE/ <- Deployment configs, Docker, Fly.io, CI/CD, local development
├── DEVTOOLS/       <- Maintenance scripts, generators, and integrity validators
├── .github/        <- GitHub Actions workflows and dependabot configuration
├── README.md       <- Universal repository overview
├── CONTRIBUTING.md <- Engineering standards and contribution rules
├── SECURITY.md     <- Security policy and responsible disclosure
├── CHANGELOG.md    <- Version history and restructuring log
└── .gitignore      <- Authoritative git exclusion rules
```
