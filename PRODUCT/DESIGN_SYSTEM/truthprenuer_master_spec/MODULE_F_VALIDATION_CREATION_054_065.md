# TRUTHPRENUER — MODULE F: VALIDATION CREATION & MANAGEMENT
## Screens 054 – 065 Specification

---

### Module Overview
- **Domain:** Step-by-Step Validation Authoring, Hypothesis Decomposition & Research Protocol Design
- **Core Principle:** Prevent vanity pitches by guiding founders through structured, falsifiable hypothesis modeling.
- **Workflow Mechanics:**
  - 10-Step Wizard with persistent top stepper bar and autosave feedback ("Draft saved 12s ago").
  - Back navigation that preserves filled form states without page reloads.
  - Contextual AI suggestions drawer ("Stress-test this problem statement with AI").
  - Clear visibility pre-flight check before publishing.

---

### Screen 054: Create Validation — Introduction
- **Screen ID:** `SCR-054`
- **Route:** `/app/validations/create`
- **Purpose:** Onboard the founder into the creation flow; set expectations on the 10-15 minute setup process.
- **Visuals:** Breakdown of the 4 required validation pillars: Problem, Customer, Economics, Evidence.
- **Action:** "Start New Validation" (`#F44A22` button) or "Resume Draft (EcoPack - 40% complete)".

---

### Screen 055: Validation Type Selection
- **Screen ID:** `SCR-055`
- **Route:** `/app/validations/create/type`
- **Selection Grid:**
  - **1. Problem Discovery (Pre-Product):** Test whether the underlying pain actually exists and is severe enough.
  - **2. Solution Concept & Value Prop:** Test whether your proposed solution resonance beats alternatives.
  - **3. Pricing & Willingness-to-Pay:** Measure elasticity, Van Westendorp price sensitivity, and buying intent.
  - **4. Feature Prioritization / Pivot:** Test new verticals or pivots for an existing product.

---

### Screen 056: Problem Statement Builder
- **Screen ID:** `SCR-056`
- **Route:** `/app/validations/create/problem`
- **Interactive Form:**
  - Core Pain Point (Textarea with counter, recommended 100-250 characters).
  - Current Workarounds: "How are people solving this today?" (e.g., messy spreadsheets, expensive consultants).
  - Frequency & Severity: Dropdown (Daily, Weekly, Monthly) + Severity rating slider (1: Minor annoyance to 5: Existential blocker).
  - AI Assistant Pill: "Check for Confirmation Bias in your wording".

---

### Screen 057: Target Customer Definition
- **Screen ID:** `SCR-057`
- **Route:** `/app/validations/create/customer`
- **Inputs:**
  - Persona Label (e.g., "VP of Supply Chain at mid-market D2C e-commerce brands").
  - Company Size / Revenue Band or Consumer Demographics.
  - Geographic Scope (Global, North America, UK/Europe, APAC).
  - Excluded Customers: (e.g., "Exclude dropshippers and enterprise brands > 10,000 employees").

---

### Screen 058: Proposed Solution Details
- **Screen ID:** `SCR-058`
- **Route:** `/app/validations/create/solution`
- **Inputs:**
  - Solution Overview (What does the product actually do in 2 sentences?).
  - Delivery Mechanism: Web App / Mobile App / API / Physical Hardware / Tech-Enabled Service.
  - Mockups / Wireframes Upload: Drag-and-drop zone supporting PNG/Figma embeds/PDFs.

---

### Screen 059: Value Proposition Builder
- **Screen ID:** `SCR-059`
- **Route:** `/app/validations/create/value-prop`
- **Structured Framework:**
  - For `[Target Customer]` who `[Experience this Problem]`, our solution `[Key Capability]` that allows them to `[Primary Quantifiable Benefit]`, unlike `[Current Alternative]`.
  - Preview card renders the generated value proposition in real-time.

---

### Screen 060: Business Model & Pricing Hypothesis
- **Screen ID:** `SCR-060`
- **Route:** `/app/validations/create/pricing`
- **Inputs:**
  - Revenue Model: B2B SaaS Subscription / Marketplace Take Rate / One-Time Purchase / Usage-Based.
  - Target Price Point: Currency selector + numeric value (e.g., $49/month/seat).
  - Hypothesis Formulation: *"Customers will pay $49/mo because it eliminates $400/mo in manual compliance labor."*

---

### Screen 061: Assumptions & Hypothesis Setup
- **Screen ID:** `SCR-061`
- **Route:** `/app/validations/create/hypotheses`
- **Dynamic Table / Repeater:**
  - Allows adding up to 5 core hypotheses.
  - Each item includes: Statement, Risk Level (High / Medium / Low), Falsification Condition (e.g., *"If fewer than 40% of reviewers say they would use this weekly, this hypothesis fails"*).

---

### Screen 062: Evidence & Supporting Documents Upload
- **Screen ID:** `SCR-062`
- **Route:** `/app/validations/create/evidence`
- **Multi-File Upload Area:**
  - Supports: Audio recordings (.mp3/.m4a), Interview transcripts (.pdf/.docx), Survey spreadsheets (.csv/.xlsx), Analytics links.
  - Tag each file to specific hypotheses configured in Screen 061.

---

### Screen 063: Research Questions & Feedback Design
- **Screen ID:** `SCR-063`
- **Route:** `/app/validations/create/questions`
- **Questionnaire Builder:**
  - Question 1: Unbiased Problem Frequency (Multiple choice).
  - Question 2: Solution Comprehension check (Open text).
  - Question 3: Willingness to Pay ($0, $1-20, $21-50, $51-100, $100+).
  - Question 4: "What is the biggest reason you would NOT buy this?" (Mandatory blocker analysis).

---

### Screen 064: Audience, Visibility & Participation Settings
- **Screen ID:** `SCR-064`
- **Route:** `/app/validations/create/audience`
- **Privacy & Visibility Selector:**
  - **Public:** Listed on Explore, indexable, open to all community reviewers.
  - **Community Only:** Only visible to logged-in verified validators on Truthprenuer.
  - **Private / Invite-Only:** Only accessible via secure cryptographically signed link.
  - Feedback Quota: Target number of completed reviews (e.g., 25, 50, 100).

---

### Screen 065: Validation Review & Publish
- **Screen ID:** `SCR-065`
- **Route:** `/app/validations/create/review`
- **Pre-Flight Summary:**
  - Completeness Score: 95% (Ready to Publish).
  - Privacy Warning: Clearly lists what is public vs. private.
  - Actions: "Save as Draft" | "Publish & Launch Study" (`#F44A22` primary button) -> Routes to `SCR-066` / `SCR-067`.
