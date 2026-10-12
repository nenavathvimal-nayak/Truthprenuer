# DOCUMENT 09 — DESIGN SYSTEM

**Document ID:** DOC-09  
**Version:** 1.0  
**Last Updated:** 2026-08-20  
**Owner:** UI/UX Design  
**Status:** Draft  
**Upstream Dependencies:** DOC-08 (UI/UX Specification)  
**Downstream Dependents:** DOC-10 (Design Rules), DOC-11 (Frontend Architecture)

---

## Table of Contents

1. [System Overview](#1-system-overview)
2. [Color Palette](#2-color-palette)
3. [Theme Semantic Colors](#3-theme-semantic-colors)
4. [Typography](#4-typography)
5. [Spacing System](#5-spacing-system)
6. [Radius & Corner Styling](#6-radius--corner-styling)
7. [Decision Registry Extract](#7-decision-registry-extract)
8. [Document Status](#8-document-status)

---

## 1. System Overview

**DS-001**

The TAEED Design System is completely codified in Flutter within the `lib/design_system/` directory.

All components MUST utilize the predefined constants from `AppPalette`, `AppThemeColors`, `AppSpacing`, `AppRadius`, and `AppTypography`. Hardcoded values (e.g., `Color(0xFF...)` or `SizedBox(height: 15)`) outside of this directory are strictly prohibited.

---

## 2. Color Palette

**DS-002**

The core brand palette (`AppPalette`).

| Color Name | Hex Value | Usage context |
|------------|-----------|---------------|
| **Orange** | `#F44A22` | Primary brand color, actions, success, warning, destructive. |
| **Midnight** | `#161616` | Background in dark mode, text in light mode. |
| **Silver** | `#FEF8E8` | Background in light mode, text in dark mode. |
| **Grey** | `#E4E2E3` | Dividers, borders, tertiary text (light mode). |
| **Stone** | `#A8AAAC` | Secondary text, borders (dark mode). |

---

## 3. Theme Semantic Colors

**DS-003**

Defined in `AppThemeColors`. TAEED supports both Light and Dark themes, with Dark Mode as the primary aesthetic.

### 3.1 Backgrounds & Surfaces

| Token | Dark Mode (`AppThemeColors.dark`) | Light Mode (`AppThemeColors.light`) |
|-------|-----------------------------------|-----------------------------------|
| `background` | Midnight (`#161616`) | Silver (`#FEF8E8`) |
| `surface` | Midnight (`#161616`) | Silver (`#FEF8E8`) |
| `surfaceElevated`| Midnight (`#161616`) | Silver (`#FEF8E8`) |
| `cardBackground` | Midnight (`#161616`) | Silver (`#FEF8E8`) |
| `cardBackgroundLight`| Midnight (`#161616`) | Silver (`#FEF8E8`) |
| `tabBar` | Midnight (`#161616`) | Silver (`#FEF8E8`) |

> [!NOTE]
> Currently, surface and card backgrounds match the primary background in both themes. Depth is achieved via borders and blurs, not elevated background colors.

### 3.2 Primary Colors

| Token | Value (Both Modes) | Opacity / Note |
|-------|--------------------|----------------|
| `primary` | Orange (`#F44A22`) | Primary actions |
| `primaryDark` | Orange (`#F44A22`) | Same as primary |
| `primaryMuted` | Orange (`#F44A22`) | Dark: 12% opacity (`0x1FF44A22`). Light: 8% opacity (`0x14F44A22`). |
| `glowPrimary` | Orange (`#F44A22`) | 20% opacity (`0x33F44A22`) |

### 3.3 Text & Iconography

| Token | Dark Mode (`AppThemeColors.dark`) | Light Mode (`AppThemeColors.light`) |
|-------|-----------------------------------|-----------------------------------|
| `text` | Silver (`#FEF8E8`) | Midnight (`#161616`) |
| `textSecondary`| Stone (`#A8AAAC`) | Stone (`#A8AAAC`) |
| `textTertiary` | Grey (`#E4E2E3`) | Grey (`#E4E2E3`) |
| `textInverted` | Midnight (`#161616`) | Silver (`#FEF8E8`) |

### 3.4 Borders & Dividers

| Token | Dark Mode (`AppThemeColors.dark`) | Light Mode (`AppThemeColors.light`) |
|-------|-----------------------------------|-----------------------------------|
| `border` | Stone (`#A8AAAC`) | Grey (`#E4E2E3`) |
| `divider` | Stone (`#A8AAAC`) | Grey (`#E4E2E3`) |

### 3.5 Semantic States

| Token | Value (Both Modes) |
|-------|--------------------|
| `success` | Orange (`#F44A22`) |
| `warning` | Orange (`#F44A22`) |
| `destructive`| Orange (`#F44A22`) |
| `info` | Stone (`#A8AAAC`) |
| `gold` | Orange (`#F44A22`) |

> [!CAUTION]
> TAEED relies heavily on its brand Orange (`#F44A22`) for almost all semantic states (success, warning, destructive). Design Rules (DOC-10) must ensure that iconography and copy clearly differentiate these states since color alone will not.

### 3.6 Data Visualization (Health & Evidence)

| Token | Value (Both Modes) |
|-------|--------------------|
| `evidenceGreen`| Stone (`#A8AAAC`) |
| `confidenceBlue`| Stone (`#A8AAAC`) |
| `riskRed` | Orange (`#F44A22`) |
| `neutralGrey` | Grey (`#E4E2E3`) |

---

## 4. Typography

**DS-004**

Defined in `AppTypography`. Three distinct font families are used to establish hierarchy and purpose.

### 4.1 Font Families

| Role | Family | Fallback |
|------|--------|----------|
| **Display & Titles** | SF Pro Rounded | System rounded |
| **Body & UI** | SF Pro Display | System default |
| **Metrics & Code** | SF Mono | System mono |

### 4.2 Text Styles

| Token | Size | Weight | Font Family |
|-------|------|--------|-------------|
| **brandHero** | 64 | 900 (Black) | SF Pro Rounded |
| **brandLogo** | 32 | 900 (Black) | SF Pro Rounded |
| **display** | 56 | 900 (Black) | SF Pro Rounded |
| **displayMedium** | 42 | 800 (Heavy) | SF Pro Rounded |
| **hero** | 40 | 700 (Bold) | SF Pro Rounded |
| **title1** | 34 | 700 (Bold) | SF Pro Rounded |
| **title2** | 28 | 700 (Bold) | SF Pro Rounded |
| **title3** | 22 | 600 (Semibold)| SF Pro Rounded |
| **title4** | 18 | 600 (Semibold)| SF Pro Rounded |
| **headline** | 17 | 600 (Semibold)| System Default |
| **bodyMedium** | 16 | 500 (Medium) | System Default |
| **body** | 16 | 400 (Regular) | System Default |
| **subheadline** | 15 | 400 (Regular) | System Default |
| **callout** | 14 | 500 (Medium) | System Default |
| **footnote** | 13 | 400 (Regular) | System Default |
| **caption** | 12 | 500 (Medium) | System Default |
| **caption2** | 11 | 400 (Regular) | System Default |
| **label** | 10 | 600 (Semibold)| System Default |
| **metricLarge** | 48 | 900 (Black) | SF Mono |
| **metric** | 32 | 700 (Bold) | SF Mono |
| **mono** | 13 | 400 (Regular) | SF Mono |
| **monoSmall** | 11 | 500 (Medium) | SF Mono |

---

## 5. Spacing System

**DS-005**

Defined in `AppSpacing`. Used for padding, margins, and gaps.

| Token | Value | Base Multiplier |
|-------|-------|-----------------|
| `xxxs` | 2.0 | Base / 4 |
| `xxs` | 4.0 | Base / 2 |
| `xs` | 8.0 | Base (8pt) |
| `sm` | 12.0 | Base * 1.5 |
| `md` | 16.0 | Base * 2 |
| `lg` | 24.0 | Base * 3 |
| `xl` | 32.0 | Base * 4 |
| `xxl` | 48.0 | Base * 6 |
| `xxxl` | 64.0 | Base * 8 |

---

## 6. Radius & Corner Styling

**DS-006**

Defined in `AppRadius`. Used for `BorderRadius` throughout the app.

| Token | Value | Usage |
|-------|-------|-------|
| `sm` | 8.0 | Small elements, inner tags, small imagery. |
| `md` | 12.0 | Standard buttons, input fields, small cards. |
| `lg` | 16.0 | Standard cards, feed items. |
| `xl` | 24.0 | Large containers, modal bottom sheets. |
| `full` | 9999.0| Pills, circular avatars, round action buttons. |

---

## 7. Decision Registry Extract

No new overarching product decisions are established in this document. It documents the implemented design system tokens from the codebase.

---

## 8. Document Status

**STATUS:** Draft  
**REVIEW STATE:** Needs Review

### Consistency Check

| Check | Result |
|-------|--------|
| Matches exactly with `lib/design_system/app_colors.dart` | ✅ |
| Matches exactly with `lib/design_system/app_spacing.dart` | ✅ |
| Matches exactly with `lib/design_system/app_typography.dart` | ✅ |
| Supports Dark Mode default philosophy (DEC-004) | ✅ |

### Next Actions

1. Proceed to DOC-10 (Design Rules) to establish guidelines on *how* to use this system.
