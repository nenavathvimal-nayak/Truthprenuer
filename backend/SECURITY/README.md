# Truthprenuer Backend — Security & Auth Invariants (`BACKEND/SECURITY/`)

## Responsibility
Houses authentication and authorization middleware, peer socket loopback verification, and cryptographic helpers.
- [`app/core/security.py`](../app/core/security.py): JWT verification, password hashing, fail-closed handling.
- [`app/core/rate_limit.py`](../app/core/rate_limit.py): Sliding window memory-leak-safe rate limiting.
- [`app/api/deps.py`](../app/api/deps.py): `require_local_admin_origin` zero-trust boundary check (peer socket must be `127.0.0.1` or `::1`).
