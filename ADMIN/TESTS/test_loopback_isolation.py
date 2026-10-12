import urllib.request
import pytest

def test_admin_loopback_reachable():
    """Verify that Admin Console is running on http://127.0.0.1:60135"""
    req = urllib.request.Request("http://127.0.0.1:60135/")
    with urllib.request.urlopen(req, timeout=3) as response:
        assert response.status == 200
        html = response.read().decode("utf-8")
        assert "Truthprenuer" in html or "root" in html
