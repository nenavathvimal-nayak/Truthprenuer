# TRUTHPRENUER — LOCAL DEVELOPMENT RUNBOOK

## 1. Prerequisites

- Flutter SDK 3.29.0+ (`flutter --version`)
- Python 3.11+ (`python3 --version`)
- Node.js 20+ & npm (`node -v`, `npm -v`)
- Git

---

## 2. Environment Setup

1. Copy example configuration files:
   ```bash
   cp .env.example .env
   cp backend/.env.example backend/.env
   cp admin_panel/.env.example admin_panel/.env
   ```

2. Supply real development keys in `.env` (Supabase URL, Anon Key, JWT Secret, Gemini API Key).

---

## 3. Starting the Public User Application (Local)

### Flutter Client (Web / Mobile / Desktop):
```bash
# Install dependencies
flutter pub get

# Run Web target on port 8080
flutter run -d chrome --web-port=8080

# Or run mobile target (Android / iOS simulator)
flutter run
```

---

## 4. Starting the Authoritative Backend API

```bash
cd backend

# Create & activate virtual environment (if not already created)
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Start FastAPI server on port 8000
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

---

## 5. Starting the Private Admin Console

```bash
# Execute the hardened local startup script
./ADMIN/RUN_LOCAL/start_admin_60135.sh
# Admin console is now accessible at http://127.0.0.1:60135
```

---

## 6. Running Local Test Suites

```bash
# 1. Run Flutter tests
flutter test

# 2. Run Backend tests
backend/venv/bin/pytest backend/tests/ -v

# 3. Build Admin Panel
cd admin_panel && npm run build
```
