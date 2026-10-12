# Truthprenuer Infrastructure & DevSecOps (`INFRASTRUCTURE/`)

## 1. Overview
The `INFRASTRUCTURE/` module defines the cloud topology, containerization, CI/CD pipelines, edge routing, and monitoring architecture for Truthprenuer.

## 2. Infrastructure Components

| Subdirectory | Scope | Target Technologies |
| :--- | :--- | :--- |
| [`INFRASTRUCTURE/DEPLOYMENT/`](file:///Volumes/NAYAK/taeed_flutter_source/INFRASTRUCTURE/DEPLOYMENT/) | Multi-tier containerization & web hosting | Docker, Cloudflare Pages, Fly.io / Cloud Run |
| [`INFRASTRUCTURE/CI_CD/`](file:///Volumes/NAYAK/taeed_flutter_source/INFRASTRUCTURE/CI_CD/) | Continuous integration & automated testing | GitHub Actions (`.github/workflows/ci.yml`) |
| [`INFRASTRUCTURE/MONITORING/`](file:///Volumes/NAYAK/taeed_flutter_source/INFRASTRUCTURE/MONITORING/) | Telemetry, uptime, and liveness endpoints | Prometheus, FastAPI `/health/liveness`, Sentry |
| [`INFRASTRUCTURE/LOCAL_DEVELOPMENT/`](file:///Volumes/NAYAK/taeed_flutter_source/INFRASTRUCTURE/LOCAL_DEVELOPMENT/) | Local multi-tier developer orchestration | Docker Compose, Local Loopback `127.0.0.1:60135` |
| [`INFRASTRUCTURE/DOCUMENTATION/`](file:///Volumes/NAYAK/taeed_flutter_source/INFRASTRUCTURE/DOCUMENTATION/) | SLA specifications, cost optimization & threat posture | ₹0 baseline startup tier architecture |

## 3. Strict Boundary Rules
- **Public User Web Client:** Hosted on Cloudflare Pages (`https://truthprenuer.pages.dev`).
- **Private Admin Console:** Strictly isolated to local loopback (`http://127.0.0.1:60135`). Never exposed to public DNS or edge proxies.
- **Backend API:** Containerized non-root service (`UID 10001`) with automatic health checks and rate-limiting.
