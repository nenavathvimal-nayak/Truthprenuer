# TRUTHPRENUER — COMPREHENSIVE REPOSITORY INVENTORY

**Inventory Date:** 12 October 2026  
**Auditing Team:** Principal Architect & DevSecOps Engineering  
**Workspace:** `Truthprenuer` (local: `USERS/FLUTTER/taeed_flutter_source`)  

---

## 1. Directory Tree & Canonical Manifests

### 1.1 Universal User Client (`Flutter`)
- **Root Manifest:** [`pubspec.yaml`](USERS/pubspec.yaml) (Dependencies: `flutter_riverpod`, `go_router`, `supabase_flutter`, `google_fonts`, `http`, `connectivity_plus`, `shared_preferences`)
- **Lockfile:** [`pubspec.lock`](USERS/pubspec.lock)
- **Linter & Rules:** [`analysis_options.yaml`](USERS/analysis_options.yaml)
- **Source Code (`lib/`):**
  - `components/`: UI components (Avatar, Badges, Cards, Top Nav, Shell, State Views)
  - `design_system/`: App colors, typography, spacing, themes
  - `models/`: Models for User, Startup, Validation, Feedback, Chat, Role Provider
  - `repositories/`: Auth, Supabase client, Validation, Feedback, Evidence, Messaging, AI, Privacy
  - `router/`: GoRouter declarative routing (`app_router.dart`)
  - `utils/`: Haptic manager, date formatters, sanitizers
  - `views/`: Auth, Community, Messaging, Validation Wizard, Settings, Profile, Admin
- **Platform Embeddings:**
  - `web/`: Flutter Web runner, manifest, favicon, index.html
  - `android/`: Android Gradle wrapper, manifests, kotlin plugins
  - `ios/`: Xcode Runner project, Podfile, Info.plist
  - `macos/`: macOS desktop embedding
  - `linux/`: Linux desktop runner
  - `windows/`: Windows desktop runner
- **Test Suite (`test/`):**
  - `admin_and_realtime_test.dart`
  - `auth_authorization_flow_test.dart`
  - `realtime_and_offline_regression_test.dart`
  - `universal_state_view_test.dart`
  - Total: 64 automated widget & unit test cases.

### 1.2 Authoritative Backend (`FastAPI`)
- **Manifest:** [`backend/requirements.txt`](backend/requirements.txt)
- **App Entry:** [`backend/app/main.py`](backend/app/main.py)
- **Modules:**
  - `core/`: Config (`config.py`), Security (`security.py`), Rate Limiting (`rate_limit.py`), Logging (`logging.py`), Middleware (`middleware.py`)
  - `api/v1/`: Health (`health.py`), AI Validation (`ai.py`), Admin Operations (`admin.py`), Dependencies (`deps.py`)
  - `services/`: Audit Service (`audit_service.py`), Moderation Service (`moderation_service.py`), AI Engine (`gemini_service.py`)
- **Virtual Environment:** `backend/venv/`
- **Test Suite:** `backend/tests/test_api_suite.py` (13 pytest test cases)
- **Deployment Manifests:** `backend/Dockerfile`, `backend/docker-compose.yml`, `backend/fly.toml`

### 1.3 Local-Only Admin Console (`React 19 / Vite 8`)
- **Manifest:** [`admin_panel/package.json`](ADMIN/package.json)
- **Lockfile:** [`admin_panel/package-lock.json`](ADMIN/package-lock.json)
- **Bundler Config:** [`admin_panel/vite.config.ts`](ADMIN/vite.config.ts) (Configured for loopback `127.0.0.1:60135`)
- **TypeScript Configs:** `tsconfig.json`, `tsconfig.app.json`, `tsconfig.node.json`
- **Source Code (`admin_panel/src/`):**
  - `components/`: AdminAuthGuard, AdminSidebar, AdminHeader, MetricsCard
  - `pages/`: Dashboard, UserManagement, ModerationQueue, AuditLogs, SystemHealth
  - `lib/`: supabase client singleton
- **Build Output:** `admin_panel/dist/`

### 1.4 Database & Infrastructure (`Supabase PostgreSQL`)
- **Schema & Policies:** [`supabase/schema.sql`](DATABASE/SCHEMA/schema.sql)
  - Normalized relational tables: `profiles`, `startups`, `validations`, `hypotheses`, `feedback`, `evidence_items`, `votes`, `comments`, `conversations`, `conversation_members`, `messages`, `connection_requests`, `notifications`, `reports`, `admin_audit_logs`, `privacy_requests`, `user_reputations`, `validation_scores`.
  - Object-level RLS policies on all exposed tables.
  - Append-only WORM policy on `admin_audit_logs`.

### 1.5 Product Specifications & Architecture (`DOC/`)
- 66 comprehensive specification documents covering PRDs, user psychology, threat models, DPDP compliance, release rules, design systems, and frontend/backend architectures.

### 1.6 CI/CD & Security Workflows (`.github/workflows/`)
- `ci.yml`: Multi-job matrix testing Flutter (analyzer + tests), FastAPI (pytest), and React Admin (`npm run build`).
- `security.yml`: Gitleaks secret scanning and CodeQL SAST scanning.
