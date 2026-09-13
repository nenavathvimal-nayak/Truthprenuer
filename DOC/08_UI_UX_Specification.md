# DOCUMENT 08 — UI/UX SPECIFICATION

**Document ID:** DOC-08  
**Version:** 1.0  
**Last Updated:** 2026-08-20  
**Owner:** UX Design  
**Status:** Draft  
**Upstream Dependencies:** DOC-03 (Personas), DOC-06 (User Flows), DOC-07 (Screen Inventory)  
**Downstream Dependents:** DOC-09 (Design System), DOC-10 (Design Rules), DOC-11 (Frontend Architecture)

---

## Table of Contents

1. [Design Philosophy](#1-design-philosophy)
2. [Layout & Structure Patterns](#2-layout--structure-patterns)
3. [Interaction Patterns](#3-interaction-patterns)
4. [Component Specifications](#4-component-specifications)
5. [Typography & Readability UX](#5-typography--readability-ux)
6. [Motion & Animation UX](#6-motion--animation-ux)
7. [Accessibility UX (A11y)](#7-accessibility-ux-a11y)
8. [Empty & Error States](#8-empty--error-states)
9. [Decision Registry Extract](#9-decision-registry-extract)
10. [Document Status](#10-document-status)

---

## 1. Design Philosophy

**UX-001**

TAEED's design philosophy is driven by its identity as a "Validation Network" for founders.

| Principle | Implication for UX | Traceability |
|-----------|--------------------|--------------|
| **Builder Aesthetic** | Dark mode default. High contrast. Monospaced elements for metrics. Looks like a professional tool, not a casual social network. | DEC-004 |
| **Evidence Over Opinion** | Data is privileged in the visual hierarchy. Health scores, percentages, and counts are large and legible. | SP-002 |
| **Friction Where Necessary** | We do not optimize for mindless scrolling. The 8-step validation wizard introduces intentional friction to ensure high-quality inputs. | SP-005, DEC-027 |
| **Honest and Constructive** | UI copy is direct. We avoid dark patterns, fabricated urgency, or manipulative gamification. | SP-004, DEC-026 |
| **Liquid-Glass Treatment** | Use of blur (`BackdropFilter`) and translucency for overlays, sheets, and persistent navigation elements to create depth. | OQ-006 |

---

## 2. Layout & Structure Patterns

**UX-002**

### 2.1 Navigation Structure

- **Bottom Navigation Bar:** Persistent across root tabs. Liquid-glass blur effect. No text labels (icons only) to maximize vertical space. Active state indicated by primary color and solid icon variant.
- **Top App Bar:** Contextual. Typically contains screen title (left-aligned or center), Search (right), Chat (right), Notifications (right).
- **Safe Areas:** All content respects device safe areas (notches, home indicators).

### 2.2 Content Layouts

- **Lists & Feeds:** Standard vertical scrolling lists. Cards have distinct boundaries (background color contrast) rather than heavy drop shadows.
- **Dashboards:** Grid layouts for metrics (e.g., Startup Health Dashboard). Use of radial charts or horizontal progress bars for data visualization.
- **Forms:** Single-column layout. Labels above inputs. Large touch targets. Clear inline validation.

---

## 3. Interaction Patterns

**UX-003**

### 3.1 Gestures

- **Swipe to Go Back:** Standard iOS edge-swipe behavior implemented universally.
- **Pull to Refresh:** Available on all primary feeds (Home, Explore, Notifications).
- **Horizontal Swipe:** Used for segmented control navigation (e.g., Validation Dashboard tabs) and Onboarding value prop pages.

### 3.2 Haptics

Haptic feedback is managed centrally (`HapticManager`) to reinforce physical interactions.

| Action | Haptic Type |
|--------|-------------|
| Bottom tab selection | `selection` (light tap) |
| Successful form submission | `success` (distinct double tap) |
| Error or validation failure | `error` (heavy thud) |
| Upvote / Bookmark toggle | `lightImpact` |
| Long press context menu | `mediumImpact` |

### 3.3 Modals vs. Sheets

- **Full-Screen Modals:** Used for complex, multi-step flows that require full attention (Validation Wizard, Profile Setup). Include a clear "X" or "Cancel" in the top left.
- **Bottom Sheets:** Used for quick actions, contextual menus, and the AI Mentor Chat. Should be draggable and dismissible by swiping down or tapping the scrim.

---

## 4. Component Specifications

**UX-004**

*(Note: Exact visual values are defined in DOC-09 Design System. This section covers UX behavior.)*

### 4.1 Buttons

- **Primary Action:** Solid background (AppColors.primary). Used for the single most important action on a screen (e.g., "Submit Feedback").
- **Secondary Action:** Outlined or subtle background. Used for alternative actions (e.g., "Save Draft").
- **Scale Effect:** Buttons should shrink slightly on press (`ScaleButtonStyle` pattern seen in onboarding) to provide immediate visual feedback.
- **Touch Target:** Minimum 44x44pt.

### 4.2 Text Inputs (CustomTextField)

- **States:** Default, Focused (border highlight), Error (red border + message), Disabled.
- **Behavior:** Auto-focus first field in forms where appropriate. Clear button ("x") appears when text is entered in search fields.
- **Validation:** Inline validation messages appear below the field on `onBlur` or `onSubmit`, not while typing (to avoid aggressive error states).

### 4.3 Validation Cards (Feed Items)

- **Hierarchy:** 1. Title (largest), 2. Problem summary (truncated to 3 lines), 3. Meta-data (Stage, Feedback Count).
- **Interactions:** Tap card body -> Validation Detail View. Tap User Avatar -> User Profile View.
- **Indicators:** "Needs Feedback" badge is highly prominent.

---

## 5. Typography & Readability UX

**UX-005**

- **Font Roles:**
  - SF Pro Rounded / Inter (Display/Headlines): Friendly but authoritative.
  - System default (Body): Maximizes native readability.
  - SF Mono / Monospaced (Metrics/Badges): Technical, precise aesthetic.
- **Line Length:** Body text constrained to ~60-70 characters per line for optimal reading comfort.
- **Contrast:** Text contrast must meet WCAG AA standards (minimum 4.5:1 for normal text). Specifically critical for dark mode secondary text against dark backgrounds.

---

## 6. Motion & Animation UX

**UX-006**

Animations are purposeful, never decorative.

| Animation Type | Purpose | Behavior |
|----------------|---------|----------|
| **Transitions** | Preserve spatial context | Push for lateral movement (drilling down). Slide up for modals. |
| **Micro-interactions** | Provide immediate feedback | Button scale down on press. Heart icon "pop" on upvote. |
| **Loading States** | Manage waiting anxiety | Skeleton screens preferred over spinners for content loading. |
| **AI Generation** | Indicate processing | Simulated typing indicator or glowing gradient border while AI report generates (FREQ-071). |

---

## 7. Accessibility UX (A11y)

**UX-007**

Inherits: NFR-040, NFR-041, NFR-042, NFR-043

- **Semantic Labels:** All icon-only buttons (e.g., upvote, bookmark, back arrow) must have semantic text labels for screen readers.
- **Dynamic Type:** Text must scale gracefully when users increase system font sizes. Layouts must scroll, not clip, when text scales up.
- **Color Independence:** Information must not be conveyed by color alone. Error states require an icon + text in addition to red color.
- **Focus Management:** When modals or sheets open, screen reader focus must shift to the new container.

---

## 8. Empty & Error States

**UX-008**

Inherits: EC-006, EC-009

### 8.1 Empty States

Empty states should educate and prompt action, not just show a blank screen.

| Screen | Empty State UX |
|--------|----------------|
| Home Feed (No validations) | "The community is quiet today. Be the first to launch an idea." + Primary CTA to Create. |
| Validation Dash | "No Active Experiments. Launch a validation request to begin." + Mascot graphic. |
| Evidence Locker | "No evidence collected yet. Start by interviewing a potential user." |
| Notifications | "All caught up. No new notifications." |
| Chat List | "No conversations yet. Find someone in the Founder Network." |

### 8.2 Error States

- **Network Error:** "Connection lost. Please check your internet and try again." (Provide retry button).
- **AI Timeout:** "The AI is taking longer than expected. Please try again." (Don't block the user from saving their validation).
- **Data Not Found (404 equivalent):** "This content is no longer available. It may have been deleted by the author." (EC-009).

---

## 9. Decision Registry Extract

No new overarching product decisions are established in this document. It serves as a UX specification adhering to the constraints of the PRD (DOC-02) and Rules (DOC-04).

---

## 10. Document Status

**STATUS:** Draft  
**REVIEW STATE:** Needs Review

### Consistency Check Against Upstream Docs

| Check | Result |
|-------|--------|
| Adheres to Dark Mode default (DEC-004). | ✅ |
| Haptic and gesture rules support the required interactions in DOC-05. | ✅ |
| Empty states account for edge cases identified in DOC-02 (EC-006). | ✅ |
| UI patterns support the personas' need for structured, clear data (DOC-03). | ✅ |

### Next Actions

1. Proceed to DOC-09 (Design System) to define the exact visual tokens (colors, spacing, typography) that implement these UX specifications.
