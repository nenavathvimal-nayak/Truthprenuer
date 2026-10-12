# DOCUMENT 23 — TRUTHPRENUER MASTER UI/UX & PRODUCT SPECIFICATION

**Product:** TRUTHPRENUER  
**Document ID:** DOC-23  
**Version:** 1.0.0 (Production MVP)  
**Status:** Approved & Canonical  
**Author:** Product & Design Systems Lead  

---

## 1. Product Ecosystem & Core Loop

### 1.1 Philosophy
```
IDEA → ASSUMPTION → VALIDATE → REAL FEEDBACK → EVIDENCE → INSIGHT → DECISION → IMPROVE → RE-VALIDATE → BUILD
```

### 1.2 Core Product Loops
1. **Primary Validation Loop:**  
   `CREATE VALIDATION → PUBLISH → GET RESPONSES → ANALYZE (AI + Manual) → LEARN → DECIDE → NEXT EXPERIMENT`
2. **Community & Collaboration Loop:**  
   `DISCOVER → FIND PEOPLE → CONNECT → MESSAGE → COLLABORATE`

---

## 2. Brand & Design System

### 2.1 Color Roles (Strict Zero-Chromatic Deviation)
| Token | Hex | Role | Usage |
| :--- | :--- | :--- | :--- |
| **ORANGE** | `#F44A22` | Primary Accent / Energy | Primary CTAs, active tab/selection, progress bars, confidence signal highlights. |
| **MIDNIGHT** | `#161616` | Seriousness / Trust | Dark mode background, primary navigation, headers, high-emphasis text. |
| **SILVER** | `#FEF8E8` | Warmth / Clarity | Light mode background, card surfaces in light mode, high-contrast text in dark mode. |
| **GREY** | `#E4E2E3` | Structure / Restraint | Borders, dividers, secondary card outlines, disabled button states. |
| **STONE** | `#A8AAAC` | Context / Metadata | Secondary text, timestamps, input placeholders, inactive icons. |

### 2.2 Typography System (Dual-Voice)
- **Ordinary Voice (`Inter`):** 85% of interface. Used for buttons, inputs, data counters, body text, form elements.
- **Parisian Voice (`Playfair Display`):** 15% of interface. Used for editorial hero prompts, emotional celebration headings, and milestone banners.

---

## 3. Global Information Architecture & Navigation

### 3.1 Primary Navigation Shell
The root scaffold provides a bottom navigation bar with 5 destinations:
1. **Home (`/`)** — Founder Command Center & Decision Intelligence
2. **Explore (`/explore`)** — Validation marketplace, search, categories, trending ideas
3. **+ (Create Action)** — Intercepted action sheet with options:
   - *Create Validation* (Primary)
   - *Ask for Feedback*
   - *Post an Update*
   - *Invite People*
4. **Network (`/network`)** — Co-founders, mentors, peer founders, connection requests
5. **Profile (`/profile`)** — Founder reputation, my validations, responses given, settings

---

## 4. Complete Screen Master Inventory (01–196)

### A. App Entry
- **SCR-001 (Splash):** Brand logo (fox/question-mark), tagline, fade animation, routing check.
- **SCR-002 (App Initializing):** Secure storage access, remote config sync, asset preheating.
- **SCR-003 (Session Restoring):** Token refresh, biometrics verification, silent login.
- **SCR-004 (Maintenance):** Scheduled downtime notice, estimated uptime, status check.
- **SCR-005 (Force Update):** Critical app update requirement, App Store / Play Store redirect.
- **SCR-006 (Unsupported Version):** Minimum OS / architecture requirement notice.

### B. Onboarding
- **SCR-007 (Welcome):** Value proposition hero: "Test before you invest."
- **SCR-008 (Problem):** "90% of startups fail by building things nobody wants."
- **SCR-009 (Validation):** "Turn dangerous assumptions into hard evidence."
- **SCR-010 (Feedback):** "Collect structured, honest feedback from real peers."
- **SCR-011 (Insights):** "Synthesize responses into actionable AI themes."
- **SCR-012 (Network):** "Build your network of trusted founders & early adopters."
- **SCR-013 (Final CTA):** Action picker: "Validate an Idea", "Explore Community", "Join Network".

### C. Authentication
- **SCR-014 (Sign In):** Email / Phone password authentication.
- **SCR-015 (Sign Up):** Account registration with Terms & Privacy agreement.
- **SCR-016 (Email Auth):** Magic link / password credentials flow.
- **SCR-017 (Phone Auth):** Mobile number entry with country code picker.
- **SCR-018 (OTP):** 6-digit PIN input with auto-paste and countdown timer.
- **SCR-019 (OTP Error):** Invalid code feedback with field shake.
- **SCR-020 (OTP Expired):** Expired state with prompt to request a fresh token.
- **SCR-021 (Resend OTP):** 60-second cooldown rate-limiting.
- **SCR-022 (Auth Success):** Success checkmark and transition to Profile Setup or Home.
- **SCR-023 (Session Expired):** In-app re-authentication modal preserving pending work.
- **SCR-024 (Logout Confirmation):** Modal confirming session termination and cache clearing.

### D. Profile Setup
- **SCR-025 (Create Profile):** Wizard entry explaining founder profile benefits.
- **SCR-026 (Upload Photo):** Camera / gallery avatar picker with crop tool.
- **SCR-027 (Name):** First and last name input.
- **SCR-028 (Username):** Unique `@handle` verification with live availability check.
- **SCR-029 (Role):** Founder, Solo Builder, Tech Lead, Product Designer, Advisor.
- **SCR-030 (Industry):** B2B SaaS, FinTech, Consumer, HealthTech, AI/ML, EdTech.
- **SCR-031 (Experience):** First-time founder, 1-3 previous startups, serial founder.
- **SCR-032 (Skills):** Chip selector for technical, design, marketing, and sales skills.
- **SCR-033 (Interests):** Emerging domains and market niches.
- **SCR-034 (Bio):** 160-character founder elevator pitch.
- **SCR-035 (Location):** City, country, and timezone selection.
- **SCR-036 (Profile Preview):** Visual summary card for final verification.
- **SCR-037 (Profile Completion):** Celebration screen with route to Home.

### E. Home Command Center
- **SCR-038 (Home):** Command Center with metrics, live validations, and recommended peer reviews.
- **SCR-039 (Home First Time):** Zero-state guiding new users to create their first validation.
- **SCR-040 (Home Returning User):** Summary of activity since last visit.
- **SCR-041 (Home No Activity):** Re-engagement recommendations and prompt cards.
- **SCR-042 (Home Active Validation):** Dedicated hero card tracking progress, response velocity, and time left.
- **SCR-043 (Home Recent Responses):** Preview list of latest feedback received.
- **SCR-044 (Home AI Insight Available):** Highlight card with confidence signal and key findings.
- **SCR-045 (Home Action Required):** Urgent badge for closing validations needing decisions.

### F. Explore & Discovery
- **SCR-046 (Explore Feed):** Category pills (All, AI, SaaS, FinTech, Consumer, B2B) and validation cards.
- **SCR-047 (Explore Trending):** Top validations sorted by response velocity.
- **SCR-048 (Explore Recommended):** Algorithmic recommendations based on user skills.
- **SCR-049 (Explore Recent):** Chronological stream of new validation requests.
- **SCR-050 (Explore People):** Community directory of founders open to connect.
- **SCR-051 (Explore Topics):** Taxonomy directory by industry and business model.
- **SCR-052 (Explore Validations):** Marketplace of requests specifically soliciting feedback.
- **SCR-053 (Search Overlay):** Instant search modal with recent queries and suggestions.
- **SCR-054 (Search Results):** Tabbed results: Validations, Founders, Topics.
- **SCR-055 (Filter Sheet):** Multi-criteria bottom sheet (Stage, Industry, Reward, Duration).
- **SCR-056 (Sort Sheet):** Sort by: Most Recent, Most Responses, Highest Signal, Ending Soon.
- **SCR-057 (No Search Results):** Empty state with suggested fallback keywords.
- **SCR-058 (Explore Empty):** Empty state for filtered criteria with "Clear Filters" CTA.

### G. Validation Creation Flow (7 Steps)
- **SCR-059 (Start Validation):** Creation hub with option to resume saved draft or start fresh.
- **SCR-060 (Step 1 — Type Selector):** Idea, Problem, Product, Feature, Pricing, Business Model, UI/UX, MVP, Brand.
- **SCR-061 (Step 2 — Define Assumption):** "What do you believe to be true that needs evidence?"
- **SCR-062 (Step 2 — Define Problem):** Customer pain point and current suboptimal alternatives.
- **SCR-063 (Step 3 — Target Audience):** Definition of ideal respondent persona.
- **SCR-064 (Step 3 — Audience Filters):** Chips for Role, Sector, Company Size, Geography.
- **SCR-065 (Step 4 — Create Questions):** Question manager card list with reorder and duplicate actions.
- **SCR-066 (Step 4 — Type Selector):** Multiple Choice, Rating, Scale, Yes/No, Open Text.
- **SCR-067 (Step 4 — Add Question):** Form for question text and answer options.
- **SCR-068 (Step 4 — Question Settings):** Required toggle, multi-select flag, min/max selections.
- **SCR-069 (Step 5 — Add Context):** Background narrative, pitch deck snippet, customer story.
- **SCR-070 (Step 5 — Add Media):** Image/mockup upload with zoom preview.
- **SCR-071 (Step 5 — Add Link):** Figma, clickable demo, landing page URL.
- **SCR-072 (Step 6 — Privacy Settings):** Public, Community, Connections Only, Invite Only, Private.
- **SCR-073 (Step 6 — Duration):** 7 days, 14 days, 30 days, or custom end date.
- **SCR-074 (Step 6 — Response Limit):** Target response count (e.g., 25, 50, 100, Unlimited).
- **SCR-075 (Step 6 — Preferences):** Enable/disable comments, anonymous responses allowed.
- **SCR-076 (Save Draft):** Manual save trigger with feedback toast.
- **SCR-077 (Draft List):** View and resume unfinished creation drafts.
- **SCR-078 (Step 7 — Preview):** Exact visual simulation of respondent's view.
- **SCR-079 (Publish Confirmation):** Confirmation sheet explaining duration, audience, and visibility.
- **SCR-080 (Publishing State):** Stepped animation showing validation upload and indexation.
- **SCR-081 (Published Success):** Celebration card with shareable link, QR code, and invite options.
- **SCR-082 (Publish Failure):** Network/server error recovery with cached draft retention.

### H. Validation Owner Flow
- **SCR-083 (My Validations):** Segmented list: Active, Drafts, Completed, Archived.
- **SCR-084 (Validation Detail):** 4 tabs: Overview, Responses, Evidence, Insights.
- **SCR-085 (Overview Tab):** Key metrics, completion rates, response timeline graph.
- **SCR-086 (Analytics View):** Demographic and role distribution of respondents.
- **SCR-087 (Response Inbox):** Chronological responses with sentiment chips (Positive, Neutral, Critical).
- **SCR-088 (Response Detail):** Full respondent answers with author credentials.
- **SCR-089 (Response Filters):** Filter by question, rating, sentiment, and read state.
- **SCR-090 (Evidence Locker):** Structured collection of proven/disproven assumptions.
- **SCR-091 (Add Evidence):** Promotion modal converting response to evidence card.
- **SCR-092 (Evidence Detail):** Evidence source, quote, classification, and impact score.
- **SCR-093 (Evidence Classification):** Supports Assumption, Contradicts, Mixed, Inconclusive.
- **SCR-094 (AI Analysis Processing):** Step-by-step analysis animation: Reading responses → Clustering themes → Computing signals.
- **SCR-095 (AI Analysis Result):** Executive summary, confidence score (0–100%), and next-step recommendation.
- **SCR-096 (AI Analysis Details):** Key themes, quotes, and consensus breakdown.
- **SCR-097 (AI Themes):** Clustered recurring founder feedback and friction points.
- **SCR-098 (AI Confidence / Signal):** Visual confidence gauge with sample size transparency.
- **SCR-099 (Decision Screen):** "What will you do next?" (Build, Pivot, Iterate, Abandon, Need More Data).
- **SCR-100 (Decision Confirmation):** Saved decision summary with founder note.
- **SCR-101 (Next Experiment):** Recommended follow-up validation hypothesis.
- **SCR-102 (Validation Completed):** Closed validation summary with exportable report.
- **SCR-103 (Validation Archived):** Read-only archival storage.

### I. Respondent Feedback Flow
- **SCR-104 (Respondent Preview):** Introduction, founder profile, estimated time (2–3 mins).
- **SCR-105 (Start Feedback):** Initial instructions and confidentiality notice.
- **SCR-106 (Question Container):** Stepper header (Question X of Y), progress bar, and answer canvas.
- **SCR-107 (Question — Multiple Choice):** Radio / checkbox option cards.
- **SCR-108 (Question — Rating):** 1-to-5 star or numerical rating widget.
- **SCR-109 (Question — Scale):** 1-to-10 Likert/NPS scale with contextual labels.
- **SCR-110 (Question — Ranking):** Drag-and-drop prioritization list.
- **SCR-111 (Question — Yes/No):** Binary selection cards with optional rationale field.
- **SCR-112 (Question — Open Text):** Focused multiline text area with suggestions.
- **SCR-113 (Feedback Review):** Summary of all answers before final submission.
- **SCR-114 (Submit Feedback):** Loading state and haptic confirmation.
- **SCR-115 (Submission Success):** Thank you screen with founder message and "Explore More Validations".
- **SCR-116 (Already Responded):** Notice preventing multiple submissions.
- **SCR-117 (Validation Closed):** State displayed when duration has expired.
- **SCR-118 (Validation Private):** Access request sheet for invite-only validations.
- **SCR-119 (Validation Removed):** Notice if author has withdrawn the validation.

### J. Notifications Hub
- **SCR-120 (Notifications Feed):** Central notification feed with badge counts.
- **SCR-121 (Notification — All):** Combined chronological activity feed.
- **SCR-122 (Notification — Validation):** Responses received, validation goals achieved.
- **SCR-123 (Notification — Network):** Connection requests, connection accepted.
- **SCR-124 (Notification — Messages):** Direct message alerts.
- **SCR-125 (Notification — System):** Account and security alerts.
- **SCR-126 (Notification Detail):** Contextual deep link handler.
- **SCR-127 (Notification Preferences):** Frequency and channel toggles.

### K. In-App Banners, Toasts & Modals
- **SCR-128 (New Response Toast):** Instant notification banner with "View Response" CTA.
- **SCR-129 (AI Analysis Ready Toast):** Banner notifying completion of AI analysis.
- **SCR-130 (Connection Request Toast):** Notification with Accept / Dismiss actions.
- **SCR-131 (Message Received Toast):** Quick reply banner for incoming chat.
- **SCR-132 (Validation Published Toast):** Confirmation with "Share Link" action.
- **SCR-133 (Validation Ending Soon):** In-app banner alert 24 hours prior to closing.
- **SCR-134 (Draft Saved Toast):** Non-blocking bottom confirmation.
- **SCR-135 (Error Toast):** Actionable toast with "Retry" button.
- **SCR-136 (Offline Banner):** Persistent header: "You're offline. Changes will sync once reconnected."
- **SCR-137 (Network Reconnected Toast):** Green indicator: "Back online."
- **SCR-138 (Success Snackbar):** General confirmation message.
- **SCR-139 (Permission Banner):** Pre-permission explanation banner for camera / notifications.

### L. Network & Connections
- **SCR-140 (Network Home):** Recommended founders, active connections, pending requests.
- **SCR-141 (Recommended People):** Matches based on complementary skillsets (e.g., Tech Founder + Marketing Co-founder).
- **SCR-142 (People Search):** Search by industry, location, startup name, or role.
- **SCR-143 (People Results):** Paginated result cards with connect CTAs.
- **SCR-144 (Person Profile):** Founder profile with past validations and achievements.
- **SCR-145 (Connect Confirmation):** Modal allowing a personalized 140-character intro note.
- **SCR-146 (Connection Request Sent):** State reflecting pending invitation.
- **SCR-147 (Request Received):** Card with Accept and Decline buttons.
- **SCR-148 (Requests List):** Management screen for incoming and outgoing invitations.
- **SCR-149 (Connections List):** Searchable list of mutual connections with direct message buttons.
- **SCR-150 (Connection Accepted):** In-app toast notifying successful match.
- **SCR-151 (Connection Declined):** Silent removal from pending list.

### M. Messaging
- **SCR-152 (Inbox):** Active conversations sorted by last message timestamp.
- **SCR-153 (Conversation):** Chat thread with timestamps, message states, and profile shortcut.
- **SCR-154 (New Message):** Recipient picker from connections.
- **SCR-155 (Attachment Selector):** Attach validation card, photo, or document.
- **SCR-156 (Message Sending):** Optimistic delivery state.
- **SCR-157 (Message Failed):** Failure state with tap-to-retry.
- **SCR-158 (Retry Message):** Immediate resend trigger.
- **SCR-159 (Block User):** Safety action to prevent further contact.
- **SCR-160 (Report User):** Abuse report submission with message selection.

### N. Profile & Reputation
- **SCR-161 (My Profile):** Public preview of user profile with stats and reputation badges.
- **SCR-162 (Edit Profile):** Form to edit name, title, bio, location, and social links.
- **SCR-163 (My Validations):** Tab listing user's published validations.
- **SCR-164 (My Responses):** Tab listing user's contributions to peer validations.
- **SCR-165 (Saved Items):** Bookmarked validations and founder profiles.
- **SCR-166 (Contributions):** Breakdown of feedback helpfulness votes and karma points.
- **SCR-167 (Activity Log):** Chronological record of user interactions.
- **SCR-168 (Profile Preview):** Toggle between "Owner View" and "Public View".

### O. Settings
- **SCR-169 (Settings Hub):** Main settings directory.
- **SCR-170 (Account):** Email and password credentials.
- **SCR-171 (Personal Information):** Legal name, timezone, contact details.
- **SCR-172 (Security):** Two-factor authentication, active sessions list.
- **SCR-173 (Privacy):** Public vs. private profile visibility toggle.
- **SCR-174 (Validation Privacy):** Default validation duration and visibility presets.
- **SCR-175 (Notifications Settings):** Granular controls for push, email, and in-app alerts.
- **SCR-176 (Language):** Interface language selection.
- **SCR-177 (Appearance):** Dark mode, Light mode, or System default.
- **SCR-178 (Connected Accounts):** Google, Apple, LinkedIn authentication linking.
- **SCR-179 (Help):** Direct shortcut to Support Center.
- **SCR-180 (Terms):** Legal terms of service.
- **SCR-181 (Privacy Policy):** Privacy policy and data rights.
- **SCR-182 (Report Problem):** General bug reporting form.
- **SCR-183 (Logout):** Session termination dialog.
- **SCR-184 (Delete Account):** Warning dialog explaining permanent data deletion.
- **SCR-185 (Delete Account Confirmation):** Re-authentication step requiring password/OTP.
- **SCR-186 (Account Deleted):** Confirmation screen and complete cache purge.

### P. Support & Safety
- **SCR-187 (Help Center):** Categorized knowledge base and FAQ search.
- **SCR-188 (FAQ):** Searchable list of common questions.
- **SCR-189 (Contact Support):** Direct contact form.
- **SCR-190 (Report Issue):** Technical bug report with device diagnostics.
- **SCR-191 (Report Validation):** Spam, intellectual property theft, or scam report.
- **SCR-192 (Report User):** Harassment or abusive behavior report.
- **SCR-193 (Support Ticket):** Active support ticket status tracking.
- **SCR-194 (Ticket Detail):** Thread between user and Truthprenuer support team.
- **SCR-195 (Ticket Submitted):** Confirmation with ticket ID.
- **SCR-196 (Ticket Resolved):** Resolution notice with satisfaction rating.

---

## 5. Screen Template Specification Sample

### SCR-060: Validation Creation — Step 1: Type Selector
- **Screen ID:** SCR-060
- **Screen Name:** Select Validation Type
- **Purpose:** Allow founder to choose the exact validation objective to dynamically configure wizard templates.
- **User Goal:** Pick the best validation category for their current stage.
- **Entry Points:** Home Hero Card ("Start Validation"), Create Action Sheet (+), My Validations ("+ New").
- **Exit Points:** Cancel / Save Draft (returns to Home/Drafts), Next Step (moves to SCR-061).
- **Primary CTA:** "Continue to Hypothesis" (Enabled when 1 option selected).
- **Secondary CTA:** "Save Draft & Exit".
- **Header:** Progress bar (1 of 7), "What are you validating?", Back button.
- **Content Hierarchy:**
  1. Stepper indicator (Step 1 / 7)
  2. Headline: "What do you want to validate?"
  3. Subtitle: "Choose the area that represents your biggest assumption."
  4. 2-column grid of 10 validation category cards (Idea, Problem, Product, Feature, Pricing, Business Model, UI/UX, MVP, Brand, Other).
  5. Sticky bottom bar with "Continue" CTA.
- **Visual Styles:**
  - Background: Midnight (`#161616`) / Silver (`#FEF8E8`)
  - Selected Card: Orange outline (`#F44A22`), subtle glow, checked icon.
  - Unselected Card: Grey border (`#E4E2E3`), Stone description text (`#A8AAAC`).
- **States:** Default, Selected, Loading, Error, Autosaved.
- **Accessibility:** VoiceOver announcements for option selection; minimum tap target 48x48dp.

---

## 6. Verification & Quality Gates
- 100% of screens map to distinct routing nodes or modal states.
- Zero non-palette chromatic colors.
- Zero dead-end buttons or non-functional placeholder actions.
- Full draft autosave resilience across all multi-step forms.
