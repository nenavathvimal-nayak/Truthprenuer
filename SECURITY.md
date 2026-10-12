# TRUTHPRENUER — SECURITY POLICY & VULNERABILITY DISCLOSURE

## 1. Security Philosophy

Truthprenuer adheres to zero-trust principles, defense-in-depth, least privilege, and tamper-evident auditing across all services.

---

## 2. Supported Versions

| Version | Supported |
| :--- | :--- |
| `1.0.x` (Current Main) | ✅ Active Security Support |
| `< 1.0.0` | ❌ Unsupported |

---

## 3. Reporting a Vulnerability

If you discover a security vulnerability, please do NOT create a public issue on GitHub.
Instead, report the vulnerability privately to:
`security@truthprenuer.com`

Please include:
1. Target component (Flutter Client, Backend API, Database, or Admin Console)
2. Vulnerability description and STRIDE categorization
3. Steps to reproduce or proof-of-concept payload
4. Impact assessment

Our security engineering team will acknowledge receipt within 24 hours and provide a remediation timeline.

---

## 4. Key Security Invariants

1. **Admin Isolation:** The administrative console is restricted to `127.0.0.1:60135`. Backend administrative endpoints reject any external or non-loopback IP with `HTTP 403 Forbidden`.
2. **Database RLS:** All public PostgreSQL tables have Row Level Security enabled.
3. **Immutable WORM Audit Trail:** `admin_audit_logs` has no `UPDATE` or `DELETE` policies.
4. **Secret Protection:** Service-role keys and JWT secrets are server-side only and never committed to version control.
