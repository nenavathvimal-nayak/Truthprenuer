#!/usr/bin/env bash
# ==============================================================================
# TRUTHPRENUER — DEVELOPER ENVIRONMENT INITIALIZATION
# Bootstraps Flutter, Python virtualenv, and Node dependencies
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

echo "==> 1. Setting up Flutter dependencies..."
cd "${ROOT_DIR}"
flutter pub get

echo "==> 2. Setting up Backend Python virtualenv..."
cd "${ROOT_DIR}/backend"
if [ ! -d "venv" ]; then
  python3 -m venv venv
fi
source venv/bin/activate
pip install -r requirements.txt

echo "==> 3. Setting up Admin Panel Node modules..."
cd "${ROOT_DIR}/admin_panel"
npm install

echo "==> Development environment ready!"
