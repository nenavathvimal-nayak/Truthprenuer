# DOCUMENT 17 — COMMUNITY & MODERATION

**Document ID:** DOC-17  
**Version:** 1.0  
**Last Updated:** 2026-08-20  
**Owner:** Trust & Safety + Product  
**Status:** Draft  
**Upstream Dependencies:** DOC-04 (Product Rules), DOC-15 (AI Rules)  
**Downstream Dependents:** DOC-18 (Security & Privacy), DOC-19 (Terms & Conditions)  

---

## Table of Contents

1. [Community Philosophy](#1-community-philosophy)
2. [Content Standards](#2-content-standards)
3. [Prohibited Content & Behavior](#3-prohibited-content--behavior)
4. [Reporting System](#4-reporting-system)
5. [Blocking & Muting](#5-blocking--muting)
6. [Moderation Workflow](#6-moderation-workflow)
7. [Enforcement Levels](#7-enforcement-levels)
8. [Appeals Process](#8-appeals-process)
9. [Automated Moderation](#9-automated-moderation)
10. [Moderator Permissions & Audit](#10-moderator-permissions--audit)
11. [Decision Registry Extract](#11-decision-registry-extract)
12. [Document Status](#12-document-status)

---

## 1. Community Philosophy

**MOD-001: Constructive Disagreement, Not Comfort.**
TAEED is a validation platform. The purpose is honest, constructive feedback — not unconditional encouragement. Moderation must protect users from harassment and abuse, but must NOT suppress legitimate critical feedback on startup ideas.

**MOD-002: Proportional Enforcement.**
Penalties must match the severity and intent of the violation. A first-time mildly rude comment gets a warning; targeted harassment gets an immediate suspension.

**MOD-003: Transparency.**
Users must be told *what* they violated and *what* the consequence is. "Your account has been restricted" with no explanation is prohibited.

---

## 2. Content Standards

**MOD-004: Acceptable Content.**

| # | Standard | Example |
| :--- | :--- | :--- |
| CS-01 | Startup ideas and related business content | Problem statements, business models, market hypotheses |
| CS-02 | Constructive feedback — including critical | "Your pricing model doesn't account for X" |
| CS-03 | Evidence and supporting data | Links, screenshots, customer quotes, research citations |
| CS-04 | Questions seeking clarification | "How do you plan to handle Y?" |
| CS-05 | Professional networking and mentorship | Connection requests, collaboration proposals |

**MOD-005: Quality Expectations.**
Feedback must be substantive. One-word responses ("Good", "Bad", "Nice") are deprioritized by the Feedback Quality Scorer (DOC-15, AI-FEAT-002) but are not removed unless they constitute spam.

---

## 3. Prohibited Content & Behavior

**MOD-006: Absolute Prohibitions.**

| # | Violation | Severity | Action |
| :--- | :--- | :--- | :--- |
| V-01 | Hate speech, slurs, threats of violence | Critical | Immediate suspension + content removal |
| V-02 | Harassment, targeted bullying, doxxing | Critical | Immediate suspension + content removal |
| V-03 | Sexually explicit content | Critical | Immediate removal |
| V-04 | Spam, bot-generated content, link farms | High | Content removal + warning; repeat = suspension |
| V-05 | Impersonating another user, investor, or public figure | High | Account suspension pending review |
| V-06 | Fabricating validation data, fake feedback, fake evidence | High | Content removal + warning; repeat = ban |
| V-07 | Scams, fraud, illegal activity promotion | Critical | Immediate permanent ban + report to authorities if warranted |
| V-08 | Intellectual property theft (claiming others' ideas as own) | High | Content removal + investigation |
| V-09 | Manipulation of scoring/validation system | High | Score reset + suspension |
| V-10 | Unsolicited commercial advertising | Medium | Content removal + warning |

---

## 4. Reporting System

**MOD-007: Report Mechanism.**
Every piece of user-generated content (idea posts, feedback comments, messages, profiles) must have a "Report" option accessible within 2 taps.

**MOD-008: Report Categories.**

| Category | Maps to Violation |
| :--- | :--- |
| Harassment or bullying | V-02 |
| Hate speech | V-01 |
| Spam | V-04 |
| Fake or misleading content | V-06 |
| Scam or fraud | V-07 |
| Impersonation | V-05 |
| Intellectual property | V-08 |
| Other (free text) | Manual review |

**MOD-009: Report Acknowledgement.**
Users who submit a report must receive immediate confirmation ("Report received. We'll review it within 24 hours."). They must receive a follow-up notification when action is taken (without disclosing specifics of penalties against the other user).

---

## 5. Blocking & Muting

**MOD-010: Block.**
- Blocked users cannot: view the blocker's profile, see the blocker's ideas, send messages to the blocker, or appear in the blocker's feed.
- Blocking is silent — the blocked user is not notified.
- Blocking is reversible from Settings.

**MOD-011: Mute.**
- Muted users' content is hidden from the muter's feed but the muted user can still view the muter's content.
- Muting is a softer action for managing noise, not abuse.

---

## 6. Moderation Workflow

**MOD-012: Triage Pipeline.**

```
Content Reported / Auto-Flagged
       │
       ▼
┌──────────────────┐
│  Auto-Filter     │ ← Keyword/pattern match, AI content filter
│  (Immediate)     │
└──────┬───────────┘
       │ Passed auto-filter or flagged for human review
       ▼
┌──────────────────┐
│  Moderation Queue │ ← Sorted by severity (Critical first)
└──────┬───────────┘
       │
       ▼
┌──────────────────┐
│  Human Review     │ ← Moderator reviews context, makes decision
└──────┬───────────┘
       │
       ▼
  Action Taken → User Notified → Logged in Audit Trail
```

**MOD-013: SLA Targets.**

| Severity | Review SLA |
| :--- | :--- |
| Critical (V-01, V-02, V-03, V-07) | Within 4 hours |
| High (V-04, V-05, V-06, V-08, V-09) | Within 24 hours |
| Medium (V-10, Other) | Within 48 hours |

---

## 7. Enforcement Levels

**MOD-014: Graduated Enforcement.**

| Level | Action | Trigger | Duration |
| :--- | :--- | :--- | :--- |
| **Level 0 — Guidance** | System nudge ("Consider making your feedback more constructive") | Low-quality content detected by AI | Immediate, in-context |
| **Level 1 — Warning** | Formal warning notification | First violation (Medium/High) | Permanent record |
| **Level 2 — Content Removal** | Specific content deleted + notification | Confirmed violation | Immediate |
| **Level 3 — Temporary Restriction** | Cannot post or send messages | 2 warnings within 30 days, or single High violation | 7 days (default) |
| **Level 4 — Suspension** | Account locked, read-only access | Critical violation, or 3+ warnings within 90 days | 30 days (default) |
| **Level 5 — Permanent Ban** | Account permanently deactivated | Repeat critical violations, or egregious single offense (V-07) | Permanent |

---

## 8. Appeals Process

**MOD-015: Right to Appeal.**
Any user who receives a Level 2+ enforcement action may submit one appeal within 14 days.

**MOD-016: Appeal Workflow.**
1. User submits appeal from the enforcement notification screen.
2. Appeal is reviewed by a *different* moderator than the original decision-maker.
3. Decision is communicated within 72 hours.
4. Appeal outcomes: **Upheld** (no change), **Reduced** (lower penalty), or **Reversed** (action retracted, record cleared).

**MOD-017: Appeal Limitations.**
- Permanent bans for Critical violations (V-01, V-07) may only be appealed once.
- Users may not appeal the same enforcement action more than once.

---

## 9. Automated Moderation

**MOD-018: Auto-Filter Layer.**
- **Keyword Blocklist:** Configurable list of slurs, explicit terms, and known spam patterns.
- **AI Content Filter:** Uses the AI backend (DOC-15) to flag potentially violating content for human review. AI flags are signals, never automatic verdicts (per AI-032).
- **Rate Limiting:** Rapid-fire posting (>5 posts in 60 seconds) triggers automatic throttle (DOC-13, VAL_429_RATE_LIMIT).

**MOD-019: Auto-Filter Transparency.**
If content is auto-held for review, the user must see: "Your post is being reviewed and will appear shortly." Content must never silently disappear.

---

## 10. Moderator Permissions & Audit

**MOD-020: Moderator Role (RBAC).**
- Moderators are assigned via the Admin panel. Only `Admin` can promote/demote moderators.
- Moderators can: view reports, review flagged content, issue Level 0–3 actions, escalate to Admin.
- Moderators CANNOT: permanently ban users (Level 5), access private messages (unless specifically reported), or modify user profile data.

**MOD-021: Audit Logging.**
Every moderation action must be logged:

| Field | Content |
| :--- | :--- |
| `action_id` | UUID |
| `moderator_id` | Who took the action |
| `target_user_id` | Who was actioned |
| `target_content_id` | Which content (if applicable) |
| `action_type` | Warning / Removal / Restriction / Suspension / Ban |
| `reason` | Violation code (V-01 through V-10) |
| `timestamp` | UTC |
| `appeal_status` | None / Pending / Upheld / Reversed |

Audit logs must be retained for a minimum of 1 year.

---

## 11. Decision Registry Extract

| ID | Decision | Reason | Status |
|---|---|---|---|
| DEC-MOD-001 | AI flags are signals, not verdicts | Prevent false positives from auto-penalizing users | Approved |
| DEC-MOD-002 | Graduated enforcement (5 levels) | Proportional response prevents over-moderation | Approved |
| DEC-MOD-003 | Moderators cannot permanently ban | Prevents abuse of power; requires Admin escalation | Approved |

---

## 12. Document Status

**STATUS:** Draft  
**REVIEW STATE:** Needs Review  

### Open Questions

| ID | Question | Owner |
|---|---|---|
| OQ-MOD-001 | Who are the initial moderators at launch? Internal team only? | Product + Ops |
| OQ-MOD-002 | Do we need a public-facing Community Guidelines page at MVP? | Product + Legal |

### Consistency Check Against Upstream Docs

| Check | Result |
|-------|--------|
| Enforcement aligns with Product Rules (DOC-04). | ✅ |
| AI moderation uses AI as signal, not authority (DOC-15, AI-032). | ✅ |
| Rate limiting references DOC-13 error taxonomy. | ✅ |
| Audit log requirements feed into DOC-18 (Security). | ✅ |

### Next Actions

1. Proceed to generate DOC-18 (Security & Privacy Architecture).
