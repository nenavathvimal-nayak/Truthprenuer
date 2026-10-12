# TRUTHPRENUER — PRIVATE ADMIN STARTUP RUNBOOK

## 1. Security Overview

The Truthprenuer Admin Console provides privileged operational controls including moderation actions, user suspension, and access to tamper-evident audit logs.

**Strict Security Requirement:** The Admin Console must NEVER be accessible over the internet or LAN. It runs exclusively on the authorized administrator's workstation bound to loopback `127.0.0.1:60135`.

---

## 2. Standard Startup Procedure

Execute the dedicated startup script from the project root:

```bash
./ADMIN/RUN_LOCAL/start_admin_60135.sh
```

Or invoke the convenience launcher:

```bash
./scripts/start_admin_60135.sh
```

### What the Script Performs:
1. **Pre-flight Port Verification:** Tests if port `60135` is already in use using `lsof`. If occupied, it immediately terminates with exit code 1 to avoid port collision.
2. **Explicit Loopback Binding:** Forces Vite to bind strictly to host `127.0.0.1` and port `60135` with `strictPort: true`.
3. **Launches Server:** Emits local listener `http://127.0.0.1:60135/`.

---

## 3. Verifying Localhost-Only Isolation

Run the following checks to confirm network boundary enforcement:

```bash
# Check 1: Loopback must succeed
curl -I http://127.0.0.1:60135/
# Expected: HTTP/1.1 200 OK

# Check 2: LAN IP must be refused
LAN_IP=$(ipconfig getifaddr en0 || ipconfig getifaddr en1)
curl --connect-timeout 2 "http://${LAN_IP}:60135/"
# Expected: Failed to connect / Connection refused

# Check 3: Check listening sockets
lsof -Pi :60135 -sTCP:LISTEN
# Expected: LISTEN on 127.0.0.1:60135 (NOT *:60135 or 0.0.0.0:60135)
```

---

## 4. Stopping the Admin Console

Press `Ctrl+C` in the running terminal, or run:

```bash
kill $(lsof -t -i :60135)
```
