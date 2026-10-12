# Truthprenuer Authoritative Backend (`BACKEND/` / `backend/`)

## 1. Overview
The Truthprenuer backend is an asynchronous, high-throughput REST API built on **FastAPI 0.111.0** and **Python 3.11**. It provides authoritative business logic, AI hypothesis validation, WORM audit logging, and administrative operations.

## 2. Architectural Subsystem Mapping
| Architectural Domain | Codebase Location | Responsibility |
| :--- | :--- | :--- |
| **`BACKEND/API/`** | [`app/api/v1/`](app/api/v1/) | User and administrative REST endpoints (`ai.py`, `admin.py`, `moderation.py`) |
| **`BACKEND/SERVICES/`** | [`app/services/`](app/services/) | Domain services: `audit_service.py` (WORM auditing), `moderation_service.py` |
| **`BACKEND/WORKERS/`** | [`app/workers/`](app/workers/) | Asynchronous background tasks and scoring pipelines |
| **`BACKEND/INTEGRATIONS/`** | [`app/integrations/`](app/integrations/) | Supabase REST and Google Gemini AI client integrations |
| **`BACKEND/SHARED/`** | [`app/core/`](app/core/) | Core utilities, rate limiting (`rate_limit.py`), configuration (`config.py`) |
| **`BACKEND/CONFIG/`** | [`requirements.txt`](requirements.txt), [`.env.example`](.env.example) | Python environment and runtime settings |
| **`BACKEND/SECURITY/`** | [`app/core/security.py`](app/core/security.py), [`app/api/deps.py`](app/api/deps.py) | JWT authentication, peer socket loopback verification for admin routes |
| **`BACKEND/TESTS/`** | [`tests/`](tests/) | Comprehensive pytest suite covering security and API endpoints |

## 3. Local Development & Setup
```bash
# 1. Create virtual environment
python3 -m venv venv
source venv/bin/activate

# 2. Install dependencies
pip install -r requirements.txt

# 3. Start development server
uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload
```

## 4. Running Backend Tests
```bash
venv/bin/pytest tests/ -v
```
All 13 security and API tests pass with 100% success.
