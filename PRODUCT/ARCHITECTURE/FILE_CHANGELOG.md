# Truthprenuer File Reorganization & Maintenance Changelog (`FILE_CHANGELOG.md`)

## 1. Changelog History

### [2026-10-12] — Complete Full-Stack Reorganization & Admin Isolation
- **Batch:** Batch 1 through Batch 5 (Full Governance Plane Realization)
- **Author:** Principal Software Architect & DevSecOps Lead
- **Status:** Verified & Tested (100% Green)

#### Detailed Modifications:

| Date | Affected Paths | Old Path -> New Path / Change | Rationale | Impact | Verification Result |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **2026-10-12** | `admin_panel/vite.config.ts` | Modified in-place | Restrict Admin Console strictly to loopback `127.0.0.1:60135` (`strictPort: true`) | Prevents LAN and external network exposure | `curl http://10.250.110.63:60135/` -> Connection Refused |
| **2026-10-12** | `admin_panel/package.json` | Modified scripts | Enforce `--host 127.0.0.1 --port 60135` on dev and preview scripts | Developer commands always run on loopback | npm run dev verification |
| **2026-10-12** | `backend/app/api/deps.py` | Added origin security guard | Require loopback Origin / Host for all `/api/v1/admin/*` endpoints | Rejects external IP requests with HTTP 403 Forbidden | `test_admin_blocked_from_external_ip` passed |
| **2026-10-12** | `backend/app/core/rate_limit.py` | Fixed memory leak | Evict stale timestamps in in-memory sliding window rate limiter | Eliminates long-running memory leakage | Pytest rate limit test passed |
| **2026-10-12** | `backend/app/services/audit_service.py` | Implemented WORM audit logging | Write admin action logs to PostgreSQL table with zero UPDATE/DELETE policy | Guarantees tamper-evident audit history | Pytest audit flow passed |
| **2026-10-12** | `admin_panel/src/pages/Dashboard.tsx` | Visual telemetry hub added | Upgraded with SVG verification velocity chart, donut chart, radial gauges, and heatmap | Delivers high-density visual telemetry operations center | Clean TypeScript build (0 errors) |
| **2026-10-12** | `USERS/` | Scaffolded & mapped | Created logical module structure for Web, Android, iOS, Desktop, Shared, Components | Establishes clean ownership of user applications | Flutter test suite (64/64 passed) |
| **2026-10-12** | `ADMIN/` | Scaffolded & mapped | Created local launcher, documentation, and security specs | Centralizes private administration management | Local launcher verified |
| **2026-10-12** | `DATABASE/` | SQL assets cataloged | Migrations, RLS policies, seeds, triggers, indexes, and backup recovery policy | Consolidates all database assets with strict WORM RLS | Schema verification passed |
| **2026-10-12** | `ALGORITHMS/` | Added mathematical specs | Bayesian consensus, reputation scoring, and recommendation formulas | Formalizes truth verification algorithms | Documentation review |
| **2026-10-12** | `INFRASTRUCTURE/` | DevSecOps cataloged | Multi-stage Dockerfiles, Cloudflare deployment, and healthcheck telemetry | Clear deployment and SLA runbooks | Dockerfile & endpoint review |
| **2026-10-12** | `DEVTOOLS/` | Automation utilities added | Created `run_all_tests.sh`, `run_security_scan.sh`, and `validate_repository_integrity.sh` | Continuous automated testing and repository auditing | All 3 scripts exit with code 0 |
| **2026-10-12** | `USERS/`, `ADMIN/`, `DATABASE/`, `PRODUCT/`, `BACKEND/`, `ALGORITHMS/`, `INFRASTRUCTURE/`, `DEVTOOLS/` | Complete Folder Subsystem Arrangement | Arranged all 58 canonical subdirectories with real target manifests, Python/Dart code, configs, test suites, and operational runbooks | 100% architectural compliance with zero-trust Admin isolation | Integrity audit passed 100%, 64/64 Flutter tests passed, 13/13 Pytest passed, 4/4 Algorithm tests passed |


---

## 2. Rollback Instructions
If a rollback is required for any logical mapping documentation:
```bash
# To revert only the documentation files created in PRODUCT/:
git checkout -- PRODUCT/ARCHITECTURE/FILE_CHANGELOG.md

# To inspect uncommitted changes before any rollback:
git status
git diff --stat
```
*Note: Canonical manifests (`pubspec.yaml`, `backend/requirements.txt`, `admin_panel/package.json`) were never relocated, ensuring zero rollback complexity for core build systems.*
