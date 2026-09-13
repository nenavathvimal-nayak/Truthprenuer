# DOCUMENT 10 — DESIGN RULES

**Document ID:** DOC-10  
**Version:** 1.0  
**Last Updated:** 2026-08-20  
**Owner:** UI/UX Design  
**Status:** Draft  
**Upstream Dependencies:** DOC-04 (Product Rules), DOC-08 (UX Spec), DOC-09 (Design System)  
**Downstream Dependents:** DOC-11 (Frontend Architecture)

---

## Table of Contents

1. [Application of the Design System](#1-application-of-the-design-system)
2. [Component Usage Rules](#2-component-usage-rules)
3. [Typography Rules](#3-typography-rules)
4. [Color Rules](#4-color-rules)
5. [Accessibility (A11y) Implementation Rules](#5-accessibility-a11y-implementation-rules)
6. [Decision Registry Extract](#6-decision-registry-extract)
7. [Document Status](#7-document-status)

---

## 1. Application of the Design System

**DSR-001**

| Rule ID | Rule | Constraint |
|---------|------|------------|
| DSR-001-A | **Never hardcode values.** All colors, spacing, typography, and radiuses MUST come from the `AppThemeColors`, `AppSpacing`, `AppTypography`, and `AppRadius` classes. | Absolute |
| DSR-001-B | **Contextual Colors.** Use `Theme.of(context).appColors` to access colors. Never use `AppPalette` directly in UI code. This ensures dark/light mode switching works flawlessly. | Absolute |
| DSR-001-C | **Responsive Layouts.** Avoid fixed widths or heights for containers unless specifically bounded (e.g., Avatars). Use `Expanded`, `Flexible`, `SafeArea`, and padding to let the UI adapt to the screen size. | Standard |
| DSR-001-D | **Glass/Blur Elements.** When applying a backdrop filter for the "liquid glass" effect, the underlying container MUST have an opacity < 1.0, and the filter MUST use `ImageFilter.blur(sigmaX: 10, sigmaY: 10)` (or similar standard value). | Standard |

---

## 2. Component Usage Rules

**DSR-002**

### 2.1 Buttons

| Rule ID | Rule |
|---------|------|
| DSR-002-A | **One Primary Button per view.** There should only be one high-contrast, solid primary button visible on the screen at a time to clearly indicate the primary action. |
| DSR-002-B | **Button scaling.** Primary and secondary buttons should use the `ScaleButtonStyle` wrapper (or similar mechanism) to provide tactile haptic and visual feedback on press. |
| DSR-002-C | **Button labels.** Must be concise verbs (e.g., "Submit Feedback", "Save Draft", "Delete"). |

### 2.2 Cards & Containers

| Rule ID | Rule |
|---------|------|
| DSR-002-D | **Card Backgrounds.** Use `colors.cardBackground` or `colors.cardBackgroundLight` for cards. Do not use heavy drop shadows (`BoxShadow`) in dark mode; rely on border colors (`colors.border`) or subtle background differences for separation. |
| DSR-002-E | **Inner Spacing.** Cards should universally use `AppSpacing.md` or `AppSpacing.lg` for internal padding. |
| DSR-002-F | **Border Radius.** Standard cards use `AppRadius.lg` or `AppRadius.xl`. Inner elements (like tags) use `AppRadius.sm`. |

---

## 3. Typography Rules

**DSR-003**

Inherits: DOC-09 (Typography)

| Rule ID | Rule |
|---------|------|
| DSR-003-A | **Semantic mapping.** Use `title1`, `title2`, etc., strictly for hierarchical headers. Do not use them just to make text larger. |
| DSR-003-B | **Monospace.** Use `metric`, `metricLarge`, `mono`, or `monoSmall` ONLY for numbers, data points, or code snippets (e.g., Health Scores, Feedback counts). Do not use monospace for body copy. |
| DSR-003-C | **Text Color.** Use `colors.text` for primary information, `colors.textSecondary` for supporting information, and `colors.textTertiary` for disabled or low-priority information. |
| DSR-003-D | **Line Height (Height multiplier).** For multi-line body text, apply a `height` property of `1.4` or `1.5` in the `TextStyle` to improve readability. |

---

## 4. Color Rules

**DSR-004**

Inherits: DOC-09 (Colors)

| Rule ID | Rule |
|---------|------|
| DSR-004-A | **Semantic ambiguity mitigation.** Since `success`, `warning`, and `destructive` all map to `AppPalette.orange` (Brand color), color alone CANNOT convey state. You MUST pair the color with a clarifying icon (e.g., `Icons.check_circle`, `Icons.warning`, `Icons.error`). |
| DSR-004-B | **Evidence Colors.** When displaying Startup Health or Evidence, use `evidenceGreen`, `confidenceBlue`, and `riskRed` to differentiate data polarity, rather than brand colors. |
| DSR-004-C | **Contrast accessibility.** Never place `colors.text` on a `colors.primary` background. If the background is primary orange, the text MUST be `Colors.white` or `colors.textInverted` to guarantee contrast. |

---

## 5. Accessibility (A11y) Implementation Rules

**DSR-005**

Inherits: DOC-08 (Accessibility)

| Rule ID | Rule |
|---------|------|
| DSR-005-A | **Semantics Widget.** Wrap custom interactive elements or complex graphics in a `Semantics` widget to provide `label`, `hint`, and `onTap` properties for screen readers. |
| DSR-005-B | **Icon Buttons.** `IconButton` or `GestureDetector` containing only an `Icon` MUST have a `tooltip` or semantic label describing the action (e.g., `semanticLabel: "Upvote validation"`). |
| DSR-005-C | **Minimum Touch Area.** The effective tap area of any interactive element must be at least 44x44 logical pixels. Use padding or wrapping `Container` to expand the hit test area of small icons. |

---

## 6. Decision Registry Extract

No new overarching product decisions are established in this document. It codifies implementation rules for the Design System (DOC-09).

---

## 7. Document Status

**STATUS:** Draft  
**REVIEW STATE:** Needs Review

### Consistency Check Against Upstream Docs

| Check | Result |
|-------|--------|
| Rules enforce the tokens defined in DOC-09. | ✅ |
| Rules support the UX specifications in DOC-08. | ✅ |
| Addresses the semantic color limitation (DSR-004-A resolves DS-003.5 caution). | ✅ |

### Next Actions

1. Proceed to Phase 4, starting with DOC-11 (Frontend Architecture).
