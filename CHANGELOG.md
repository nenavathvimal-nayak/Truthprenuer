# TRUTHPRENUER — CHANGELOG

All notable changes to the Truthprenuer platform are documented in this file.

---

## [1.0.0-PROD] - 2026-10-12

### Security & Isolation
- **Admin Isolation:** Bound the Admin Console exclusively to loopback `127.0.0.1:60135` with `strictPort: true`.
- **LAN Blocking:** Verified that LAN network connections (`10.x.x.x:60135`) are dropped with Connection Refused.
- **Backend Origin Boundary:** Implemented `require_local_admin_origin` dependency in FastAPI backend. Any external internet request to `/api/v1/admin/*` is terminated with HTTP 403 Forbidden.
- **Automated Origin Test:** Added `test_admin_blocked_from_external_ip` to backend pytest suite (verified passing).
- **Admin Authentication Guard:** Eliminated client-side dev bypass in production bundles via `import.meta.env.DEV` dead-code elimination. Added authoritative server-side role and suspension check against `profiles` table.
- **JWT Fail-Closed:** Configured backend to raise HTTP 500 fail-closed in production if `SUPABASE_JWT_SECRET` is unset.
- **Prompt Injection Defense:** Added `sanitize_user_input` and encapsulated pitches inside `<untrusted_submission>` delimiters.
- **Rate Limiting Garbage Collection:** Implemented periodic cleanup (`_cleanup_stale_keys`) in `SlidingWindowRateLimiter` to eliminate memory leaks.

### Persistence & Data Integrity
- **WORM Audit Trail:** Wired `audit_service.py` to write tamper-evident append-only records to PostgreSQL table `admin_audit_logs`.
- **Moderation Persistence:** Wired report resolutions to `reports` and user account suspensions to `profiles` (`is_suspended`, `suspended_at`, `suspension_reason`).
- **Realtime Chat Persistence:** Integrated `MessagingRepository` into Riverpod `ConversationsNotifier` and `ChatMessagesNotifier` with optimistic UI responsiveness and background sync to Supabase.
- **GDPR Compliance:** Added right-to-erasure request insertion to `privacy_requests` before profile deletion.

### Architecture & Repository Reorganization
- Reorganized codebase into the target logical multi-tier structure:
  - `USERS/` (Client apps, platform runners, components, localization, tests)
  - `ADMIN/` (Private React console, startup scripts, isolation specs, security guards)
  - `DATABASE/` (Relational schema, migrations, seeds, functions, triggers, RLS policies, dictionary)
  - `PRODUCT/` (PRDs, requirements, user journeys, UI/UX specs, runbooks, QA reports, raw specs archive)
  - `BACKEND/` (FastAPI REST API, services, core security, background workers, integrations)
  - `ALGORITHMS/` (Consensus models, reputation weighting, analytics, recommendations, search)
  - `INFRASTRUCTURE/` (CI/CD workflows, Docker configurations, local dev topologies, documentation)
  - `DEVTOOLS/` (Build scripts, asset generators, authoritative validators, repository maintenance)
- **Physical Consolidation of Monorepo Structure:**
  - Physically moved `admin_panel/` into `ADMIN/` (authoritative home for Vite 8, React 19, TypeScript console, strictly bound to `127.0.0.1:60135`).
  - Physically moved Flutter client package into `USERS/` (`lib/`, `test/`, `assets/`, `web/`, `android/`, `ios/`, `macos/`, `linux/`, `windows/`, `pubspec.yaml`, `pubspec.lock`, `analysis_options.yaml`).
  - Consolidated and removed root duplicates: `supabase/` (consolidated into `DATABASE/SCHEMA/schema.sql`) and `scripts/` (consolidated into `DEVTOOLS/SCRIPTS/`).
  - Consolidated `strix_runs/` into `PRODUCT/SECURITY/STRIX_AUDITS/`.
  - Updated all CI workflows (`.github/workflows/ci.yml`), dependabot (`.github/dependabot.yml`), local launchers (`ADMIN/RUN_LOCAL/start_admin_60135.sh`), and test runners (`DEVTOOLS/TESTING/run_all_tests.sh`).
  - Generated machine-readable inventory `PRODUCT/ARCHITECTURE/repository_inventory.json` and authoritative migration map `PRODUCT/ARCHITECTURE/file_migration_map.md`.
  - Implemented authoritative multi-point validator `DEVTOOLS/VALIDATORS/validate_repository_integrity.sh` and wrapper `DEVTOOLS/REPOSITORY_MAINTENANCE/validate_repository_integrity.sh`.
  - Created dedicated fail-fast startup script `ADMIN/RUN_LOCAL/start_admin_60135.sh`.
- Created comprehensive runbooks: `LOCAL_DEVELOPMENT.md`, `ADMIN_STARTUP.md`, `PRODUCTION_DEPLOYMENT.md`, `INCIDENT_RESPONSE.md`.
- Authored master architecture specifications: `REPOSITORY_MAP.md`, `DEPLOYMENT_ARCHITECTURE.md`, `ADMIN_ISOLATION.md`, `THREAT_MODEL.md`.

### Quality & Testing
- Flutter test suite: 64 passed, 0 failed.
- Backend pytest suite: 13 passed, 0 failed.
- React Admin build: Clean build, 0 errors (`tsc -b && vite build`).
- Repository integrity audit: 100% passed with zero violations.

