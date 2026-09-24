# DOCUMENT 24 — DPDP DATA INVENTORY

**Document ID:** DOC-24  
**Version:** 1.0  
**Last Updated:** 2026-09-22  
**Owner:** Privacy & Data Lead  
**Status:** Initial Draft  
**Purpose:** Field-by-field mapping of all personal data processed by NENAV (TAEED) to establish a baseline for DPDP compliance.

---

## 1. Classification Categories

- **PUBLIC / LOW RISK:** Visible to other users (e.g., username, bio, public ideas).
- **PERSONAL:** Identifies the user (e.g., email, full name).
- **LOCATION:** IP-based approximate location (if collected).
- **VERIFICATION / RESTRICTED:** Internal IDs, authentication tokens.
- **SECURITY / INTERNAL:** Audit logs, access logs.

---

## 2. Data Inventory Matrix

### 2.1. Authentication & Profile (Supabase Auth + `profiles` table)

| Data Field | Data Subject | Purpose | Lawful Ground | Required/Optional | Collection Point | Storage | Processor | Who Can Access | User Visibility | Retention | Deletion Method | Security Classification |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `auth.email` | User | Login, Auth | Consent / Sec 7 (Auth) | Required | Signup | Database | Supabase | Auth Service | Settings | Active Account | Account Deletion | Personal |
| `auth.password` | User | Login | Sec 7 (Auth) | Required | Signup | Database | Supabase | Auth Service | Hidden | Active Account | Account Deletion | Security (Hashed) |
| `profiles.username` | User | Platform Identity | Consent | Required | Profile Setup | Database | Supabase | Public | Public | Active Account | Account Deletion | Public |
| `profiles.full_name` | User | Profile Display | Consent | Required | Profile Setup | Database | Supabase | Public | Public | Active Account | Account Deletion | Personal / Public |
| `profiles.avatar_url`| User | Profile Visual | Consent | Optional | Profile Setup | DB / Storage | Supabase | Public | Public | Active Account | Account Deletion | Public |
| `profiles.bio` | User | Professional Context | Consent | Optional | Profile Setup | Database | Supabase | Public | Public | Active Account | Account Deletion | Public |
| `profiles.role` | User | RBAC Enforcement | Sec 7 (Security) | Required | System Generated | Database | Supabase | Admins / Self | Settings | Active Account | Account Deletion | Security / Internal |
| `IP Address` | User | Abuse Prevention | Sec 7 (Security) | Required | Network Request | Logs | Supabase / Hosting | Admins / Security | Hidden | 30-90 Days | Log Rotation | Security / Internal |

### 2.2. User Content & Ideas (`validations`, `evidence_items`, `validation_questions`)

*Note: User content may contain incidental PII depending on what the user types. The lawful ground is Consent for product functionality.*

| Data Field | Data Subject | Purpose | Lawful Ground | Required/Optional | Collection Point | Storage | Processor | Who Can Access | User Visibility | Retention | Deletion Method | Security Classification |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `validations.*` | User | Core Product (Idea) | Consent | Required | In-App Form | Database | Supabase | Public (or specified audience) | App UI | Active Account | Account Deletion / User Action | Public |
| `evidence_items.*`| User | Idea Validation | Consent | Required | In-App Form | Database | Supabase | Public / Connections | App UI | Active Account | Account Deletion / User Action | Public |

## 3. Data Minimization Analysis

- **Are we collecting unnecessary data?** Currently, the schema is very lean. No precise GPS, no phone numbers (unless enabled in Supabase Auth), no contact lists. 
- **Action Items:** 
  - Ensure Supabase Auth is configured to NOT require phone numbers unless explicitly needed for 2FA later.
  - Implement explicit consent for storing and processing `bio` and `avatar_url` since they are optional.

---

> **Legal Validation Required:** Lawful grounds mapping (Consent vs Section 7 legitimate uses) requires formal legal sign-off.
