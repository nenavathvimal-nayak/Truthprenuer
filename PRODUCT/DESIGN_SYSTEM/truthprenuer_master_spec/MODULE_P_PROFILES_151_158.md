# TRUTHPRENUER — MODULE P: PROFILE, REPUTATION & ACHIEVEMENTS
## Screens 151 – 158 Specification

---

### Module Overview
- **Domain:** User Identity, Reputation Accounting, Verification Badges & Contribution Portfolios
- **Core Principle:** Meritocratic credibility: Reputation cannot be purchased; it is earned strictly through high-signal validation feedback, auditable startup evidence, and community trust.

---

### Screen 151: My Profile
- **Screen ID:** `SCR-151`
- **Route:** `/app/profile`
- **Layout Architecture:**
  - Header Banner + Profile Avatar (with verified checkmark badge).
  - Identity Summary: Name, Headline, Location, Joined Date, Verified Credentials.
  - Reputation Score Pill: **Top 3% Validator • 840 Reputation Pts**.
  - Tabs: Overview | Active Validations | Feedback Given (48) | Achievements | Skills & Endorsements.

---

### Screen 152: Edit Profile
- **Screen ID:** `SCR-152`
- **Route:** `/app/profile/edit`
- **Form Controls:** Avatar upload with cropping tool, Banner image, Display Name, Bio (rich text), Social links (LinkedIn, GitHub, X, Personal site), Availability status toggle ("Open for Advisor Roles").

---

### Screen 153: Public Profile Preview
- **Screen ID:** `SCR-153`
- **Route:** `/app/profile/preview`
- **Duality Verification:** Allows user to inspect exactly how their profile looks to:
  - An anonymous public visitor.
  - A logged-in community member.
  - A connected friend or investor.

---

### Screen 154: Skills & Experience
- **Screen ID:** `SCR-154`
- **Route:** `/app/profile/experience`
- **Timeline:** Past companies, founder roles, educational background, verified skill tags with evidence links.

---

### Screen 155: Validation Contributions
- **Screen ID:** `SCR-155`
- **Route:** `/app/profile/contributions`
- **Contribution History:** Portfolio of public validation reviews given, upvotes received from other community members, and thank-you notes from founders.

---

### Screen 156: Achievements & Badges
- **Screen ID:** `SCR-156`
- **Route:** `/app/profile/badges`
- **Merit Badges:**
  - *Truth Teller:* Submitted 25+ detailed reviews with constructive critique.
  - *Evidence Master:* Uploaded 10+ cryptographically verified customer artifacts.
  - *Early Adopter:* Joined Truthprenuer during foundational genesis.
  - *Top Mentor:* Maintained 95%+ helpfulness rating.

---

### Screen 157: Reputation & Contribution History
- **Screen ID:** `SCR-157`
- **Route:** `/app/profile/reputation`
- **Ledger:** Detailed breakdown of how points were accumulated: (+25 for B2B Review, +50 for Verified LOI Upload, +10 for Accepted Answer).

---

### Screen 158: Profile Visibility & Verification Status
- **Screen ID:** `SCR-158`
- **Route:** `/app/profile/verification`
- **Identity Verification Portal:**
  - Link LinkedIn / GitHub / Domain Email to unlock Verified Founder or Verified Investor badge.
  - Privacy toggles: Hide email, Hide active validation count from public view.
