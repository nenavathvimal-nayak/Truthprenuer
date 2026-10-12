# TRUTHPRENUER — REPOSITORY ARCHITECTURE & MODULE MAP

**Authoritative Architecture Specification**  
**Classification:** Enterprise System Map  

---

## 1. Logical-to-Physical Structure

Truthprenuer adheres to the master multi-tier enterprise structure:

```text
Truthprenuer/
├── USERS/              # Public User Applications, APIs & Infrastructure
│   ├── WEB/            # Flutter Web Embedding & Cloudflare Build Setup
│   ├── ANDROID/        # Flutter Android Native Wrapper & Gradle Config
│   ├── IOS/            # Flutter iOS Xcode Workspace & Podfile
│   ├── DESKTOP/        # macOS, Linux, Windows Desktop Embeddings
│   ├── BACKEND/        # FastAPI Application, Services & Test Suite
│   ├── SHARED/         # Shared Riverpod State, UI Components, Design System
│   ├── ALGORITHMS/     # AI Pitch Extraction, Validation Scoring & Counter-Metrics
│   ├── INFRASTRUCTURE/ # Docker, Compose, and Fly.io Container Packages
│   └── DOCUMENTATION/  # Public API Integration & Developer Guides
│
├── ADMIN/              # Private Administrative Console (Localhost-Only)
│   ├── APP/            # Vite + React Admin Root Application
│   ├── FRONTEND/       # Admin Dashboard, Moderation Queue, User Management
│   ├── BACKEND/        # Administrative Endpoints (/api/v1/admin/*)
│   ├── AUTH/           # AdminAuthGuard, Dev Bypass Gate
│   ├── AUTHORIZATION/  # Server-Side RBAC & require_local_admin_origin Loopback Guard
│   ├── AUDIT_LOGS/     # Append-Only WORM Database Audit Logging Service
│   ├── CONFIG/         # Bundler Host (127.0.0.1) & Port (60135) Strict Config
│   ├── SECURITY/       # Isolation Boundary & Hardening Specifications
│   ├── TESTS/          # Admin Build & Privileged Endpoint Test Suites
│   ├── SCRIPTS/        # Admin Utilities
│   ├── RUN_LOCAL/      # Dedicated start_admin_60135.sh Fail-Fast Script
│   └── DOCUMENTATION/  # Administrator Manual & Operational Runbooks
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
├── PRODUCT/            # Product Governance, PRDs, & Technical Runbooks
│   ├── PRD/            # Master Product Requirements & Feature Catalogue
│   ├── REQUIREMENTS/   # Legal, Terms, DPDP, and GDPR Compliance Standards
│   ├── USER_JOURNEYS/  # Personas, User Psychology, & Information Architecture
│   ├── UI_UX/          # Design Tokens, Typography, & Screen Inventories
│   ├── DESIGN_SYSTEM/  # Handoff Specs, Component Tokens, & Audit Matrix
│   ├── ARCHITECTURE/   # REPOSITORY_MAP.md, DEPLOYMENT_ARCHITECTURE.md
│   ├── SECURITY/       # ADMIN_ISOLATION.md, THREAT_MODEL.md
│   ├── QA_REPORTS/     # FINAL_VERIFICATION_REPORT.md & Test Evidence
│   ├── RELEASES/       # Staging & Production Deployment Gate Criteria
│   ├── ROADMAP/        # Milestone Roadmap & Sprint Targets
│   └── RUNBOOKS/       # LOCAL_DEVELOPMENT.md, ADMIN_STARTUP.md, INCIDENT_RESPONSE.md
│
├── DEVTOOLS/           # Engineering Automation, CI/CD, & Scanners
│   ├── SCRIPTS/        # Web Compilation & Port 60135 Launchers
│   ├── DEVELOPMENT/    # Local Service Orchestration
│   ├── TESTING/        # Test Runners across Flutter, Python, and Vite
│   └── SECURITY_SCANNING/ # Gitleaks & SAST CodeQL Orchestrators
│
├── .github/workflows/  # Automated Multi-Tier CI & Security Workflows
├── README.md           # Master Project Overview
├── SECURITY.md         # Vulnerability Disclosure & Threat Policies
├── CONTRIBUTING.md     # Engineering Standards & PR Guidelines
└── CHANGELOG.md        # Full Audit & Hardening Changelog
```

---

## 2. Framework Preservation & Path Continuity

To maintain seamless compatibility with framework package managers and build systems:
1. **Flutter Root:** `pubspec.yaml` remains at the root level, referencing `lib/`, `test/`, and platform folders (`web/`, `android/`, `ios/`).
2. **FastAPI Backend:** Located in `backend/` with `requirements.txt` and its own isolated virtual environment `backend/venv/`.
3. **React 19 Admin Panel:** Located in `admin_panel/` with `package.json` and strict loopback configuration for `127.0.0.1:60135`.
4. **Logical Access:** The target directories (`USERS/`, `ADMIN/`, `DATABASE/`, `PRODUCT/`, `DEVTOOLS/`) provide structured separation, operational runbooks, and build automation.
