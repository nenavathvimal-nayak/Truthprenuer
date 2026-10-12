# DOCUMENT 07 — SCREEN & PAGE INVENTORY

**Document ID:** DOC-07  
**Version:** 1.0  
**Last Updated:** 2026-08-20  
**Owner:** UI/UX Design  
**Status:** Draft  
**Upstream Dependencies:** DOC-05 (Feature Catalogue), DOC-06 (User Flows / IA)  
**Downstream Dependents:** DOC-08 (UI/UX Specification), DOC-11 (Frontend Architecture)

---

## Table of Contents

1. [Inventory Organization](#1-inventory-organization)
2. [SCR-100: Onboarding & Auth](#2-scr-100-onboarding--auth)
3. [SCR-200: Home & Discovery](#3-scr-200-home--discovery)
4. [SCR-300: Validation Engine](#4-scr-300-validation-engine)
5. [SCR-400: Profiles & Network](#5-scr-400-profiles--network)
6. [SCR-500: Communication & Modals](#6-scr-500-communication--modals)
7. [Decision Registry Extract](#7-decision-registry-extract)
8. [Document Status](#8-document-status)

---

## 1. Inventory Organization

**SCR-001**

This document catalogues every screen required for the MVP, mapping them directly to the Flutter codebase implementation.

| Prefix | Area |
|--------|------|
| **SCR-100** | Onboarding & Authentication |
| **SCR-200** | Home & Discovery |
| **SCR-300** | Validation Engine |
| **SCR-400** | Profiles & Network |
| **SCR-500** | Communication & Modals |

**Legend:**
- **Status:** Complete (in code) / Missing (needs implementation)
- **File:** Path relative to `lib/views/`

---

## 2. SCR-100: Onboarding & Auth

| Screen ID | Screen Name | Description | File Path | Status |
|-----------|-------------|-------------|-----------|--------|
| SCR-101 | Splash Screen | Brand logo, tagline, animated entry. Handles auth state routing. | `onboarding/splash_view.dart` | Complete |
| SCR-102 | Mood Selection | Mascot interaction, "How's your entrepreneurial energy today?" | `onboarding/mood_selection_view.dart` | Complete |
| SCR-103 | Action Selection | Select goal: Validate, Build, Find Co-founder, Explore. | `onboarding/action_selection_view.dart` | Complete |
| SCR-104 | Value Prop Onboarding | 3-page swipeable introduction to TAEED core values. | `onboarding/onboarding_view.dart` | Complete |
| SCR-105 | Login | Email/password entry, link to forgot password. | `auth/login_view.dart` | Complete |
| SCR-106 | Signup | Email/password creation, Terms acceptance. | `auth/signup_view.dart` | Complete |
| SCR-107 | OTP Verification | 6-digit PIN entry for email verification. | `auth/otp_verification_view.dart` | Complete |
| SCR-108 | Forgot Password | Email entry to request password reset link/OTP. | `auth/forgot_password_view.dart` | Complete |
| SCR-109 | Profile Setup Wizard | Collects Name, Role, Bio, Skills. Multi-step. | `profile/profile_setup_wizard_view.dart` | Complete |

---

## 3. SCR-200: Home & Discovery

| Screen ID | Screen Name | Description | File Path | Status |
|-----------|-------------|-------------|-----------|--------|
| SCR-201 | Main Tab View | Root scaffold containing bottom navigation bar. | `main/main_tab_view.dart` | Complete |
| SCR-202 | Founder Home | Dashboard with Decision Intelligence, Validation Marketplace. | `main/founder_home_view.dart` | Complete |
| SCR-203 | Discovery Engine (Explore) | Filterable list of all public validation requests. | `main/explore_view.dart` | Complete |
| SCR-204 | Explore Skeleton | Loading state for discovery feed. | `main/explore_skeleton_view.dart` | Complete |
| SCR-205 | Search Overlay | Full-screen search with history and tabbed results. | *Integrated in exploration views or separate?* [Needs verification] | Missing/TBD |

---

## 4. SCR-300: Validation Engine

| Screen ID | Screen Name | Description | File Path | Status |
|-----------|-------------|-------------|-----------|--------|
| SCR-301 | Validation Wizard | 8-step modal flow for creating a new request. | `validation/validation_wizard_view.dart` | Complete |
| SCR-302 | Validation Dashboard | User's personal validation hub (tabbed view). | `validation/validation_dashboard_view.dart` | Complete |
| SCR-303 | Startup Health Dashboard | Visual display of the 10 health dimensions. | `validation/startup_health_dashboard_view.dart` | Complete |
| SCR-304 | AI Validation Report | Dedicated view for the LLM critique output. | `validation/ai_validation_view.dart` | Complete |
| SCR-305 | Evidence Locker | List of collected evidence items with confidence scores. | `validation/evidence_locker_view.dart` | Complete |
| SCR-306 | Validation Detail | Deep dive into a specific request, shows feedback & comments. | `validation/validation_detail_view.dart` | Complete |
| SCR-307 | Structured Feedback Form | Modal data entry for validators to submit feedback. | `validation/structured_feedback_view.dart` | Complete |
| SCR-308 | Validation Marketplace | List of validations specifically requiring feedback. | `validation/validation_marketplace_view.dart` | Complete |

---

## 5. SCR-400: Profiles & Network

| Screen ID | Screen Name | Description | File Path | Status |
|-----------|-------------|-------------|-----------|--------|
| SCR-401 | Builder Profile | User's own public profile (Validations & Posts tabs). | `profile/builder_profile_view.dart` | Complete |
| SCR-402 | User Profile | View of another user's profile. | `profile/user_profile_view.dart` | Complete |
| SCR-403 | Edit Profile | Form to update user details (Bio, Skills, etc.). | `profile/edit_profile_view.dart` | Complete |
| SCR-404 | Startup Profile | Entity profile distinct from the founder. | `profile/startup_profile_view.dart` | Complete |
| SCR-405 | Founder Network | Searchable directory of all users. | `network/network_view.dart` | Complete |
| SCR-406 | Startup Match | Tinder-style or list-style co-founder matching. | `network/startup_match_view.dart` | Complete |
| SCR-407 | Gamification Hub | Achievements and Leaderboards. | `profile/gamification_hub_view.dart` | Complete |
| SCR-408 | App Settings | Account management, notifications, theme toggles. | `profile/settings_view.dart` | Complete |
| SCR-409 | Startup Settings | Entity-level configuration. | `profile/startup_settings_views.dart` | Complete |

---

## 6. SCR-500: Communication & Modals

| Screen ID | Screen Name | Description | File Path | Status |
|-----------|-------------|-------------|-----------|--------|
| SCR-501 | Notifications List | Feed of all 8 notification types. | `main/notifications_view.dart` | Complete |
| SCR-502 | Chat List | Inbox of all 1-on-1 conversations. | `messaging/chats_list_view.dart` | Complete |
| SCR-503 | Chat Room | Individual conversation thread. | `messaging/chat_room_view.dart` | Complete |
| SCR-504 | AI Mentor Chat | Conversational interface with the AI assistant. | `messaging/ai_mentor_chat_view.dart` | Complete |
| SCR-505 | Create Post Modal | Form for creating a community post. | *Not explicitly found as separate view* | Missing/TBD |

---

## 7. Decision Registry Extract

No new overarching product decisions are established in this document. It serves as an inventory mapping IA (DOC-06) to actual Flutter files.

---

## 8. Document Status

**STATUS:** Draft  
**REVIEW STATE:** Needs Review

### Consistency Check Against Upstream Docs

| Check | Result |
|-------|--------|
| 34 confirmed screens from implementation plan are catalogued. | ✅ |
| Navigation hierarchy aligns with DOC-06. | ✅ |
| Required features from DOC-05 have corresponding screens. | ✅ |

### Missing Elements Identified

- **Search Overlay:** Needs explicit implementation details.
- **Create Post Modal:** Post creation mechanism (FREQ-140) needs a dedicated screen or modal.

### Next Actions

1. Design team to verify screen inventory covers all edge cases.
2. Proceed to DOC-08 (UI/UX Specification).
