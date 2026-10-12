# TRUTHPRENUER — Production-Ready Startup Validation Platform

[![Truthprenuer CI](https://github.com/Truthprenuer/Truthprenuer/actions/workflows/ci.yml/badge.svg)](https://github.com/Truthprenuer/Truthprenuer/actions/workflows/ci.yml)
[![Security Scan](https://github.com/Truthprenuer/Truthprenuer/actions/workflows/security.yml/badge.svg)](https://github.com/Truthprenuer/Truthprenuer/actions/workflows/security.yml)
[![License: Proprietary](https://img.shields.io/badge/License-Proprietary-blue.svg)](LICENSE)

Truthprenuer is an enterprise startup hypothesis validation, feedback intelligence, and credibility platform. It enables founders to pressure-test product ideas with verified operators, collect tamper-evident validation metrics, and connect with investors.

---

## 1. Architecture Overview

Truthprenuer is engineered with strict separation between **Public User Applications** and the **Private Localhost Admin Console**:

- **Public Applications (`USERS/`):**
  - **Flutter Universal App:** Web ([Cloudflare Pages](https://truthprenuer.pages.dev)), iOS, Android, and Desktop.
  - **FastAPI Gateway Backend:** Python 3.11 service with rate-limiting, JWT authentication, and prompt injection defense.
- **Private Admin Console (`ADMIN/`):**
  - **React 19 / Vite 8:** Dedicated administrative tool binding strictly to `http://127.0.0.1:60135`.
  - **Zero Public Exposure:** Blocked from LAN and internet ingress; backend admin routes reject non-loopback calls with HTTP 403.
- **Authoritative Database (`DATABASE/`):**
  - **Supabase PostgreSQL:** 18 relational tables with Row Level Security (RLS) and immutable WORM audit logs (`admin_audit_logs`).
- **Product Architecture & Runbooks (`PRODUCT/`):**
  - Comprehensive PRDs, design systems, threat models, and operational runbooks.

---

## 2. Quick Start

### 2.1 Starting User Applications (Local)
```bash
# Install Flutter dependencies
flutter pub get

# Launch Flutter client (Web port 8080 or native simulator)
flutter run -d chrome --web-port=8080
```

### 2.2 Starting Authoritative Backend (Local)
```bash
cd backend
source venv/bin/activate
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

### 2.3 Starting Private Admin Console (Localhost 60135)
```bash
# Launch the private admin server bound strictly to loopback 127.0.0.1:60135
./ADMIN/RUN_LOCAL/start_admin_60135.sh

# Open in browser:
# http://127.0.0.1:60135
```

---

## 3. Automated Test Verification

Truthprenuer includes comprehensive automated test suites across all tiers:

```bash
# Run all tests across Flutter, Backend, and Admin
./DEVTOOLS/TESTING/run_all_tests.sh
```

| Component | Test Suite | Current Status |
| :--- | :--- | :--- |
| **Flutter Universal App** | `flutter test` | **64 / 64 Passed** |
| **FastAPI Backend** | `pytest backend/tests/ -v` | **13 / 13 Passed** |
| **Admin Console** | `tsc -b && vite build` | **0 Errors (Clean Build)** |

---

## 4. Documentation & Operational Runbooks

- [Repository Map](PRODUCT/ARCHITECTURE/REPOSITORY_MAP.md)
- [Deployment Architecture](PRODUCT/ARCHITECTURE/DEPLOYMENT_ARCHITECTURE.md)
- [Admin Isolation Specification](PRODUCT/SECURITY/ADMIN_ISOLATION.md)
- [Threat Model](PRODUCT/SECURITY/THREAT_MODEL.md)
- [Local Development Runbook](PRODUCT/RUNBOOKS/LOCAL_DEVELOPMENT.md)
- [Admin Startup Runbook](PRODUCT/RUNBOOKS/ADMIN_STARTUP.md)
- [Production Deployment Runbook](PRODUCT/RUNBOOKS/PRODUCTION_DEPLOYMENT.md)
- [Incident Response Runbook](PRODUCT/RUNBOOKS/INCIDENT_RESPONSE.md)
- [Final Verification Report](PRODUCT/QA_REPORTS/FINAL_VERIFICATION_REPORT.md)
