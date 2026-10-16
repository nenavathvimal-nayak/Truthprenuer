#!/usr/bin/env bash
# ==============================================================================
# TRUTHPRENUER DATABASE MIGRATION RUNNER
# Idempotent sequential executor for PostgreSQL schema migrations
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
MIGRATIONS_DIR="${DB_DIR}/MIGRATIONS"

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-truthprenuer}"
DB_USER="${DB_USER:-postgres}"
DB_PASSWORD="${DB_PASSWORD:-postgrespassword}"

DATABASE_URL="${DATABASE_URL:-postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}}"

echo "=================================================================="
echo "  TRUTHPRENUER DATABASE MIGRATION RUNNER"
echo "=================================================================="
echo "Target Database: ${DB_NAME} on ${DB_HOST}:${DB_PORT}"
echo "Migrations Directory: ${MIGRATIONS_DIR}"

# Check for psql or python runner
if command -v psql >/dev/null 2>&1; then
    echo "Found psql client. Initializing migration registry..."
    export PGPASSWORD="${DB_PASSWORD}"
    
    # 1. Ensure migrations tracking table exists
    psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" -v ON_ERROR_STOP=1 <<-EOSQL
        CREATE TABLE IF NOT EXISTS public._schema_migrations (
            version VARCHAR(255) PRIMARY KEY,
            applied_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
        );
EOSQL

    # 2. Iterate and apply migrations
    for migration_file in $(ls "${MIGRATIONS_DIR}"/*.sql | sort); do
        version="$(basename "${migration_file}")"
        is_applied=$(psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" -t -A -c "SELECT COUNT(*) FROM public._schema_migrations WHERE version = '${version}';")
        
        if [ "${is_applied}" -eq "0" ]; then
            echo "Applying migration: ${version}..."
            psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" -v ON_ERROR_STOP=1 -f "${migration_file}"
            psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d "${DB_NAME}" -c "INSERT INTO public._schema_migrations (version) VALUES ('${version}');"
            echo "  [SUCCESS] ${version} applied."
        else
            echo "  [SKIP] ${version} already applied."
        fi
    done
    echo "=================================================================="
    echo "  ALL MIGRATIONS SYNCHRONIZED SUCCESSFULLY"
    echo "=================================================================="
else
    echo "psql not detected locally. Using Python migration runner..."
    python3 "${SCRIPT_DIR}/run_migrations.py"
fi
