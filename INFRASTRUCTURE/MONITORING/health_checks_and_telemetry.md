# Health Checks and Telemetry (`INFRASTRUCTURE/MONITORING/`)

## 1. Endpoints & Probes

| Probe Name | Route | HTTP Code | Purpose |
| :--- | :--- | :--- | :--- |
| **Liveness Probe** | `/health/liveness` | `200 OK` | Container orchestrator healthcheck confirming event loop is responsive |
| **Readiness Probe** | `/health/readiness` | `200 OK` | Confirms database connectivity & AI service initialization before traffic routing |
| **Admin Telemetry** | `/api/v1/admin/health` | `200 OK` | Privileged high-detail operational metrics for Admin Console dashboard |

## 2. Verification Commands
```bash
# Verify API liveness
curl -s http://127.0.0.1:8000/health/liveness
# Response: {"status":"alive","service":"Truthprenuer API"}

# Verify API readiness
curl -s http://127.0.0.1:8000/health/readiness
# Response: {"status":"ready","database":"connected"}
```
