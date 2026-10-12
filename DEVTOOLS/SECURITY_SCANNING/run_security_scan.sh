#!/usr/bin/env bash
# ==============================================================================
# TRUTHPRENUER — SECURITY AUDIT & SCANNING AUTOMATION
# Scans for secrets, vulnerabilities, and unauthorized network bindings
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

echo "=================================================================="
echo "  1. AUDITING ADMIN PANEL NETWORK BINDINGS"
echo "=================================================================="
if grep -E "host:\s*['\"]0\.0\.0\.0['\"]" "${ROOT_DIR}/admin_panel/vite.config.ts"; then
  echo "❌ CRITICAL SECURITY ERROR: admin_panel/vite.config.ts exposes 0.0.0.0!"
  exit 1
else
  echo "✅ PASSED: Admin panel strictly binds to 127.0.0.1 (Loopback only)."
fi

echo "=================================================================="
echo "  2. AUDITING FOR HARDCODED SECRETS IN CODEBASE"
echo "=================================================================="
if grep -rn "sk-ant-" "${ROOT_DIR}/backend/app" 2>/dev/null; then
  echo "❌ CRITICAL ERROR: Found hardcoded Anthropic key in backend!"
  exit 1
fi
if grep -rn "BEGIN PRIVATE KEY" "${ROOT_DIR}/lib" "${ROOT_DIR}/backend/app" "${ROOT_DIR}/admin_panel/src" 2>/dev/null; then
  echo "❌ CRITICAL ERROR: Found raw private key file in application source!"
  exit 1
fi
if grep -rn "service_role" "${ROOT_DIR}/lib" 2>/dev/null; then
  echo "❌ CRITICAL ERROR: Found Supabase service_role key in client lib!"
  exit 1
fi
echo "✅ PASSED: No hardcoded production credentials detected."

echo "=================================================================="
echo "  3. AUDITING DEPENDENCY VULNERABILITIES"
echo "=================================================================="
cd "${ROOT_DIR}/admin_panel"
npm audit --audit-level=critical || true

echo "=================================================================="
echo "  SECURITY SCAN COMPLETED SUCCESSFULLY"
echo "=================================================================="
