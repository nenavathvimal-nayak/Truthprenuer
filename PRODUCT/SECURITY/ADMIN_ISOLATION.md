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
- **Startup Script:** [`ADMIN/RUN_LOCAL/start_admin_60135.sh`](file:///Volumes/NAYAK/taeed_flutter_source/ADMIN/RUN_LOCAL/start_admin_60135.sh) performs a pre-flight `lsof` check to confirm port `60135` is free before launching.

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

### 2.4 Server-Side RBAC Verification
1. Verifies user session with Supabase auth.
2. Queries the authoritative `profiles` table to confirm that `role IN ('Admin', 'Super_Admin', 'Security')`.
3. Verifies that `is_suspended` is false.
4. If invalid, executes `supabase.auth.signOut()` and renders an access-denied security banner.

---

## 3. Verification Protocol

To verify admin isolation on the owner's workstation:

```bash
# 1. Verify loopback access works
curl -I http://127.0.0.1:60135/
# Expected: HTTP/1.1 200 OK

# 2. Verify LAN access is blocked
LAN_IP=$(ipconfig getifaddr en0 || ipconfig getifaddr en1)
curl --connect-timeout 2 "http://${LAN_IP}:60135/"
# Expected: Connection refused (exit code 7)

# 3. Verify external internet call to Admin API is rejected
pytest backend/tests/test_api_suite.py -k "test_admin_blocked_from_external_ip"
# Expected: PASSED (HTTP 403 Forbidden returned)
```
