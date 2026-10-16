# TRUTHPRENUER — COMPREHENSIVE REPOSITORY INVENTORY
## Phase 1 Architecture & File Governance Manifest

**Date:** 12 October 2026  
**Auditor:** Principal Software Architect, DevSecOps & Security Review  
**Repository Root:** `Truthprenuer` (workspace: `USERS/FLUTTER/taeed_flutter_source`)  
**Target Identity:** `Truthprenuer/`  

---

## 1. Complete File Classification & Inventory Matrix

| Current Path | File Purpose | Owner | Dependencies | Runtime Status | Target Path | Risk | Action | Verification |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `pubspec.yaml` | Flutter client manifest and dependencies | User Client (Universal) | Flutter SDK, pub packages | Production (Critical) | `pubspec.yaml` (Framework Root) | High | Keep at root (Framework convention) | `flutter pub get` & `flutter test` |
| `pubspec.lock` | Deterministic dependency tree lockfile | User Client (Universal) | `pubspec.yaml` | Production (Critical) | `pubspec.lock` | High | Keep at root | `flutter test` |
| `lib/main.dart` | Universal client entry point and provider root | User Client (Universal) | Flutter, Riverpod, Supabase | Production (Active) | `lib/main.dart` | High | Keep & map to `USERS/` | `flutter run` & `flutter test` |
| `lib/components/` | Reusable UI widgets (cards, badges, modals) | User Client (Presentation) | Flutter Material, Design System | Production (Active) | `lib/components/` (mapped to `USERS/COMPONENTS/`) | Medium | Keep in place; document ownership | 64 Flutter widget tests |
| `lib/models/` | Domain entity definitions (User, Claim, Feedback) | User Client (Domain) | Dart core, JSON serialization | Production (Active) | `lib/models/` (mapped to `USERS/SHARED/`) | Medium | Keep in place | Unit tests |
| `lib/repositories/` | Data access, Supabase client, offline sync | User Client (Infrastructure) | `supabase_flutter`, `http`, SQLite | Production (Active) | `lib/repositories/` (mapped to `USERS/SHARED/`) | High | Keep in place | Integration tests |
| `lib/router/app_router.dart` | Declarative URL & screen navigation | User Client (Routing) | `go_router` | Production (Active) | `lib/router/app_router.dart` | Medium | Keep in place | Route unit tests |
| `test/` | Automated unit, widget, and regression test suite | QA / Automation | `flutter_test`, `flutter_riverpod` | Test-only | `test/` | High | Keep in place; 64 tests | `flutter test` (100% pass) |
| `android/` | Native Android wrapper and Gradle build tree | Android Platform | Gradle 8, Android SDK 34 | Build Configuration | `android/` (mapped to `USERS/ANDROID/`) | High | Keep at root (Toolchain requirement) | `flutter build apk --dry-run` |
| `ios/` | Native iOS Xcode project and CocoaPods | iOS Platform | CocoaPods, Xcode 15+ | Build Configuration | `ios/` (mapped to `USERS/IOS/`) | High | Keep at root (Toolchain requirement) | `pod check` / build tests |
| `web/` | Web embedding, PWA manifest, service workers | Web Platform | Flutter Web engine | Production (Cloudflare Pages) | `web/` (mapped to `USERS/WEB/`) | Medium | Keep at root | `flutter build web` |
| `backend/app/main.py` | FastAPI application server entry point | Backend API | FastAPI, Starlette, Uvicorn | Production (Active) | `backend/app/main.py` | High | Keep in place (Mapped to `BACKEND/API/`) | `pytest backend/tests/` |
| `backend/app/core/` | Security, rate limiting, logging, middleware | Backend Core | `pydantic`, `pyjwt`, `argon2` | Production (Active) | `backend/app/core/` (Mapped to `BACKEND/SHARED/`) | High | Keep in place | Pytest security suite |
| `backend/app/services/` | Audit logging (WORM), moderation, AI engine | Backend Services | Supabase REST, Gemini SDK | Production (Active) | `backend/app/services/` (Mapped to `BACKEND/SERVICES/`) | High | Keep in place | Pytest service suite |
| `backend/requirements.txt` | Python dependency manifest | Backend API | pip, venv | Production (Critical) | `backend/requirements.txt` | High | Keep in place | `pip check` |
| `backend/tests/` | Pytest API & security test suite (13 tests) | Backend QA | `pytest`, `httpx` | Test-only | `backend/tests/` | High | Keep in place | `pytest` (13/13 pass) |
| `admin_panel/package.json` | React 19 / Vite 8 admin manifest | Admin Console | React 19, Vite 8, Lucide | Build Configuration | `admin_panel/package.json` | High | Keep in place (Mapped to `ADMIN/FRONTEND/`) | `npm run build` |
| `admin_panel/vite.config.ts` | Vite configuration strictly bound to `127.0.0.1:60135` | Admin Console Security | Vite | Production (Loopback) | `admin_panel/vite.config.ts` | High | Keep in place | `curl -I 127.0.0.1:60135/` |
| `admin_panel/src/` | Admin React pages, guards, and telemetry visuals | Admin Console UI | React, Tailwind, Lucide | Production (Loopback) | `admin_panel/src/` | High | Keep in place | TypeScript compilation |
| `ADMIN/RUN_LOCAL/start_admin_60135.sh` | Local Admin loopback launcher script | DevSecOps / Admin | Bash, Vite | Operational Utility | `ADMIN/RUN_LOCAL/start_admin_60135.sh` | Medium | Keep and maintain | Curl loopback verify |
| `DATABASE/SCHEMA/schema.sql` | Canonical PostgreSQL schema definitions | Database Architecture | PostgreSQL 15+ | Production Baseline | `DATABASE/SCHEMA/schema.sql` | High | Keep in place | Schema verification test |
| `DATABASE/POLICIES/rls_policies.sql` | Row Level Security (RLS) & WORM audit policies | Database Security | PostgreSQL RLS | Production Security | `DATABASE/POLICIES/rls_policies.sql` | High | Keep in place | SQL parse check |
| `DATABASE/TRIGGERS/audit_and_reputation_triggers.sql` | Immutability triggers and updated_at triggers | Database Engine | PL/pgSQL | Production Security | `DATABASE/TRIGGERS/audit_and_reputation_triggers.sql` | High | Keep in place | SQL parse check |
| `DATABASE/INDEXES/performance_indexes.sql` | Composite query indexes for validation feeds | Database Performance | PostgreSQL | Production Performance | `DATABASE/INDEXES/performance_indexes.sql` | Medium | Keep in place | Index analysis |
| `DEVTOOLS/TESTING/run_all_tests.sh` | One-command full test suite runner | DevTooling / QA | Bash, Flutter, Pytest, npm | Operational Utility | `DEVTOOLS/TESTING/run_all_tests.sh` | High | Keep in place | Shell execution |
| `DEVTOOLS/SECURITY_SCANNING/run_security_scan.sh` | Secret hygiene & 0.0.0.0 binding scanner | Security Engineering | Bash, grep | Operational Utility | `DEVTOOLS/SECURITY_SCANNING/run_security_scan.sh` | High | Keep in place | Scanner execution |
| `PRODUCT/PRD/` | Product Requirements Document | Product Management | None | Documentation | `PRODUCT/PRD/` | Low | Maintain synchronization | Doc review |
| `PRODUCT/ARCHITECTURE/` | Architecture maps, deployment models, inventories | Systems Architecture | None | Documentation | `PRODUCT/ARCHITECTURE/` | Low | Maintain synchronization | Architecture review |
| `PRODUCT/RUNBOOKS/` | Development, admin startup, and incident response runbooks | Site Reliability (SRE) | None | Operational Guide | `PRODUCT/RUNBOOKS/` | Medium | Maintain synchronization | Operator test |
| `.github/workflows/ci.yml` | CI automation for Flutter, Backend, and Admin | DevSecOps / CI | GitHub Actions | Automation (Active) | `.github/workflows/ci.yml` | High | Keep at root (.github requirement) | YAML lint / CI run |

---

## 2. Framework-Required Root File Justifications

In adherence to Non-Negotiable Rule 2 & 3, the following files MUST remain at their designated canonical locations because moving them breaks package managers, CLI toolchains, and CI/CD discovery:

1. **`pubspec.yaml` & `pubspec.lock`**: The Flutter SDK specifically checks `$(pwd)/pubspec.yaml` for package resolution, asset bundling, and test discovery.
2. **`lib/`**: Flutter compilation defaults to `lib/main.dart`. Moving `lib/` breaks `flutter run`, `flutter test`, and IDE analyzers.
3. **`test/`**: `flutter test` automatically runs tests from the top-level `test/` directory.
4. **`android/`, `ios/`, `web/`, `macos/`, `windows/`, `linux/`**: Native platform folders are managed by the Flutter CLI.
5. **`backend/`**: Contains Python `requirements.txt`, `venv/`, and `tests/` invoked by Dockerfiles and CI scripts.
6. **`admin_panel/`**: Contains Node `package.json`, `vite.config.ts`, and `node_modules/`.
7. **`.github/workflows/`**: GitHub Actions runner strictly requires workflows to reside in `.github/workflows/`.

All logical modules in `USERS/`, `ADMIN/`, `DATABASE/`, `PRODUCT/`, `BACKEND/`, `ALGORITHMS/`, `INFRASTRUCTURE/`, and `DEVTOOLS/` serve as the authoritative architectural mapping, ownership governance, and documentation layer.
