#!/usr/bin/env bash
# ==============================================================================
# TRUTHPRENUER LOCAL INFRASTRUCTURE ORCHESTRATOR
# Launches PostgreSQL, Redis, Backend, and applies database migrations
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${SCRIPT_DIR}/docker-compose.local.yml"

echo "=================================================================="
echo "  TRUTHPRENUER LOCAL INFRASTRUCTURE ORCHESTRATOR"
echo "=================================================================="

if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: Docker CLI is required but not installed." >&2
    exit 1
fi

if [ "${1:-}" == "--check-only" ]; then
    echo "Validating docker compose syntax..."
    docker compose -f "${COMPOSE_FILE}" config
    echo "Docker Compose syntax valid."
    exit 0
fi

echo "Launching local multi-service container stack..."
docker compose -f "${COMPOSE_FILE}" up -d

echo "Waiting for PostgreSQL and Redis to be healthy..."
docker compose -f "${COMPOSE_FILE}" ps

echo ""
echo "=================================================================="
echo "  LOCAL INFRASTRUCTURE READY"
echo "  PostgreSQL : localhost:5432 (truthprenuer)"
echo "  Redis      : localhost:6379"
echo "  Backend    : http://localhost:8000"
echo "=================================================================="
