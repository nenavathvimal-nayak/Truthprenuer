# TRUTHPRENUER — COMPREHENSIVE THREAT MODEL

**Methodology:** STRIDE (Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege)  
**Scope:** Full-Stack Architecture (Client, Gateway API, Database, Admin)  

---

## 1. System Asset Classification

- **Tier 1 (Critical Assets):**
  - Supabase Database Service Role Key (Server-side held)
  - Supabase JWT Signing Secret (Server-side held)
  - PostgreSQL WORM Audit Log (`admin_audit_logs`)
  - User Authentication Records (`auth.users`, `profiles`)
- **Tier 2 (Sensitive Assets):**
  - Private Direct Messages & Conversations
  - Unreleased Startup Hypotheses & Validation Pitches
  - Internal Reputation Scores & Fraud Reports
- **Tier 3 (Public Assets):**
  - Public User Profiles & Upvote Aggregates
  - Static Web Client Assets

---

## 2. STRIDE Threat Assessment & Mitigations

### 2.1 Spoofing Identity
- **Threat:** Attacker crafts forgeable JWTs or reuses expired tokens to impersonate administrators or founders.
- **Mitigation:**
  - Mandatory signature verification with `SUPABASE_JWT_SECRET`.
  - Fail-closed gate: if secret is absent in production, server rejects requests with HTTP 500 rather than accepting unverified payloads.
  - Token expiration (`exp`) strictly validated.

### 2.2 Tampering with Data
- **Threat:** Malicious user alters validation scores, modifies other founders' pitches, or tampers with moderation logs.
- **Mitigation:**
  - Row Level Security (RLS) on all PostgreSQL tables.
  - `admin_audit_logs` table has no `UPDATE` or `DELETE` policies (WORM append-only).
  - Score calculations performed server-side.

### 2.3 Repudiation
- **Threat:** An administrator suspends an account or deletes content, then denies having performed the action.
- **Mitigation:**
  - Every administrative action (`suspend_user`, `restore_user`, `action_report`) logs an immutable entry to `admin_audit_logs` containing `actor_id`, `actor_role`, `action`, `target_id`, `ip_address`, `request_id`, and `timestamp`.

### 2.4 Information Disclosure
- **Threat:** Leaking service-role keys in public frontend web builds or repository commits.
- **Mitigation:**
  - Client applications only hold public anon key.
  - Service-role key exists exclusively in backend `.env` (gitignored).
  - Automated CI secret scanning via Gitleaks action.

### 2.5 Denial of Service (DoS)
- **Threat:** Flooding high-compute AI validation endpoints or exhausting server memory.
- **Mitigation:**
  - `SlidingWindowRateLimiter` restricts AI endpoints to 10 requests/minute and general API to 60 requests/minute.
  - Memory leak protection via `_cleanup_stale_keys(now)` garbage collection every 5 minutes.

### 2.6 Elevation of Privilege
- **Threat:** Standard user escalates role to Admin by editing profile JSON or setting client localStorage keys.
- **Mitigation:**
  - `AdminAuthGuard` validates role directly against the server-side `profiles` table.
  - Backend `require_admin` checks database role and enforces `require_local_admin_origin` (loopback-only).
