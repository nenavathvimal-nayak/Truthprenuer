import sys
import os
import time
from typing import Optional
import pytest
import jwt
from fastapi.testclient import TestClient

# Ensure backend directory is in sys.path
backend_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if backend_dir not in sys.path:
    sys.path.insert(0, backend_dir)

from app.main import app
from app.core.config import settings

TEST_JWT_SECRET = "test-secret-key-1234567890123456"

# Ensure test suite runs with a deterministic verified JWT secret
settings.SUPABASE_JWT_SECRET = TEST_JWT_SECRET

@pytest.fixture
def client():
    """FastAPI TestClient fixture."""
    with TestClient(app) as test_client:
        yield test_client

def make_test_jwt(
    user_id: str = "test-user-uuid-1234",
    email: str = "user@truthprenuer.com",
    app_metadata_role: Optional[str] = None,
    user_metadata_role: Optional[str] = None,
    expires_in_seconds: int = 3600,
    signing_secret: Optional[str] = None
) -> str:
    """Helper to generate JWT tokens for test cases."""
    now = int(time.time())
    payload = {
        "sub": user_id,
        "email": email,
        "iat": now,
        "exp": now + expires_in_seconds,
        "app_metadata": {},
        "user_metadata": {}
    }
    if app_metadata_role:
        payload["app_metadata"]["role"] = app_metadata_role
    if user_metadata_role:
        payload["user_metadata"]["role"] = user_metadata_role

    secret = signing_secret if signing_secret is not None else (settings.SUPABASE_JWT_SECRET or TEST_JWT_SECRET)
    return jwt.encode(payload, secret, algorithm="HS256")
