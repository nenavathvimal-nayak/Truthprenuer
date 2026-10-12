# TRUTHPRENUER — MODULE N: CO-FOUNDERS, TALENT & OPPORTUNITIES
## Screens 133 – 140 Specification

---

### Module Overview
- **Domain:** Co-Founder Matching, Technical & Business Talent Marketplace & Opportunity Management
- **Key Differentiator:** Every opportunity listing is directly linked to an auditable Validation Dossier, allowing prospective co-founders and engineers to evaluate startup viability before applying.

---

### Screen 133: Co-Founder Discovery
- **Screen ID:** `SCR-133`
- **Route:** `/app/talent/co-founders`
- **Filter Bar:**
  - Role Needed: Technical Co-founder (CTO) / Business & Sales (CEO/COO) / Product & Design (CPO).
  - Equity & Compensation: Pure Equity (20-50%) / Equity + Stipend / Salary + Equity.
  - Commitment: Full-time / Part-time / Nights & Weekends.
- **Listing Card:** Startup Name, Validated Pitch summary, Co-Founder Role Needed, Equity range, Validation Health Score badge (e.g., "Health: 82/100 • 48 Validator Responses").

---

### Screen 134: Co-Founder Opportunity Details
- **Screen ID:** `SCR-134`
- **Route:** `/app/talent/co-founders/:id`
- **Deep Inspection Experience:**
  - Detailed Venture Background & Problem.
  - What the founder brings to the table vs. What is expected from the co-founder.
  - Linked Public Validation Dossier (Direct link to review the hypothesis evidence).
  - Primary Action: "Apply for Co-founder Role" (`#F44A22` button).

---

### Screen 135: Create a Co-Founder Listing
- **Screen ID:** `SCR-135`
- **Route:** `/app/talent/co-founders/new`
- **Form Wizard:**
  - Link Existing Validation: Select from your active validations.
  - Role Title & Responsibilities.
  - Desired Technical / Domain Skills (Tag selector).
  - Equity & Compensation Split slider (e.g., 25% – 35%).
  - Working Arrangement: Remote / Hybrid / City location.

---

### Screen 136: Talent & Skills Directory
- **Screen ID:** `SCR-136`
- **Route:** `/app/talent/directory`
- **Profile Explorer:** Browse individuals open for early-stage roles, advisory, or contract work. Filter by stack (Flutter, Python, Rust, Go, Figma, Growth Marketing).

---

### Screen 137: Professional Opportunity Details
- **Screen ID:** `SCR-137`
- **Route:** `/app/talent/opportunities/:id`
- **Listing Details:** Job overview for early-stage hire (Founding Engineer, Lead Designer, Growth Lead) with compensation and team introduction.

---

### Screen 138: Create a Job or Collaboration Listing
- **Screen ID:** `SCR-138`
- **Route:** `/app/talent/opportunities/new`
- **Form Elements:** Opportunity Type (Full-time, Contract, Advisory), Role Description, Requirements, Perks, Application Deadline.

---

### Screen 139: Applicants / Interested People
- **Screen ID:** `SCR-139`
- **Route:** `/app/talent/my-listings/:id/applicants`
- **Candidate Pipeline:**
  - Stages: Applied (14) | Shortlisted (4) | In Discussion (2) | Made Offer (1) | Rejected (7).
  - Candidate Card: Profile summary, relevant past startup experience, customized note, CV link, quick action "Schedule Chat".

---

### Screen 140: Opportunity Management
- **Screen ID:** `SCR-140`
- **Route:** `/app/talent/my-listings`
- **Status Dashboard:** List of all active job and co-founder listings, view counts, application counts, status toggles (Active / Paused / Filled).
