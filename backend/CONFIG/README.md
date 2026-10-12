# Truthprenuer Backend — Configuration Management (`BACKEND/CONFIG/`)

## Responsibility
Manages runtime configuration, environment parsing, and dependency declarations for the FastAPI service.
- [`.env.example`](../.env.example): Sanitized environment template.
- [`requirements.txt`](../requirements.txt): Pinned Python package dependencies.
- [`core/config.py`](../app/core/config.py): Pydantic Settings model with strict CORS and fail-closed validation.
