# TRUTHPRENUER — MODULE R: HELP, SUPPORT & LEGAL
## Screens 169 – 175 Specification

---

### Module Overview
- **Domain:** Knowledge Base, Customer Support Ticketing, Bug Reporting & Legal Policies
- **Core Standard:**
  - Fast, self-serve answers with instant search and category browsing.
  - Transparent support SLA tracking.
  - Plain-English legal summaries alongside formal contractual terms.

---

### Screen 169: Help Centre
- **Screen ID:** `SCR-169`
- **Route:** `/help`
- **Layout Architecture:**
  - Hero: Search Bar: "How can we help you validate today?"
  - Category Grid (6 Cards):
    1. Getting Started with Validations
    2. Designing Unbiased Hypotheses
    3. Managing the Evidence Locker
    4. Understanding AI Confidence Scores
    5. Billing, Plans & Invoices
    6. Community Guidelines & Reputation
  - Quick FAQs accordion and "Contact Support" button.

---

### Screen 170: Search Help Articles
- **Screen ID:** `SCR-170`
- **Route:** `/help/search?q={query}`
- **Experience:** Real-time search results with highlighted excerpt text, estimated read time, and "Was this helpful?" feedback buttons.

---

### Screen 171: Support Request Form
- **Screen ID:** `SCR-171`
- **Route:** `/help/contact`
- **Inputs:** Issue Category (Account, Billing, Evidence Upload, AI Synthesis Bug, Report User), Priority Level (Low, Medium, Urgent), Subject, Message, Screenshot Attachment upload.

---

### Screen 172: Bug Report / Feedback Form
- **Screen ID:** `SCR-172`
- **Route:** `/help/feedback`
- **Diagnostic Capture:** Auto-attaches client browser version, OS, viewport resolution, and console error logs (with user consent). Input fields for Steps to Reproduce, Expected vs. Actual behavior.

---

### Screen 173: Terms of Service
- **Screen ID:** `SCR-173`
- **Route:** `/legal/terms`
- **Structure:** Sticky sidebar table of contents, Version History selector (e.g., "Version 2.4 - Effective Oct 2026"), Plain-English summary sidebars next to legal clauses. Key clauses: IP ownership remains 100% with founder; no warranty on AI score investment outcomes.

---

### Screen 174: Privacy Policy
- **Screen ID:** `SCR-174`
- **Route:** `/legal/privacy`
- **GDPR / CCPA Standards:** Data processing disclosures, sub-processor registry, user deletion rights, DPO contact details.

---

### Screen 175: Community Guidelines & Safety
- **Screen ID:** `SCR-175`
- **Route:** `/legal/guidelines`
- **Core Principles:**
  - "Brutal honesty, never cruelty."
  - Zero tolerance for spam, plagiarized pitches, or fabricated customer traction.
  - Clear sanctions hierarchy: Warning -> Reputation Demotion -> 30-Day Suspension -> Permanent Ban.
