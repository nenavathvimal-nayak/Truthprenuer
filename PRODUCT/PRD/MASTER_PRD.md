# DOCUMENT 02 — MASTER PRODUCT REQUIREMENTS DOCUMENT (PRD)

**Document ID:** DOC-02  
**Version:** 1.0  
**Last Updated:** 2026-08-20  
**Owner:** Product Management  
**Status:** Draft  
**Upstream Dependencies:** DOC-01 (Product Vision & Strategy)  
**Downstream Dependents:** DOC-03 through DOC-22

---

## Table of Contents

1. [Product Overview](#1-product-overview)
2. [Problem Statement](#2-problem-statement)
3. [Goals](#3-goals)
4. [Non-Goals](#4-non-goals)
5. [User Requirements](#5-user-requirements)
6. [Business Requirements](#6-business-requirements)
7. [Functional Requirements](#7-functional-requirements)
8. [Non-Functional Requirements](#8-non-functional-requirements)
9. [MVP Scope](#9-mvp-scope)
10. [Post-MVP Scope](#10-post-mvp-scope)
11. [Feature Priorities](#11-feature-priorities)
12. [Acceptance Criteria](#12-acceptance-criteria)
13. [Dependencies](#13-dependencies)
14. [Constraints](#14-constraints)
15. [Risks](#15-risks)
16. [Success Metrics](#16-success-metrics)
17. [Edge Cases](#17-edge-cases)
18. [Product Rules References](#18-product-rules-references)
19. [Decision Registry Extract](#19-decision-registry-extract)
20. [Document Status](#20-document-status)

---

## 1. Product Overview

**PRD-001**

**Product Name:** TAEED  
**Tagline:** Validation Network  
**Platform:** iOS, Android (Flutter cross-platform)  
**Current State:** Frontend prototype with mock data. No backend.

TAEED is a mobile-first platform where early-stage founders submit startup ideas for structured community validation, receive AI-assisted analysis, collect evidence, and make evidence-based decisions about whether to build, pivot, or abandon their ideas.

Inherits: VISION-001, VISION-002, DEC-007

---

## 2. Problem Statement

**PRD-002**

Inherits: VISION-003

> Early-stage founders lack a structured, accessible system for validating their startup ideas before committing significant time and capital. Existing alternatives (forums, advisors, accelerators) are either unstructured, inaccessible, or not designed for pre-build validation. As a result, founders build products that nobody wants, wasting resources on untested assumptions.

TAEED solves this by providing a structured validation workflow combining community feedback, AI analysis, and evidence collection.

---

## 3. Goals

**PRD-003**

### 3.1 Product Goals

| ID | Goal | Measure | Priority |
|----|------|---------|----------|
| GOAL-001 | Enable founders to validate startup ideas before building | # of validation requests created | P0 |
| GOAL-002 | Provide structured, quantifiable community feedback | Average structured feedback items per validation request | P0 |
| GOAL-003 | Deliver AI-assisted analysis that is useful and honest | AI usefulness rating (user-reported) | P0 |
| GOAL-004 | Help founders collect and organize validation evidence | # of evidence items per validation | P1 |
| GOAL-005 | Quantify startup health across multiple dimensions | Startup Health score adoption rate | P1 |
| GOAL-006 | Provide actionable decision intelligence | Decision action rate | P1 |
| GOAL-007 | Build a founder community centered on validation | Weekly active users, D7 retention | P0 |
| GOAL-008 | Enable founder-to-founder networking | Connection/match rate | P2 |

### 3.2 Business Goals

| ID | Goal | Measure | Priority |
|----|------|---------|----------|
| BGOAL-001 | Achieve product-market fit for the validation loop | North Star Metric (see VISION-016) | P0 |
| BGOAL-002 | Build a two-sided marketplace with organic supply | Validator-to-founder ratio | P0 |
| BGOAL-003 | Demonstrate monetization potential | Willingness-to-pay signals from users | P1 |
| BGOAL-004 | Create defensible network effects | Viral coefficient, organic growth rate | P2 |

---

## 4. Non-Goals

**PRD-004**

Inherits: VISION-013

| ID | Non-Goal |
|----|----------|
| NG-001 | Replace customer interviews |
| NG-002 | Guarantee startup success |
| NG-003 | Become a social media platform |
| NG-004 | Provide legal, financial, or tax advice |
| NG-005 | Build an accelerator program |
| NG-006 | Facilitate fundraising or investor matching |
| NG-007 | Operate as an idea marketplace |
| NG-008 | Compete with project management tools |
| NG-009 | Support enterprise / corporate innovation use cases in MVP |
| NG-010 | Build a web application for MVP (mobile-first) |

---

## 5. User Requirements

**PRD-005**

Detailed personas in DOC-03. Requirements derived from confirmed code behavior.

### 5.1 Founder Requirements

| ID | Requirement | Priority | Source |
|----|------------|----------|--------|
| UREQ-001 | As a founder, I can create a validation request with structured fields (problem, solution, audience, business model, differentiator, go-to-market, title). | P0 | validation_wizard_view.dart |
| UREQ-002 | As a founder, I receive an AI validation report (problem analysis, competitor overview, risks, bias warnings) for my validation request. | P0 | ai_validation_view.dart |
| UREQ-003 | As a founder, I receive structured feedback from community validators (problem frequency, current solution, willingness to pay, pricing, missing features, rating). | P0 | structured_feedback_view.dart |
| UREQ-004 | As a founder, I can view my Startup Health score across 10 dimensions. | P1 | startup_health_dashboard_view.dart |
| UREQ-005 | As a founder, I receive Decision Intelligence recommendations (next best action, confidence, contradiction detection). | P1 | founder_home_view.dart |
| UREQ-006 | As a founder, I can collect and organize evidence (user interviews, prototype tests, AI critiques, expert reviews, market data). | P1 | evidence_locker_view.dart |
| UREQ-007 | As a founder, I can view all validations requiring my feedback in the home feed. | P0 | founder_home_view.dart |
| UREQ-008 | As a founder, I can chat with an AI Mentor for guidance. | P1 | ai_mentor_chat_view.dart |
| UREQ-009 | As a founder, I can browse and discover other founders' validations by industry category. | P0 | explore_view.dart |
| UREQ-010 | As a founder, I can upvote and bookmark validation requests. | P1 | models.dart |
| UREQ-011 | As a founder, I can create posts to share updates, wins, or challenges. | P1 | mock_data_store.dart |
| UREQ-012 | As a founder, I can message other users directly. | P1 | chat_room_view.dart |
| UREQ-013 | As a founder, I can set up my profile with name, bio, role, website, Twitter, location, and skills. | P0 | edit_profile_view.dart |
| UREQ-014 | As a founder, I can view my validation history and progress in a dashboard. | P1 | validation_dashboard_view.dart |
| UREQ-015 | As a founder, I receive notifications for feedback, mentions, milestones, connections, and upvotes. | P1 | notifications_view.dart |

### 5.2 Validator Requirements

| ID | Requirement | Priority | Source |
|----|------------|----------|--------|
| UREQ-020 | As a validator, I can provide structured feedback on founders' validation requests. | P0 | structured_feedback_view.dart |
| UREQ-021 | As a validator, I can attach evidence to my feedback (confidence score, evidence items). | P1 | models.dart (EvidenceAttachment) |
| UREQ-022 | As a validator, I can build my Validation Passport (verified expertise, ideas improved, trust rating). | P2 | models.dart (ValidationPassport) |
| UREQ-023 | As a validator, I can browse validations needing feedback. | P0 | founder_home_view.dart |
| UREQ-024 | As a validator, I earn Proof of Validation tokens for providing feedback. | P2 | models.dart (ValidationPassport) |

### 5.3 General User Requirements

| ID | Requirement | Priority | Source |
|----|------------|----------|--------|
| UREQ-030 | As a user, I can sign up with email and password. | P0 | signup_view.dart |
| UREQ-031 | As a user, I can log in with email and password. | P0 | login_view.dart |
| UREQ-032 | As a user, I can verify my account with OTP. | P0 | otp_verification_view.dart |
| UREQ-033 | As a user, I can reset my password. | P0 | forgot_password_view.dart |
| UREQ-034 | As a user, I experience a guided onboarding flow. | P0 | onboarding_view.dart |
| UREQ-035 | As a user, I can search for users, validations, and posts. | P1 | mock_data_store.dart (SearchResults) |
| UREQ-036 | As a user, I can switch between dark and light mode. | P2 | mock_data_store.dart (isDarkMode) |
| UREQ-037 | As a user, I can view other users' profiles. | P1 | user_profile_view.dart |
| UREQ-038 | As a user, I can find potential co-founders or matches. | P2 | startup_match_view.dart |
| UREQ-039 | As a user, I can view gamification progress (achievements, leaderboard). | P2 | gamification_hub_view.dart |

---

## 6. Business Requirements

**PRD-006**

| ID | Requirement | Priority |
|----|------------|----------|
| BREQ-001 | The platform must support at least 1,000 concurrent users at MVP launch. | P1 |
| BREQ-002 | AI analysis costs must remain under $0.50 per validation report at MVP. | P1 |
| BREQ-003 | The platform must comply with applicable data protection regulations. [Needs Legal Review] | P0 |
| BREQ-004 | User data must be encrypted at rest and in transit. | P0 |
| BREQ-005 | The platform must not store or share user ideas with third parties without consent. | P0 |
| BREQ-006 | The MVP must launch on both iOS and Android simultaneously. | P0 |
| BREQ-007 | The app must be distributable through the Apple App Store and Google Play Store. | P0 |
| BREQ-008 | Analytics must be in place from day one to measure the North Star Metric. | P0 |

---

## 7. Functional Requirements

**PRD-007**

### 7.1 Authentication & Onboarding

| ID | Requirement | Priority | MVP |
|----|------------|----------|-----|
| FREQ-001 | App displays animated splash screen with TAEED brand and "VALIDATION NETWORK" tagline. | P0 | Yes |
| FREQ-002 | First-time users see mood selection screen ("How's your entrepreneurial energy today?") with mascot. | P1 | Yes |
| FREQ-003 | First-time users see action selection screen with 4 options: Validate an Idea, Build a Product, Find Co-founder, Explore Startups. | P1 | Yes |
| FREQ-004 | First-time users see 3-page onboarding: "Validate First", "Find Co-founders", "Build Your Network". | P0 | Yes |
| FREQ-005 | Users can sign up with email and password. | P0 | Yes |
| FREQ-006 | Users can log in with email and password. | P0 | Yes |
| FREQ-007 | Users verify their account via OTP. | P0 | Yes |
| FREQ-008 | Users can request password reset. | P0 | Yes |
| FREQ-009 | New users complete a multi-step profile setup wizard. | P0 | Yes |
| FREQ-010 | Onboarding state is persisted (SharedPreferences). Returning users skip onboarding. | P0 | Yes |

### 7.2 Home & Navigation

| ID | Requirement | Priority | MVP |
|----|------------|----------|-----|
| FREQ-020 | Bottom navigation with 5 tabs: Home, Explore, Validate, Network, Profile. | P0 | Yes |
| FREQ-021 | Home screen displays "Decision Intelligence" section with overnight evidence summary. | P1 | Yes |
| FREQ-022 | Home screen displays Decision Center cards (next-best-action recommendations). | P1 | Yes |
| FREQ-023 | Home screen displays category filter chips (All, AI, SaaS, FinTech, HealthTech, Consumer, B2B). | P0 | Yes |
| FREQ-024 | Home screen displays "Explore Validations" list — validations needing feedback, excluding user's own. | P0 | Yes |
| FREQ-025 | Home screen header includes chat and notification icons with unread badges. | P0 | Yes |
| FREQ-026 | Floating action button opens AI Mentor chat as a bottom sheet. | P1 | Yes |
| FREQ-027 | Global floating action button ("+") for creating new content. | P1 | Yes |

### 7.3 Explore & Discovery

| ID | Requirement | Priority | MVP |
|----|------------|----------|-----|
| FREQ-030 | Explore screen titled "Discovery Engine" displays all validations. | P0 | Yes |
| FREQ-031 | Explore screen has horizontal filter chips by industry (All Industries, SaaS, HealthTech, B2B, FinTech, AI, Marketplace). | P0 | Yes |
| FREQ-032 | Explore screen shows loading skeleton while data loads. | P1 | Yes |
| FREQ-033 | Search functionality: search users by name/username/bio, validations by title/problem/tags, posts by title/body/tags. | P1 | Yes |
| FREQ-034 | Search history is maintained (up to 10 items), removable. | P2 | Yes |

### 7.4 Validation System (Core Product Loop)

| ID | Requirement | Priority | MVP |
|----|------------|----------|-----|
| FREQ-040 | Validation Wizard: 8-step creation flow. | P0 | Yes |
| FREQ-041 | Step 1: Problem description (required). | P0 | Yes |
| FREQ-042 | Step 2: Target audience (required). | P0 | Yes |
| FREQ-043 | Step 3: Proposed solution (required). | P0 | Yes |
| FREQ-044 | Step 4: Existing alternatives (required). | P0 | Yes |
| FREQ-045 | Step 5: Differentiator (required). | P0 | Yes |
| FREQ-046 | Step 6: Business model (required). | P0 | Yes |
| FREQ-047 | Step 7: Title (required). | P0 | Yes |
| FREQ-048 | Step 8: AI Critique generation with loading state and results display (problem analysis, competitor overview, market assumptions, risks, missing information, suggested audience, interview questions, bias warnings). | P0 | Yes |
| FREQ-049 | Each step validates that the field is non-empty before allowing progression. | P0 | Yes |
| FREQ-050 | Validation request stores: title, problem, solution, target audience, tags, validation stage, business model, existing alternatives, differentiator, go-to-market, target persona. | P0 | Yes |
| FREQ-051 | Validation request tracks: health score, feedback count, needs feedback flag, upvotes, comments count, views, bookmarks. | P0 | Yes |
| FREQ-052 | Validation detail view shows full request with comments and structured feedback summary. | P0 | Yes |
| FREQ-053 | Users can upvote validation requests (toggle). | P1 | Yes |
| FREQ-054 | Users can bookmark validation requests (toggle). | P1 | Yes |
| FREQ-055 | Users can add comments to validation requests. | P1 | Yes |
| FREQ-056 | Validation Marketplace view shows validations needing feedback. | P0 | Yes |

### 7.5 Structured Feedback

| ID | Requirement | Priority | MVP |
|----|------------|----------|-----|
| FREQ-060 | Structured feedback form collects: problem frequency (Daily/Weekly/Monthly/Rarely/Never), current solution, willingness to pay (boolean), expected price, missing feature, overall rating (1-5), text feedback. | P0 | Yes |
| FREQ-061 | Feedback includes confidence score (0-1, default 0.5). | P1 | Yes |
| FREQ-062 | Feedback supports evidence attachments (image, document, link, audio). | P2 | Yes |
| FREQ-063 | Submitting feedback increments validation's feedback count and updates needs-feedback flag (threshold: 3). | P0 | Yes |
| FREQ-064 | Submitting feedback triggers health score recalculation. | P1 | Yes |
| FREQ-065 | Submitting feedback generates a notification to the validation author. | P0 | Yes |

### 7.6 AI System

| ID | Requirement | Priority | MVP |
|----|------------|----------|-----|
| FREQ-070 | AI Validation Report generates: problem analysis, competitor overview, market assumptions, risks, missing information, suggested audience, interview questions, bias warnings. | P0 | Yes |
| FREQ-071 | AI report generation shows loading state (2-second simulated delay in mock). | P0 | Yes |
| FREQ-072 | AI report is displayed in a dedicated view with sections for each analysis area. | P0 | Yes |
| FREQ-073 | AI Mentor Chat provides conversational AI guidance. Opening message: "I'm your AI Co-Founder. I've reviewed your latest validation metrics." | P1 | Yes |
| FREQ-074 | AI Mentor Chat supports typing indicator animation. | P2 | Yes |
| FREQ-075 | AI generates simulated responses based on predefined templates (mock for MVP). | P0 | Yes |

### 7.7 Evidence & Health Scoring

| ID | Requirement | Priority | MVP |
|----|------------|----------|-----|
| FREQ-080 | Evidence Locker stores typed evidence items: user interview, prototype test, AI critique, expert review, market data. | P1 | Yes |
| FREQ-081 | Each evidence item has: title, content, source ID, confidence level (0-100), creation date. | P1 | Yes |
| FREQ-082 | Startup Health Dashboard displays 10 dimensions as visual scores. | P1 | Yes |
| FREQ-083 | Startup Health dimensions: Problem Strength, Demand Validation, Validation Confidence, Solution Readiness, Product Readiness, PMF Readiness, Execution Velocity, Team Capabilities, Growth Engines, Funding Readiness. | P1 | Yes |
| FREQ-084 | Each health dimension includes: score (0-100), explanation, evidence references, recommendation. | P1 | Yes |
| FREQ-085 | Overall Startup Health score is the average of all dimension scores. | P1 | Yes |
| FREQ-086 | Health scores recalculate when new structured feedback is submitted. | P1 | Yes |

### 7.8 Decision Intelligence

| ID | Requirement | Priority | MVP |
|----|------------|----------|-----|
| FREQ-090 | Decision Intelligence provides: next best action, confidence score, contradictory feedback count, recent evidence summary. | P1 | Yes |
| FREQ-091 | Decision Center displays action cards with types: Gather Evidence, Consider Pivot, Start Building, Expert Review. | P1 | Yes |
| FREQ-092 | Each action card shows: title, description, impact level, confidence, type-specific CTA button. | P1 | Yes |

### 7.9 Networking

| ID | Requirement | Priority | MVP |
|----|------------|----------|-----|
| FREQ-100 | Founder Network screen displays all users with search by name, role, or skill. | P1 | Yes |
| FREQ-101 | User cards display: name, role, avatar, skills, validations count. | P1 | Yes |
| FREQ-102 | Startup Match view displays potential co-founder or collaboration matches. | P2 | Yes |
| FREQ-103 | Tapping a user navigates to their profile. | P1 | Yes |

### 7.10 Messaging

| ID | Requirement | Priority | MVP |
|----|------------|----------|-----|
| FREQ-110 | Chat list displays all conversations ordered by last message time. | P1 | Yes |
| FREQ-111 | Conversations support: pinning, archiving, unread count. | P1 | Yes |
| FREQ-112 | Chat room displays messages in chronological order with sender identification. | P1 | Yes |
| FREQ-113 | Users can send text messages. | P1 | Yes |
| FREQ-114 | Users can add reactions to messages (e.g., ❤️ toggle). | P2 | Yes |
| FREQ-115 | Chat list shows other participant's name and avatar. | P1 | Yes |

### 7.11 Profile & Settings

| ID | Requirement | Priority | MVP |
|----|------------|----------|-----|
| FREQ-120 | Builder profile displays: avatar, name, role, bio, verification status, skills, location, website, Twitter, validation stats, joined date. | P0 | Yes |
| FREQ-121 | Builder profile shows user's validations and posts in tabs. | P1 | Yes |
| FREQ-122 | Edit profile allows editing: name, bio, role, website, Twitter, location, skills. | P0 | Yes |
| FREQ-123 | Startup profile displays startup details: name, tagline, description, industry, stage, logo. | P1 | Yes |
| FREQ-124 | Settings screen with account, notification, and app preferences. | P1 | Yes |
| FREQ-125 | Startup settings for managing startup-level configuration. | P2 | Yes |
| FREQ-126 | User profile view for viewing other users' profiles. | P1 | Yes |
| FREQ-127 | Gamification Hub with achievements and leaderboard tabs. | P2 | Yes |

### 7.12 Notifications

| ID | Requirement | Priority | MVP |
|----|------------|----------|-----|
| FREQ-130 | 8 notification types: feedback, mention, system, milestone, welcome, connection, upvote, follow. | P1 | Yes |
| FREQ-131 | Each notification has: type, actor, message, time, read status, optional action ID. | P1 | Yes |
| FREQ-132 | Mark individual notification as read. | P1 | Yes |
| FREQ-133 | Mark all notifications as read. | P1 | Yes |
| FREQ-134 | Unread notification count displayed as badge on navigation. | P0 | Yes |

### 7.13 Posts (Community Content)

| ID | Requirement | Priority | MVP |
|----|------------|----------|-----|
| FREQ-140 | Users can create posts with: title, body, tags. | P1 | Yes |
| FREQ-141 | Posts support: likes, comments count, bookmarks. | P1 | Yes |
| FREQ-142 | Like and bookmark are toggleable. | P1 | Yes |

---

## 8. Non-Functional Requirements

**PRD-008**

### 8.1 Performance

| ID | Requirement | Target | Priority |
|----|------------|--------|----------|
| NFR-001 | App cold start to interactive | < 3 seconds | P0 |
| NFR-002 | Screen transition time | < 300ms | P0 |
| NFR-003 | API response time (p95) | < 2 seconds [Assumption — backend not built] | P1 |
| NFR-004 | AI report generation time | < 10 seconds [Assumption — depends on provider] | P1 |
| NFR-005 | List scrolling frame rate | 60 fps | P0 |

### 8.2 Reliability

| ID | Requirement | Target | Priority |
|----|------------|--------|----------|
| NFR-010 | App crash rate | < 1% of sessions | P0 |
| NFR-011 | API availability | 99.5% uptime [Assumption — backend not built] | P1 |
| NFR-012 | Data integrity | Zero data loss for user-created content | P0 |

### 8.3 Scalability

| ID | Requirement | Target | Priority |
|----|------------|--------|----------|
| NFR-020 | Concurrent users (MVP) | 1,000 | P1 |
| NFR-021 | Validation requests (MVP) | 10,000 | P1 |
| NFR-022 | Users (MVP Year 1) | 50,000 | P2 |

### 8.4 Security

| ID | Requirement | Priority |
|----|------------|----------|
| NFR-030 | All data in transit encrypted via TLS 1.2+ | P0 |
| NFR-031 | All data at rest encrypted | P0 |
| NFR-032 | Authentication tokens stored securely (no plain text) | P0 |
| NFR-033 | Input validation on all user inputs | P0 |
| NFR-034 | Rate limiting on authentication endpoints | P0 |

### 8.5 Accessibility

| ID | Requirement | Priority |
|----|------------|----------|
| NFR-040 | All interactive elements have semantic labels | P1 |
| NFR-041 | Minimum touch target size: 44x44 points | P1 |
| NFR-042 | Support for screen readers (VoiceOver, TalkBack) | P2 |
| NFR-043 | Sufficient color contrast (WCAG AA) | P1 |

### 8.6 Compatibility

| ID | Requirement | Priority |
|----|------------|----------|
| NFR-050 | iOS 16+ | P0 |
| NFR-051 | Android 10+ (API 29+) | P0 |
| NFR-052 | Flutter SDK ≥ 3.3.0 | Confirmed |

---

## 9. MVP Scope

**PRD-009**

Inherits: VISION-012

### 9.1 MVP Feature Matrix

| Feature Area | Included | Excluded |
|-------------|----------|----------|
| Onboarding (splash, mood, action, pages, auth, profile setup) | ✅ | — |
| Validation Wizard (8-step creation) | ✅ | — |
| AI Validation Report | ✅ | — |
| Structured Feedback Form | ✅ | — |
| Evidence Locker | ✅ | — |
| Startup Health Dashboard (10 dimensions) | ✅ | — |
| Decision Intelligence (next-best-action) | ✅ | — |
| Home Feed (validations needing feedback) | ✅ | — |
| Explore / Discovery Engine | ✅ | — |
| Search (users, validations, posts) | ✅ | — |
| Bottom Navigation (5 tabs) | ✅ | — |
| Messaging (1-on-1 chat) | ✅ | — |
| AI Mentor Chat | ✅ | — |
| Notifications (8 types) | ✅ | — |
| Builder Profile | ✅ | — |
| Edit Profile | ✅ | — |
| Community Posts | ✅ | — |
| Network / Founder Directory | ✅ | — |
| Settings | ✅ | — |
| Payments / Monetization | — | ❌ |
| Video/Audio Feedback | — | ❌ |
| Admin Dashboard | — | ❌ |
| Multi-language | — | ❌ |
| Push Notifications | — | ❌ |
| Offline Mode | — | ❌ |
| Public API | — | ❌ |
| Advanced Search (Algolia) | — | ❌ |

### 9.2 MVP Backend Requirements [Needs Decision]

The current prototype uses mock data. The MVP requires a real backend. Minimum backend requirements:

| Area | Requirement | Status |
|------|------------|--------|
| Authentication | Email/password auth with OTP verification | Needs Decision (provider) |
| Database | Users, startups, validations, feedback, evidence, conversations, messages, notifications, posts, comments | Needs Decision (technology) |
| Storage | User avatars, evidence file uploads | Needs Decision (provider) |
| AI Integration | LLM API for validation reports and AI mentor | Needs Decision (provider) |
| Realtime | Chat messages, notifications | Needs Decision (WebSockets vs. provider solution) |

---

## 10. Post-MVP Scope

**PRD-010**

| Feature | Priority | Reason for Deferral |
|---------|----------|-------------------|
| Payments / Subscription tiers | P1 | Validate core loop before monetizing |
| Push notifications | P1 | In-app notifications sufficient for MVP |
| Video/audio evidence and feedback | P2 | Text-based feedback validates the model first |
| Advanced analytics for founders | P2 | Basic health scoring is sufficient |
| Marketplace for paid validation services | P2 | Requires payment infrastructure |
| Admin/moderation dashboard | P1 | Manual moderation acceptable at MVP scale |
| Multi-language support | P3 | English-first market |
| Offline-first architecture | P2 | Network-required acceptable for MVP |
| Public API | P3 | No external integration need |
| Co-founder matching algorithm | P2 | Manual networking sufficient for MVP |
| Gamification rewards (redeemable tokens) | P2 | Status-based gamification first |
| Startup case studies / public validation reports | P2 | Privacy considerations need resolution |
| Integration with Notion, Linear, Figma | P3 | No user demand validated |
| Web application | P2 | Mobile-first strategy |

---

## 11. Feature Priorities

**PRD-011**

Full feature catalogue in DOC-05. Summary priority tiers:

### P0 — Critical (Must Have for MVP Launch)

- Authentication (signup, login, OTP, password reset)
- Onboarding flow
- Profile setup
- Validation Wizard (8-step creation)
- AI Validation Report
- Structured Feedback form
- Home feed (validations needing feedback)
- Explore / Discovery
- Bottom navigation (5 tabs)
- Notifications (in-app with badges)

### P1 — High (Should Have for MVP Launch)

- Evidence Locker
- Startup Health Dashboard
- Decision Intelligence
- Messaging (1-on-1 chat)
- AI Mentor Chat
- Community posts
- Founder Network / search
- Builder Profile
- Edit Profile
- Settings
- Category filtering
- Comments on validations

### P2 — Medium (Nice to Have for MVP, Can Defer)

- Startup matching
- Gamification Hub
- Message reactions
- Validation Passport
- Proof of Validation tokens
- Theme switching (dark/light)
- Search history
- Evidence attachments on feedback
- Startup settings

### P3 — Later (Post-MVP)

- Payments
- Admin dashboard
- Multi-language
- Offline mode
- Push notifications
- Public API
- Web app

---

## 12. Acceptance Criteria

**PRD-012**

### 12.1 MVP Launch Criteria

| Criterion | Condition |
|-----------|-----------|
| Authentication works end-to-end | Users can sign up, verify, login, reset password |
| Core validation loop functions | Create validation → Receive AI report → Receive ≥ 1 structured feedback |
| Health scoring updates | Health score recalculates after feedback submission |
| Messaging works | Users can send and receive 1-on-1 messages |
| Notifications work | In-app notifications generated for feedback, comments, upvotes |
| App Store / Play Store approved | App passes review guidelines |
| No P0 bugs | Zero known crash-level or data-loss bugs |
| Analytics instrumented | North Star Metric, activation, and retention events tracked |
| Security baseline met | TLS, auth token security, input validation, rate limiting |

### 12.2 Definition of Done (per Feature)

A feature is "done" when:

1. Functional requirements are implemented and tested.
2. UI matches design system specifications (DOC-09, DOC-10).
3. Error states are handled (DOC-13).
4. Analytics events are instrumented (DOC-14).
5. Accessibility requirements are met (DOC-08).
6. QA test cases pass (DOC-16).
7. Security requirements are met (DOC-18).
8. Code is reviewed and merged.

---

## 13. Dependencies

**PRD-013**

| Dependency | Type | Status | Impact |
|-----------|------|--------|--------|
| Backend technology choice | Blocking | Needs Decision | Cannot build real API layer |
| AI provider choice | Blocking for AI features | Needs Decision | AI reports and mentor depend on this |
| App Store developer accounts | Blocking for launch | [Needs Validation] | Cannot distribute without accounts |
| Legal review of Terms & Privacy | Blocking for launch | Not Started | Required for App Store compliance |
| Design asset finalization | Non-blocking (code has design system) | In Progress | Brand assets, app icon, etc. |

---

## 14. Constraints

**PRD-014**

| Constraint | Impact |
|-----------|--------|
| **Flutter SDK ≥ 3.3.0** | All features must work within Flutter's capabilities. |
| **No backend exists** | All backend work is greenfield. Mock data must be replaceable. |
| **Single developer / small team** [Assumption] | Feature scope must be realistic for team size. |
| **Mobile-first** | Web is not targeted for MVP. |
| **Dark mode default** | All UI must be designed for dark mode first, light mode secondary. |
| **AI cost budget** | AI features must be cost-effective. No unlimited API calls. |

---

## 15. Risks

**PRD-015**

Inherits: VISION-019. Additional PRD-specific risks:

| ID | Risk | Likelihood | Impact | Mitigation |
|----|------|------------|--------|------------|
| PRISK-001 | Validation Wizard is too long (8 steps) and causes drop-off. | Medium | High | Track step completion rates. Consider combining steps post-MVP. |
| PRISK-002 | AI reports are generic and users find them unhelpful. | Medium | High | Tune prompts. Add feedback mechanism. Consider multiple AI models. |
| PRISK-003 | Structured feedback form is too burdensome for validators. | Medium | High | Track completion rates. Consider shortened forms for quick feedback. |
| PRISK-004 | Two-sided marketplace fails to achieve liquidity. | High | Critical | AI Mentor as fallback. Reciprocity requirement. Community seeding. |
| PRISK-005 | Mock data architecture makes backend integration difficult. | Low | Medium | MockDataStore is well-abstracted. Repository pattern migration path. |

---

## 16. Success Metrics

**PRD-016**

Inherits: VISION-016, VISION-017

| Metric | Target (Month 1) | Target (Month 3) | Status |
|--------|------------------|-------------------|--------|
| North Star: Validations with ≥ 3 feedback in 7 days | 50 | 200 | Proposed |
| Signups | 500 | 2,000 | Proposed |
| Activation (created ≥ 1 validation in 7 days) | > 30% | > 35% | Proposed |
| D7 Retention | > 40% | > 45% | Proposed |
| Feedback per validation (average) | ≥ 3 | ≥ 5 | Proposed |
| AI report usefulness rating | > 60% "useful" | > 70% | Proposed |
| Crash rate | < 1% | < 0.5% | Proposed |

---

## 17. Edge Cases

**PRD-017**

| ID | Edge Case | Expected Behavior | Owner |
|----|-----------|-------------------|-------|
| EC-001 | User submits validation with minimum text (1 character). | Pass validation but flag for review. AI may generate low-quality report. | DOC-04, DOC-15 |
| EC-002 | User submits duplicate validation request. | Allow (user may iterate). No automatic deduplication. | DOC-04 |
| EC-003 | Validator provides feedback on their own validation. | Prevent. User cannot feedback their own validation. | DOC-04 |
| EC-004 | AI API is down when user requests validation report. | Show error state. Allow retry. Save validation without AI report. | DOC-13 |
| EC-005 | User deletes their account while having active validations. | Validations remain anonymized. Feedback is preserved. | DOC-04, DOC-18 |
| EC-006 | User has 0 validations and visits the dashboard. | Show empty state: "No Active Experiments. Launch a validation request." | DOC-08 |
| EC-007 | User searches with empty query. | Show search history or suggested categories. | DOC-07 |
| EC-008 | Network timeout during feedback submission. | Show error. Preserve local draft. Allow retry. | DOC-13 |
| EC-009 | User receives notification for deleted content. | Notification links to an empty/error state. Show "Content not available." | DOC-13 |
| EC-010 | Two users send messages simultaneously. | Messages appear in correct chronological order. No data loss. | DOC-12 |

---

## 18. Product Rules References

**PRD-018**

Full product rules in DOC-04. Key cross-references:

| Area | Reference |
|------|-----------|
| Account rules (creation, verification, deletion) | DOC-04, Section 1 |
| Validation rules (creation, feedback, scoring) | DOC-04, Section 3 |
| Content rules (posts, comments, moderation) | DOC-04, Section 4 |
| AI rules (limits, safety, hallucination controls) | DOC-04 Section 7, DOC-15 |
| Privacy rules (data handling, sharing, retention) | DOC-04 Section 8, DOC-18, DOC-20 |

---

## 19. Decision Registry Extract

**PRD-019**

New decisions established by this document:

| ID | Decision | Status | Affected Documents |
|----|----------|--------|-------------------|
| DEC-016 | **Validation Wizard has 8 steps.** Steps: Problem, Audience, Solution, Alternatives, Differentiator, Business Model, Title, AI Critique. | Confirmed | 04, 05, 06, 07, 08, 11, 16 |
| DEC-017 | **Structured Feedback form has 7 fields + confidence + evidence.** Fields: problem frequency, current solution, willingness to pay, expected price, missing feature, overall rating, text feedback. | Confirmed | 04, 05, 06, 07, 08, 11, 12, 14, 16 |
| DEC-018 | **A validation "needs feedback" until it has ≥ 3 structured feedback responses.** | Confirmed | 04, 05, 11, 12 |
| DEC-019 | **AI Validation Report contains 8 sections.** Sections: problem analysis, competitor overview, market assumptions, risks, missing information, suggested audience, interview questions, bias warnings. | Confirmed | 05, 15, 16 |
| DEC-020 | **8 notification types are supported.** Types: feedback, mention, system, milestone, welcome, connection, upvote, follow. | Confirmed | 05, 07, 11, 12 |
| DEC-021 | **Bottom navigation has 5 tabs: Home, Explore, Validate, Network, Profile.** | Confirmed | 06, 07, 08, 09, 11 |
| DEC-022 | **Search covers 3 entity types: users, validations, posts.** | Confirmed | 05, 06, 11, 12 |

---

## 20. Document Status

**STATUS:** Draft  
**REVIEW STATE:** Needs Review

### Open Questions

| ID | Question | Impact | Owner |
|----|----------|--------|-------|
| OQ-008 | Should the validation wizard allow saving drafts? | Affects FREQ-040, UX, backend | Product |
| OQ-009 | Should validators be required to provide feedback to unlock their own validation results? (reciprocity) | Affects UREQ-020, growth loop | Product / Growth |
| OQ-010 | What is the minimum text length for validation wizard fields? | Affects FREQ-041–047, input validation | Product |
| OQ-011 | Should validation requests have privacy settings (public / semi-public / private)? | Affects FREQ-050, DOC-18, DOC-20 | Product / Privacy |
| OQ-012 | What is the maximum number of validations a free user can create per month? | Affects FREQ-040, business model | Product / Business |

### Dependencies

- DOC-01 (Product Vision & Strategy) — Approved decisions DEC-001 through DEC-015.

### Affected Documents

- DOC-03 through DOC-22 inherit requirements from this document.

### Next Actions

1. Obtain review of functional requirements matrix.
2. Resolve Open Questions OQ-008 through OQ-012.
3. Proceed to DOC-03 (User Personas & Psychology).

### Consistency Check Against DOC-01

| Check | Result |
|-------|--------|
| All VISION decisions (DEC-001 to DEC-015) respected | ✅ |
| Non-goals (VISION-013) not contradicted | ✅ |
| MVP scope (VISION-012) aligned | ✅ |
| Strategic principles (VISION-011) reflected in requirements | ✅ |
| North Star Metric (VISION-016) supported by requirements | ✅ |
| No features invented beyond codebase evidence | ✅ |
| Terminology consistent (Validation Request, Structured Feedback, Decision Intelligence, Startup Health, Evidence Locker) | ✅ |
