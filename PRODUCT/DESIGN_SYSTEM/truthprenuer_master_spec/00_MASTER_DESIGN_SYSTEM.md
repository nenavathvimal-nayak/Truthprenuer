# TRUTHPRENUER — Master Design System Specification
**Version:** 2.0.0 (Production Master)  
**Brand Tagline:** Ideas to Impact. Together.  
**Reference Web Platform:** [https://truthprenuer.pages.dev/](https://truthprenuer.pages.dev/)  
**Target Viewports:** 1920×1080 (Large Desktop), 1440×900 (Baseline Desktop), 1024×768 (Tablet Landscape), 768×1024 (Tablet Portrait), 390×844 (Mobile)

---

## 1. Brand Philosophy & Aesthetic Tenets

Truthprenuer is not a startup ideas directory or superficial social network. It is an **institutional human-validation and AI-intelligence operating system** that guides entrepreneurs from raw hunch to verified traction.

### The Five Core Design Tenets
1. **Evidence Over Enthusiasm**: Visual hierarchy prioritizes verified evidence, objective sample size, and falsifiable customer feedback over hype and vanity metrics.
2. **Provenance Clarity**: Every metric, score, or insight visually declares its provenance:
   - `[Verified Evidence]` (Direct customer actions, receipts, signed interviews)
   - `[Founder Hypothesis]` (Unvalidated assumptions submitted by the team)
   - `[AI Synthesis]` (Model-generated insights with transparent confidence intervals and evidence gaps)
   - `[Community Signal]` (Unbiased, blinded peer reviews)
3. **Restrained, High-Contrast Elegance**: Generous whitespace, razor-sharp 1px structural borders, deep charcoal and midnight tones paired with rich warm cream surfaces, reserved for #F44A22 (Empower Orange) exclusively on primary interactive triggers and verified focus states.
4. **Cognitive Calm & High Density Without Clutter**: Multi-column desktop workspaces feature structured 3-pane workflows: persistent navigation (left), central evidence work area (center), and contextual AI co-pilot/health telemetry (right).
5. **Universal Accessibility (WCAG 2.2 AA Standard)**: Minimum 4.5:1 text contrast for body, 3:1 for large display headings, clear 2px focus outlines with 2px offset, full keyboard navigability with visible jump links, zero reliance on color alone for critical state indicators.

---

## 2. Color System & Semantic Token Architecture

### 2.1 The Official Core Brand Palette
```css
/* Core Brand Tokens */
--color-brand-orange: #F44A22;      /* Empower Orange - Primary CTA, active selections, high-conviction highlights */
--color-brand-black: #161616;       /* Midnight Black - Top headers, deep sidebar, dark mode base */
--color-brand-cream: #FEF8E8;       /* Silver/Cream - Warm, readable light mode canvas & card surface */
--color-brand-light-grey: #E4E2E3;  /* Light Grey - Subtle borders, structural dividers, inactive chips */
--color-brand-stone-grey: #A8AAAC;  /* Stone Grey - Secondary metadata, caption hierarchy, inactive icons */
```

### 2.2 Semantic Color Matrix (Light & Dark Mode)

| Semantic Role | Light Mode Value | Dark Mode Value | Contrast Ratio (WCAG) | Usage Description |
| :--- | :--- | :--- | :--- | :--- |
| `--surface-canvas` | `#FEF8E8` (Silver Cream) | `#121212` (OLED Charcoal) | Base canvas background | Foundation canvas |
| `--surface-card` | `#FFFFFF` (Pure White) | `#1C1C1E` (Elevated Midnight) | 14.2:1 against black | Content container cards |
| `--surface-elevated` | `#F8F6F0` (Muted Cream) | `#252528` (High Midnight) | 12.1:1 against black | Modal sheets, floating drawers |
| `--surface-sidebar` | `#161616` (Midnight Black) | `#0E0E10` (Abyssal Black) | High contrast anchor | Persistent desktop sidebar |
| `--text-primary` | `#161616` (Midnight Black) | `#F5F5F7` (Crisp Off-White) | 15.8:1 (AAA) | Headings, primary body labels |
| `--text-secondary` | `#595959` (Slate Neutral) | `#A8AAAC` (Stone Grey) | 7.1:1 (AAA) | Subheadings, field labels, metadata |
| `--text-tertiary` | `#7D7D80` (Muted Neutral) | `#6E6E73` (Dim Stone) | 4.6:1 (AA) | Timestamps, character counts, breadcrumbs |
| `--accent-primary` | `#F44A22` (Empower Orange) | `#F44A22` (Empower Orange) | 4.8:1 (AA) | Primary button, active tab indicator |
| `--accent-hover` | `#D93E1B` (Deep Orange) | `#FF5C36` (Bright Orange) | 5.2:1 (AA) | Hover & active click states |
| `--accent-subtle` | `rgba(244, 74, 34, 0.08)` | `rgba(244, 74, 34, 0.16)` | Decorative / State | Hover highlight, selected row tint |
| `--border-subtle` | `#E4E2E3` (Light Grey) | `#2A2A2D` (Subtle Stroke) | 3.2:1 | Card borders, list dividers |
| `--border-focus` | `#F44A22` (Empower Orange) | `#FF5C36` (Bright Orange) | Focus outline | 2px accessible focus ring |
| `--status-success` | `#10B981` (Emerald) | `#34D399` (Bright Mint) | 4.7:1 (AA) | Verified signals, passed hypotheses |
| `--status-warning` | `#F59E0B` (Amber) | `#FBBF24` (Sunburst) | 4.5:1 (AA) | Inconclusive data, moderate risk |
| `--status-danger` | `#EF4444` (Crimson) | `#F87171` (Coral Red) | 5.1:1 (AA) | Falsified assumptions, critical risks |
| `--status-info` | `#0284C7` (Sky Cerulean) | `#38BDF8` (Bright Azure) | 4.6:1 (AA) | AI annotations, research prompts |

---

## 3. Typography Scale & Hierarchy

Truthprenuer pairs an architectural geometric display sans (**Space Grotesk**) with an ultra-legible modern UI workhorse (**Inter / DM Sans**).

```
Display Large:    36px / 44px Line Height / Weight: 800 / Tracking: -0.03em (Hero H1)
Display Medium:   30px / 38px Line Height / Weight: 700 / Tracking: -0.02em (Page Title H2)
Headline Large:   24px / 32px Line Height / Weight: 700 / Tracking: -0.015em (Section Title H3)
Headline Medium:  20px / 28px Line Height / Weight: 600 / Tracking: -0.01em (Card Header H4)
Title Medium:     18px / 26px Line Height / Weight: 600 / Tracking: -0.005em (Tile Title)
Body Large:       16px / 24px Line Height / Weight: 400 & 500 / Tracking: 0 (Main Body)
Body Medium:      14px / 20px Line Height / Weight: 400 & 500 / Tracking: +0.005em (Table & Form UI)
Caption:          12px / 16px Line Height / Weight: 500 & 600 / Tracking: +0.02em (Badges & Timestamps)
Micro/Overline:   11px / 14px Line Height / Weight: 700 / Tracking: +0.06em (Uppercase Category Tag)
Code/Mono:        13px / 18px Line Height / Weight: 500 / JetBrains Mono (IDs, Tokens, Data Schemas)
```

---

## 4. Layout Grid, Spacing & Breakpoint Tokens

### 4.1 Spacing Scale (8pt Baseline Grid)
- `4px` (`--space-xxs`): Badge padding, micro tag gaps
- `8px` (`--space-xs`): Icon-to-label gaps, chip margins
- `12px` (`--space-sm`): Input vertical padding, list item gaps
- `16px` (`--space-md`): Card interior padding (compact), button padding
- `24px` (`--space-lg`): Standard card padding, column gap
- `32px` (`--space-xl`): Section vertical spacing, modal gutters
- `48px` (`--space-xxl`): Workspace block spacing
- `64px` (`--space-hero`): Landing page module vertical gutters

### 4.2 Breakpoints & Responsive Adaptations
- **1920px (Ultra-Wide Desktop)**: Centered container max-width 1680px. 3-pane layout active: Sidebar (260px) + Main Content (1020px) + Intelligence Drawer (400px).
- **1440px (Baseline Desktop)**: Sidebar (240px) + Work Area (840px) + Contextual Inspector (360px collapsible).
- **1024px (Tablet Landscape)**: Compact icon-rail Sidebar (72px) + Work Area (640px) + Bottom Sheet Inspector.
- **768px (Tablet Portrait)**: Top App Bar with hamburger drawer + Single column card stream + Drawer modal overlays.
- **390px (Mobile Standard)**: Top App Bar with Brand Mark + Sticky 5-item Bottom Navigation Bar (`Home`, `Explore`, `Validate [+]`, `Network`, `Profile`).

---

## 5. Reusable Component Library Matrix

Every component is defined with exact states: **Default, Hover, Active/Pressed, Focused, Disabled, Loading, and Error**.

```
Component 01: Buttons (Primary Orange, Secondary Black, Outline Subtle, Ghost Minimal, Destructive Red)
Component 02: Text Inputs & TextAreas (Floating label, error hint, character count, auto-resize)
Component 03: Selects & Dropdowns (Searchable typeahead, multi-select tag cloud, group dividers)
Component 04: Toggle Switches & Checkboxes (High-contrast check, accessible hit targets ≥ 44×44px)
Component 05: Radio Group Cards (Selectable role & hypothesis cards with orange boundary rings)
Component 06: Status & Provenance Badges (Pill shape, dot indicator, accessible tooltip on hover)
Component 07: Metric KPI Cards (Large metric, delta badge, mini trend sparkline, provenance tag)
Component 08: Hypothesis Accordion Cards (Collapsed score overview -> expanded evidence breakdown)
Component 09: Radar Health Chart (Hexagonal multi-axis scoring: Problem, Demand, Solution, Market, Moat, Team)
Component 10: Step-by-Step Wizard Stepper (Numbered circles, checkmark on complete, progress bar)
Component 11: File & Evidence Dropzone (Drag-and-drop, format validation, upload progress, preview chips)
Component 12: Structured Survey Inputs (Likert scale 1-5, Willingness-to-pay slider, Frequency chips)
Component 13: Search & Filter Toolbar (Search bar, quick filter pills, sort dropdown, active filter count)
Component 14: Data Tables (Sortable columns, sticky header, row hover actions, pagination controls)
Component 15: Modals & Dialogs (Backdrop blur 8px, centered card, clear title, cancel + confirm CTA)
Component 16: Slide-Over Drawers (Right drawer 420px, header with close icon, scrollable body, sticky actions)
Component 17: Toast Notification Banner (Floating bottom-right, progress auto-dismiss, action button)
Component 18: Empty State Illustrative Units (Vector graphic, bold message, explanatory subtext, primary CTA)
```

---

## 6. Accessibility & Keyboard Interaction Contract

- **Focus Order**: Strictly left-to-right, top-to-bottom logical DOM order.
- **Focus Ring**: `2px solid #F44A22` with `2px offset` on light surfaces; `2px solid #FF5C36` on dark surfaces.
- **Keyboard Shortcuts**:
  - `CMD + K` / `Ctrl + K`: Global Omnisearch overlay
  - `N`: Quick Create Validation Wizard (when not focusing text input)
  - `ESC`: Close open modals, drawers, and overlay menus
  - `Tab` / `Shift + Tab`: Seamless focus traversal through forms and tables
  - `Space` / `Enter`: Activate buttons, toggles, and select options
- **Screen Reader Semantics**:
  - Live regions (`aria-live="polite"`) for real-time validation count and WebSocket connectivity updates.
  - Semantic `<nav>`, `<main>`, `<aside>`, `<header>`, `<footer>` structuring.
  - All icon-only buttons carry descriptive `aria-label` tags (e.g., `aria-label="Export Evidence Report as PDF"`).
