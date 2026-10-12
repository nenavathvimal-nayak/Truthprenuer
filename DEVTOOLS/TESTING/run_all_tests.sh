#!/usr/bin/env bash
# ==============================================================================
# TRUTHPRENUER — COMPREHENSIVE TEST RUNNER
# Executes Flutter, Backend FastAPI, and Admin Panel tests
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

cd "${ROOT_DIR}"

echo "=================================================================="
echo "  1. RUNNING FLUTTER CLIENT TEST SUITE"
echo "=================================================================="
(cd USERS && flutter test)

echo "=================================================================="
echo "  2. RUNNING BACKEND PYTEST SUITE"
echo "=================================================================="
backend/venv/bin/pytest backend/tests/ -v

echo "=================================================================="
echo "  3. RUNNING ALGORITHM DOMAIN SUITE"
echo "=================================================================="
backend/venv/bin/pytest ALGORITHMS/TESTS/test_algorithms.py -v

echo "=================================================================="
echo "  4. RUNNING ADMIN PANEL TYPECHECK & BUILD"
echo "=================================================================="
cd ADMIN
npm run build
cd "${ROOT_DIR}"

echo "=================================================================="
echo "  ALL TESTS PASSED WITH ZERO ERRORS!"
echo "=================================================================="
