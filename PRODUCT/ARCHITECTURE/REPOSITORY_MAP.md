# TRUTHPRENUER — REPOSITORY ARCHITECTURE & MODULE MAP

**Authoritative Architecture Specification**  
**Classification:** Enterprise System Map  

---

## 1. Logical-to-Physical Structure

Truthprenuer adheres to the master multi-tier enterprise structure:

```text
Truthprenuer/ (Child Repository / Submodule: USERS/FLUTTER/taeed_flutter_source)
├── USERS/              # Flutter Multi-Platform Client & Platform Assets
│   ├── lib/            # Flutter core Dart application source (Riverpod, screens, widgets)
│   ├── test/           # Flutter unit & widget tests (64 passed)
│   ├── pubspec.yaml    # Flutter dependency manifest
│   ├── web/            # Flutter Web embedding & build configurations
│   ├── android/        # Android native embedding & Gradle files
│   ├── ios/            # iOS Xcode project, Podfile & bundle configurations
│   ├── macos/          # macOS desktop embedding
│   ├── linux/          # Linux desktop embedding
│   └── windows/        # Windows desktop embedding
│
├── ADMIN/              # Private Administrative Console (Localhost-Only 127.0.0.1:60135)
│   ├── src/            # React 19 source, components (AdminAuthGuard), pages
│   ├── package.json    # Vite 8 / React 19 dependencies & scripts
│   ├── vite.config.ts  # Strict loopback binding (127.0.0.1:60135, strictPort: true)
│   ├── dist/           # Local build output (excluded from public deployment)
│   └── RUN_LOCAL/      # Dedicated start_admin_60135.sh Fail-Fast Script
│
├── backend/            # FastAPI Backend Service & Test Suite
│   ├── app/            # Application core, config, security, and API endpoints
│   │   ├── api/        # API v1 routes & dependencies (deps.py)
│   │   ├── core/       # Security (security.py) & settings (config.py)
│   │   └── services/   # Business logic services
│   ├── tests/          # Pytest suite with authentication & isolation tests (17 passed)
│   ├── requirements.txt # Python dependencies
│   └── venv/           # Python 3.11 virtual environment
│
├── DATABASE/           # Relational Schema, Policies, & Migration Engine
│   ├── SCHEMA/         # Authoritative PostgreSQL Relational Schema (schema.sql)
│   ├── MIGRATIONS/     # Versioned Migration SQL Scripts
│   ├── SEEDS/          # Development Database Fixtures & Seed Data
│   ├── FUNCTIONS/      # PostgreSQL Stored Functions & Verification Procedures
│   ├── TRIGGERS/       # User Profile Creation & Score Update Triggers
│   ├── POLICIES/       # Comprehensive Row Level Security (RLS) Rules
│   ├── INDEXES/        # Performance & Query Optimization Indexes
│   ├── BACKUPS/        # Database Snapshot & Recovery Procedures
│   ├── TESTS/          # Schema Validation & RLS Policy Tests
│   └── DOCUMENTATION/  # Data Dictionary & DPDP / GDPR Compliance Registers
│
├── ALGORITHMS/         # Proprietary Algorithmic Engines & Domain Tests
│   ├── SCORING/        # Reputation, truth weighting & founder scores
│   ├── RECOMMENDATIONS/# Algorithmic matching & feed generation
│   ├── ANALYTICS/      # Platform analytics calculation
│   ├── SEARCH/         # Semantic & vector search queries
│   └── TESTS/          # Dedicated algorithm test suite (4 passed)
│
├── INFRASTRUCTURE/     # Deployment, Containerization & Local Dev
│   ├── DOCKER/         # Dockerfiles & container definitions
│   ├── LOCAL_DEVELOPMENT/ # Local dev orchestration
│   └── CI_CD/          # CI/CD guidance & configurations
│
├── PRODUCT/            # Product Governance, Architecture & Technical Runbooks
│   ├── ARCHITECTURE/   # REPOSITORY_MAP.md, DEPLOYMENT_ARCHITECTURE.md
│   ├── SECURITY/       # ADMIN_ISOLATION.md, STRIX_AUDITS_INSPECTION.md
│   ├── QA_REPORTS/     # REPOSITORY_MAINTENANCE_REPORT.md & Test Evidence
│   ├── PRD/            # Master Product Requirements & Feature Catalogue
│   └── RUNBOOKS/       # LOCAL_DEVELOPMENT.md, ADMIN_STARTUP.md, INCIDENT_RESPONSE.md
│
├── DEVTOOLS/           # Engineering Automation, Scripts & Scanners
│   ├── GENERATORS/     # Icon & asset generation tooling
│   ├── SCRIPTS/        # Maintenance & automation scripts
│   └── SECURITY_SCANNING/ # Security audit & check scripts
│
├── .github/workflows/  # Automated Multi-Tier CI Workflows
├── README.md           # Master Project Overview
├── SECURITY.md         # Vulnerability Disclosure & Threat Policies
├── CONTRIBUTING.md     # Engineering Standards & PR Guidelines
└── CHANGELOG.md        # Audit & Hardening Changelog
```

---

## 2. Framework Preservation & Path Continuity

To maintain seamless compatibility with framework package managers and build systems:
1. **Flutter Universal Client:** Located in `USERS/` with `USERS/pubspec.yaml`, `USERS/lib/`, `USERS/test/`, and platform folders (`USERS/WEB/`, `USERS/ANDROID/`, `USERS/IOS/`, `USERS/DESKTOP/`).
2. **FastAPI Backend:** Located in `backend/` with `requirements.txt` and its isolated virtual environment `backend/venv/`.
3. **React 19 Admin Panel:** Located in `ADMIN/` (with `admin_panel/` symlink alias) containing `package.json`, `vite.config.ts`, and strict loopback configuration for `127.0.0.1:60135`.
4. **Logical Subsystems:** Dedicated directories (`USERS/`, `ADMIN/`, `DATABASE/`, `ALGORITHMS/`, `PRODUCT/`, `DEVTOOLS/`) provide structured separation, operational runbooks, and build automation.
