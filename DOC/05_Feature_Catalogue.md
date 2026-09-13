# DOCUMENT 05 — FEATURE CATALOGUE

**Document ID:** DOC-05  
**Version:** 1.0  
**Last Updated:** 2026-08-20  
**Owner:** Product Management  
**Status:** Draft  
**Upstream Dependencies:** DOC-01 (Vision), DOC-02 (PRD), DOC-03 (Personas), DOC-04 (Rules)  
**Downstream Dependents:** DOC-06 (User Flows), DOC-07 (Screen Inventory), DOC-08 (UX), DOC-16 (QA)

---

## Table of Contents

1. [Catalogue Structure](#1-catalogue-structure)
2. [FC-100: Authentication & Profile](#2-fc-100-authentication--profile)
3. [FC-200: Validation Core](#3-fc-200-validation-core)
4. [FC-300: Intelligence & Analysis](#4-fc-300-intelligence--analysis)
5. [FC-400: Discovery & Network](#5-fc-400-discovery--network)
6. [FC-500: Communication & Community](#6-fc-500-communication--community)
7. [FC-600: Gamification & Engagement](#7-fc-600-gamification--engagement)
8. [Decision Registry Extract](#8-decision-registry-extract)
9. [Document Status](#9-document-status)

---

## 1. Catalogue Structure

**FC-001**

The feature catalogue maps PRD requirements (DOC-02) into discrete product features. Every feature here must trace back to a functional requirement (FREQ) and forward to a User Flow (DOC-06).

| Module ID | Domain | Primary User |
|-----------|--------|--------------|
| FC-100 | Auth & Profile | All Users |
| FC-200 | Validation | Founder, Validator |
| FC-300 | Intelligence | Founder |
| FC-400 | Discovery | All Users |
| FC-500 | Communication | All Users |
| FC-600 | Gamification | Validator, Founder |

---

## 2. FC-100: Authentication & Profile

### FC-101: Email/Password Authentication
- **Description:** Secure login and registration using email and password.
- **Components:** Sign up, Log in, Forgot password, OTP verification.
- **Traceability:** FREQ-005, FREQ-006, FREQ-007, FREQ-008
- **Rules:** RULE-001
- **Status:** MVP

### FC-102: Interactive Onboarding
- **Description:** Guided setup experience for first-time users.
- **Components:** Splash screen, mood selector, action intention selector, 3-page value prop slider.
- **Traceability:** FREQ-001, FREQ-002, FREQ-003, FREQ-004
- **Status:** MVP

### FC-103: Builder Profile
- **Description:** Public-facing identity for users on the platform.
- **Components:** Avatar, name, bio, role, skills, social links, location. Tabs for Validations and Posts.
- **Traceability:** FREQ-120, FREQ-121
- **Rules:** RULE-002
- **Status:** MVP

### FC-104: Startup Profile
- **Description:** Dedicated profile for the startup entity, distinct from the founder.
- **Components:** Startup name, tagline, description, industry, stage, logo.
- **Traceability:** FREQ-123
- **Status:** MVP

### FC-105: Profile Editor & Settings
- **Description:** Interface to modify profile data and app preferences.
- **Components:** Profile edit form, app settings (notifications, theme), account deletion.
- **Traceability:** FREQ-122, FREQ-124, FREQ-125
- **Status:** MVP

---

## 3. FC-200: Validation Core

### FC-201: Validation Wizard
- **Description:** Guided 8-step process to create a new validation request.
- **Components:** Inputs for Problem, Audience, Solution, Alternatives, Differentiator, Business Model, Title. Generates AI Critique on completion.
- **Traceability:** FREQ-040 through FREQ-049
- **Rules:** RULE-003
- **Status:** MVP

### FC-202: Structured Feedback Form
- **Description:** The core data collection mechanism for community validation.
- **Components:** Problem frequency selector, current solution text, willingness-to-pay toggle, expected price text, missing feature text, 1-5 rating slider, detailed text feedback, confidence slider.
- **Traceability:** FREQ-060, FREQ-061
- **Rules:** RULE-004, RULE-004-C, DEC-028 (No self-feedback)
- **Status:** MVP

### FC-203: Evidence Locker
- **Description:** Repository for storing validation artifacts.
- **Components:** Evidence items (User Interview, Prototype Test, AI Critique, Expert Review, Market Data), confidence scoring.
- **Traceability:** FREQ-080, FREQ-081
- **Rules:** RULE-005, DEC-031
- **Status:** MVP

### FC-204: Validation detail & Management
- **Description:** The central hub for a specific validation request.
- **Components:** Full request details, feedback summary, comment thread, edit/delete controls.
- **Traceability:** FREQ-050, FREQ-051, FREQ-052
- **Status:** MVP

---

## 4. FC-300: Intelligence & Analysis

### FC-301: AI Validation Report
- **Description:** LLM-generated critique of the validation request.
- **Components:** Analysis sections: problem analysis, competitor overview, market assumptions, risks, missing information, suggested audience, interview questions, bias warnings.
- **Traceability:** FREQ-070, FREQ-071, FREQ-072
- **Rules:** RULE-013, DEC-032
- **Status:** MVP

### FC-302: Startup Health Dashboard
- **Description:** 10-dimensional quantitative score based on feedback and evidence.
- **Components:** Overall score, 10 individual dimension scores with explanations and recommendations.
- **Traceability:** FREQ-082, FREQ-083, FREQ-084, FREQ-085, FREQ-086
- **Rules:** RULE-006
- **Status:** MVP

### FC-303: Decision Intelligence Center
- **Description:** Actionable recommendations based on validation state.
- **Components:** Next-best-action cards (Gather Evidence, Pivot, Build, etc.), confidence score, contradiction detection.
- **Traceability:** FREQ-090, FREQ-091, FREQ-092
- **Rules:** RULE-007
- **Status:** MVP

### FC-304: AI Mentor Chat
- **Description:** Conversational interface for querying validation data and receiving guidance.
- **Components:** Chat UI, context-aware AI responses based on the user's validation state.
- **Traceability:** FREQ-073, FREQ-074, FREQ-075
- **Status:** MVP

---

## 5. FC-400: Discovery & Network

### FC-401: Home Feed (Validation Marketplace)
- **Description:** Curated list of validation requests requiring feedback.
- **Components:** Validation cards (title, problem, stage, feedback count), category filters.
- **Traceability:** FREQ-024, FREQ-056
- **Rules:** DEC-030 (needsFeedback = < 3)
- **Status:** MVP

### FC-402: Discovery Engine (Explore)
- **Description:** Global view of all validation activity on the platform.
- **Components:** Filterable list of all public validation requests.
- **Traceability:** FREQ-030, FREQ-031
- **Status:** MVP

### FC-403: Founder Network Directory
- **Description:** Searchable list of all platform users.
- **Components:** User cards (name, role, skills), search by name/role/skill.
- **Traceability:** FREQ-100, FREQ-101
- **Rules:** RULE-010
- **Status:** MVP

### FC-404: Global Search
- **Description:** Unified search across entities.
- **Components:** Search inputs, results grouped by Users, Validations, Posts. Local search history.
- **Traceability:** FREQ-033, FREQ-034
- **Status:** MVP

---

## 6. FC-500: Communication & Community

### FC-501: 1-on-1 Messaging
- **Description:** Direct communication between users.
- **Components:** Chat list, unread badges, chat room, text messages, pin/archive conversation.
- **Traceability:** FREQ-110, FREQ-111, FREQ-112, FREQ-113
- **Rules:** RULE-011
- **Status:** MVP

### FC-502: Community Posts
- **Description:** User-generated content for sharing updates, wins, or challenges.
- **Components:** Post creation (title, body, tags), feed display, like, bookmark.
- **Traceability:** FREQ-140, FREQ-141, FREQ-142
- **Rules:** RULE-008
- **Status:** MVP

### FC-503: Comments System
- **Description:** Threaded discussion on validation requests.
- **Components:** Comment creation, chronological display, like.
- **Traceability:** FREQ-055
- **Rules:** RULE-009
- **Status:** MVP

### FC-504: In-App Notifications
- **Description:** Real-time alerts for relevant platform activity.
- **Components:** Notification feed, 8 notification types, unread count badge, mark as read.
- **Traceability:** FREQ-130, FREQ-131, FREQ-132, FREQ-133, FREQ-134
- **Rules:** RULE-012
- **Status:** MVP

---

## 7. FC-600: Gamification & Engagement

### FC-601: Validation Passport
- **Description:** Portable reputation system for validators.
- **Components:** Verified expertise badges, "ideas improved" count, trust rating.
- **Traceability:** UREQ-022
- **Status:** Medium Priority (Post-MVP refinement)

### FC-602: Gamification Hub
- **Description:** Dashboard tracking user progress and community standing.
- **Components:** Achievements tab, Leaderboard tab.
- **Traceability:** FREQ-127
- **Status:** Medium Priority (Post-MVP refinement)

### FC-603: Social Proof Actions
- **Description:** Lightweight interaction mechanics.
- **Components:** Upvote validation, bookmark validation.
- **Traceability:** FREQ-053, FREQ-054
- **Status:** MVP

---

## 8. Decision Registry Extract

No new overarching product decisions are established in this document. It serves as a mapping layer between requirements (DOC-02) and user flows (DOC-06).

---

## 9. Document Status

**STATUS:** Draft  
**REVIEW STATE:** Needs Review

### Consistency Check Against Upstream Docs

| Check | Result |
|-------|--------|
| All P0/P1 functional requirements from DOC-02 are mapped to a feature. | ✅ |
| No features contradict the rules in DOC-04. | ✅ |
| Personas from DOC-03 can achieve their goals via these features. | ✅ |
| MVP scope aligns with VISION-012. | ✅ |

### Next Actions

1. Proceed to DOC-06 (User Flows & Information Architecture).
