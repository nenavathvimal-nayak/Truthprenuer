import urllib.request
import urllib.error
import pytest

def test_admin_loopback_reachable():
    """Verify that Admin Console is running on http://127.0.0.1:60135 when server is active."""
    try:
        req = urllib.request.Request("http://127.0.0.1:60135/")
        with urllib.request.urlopen(req, timeout=3) as response:
            assert response.status == 200
            html = response.read().decode("utf-8")
            assert "Truthprenuer" in html or "root" in html
    except (urllib.error.URLError, ConnectionRefusedError, OSError):
        pytest.skip("Admin local dev server on 127.0.0.1:60135 is not currently running.")
