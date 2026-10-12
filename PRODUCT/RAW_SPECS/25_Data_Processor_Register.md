# DOCUMENT 25 — DATA PROCESSOR REGISTER

**Document ID:** DOC-25  
**Version:** 1.0  
**Last Updated:** 2026-09-22  
**Owner:** Security / Privacy  
**Status:** Initial Draft  
**Purpose:** Registry of all third-party vendors processing personal data on behalf of NENAV (TAEED).

---

## 1. Primary Infrastructure

| Vendor | Purpose | Data Processed | Data Categories | Country / Location | Processing Location | Sub-Processors | Security Controls | Contract Status | Retention | Deletion Process | Cross-Border Status | Owner |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **Supabase** | DB, Auth, Storage | Email, hashed password, user profiles, ideas, logs | Personal, Public, Internal | Global (US HQ) | *Needs Verification* (Specify region in config) | AWS (typically) | Encryption at rest/transit, SOC2 | *Needs DPA* | Matches app logic | API driven | Yes (If outside India) | Engineering |
| **AWS / Cloud Provider** | Hosting (if custom backend added) | Logs, IP addresses | Internal, Security | Global | *Needs Verification* | None | Encryption | *Needs DPA* | 90 days | Automated | Yes | DevOps |

## 2. Analytics & Monitoring

| Vendor | Purpose | Data Processed | Data Categories | Country / Location | Processing Location | Sub-Processors | Security Controls | Contract Status | Retention | Deletion Process | Cross-Border Status | Owner |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **PostHog / Mixpanel** | Product Analytics | UUID, usage events, IP (approx location) | Internal, Location | Global | *Needs Verification* | AWS / GCP | SOC2 | *Needs DPA* | 2 years | API / Automated | Yes | Product |
| **Sentry / Crashlytics** | Crash Reporting | Device info, stack traces, User ID | Internal | Global | *Needs Verification* | AWS / GCP | SOC2 | *Needs DPA* | 90 days | Automated | Yes | Engineering |

## 3. AI / Machine Learning

| Vendor | Purpose | Data Processed | Data Categories | Country / Location | Processing Location | Sub-Processors | Security Controls | Contract Status | Retention | Deletion Process | Cross-Border Status | Owner |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **OpenAI / Gemini** | Idea Sharpening, Feedback | Idea text, user content | Public, Personal (incidental) | US | US | None | SOC2, "Zero Data Retention" (Enterprise) | *Needs DPA* | 0-30 days | API / Automated | Yes | Product |

---

## Cross-Border Processing Summary

NENAV utilizes globally distributed cloud services (Supabase, OpenAI, Analytics). This constitutes cross-border data transfer. 
- **Action Required:** Verify if DPDP Act triggers any restricted transfer rules based on future government notifications.
- **Action Required:** Sign Data Processing Agreements (DPAs) with all vendors listed above, explicitly prohibiting secondary use or model training on NENAV data.

> **Legal Validation Required:** Contract status and cross-border processing locations must be verified by Legal.
