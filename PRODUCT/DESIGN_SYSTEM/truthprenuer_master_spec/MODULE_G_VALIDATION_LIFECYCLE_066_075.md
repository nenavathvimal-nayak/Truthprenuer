# TRUTHPRENUER — MODULE G: VALIDATION LIFECYCLE & MANAGEMENT
## Screens 066 – 075 Specification

---

### Module Overview
- **Domain:** Validation Project State Management, Public/Private Duality, Lifecycle Operations & Safe Deletion
- **Key Tenets:**
  - Strict privacy separation between public reviewer views and private founder management views.
  - Safe lifecycle state transitions (Draft -> Published -> Active -> Paused -> Completed -> Archived).
  - Robust data loss prevention with explicit confirmation dialogs requiring typed project names.

---

### Screen 066: Validation Detail — Public View
- **Screen ID:** `SCR-066`
- **Route:** `/v/:slug` or `/app/validations/:id/public`
- **Primary Persona:** External visitor, community validator, or investor reviewing a public validation.
- **Top Bar:** Project Title, Founder Bio snippet, Stage badge ("Community Validation Active"), Response progress ("38 / 50 Responses collected").
- **Content Panels:**
  - Executive Problem Summary.
  - Who this is for (Target Persona).
  - Proposed Solution description and approved screenshots.
  - Core Research Questions.
- **Primary Action:** "Give Honest Feedback" (`#F44A22` sticky button on desktop & mobile) -> Routes to `SCR-076`.
- **Privacy Enforcement:** Private financial forecasts, unredacted customer names, and internal notes are strictly hidden.

---

### Screen 067: Validation Detail — Private Founder View
- **Screen ID:** `SCR-067`
- **Route:** `/app/validations/:id`
- **Primary Persona:** Project owner / startup team
- **Layout Architecture:**
  - Full management toolbar: Edit, Settings, Pause/Resume, Run AI Synthesis, Export Report.
  - Real-Time Response Health: Live incoming responses ticker, response velocity chart, completion rate.
  - Hypothesis Status Board: Live meter for each of the 5 hypotheses (Green: Trending Confirmed, Amber: Inconclusive, Red: Trending Disproved).
  - Flagged Reviewer Insights: Unprocessed comments, contradictions, and critical concerns.

---

### Screen 068: Validation Overview & Status
- **Screen ID:** `SCR-068`
- **Route:** `/app/validations/:id/status`
- **Status Timeline:**
  - Visual status pill with color codes:
    - *Draft:* Grey `#A8AAAC`
    - *Active / Collecting Feedback:* Green `#10B981`
    - *Paused:* Amber `#F59E0B`
    - *Completed:* Indigo `#6366F1`
    - *Archived:* Charcoal `#4B5563`
  - Quota tracker: Displays days remaining until scheduled closing date.

---

### Screen 069: Edit Existing Validation
- **Screen ID:** `SCR-069`
- **Route:** `/app/validations/:id/edit`
- **Guardrails:**
  - If responses already exist (> 0), editing core hypothesis statements triggers a warning modal: *"Editing this hypothesis will version-tag previous 18 responses to Version 1.0 to preserve scientific validity."*
  - Editable without restriction: Non-binding descriptive text, media attachments, team member invites.

---

### Screen 070: Validation Settings
- **Screen ID:** `SCR-070`
- **Route:** `/app/validations/:id/settings`
- **Controls:**
  - Visibility mode toggle (Public vs. Community vs. Private).
  - Custom domain or vanity slug configuration (`truthprenuer.com/v/ecopack`).
  - Webhook notifications for new feedback (Slack, Discord, Email).
  - Anonymity toggle: Allow anonymous reviewer submissions (Yes/No).

---

### Screen 071: Validation Pause / Resume
- **Screen ID:** `SCR-071`
- **Route:** Modal dialog on `/app/validations/:id`
- **Functionality:** Temporarily freezes public submission form; visitors see a clean notification: *"This founder has temporarily paused feedback collection while analyzing recent findings."* Founder can resume with 1 click.

---

### Screen 072: Extend or Close Validation
- **Screen ID:** `SCR-072`
- **Route:** Modal dialog on `/app/validations/:id`
- **Options:**
  - Extend response quota (e.g., from 50 to 100 responses).
  - Close validation study early, locking feedback and triggering final AI Synthesis Dossier.

---

### Screen 073: Duplicate Validation / Create New Experiment
- **Screen ID:** `SCR-073`
- **Route:** `/app/validations/:id/branch`
- **Use Case:** Branching after a pivot (e.g., "EcoPack Experiment 2: B2B Enterprise Pricing Focus").
- **Workflow:** Clones hypotheses and structure while resetting response pools and linking back to Experiment 1 as parent lineage.

---

### Screen 074: Archive Validation
- **Screen ID:** `SCR-074`
- **Route:** `/app/validations/:id/archive`
- **Result:** Moves project to read-only archive; removes from public explore feeds but preserves all historic evidence and AI reports in founder's vault.

---

### Screen 075: Delete Validation Confirmation
- **Screen ID:** `SCR-075`
- **Route:** Modal dialog on `/app/validations/:id/delete`
- **Destructive Action Safety Protocol:**
  - Displays red warning banner (`#DC2626`): *"This action cannot be undone. All 48 validator responses, evidence files, and generated AI models will be permanently purged."*
  - Requires user to type the exact validation title (e.g., `EcoPack Zero-Waste Shipping Envelope`) to enable the "Permanently Delete Validation" button.
