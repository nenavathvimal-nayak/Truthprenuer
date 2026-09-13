# MASTER DECISION REGISTRY

**Document ID:** DOC-00-DR  
**Last Updated:** 2026-08-20  
**Owner:** Product Strategy  
**Purpose:** Central source of truth for all major product, design, technical, and operational decisions across the TAEED ecosystem. No downstream document may contradict an approved decision.

---

## 1. Product & Strategy Decisions (Docs 01-07)

| ID | Decision | Reason | Source | Status |
|---|---|---|---|---|
| DEC-PROD-001 | MVP Focus on Idea → Feedback loop only | Prevent scope creep; test core value proposition first. | DOC-02 | Approved |
| DEC-PROD-002 | Strict moderation of non-constructive feedback | Crucial to maintain trust and prevent platform toxicity. | DOC-04 | Approved |

## 2. Design & UX Decisions (Docs 08-10)

| ID | Decision | Reason | Source | Status |
|---|---|---|---|---|
| DEC-DES-001 | No generic "success/error" colors without icons | Accessibility (A11y) constraint for colorblind users. | DOC-10 | Approved |
| DEC-DES-002 | Use "Liquid Glass" navigation treatment | Establishes premium visual identity. | DOC-09 | Approved |

## 3. Engineering & Architecture Decisions (Docs 11-13)

| ID | Decision | Reason | Source | Status |
|---|---|---|---|---|
| DEC-FRONT-001 | Feature-First Folder Structure | Better cohesion and scalability than layer-first. | DOC-11 | Approved |
| DEC-FRONT-002 | Riverpod for State & DI | Standardizes both state and DI safely; excellent testability. | DOC-11 | Approved |
| DEC-FRONT-003 | GoRouter for Navigation | Official routing package, handles deep links and auth guards well. | DOC-11 | Approved |
| DEC-BACK-001 | Modular Monolith | Balances speed of MVP development with future extraction capabilities. | DOC-12 | Approved |
| DEC-BACK-002 | PostgreSQL as Primary DB | Required for relational integrity, JSONB support, and mature ecosystem. | DOC-12 | Approved |
| DEC-BACK-003 | Presigned URLs for Uploads | Prevents the API from bottlenecking on large media uploads. | DOC-12 | Approved |
| DEC-ERR-001 | Human-Readable Errors | Raw errors erode trust. All errors must map to consumer-friendly copy. | DOC-13 | Approved |

## 4. Analytics & AI Decisions (Docs 14-15)

| ID | Decision | Reason | Source | Status |
|---|---|---|---|---|
| DEC-AN-001 | WAVF as North Star | Directly measures core product value delivery, not vanity activity. | DOC-14 | Approved |
| DEC-AN-002 | UUID-only user identification | Prevents PII leakage in the analytics pipeline. | DOC-14 | Approved |
| DEC-AI-001 | AI is assistant, not authority | Protect trust; prevent false validation | DOC-15 | Approved |
| DEC-AI-002 | All AI outputs visually labeled | Transparency is non-negotiable | DOC-15 | Approved |
| DEC-AI-003 | No training on user data without consent | Legal and ethical requirement | DOC-15 | Approved |
| DEC-AI-005 | AI provider selection | OpenAI vs Gemini vs Anthropic | DOC-15 | **Needs Decision** |

## 5. QA & Release Decisions (Docs 16, 21)

| ID | Decision | Reason | Source | Status |
|---|---|---|---|---|
| DEC-QA-001 | Test Pyramid (60/20/15/5 split) | Maximize coverage at lowest cost; E2E only for critical paths | DOC-16 | Approved |
| DEC-QA-003 | Physical device release gate | Emulators miss real-world rendering, gesture, and performance issues | DOC-16 | Approved |
| DEC-REL-001 | Trunk-based development | Prevents merge hell; forces smaller, testable PRs | DOC-21 | Approved |
| DEC-REL-002 | Feature flags for all P0/P1 | Decouples deployment from product launch | DOC-21 | Approved |
| DEC-REL-003 | Non-destructive DB migrations | Enables safe backend rollbacks | DOC-21 | Approved |

## 6. Governance & Legal Decisions (Docs 17-20)

| ID | Decision | Reason | Source | Status |
|---|---|---|---|---|
| DEC-MOD-001 | AI flags are signals, not verdicts | Prevent false positives from auto-penalizing users | DOC-17 | Approved |
| DEC-MOD-002 | Graduated enforcement (5 levels) | Proportional response prevents over-moderation | DOC-17 | Approved |
| DEC-SEC-001 | JWT with short-lived access + rotating refresh | Industry standard; limits token theft window | DOC-18 | Approved |
| DEC-SEC-004 | 30-day hard-delete after account deletion | Balance user rights with recovery grace period | DOC-18 | Approved |
| DEC-LEG-001 | No IP claim on user ideas | Essential for founder trust; we are a platform, not an incubator. | DOC-19 | Approved |
| DEC-PRIV-001 | Explicit "No Training" disclosure | Builds trust with founders protective of their IP. | DOC-20 | Approved |
