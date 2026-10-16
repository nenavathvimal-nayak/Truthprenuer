# Truthprenuer Infrastructure — Local Development Setup (`INFRASTRUCTURE/LOCAL_DEVELOPMENT/`)

## 1. Overview
Coordinates local development services across Flutter, FastAPI, Supabase, and the Admin Console.

## 2. Core Service Topology
| Service | Runtime | Local Address | Startup Command |
| :--- | :--- | :--- | :--- |
| **Flutter Web Client** | Dart / Chrome | `http://localhost:8080` | `flutter run -d chrome --web-port=8080` |
| **FastAPI Backend** | Python 3.11 / Uvicorn | `http://127.0.0.1:8000` | `cd backend && source venv/bin/activate && uvicorn app.main:app --port 8000` |
| **Private Admin Console** | Vite / React 19 | `http://127.0.0.1:60135` | `./ADMIN/RUN_LOCAL/start_admin_60135.sh` |
| **OAuth Callback Proxy** | Node.js HTTP | `http://127.0.0.1:3000` | `node DEVTOOLS/SCRIPTS/localhost_redirect.js` |

## 3. Docker Orchestration
Local containerized backend development is supported via:
- Containerfile: [`backend/Dockerfile`](../../backend/Dockerfile)
- Compose definition: [`backend/docker-compose.yml`](../../backend/docker-compose.yml)
