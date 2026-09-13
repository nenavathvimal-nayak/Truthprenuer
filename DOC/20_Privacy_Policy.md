# DOCUMENT 20 — PRIVACY POLICY

**Document ID:** DOC-20  
**Version:** 1.0  
**Last Updated:** 2026-08-20  
**Owner:** Legal + Privacy  
**Status:** Draft [LEGAL REVIEW REQUIRED]  
**Upstream Dependencies:** DOC-14 (Analytics), DOC-15 (AI Rules), DOC-18 (Security & Privacy)  
**Downstream Dependents:** None  

---

## Table of Contents

1. [Information We Collect](#1-information-we-collect)
2. [How We Use Your Information](#2-how-we-use-your-information)
3. [How We Share Your Information](#3-how-we-share-your-information)
4. [AI Processing & Data Privacy](#4-ai-processing--data-privacy)
5. [Data Retention & Deletion](#5-data-retention--deletion)
6. [Your Privacy Rights](#6-your-privacy-rights)
7. [Security Measures](#7-security-measures)
8. [International Data Transfers](#8-international-data-transfers)
9. [Children's Privacy](#9-childrens-privacy)
10. [Changes to this Policy](#10-changes-to-this-policy)
11. [Decision Registry Extract](#11-decision-registry-extract)
12. [Document Status](#12-document-status)

---

## 1. Information We Collect

We collect information necessary to provide the TAEED platform. We explicitly do not collect precise GPS location or device contact lists (DOC-18, SEC-022).

- **Information You Provide Directly:**
  - **Account Data:** Email address, password (hashed), and profile information (name, bio).
  - **User Content:** Startup ideas, evidence uploaded, and feedback submitted to peers.
  - **Communications:** Direct messages sent to other users or support requests sent to us.
- **Information Collected Automatically:**
  - **Usage Data:** Interactions with the app (e.g., screens viewed, buttons tapped), linked only to an anonymous UUID (DOC-14, AN-011).
  - **Device Data:** Device type, operating system version, and IP address (used for abuse prevention and approximate region mapping).

---

## 2. How We Use Your Information

We use the collected information strictly for the following purposes:
- **Service Delivery:** To create your account, display your profile, and facilitate the core idea validation loop.
- **Platform Improvement:** To analyze aggregate, pseudonymous usage trends (DOC-14) to improve the user experience.
- **Trust & Safety:** To enforce our Community Guidelines (DOC-17), prevent spam, and mitigate fraud.
- **Communication:** To send you essential product updates, feedback notifications, and security alerts.

---

## 3. How We Share Your Information

We do not sell your personal information to data brokers. We share information only in the following circumstances:
- **With Other Users:** Information you choose to make public (e.g., your public profile, public startup ideas, and public feedback) is visible to other users.
- **With Service Providers:** We use trusted third-party vendors for hosting, database management, authentication, analytics, and AI processing. These vendors are bound by Data Processing Agreements (DPAs) (DOC-18, SEC-029).
- **For Legal Compliance:** We may disclose information if required by law, subpoena, or valid legal process.

---

## 4. AI Processing & Data Privacy

TAEED utilizes third-party Large Language Models (LLMs) to power specific features (e.g., Idea Sharpening, Scoring).
- **Data Transmission:** When you use an AI feature, relevant text is transmitted to our AI provider.
- **No Training Promise:** We explicitly prohibit our AI providers from using your User Content to train their foundation models (DOC-15, AI-017).
- **Ephemeral Processing:** Raw prompt data containing your content is not retained by the AI provider beyond the immediate request lifecycle (DOC-15, AI-018).

---

## 5. Data Retention & Deletion

- **Retention:** We retain your account data for as long as your account is active. Pseudonymous analytics data may be retained for up to 2 years.
- **Deletion:** You may request account deletion at any time via the Settings menu. Upon request, your account enters a 7-day cooling-off period, followed by soft-deletion for 30 days, and subsequent hard deletion of all PII (DOC-18, SEC-026).

---

## 6. Your Privacy Rights

Depending on your jurisdiction (e.g., GDPR, CCPA), you may have the right to:
- Access the personal data we hold about you.
- Request correction of inaccurate data.
- Request deletion of your personal data (Right to be Forgotten).
- Opt-out of specific data processing (e.g., disabling AI features in Settings).

> **[LEGAL REVIEW REQUIRED]:** Ensure rights listed align with the specific jurisdictions TAEED operates in.

---

## 7. Security Measures

We implement industry-standard technical and organizational measures to protect your data, including TLS encryption in transit, AES-256 encryption at rest, and strict Role-Based Access Controls (RBAC) (DOC-18). However, no system is 100% secure, and we cannot guarantee absolute security.

---

## 8. International Data Transfers

Your data may be processed and stored on servers located outside your country of residence (e.g., in the United States). By using TAEED, you consent to this transfer.

> **[LEGAL REVIEW REQUIRED]:** If operating in the EU/UK, confirm whether Standard Contractual Clauses (SCCs) or the Data Privacy Framework are relied upon.

---

## 9. Children's Privacy

TAEED is not intended for individuals under the age of 18. We do not knowingly collect personal information from children. If we become aware that we have collected such data, we will delete it immediately.

---

## 10. Changes to this Policy

We may update this Privacy Policy from time to time. If we make material changes, we will notify you within the app or via email prior to the changes taking effect.

---

## 11. Decision Registry Extract

| ID | Decision | Reason | Status |
|---|---|---|---|
| DEC-PRIV-001 | Explicit "No Training" disclosure | Builds trust with founders protective of their IP. | Approved |
| DEC-PRIV-002 | UUID-only analytics data | Limits blast radius if analytics provider is breached. | Approved |
| DEC-PRIV-003 | Hard deletion at 37 days | (7 days cool-off + 30 days soft delete) Balances recovery UX with GDPR rights. | Approved |

---

## 12. Document Status

**STATUS:** Draft  
**REVIEW STATE:** Needs Legal Review  

### Open Questions

| ID | Question | Owner |
|---|---|---|
| OQ-PRIV-001 | Does TAEED fall under CCPA thresholds or GDPR jurisdiction at launch? | Legal |
| OQ-PRIV-002 | What is the contact email address for privacy/DSR requests? | Ops |

### Consistency Check Against Upstream Docs

| Check | Result |
|-------|--------|
| Data collection limits match DOC-18 (Security). | ✅ |
| Analytics claims match DOC-14 (UUIDs, no PII). | ✅ |
| AI processing disclosures match DOC-15 rules. | ✅ |
| Account deletion timeline matches DOC-18 (SEC-026). | ✅ |

### Next Actions

1. Proceed to generate DOC-21 (Release Rules).
