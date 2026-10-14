#!/usr/bin/env bash
# ==============================================================================
# TRUTHPRENUER — REPOSITORY INTEGRITY & ARCHITECTURE VALIDATOR
# Continuous automated validation of directory architecture, boundaries, and secrets
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

FAILED=0

echo "=================================================================="
echo "  TRUTHPRENUER REPOSITORY INTEGRITY AUDIT"
echo "=================================================================="

# 1. Verify Top-Level Architectural Folders Exist
echo "--> 1. Verifying Core Architecture Directories..."
REQUIRED_DIRS=(
  "USERS"
  "ADMIN"
  "DATABASE"
  "PRODUCT"
  "BACKEND"
  "ALGORITHMS"
  "INFRASTRUCTURE"
  "DEVTOOLS"
  ".github/workflows"
)

for dir in "${REQUIRED_DIRS[@]}"; do
  if [ -d "${ROOT_DIR}/${dir}" ]; then
    echo "  [OK] Directory exists: ${dir}"
  else
    echo "  [ERROR] Missing architectural directory: ${dir}"
    FAILED=1
  fi
done

# 1b. Verify Subdirectory Architecture
echo "--> 1b. Verifying Architectural Subsystems..."
SUB_DIRS=(
  "USERS/WEB" "USERS/ANDROID" "USERS/IOS" "USERS/DESKTOP" "USERS/SHARED" "USERS/COMPONENTS" "USERS/ASSETS" "USERS/LOCALIZATION" "USERS/DOCUMENTATION"
  "ADMIN/APP" "ADMIN/FRONTEND" "ADMIN/BACKEND" "ADMIN/AUTH" "ADMIN/AUTHORIZATION" "ADMIN/SERVICES" "ADMIN/SECURITY" "ADMIN/AUDIT_LOGS" "ADMIN/CONFIG" "ADMIN/TESTS" "ADMIN/SCRIPTS" "ADMIN/RUN_LOCAL" "ADMIN/DOCUMENTATION"
  "DATABASE/SCHEMA" "DATABASE/MIGRATIONS" "DATABASE/SEEDS" "DATABASE/FUNCTIONS" "DATABASE/TRIGGERS" "DATABASE/POLICIES" "DATABASE/INDEXES" "DATABASE/TESTS" "DATABASE/BACKUPS" "DATABASE/DOCUMENTATION"
  "PRODUCT/PRD" "PRODUCT/REQUIREMENTS" "PRODUCT/USER_JOURNEYS" "PRODUCT/UI_UX" "PRODUCT/DESIGN_SYSTEM" "PRODUCT/ARCHITECTURE" "PRODUCT/SECURITY" "PRODUCT/QA_REPORTS" "PRODUCT/RELEASES" "PRODUCT/ROADMAP" "PRODUCT/RUNBOOKS"
  "ALGORITHMS/VALIDATION" "ALGORITHMS/RECOMMENDATIONS" "ALGORITHMS/SCORING" "ALGORITHMS/ANALYTICS" "ALGORITHMS/SEARCH" "ALGORITHMS/TESTS"
  "INFRASTRUCTURE/DEPLOYMENT" "INFRASTRUCTURE/CI_CD" "INFRASTRUCTURE/MONITORING" "INFRASTRUCTURE/LOCAL_DEVELOPMENT" "INFRASTRUCTURE/DOCUMENTATION"
  "DEVTOOLS/SCRIPTS" "DEVTOOLS/GENERATORS" "DEVTOOLS/VALIDATORS" "DEVTOOLS/REPOSITORY_MAINTENANCE"
)

for sdir in "${SUB_DIRS[@]}"; do
  if [ -d "${ROOT_DIR}/${sdir}" ]; then
    echo "  [OK] Subsystem verified: ${sdir}"
  else
    echo "  [ERROR] Missing subsystem directory: ${sdir}"
    FAILED=1
  fi
done

# 2. Verify Admin Panel Loopback Binding (Strictly 127.0.0.1:60135)
echo "--> 2. Verifying Admin Panel Network Boundary..."
if grep -E "host:\s*['\"]0\.0\.0\.0['\"]" "${ROOT_DIR}/admin_panel/vite.config.ts" >/dev/null 2>&1; then
  echo "  [ERROR] Security violation: admin_panel/vite.config.ts exposes 0.0.0.0!"
  FAILED=1
else
  echo "  [OK] Admin Panel strictly binds 127.0.0.1 (Loopback only)"
fi

if grep -q "port: 60135" "${ROOT_DIR}/admin_panel/vite.config.ts" >/dev/null 2>&1; then
  echo "  [OK] Admin Panel configured for port 60135"
else
  echo "  [ERROR] Admin Panel missing expected port 60135"
  FAILED=1
fi

# 3. Verify Framework-Required Root Manifests & Canonical Root Files
echo "--> 3. Verifying Package Manifests & Root Files..."
ROOT_FILES=(
  "USERS/pubspec.yaml"
  "backend/requirements.txt"
  "ADMIN/package.json"
  "README.md"
  "CONTRIBUTING.md"
  "SECURITY.md"
  "CHANGELOG.md"
  ".gitignore"
  ".env.example"
)

for rf in "${ROOT_FILES[@]}"; do
  if [ -f "${ROOT_DIR}/${rf}" ]; then
    echo "  [OK] Root file present: ${rf}"
  else
    echo "  [ERROR] Missing required root file: ${rf}"
    FAILED=1
  fi
done

# 4. Secret & Credential Hygiene Check
echo "--> 4. Scanning for Leaked Credentials..."
if grep -rn "sk-ant-" "${ROOT_DIR}/backend/app" 2>/dev/null; then
  echo "  [ERROR] Hardcoded Anthropic key found in backend!"
  FAILED=1
else
  echo "  [OK] No private Anthropic keys found in backend"
fi

if grep -rn "service_role" "${ROOT_DIR}/lib" 2>/dev/null; then
  echo "  [ERROR] Supabase service_role key found in public client code!"
  FAILED=1
else
  echo "  [OK] Client code contains no service-role credentials"
fi

# 5. Boundary Validation Check
echo "--> 5. Checking Architectural Import Boundaries..."
if python3 "${ROOT_DIR}/DEVTOOLS/VALIDATORS/validate_boundaries.py" >/dev/null 2>&1; then
  echo "  [OK] Zero forbidden cross-boundary imports detected"
else
  echo "  [ERROR] Boundary violation detected"
  FAILED=1
fi

# 6. Summary & Exit Code
echo "=================================================================="
if [ "${FAILED}" -eq 0 ]; then
  echo "  REPOSITORY INTEGRITY CHECK: 100% PASSED"
  echo "=================================================================="
  exit 0
else
  echo "  REPOSITORY INTEGRITY CHECK FAILED: Address issues above"
  echo "=================================================================="
  exit 1
fi
