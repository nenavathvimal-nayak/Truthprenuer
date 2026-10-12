# TRUTHPRENUER — MODULE C: ONBOARDING & PROFILE SETUP
## Screens 026 – 035 Specification

---

### Module Overview
- **Domain:** User Onboarding, Multi-Persona Profiling, Skills Mapping & Intent Personalization
- **Core Principle:** Frictionless, persona-tailored setup that captures essential intent without causing drop-off.
- **Role Support:** Founder, Investor, Professional / Validator, Student, Creator.
- **Design Tokens:**
  - Progress Indicator: Stepper header with 4 stages, orange active pill (`#F44A22`), stone grey inactive (`#A8AAAC`).
  - Interactive Selection Cards: Selectable role tiles with hover lift, active orange border and checkmark badge.
  - Optionality: Clear "Skip for now" tertiary link on optional screens.

---

### Screen 026: Welcome / Onboarding Introduction
- **Screen ID:** `SCR-026`
- **Route:** `/onboarding/welcome`
- **Primary Persona:** Newly authenticated user
- **Core Message:** "Welcome to Truthprenuer. Let's tailor your experience in under 2 minutes."
- **Visual:** Split layout: Left column contains personalized greeting, value bullets, and "Get Started" CTA; Right column shows preview illustration of the customized dashboard.

---

### Screen 027: Role Selection
- **Screen ID:** `SCR-027`
- **Route:** `/onboarding/role-selection`
- **Layout:** Responsive 3x2 grid of role cards:
  1. **Founder / Startup Team:** "I have a concept or product and want to test assumptions with real humans."
  2. **Angel / VC Investor:** "I want to discover high-conviction startups backed by auditable evidence."
  3. **Domain Expert / Validator:** "I want to review early concepts, give brutal feedback, and earn reputation."
  4. **Student / Academic:** "I'm learning entrepreneurship and testing initial class or hackathon projects."
  5. **Creator / Operator:** "I build audiences or provide specialized design, dev, and growth services."
  6. **Co-founder / Job Seeker:** "I want to join an early-stage team with proven validation traction."
- **Multi-Role Support:** Users can select up to 2 primary roles (e.g., Founder + Validator).

---

### Screen 028: Founder Onboarding
- **Screen ID:** `SCR-028`
- **Route:** `/onboarding/founder`
- **Tailored Questions:**
  - Stage of Venture: Idea / Customer Discovery / MVP in Dev / Launched / Generating Revenue.
  - Sector Focus: B2B SaaS, HealthTech, ClimateTech, D2C, FinTech, AI Infrastructure.
  - Biggest Hurdle: Problem Validation / Willingness to Pay / Technical Feasibility / Finding Co-founder.
  - Existing Team Size: Solo / 2-3 Co-founders / 4-10 Team.

---

### Screen 029: Investor Onboarding
- **Screen ID:** `SCR-029`
- **Route:** `/onboarding/investor`
- **Tailored Questions:**
  - Investor Type: Angel Investor / Pre-Seed Fund / Accelerator Scout / Family Office / VC Partner.
  - Typical Check Size: $10k–$50k / $50k–$250k / $250k–$1M / > $1M.
  - Geographic Focus: Global / North America / Europe / India / Southeast Asia / LATAM.
  - Deal Flow Preferences: Filter by Minimum Validation Confidence Score (e.g., Only alert me if score > 75%).

---

### Screen 030: Professional or Validator Onboarding
- **Screen ID:** `SCR-030`
- **Route:** `/onboarding/validator`
- **Tailored Questions:**
  - Areas of Rigorous Feedback: Pricing Strategy, Technical Architecture, UX/Design, Legal/Regulatory, Growth/Sales.
  - Weekly Availability: 1-2 Reviews / 3-5 Reviews / 5+ Reviews per week.
  - Credential Verification: Optional LinkedIn / GitHub / AngelList profile sync for verified badge.

---

### Screen 031: Student Onboarding
- **Screen ID:** `SCR-031`
- **Route:** `/onboarding/student`
- **Tailored Questions:**
  - University / Institution Name.
  - Program / Major and Expected Graduation Year.
  - Affiliated Programs: Campus Incubator, Hackathon, Research Lab.

---

### Screen 032: Creator Onboarding
- **Screen ID:** `SCR-032`
- **Route:** `/onboarding/creator`
- **Tailored Questions:**
  - Creative Discipline: UI/UX Design, Full-Stack Dev, Technical Writing, Video / Content, No-Code.
  - Portfolio URL (Figma, GitHub, Dribbble, Substack).
  - Open for Collaboration / Sweat Equity / Contract work.

---

### Screen 033: Industry & Interests Selection
- **Screen ID:** `SCR-033`
- **Route:** `/onboarding/interests`
- **Layout:** Searchable chip cloud organized by master categories (Tech, Healthcare, Green Tech, Consumer, Commerce, GovTech).
- **Rule:** Minimum 3 selections to continue; selected chips illuminate with orange background and checkmark.

---

### Screen 034: Skills & Expertise Selection
- **Screen ID:** `SCR-034`
- **Route:** `/onboarding/skills`
- **Interactive Component:** Autocomplete multi-select input with suggested tags (e.g., *Product Management, React/Next.js, Python, B2B Enterprise Sales, HIPAA Compliance, Prompt Engineering*).

---

### Screen 035: Profile Completion & Onboarding Success
- **Screen ID:** `SCR-035`
- **Route:** `/onboarding/success`
- **Visual & Feedback:** Micro-animated celebration icon; personalized summary of configured feed and permissions.
- **Primary Action:** "Enter Your Workspace" -> Routes directly to `SCR-046` (First-Time User Dashboard) or `SCR-054` (Create Validation).
