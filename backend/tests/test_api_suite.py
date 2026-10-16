import time
import pytest
from conftest import make_test_jwt

def test_root_endpoint(client):
    """Verify public root endpoint gives operational heartbeat without internal leaks."""
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "operational"
    assert "Truthprenuer" in data["service"]

def test_liveness_and_readiness(client):
    """Verify health probes."""
    live = client.get("/health/liveness")
    assert live.status_code == 200
    assert live.json()["status"] == "alive"

    ready = client.get("/health/readiness")
    assert ready.status_code == 200
    assert "status" in ready.json()

def test_security_headers_present(client):
    """Verify mandatory security headers on every response (Section 46)."""
    response = client.get("/")
    assert response.headers.get("X-Content-Type-Options") == "nosniff"
    assert response.headers.get("X-Frame-Options") == "DENY"
    assert "default-src 'self'" in response.headers.get("Content-Security-Policy", "")
    assert "max-age=" in response.headers.get("Strict-Transport-Security", "")
    assert response.headers.get("X-Request-ID") is not None

def test_unauthenticated_requests_blocked(client):
    """Verify endpoints requiring authentication fail closed with 401."""
    # AI validation without token
    res = client.post("/api/v1/ai/validate", json={"problem": "Too much manual data entry", "solution": "AI automation"})
    assert res.status_code == 401
    assert "credentials required" in res.json()["detail"].lower()

    # Admin audit logs without token
    res = client.get("/api/v1/admin/audit-logs")
    assert res.status_code == 401

def test_expired_token_rejected(client):
    """Verify expired tokens are rejected."""
    expired_token = make_test_jwt(expires_in_seconds=-60)
    res = client.get("/api/v1/admin/audit-logs", headers={"Authorization": f"Bearer {expired_token}"})
    assert res.status_code == 401
    assert "expired" in res.json()["detail"].lower()

def test_privilege_escalation_blocked(client):
    """
    CRITICAL SECURITY TEST (Section 7, Rule 4, Rule 5):
    Untrusted user attempts privilege escalation by injecting 'Admin' role into user_metadata.
    The server MUST reject client-supplied role and deny access with 403 Forbidden.
    """
    malicious_token = make_test_jwt(
        user_id="attacker-user-id",
        email="hacker@evil.com",
        user_metadata_role="Admin"  # Client-writable metadata
    )
    
    # Try accessing Admin audit logs
    res = client.get("/api/v1/admin/audit-logs", headers={"Authorization": f"Bearer {malicious_token}"})
    assert res.status_code == 403
    assert "privileged administrative credentials required" in res.json()["detail"].lower()

def test_authenticated_admin_access(client):
    """Verify valid admin token with role in app_metadata can access admin endpoints."""
    admin_token = make_test_jwt(
        user_id="legit-admin-id",
        email="admin@truthprenuer.com",
        app_metadata_role="Admin"
    )
    res = client.get("/api/v1/admin/audit-logs", headers={"Authorization": f"Bearer {admin_token}"})
    assert res.status_code == 200
    assert isinstance(res.json(), list)

def test_moderator_access_separation(client):
    """
    Verify RBAC separation:
    Moderator CAN access moderation reports, but CANNOT access admin-only endpoints.
    """
    mod_token = make_test_jwt(
        user_id="mod-user-id",
        email="mod@truthprenuer.com",
        app_metadata_role="Moderator"
    )

    # Can access moderation reports
    res = client.get("/api/v1/admin/moderation/reports", headers={"Authorization": f"Bearer {mod_token}"})
    assert res.status_code == 200

    # CANNOT access admin-only audit logs
    res = client.get("/api/v1/admin/audit-logs", headers={"Authorization": f"Bearer {mod_token}"})
    assert res.status_code == 403

def test_admin_suspend_user_and_audit(client):
    """Verify user suspension with audit logging and self-suspension guard."""
    admin_token = make_test_jwt(
        user_id="admin-agent-01",
        email="admin@truthprenuer.com",
        app_metadata_role="Admin"
    )

    # Self-suspension guard
    res = client.post(
        "/api/v1/admin/users/admin-agent-01/suspend",
        json={"reason": "Self test", "duration_days": 1},
        headers={"Authorization": f"Bearer {admin_token}"}
    )
    assert res.status_code == 400
    assert "own session" in res.json()["detail"].lower()

    # Legitimate user suspension
    target_id = "spam-user-999"
    res = client.post(
        f"/api/v1/admin/users/{target_id}/suspend",
        json={"reason": "Repeated fraudulent claims in validation pitch", "duration_days": 7},
        headers={"Authorization": f"Bearer {admin_token}"}
    )
    assert res.status_code == 200
    assert res.json()["status"] == "success"

    # Verify audit log recorded
    audit_res = client.get("/api/v1/admin/audit-logs?action=USER_SUSPENDED", headers={"Authorization": f"Bearer {admin_token}"})
    assert audit_res.status_code == 200
    logs = audit_res.json()
    assert any(l["target_id"] == target_id and l["action"] == "USER_SUSPENDED" for l in logs)

def test_moderation_action_flow(client):
    """Verify report listing and moderation action."""
    mod_token = make_test_jwt(
        user_id="mod-agent-02",
        app_metadata_role="Moderator"
    )

    reports = client.get("/api/v1/admin/moderation/reports", headers={"Authorization": f"Bearer {mod_token}"}).json()
    assert len(reports) > 0
    sample_report_id = reports[0]["id"]

    # Apply action
    res = client.post(
        f"/api/v1/admin/moderation/reports/{sample_report_id}/action",
        json={"action": "remove_content", "reason": "Violates community evidence guidelines"},
        headers={"Authorization": f"Bearer {mod_token}"}
    )
    assert res.status_code == 200
    assert res.json()["report"]["status"] == "resolved"
    assert res.json()["report"]["action_taken"] == "remove_content"

def test_ai_validation_endpoint(client):
    """Verify AI validation endpoint with valid user token and schema validation."""
    user_token = make_test_jwt(user_id="founder-user-1")

    # Invalid input (too short problem)
    bad_req = client.post(
        "/api/v1/ai/validate",
        json={"problem": "short", "solution": "solution text here"},
        headers={"Authorization": f"Bearer {user_token}"}
    )
    assert bad_req.status_code == 422  # Pydantic validation error

    # Valid input
    good_req = client.post(
        "/api/v1/ai/validate",
        json={
            "problem": "Early-stage founders waste months building products nobody wants because they lack honest market validation.",
            "solution": "Truthprenuer provides evidence-based startup validation with peer feedback, investor scoring, and synthetic stress testing.",
            "industry": "B2B SaaS",
            "target_audience": "Tech Startup Founders"
        },
        headers={"Authorization": f"Bearer {user_token}"}
    )
    assert good_req.status_code == 200
    data = good_req.json()
    assert data["status"] == "success"
    assert "analysis" in data
    analysis = data["analysis"]
    assert "summary" in analysis
    assert len(analysis["suggested_questions"]) > 0

def test_rate_limiter_enforcement(client):
    """
    Verify rate limiter blocks abuse with HTTP 429 Too Many Requests
    and provides Retry-After header (Section 24).
    """
    rapid_token = make_test_jwt(user_id="rate-limit-test-user")
    payload = {
        "problem": "Founders require objective feedback on target customer pain points.",
        "solution": "Truthprenuer automated evidence validation matrix and insights.",
        "industry": "FinTech",
        "target_audience": "Founders"
    }

    # Execute requests up to the limit (10 for AI)
    responses = []
    for _ in range(15):
        res = client.post(
            "/api/v1/ai/validate",
            json=payload,
            headers={"Authorization": f"Bearer {rapid_token}"}
        )
        responses.append(res.status_code)

    # At least one request beyond the limit must return 429
    assert 429 in responses
    # Find the 429 response and verify headers
    last_res = client.post(
        "/api/v1/ai/validate",
        json=payload,
        headers={"Authorization": f"Bearer {rapid_token}"}
    )
    assert last_res.status_code == 429
    assert "Retry-After" in last_res.headers

def test_admin_blocked_from_external_ip(client):
    """
    Verify zero-trust local network isolation:
    Even with valid Admin credentials, any request originating from an external / public IP
    is strictly rejected with HTTP 403 Forbidden.
    """
    admin_token = make_test_jwt(
        user_id="admin-agent-01",
        email="admin@truthprenuer.com",
        app_metadata_role="Admin"
    )

    # Simulated external internet / cloud request
    res = client.get(
        "/api/v1/admin/audit-logs",
        headers={
            "Authorization": f"Bearer {admin_token}",
            "X-Forwarded-For": "198.51.100.42"  # Public Internet IP
        }
    )
    assert res.status_code == 403
    assert "local loopback access only" in res.json()["detail"].lower()

def test_forged_token_with_wrong_secret_rejected(client):
    """
    CRITICAL SECURITY TEST:
    Attacker signs a token with an unauthorized secret key.
    The server MUST reject the signature and return 401 Unauthorized.
    """
    forged_token = make_test_jwt(
        user_id="attacker-forge-id",
        email="attacker@evil.com",
        app_metadata_role="Super_Admin",
        signing_secret="wrong-secret-key-attacker-666"
    )
    res = client.get(
        "/api/v1/admin/audit-logs",
        headers={"Authorization": f"Bearer {forged_token}"}
    )
    assert res.status_code == 401
    assert "invalid authentication token" in res.json()["detail"].lower()

def test_malformed_token_rejected(client):
    """Verify malformed or garbage Bearer tokens fail closed with 401."""
    res = client.get(
        "/api/v1/admin/audit-logs",
        headers={"Authorization": "Bearer not-a-valid-jwt-token"}
    )
    assert res.status_code == 401
    assert "invalid authentication token" in res.json()["detail"].lower()

def test_unverified_token_cannot_access_admin_even_in_dev(client):
    """
    CRITICAL SECURITY TEST:
    Even when SUPABASE_JWT_SECRET is empty in development, unverified tokens
    must NEVER be granted privileged administrative access (fail-closed).
    """
    from app.core.config import settings
    orig_secret = settings.SUPABASE_JWT_SECRET
    try:
        # Simulate environment where secret is unset
        settings.SUPABASE_JWT_SECRET = ""
        unverified_token = make_test_jwt(
            user_id="unverified-admin-claim",
            email="hacker@evil.com",
            app_metadata_role="Admin",
            signing_secret="any-random-dev-key"
        )
        res = client.get(
            "/api/v1/admin/audit-logs",
            headers={"Authorization": f"Bearer {unverified_token}"}
        )
        assert res.status_code == 401
        assert "valid cryptographically signed" in res.json()["detail"].lower()
    finally:
        settings.SUPABASE_JWT_SECRET = orig_secret

def test_non_admin_personas_rejected_from_admin_endpoints(client):
    """
    Verify authenticated non-admin personas (Founder, Investor, Creator, Professional)
    are strictly rejected with HTTP 403 Forbidden on administrative endpoints.
    """
    for role in ["Founder", "Investor", "Creator", "Professional"]:
        token = make_test_jwt(
            user_id=f"user-{role.lower()}-123",
            app_metadata_role=role
        )
        res = client.get(
            "/api/v1/admin/audit-logs",
            headers={"Authorization": f"Bearer {token}"}
        )
        assert res.status_code == 403, f"Expected role {role} to be forbidden from admin audit-logs"


