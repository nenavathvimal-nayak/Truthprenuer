# DOCUMENT 18 — SECURITY & PRIVACY ARCHITECTURE

**Document ID:** DOC-18  
**Version:** 1.0  
**Last Updated:** 2026-08-20  
**Owner:** Security/Privacy Lead  
**Status:** Draft  
**Upstream Dependencies:** DOC-04 (Product Rules), DOC-12 (Backend), DOC-15 (AI Rules), DOC-17 (Moderation)  
**Downstream Dependents:** DOC-19 (Terms), DOC-20 (Privacy Policy), DOC-21 (Release Rules)  

---

## Table of Contents

1. [Security Principles](#1-security-principles)
2. [Authentication Architecture](#2-authentication-architecture)
3. [Authorization & RBAC](#3-authorization--rbac)
4. [Encryption & Data Protection](#4-encryption--data-protection)
5. [API Security](#5-api-security)
6. [Database Security](#6-database-security)
7. [File & Storage Security](#7-file--storage-security)
8. [Privacy Architecture](#8-privacy-architecture)
9. [Data Retention & Deletion](#9-data-retention--deletion)
10. [AI Privacy Considerations](#10-ai-privacy-considerations)
11. [Third-Party Integration Security](#11-third-party-integration-security)
12. [Abuse Prevention](#12-abuse-prevention)
13. [Audit Logging & Monitoring](#13-audit-logging--monitoring)
14. [Incident Response](#14-incident-response)
15. [Threat Model Summary](#15-threat-model-summary)
16. [Decision Registry Extract](#16-decision-registry-extract)
17. [Document Status](#17-document-status)

---

## 1. Security Principles

**SEC-001: Least Privilege.**
Every system component, user role, and API endpoint must operate with the minimum permissions required. No blanket admin access.

**SEC-002: Defense in Depth.**
Security must be enforced at multiple layers: client, API gateway, service layer, database, and storage. No single layer is the sole defense.

**SEC-003: Zero Trust Internal.**
Backend services must authenticate each other. A compromised service must not automatically have access to all data.

**SEC-004: No Security through Obscurity.**
Never rely on hidden URLs, undocumented endpoints, or client-side enforcement as a security control. All authorization must be server-side.

---

## 2. Authentication Architecture

**SEC-005: Authentication Flow.**

| Component | Implementation |
| :--- | :--- |
| **Method** | Email/Password + Social OAuth (Google, Apple) |
| **Tokens** | JWT: Short-lived access token (15 min) + Long-lived refresh token (30 days) |
| **Storage (Client)** | Access token: in-memory. Refresh token: `flutter_secure_storage` (Keychain/Keystore) |
| **Rotation** | Access token refreshed silently via refresh token. Refresh token rotated on each use. |
| **Logout** | Invalidate refresh token server-side. Clear all tokens client-side. |
| **Multi-Device** | Each device gets independent refresh tokens. Revoking one does not affect others (unless "Log out all devices" is triggered). |

**SEC-006: Password Requirements.**
- Minimum 8 characters.
- Must contain at least 1 uppercase, 1 lowercase, and 1 digit.
- Passwords hashed server-side using bcrypt (cost factor ≥ 12) or Argon2id.
- Plaintext passwords must NEVER be logged, stored, or transmitted outside of HTTPS.

**SEC-007: Multi-Factor Authentication.**
MFA is **Post-MVP**. Flag for implementation before any monetization or admin-panel features launch.

---

## 3. Authorization & RBAC

**SEC-008: Role Definitions.**

| Role | Permissions |
| :--- | :--- |
| **User** | CRUD own profile, CRUD own ideas, submit/receive feedback, message connections, view public content |
| **Moderator** | All User permissions + view reports, review flagged content, issue Level 0–3 enforcement (DOC-17) |
| **Admin** | All Moderator permissions + manage users, promote/demote moderators, issue Level 4–5 enforcement, access admin dashboard, manage feature flags |

**SEC-009: Resource Ownership Enforcement.**
Every mutating API endpoint must verify that `request.user_id == resource.owner_id` before executing the operation. This check must happen in the service layer, not just middleware.

---

## 4. Encryption & Data Protection

**SEC-010: Encryption in Transit.**
- All client ↔ server communication must use TLS 1.2+ (preferably TLS 1.3).
- HTTP is prohibited. HSTS headers must be set.
- Certificate pinning: **Evaluate Post-MVP** (complex to maintain with certificate rotation).

**SEC-011: Encryption at Rest.**
- Database encryption at rest must be enabled (provided by managed PostgreSQL services).
- Object storage (S3/R2) must have server-side encryption enabled.
- Client-side sensitive data in `flutter_secure_storage` leverages OS-level encryption (Keychain/Keystore).

**SEC-012: Secrets Management.**
- API keys, database credentials, and signing keys must NEVER appear in source code.
- Use environment variables or a secrets manager (e.g., AWS Secrets Manager, Vault).
- Rotate secrets on a quarterly schedule and immediately upon any suspected compromise.

---

## 5. API Security

**SEC-013: Input Validation.**
- All API inputs must be validated server-side (type, length, format, range).
- Client-side validation is a UX convenience, not a security control.

**SEC-014: Rate Limiting.**
- Global: 100 requests per minute per authenticated user.
- Auth endpoints (login, signup): 10 requests per minute per IP.
- AI endpoints: Per-feature limits defined in DOC-15 (AI-030).
- Return `429 Too Many Requests` with `Retry-After` header (maps to DOC-13, VAL_429_RATE_LIMIT).

**SEC-015: CORS.**
- Only allow origins matching the TAEED web domain (if applicable). Mobile apps do not use CORS.
- Never set `Access-Control-Allow-Origin: *` in production.

**SEC-016: SQL Injection Prevention.**
- All database queries must use parameterized queries or an ORM. Raw string concatenation in SQL is prohibited.

**SEC-017: Request ID Tracing.**
- Every API request must be assigned a unique `X-Request-ID` header for traceability across logs, errors, and support tickets.

---

## 6. Database Security

**SEC-018: Access Control.**
- Application connects to the database via a dedicated service account with restricted permissions (no `DROP`, no `GRANT`).
- Admin access to production database requires VPN + individual credentials + audit logging.

**SEC-019: Soft Deletes.**
- User-facing "delete" operations perform soft deletes (`deleted_at` timestamp) per DOC-12, BA-006.
- Hard deletes (permanent data destruction) are executed only by automated retention policies or explicit GDPR/privacy deletion requests.

---

## 7. File & Storage Security

**SEC-020: Upload Validation.**
- Validate file type (MIME type + magic bytes, not just extension).
- Enforce file size limits (10 MB for images, configurable for other types).
- Scan uploads for malware if budget permits (Post-MVP).

**SEC-021: Presigned URL Security.**
- Presigned upload URLs must expire within 15 minutes.
- Presigned download URLs for private content must expire within 1 hour.
- Public content (e.g., idea cover images) may use public CDN URLs.

---

## 8. Privacy Architecture

**SEC-022: Data Minimization.**
Collect only data required for product functionality. Do not collect:
- Precise GPS location (approximate city from IP is sufficient, if needed).
- Contact lists.
- Device sensor data beyond what is needed for the product.

**SEC-023: Privacy by Default.**
- New user profiles default to the minimum public visibility.
- Users must opt-in to broader visibility (e.g., showing their portfolio publicly).

**SEC-024: User Data Access.**
Users must be able to:
- View all data TAEED holds about them (data export / download).
- Request deletion of their account and associated data.

These are MVP requirements, not Post-MVP.

---

## 9. Data Retention & Deletion

**SEC-025: Retention Schedule.**

| Data Type | Retention Period | Justification |
| :--- | :--- | :--- |
| Active user account data | Until deletion requested | Product functionality |
| Soft-deleted user data | 30 days post-deletion request | Recovery grace period, then hard delete |
| Moderation audit logs | 1 year | Abuse investigation & compliance |
| Analytics events (pseudonymous) | 2 years | Product analysis |
| AI request logs (metadata only) | 90 days | Debugging & quality evaluation |
| Raw AI prompts (containing user content) | Not retained beyond request lifecycle | Privacy (DOC-15, AI-018) |
| Auth refresh tokens (revoked) | 30 days | Security audit trail |

**SEC-026: Account Deletion Flow.**
1. User requests deletion from Settings.
2. 7-day cooling-off period (user can cancel).
3. After 7 days: account soft-deleted, profile removed from public view.
4. After 30 days: all personal data hard-deleted. Pseudonymous analytics data retained.
5. User notified via email at each stage.

---

## 10. AI Privacy Considerations

**SEC-027: AI Data Flow.**
- User content sent to third-party LLM APIs is governed by Data Processing Agreements (DOC-15, AI-019).
- User content must be transmitted to the LLM API and discarded after the response. The AI provider must not retain or train on TAEED user data (contractual requirement).
- The Privacy Policy (DOC-20) must disclose this data flow.

**SEC-028: AI Opt-Out.**
Users who disable AI features (DOC-15, AI-025) must have their content excluded from all AI processing pipelines.

---

## 11. Third-Party Integration Security

**SEC-029: Third-Party Inventory.**
Maintain a registry of all third-party services that receive user data:

| Service | Data Shared | Purpose | DPA Required |
| :--- | :--- | :--- | :--- |
| Auth Provider (e.g., Supabase Auth) | Email, hashed password | Authentication | Yes |
| LLM Provider (e.g., OpenAI) | Idea text, feedback text | AI features | Yes — **Needs Legal Review** |
| Analytics Provider (e.g., PostHog) | Pseudonymous events | Product analytics | Yes |
| Object Storage (e.g., AWS S3) | User-uploaded files | Media storage | Yes (covered by cloud DPA) |
| Email Service (e.g., SendGrid) | Email address | Transactional emails | Yes |

**SEC-030: Vendor Assessment.**
Before integrating any new third-party service, evaluate: data handling practices, encryption, compliance certifications, and DPA availability.

---

## 12. Abuse Prevention

**SEC-031: Account Abuse.**
- Limit account creation to 3 accounts per email domain per hour (prevent mass bot signups).
- CAPTCHA or equivalent challenge on signup if suspicious activity detected.

**SEC-032: Content Abuse.**
- Rate limiting on submissions (DOC-13, VAL_429).
- AI-powered content flagging (DOC-17, MOD-018).
- Validation score manipulation detection: flag statistical anomalies (e.g., a user receiving 50 perfect scores in 1 hour).

---

## 13. Audit Logging & Monitoring

**SEC-033: Security Events to Log.**

| Event | Severity |
| :--- | :--- |
| Login success/failure | Info |
| Password change | Info |
| Permission escalation (role change) | Warning |
| Account deletion initiated | Warning |
| Admin access to production database | Critical |
| Repeated 403 from same user | Warning (potential abuse) |
| Rate limit exceeded (429) | Warning |
| Unusual API pattern (possible scraping) | Warning |

**SEC-034: Monitoring & Alerting.**
- Set up automated alerts for: >10 failed login attempts from one IP (5 min), any 500-series error spike (>5/min), and any role change to Admin.
- Alerts route to the on-call engineer via PagerDuty/Slack/email.

---

## 14. Incident Response

**SEC-035: Incident Response Plan (MVP Baseline).**

| Phase | Action | Owner |
| :--- | :--- | :--- |
| **Detection** | Automated alert or user report | Engineering / Support |
| **Triage** | Classify severity (S0–S3 per DOC-16) | On-Call Engineer |
| **Containment** | Disable affected feature, revoke compromised tokens, block abusive accounts | Engineering |
| **Eradication** | Fix root cause, patch vulnerability | Engineering |
| **Recovery** | Restore service, verify fix, re-enable features | Engineering |
| **Post-Mortem** | Document incident, root cause, timeline, and preventive measures | Engineering + Product |

**SEC-036: Data Breach Notification.**
If a data breach affecting user PII is confirmed:
- Notify affected users within 72 hours.
- Notify relevant data protection authorities as legally required.
- Document the breach scope, timeline, and remediation in the post-mortem.

> **STATUS:** Specific legal notification obligations are **Needs Legal Review** based on operating jurisdictions.

---

## 15. Threat Model Summary

**SEC-037: Top Threats (MVP).**

| Threat | Likelihood | Impact | Mitigation |
| :--- | :--- | :--- | :--- |
| Credential stuffing / brute force login | High | High | Rate limiting, account lockout, bcrypt/Argon2 |
| SQL injection | Medium | Critical | Parameterized queries, ORM |
| XSS (if web client exists) | Medium | High | Input sanitization, CSP headers |
| Token theft (mobile) | Medium | High | Secure storage, short-lived tokens, rotation |
| Prompt injection (AI features) | Medium | Medium | Input sanitization, defensive prompts (DOC-15) |
| Unauthorized data access | Medium | Critical | RBAC, ownership checks, least privilege |
| Mass spam / bot accounts | High | Medium | Rate limiting, CAPTCHA, moderation |
| Data exfiltration by rogue admin | Low | Critical | Audit logging, least privilege, separation of duties |

---

## 16. Decision Registry Extract

| ID | Decision | Reason | Status |
|---|---|---|---|
| DEC-SEC-001 | JWT with short-lived access + rotating refresh | Industry standard; limits token theft window | Approved |
| DEC-SEC-002 | bcrypt or Argon2id for password hashing | Resistant to brute-force and GPU attacks | Approved |
| DEC-SEC-003 | MFA is Post-MVP | MVP scope control; flag before monetization | Approved |
| DEC-SEC-004 | 30-day hard-delete after account deletion | Balance user rights with recovery grace period | Approved |
| DEC-SEC-005 | Data breach notification within 72 hours | Aligns with GDPR-style requirements | **Needs Legal Review** |

---

## 17. Document Status

**STATUS:** Draft  
**REVIEW STATE:** Needs Legal Review (breach notification, DPAs, jurisdiction)  

### Open Questions

| ID | Question | Owner |
|---|---|---|
| OQ-SEC-001 | Which jurisdictions does TAEED operate in? (Affects privacy law obligations) | Legal |
| OQ-SEC-002 | Are all third-party DPAs signed? | Legal |
| OQ-SEC-003 | Should certificate pinning be MVP or Post-MVP? | Engineering |
| OQ-SEC-004 | Budget for malware scanning on uploads? | Product + Finance |

### Consistency Check Against Upstream Docs

| Check | Result |
|-------|--------|
| Auth flow supports Frontend token handling (DOC-11, FA-013). | ✅ |
| RBAC matches Backend roles (DOC-12, BA-009). | ✅ |
| AI privacy rules match DOC-15. | ✅ |
| Moderation audit logs match DOC-17 requirements. | ✅ |
| Rate limiting maps to DOC-13 error codes. | ✅ |
| Retention schedule matches Analytics privacy classification (DOC-14). | ✅ |

### Next Actions

1. Proceed to generate DOC-19 (Terms & Conditions).
