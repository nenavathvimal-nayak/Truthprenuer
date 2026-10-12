# TRUTHPRENUER — MODULE S: ADMINISTRATION & MODERATION
## Screens 176 – 185 Specification

---

### Module Overview
- **Domain:** Platform Administration, Trust & Safety Moderation, User Lifecycle Management & Security Audit
- **Security & Access Control:**
  - Strictly restricted to authorized personnel with Platform Admin or Trust & Safety Moderator roles.
  - Mandatory hardware MFA and session timeouts (30-minute idle re-auth).
  - 100% immutable audit logging for all administrative actions (bans, suspensions, taxonomy edits).

---

### Screen 176: Admin Dashboard
- **Screen ID:** `SCR-176`
- **Route:** `/admin`
- **Key Health Metrics:**
  - Active Users (DAU 4,820 • MAU 42,100)
  - Pending Moderation Reports (14 Queue items)
  - Total Validations Launched (1,240 this month)
  - System Error Rate (0.02% • All AI synthesis pipelines nominal)
- **Urgent Action Queues:** "3 High-Priority Abuse Reports", "2 Pending Investor Credential Verifications".

---

### Screen 177: User Management
- **Screen ID:** `SCR-177`
- **Route:** `/admin/users`
- **User Directory Table:**
  - User ID, Name, Email, Role (Founder, Investor, Validator, Admin), Status (Active, Suspended, Banned, Pending Verification), Joined Date, Reports Count.
  - Search & Filters by Role, Status, Risk Score.

---

### Screen 178: User Details & Account Actions
- **Screen ID:** `SCR-178`
- **Route:** `/admin/users/:userId`
- **Operator View:**
  - Full account history: Login IPs, connected providers, validations created, feedback submitted.
  - Administrative Action Modal: Suspend Account (7/30 days), Permanent Ban, Reset 2FA, Manually Grant Verified Credential Badge. Requires reason input recorded to audit log.

---

### Screen 179: Validation Moderation Queue
- **Screen ID:** `SCR-179`
- **Route:** `/admin/moderation/validations`
- **Triage Queue:** List of validations flagged by automated spam heuristics or community reports. Shows reason for flag, AI confidence risk score, and quick actions: "Approve", "Request Edits", "Take Down".

---

### Screen 180: Report & Abuse Review
- **Screen ID:** `SCR-180`
- **Route:** `/admin/moderation/reports`
- **Review Inbox:** User reports categorized by Harassment, Fake Traction, Intellectual Property Theft, Commercial Spam. Priority sorting by reporter reputation.

---

### Screen 181: Content Moderation Details
- **Screen ID:** `SCR-181`
- **Route:** `/admin/moderation/reports/:reportId`
- **Side-by-Side Comparison:** Reporter claim vs. Reported content (with highlighted offending passages). Audit actions: Dismiss Report, Issue Warning to author, Delete Content, Shadowban user.

---

### Screen 182: Community Management
- **Screen ID:** `SCR-182`
- **Route:** `/admin/communities`
- **Community Directory:** Manage community channels, review creator applications, assign platform moderators, transfer community ownership.

---

### Screen 183: Platform Categories & Taxonomy
- **Screen ID:** `SCR-183`
- **Route:** `/admin/taxonomy`
- **Taxonomy Editor:** Add, merge, or deprecate industry verticals, skill tags, and validation stages. Shows active usage counts per category.

---

### Screen 184: Platform Analytics & Operational Health
- **Screen ID:** `SCR-184`
- **Route:** `/admin/analytics`
- **System Telemetry:** AI Synthesis API latency (p50, p95, p99), Supabase database pool connection status, storage consumption, monthly recurring revenue (MRR) breakdown.

---

### Screen 185: Admin Roles, Permissions & Audit Log
- **Screen ID:** `SCR-185`
- **Route:** `/admin/audit-log`
- **Immutable Audit Trail:**
  - Timestamp, Admin Operator (`admin_john@truthprenuer.com`), Action (`USER_BANNED`), Target (`user_98421`), Justification ("Repeated promotional spam bot"), IP Address.
  - Export Audit Log to CSV/JSON for compliance review.
