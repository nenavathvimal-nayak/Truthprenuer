# TRUTHPRENUER — MODULE A: PUBLIC WEBSITE & MARKETING
## Screens 001 – 015 Specification

---

### Module Overview
- **Domain:** Public Marketing, Acquisition, Education & Conversion
- **Target Audience:** Prospective founders, investors, validators, student builders, enterprise innovation leads, public visitors
- **Primary Objective:** Communicate Truthprenuer's core value proposition ("Ideas to Impact. Together."), demystify the human + AI validation loop, educate on the dangers of confirmation bias and vanity metrics, and drive qualified signups into the onboarding funnel.
- **Brand System Integration:**
  - Background: Light Mode `#FEF8E8` (Silver/Cream) with clean white `#FFFFFF` cards; Dark Mode `#161616` (Midnight Black) with `#1F1F1F` cards.
  - Accent: `#F44A22` (Empower Orange) reserved for high-intent conversion buttons, active tab indicators, and critical callouts.
  - Borders: `#E4E2E3` (Light Mode) / `#2A2A2A` (Dark Mode).
  - Provenance Distinction: Clear badges indicating illustrative demo data versus real verified user proof.

---

### Screen 001: Homepage / Main Landing Page
- **Screen ID:** `SCR-001`
- **Route:** `/`
- **Target Viewport:** 1440 × 900 (Baseline), 1024 tablet, 390 mobile
- **Primary Persona:** First-time visitor / inquisitive founder
- **Primary CTA:** "Validate Your Idea Free" (`#F44A22` filled button) -> Routes to `SCR-017` / `SCR-026`
- **Secondary CTA:** "Explore Public Validations" (Outlined button) -> Routes to `SCR-037`

#### Desktop Layout Wireframe (1440px)
```
+----------------------------------------------------------------------------------------------------+
| [Logo] TRUTHPRENUER      How it Works   Features   AI & Human   Pricing   Blog   | [Log In] [Start Free] |
+----------------------------------------------------------------------------------------------------+
|                                                                                                    |
|    TAGLINE: IDEAS TO IMPACT. TOGETHER.                                                             |
|    HERO HEADING: Stop Building What Nobody Wants. Validate with Real Human Truth + AI Rigor.       |
|    SUBHEAD: Get brutally honest feedback from verified buyers, domain mentors, and multi-agent      |
|             market evidence before you spend your life savings or 6 months of code.                 |
|                                                                                                    |
|    [CTA: Validate Your Idea Now ->]    [Watch 2-Min Interactive Demo (Play)]                       |
|                                                                                                    |
|    +------------------------------------------------------------------------------------------+    |
|    | LIVE VALIDATION PULSE PREVIEW (Interactive Card)                                         |    |
|    | Project: EcoPack Zero-Waste Shipping Envelope       [Stage: Assumption Testing]          |    |
|    | Confidence Signal: 74% (Moderate High)             Responses: 48 Verified Validators    |    |
|    | [Human Signal: 68% Willingness to Pay $1.20/unit]   [AI Synthesis: Market Risk Low]      |    |
|    | Evidence Trail: 3 Customer Interview Audio Clips | 2 Competitor Tear-downs Linked         |    |
|    +------------------------------------------------------------------------------------------+    |
|                                                                                                    |
|    TRUST & PROVENANCE BARRIER:                                                                     |
|    "Zero vanity upvotes. Zero fake traction. 100% auditable evidence trails."                      |
|                                                                                                    |
|    KEY CAPABILITIES (3-Column Grid):                                                               |
|    [1. Assumption Decomposition]   [2. Human Panel Truth]          [3. Multi-Agent Synthesis]      |
|    Deconstruct your pitch into     Targeted questionnaires with    Cross-references interview data |
|    falsifiable hypotheses.         verified willingness-to-pay.    against live market signals.    |
|                                                                                                    |
|    FOOTER: Sitemap | Legal | Privacy | Status | (C) 2026 Truthprenuer Inc.                          |
+----------------------------------------------------------------------------------------------------+
```

#### Responsive Breakpoint Adaptations
- **1024px Tablet:** Top navigation collapses secondary links into a condensed menu; hero validation card stacks horizontally.
- **768px Tablet:** Single-column hero copy; validation preview card reduces metadata fields to confidence score and top finding.
- **390px Mobile:** Sticky bottom bar with "Start Free" CTA; burger menu for navigation; touch-friendly 48px tap targets.

#### Interactive States
- **Hero Video Modal:** Triggered on "Watch 2-Min Demo" — renders accessible dialog with closed captions.
- **Interactive Card Toggle:** Visitors can toggle sample projects between "B2B SaaS", "D2C Hardware", and "Marketplace".

---

### Screen 002: How Truthprenuer Works
- **Screen ID:** `SCR-002`
- **Route:** `/how-it-works`
- **Primary Persona:** Skeptical founder seeking methodology explanation
- **Primary CTA:** "Deconstruct Your Pitch" -> Routes to `SCR-054`
- **Core Visual:** 5-Step Continuous Process Stepper with interactive drill-down cards:
  1. *Deconstruct Assumptions:* Break pitch into Problem, Audience, Willingness-to-Pay, and Feasibility hypotheses.
  2. *Design Blind Test:* Formulate unbiased questions avoiding confirmation bias.
  3. *Collect Human Truth:* Engage verified reviewers, potential customers, and domain mentors.
  4. *Run AI Evidence Engine:* Multi-perspective agent analysis identifying contradictions and blind spots.
  5. *Commit Decisive Action:* Formulate actionable pivots, kill decisions, or validated experiments.

---

### Screen 003: Product Features Overview
- **Screen ID:** `SCR-003`
- **Route:** `/features`
- **Layout Architecture:** Modular Bento-Grid showcasing Truthprenuer core platform features:
  - Feature A: **Hypothesis Builder** with falsifiability metrics.
  - Feature B: **Evidence Locker** with cryptographic provenance hashes and multi-format support (PDF, Audio, CSV).
  - Feature C: **Bias-Free Feedback Collector** with randomized response choices.
  - Feature D: **Truth Confidence Radar** (6-axis diagnostic).
  - Feature E: **Decision Audit Trail** keeping founders accountable to real data.

---

### Screen 004: Human Validation Explained
- **Screen ID:** `SCR-004`
- **Route:** `/human-validation`
- **Key Proposition:** Why AI alone cannot replace human commitment.
- **Core Elements:**
  - Breakdown of validator tiers (Verified Consumers, Industry Mentors, Investors, Technical Operators).
  - Anti-gaming mechanisms: Stated interest vs. Observed behavior tracking (e.g., pre-order deposits, waitlist actions).
  - Detailed side-by-side comparison: *Vanity Feedback (Reddit/Twitter)* vs. *Truthprenuer Structured Blind Feedback*.

---

### Screen 005: AI Validation Explained
- **Screen ID:** `SCR-005`
- **Route:** `/ai-validation`
- **Ethical AI Stance:** AI is a synthesis partner and stress-tester, not an infallible oracle.
- **Core Components:**
  - Visualization of the 4-Agent Synthesis Pipeline:
    - *Devil's Advocate Agent:* Actively seeks fatal flaws and counter-evidence.
    - *Market Intelligence Agent:* Analyzes competitive landscape and regulatory head-winds.
    - *Economic Viability Agent:* Evaluates unit economics and pricing friction.
    - *Synthesis Arbiter:* Weights evidence and outputs confidence scores with uncertainty bands.
  - Prominent disclaimer: *“AI Confidence scores represent internal consistency of collected evidence, not guaranteed market success.”*

---

### Screen 006: Startup Analysis & Intelligence
- **Screen ID:** `SCR-006`
- **Route:** `/intelligence`
- **Feature Showcase:** Deep dive into the automated 12-page Validation Dossier generated for every completed study.
- **Interactive Component:** Embedded interactive sample report with toggleable redaction controls and export options.

---

### Screen 007: Startup Health & Readiness
- **Screen ID:** `SCR-007`
- **Route:** `/health-radar`
- **Visual Centerpiece:** The Truthprenuer 6-Axis Health Radar:
  1. Problem Severity & Frequency
  2. Customer Willingness to Pay
  3. Market Headroom & Timing
  4. Technical / Execution Feasibility
  5. Evidence Robustness
  6. Regulatory / Defensibility Moat

---

### Screen 008: Use Cases by User Type
- **Screen ID:** `SCR-008`
- **Route:** `/use-cases`
- **Persona Filter Tabs:**
  - *Early-Stage Founders:* Test ideas before quitting full-time job.
  - *Accelerators & Incubators:* Track cohort validation velocity and diligence.
  - *Angel Investors & VCs:* Audit pre-seed traction claims with raw evidence.
  - *Product Managers:* Validate new feature verticals inside existing companies.
  - *University Entrepreneurs:* Academic-backed customer discovery tracking.

---

### Screen 009: Founder Success Stories & Case Studies
- **Screen ID:** `SCR-009`
- **Route:** `/case-studies`
- **Honest Case Studies (Success & Pivot Stories):**
  - Case A: *SaaS Pivot:* From "AI Meeting Assistant" to "Compliance Auditing for Remote Clinics" (Saved 9 months of engineering).
  - Case B: *Validated B2B Launch:* Logistics Route Optimizer secured 14 paid LOIs during validation stage.
  - Case C: *Graceful Kill:* D2C Coffee Subscription cancelled after 82% of target users rejected $24/bag pricing hypothesis.

---

### Screen 010: Pricing & Plans
- **Screen ID:** `SCR-010`
- **Route:** `/pricing`
- **Pricing Architecture:**
  - **Starter (Free):** 1 Active Validation, 15 Human Community Feedback slots, Basic AI Synthesis report.
  - **Founder Pro ($49/mo):** 5 Concurrent Validations, 100 Verified Feedback responses, Deep Evidence Locker, Exportable PDF dossiers.
  - **Studio & Syndicate ($199/mo):** Unlimited Validations, Targeted Panel Recruitment, Investor Diligence Portals, Team collaboration (5 seats).
  - **Billing Toggle:** Monthly vs. Annual (Save 20% with annual toggle).

---

### Screen 011: Pricing Comparison Table
- **Screen ID:** `SCR-011`
- **Route:** `/pricing/compare`
- **Complete Feature Matrix:** 42-row comparative table covering:
  - Validation Limits & Concurrency
  - Human Panel Types & Reviewer Screening
  - Evidence Locker Storage (GB) & Formats
  - AI Synthesis Depth & Multi-Agent Models
  - Export Options (PDF, JSON, CSV, Pitch Slide Deck)
  - Privacy Tiers (Public, Community, Secret/Encrypted)

---

### Screen 012: About Truthprenuer
- **Screen ID:** `SCR-012`
- **Route:** `/about`
- **Brand Story:** Founded to stop the epidemic of wasted founder years.
- **Mission:** Democratizing rigorous, bias-free validation so founders build what matters.
- **Leadership & Advisors:** Transparent team biographies with LinkedIn credentials and verified domain expertise.

---

### Screen 013: Blog & Articles Listing
- **Screen ID:** `SCR-013`
- **Route:** `/blog`
- **Content Categories:** Validation Methodologies, Customer Discovery Guides, Bias Avoidance, Pricing Experiments, Market Research.
- **Search & Filter:** Category chips, read-time filter, and newsletter subscribe drawer.

---

### Screen 014: Article Details Page
- **Screen ID:** `SCR-014`
- **Route:** `/blog/:slug`
- **Editorial Experience:** High-readability serif/sans typography, estimated reading time, table of contents, in-article downloadable validation templates, author bio, related case studies.

---

### Screen 015: Contact, Support & Enquiry Page
- **Screen ID:** `SCR-015`
- **Route:** `/contact`
- **Structured Enquiry Form:**
  - Inquiry Type (General, Accelerator Partnership, Validator Network, Enterprise Inquiry, Security Audit).
  - Direct office locations, support response SLA (< 4 hours for Pro, < 24 hours standard), and live status indicator.
