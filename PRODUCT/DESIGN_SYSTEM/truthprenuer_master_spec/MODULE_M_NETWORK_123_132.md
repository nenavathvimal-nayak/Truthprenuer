# TRUTHPRENUER — MODULE M: NETWORK & PROFESSIONAL DISCOVERY
## Screens 123 – 132 Specification

---

### Module Overview
- **Domain:** Professional Ecosystem, Founder-Investor Matchmaking, Validator Directory & Connection Inboxes
- **Core Standard:**
  - Verifiable credentials only (Zero manufactured endorsements or fake badges).
  - Explicit connection state feedback (Connect -> Request Sent -> Accepted / Message).
  - Anti-spam guardrails on connection requests (Max 20 pending requests at a time).

---

### Screen 123: Network Overview
- **Screen ID:** `SCR-123`
- **Route:** `/app/network`
- **Dashboard Layout:**
  - Connection Stats: 142 Connections • 18 Pending Requests • 4 Active Mentors.
  - Recommended Connections Carousel: "Founders testing in your sector" and "Investors looking for Pre-Seed ClimateTech".
  - Recent Network Activity: "Dr. Alex Wong accepted your connection request".

---

### Screen 124: Discover Founders
- **Screen ID:** `SCR-124`
- **Route:** `/app/network/founders`
- **Directory Grid:**
  - Filters: Industry, Stage (Pre-Idea, Validated, Seed), Location, Looking for Co-founder (Yes/No).
  - Founder Card: Profile photo, Name, Current Venture ("Founder of EcoPack"), Stage badge, Validation Health Score pill (if made public by founder), "Connect" button.

---

### Screen 125: Founder Profile Details
- **Screen ID:** `SCR-125`
- **Route:** `/app/network/founders/:username`
- **Profile Layout:**
  - Hero Header: Banner, Avatar, Name, Bio, LinkedIn / GitHub links.
  - Active & Past Validations tab (Public summaries only).
  - Verified Traction Highlights: Audited pre-orders, LOIs, and customer interview count.
  - Primary CTAs: "Connect" | "Send Message" | "Invite to Review Idea".

---

### Screen 126: Discover Investors
- **Screen ID:** `SCR-126`
- **Route:** `/app/network/investors`
- **Directory Grid:**
  - Filters: Fund Type (Angel, VC, Syndicate), Check Size ($10k-$50k, $100k-$500k), Preferred Verticals.
  - Investor Card: Photo, Fund Name, Investment Criteria ("Looking for B2B SaaS with >70% Truthprenuer confidence score"), "Request Intro" button.

---

### Screen 127: Investor Profile Details
- **Screen ID:** `SCR-127`
- **Route:** `/app/network/investors/:username`
- **Details:** Investment thesis, portfolio companies, deal history, diligence criteria, and direct submission guidelines for validated dossiers.

---

### Screen 128: Discover Professionals & Validators
- **Screen ID:** `SCR-128`
- **Route:** `/app/network/validators`
- **Directory Grid:**
  - Filters: Domain Expertise (Pricing, HIPAA, UX, B2B Enterprise Sales), Validator Tier (Top 5%, Verified Master Validator).
  - Validator Card: Reviews Completed count (e.g., "64 Validations Reviewed"), Credential tags ("Ex-AWS Senior Architect"), "Request Expert Feedback" action.

---

### Screen 129: Professional Profile Details
- **Screen ID:** `SCR-129`
- **Route:** `/app/network/validators/:username`
- **Details:** Detailed review track record, community upvotes received, specialized review offerings, office hour bookings.

---

### Screen 130: Follow / Connect / Request Sent States
- **Screen ID:** `SCR-130`
- **Route:** Component Variants across `/app/network`
- **Button Micro-States:**
  - *Default:* "Connect" (`#F44A22` outline)
  - *Loading:* Spinner inside button with "Sending..."
  - *Pending:* "Request Sent" (Grey `#E4E2E3` with clock icon, dropdown to "Withdraw Request")
  - *Connected:* "Connected" (Green checkmark, hover changes to "Message" or "Disconnect")

---

### Screen 131: Connection Requests Inbox
- **Screen ID:** `SCR-131`
- **Route:** `/app/network/requests`
- **List of Incoming Inquiries:**
  - Incoming (12) | Outgoing Pending (6).
  - Request Item: Requester details, custom intro note ("Hi Sarah, loved your validation on EcoPack, would love to compare notes on D2C packaging"), "Accept" (`#F44A22`) vs "Decline" buttons.

---

### Screen 132: Connection Request Review & Management
- **Screen ID:** `SCR-132`
- **Route:** Modal dialog on `/app/network/requests/:id`
- **Action Modal:** Inspect requester's profile, mutual connections, and choose to: Accept, Decline, or Report as Spam.
