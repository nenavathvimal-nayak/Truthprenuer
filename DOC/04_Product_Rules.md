# DOCUMENT 04 — PRODUCT RULES & REGULATIONS

**Document ID:** DOC-04  
**Version:** 1.0  
**Last Updated:** 2026-08-20  
**Owner:** Product Management  
**Status:** Draft  
**Upstream Dependencies:** DOC-01 (Vision), DOC-02 (PRD), DOC-03 (Personas)  
**Downstream Dependents:** DOC-05 through DOC-22

---

## Table of Contents

1. [Account Rules](#1-account-rules)
2. [Profile Rules](#2-profile-rules)
3. [Validation Rules](#3-validation-rules)
4. [Structured Feedback Rules](#4-structured-feedback-rules)
5. [Evidence Rules](#5-evidence-rules)
6. [Health Scoring Rules](#6-health-scoring-rules)
7. [Decision Intelligence Rules](#7-decision-intelligence-rules)
8. [Post & Content Rules](#8-post--content-rules)
9. [Comment Rules](#9-comment-rules)
10. [Networking Rules](#10-networking-rules)
11. [Messaging Rules](#11-messaging-rules)
12. [Notification Rules](#12-notification-rules)
13. [AI Rules](#13-ai-rules)
14. [Privacy Rules](#14-privacy-rules)
15. [Moderation Rules](#15-moderation-rules)
16. [Deletion Rules](#16-deletion-rules)
17. [Visibility Rules](#17-visibility-rules)
18. [State Transitions](#18-state-transitions)
19. [Permissions](#19-permissions)
20. [Document Status](#20-document-status)

---

## Governing Principle

**RULE-000**

> These rules define deterministic product behavior. Where a rule exists, implementation MUST follow it exactly. Where no rule exists, the implementation team should request a rule before making a behavioral decision.

Authoritative source for product behavior: **This document (DOC-04).**  
AI-specific rules are summarized here and expanded in DOC-15.  
Moderation-specific rules are summarized here and expanded in DOC-17.  
Security/privacy rules are summarized here and expanded in DOC-18.

---

## 1. Account Rules

**RULE-001**

### 1.1 Account Creation

| Rule ID | Rule | Deterministic |
|---------|------|---------------|
| RULE-001-A | Users sign up with email and password. | Yes |
| RULE-001-B | Email must be a valid email format (RFC 5322). | Yes |
| RULE-001-C | Password must be ≥ 8 characters. [Assumption — Needs Decision on exact policy] | Yes |
| RULE-001-D | Account requires OTP verification via email before full access. | Yes |
| RULE-001-E | Username must be unique, case-insensitive. | Yes |
| RULE-001-F | Username must be 3–30 characters, alphanumeric + underscores only. [Assumption] | Yes |
| RULE-001-G | One account per email address. | Yes |
| RULE-001-H | Users must accept Terms of Service before account creation. | Yes |

### 1.2 Authentication

| Rule ID | Rule |
|---------|------|
| RULE-001-I | Login requires email + password. |
| RULE-001-J | Failed login shows generic "Invalid email or password" (no credential enumeration). |
| RULE-001-K | After 5 failed login attempts, account is temporarily locked for 15 minutes. [Assumption] |
| RULE-001-L | Password reset requires email verification via OTP. |
| RULE-001-M | Auth tokens have a defined expiry (see DOC-18). |
| RULE-001-N | Logout clears local session and tokens. |

### 1.3 Account States

| State | Description | Allowed Actions |
|-------|-------------|----------------|
| **Unverified** | Created but OTP not completed | Resend OTP, complete verification |
| **Active** | Verified and in good standing | All platform features |
| **Suspended** | Temporarily disabled by moderation | View-only. Cannot create content. Can appeal. |
| **Deleted** | User-initiated deletion | None. Data handled per DOC-16 deletion rules. |

---

## 2. Profile Rules

**RULE-002**

### 2.1 Required Fields

| Field | Required for | Rules |
|-------|-------------|-------|
| Name | Account setup | 1–100 characters. Cannot be empty. |
| Username | Account setup | 3–30 characters. Alphanumeric + underscore. Unique. |
| Bio | Not required | 0–500 characters. [Assumption] |
| Role | Account setup | Selected from predefined list or free text. [Needs Decision] |

### 2.2 Optional Fields

| Field | Rules |
|-------|-------|
| Avatar | Image upload. Max 5MB. JPG/PNG. [Assumption] |
| Website | Valid URL format or empty. |
| Twitter handle | Valid handle format (@username) or empty. |
| Skills | Array of strings. Max 10 skills. Each skill max 50 characters. [Assumption] |
| Location | Free text. Max 100 characters. |
| Validator Expertise | Array of strings. Used for Validation Passport. |

### 2.3 Profile Visibility

| Rule ID | Rule |
|---------|------|
| RULE-002-A | All profiles are public by default. Other users can view name, bio, role, skills, validation stats. |
| RULE-002-B | Email is NEVER publicly visible. |
| RULE-002-C | Validation Passport data (verified expertise, ideas improved, trust rating, tokens) is publicly visible. |

### 2.4 Verification

| Rule ID | Rule |
|---------|------|
| RULE-002-D | `isVerified` flag requires manual verification process. [Needs Decision — criteria for verification] |
| RULE-002-E | Verified badge is displayed on profile and in all contexts where the user's name appears. |

---

## 3. Validation Rules

**RULE-003**

### 3.1 Validation Request Creation

| Rule ID | Rule |
|---------|------|
| RULE-003-A | A validation request requires ALL of: title, problem, solution, target audience. (Confirmed: wizard enforces non-empty) |
| RULE-003-B | Additional fields (business model, existing alternatives, differentiator, go-to-market, target persona) are collected in the wizard but may be empty. [Needs Validation] |
| RULE-003-C | Validation requests are created by authenticated users only. |
| RULE-003-D | Each validation request receives a unique ID. |
| RULE-003-E | Validation requests are timestamped with creation date. |
| RULE-003-F | Newly created validations have: upvotes=1, commentsCount=0, isUpvoted=true (auto-upvote by author), views=0, healthScore=0, feedbackCount=0, needsFeedback=true. |
| RULE-003-G | Tags are optional. Maximum 5 tags per validation. [Assumption] |

### 3.2 Validation Stages

| Stage | Definition |
|-------|-----------|
| **Idea** | Concept only. No prototype. |
| **Prototype** | Early mockup or demo exists. |
| **MVP** | Minimum viable product is built. |
| **Launched** | Product is live with users. |
| **Growing** | Product has traction and growth. |

| Rule ID | Rule |
|---------|------|
| RULE-003-H | Default stage is "Idea". |
| RULE-003-I | Stage can be updated by the author at any time. |
| RULE-003-J | Stage affects how feedback is weighted. [Proposed — Needs Decision] |

### 3.3 Validation Ownership

| Rule ID | Rule |
|---------|------|
| RULE-003-K | Only the author can edit their validation request. |
| RULE-003-L | Only the author can delete their validation request. |
| RULE-003-M | Deletion removes the validation but preserves anonymized feedback data for platform analytics. [Proposed] |

### 3.4 Upvoting

| Rule ID | Rule |
|---------|------|
| RULE-003-N | Any authenticated user can upvote a validation request. |
| RULE-003-O | Upvote is a toggle (upvote/un-upvote). |
| RULE-003-P | Users CANNOT upvote their own validation (auto-upvote on creation is the exception). [Needs Validation — current code allows] |
| RULE-003-Q | Upvote count is publicly visible. |

### 3.5 Bookmarking

| Rule ID | Rule |
|---------|------|
| RULE-003-R | Any authenticated user can bookmark a validation request. |
| RULE-003-S | Bookmark is a toggle. |
| RULE-003-T | Bookmarks are private (only visible to the bookmarking user). |

---

## 4. Structured Feedback Rules

**RULE-004**

### 4.1 Feedback Submission

| Rule ID | Rule |
|---------|------|
| RULE-004-A | Only authenticated users can submit structured feedback. |
| RULE-004-B | **A user CANNOT submit feedback on their own validation.** (Confirmed: validationsNeedingFeedback filters out own validations) |
| RULE-004-C | Structured feedback fields: problem frequency (required), current solution (required), willingness to pay (required, boolean), expected price (required), missing feature (required), overall rating (required, 1–5), text feedback (required). |
| RULE-004-D | Confidence score defaults to 0.5 (range 0.0–1.0). User can adjust. |
| RULE-004-E | Evidence attachments are optional. Types: image, document, link, audio. |
| RULE-004-F | One user can submit only ONE structured feedback response per validation request. [Proposed — Needs Decision] |

### 4.2 Feedback Effects

| Rule ID | Rule |
|---------|------|
| RULE-004-G | Submitting feedback increments the validation's feedbackCount by 1. |
| RULE-004-H | When feedbackCount reaches ≥ 3, needsFeedback is set to false. (Confirmed from code) |
| RULE-004-I | Submitting feedback triggers Startup Health recalculation. (Confirmed from code) |
| RULE-004-J | Submitting feedback generates a notification to the validation author. (Confirmed from code) |
| RULE-004-K | Feedback is immutable after submission. [Proposed — Needs Decision on editing] |

### 4.3 Problem Frequency Values

| Value | Display |
|-------|---------|
| daily | "Daily" |
| weekly | "Weekly" |
| monthly | "Monthly" |
| rarely | "Rarely" |
| never | "Never" |

### 4.4 Overall Rating Scale

| Rating | Meaning |
|--------|---------|
| 1 | Poor — Fundamental issues |
| 2 | Below average — Significant gaps |
| 3 | Average — Some promise, needs work |
| 4 | Good — Solid foundation |
| 5 | Excellent — Strong potential |

---

## 5. Evidence Rules

**RULE-005**

| Rule ID | Rule |
|---------|------|
| RULE-005-A | Evidence items belong to a startup (via startupId). |
| RULE-005-B | 5 evidence types: User Interview, Prototype Test, AI Critique, Expert Review, Market Data. |
| RULE-005-C | Each evidence item has: title, content, confidence level (0–100), creation date. |
| RULE-005-D | Source ID is optional (links to the feedback or external source that generated this evidence). |
| RULE-005-E | Evidence is created by the validation/startup owner only. [Proposed] |
| RULE-005-F | AI Critique evidence is automatically generated when an AI Validation Report is created. [Proposed] |
| RULE-005-G | Evidence items can be deleted by their creator. |

---

## 6. Health Scoring Rules

**RULE-006**

### 6.1 Dimensions

| Dimension | What It Measures |
|-----------|-----------------|
| Problem Strength | How painful and urgent is the problem? |
| Demand Validation | Is there empirical evidence that people want this? |
| Validation Confidence | How rigorous and reliable is the validation evidence? |
| Solution Readiness | Does the solution effectively address the problem? |
| Product Readiness | Is the product built and functioning? |
| PMF Readiness | Are there early signs of Product-Market Fit? |
| Execution Velocity | Is the team moving quickly and shipping? |
| Team Capabilities | Does the team have the right skills? |
| Growth Engines | Are there scalable channels to acquire users? |
| Funding Readiness | Is the startup prepared for investment? |

### 6.2 Scoring Rules

| Rule ID | Rule |
|---------|------|
| RULE-006-A | Each dimension scores 0–100. |
| RULE-006-B | Overall health score = average of all dimension scores, rounded to nearest integer. (Confirmed from code) |
| RULE-006-C | Scores recalculate when new structured feedback is submitted. (Confirmed from code) |
| RULE-006-D | Score calculation for Problem Strength: average overall rating × 20. (Confirmed from code) |
| RULE-006-E | Score calculation for Demand: count of willingness-to-pay "yes" responses × 30, clamped to 0–100. (Confirmed from code) |
| RULE-006-F | Remaining 8 dimensions are calculated from evidence and feedback when available, defaulting to 0 when insufficient data exists. [Confirmed — currently only 2 dimensions have formulas] |
| RULE-006-G | Health scores are never manually editable. They are computed values only. |
| RULE-006-H | A health score is only meaningful after ≥ 3 feedback responses. Below that threshold, display "Insufficient Data" label. [Proposed] |

---

## 7. Decision Intelligence Rules

**RULE-007**

| Rule ID | Rule |
|---------|------|
| RULE-007-A | Decision Intelligence provides: next best action (string), confidence (0–1.0), contradictory feedback count (integer), recent evidence summary (string). |
| RULE-007-B | Action types: Gather Evidence, Consider Pivot, Start Building, Expert Review. |
| RULE-007-C | Decision Intelligence is advisory only. **It does NOT make decisions for the user.** (Inherits: SP-003, DEC-010) |
| RULE-007-D | Contradictory feedback count must be ≥ 0 and reflect actual contradictions in structured feedback. |
| RULE-007-E | Confidence scores must be calibrated. If data is limited, confidence should be low (< 0.5). Never fabricate high confidence. |
| RULE-007-F | If no structured feedback exists, Decision Intelligence shows a default state: "Gather 3 more structured feedback responses." |

---

## 8. Post & Content Rules

**RULE-008**

| Rule ID | Rule |
|---------|------|
| RULE-008-A | Authenticated users can create posts with: title (required), body (required), tags (optional). |
| RULE-008-B | Title: 1–200 characters. [Assumption] |
| RULE-008-C | Body: 1–5000 characters. [Assumption] |
| RULE-008-D | Tags: max 5, each max 30 characters. [Assumption] |
| RULE-008-E | Posts can be liked (toggle). |
| RULE-008-F | Posts can be bookmarked (toggle). |
| RULE-008-G | Like/bookmark counts are public. Bookmarks are private to the user. |
| RULE-008-H | Only the author can edit or delete their post. |

---

## 9. Comment Rules

**RULE-009**

| Rule ID | Rule |
|---------|------|
| RULE-009-A | Authenticated users can comment on validation requests. |
| RULE-009-B | Comments require non-empty text. |
| RULE-009-C | Comments display: author name, author role, text, timestamp. |
| RULE-009-D | Comments can be liked (toggle). |
| RULE-009-E | Comment order: chronological (oldest first). [Assumption — Needs Decision] |
| RULE-009-F | Comments are distinct from Structured Feedback. Comments are informal; Structured Feedback is the core validation mechanism. |
| RULE-009-G | Adding a comment increments the validation's commentsCount. (Confirmed from code) |

---

## 10. Networking Rules

**RULE-010**

| Rule ID | Rule |
|---------|------|
| RULE-010-A | All users in the Founder Network are browsable and searchable. |
| RULE-010-B | Search filters: name, role, skills. (Confirmed from code) |
| RULE-010-C | Tapping a user card navigates to their profile. |
| RULE-010-D | Startup Match shows potential matches based on complementary skills. [Proposed — matching algorithm TBD] |
| RULE-010-E | No connection/follow request mechanism in MVP. All profiles are viewable. [Assumption — Needs Decision] |

---

## 11. Messaging Rules

**RULE-011**

| Rule ID | Rule |
|---------|------|
| RULE-011-A | Any authenticated user can send a message to any other user. [Assumption — Needs Decision on consent requirement] |
| RULE-011-B | Messages are 1-on-1 conversations. No group chat in MVP. |
| RULE-011-C | Conversations track: last message, last message time, unread count, pinned status, archived status. |
| RULE-011-D | Users can pin conversations (toggle). |
| RULE-011-E | Users can archive conversations (toggle). |
| RULE-011-F | Messages support emoji reactions (toggle, one reaction per message per user). |
| RULE-011-G | Messages are ordered chronologically within a conversation. |
| RULE-011-H | Unread message count is displayed as a badge in the navigation. |
| RULE-011-I | Messages cannot be edited or deleted after sending in MVP. [Proposed] |

---

## 12. Notification Rules

**RULE-012**

### 12.1 Notification Types

| Type | Icon | Trigger |
|------|------|---------|
| feedback | doc.text.magnifyingglass | Someone submits structured feedback on your validation |
| mention | at.circle.fill | Someone mentions you in a comment or post |
| system | bell.fill | Platform-level announcement |
| milestone | star.circle.fill | User reaches a milestone (e.g., 5 feedbacks received) |
| welcome | hand.wave.fill | Account creation complete |
| connection | person.2.fill | Someone connects with you |
| upvote | arrow.up.circle.fill | Someone upvotes your validation |
| follow | person.2.fill | Someone follows you [Assumption — follow system not confirmed] |

### 12.2 Rules

| Rule ID | Rule |
|---------|------|
| RULE-012-A | Notifications are in-app only for MVP. No push notifications. |
| RULE-012-B | Each notification has: type, actor ID, actor name, message, time, read status, optional action ID. |
| RULE-012-C | Notifications appear in reverse chronological order (newest first). |
| RULE-012-D | Users can mark individual notifications as read. |
| RULE-012-E | Users can mark all notifications as read. |
| RULE-012-F | Unread count badge appears in the home header navigation. |
| RULE-012-G | Tapping a notification with an actionId navigates to the relevant content (e.g., validation detail). |
| RULE-012-H | Do NOT generate notifications for the user's own actions (e.g., don't notify "You upvoted your own validation"). |

---

## 13. AI Rules (Summary)

**RULE-013**

Full AI rules in DOC-15. Critical rules summarized here for cross-reference:

| Rule ID | Rule |
|---------|------|
| RULE-013-A | AI is an assistant, not an authority. (Inherits: DEC-010, SP-003) |
| RULE-013-B | AI MUST NOT fabricate evidence, users, research, validation results, or business facts. |
| RULE-013-C | AI MUST include uncertainty indicators in all analysis. |
| RULE-013-D | AI Validation Report is generated once per validation request. Updates require re-generation. [Proposed] |
| RULE-013-E | AI Mentor Chat responses must be helpful, honest, and non-manipulative. |
| RULE-013-F | AI MUST NOT provide legal, financial, medical, or tax advice. |
| RULE-013-G | All AI outputs must be clearly labeled as AI-generated. |
| RULE-013-H | Users can provide feedback on AI quality (useful/not useful). [Proposed] |

---

## 14. Privacy Rules (Summary)

**RULE-014**

Full privacy rules in DOC-18 and DOC-20. Critical rules summarized here:

| Rule ID | Rule |
|---------|------|
| RULE-014-A | Email addresses are never publicly visible. |
| RULE-014-B | User-created content (validation requests, feedback, posts) is visible to all authenticated users unless privacy settings are implemented. [Needs Decision — OQ-011] |
| RULE-014-C | Bookmarks are private. Only visible to the bookmarking user. |
| RULE-014-D | Search history is local to the device. Not synced or shared. (Confirmed: SharedPreferences) |
| RULE-014-E | AI analysis of user ideas must not be shared with other users or third parties. |
| RULE-014-F | User data is not sold to third parties. |
| RULE-014-G | Analytics data is anonymized/aggregated. Individual user behavior is not exposed. |

---

## 15. Moderation Rules (Summary)

**RULE-015**

Full moderation rules in DOC-17. Critical rules summarized here:

| Rule ID | Rule |
|---------|------|
| RULE-015-A | Content that violates community standards is removable. |
| RULE-015-B | Users can report content or users. |
| RULE-015-C | Harassment, abuse, hate speech, threats, and illegal content result in account suspension or deletion. |
| RULE-015-D | Spam validation requests (low-effort, promotional, duplicated) can be removed. |
| RULE-015-E | Fake or manipulated feedback is a violation. |
| RULE-015-F | Moderation actions are logged for audit. |
| RULE-015-G | Users can appeal moderation decisions. |

---

## 16. Deletion Rules

**RULE-016**

### 16.1 Content Deletion

| Content Type | Deletion Behavior |
|-------------|-------------------|
| Validation Request | Author can delete. Validation is removed from feeds. Existing feedback is anonymized and retained for analytics. [Proposed] |
| Post | Author can delete. Post is removed immediately. |
| Comment | Author can delete their own comment. Comment count on validation decrements. [Proposed] |
| Message | Messages cannot be deleted in MVP. [Proposed] |
| Evidence Item | Creator can delete. Item is removed from Evidence Locker. |

### 16.2 Account Deletion

| Rule ID | Rule |
|---------|------|
| RULE-016-A | Users can request account deletion from Settings. |
| RULE-016-B | Account deletion is irreversible. |
| RULE-016-C | Upon deletion: profile is removed, validations are anonymized (author shown as "Deleted User"), feedback provided by the user is anonymized, conversations are removed from the deleted user's side. |
| RULE-016-D | Account deletion does NOT remove: anonymized feedback data, anonymized analytics data, content that other users depend on (e.g., feedback on someone else's validation). [Proposed] |
| RULE-016-E | Data retention timeline after deletion: 30 days for recovery request, then permanent purge. [Assumption — Needs Legal Review] |

---

## 17. Visibility Rules

**RULE-017**

| Content | Visibility |
|---------|-----------|
| Validation requests | All authenticated users (MVP). [Needs Decision — OQ-011 re: privacy controls] |
| Structured feedback | Validation author + feedback author + public readers |
| Comments | All authenticated users |
| Posts | All authenticated users |
| User profiles | All authenticated users (except email) |
| Evidence Locker | Validation/startup owner only [Proposed] |
| Health scores | Validation/startup owner + potentially public [Needs Decision] |
| AI reports | Validation author only [Proposed] |
| Conversations | Participants only |
| Messages | Sender + receiver only |
| Notifications | Recipient only |
| Bookmarks | Owner only |
| Search history | Owner only (local device) |

---

## 18. State Transitions

**RULE-018**

### 18.1 Validation Request Lifecycle

```
DRAFT [Post-MVP — not in current code]
  ↓ submit
PUBLISHED (needsFeedback = true)
  ↓ receives feedback (feedbackCount increments)
PUBLISHED (needsFeedback = true, feedbackCount < 3)
  ↓ feedbackCount reaches 3
PUBLISHED (needsFeedback = false)
  ↓ author deletes
DELETED (anonymized)
```

### 18.2 User Account Lifecycle

```
UNVERIFIED
  ↓ OTP verified
ACTIVE
  ↓ moderation action
SUSPENDED
  ↓ appeal approved
ACTIVE
  ↓ user requests deletion
DELETED
```

### 18.3 Conversation Lifecycle

```
ACTIVE (unread > 0)
  ↓ messages read
ACTIVE (unread = 0)
  ↓ user archives
ARCHIVED
  ↓ user un-archives
ACTIVE
  ↓ user pins
PINNED
  ↓ user unpins
ACTIVE
```

---

## 19. Permissions

**RULE-019**

### 19.1 Permission Matrix

| Action | Unauthenticated | Authenticated (Own) | Authenticated (Other's) | Suspended |
|--------|----------------|--------------------|-----------------------|-----------|
| View validation | ❌ | ✅ | ✅ | ✅ (view only) |
| Create validation | ❌ | ✅ | — | ❌ |
| Edit validation | ❌ | ✅ | ❌ | ❌ |
| Delete validation | ❌ | ✅ | ❌ | ❌ |
| Upvote validation | ❌ | ❌ (own) | ✅ | ❌ |
| Submit feedback | ❌ | ❌ (own validation) | ✅ | ❌ |
| View feedback | ❌ | ✅ | ✅ | ✅ |
| Create post | ❌ | ✅ | — | ❌ |
| Comment | ❌ | ✅ | ✅ | ❌ |
| Send message | ❌ | ✅ | ✅ | ❌ |
| View profile | ❌ | ✅ | ✅ | ✅ |
| Edit profile | ❌ | ✅ | ❌ | ❌ |
| View Evidence Locker | ❌ | ✅ (own startup only) | ❌ | ❌ |
| View AI report | ❌ | ✅ (own validation only) | ❌ | ❌ |
| Report content | ❌ | ✅ | ✅ | ❌ |
| Delete account | ❌ | ✅ | ❌ | ✅ |

---

## 20. Document Status

**STATUS:** Draft  
**REVIEW STATE:** Needs Review

### Open Questions (Inherited + New)

| ID | Question | Impact | Owner |
|----|----------|--------|-------|
| OQ-011 | Should validation requests have privacy settings? | RULE-017, RULE-003 | Product |
| OQ-016 | Should feedback be editable after submission? | RULE-004-K | Product |
| OQ-017 | Should there be a connection/follow system in MVP? | RULE-010-E, RULE-012 | Product |
| OQ-018 | Should messaging require mutual consent (opt-in) or allow anyone to DM? | RULE-011-A | Product / Safety |
| OQ-019 | What are the exact password requirements? | RULE-001-C | Security |
| OQ-020 | What is the role selection mechanism (predefined list vs. free text)? | RULE-002 | Product |
| OQ-021 | What are the criteria for profile verification? | RULE-002-D | Product |
| OQ-022 | Should Health scores be publicly visible or private to the owner? | RULE-017 | Product |

### Consistency Check Against DOC-01, DOC-02, DOC-03

| Check | Result |
|-------|--------|
| All DEC decisions respected | ✅ |
| All confirmed code behaviors reflected as rules | ✅ |
| Feedback threshold of 3 (DEC-018) implemented | ✅ |
| Structured feedback fields (DEC-017) match | ✅ |
| AI as assistant (DEC-010) enforced | ✅ |
| Dark patterns prohibition (DEC-026) respected | ✅ |
| No features invented beyond DOC-02 scope | ✅ |
| Terminology consistent | ✅ |
| Self-feedback prevention confirmed from code | ✅ |

### Decision Registry Extract

| ID | Decision | Status | Affected Documents |
|----|----------|--------|-------------------|
| DEC-028 | **Self-feedback is prohibited.** Users cannot submit structured feedback on their own validation. | Confirmed (from code) | 05, 06, 08, 11, 12, 16 |
| DEC-029 | **Bookmarks are private.** Only visible to the bookmarking user. | Confirmed | 05, 07, 11, 12 |
| DEC-030 | **needsFeedback threshold is 3.** A validation "needs feedback" until it has ≥ 3 structured feedback responses. | Confirmed (from code) | 05, 11, 12, 14 |
| DEC-031 | **Evidence Locker is private to the startup owner.** | Proposed | 05, 07, 17, 18 |
| DEC-032 | **AI reports are private to the validation author.** | Proposed | 05, 07, 15, 18 |

### Next Actions

1. Resolve OQ-016 through OQ-022.
2. Proceed to DOC-05 (Feature Catalogue).
