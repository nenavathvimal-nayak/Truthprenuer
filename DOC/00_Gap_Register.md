# MASTER GAP REGISTER

**Document ID:** DOC-00-GR  
**Last Updated:** 2026-08-20  
**Owner:** Product Management  
**Purpose:** Track identified gaps, contradictions, and missing requirements discovered during the Cross-Document Audit process.

---

## 1. Active Gaps

| Gap ID | Description | Severity | Affected Docs | Recommended Action | Status |
|---|---|---|---|---|---|
| GAP-001 | AI Provider Unselected | Critical | 12, 15, 18 | Evaluate OpenAI vs Anthropic cost/latency SLA and sign DPA. | Open |
| GAP-002 | Analytics KPI Targets missing baseline | Medium | 14 | Launch without hard targets for WAVF and adjust after Cohort 1. | Open |
| GAP-003 | Legal Jurisdiction Undefined | High | 19, 20 | Founders must select incorporation state/country to finalize dispute resolution clause. | Open |
| GAP-004 | DPA Signatures Pending | Critical | 18, 20 | Complete DPA review for Auth0/Supabase, Analytics, and AI providers before Beta launch. | Open |
| GAP-005 | Physical Device Inventory | Medium | 16 | QA team needs to procure minimum required Android/iOS physical devices for release gates. | Open |

---

## 2. Resolved Gaps

| Gap ID | Description | Resolution | Date |
|---|---|---|---|
| GAP-RES-001 | Error states undocumented in UI | Generated DOC-13 and mapped to DOC-08 UI components. | 2026-08-20 |
| GAP-RES-002 | Analytics PII leakage risk | Added strict UUID-only rule in DOC-14 and mapped to DOC-18. | 2026-08-20 |
| GAP-RES-003 | Vague "AI rules" in PRD | Expanded into DOC-15 with strict SLAs, fallbacks, and prohibitions. | 2026-08-20 |
