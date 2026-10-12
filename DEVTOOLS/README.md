# Truthprenuer Developer Tooling (`DEVTOOLS/`)

## 1. Overview
Automated operational scripts, testing pipelines, and security auditing tools for Truthprenuer.

## 2. Directory Contents
- **`DEVTOOLS/TESTING/run_all_tests.sh`**: One-command runner executing Flutter tests (64 tests), Backend Pytest suite (13 tests), and Admin Panel TypeScript build verification.
- **`DEVTOOLS/SECURITY_SCANNING/run_security_scan.sh`**: Scans network bindings to ensure Admin Console never binds to `0.0.0.0`, audits for secrets, and checks dependencies.
- **`DEVTOOLS/DEVELOPMENT/setup_dev_env.sh`**: One-command developer bootstrap installing Flutter pub packages, Python virtualenv dependencies, and Admin panel npm dependencies.
- **`DEVTOOLS/SCRIPTS/build_flutter_web.sh`**: Cloudflare Pages web distribution compilation script.
- **`DEVTOOLS/SCRIPTS/start_admin_60135.sh`**: Local admin panel launcher on `http://127.0.0.1:60135`.
