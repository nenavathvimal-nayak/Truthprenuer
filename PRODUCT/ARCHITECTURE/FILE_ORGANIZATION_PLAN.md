# TRUTHPRENUER — FILE ORGANIZATION PLAN & TARGET ARCHITECTURE
## Continuous Maintenance Blueprint (Phase 2 & Phase 3)

**Date:** 12 October 2026  
**Architect:** Principal Software Architect & DevOps Engineer  
**Status:** Approved for Implementation  

---

## 1. Architectural Strategy & Target Structure

Truthprenuer combines a multiplatform client (Flutter), a high-throughput backend (FastAPI), a strictly local Admin Console (React/Vite), and a managed relational database (PostgreSQL/Supabase). 

To ensure clean code governance without breaking package managers or build systems, the repository adheres to a **Dual-Plane Architecture**:
1. **Toolchain Execution Plane (Canonical Roots):** Root-level framework paths (`pubspec.yaml`, `lib/`, `backend/`, `admin_panel/`, `test/`, `android/`, `ios/`, `web/`, `.github/`) preserved for seamless toolchain execution and zero CI breakage.
2. **Logical Governance Plane (Target Architecture):** High-level architectural modules (`USERS/`, `ADMIN/`, `DATABASE/`, `PRODUCT/`, `BACKEND/`, `ALGORITHMS/`, `INFRASTRUCTURE/`, `DEVTOOLS/`) governing ownership, module boundaries, interfaces, and specifications.

---

## 2. Directory Governance Plan

```
Truthprenuer/
│
├── USERS/                 # Public User Applications
│   ├── WEB/               # Web client architecture & Cloudflare Pages mapping
│   ├── ANDROID/           # Native Android configurations & manifests
│   ├── IOS/               # Native iOS project & capabilities
│   ├── DESKTOP/           # macOS, Windows, Linux desktop embeddings
│   ├── SHARED/            # Dart models, Riverpod state, offline caching
│   ├── COMPONENTS/        # Presentation widgets & design system UI components
│   ├── ASSETS/            # Images, icons, fonts, and animation assets
│   ├── LOCALIZATION/      # l10n configuration & translations
│   └── DOCUMENTATION/     # Public user & API guides
│
├── ADMIN/                 # Private Local Loopback Administration (127.0.0.1:60135)
│   ├── APP/               # Admin application root & entry point
│   ├── FRONTEND/          # React 19 / Vite 8 console UI & telemetry visuals
│   ├── BACKEND/           # Elevated administrative endpoints & RBAC
│   ├── AUTH/              # Admin authentication & session security
│   ├── AUTHORIZATION/     # Server-side role verification (Admin, Super_Admin)
│   ├── SERVICES/          # Moderation service & user suspension handlers
│   ├── SECURITY/          # Origin filtering & loopback enforcement
│   ├── AUDIT_LOGS/        # WORM append-only audit trail integration
│   ├── CONFIG/            # Local configuration & environment guards
│   ├── TESTS/             # Admin isolation regression suite
│   ├── SCRIPTS/           # start_admin_60135.sh
│   ├── RUN_LOCAL/         # Standalone launcher
│   └── DOCUMENTATION/     # Admin security architecture & runbooks
│
├── DATABASE/              # Relational Storage & Data Integrity
│   ├── SCHEMA/            # schema.sql (tables, constraints, foreign keys)
│   ├── MIGRATIONS/        # 001_initial_schema.sql
│   ├── SEEDS/             # seed_data.sql (development & test seeds)
│   ├── FUNCTIONS/         # stored_procedures.sql (reputation recalculation)
│   ├── TRIGGERS/          # audit_and_reputation_triggers.sql
│   ├── POLICIES/          # rls_policies.sql (Row-Level Security & WORM policies)
│   ├── INDEXES/           # performance_indexes.sql
│   ├── TESTS/             # test_db_schema.sql
│   ├── BACKUPS/           # backup_policy.md (RPO/RTO & disaster recovery)
│   └── DOCUMENTATION/     # DATABASE_DICTIONARY.md
│
├── PRODUCT/               # Product Requirements & Systems Architecture
│   ├── PRD/               # PRD_DOCUMENT.md
│   ├── REQUIREMENTS/      # REQUIREMENTS_SPECIFICATION.md
│   ├── USER_JOURNEYS/     # USER_JOURNEYS.md
│   ├── UI_UX/             # UI_UX_SPECIFICATION.md
│   ├── DESIGN_SYSTEM/     # DESIGN_SYSTEM_GUIDELINES.md
│   ├── ARCHITECTURE/      # REPOSITORY_INVENTORY, REPOSITORY_MAP, REPOSITORY_ARCHITECTURE
│   ├── SECURITY/          # ADMIN_ISOLATION, THREAT_MODEL
│   ├── QA_REPORTS/        # FINAL_VERIFICATION_REPORT, REPOSITORY_MAINTENANCE_REPORT
│   ├── RELEASES/          # RELEASE_CHECKLIST.md
│   ├── ROADMAP/           # ROADMAP.md
│   └── RUNBOOKS/          # LOCAL_DEVELOPMENT, ADMIN_STARTUP, PRODUCTION_DEPLOYMENT
│
├── BACKEND/               # Authoritative Backend Services
│   ├── API/               # FastAPI route controllers (v1 routes)
│   ├── SERVICES/          # Core business services (Audit, Moderation, Gemini AI)
│   ├── WORKERS/           # Async background tasks & event processors
│   ├── INTEGRATIONS/      # Third-party integrations (Supabase, Gemini)
│   ├── SHARED/            # Config, security, rate limiting, logging
│   └── TESTS/             # Pytest test suite (13/13 passing)
│
├── ALGORITHMS/            # Core Algorithms & Consensus Engine
│   ├── VALIDATION/        # Bayesian consensus verification algorithms
│   ├── RECOMMENDATIONS/   # Feed ranking & discovery algorithms
│   ├── SCORING/           # Dynamic validator reputation weighting
│   ├── ANALYTICS/         # Verification velocity & trend telemetry
│   ├── SEARCH/            # Fuzzy claim search & deduplication
│   └── TESTS/             # Algorithm unit & property tests
│
├── INFRASTRUCTURE/        # Cloud Deployment & DevSecOps
│   ├── DEPLOYMENT/        # Dockerfile, docker-compose, fly.toml, Cloudflare Pages
│   ├── CI_CD/             # CI workflows, GitHub Actions documentation
│   ├── MONITORING/        # Telemetry, health checks (/health/liveness), alerts
│   ├── LOCAL_DEVELOPMENT/ # Local dev containerization & proxy configuration
│   └── DOCUMENTATION/     # Cloud architecture, cost analysis & SLA specs
│
├── DEVTOOLS/              # Tooling & Maintenance Automation
│   ├── SCRIPTS/           # build_flutter_web.sh, start_admin_60135.sh
│   ├── GENERATORS/        # Seed & schema generation utilities
│   ├── VALIDATORS/        # Security scanner (run_security_scan.sh)
│   └── REPOSITORY_MAINTENANCE/ # validate_repository_integrity.sh
│
├── .github/workflows/     # CI/CD pipelines
├── README.md              # Project overview, quickstart & architecture
├── CONTRIBUTING.md        # Contribution & coding standards
├── SECURITY.md            # Security policy, threat model & vulnerability reporting
├── CHANGELOG.md           # SemVer changelog
├── .gitignore             # Strict gitignore excluding build caches, keys, venv
└── .env.example           # Environment template with safe placeholders
```

---

## 3. Organizational Risk Matrix & Decision Process

| Potential Risk | Impact | Mitigation Strategy |
| :--- | :--- | :--- |
| **Breaking `flutter test` or `flutter build`** | High | Preserve root `pubspec.yaml`, `lib/`, `test/`, and platform embedding directories (`android/`, `ios/`, `web/`). |
| **Breaking Python venv or Docker builds** | High | Preserve `backend/requirements.txt` and `backend/app/main.py`. |
| **Admin Panel Network Leak** | Critical | Lock `admin_panel/vite.config.ts` to `127.0.0.1:60135` (`strictPort: true`). Never bind `0.0.0.0`. |
| **Leaking Secrets in Repository** | Critical | Audit via `run_security_scan.sh`. Never commit `.env` or `.env.json`. Use `.env.example`. |
| **Divergent Documentation** | Medium | Single source of truth in `PRODUCT/` with cross-links. |

---

## 4. Phased Execution Roadmap

- **Batch 1 (Completed):** Directory scaffolding, inventory creation, architecture planning.
- **Batch 2 (In Progress):** Populate `ALGORITHMS/` and `INFRASTRUCTURE/` module manifests and specifications.
- **Batch 3:** Complete `USERS/` and `ADMIN/` submodules (`COMPONENTS/`, `ASSETS/`, `LOCALIZATION/`, `AUTH/`, `SERVICES/`).
- **Batch 4:** Create `DEVTOOLS/REPOSITORY_MAINTENANCE/validate_repository_integrity.sh`.
- **Batch 5:** Synchronize `PRODUCT/ARCHITECTURE/REPOSITORY_ARCHITECTURE.md`, `FILE_CHANGELOG.md`, and produce `PRODUCT/QA_REPORTS/REPOSITORY_MAINTENANCE_REPORT.md`.
- **Batch 6:** Execute full validation test suite (`run_all_tests.sh`) to confirm zero regressions.
