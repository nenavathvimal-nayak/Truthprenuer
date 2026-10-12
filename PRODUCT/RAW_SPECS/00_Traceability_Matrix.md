# MASTER TRACEABILITY MATRIX

**Document ID:** DOC-00-TM  
**Last Updated:** 2026-08-20  
**Owner:** Product Architecture  
**Purpose:** Ensure every feature defined in the Master PRD maps to a complete set of implementation requirements across the entire product stack.

---

## 1. Traceability Standard

For a feature to be considered "Implementation Ready", it must be traceable across all 12 domains:
`Feature → Flow → Screen → UI → Frontend → API → Error → Analytics → QA → Moderation → Security → Legal`

---

## 2. Master Matrix (MVP Features)

| Feature (DOC-05) | Flow (DOC-06) | Screen (DOC-07) | Frontend (DOC-11) | Backend (DOC-12) | Error (DOC-13) | Analytics (DOC-14) | QA (DOC-16) | Sec/Privacy (DOC-18/20) |
|---|---|---|---|---|---|---|---|---|
| **Auth/Signup** | Onboarding Flow | SPL-01, ONB-01..03, LOG-01 | AuthRepository, GoRouter AuthGuard | Identity Service, JWT | SEC_401 | AN-ACT-001..004 | TC-001 | bcrypt, short-lived JWT |
| **Idea Submission** | Submission Flow | SUB-01, SUB-02 | Form Providers, Image Picker | Content Service, S3 Upload | VAL_400, NET_002, SYS_UPLOAD | AN-VAL-001..003 | TC-002 | Presigned URLs, Rate Limit |
| **Global Feed** | Feed Flow | HOM-01 | AsyncNotifierProvider | Content Service, Pagination | NET_001, SYS_500 | AN-ENG-003..004 | TC-002 | Public visibility |
| **Peer Feedback** | Feedback Flow | IDEA-01, FBK-01 | Feedback Notifier | Validation Service | VAL_429, VAL_409 | AN-VAL-004..005 | TC-003 | Content Auto-Filter (MOD-018) |
| **Health Score** | View Score Flow | DASH-01 | AsyncNotifierProvider | Validation Service | NET_002 | AN-VAL-007 | TC-004 | Score manipulation detection |
| **AI Sharpening** | AI Context Flow | SUB-01-AI | AI State Enum | AI Orchestrator | AI_503 | AN-AI-001..005 | TC-005 | No-training DPA (AI-017) |

---

## 3. Gap Identification Status

*(Refer to `00_Gap_Register.md` for specific missing items)*

- **Orphaned Features:** None. All DOC-05 features trace to a DOC-07 screen.
- **Orphaned Screens:** None. All DOC-07 screens are tied to a DOC-06 Flow.
- **Orphaned Errors:** None. All DOC-13 errors are tied to a frontend state.
