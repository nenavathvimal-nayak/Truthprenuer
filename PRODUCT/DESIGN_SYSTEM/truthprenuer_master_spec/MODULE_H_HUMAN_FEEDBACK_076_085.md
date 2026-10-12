# TRUTHPRENUER — MODULE H: HUMAN FEEDBACK & COMMUNITY PARTICIPATION
## Screens 076 – 085 Specification

---

### Module Overview
- **Domain:** Human Review Engine, Blind Peer Assessment, Pricing Sensitivity & Community Discussion
- **Core Mission:** Eliminate polite confirmation bias by designing unbiased, rigorous question flows that separate stated desire from observed behavior.
- **Audience Safeguards:**
  - Anonymity protection options for validators to ensure unvarnished candor.
  - Transparent provenance tagging (`[Community Signal]`, `[Verified Validator]`).
  - Community reporting and moderation flags against spam, harassment, or self-promotion.

---

### Screen 076: Give Feedback
- **Screen ID:** `SCR-076`
- **Route:** `/v/:slug/review`
- **Primary Persona:** Community validator / prospective customer / mentor
- **Header:** Project title, founder statement, and estimated review duration: "Estimated time: 3-5 minutes • 8 questions".
- **Guidance Banner:** *"Truthprenuer values brutal honesty over encouragement. Real critique saves founders years of their lives."*
- **Primary Action:** "Begin Structured Review" (`#F44A22` button).

---

### Screen 077: Structured Feedback Questionnaire
- **Screen ID:** `SCR-077`
- **Route:** `/v/:slug/review/step-1`
- **Experience:** Focused, one-question-per-screen card flow or high-density vertical form with smooth scrolling and keyboard shortcuts (1-5 for options, Enter for next).
- **Core Questions:**
  - "Do you personally experience this problem?" (Yes, frequently / Yes, rarely / No / I know others who do).
  - "What do you currently use to solve it?" (Free text).
  - "How well does the proposed solution actually address the root pain?" (Rating scale 1-10 with qualitative justification).

---

### Screen 078: Rating & Confidence Input
- **Screen ID:** `SCR-078`
- **Route:** `/v/:slug/review/ratings`
- **Multi-Dimensional Sliders:**
  1. *Problem Authenticity:* (Is this a hair-on-fire problem or a nice-to-have?)
  2. *Solution Feasibility:* (Can a small team actually build and deliver this?)
  3. *Market Readiness:* (Is the market ready right now, or 5 years too early?)
- **Confidence Rating:** "How confident are you in your assessment?" (Low / Medium / High / Domain Expert).

---

### Screen 079: Willingness-to-Pay / Pricing Feedback
- **Screen ID:** `SCR-079`
- **Route:** `/v/:slug/review/pricing`
- **Van Westendorp Price Sensitivity Matrix:**
  - At what price would this product feel **Too Expensive** to even consider? ($____)
  - At what price would it feel **Too Cheap**, causing you to question quality? ($____)
  - At what price would it feel like a **Great Deal / Bargain**? ($____)
  - At what price would it start getting **Expensive**, but you'd still buy? ($____)
- **Commitment Test:** "Would you pay a refundable $10 deposit today to get early beta access?" (Yes / No).

---

### Screen 080: Problem Severity & Frequency Feedback
- **Screen ID:** `SCR-080`
- **Route:** `/v/:slug/review/severity`
- **Diagnostic Matrix:**
  - Frequency: Several times a day / Weekly / Monthly / Once a year.
  - Financial or Time Cost of the problem: "How many hours per week do you lose to this pain point?" (0-2 hrs / 3-5 hrs / 6-10 hrs / 10+ hrs).

---

### Screen 081: Comments & Discussion
- **Screen ID:** `SCR-081`
- **Route:** `/app/validations/:id/discussion`
- **Discussion Feed:**
  - Threaded comment interface with role badges (`[Founder]`, `[Verified Validator]`, `[Angel Investor]`).
  - Upvote / Insightful reactions ("Insightful", "Critical Blindspot", "Counter-example").
  - Filter comments: Top Insightful / Most Recent / Unanswered by Founder.

---

### Screen 082: Reply to a Comment
- **Screen ID:** `SCR-082`
- **Route:** Inline expansion on `/app/validations/:id/discussion`
- **Component:** Rich-text reply box with markdown support, code blocks, and attachment pill for linking supporting URLs or research papers.

---

### Screen 083: Feedback Submission Success
- **Screen ID:** `SCR-083`
- **Route:** `/v/:slug/review/success`
- **Post-Submission Confirmation:**
  - "Thank you for keeping validation honest."
  - Impact Metrics: *"Your review contributed to EcoPack's Willingness-to-Pay analysis."*
  - Reputation Points: +25 Validator Reputation Earned.
  - Actions: "Explore More Validations Needing Feedback" | "View Your Review History".

---

### Screen 084: Edit or Withdraw Eligible Feedback
- **Screen ID:** `SCR-084`
- **Route:** `/app/my-feedback/:id/edit`
- **Rules:** Reviewers can edit or withdraw their feedback within 48 hours of submission, provided the study has not yet concluded.
- **Confirmation:** Explicit warning that withdrawing will re-calculate founder's real-time confidence scores.

---

### Screen 085: Report Inappropriate Content
- **Screen ID:** `SCR-085`
- **Route:** Modal dialog on `/v/:slug`
- **Report Reasons:**
  - Spam or Promotional Pitch
  - Hate Speech or Harassment
  - Intellectual Property Violation / Idea Theft
  - Misleading Claims / Fake Traction
  - Free text details box + Submit button -> Routes to Moderation Queue `SCR-179`.
