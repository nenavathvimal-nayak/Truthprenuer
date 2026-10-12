#!/usr/bin/env bash
# Wrapper launcher invoking ADMIN/RUN_LOCAL/start_admin_60135.sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
exec "${ROOT_DIR}/ADMIN/RUN_LOCAL/start_admin_60135.sh" "$@"
