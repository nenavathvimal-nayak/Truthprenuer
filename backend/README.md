# Truthprenuer Backend (FastAPI)

This backend serves two primary purposes for the MVP:
1. **Security Proxy:** Hides the `GEMINI_API_KEY` from the Flutter client to prevent quota hijacking.
2. **Admin Operations:** Uses the Supabase Service Role key to perform privileged operations (e.g., banning users) for the Admin Panel.

## Setup
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```
