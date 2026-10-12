# Truthprenuer Local Development Infrastructure (`INFRASTRUCTURE/LOCAL_DEVELOPMENT/`)

## 1. Local Infrastructure Services
To run the full stack locally without relying on live cloud connections during offline testing:
- **Mock PostgreSQL & Redis:** Run `docker-compose -f INFRASTRUCTURE/LOCAL_DEVELOPMENT/docker-compose.local.yml up -d`
- **Backend Service:** Run `cd backend && venv/bin/uvicorn app.main:app --host 127.0.0.1 --port 8000`
- **Admin Console:** Run `./ADMIN/RUN_LOCAL/start_admin_60135.sh` (Strictly bound to `127.0.0.1:60135`)
- **Client Application:** Run `flutter run -d chrome` or connected mobile device
