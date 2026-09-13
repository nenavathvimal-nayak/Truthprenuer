# DOCUMENT 22 — ROADMAP

**Document ID:** DOC-22  
**Version:** 1.0  
**Last Updated:** 2026-08-20  
**Owner:** Product Strategy  
**Status:** Draft  
**Upstream Dependencies:** DOC-01 through DOC-21  
**Downstream Dependents:** None  

---

## Table of Contents

1. [Roadmap Philosophy](#1-roadmap-philosophy)
2. [Phase 1: NOW (MVP Launch)](#2-phase-1-now-mvp-launch)
3. [Phase 2: NEXT (Post-Launch Growth)](#3-phase-2-next-post-launch-growth)
4. [Phase 3: LATER (Scale & Expansion)](#4-phase-3-later-scale--expansion)
5. [Feature Dependency Mapping](#5-feature-dependency-mapping)
6. [Decision Registry Extract](#6-decision-registry-extract)
7. [Document Status](#7-document-status)

---

## 1. Roadmap Philosophy

**RD-001: Sequence Over Dates.**
This roadmap prioritizes dependencies and strategic impact (Impact vs. Effort vs. Risk). We do not assign arbitrary launch dates (e.g., "Q3 Release") until the engineering velocity of the MVP is proven.

**RD-002: MVP Discipline.**
If a feature does not directly support the Core Product Loop (Idea → Feedback → Validation) or basic Trust & Safety, it belongs in NEXT or LATER.

---

## 2. Phase 1: NOW (MVP Launch)

**Goal:** Establish the Core Product Loop and achieve the first cohort of Weekly Active Validated Founders (WAVF).

| Priority | Feature / Milestone | Upstream Dependency | Status |
| :--- | :--- | :--- | :--- |
| **P0** | **Identity:** Auth, Sign Up, Basic Profile (Auth0 / Supabase Auth) | — | Planned |
| **P0** | **Core Action:** Idea Submission Form (Text + Image upload) | Identity | Planned |
| **P0** | **Discovery:** Global Feed (Chronological/Basic sort) | Idea Submission | Planned |
| **P0** | **Validation:** Peer Feedback Form (Structured inputs) | Discovery | Planned |
| **P0** | **Value Delivery:** Basic Validation Health Score Calculation | Peer Feedback | Planned |
| **P1** | **Safety:** Basic Moderation (Reporting, Block, Mute) | Identity | Planned |
| **P1** | **AI MVP:** Idea Sharpening Assistant | Idea Submission | Planned |
| **P1** | **Infra:** Analytics Pipeline Setup (DOC-14) | — | Planned |
| **P1** | **Infra:** App Store release infrastructure (DOC-21) | — | Planned |

**Exit Criteria for Phase 1:** App is live in iOS/Android stores; 100 early-access founders have successfully received feedback.

---

## 3. Phase 2: NEXT (Post-Launch Growth)

**Goal:** Increase retention, deepen network connections, and improve feedback quality using advanced AI.

| Priority | Feature / Milestone | Upstream Dependency | Status |
| :--- | :--- | :--- | :--- |
| **P1** | **Social:** Direct Messaging between founders/reviewers | Identity | Backlog |
| **P1** | **Social:** Follow / Connection graph | Identity | Backlog |
| **P1** | **AI Expansion:** Health Score Explainer (DOC-15, AI-FEAT-004) | Health Score | Backlog |
| **P2** | **AI Expansion:** Feedback Quality Scorer (DOC-15, AI-FEAT-002) | Peer Feedback | Backlog |
| **P2** | **Discovery:** Algorithmic Feed (Engagement-based sorting) | Analytics | Backlog |
| **P2** | **Retention:** Push Notifications (Milestones, new feedback) | Core Action | Backlog |

**Exit Criteria for Phase 2:** D30 Retention stabilizes > 12%; Validation Quality Score reaches baseline targets.

---

## 4. Phase 3: LATER (Scale & Expansion)

**Goal:** Monetization, enterprise infrastructure, and advanced validation tools.

| Priority | Feature / Milestone | Upstream Dependency | Status |
| :--- | :--- | :--- | :--- |
| **P2** | **Monetization:** Premium Founder Tier (Advanced analytics, priority feed placement) | Payments Infra | Backlog |
| **P3** | **Validation:** Investor/Expert Verification Badges | Identity verification | Backlog |
| **P3** | **AI Expansion:** Evidence Relevance Checker (DOC-15, AI-FEAT-003) | Idea Submission | Backlog |
| **P3** | **Infra:** Transition Monolith to Microservices (if scaled) | Backend (DOC-12) | Backlog |
| **P3** | **Infra:** Multi-region database replication | Database setup | Backlog |

---

## 5. Feature Dependency Mapping

**RD-003: The Critical Path.**
Development must strictly follow this order to unblock engineering:
1. **Database Schema & Auth** (Unblocks all feature work)
2. **Design System & Base UI Components** (Unblocks all frontend screens)
3. **Idea Submission API** (Unblocks the Feed)
4. **Feed UI** (Unblocks Peer Feedback)
5. **Peer Feedback API** (Unblocks Health Score Calculation)
6. **Analytics & QA Gates** (Unblocks Release)

---

## 6. Decision Registry Extract

| ID | Decision | Reason | Status |
|---|---|---|---|
| DEC-RD-001 | No Direct Messaging in MVP | Too high effort/risk for initial Core Product Loop testing. | Approved |
| DEC-RD-002 | Algorithmic feed deferred to NEXT | Chronological is sufficient for first 1,000 users. | Approved |
| DEC-RD-003 | AI Quality Scorer deferred to NEXT | Need baseline human feedback data to evaluate the AI. | Approved |

---

## 7. Document Status

**STATUS:** Draft  
**REVIEW STATE:** Needs Review  

### Open Questions

| ID | Question | Owner |
|---|---|---|
| OQ-RD-001 | What is the target engineering team size for MVP execution? | Founders |
| OQ-RD-002 | Will we launch iOS and Android simultaneously, or iOS first? | Product |

### Consistency Check Against Upstream Docs

| Check | Result |
|-------|--------|
| MVP features align exactly with DOC-05 Feature Catalogue. | ✅ |
| Defers complex backend (Microservices) per DOC-12. | ✅ |
| Includes AI features exactly as scoped in DOC-15. | ✅ |

### Next Actions

1. Execute the **Master Cross-Document Audit**.
