# DOCUMENT 14 — ANALYTICS

**Document ID:** DOC-14  
**Version:** 1.0  
**Last Updated:** 2026-08-20  
**Owner:** Product & Growth  
**Status:** Draft  
**Upstream Dependencies:** DOC-02 (Master PRD), DOC-05 (Feature Catalogue), DOC-13 (Error Handling)  
**Downstream Dependents:** DOC-16 (QA), DOC-22 (Roadmap)  

---

## Table of Contents

1. [Analytics Philosophy](#1-analytics-philosophy)
2. [North Star Metric](#2-north-star-metric)
3. [Strategic KPIs](#3-strategic-kpis)
4. [Event Taxonomy Standard](#4-event-taxonomy-standard)
5. [Activation Events](#5-activation-events)
6. [Engagement Events](#6-engagement-events)
7. [Validation & Feedback Events](#7-validation--feedback-events)
8. [Networking & Social Events](#8-networking--social-events)
9. [AI Feature Events](#9-ai-feature-events)
10. [Error & Failure Events](#10-error--failure-events)
11. [Funnel & Cohort Definitions](#11-funnel--cohort-definitions)
12. [Privacy Classification](#12-privacy-classification)
13. [Implementation Rules](#13-implementation-rules)
14. [Decision Registry Extract](#14-decision-registry-extract)
15. [Document Status](#15-document-status)

---

## 1. Analytics Philosophy

**AN-001: Measure Signal, Not Noise.**
TAEED must never optimize for vanity metrics. Every event tracked must serve a specific product decision. If no one uses the data, the event should not exist.

**AN-002: Avoid Vanity Metrics.**
The following are explicitly prohibited as primary KPIs:
- Total app downloads (without activation)
- Total posts created (without quality filter)
- Daily page views (without engagement depth)

**AN-003: Privacy-First.**
No analytics event may transmit Personally Identifiable Information (PII) such as full names, email addresses, or phone numbers. Use anonymous User IDs (UUIDs) as user identifiers. See DOC-18 (Security & Privacy) for full constraints.

---

## 2. North Star Metric

**AN-004: North Star Definition.**

> **Weekly Active Validated Founders (WAVF)**
>
> Defined as: Founders who, in a given 7-day window, have received at least one piece of structured, actionable feedback on a submitted startup idea.

**Rationale:** This metric directly measures TAEED's core product promise — that founders get useful, real feedback on their ideas. It captures activation (an idea was submitted), quality (feedback was structured), and engagement (the loop is active). It does not reward low-quality activity.

---

## 3. Strategic KPIs

**AN-005: Primary KPI Set.**

| KPI ID | Metric | Target (MVP Launch, 90 days) | Measurement |
| :--- | :--- | :--- | :--- |
| KPI-001 | Weekly Active Validated Founders (WAVF) | [Needs Decision] | Weekly |
| KPI-002 | D7 Retention | ≥ 25% | Cohort-based |
| KPI-003 | D30 Retention | ≥ 12% | Cohort-based |
| KPI-004 | Idea Submission → First Feedback Received Rate | ≥ 60% | Funnel |
| KPI-005 | Validation Quality Score (Avg) | [Needs Calibration] | Weekly |
| KPI-006 | Peer Reviewer Activation Rate | ≥ 30% of active users submit feedback | Weekly |
| KPI-007 | AI Feature Engagement Rate | % of users who interact with AI ≥ 1x | Weekly |
| KPI-008 | Error Rate (P1 errors per session) | < 0.5% | Daily |

> **STATUS:** KPI-001 and KPI-005 targets are marked **Needs Decision** — requires product team calibration after first cohort data.

---

## 4. Event Taxonomy Standard

**AN-006: Naming Convention.**
All events follow snake_case and use this structure:

```
[area]_[object]_[action]
```

**Examples:**
- `auth_session_started`
- `idea_submission_completed`
- `feedback_form_opened`

**AN-007: Standard Event Properties.**
Every event must include these base properties automatically:

| Property | Type | Description |
| :--- | :--- | :--- |
| `event_id` | UUID | Unique ID per event occurrence |
| `user_id` | UUID | Anonymous user identifier |
| `session_id` | UUID | Current session ID |
| `timestamp` | ISO 8601 | UTC time of event |
| `platform` | Enum | `ios` / `android` |
| `app_version` | String | Semantic version string |
| `screen_name` | String | Current screen at time of event |

---

## 5. Activation Events

| EVENT-ID | Name | Trigger | Key Properties | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| AN-ACT-001 | `onboarding_started` | First app launch | `entry_source` | Measure top-of-funnel |
| AN-ACT-002 | `onboarding_step_completed` | Each onboarding step | `step_index`, `step_name` | Identify drop-off points |
| AN-ACT-003 | `onboarding_completed` | Final onboarding screen | `total_duration_seconds` | Measure full activation funnel |
| AN-ACT-004 | `account_created` | User signs up | `auth_method` | Track signup channels |
| AN-ACT-005 | `profile_completed` | User completes their profile | `fields_filled_count` | Measure profile quality |
| AN-ACT-006 | `first_idea_submitted` | User submits their first startup idea | `idea_category` | Core activation milestone |

---

## 6. Engagement Events

| EVENT-ID | Name | Trigger | Key Properties | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| AN-ENG-001 | `session_started` | App foregrounded | `session_source` | Measure active usage |
| AN-ENG-002 | `session_ended` | App backgrounded | `session_duration_seconds` | Measure session depth |
| AN-ENG-003 | `feed_viewed` | User opens main feed | `feed_type`, `item_count` | Measure feed engagement |
| AN-ENG-004 | `idea_card_tapped` | User opens an idea detail | `idea_id`, `position_in_feed` | Measure content discovery |
| AN-ENG-005 | `idea_saved` | User bookmarks/saves an idea | `idea_id` | Measure intent signals |
| AN-ENG-006 | `search_performed` | User submits a search query | `query_length`, `results_count` | Measure discovery quality |
| AN-ENG-007 | `notification_tapped` | User taps a push notification | `notification_type`, `deep_link_target` | Measure re-engagement |

---

## 7. Validation & Feedback Events

> These events are the most critical in the system. They directly measure the Core Product Loop.

| EVENT-ID | Name | Trigger | Key Properties | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| AN-VAL-001 | `idea_submission_started` | User opens submission form | — | Measure intent |
| AN-VAL-002 | `idea_submission_completed` | User submits a startup idea | `idea_id`, `category`, `has_media` | Core funnel milestone |
| AN-VAL-003 | `idea_submission_abandoned` | User closes form without submitting | `last_step_reached`, `time_spent_seconds` | Identify friction in submission |
| AN-VAL-004 | `feedback_form_opened` | User opens feedback panel | `idea_id`, `reviewer_type` | Measure feedback engagement |
| AN-VAL-005 | `feedback_submitted` | User submits structured feedback | `idea_id`, `feedback_type`, `word_count` | Core engagement action |
| AN-VAL-006 | `feedback_received` | Author receives feedback notification | `idea_id`, `feedback_count_total` | Measures value delivery |
| AN-VAL-007 | `validation_score_viewed` | User views their Health Score | `idea_id`, `score_value` | Measure score comprehension |
| AN-VAL-008 | `evidence_item_added` | User adds evidence to their idea | `idea_id`, `evidence_type` | Measure evidence quality |

---

## 8. Networking & Social Events

| EVENT-ID | Name | Trigger | Key Properties | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| AN-SOC-001 | `connection_request_sent` | User sends a connection request | `target_user_id` | Measure network growth |
| AN-SOC-002 | `connection_accepted` | User accepts a connection request | `requester_user_id` | Measure acceptance rate |
| AN-SOC-003 | `message_sent` | User sends a DM | `conversation_id`, `message_length` | Measure communication depth |
| AN-SOC-004 | `profile_viewed` | User views another user's profile | `target_user_id`, `source_screen` | Measure discovery patterns |

---

## 9. AI Feature Events

| EVENT-ID | Name | Trigger | Key Properties | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| AN-AI-001 | `ai_feature_triggered` | User initiates an AI request | `feature_name`, `context` | Measure AI adoption |
| AN-AI-002 | `ai_response_received` | AI response rendered | `feature_name`, `latency_ms` | Measure AI performance |
| AN-AI-003 | `ai_response_accepted` | User accepts/uses AI output | `feature_name` | Measure AI quality |
| AN-AI-004 | `ai_response_rejected` | User discards or regenerates AI output | `feature_name`, `rejection_reason` | Identify poor AI outputs |
| AN-AI-005 | `ai_response_edited` | User edits AI-generated text | `feature_name`, `chars_changed` | Measure AI reliability gap |

---

## 10. Error & Failure Events

*(Inherits from DOC-13. These are the analytics counterpart to the error taxonomy.)*

| EVENT-ID | Name | Trigger | Key Properties | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| AN-ERR-001 | `error_network_offline` | Device offline | `last_screen`, `retry_count` | Measure offline frequency |
| AN-ERR-002 | `error_network_timeout` | Request timeout | `endpoint`, `timeout_duration_ms` | Identify slow endpoints |
| AN-ERR-003 | `error_system_server` | 500+ server error | `endpoint`, `http_status` | Monitor backend health |
| AN-ERR-004 | `error_ai_failure` | AI generation failure | `feature_name`, `failure_reason` | Monitor AI reliability |
| AN-ERR-005 | `error_permission_denied` | 403 access denied | `attempted_action` | Detect auth/permission bugs |

---

## 11. Funnel & Cohort Definitions

**AN-008: Activation Funnel.**
```
App Installed
  → onboarding_started                   (Step 1)
  → account_created                      (Step 2)
  → profile_completed                    (Step 3 — "Activated")
  → first_idea_submitted                 (Step 4 — "Core Activated")
  → feedback_received (first time)       (Step 5 — "Value Experienced")
```

**AN-009: Core Value Funnel.**
```
idea_submission_started
  → idea_submission_completed            (Submission Rate)
  → feedback_form_opened (by others)     (Peer Engagement Rate)
  → feedback_submitted                   (Feedback Conversion Rate)
  → validation_score_viewed (by author)  (Value Realized Rate)
```

**AN-010: Cohort Definitions.**
- **New User Cohort:** Users who signed up in a given 7-day window.
- **Activated Cohort:** Users who submitted their first idea.
- **Retained Cohort:** Users who returned and performed a key action 7 / 30 days after activation.
- **Churned Cohort:** Activated users who have not returned in 30+ days.

---

## 12. Privacy Classification

All events must be classified before implementation:

| Classification | Definition | Examples |
| :--- | :--- | :--- |
| **Non-Personal** | No user link possible. | App version, crash logs |
| **Pseudonymous** | Linked to anonymous UUID only. | Most product events |
| **Personal** | Explicitly linked to identity. | **Prohibited in analytics pipeline** |

**AN-011: PII Prohibition.**
Analytics events MUST NOT contain: full name, email, phone number, exact location coordinates, or any field that can identify a specific real person without cross-referencing the user table.

---

## 13. Implementation Rules

**AN-012: Centralized Service.**
All event tracking must go through `AnalyticsService` (DOC-11: FA-015). No component may call a vendor SDK directly.

**AN-013: Deferred Non-Critical Events.**
Error events and background session events may be batched and sent when a network connection is available. Critical funnel events (e.g., `account_created`, `first_idea_submitted`) must be sent immediately.

**AN-014: Test Mode.**
All analytics events must have a `debug_mode` flag that routes them to a staging/sandbox environment. Production events must never be polluted by QA testing.

---

## 14. Decision Registry Extract

| ID | Decision | Reason | Status |
|---|---|---|---|
| DEC-AN-001 | WAVF as North Star | Directly measures core product value delivery, not vanity activity. | Approved |
| DEC-AN-002 | UUID-only user identification | Prevents PII leakage in the analytics pipeline. | Approved |
| DEC-AN-003 | Centralized AnalyticsService | Prevents vendor lock-in and ensures consistent property collection. | Approved |

---

## 15. Document Status

**STATUS:** Draft  
**REVIEW STATE:** Needs Calibration on KPI targets (KPI-001, KPI-005)  

### Open Questions

| ID | Question | Owner |
|---|---|---|
| OQ-AN-001 | What are the realistic WAVF targets for Month 1 / Month 3? | Product |
| OQ-AN-002 | Which analytics vendor to use? (PostHog, Mixpanel, Amplitude) | Engineering |
| OQ-AN-003 | Is D7 ≥ 25% realistic for MVP cohort 1? | Product |

### Consistency Check Against Upstream Docs

| Check | Result |
|-------|--------|
| All error events map 1:1 to DOC-13 error taxonomy. | ✅ |
| Funnel mirrors the Core Product Loop defined in the prompt. | ✅ |
| PII rules align with DOC-18 (Security & Privacy — to be generated). | ✅ |

### Next Actions

1. Proceed to generate DOC-15 (AI Rules).
