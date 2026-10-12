# TRUTHPRENUER — REPOSITORY REORGANIZATION & MIGRATION PLAN

**Plan Date:** 12 October 2026  
**Auditing Team:** Principal Architect, Full-Stack & DevSecOps Engineering  
**Target Logical Architecture:** `Truthprenuer/` structure (`USERS/`, `ADMIN/`, `DATABASE/`, `PRODUCT/`, `DEVTOOLS/`)  

---

## 1. Migration Goals & Invariants

1. **Zero Downtime / Zero Breakage:** Tooling (`flutter test`, `flutter build`, `pytest`, `npm run build`, `npm run dev`) must continue to execute reliably without path or import failure.
2. **Strict Admin Isolation:** Admin panel must bind strictly to `127.0.0.1:60135` and remain completely isolated from public deployment paths.
3. **Canonical Manifest Integrity:** Framework root files (`pubspec.yaml`, `pubspec.lock`, `package.json`, `requirements.txt`) must reside in locations compliant with their respective ecosystems (Flutter, Node.js, Python).
4. **Clean Separation of Concerns:**
   - User-facing applications and backend services under `USERS/`.
   - Private administrative tools, runbooks, and configurations under `ADMIN/`.
   - Relational schemas, migrations, policies, and test scripts under `DATABASE/`.
   - Master specifications, architecture documents, PRDs, and QA reports under `PRODUCT/`.
   - Developer tooling, automation scripts, and security scanning under `DEVTOOLS/`.

---

## 2. Logical-to-Physical Architecture Mapping

```text
Truthprenuer/ (Repository Root)
│
├── USERS/
│   ├── WEB/ ───────────────► Flutter Web embedding (web/) & web build configurations
│   ├── ANDROID/ ───────────► Flutter Android embedding (android/)
│   ├── IOS/ ───────────────► Flutter iOS embedding (ios/)
│   ├── DESKTOP/ ───────────► Flutter Desktop runners (macos/, linux/, windows/)
│   ├── BACKEND/ ───────────► FastAPI service (backend/app, backend/tests)
│   ├── SHARED/ ────────────► Core domain models, utils, design system (lib/)
│   ├── ALGORITHMS/ ────────► AI Validation & scoring engines (lib/models, backend/app/services)
│   ├── INFRASTRUCTURE/ ────► Container definitions (backend/Dockerfile, docker-compose.yml)
│   └── DOCUMENTATION/ ─────► Public developer guides and integration notes
│
├── ADMIN/
│   ├── APP/ ───────────────► Admin React entry point (admin_panel/src)
│   ├── FRONTEND/ ──────────► Admin UI pages & components (admin_panel/src/pages, components)
│   ├── BACKEND/ ───────────► Administrative API routes & dependencies (backend/app/api/v1/admin.py)
│   ├── AUTH/ ──────────────► Admin authentication guards (admin_panel/src/components/AdminAuthGuard.tsx)
│   ├── AUTHORIZATION/ ─────► Server-side RBAC & loopback boundary (backend/app/api/deps.py)
│   ├── AUDIT_LOGS/ ────────► Tamper-evident WORM logging service (backend/app/services/audit_service.py)
│   ├── CONFIG/ ────────────► Admin bundler & env config (admin_panel/vite.config.ts)
│   ├── SECURITY/ ──────────► Admin security documentation & isolation specs
│   ├── TESTS/ ─────────────► Admin tests (frontend builds & backend audit tests)
│   ├── SCRIPTS/ ───────────► Admin operational utilities
│   ├── RUN_LOCAL/ ─────────► Dedicated localhost startup script (binds 127.0.0.1:60135)
│   └── DOCUMENTATION/ ─────► Private administrator runbooks & threat models
│
├── DATABASE/
│   ├── SCHEMA/ ────────────► Production schema (supabase/schema.sql)
│   ├── MIGRATIONS/ ────────► Versioned schema migration files
│   ├── SEEDS/ ─────────────► Realistic development fixtures & seed data
│   ├── FUNCTIONS/ ─────────► Database stored procedures & validation calculations
│   ├── TRIGGERS/ ──────────► User creation & reputation update triggers
│   ├── POLICIES/ ──────────► Object-level Row Level Security (RLS) policies
│   ├── INDEXES/ ───────────► Performance & search optimization indexes
│   ├── BACKUPS/ ───────────► Disaster recovery & backup runbooks
│   ├── TESTS/ ─────────────► Schema integrity & RLS verification test suite
│   └── DOCUMENTATION/ ─────► Data dictionary, entity relationships, and DPDP registers
│
├── PRODUCT/
│   ├── PRD/ ───────────────► Master PRD & Feature Catalog (migrated from DOC/)
│   ├── REQUIREMENTS/ ──────► Business & compliance requirements (DPDP, GDPR)
│   ├── USER_JOURNEYS/ ─────► User flows, IA, and psychological personas
│   ├── UI_UX/ ─────────────► Design tokens, screen inventory, and layout specs
│   ├── DESIGN_SYSTEM/ ─────► Truthprenuer master spec & design audit
│   ├── ARCHITECTURE/ ──────► REPOSITORY_MAP.md, DEPLOYMENT_ARCHITECTURE.md
│   ├── SECURITY/ ──────────► ADMIN_ISOLATION.md, THREAT_MODEL.md
│   ├── QA_REPORTS/ ────────► FINAL_VERIFICATION_REPORT.md, test matrices
│   ├── RELEASES/ ──────────► Release criteria and deployment checklists
│   ├── ROADMAP/ ───────────► Product milestones and future iterations
│   └── RUNBOOKS/ ──────────► LOCAL_DEVELOPMENT.md, ADMIN_STARTUP.md, INCIDENT_RESPONSE.md
│
├── DEVTOOLS/
│   ├── SCRIPTS/ ───────────► Flutter web build & local launch automation
│   ├── DEVELOPMENT/ ───────► Tooling utilities and local orchestrations
│   ├── TESTING/ ───────────► Cross-platform test runners
│   └── SECURITY_SCANNING/ ─► SAST, secret auditing, and dependency check runners
│
├── .github/
│   └── workflows/ ─────────► CI/CD and automated security scanning pipelines
│
├── .gitignore
├── .env.example
├── README.md
├── SECURITY.md
├── CONTRIBUTING.md
└── CHANGELOG.md
```

---

## 3. Step-by-Step Execution Phases

### Phase 1: Establish Root Specifications & Audit Baseline (Current)
- Generate `AUDIT_REPORT.md`, `REPOSITORY_INVENTORY.md`, `SECURITY_FINDINGS.md`, `MIGRATION_PLAN.md`.
- Ensure all 64 Flutter tests and 13 backend tests pass without error.

### Phase 2: Configure Dedicated Admin Local Port `60135`
- Update `admin_panel/vite.config.ts` to bind strictly to host `127.0.0.1` and port `60135`.
- Update `admin_panel/package.json` scripts (`dev`, `preview`) to target `--host 127.0.0.1 --port 60135`.
- Update `backend/app/core/config.py` CORS to whitelist `http://127.0.0.1:60135` and `http://localhost:60135`.
- Create `ADMIN/RUN_LOCAL/start_admin_60135.sh` (with port conflict fail-fast check).
- Verify via curl that the admin panel responds exclusively on `127.0.0.1:60135`.

### Phase 3: Structure Logical Target Folders & Documentation Assets
- Create `DATABASE/` directories and organize schema, policies, triggers, and documentation.
- Create `PRODUCT/` directories and migrate/organize specifications from `DOC/` into `PRD/`, `REQUIREMENTS/`, `ARCHITECTURE/`, `SECURITY/`, `RUNBOOKS/`, and `QA_REPORTS/`.
- Create `DEVTOOLS/` directory and populate build and security scanning scripts.
- Create `USERS/` and `ADMIN/` structural mappings with authoritative `PRODUCT/ARCHITECTURE/REPOSITORY_MAP.md`.

### Phase 4: Full-Stack Verification & Operational Signoff
- Re-run all automated tests (`flutter test`, `pytest`, `npm run build`).
- Verify zero public network exposure for the admin panel.
- Produce `PRODUCT/QA_REPORTS/FINAL_VERIFICATION_REPORT.md`.
