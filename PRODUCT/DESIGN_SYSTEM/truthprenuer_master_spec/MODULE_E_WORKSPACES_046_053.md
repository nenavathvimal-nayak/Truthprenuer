# TRUTHPRENUER — MODULE E: HOME DASHBOARD & WORKSPACE
## Screens 046 – 053 Specification

---

### Module Overview
- **Domain:** Founder Command Center, Active Validation Workspace, Velocity Metrics & Personalization
- **Core Purpose:** Bridge high-level progress with granular daily validation tasks, ensuring founders focus on high-impact falsification experiments.
- **Visual Design Rules:**
  - Clear information hierarchy distinguishing active work from passive metrics.
  - Every metric has an explicit time window, calculation basis, and provenance badge.
  - Zero vanity widgets; every card provides a direct action link.

---

### Screen 046: First-Time User Dashboard
- **Screen ID:** `SCR-046`
- **Route:** `/app/dashboard/welcome`
- **Primary Persona:** Founder with 0 validations created
- **Layout Architecture:**
  - Banner: "Welcome to your Validation Studio. Let's turn your untested assumptions into hard evidence."
  - Guided 3-Step Checklist:
    1. [x] Account and Role Configured
    2. [ ] Create Your First Hypothesis (Problem + Customer) -> "Launch Builder" (`#F44A22`)
    3. [ ] Invite 3 Team Members or Co-validators
  - Interactive Template Selector: Pre-populated hypothesis templates (B2B SaaS, Hardware Device, Consumer Marketplace, AI Workflow).

---

### Screen 047: Returning Founder Dashboard
- **Screen ID:** `SCR-047`
- **Route:** `/app/dashboard`
- **Primary Persona:** Active founder managing 1 or more ongoing validations
- **Top Metrics Row (4 Cards):**
  - **Active Validations:** 2 In Progress, 1 In Review
  - **Human Responses:** 64 Total (+18 this week)
  - **Overall Confidence Signal:** 76% (Moderate-High) `[AI Synthesis]`
  - **Critical Hypotheses Tested:** 5 Confirmed / 2 Invalidated
- **Main Section:** Active Validation Cards with live response tickers and warning alerts (e.g., *"Contradiction detected in Pricing Hypothesis for EcoPack"*).

---

### Screen 048: Active Validation Workspace Overview
- **Screen ID:** `SCR-048`
- **Route:** `/app/validations/:id/workspace`
- **Purpose:** Central mission control for a specific startup validation project.
- **Tab Bar:** Overview (Active) | Hypotheses | Evidence Locker | Community Feedback | AI Intelligence | Health Radar | Decisions & Experiments.
- **Quick Actions:** "Share Public Link", "Pause Data Collection", "Run AI Synthesis", "Export Dossier".

---

### Screen 049: Recent Activities & Updates
- **Screen ID:** `SCR-049`
- **Route:** `/app/dashboard/activity`
- **Audit Stream:** Chronological feed of all interactions:
  - *"Dr. Alex Wong (Senior Validator) submitted structured feedback on Medical Drone Logistics"*
  - *"New customer interview recording (24m 12s) uploaded to Evidence Locker"*
  - *"AI Synthesis Agent completed stress test: Flagged 2 competitive blind spots"*
  - Timestamp, actor avatar, and direct click-through to evidence item.

---

### Screen 050: Recommended Actions
- **Screen ID:** `SCR-050`
- **Route:** `/app/dashboard/recommendations`
- **Intelligent Priority Matrix:**
  - **Urgent:** "Your Willingness-to-Pay hypothesis has only 4 responses. Recruit 15 more B2B buyers to reach statistical significance."
  - **Recommended:** "Attach customer interview transcripts to back up assumption #3 (Compliance Burden)."
  - **Next Experiment:** "Launch pricing sensitivity test ($49/mo vs. $99/mo)."

---

### Screen 051: Weekly Progress & Activity
- **Screen ID:** `SCR-051`
- **Route:** `/app/dashboard/weekly-velocity`
- **Visuals:** Bar chart of validator feedback velocity over the last 8 weeks; hypothesis resolution rate (Pivoted vs. Confirmed vs. Disproved); time-to-decision trend line.

---

### Screen 052: Personalised Opportunities
- **Screen ID:** `SCR-052`
- **Route:** `/app/dashboard/opportunities`
- **Content:**
  - Accelerator Deadlines matching startup vertical
  - Angel Investors actively viewing projects in this industry
  - Validators offering free office hours in exchange for reviewing early concepts

---

### Screen 053: Dashboard Customisation & Widget Preferences
- **Screen ID:** `SCR-053`
- **Route:** `/app/dashboard/customize`
- **Interaction:** Drag-and-drop widget layout editor; toggle widget visibility (Metrics Bar, Health Radar, Recent Activity, Validator Leaderboard, Market Feeds).
