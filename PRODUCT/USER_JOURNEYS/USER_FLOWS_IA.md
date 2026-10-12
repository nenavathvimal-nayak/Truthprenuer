# DOCUMENT 06 — USER FLOWS & INFORMATION ARCHITECTURE

**Document ID:** DOC-06  
**Version:** 1.0  
**Last Updated:** 2026-08-20  
**Owner:** UX Design / Product  
**Status:** Draft  
**Upstream Dependencies:** DOC-04 (Rules), DOC-05 (Feature Catalogue)  
**Downstream Dependents:** DOC-07 (Screen Inventory), DOC-08 (UX Spec)

---

## Table of Contents

1. [Information Architecture (Sitemap)](#1-information-architecture-sitemap)
2. [Global Navigation Rules](#2-global-navigation-rules)
3. [UF-100: Onboarding & Authentication Flow](#3-uf-100-onboarding--authentication-flow)
4. [UF-200: Core Validation Flow (Founder)](#4-uf-200-core-validation-flow-founder)
5. [UF-300: Core Feedback Flow (Validator)](#5-uf-300-core-feedback-flow-validator)
6. [UF-400: Discovery Flow](#6-uf-400-discovery-flow)
7. [UF-500: Communication Flow](#7-uf-500-communication-flow)
8. [Decision Registry Extract](#8-decision-registry-extract)
9. [Document Status](#9-document-status)

---

## 1. Information Architecture (Sitemap)

**IA-001**

TAEED utilizes a flat, tab-based information architecture anchored by a persistent bottom navigation bar.

```mermaid
graph TD
    App[App Launch] --> CheckAuth{Is Authenticated?}
    
    %% Unauthenticated
    CheckAuth -->|No| Splash[Splash Screen]
    Splash --> Mood[Mood Selection]
    Mood --> Action[Action Selection]
    Action --> Intro[Value Prop Intro Pages]
    Intro --> Auth[Auth Selection]
    Auth --> Login[Log In]
    Auth --> Signup[Sign Up]
    Signup --> OTP[OTP Verification]
    OTP --> Setup[Profile Setup Wizard]
    Setup --> Root
    Login --> Root
    
    %% Authenticated
    CheckAuth -->|Yes| Root[Main Tab View]
    
    %% Tabs
    Root --> Tab1(Home)
    Root --> Tab2(Explore)
    Root --> Tab3(Validate)
    Root --> Tab4(Network)
    Root --> Tab5(Profile)
    
    %% Home Tab
    Tab1 --> HomeDash[Founder Dashboard]
    HomeDash --> DecisionCenter[Decision Center]
    HomeDash --> ValidationMarket[Validation Marketplace]
    HomeDash --> Notifications[Notifications List]
    HomeDash --> ChatsList[Chats List]
    
    %% Explore Tab
    Tab2 --> ExploreDash[Discovery Engine]
    ExploreDash --> FilteredList[Filtered Validations]
    ExploreDash --> GlobalSearch[Global Search]
    
    %% Validate Tab
    Tab3 --> ValDash[Validation Dashboard]
    ValDash --> HealthTab[Startup Health]
    ValDash --> AIReportTab[AI Validation Report]
    ValDash --> EvidenceTab[Evidence Locker]
    ValDash --> CreateFlow((+ Create Validation))
    
    %% Network Tab
    Tab4 --> FounderNet[Founder Network]
    FounderNet --> StartupMatch[Startup Match]
    
    %% Profile Tab
    Tab5 --> BuilderProf[Builder Profile]
    BuilderProf --> MyValidations[My Validations]
    BuilderProf --> MyPosts[My Posts]
    BuilderProf --> EditProf[Edit Profile]
    BuilderProf --> Settings[Settings]
    BuilderProf --> Gamification[Gamification Hub]
    
    %% Shared Deep Links
    ValidationMarket --> ValDetail[Validation Detail View]
    FilteredList --> ValDetail
    MyValidations --> ValDetail
    ValDetail --> AddFeedback[Structured Feedback Form]
    
    ChatsList --> ChatRoom[Chat Room]
    FounderNet --> UserProf[User Profile View]
```

---

## 2. Global Navigation Rules

**IA-002**

| Rule | Description | Traceability |
|------|-------------|--------------|
| **Primary Navigation** | 5-tab bottom bar: Home, Explore, Validate (Center Prominent), Network, Profile. | DEC-021 |
| **Header Navigation** | Contextual. On root tabs, typically contains Search (left), Chat (right), Notifications (right). | FREQ-025 |
| **Floating Actions** | Global "Create" FAB on most screens. AI Mentor FAB on Home. | FREQ-026, FREQ-027 |
| **Deep Linking** | Validation Details, User Profiles, and specific Posts must be deep-linkable. | DEC-003 |
| **Modal Patterns** | Creation flows (Validation Wizard, New Post, Feedback Form) open as full-screen modals to preserve context beneath. | UX Standard |
| **Sheet Patterns** | AI Mentor, Action Menus, and quick interactions open as bottom sheets. | UX Standard |

---

## 3. UF-100: Onboarding & Authentication Flow

**FLOW-100**

**Goal:** Get the user from app launch to a verified, setup account ready to validate.

```mermaid
sequenceDiagram
    participant U as User
    participant A as App
    
    U->>A: Opens App (First Time)
    A-->>U: Splash Screen (TAEED Validation Network)
    A-->>U: Mood Selection ("How's your energy?")
    U->>A: Selects mood (or skips)
    A-->>U: Action Selection ("What are you working on?")
    U->>A: Selects action
    A-->>U: Value Prop pages (swipeable)
    U->>A: Taps "Get Started"
    
    A-->>U: Auth Options
    U->>A: Taps "Sign Up"
    A-->>U: Collect Email & Password
    U->>A: Submits credentials
    A-->>U: OTP Verification Screen
    U->>A: Enters 6-digit OTP
    
    A-->>U: Profile Setup Wizard
    U->>A: Enters Name, Role, Bio
    U->>A: Selects Skills
    A-->>U: Success state -> Redirects to Home Tab
```

---

## 4. UF-200: Core Validation Flow (Founder)

**FLOW-200**

**Goal:** Founder creates a validation request, receives AI analysis, and tracks incoming feedback.

```mermaid
sequenceDiagram
    participant F as Founder
    participant A as App
    participant V as Community Validator
    
    %% Creation Phase
    F->>A: Taps Global "+" -> "New Validation"
    A-->>F: Validation Wizard (Step 1: Problem)
    F->>A: Completes 7 descriptive steps
    A-->>F: Step 8: Generating AI Critique (Loading...)
    A-->>F: Shows AI Validation Report
    F->>A: Reviews report, taps "Publish to Marketplace"
    A-->>F: Success. Validation is public.
    
    %% Waiting & Feedback Phase
    Note over A: Validation appears in Home Feed for others
    V->>A: Sees validation, submits Structured Feedback
    A-->>F: Notification: "New feedback received"
    
    %% Review Phase
    F->>A: Taps notification
    A-->>F: Opens Validation Dashboard
    A-->>F: Shows updated Startup Health Score (Recalculated)
    F->>A: Taps Decision Intelligence
    A-->>F: Shows "Next Best Action: Pivot Target Audience"
```

---

## 5. UF-300: Core Feedback Flow (Validator)

**FLOW-300**

**Goal:** Validator discovers a startup idea and provides structured feedback.

```mermaid
sequenceDiagram
    participant V as Validator
    participant A as App
    
    V->>A: Opens App -> Home Tab
    A-->>V: Shows Validation Marketplace (ideas needing feedback)
    V->>A: Taps a Validation Card
    A-->>V: Validation Detail View (reads problem, solution, etc.)
    
    V->>A: Taps "Provide Feedback"
    A-->>V: Structured Feedback Form (Modal)
    V->>A: Selects Problem Frequency (e.g., "Weekly")
    V->>A: Taps Willingness to Pay toggle
    V->>A: Sets Overall Rating (1-5 slider)
    V->>A: Enters detailed text feedback
    V->>A: Taps Submit
    
    A-->>V: Success Animation
    A-->>V: Rewards "Proof of Validation" (if implemented)
    A-->>V: Returns to Home Feed
```

---

## 6. UF-400: Discovery Flow

**FLOW-400**

**Goal:** User searches for specific content or browses by category.

```mermaid
sequenceDiagram
    participant U as User
    participant A as App
    
    U->>A: Taps "Explore" Tab
    A-->>U: Shows Discovery Engine
    
    %% Category Filtering
    U->>A: Taps "HealthTech" filter chip
    A-->>U: Updates list to show only HealthTech validations
    U->>A: Taps a card to view details
    
    %% Global Search
    U->>A: Returns to Explore, taps Search Bar
    A-->>U: Shows Search Overlay (recent searches)
    U->>A: Types "payment gateway"
    A-->>U: Shows Results tabbed by: Validations, Users, Posts
    U->>A: Selects "Users" tab
    A-->>U: Shows Founders with FinTech skills
```

---

## 7. UF-500: Communication Flow

**FLOW-500**

**Goal:** User interacts with another user via direct message or post comment.

```mermaid
sequenceDiagram
    participant U1 as User 1
    participant A as App
    participant U2 as User 2
    
    %% Direct Messaging
    U1->>A: Browsing Founder Network (Network Tab)
    A-->>U1: Shows list of users
    U1->>A: Taps User 2's profile
    A-->>U1: User 2 Profile View
    U1->>A: Taps "Message"
    A-->>U1: Opens Chat Room
    U1->>A: Types and sends message
    A-->>U2: Notification: New Message from User 1
    
    %% Commenting
    U1->>A: Browsing Explore -> Taps User 2's Validation
    A-->>U1: Validation Detail View
    U1->>A: Scrolls to Comments -> Taps text input
    U1->>A: Types comment and posts
    A-->>U1: Comment appears inline
    A-->>U2: Notification: New Comment on your validation
```

---

## 8. Decision Registry Extract

No new deterministic rules or overarching decisions are established in this document. It serves to orchestrate the features defined in DOC-05 according to the rules defined in DOC-04.

---

## 9. Document Status

**STATUS:** Draft  
**REVIEW STATE:** Needs Review

### Consistency Check Against Upstream Docs

| Check | Result |
|-------|--------|
| Navigation matches DEC-021 (5 bottom tabs). | ✅ |
| Validation Wizard flow matches DEC-016 (8 steps). | ✅ |
| Structured Feedback form flow matches DEC-017. | ✅ |
| No self-feedback possible in UF-300 (adheres to DEC-028). | ✅ |
| Deep linking architecture supports notification routing (RULE-012-G). | ✅ |

### Next Actions

1. Proceed to DOC-07 (Screen & Page Inventory).
