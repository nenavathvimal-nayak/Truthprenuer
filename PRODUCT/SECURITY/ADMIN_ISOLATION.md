# TRUTHPRENUER — SECURE ADMIN ISOLATION SPECIFICATION

**Protocol Specification:** Localhost-Only Zero-Trust Administrative Boundary  
**Enforcement Port:** `60135`  
**Enforcement Host:** `127.0.0.1`  

---

## 1. Threat Definition & Scope

Administrative access carries high privilege: inspecting tamper-evident audit logs, resolving user fraud reports, suspending user accounts, and managing platform compliance. If exposed to the internet, attackers could target administrative endpoints through credential stuffing, session hijacking, or automated scanner probes.

---

## 2. Hardened Isolation Controls

### 2.1 Interface & Port Binding
- **Host Binding:** `127.0.0.1` (IPv4 loopback).
- **Wildcard Prohibition:** Binding to `0.0.0.0` or `::` is strictly prohibited.
- **Port:** Fixed at `60135`.
- **Fail-Fast:** Vite configured with `strictPort: true`. If port `60135` is occupied, Vite terminates immediately rather than incrementing to an unapproved port.
- **Startup Script:** [`ADMIN/RUN_LOCAL/start_admin_60135.sh`](../../ADMIN/RUN_LOCAL/start_admin_60135.sh) performs a pre-flight `lsof` check to confirm port `60135` is free before launching.

### 2.2 Network Level & LAN Blocking
- **Empirical Proof:** When tested against the local LAN address (`10.250.110.63:60135`), incoming TCP SYN packets are rejected at the kernel socket boundary with `Connection Refused`.
- **Zero Ingress:** No public DNS records, Cloudflare Tunnel rules, ngrok tunnels, or reverse proxy paths point to port `60135`.

### 2.3 Backend Gateway Enforcement (`require_local_admin_origin`)
Even if an attacker gains knowledge of the `/api/v1/admin/*` API surface, the backend server implements an origin guard:
```python
def require_local_admin_origin(request: Request) -> None:
    client_ip = request.client.host if request.client else "unknown"
    local_loopbacks = {"127.0.0.1", "::1", "localhost", "testclient"}
    # Blocks if external IP or public hop in X-Forwarded-For
    ...
```
Any request from a public IP address is terminated with `HTTP 403 Forbidden` at the dependency injection level before reaching business logic.

### 2.4 Server-Side Cryptographic Auth & RBAC Verification
1. **Cryptographic Signature Mandate:**
   - Any token authorizing administrative (`require_admin`) or moderation (`require_moderator`) operations **MUST** be verified cryptographically (`is_signature_verified=True`).
   - In development mode without a configured `SUPABASE_JWT_SECRET`, unverified tokens are stripped of elevated permissions and assigned role `Founder`, preventing any unauthorized privilege escalation (`HTTP 401 Unauthorized`).
2. **Authoritative Server Decisions:**
   - Unverified tokens, forged tokens with arbitrary secrets, and expired tokens fail closed immediately.
   - Client-writable claims cannot promote a user. All role assignments are validated against the authoritative Supabase user profile.
3. **Frontend Guard Alignment (`AdminAuthGuard.tsx`):**
   - The React admin panel strictly permits only privileged roles: `Admin`, `Super_Admin`, `Security`, and `Moderator`.
   - Non-privileged roles (`Founder`, `Investor`, `User`) and accounts with missing profiles are denied administrative access and redirected to access-denied state.

---

## 3. Verification Protocol

To verify admin isolation and security controls on the owner's workstation:

```bash
# 1. Verify loopback UI access works
curl -I http://127.0.0.1:60135/
# Expected: HTTP/1.1 200 OK

# 2. Verify LAN access is blocked at network socket layer
LAN_IP=$(ipconfig getifaddr en0 || ipconfig getifaddr en1)
curl --connect-timeout 2 "http://${LAN_IP}:60135/"
# Expected: Connection refused (exit code 7)

# 3. Verify backend test suite enforces all isolation and cryptographic auth rules
backend/venv/bin/pytest backend/tests/test_api_suite.py -k "admin"
# Expected: PASSED (All admin IP isolation, signature checks, and RBAC tests pass)
```
