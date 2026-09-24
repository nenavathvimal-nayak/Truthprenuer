# TRUTHPRENUER — MVP Product Scope & Feature Classification
**Phase 1 Product Scope Reset**
**Status:** Authoritative Scope Baseline  

---

## 1. Scope Decision Framework

Every feature in the repository and specification was evaluated against the central product loop:
> **ASSUMPTION → VALIDATION → REAL FEEDBACK → EVIDENCE → AI ANALYSIS → SIGNAL / UNCERTAINTY → HUMAN DECISION → NEXT EXPERIMENT → RE-VALIDATION**

Classification Key:
- **KEEP (P0)**: Core spine essential for the validation loop.
- **SIMPLIFY (P0/P1)**: Retained, but stripped of decorative UI, redundant steps, and excess fields.
- **MERGE (P0)**: Consolidated into a unified surface rather than a separate page.
- **POST-MVP (P2)**: Valuable concept deferred until core loop adoption is proven.
- **DELETE**: Distracting, gamified, fake, decorative, or social-media clone mechanics removed immediately.

---

## 2. Feature Master Registry & Classification

### 2.1 Identity & Access
| Feature | Classification | Rationale |
| :--- | :--- | :--- |
| Email + Password Auth | **KEEP** | Standard Supabase Auth integration. |
| OTP Email Verification | **KEEP** | Required for account verification and security. |
| Password Reset Flow | **KEEP** | Core security hygiene. |
| Profile Setup (Name, Handle, Bio, Skills) | **SIMPLIFY** | Compact 4-step wizard. Remove non-essential fields (e.g. forced 10 skills). |
| Role Selection (Founder, Investor, Professional, Creator) | **MERGE** | Retained in profile setup. Student consolidated into Professional/Creator. |
| Session Expiry & Auto-Refresh | **KEEP** | Core security requirement. |

### 2.2 Core Validation Loop
| Feature | Classification | Rationale |
| :--- | :--- | :--- |
| Validation Creation Wizard | **SIMPLIFY** | Streamline into an 8-step wizard with autosave and draft recovery. |
| Autosave & Draft System | **KEEP** | Prevents data loss during network drop or app exit. |
| Visibility Permissions (Public, Community, Connections, Invite, Private) | **KEEP** | Essential for founder data protection and investor confidentiality. |
| Validation Detail Surface | **MERGE** | Central object surface uniting Problem, Questions, Feedback, Evidence, AI, and Decisions. |
| Structured Feedback Entry | **SIMPLIFY** | Focus on speed, honesty, and evidence quality (Multiple choice, rating, scale, yes/no, open text). |
| Duplicate Response Guard | **KEEP** | Prevents ballot-stuffing and corrupt signals. |
| Evidence Locker | **KEEP** | First-class evidence repository with provenance, classification (`Supports`/`Contradicts`), and tags. |
| AI Evidence Synthesis | **SIMPLIFY** | 8-part structured report (Observations, Patterns, Contradictions, Uncertainties, Missing Info, Next Experiment). |
| Decision Center | **SIMPLIFY** | Human founder choices: `Gather Evidence`, `Iterate`, `Build`, `Re-test`, `Pivot`, `Pause`. |
| Next Experiment Setup | **KEEP** | Links decision directly into re-validation loop. |

### 2.3 Discovery & Exploration
| Feature | Classification | Rationale |
| :--- | :--- | :--- |
| Unified Search (Validations & People) | **KEEP** | Single search engine respecting privacy filters. |
| Search Filters (Industry, Stage, Role) | **SIMPLIFY** | Compact filter modal. |
| Validation Marketplace Feed | **MERGE** | Embedded directly into Explore tab. |
| Social Posts / General Feed | **DELETE** | Excluded to keep app focused on empirical validation rather than social media noise. |

### 2.4 Community & Relationship
| Feature | Classification | Rationale |
| :--- | :--- | :--- |
| Peer Connections (Request / Accept / Decline) | **KEEP** | Lightweight professional networking. |
| Direct 1-on-1 Messaging | **SIMPLIFY** | Text-based messaging with real persistence. Remove complex attachments. |
| User Blocking & Content Reporting | **KEEP** | Mandatory trust and safety baseline. |
| Co-Founder Swipe/Matching Engine | **POST-MVP** | Avoid dating-app mechanics; rely on transparent skills and profile discovery. |
| Gamified Leaderboards & Tokens | **DELETE** | Purge vanity tokens, badges, and streaks. |
| Contribution Reputation | **SIMPLIFY** | Transparent metrics: Validations reviewed and helpful feedback impact. |

### 2.5 Intelligence & Evaluation
| Feature | Classification | Rationale |
| :--- | :--- | :--- |
| AI Mentor Chatbot | **POST-MVP** | Focus AI exclusively on evidence synthesis and contradiction analysis first. |
| Synthetic Startup Health Scores | **DELETE** | Remove ungrounded numerical scores. |
| Evidence-Backed Validation Health | **SIMPLIFY** | Explainable metrics based on sample size, contradiction ratio, and evidence recency. |

### 2.6 Account, Privacy & Platform
| Feature | Classification | Rationale |
| :--- | :--- | :--- |
| Event Notifications | **KEEP** | Deep-linked alerts (feedback received, analysis ready, connection). |
| Appearance (Dark / Light / System) | **KEEP** | High-contrast palette (`#161616` Midnight / `#FEF8E8` Silver). |
| Privacy Center & Consent Records | **KEEP** | DPDP/GDPR compliant transparency, export, and consent history. |
| Account Deletion Lifecycle | **KEEP** | Authentic irreversible account and data deletion. |
| Offline Error Handling & State Views | **KEEP** | Universal loading, empty, offline, and unauthorized states. |
