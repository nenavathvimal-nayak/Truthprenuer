# TRUTHPRENUER — MODULE L: DECISIONS, EXPERIMENTS & REPORTING
## Screens 116 – 122 Specification

---

### Module Overview
- **Domain:** Decision Accounting, Falsification Experimentation, Milestone Timelines & Investor Diligence Export
- **Core Purpose:** Transform raw feedback and AI synthesis into immutable, accountable strategic actions.
- **Accountability Rule:** Every pivot or commit decision is permanently logged with the date, decider, reasoning, and linked evidence IDs.

---

### Screen 116: Decision Log
- **Screen ID:** `SCR-116`
- **Route:** `/app/validations/:id/decisions`
- **Chronological Ledger:**
  - Decision 1 (Oct 8, 2026): **Pivot Pricing Model** from $19/mo consumer to $49/mo B2B team tier. (Decider: Founder Sarah J. • Cites: AI Pricing Report & 12 Validator Quotes).
  - Decision 2 (Sep 24, 2026): **Deprecate Feature "AI Auto-Writer"** due to low customer resonance (8% interest).
  - Filter: All Decisions / Pivots / Feature Kills / Go-to-Market Commits / Capital Allocations.

---

### Screen 117: Create a Decision Record
- **Screen ID:** `SCR-117`
- **Route:** `/app/validations/:id/decisions/new`
- **Structured Decision Form:**
  - Decision Title (e.g., "Pivot Target Customer from Freelancers to Mid-Market Agencies").
  - Type: Strategic Pivot / Feature Deprecation / Pricing Revision / Audience Refinement / Project Shutdown.
  - Core Rationale (Rich text).
  - Linked Evidence Items (Multi-select dropdown from Evidence Locker).
  - Target Re-Validation Date (e.g., Check back in 30 days).

---

### Screen 118: Experiment Planner
- **Screen ID:** `SCR-118`
- **Route:** `/app/validations/:id/experiments`
- **Kanban Experiment Board:**
  - Column 1: **Backlog / Proposed Experiments** (e.g., "Test $49/mo landing page").
  - Column 2: **Running Active Tests** (e.g., "10 IT Security In-Depth Interviews").
  - Column 3: **Awaiting Analysis** (e.g., "Typeform B2B Enterprise Survey").
  - Column 4: **Concluded & Logged** (e.g., "Feature Resonance Smoke Test").

---

### Screen 119: Experiment Detail & Results
- **Screen ID:** `SCR-119`
- **Route:** `/app/validations/:id/experiments/:expId`
- **Card Elements:**
  - Experiment Name & Hypothesis Tested.
  - Success Metric / Falsification Threshold (e.g., Target: > 15% conversion rate; Actual: 19.4% — Success).
  - Run Dates, Cost / Budget Spent ($120 on ads), Sample Size (N = 450).
  - Outcome Summary & Resulting Decision link.

---

### Screen 120: Recommended Next Steps
- **Screen ID:** `SCR-120`
- **Route:** `/app/validations/:id/next-steps`
- **Priority Road Map:** Top 3 sequential actions to de-risk the startup this sprint.

---

### Screen 121: Validation Progress & Timeline
- **Screen ID:** `SCR-121`
- **Route:** `/app/validations/:id/timeline`
- **Gantt / Milestone View:** Visual history showing incubation trajectory: Idea Formulated -> Discovery Interviews -> Pricing Stress Test -> Health Score Breakthrough -> Investor Diligence Readiness.

---

### Screen 122: Exportable Validation Report
- **Screen ID:** `SCR-122`
- **Route:** `/app/validations/:id/export`
- **Export Formats & Options:**
  - **Comprehensive 12-Page PDF Dossier:** Executive brief, health radar, evidence catalog, quote appendices, AI stress-test summary.
  - **Pitch Deck Slide Insert:** High-resolution 16:9 PNG graphic summarizing validation metrics for pitch decks.
  - **Raw Data Export (ZIP):** CSV of anonymized validator responses + JSON manifest of evidence checksums.
  - Live Watermark & Redaction options for sensitive IP.
