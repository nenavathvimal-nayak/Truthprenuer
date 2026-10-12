# TRUTHPRENUER — MODULE D: GLOBAL NAVIGATION & DISCOVERY
## Screens 036 – 045 Specification

---

### Module Overview
- **Domain:** Global Exploration, Filtering, Search Engine, Taxonomy & Bookmarking
- **Core Experience:** Fast, faceted search across live validations, startup profiles, investors, domain mentors, and community evidence.
- **Design Structure:**
  - 3-Pane Layout: 240px persistent desktop sidebar, 840px central listing, 360px contextual filters and trending topics rail.
  - Search Bar: Global keyboard-accessible search (`Cmd + K` / `Ctrl + K`) present in sticky header across all authenticated views.
  - Card Standard: Provenance tags (`[Verified Evidence]`, `[Founder Hypothesis]`, `[AI Synthesis]`), confidence badges, validator counter.

---

### Screen 036: Main Home Dashboard
- **Screen ID:** `SCR-036`
- **Route:** `/app/home`
- **Layout Architecture:**
  - Top Navigation: Logo, Global Search Input (`Cmd+K`), Notification Bell with badge, Message Icon with badge, Profile Avatar with role badge.
  - Left Sidebar: Home (Active), Explore, Validations, Analysis & Health, Network, Messages, Profile.
  - Central Stream: Personalized activity feed (New feedback on your ideas, validation requests matching your expertise, trending ideas in your industry).
  - Right Intelligence Rail: Weekly validation streak, quick-launch "Create Validation", Top Validators of the week.

---

### Screen 037: Explore Validations
- **Screen ID:** `SCR-037`
- **Route:** `/app/explore/validations`
- **Core View:** Filterable grid/list of active public and community validations.
- **Card Data Points:**
  - Title & One-line Pitch
  - Problem Category tag (e.g., `#ClimateTech`, `#B2BSaaS`)
  - Validation Phase: (Assumption Testing, Pricing Discovery, MVP Feedback)
  - Target Audience: (e.g., "Freelance designers in US/EU")
  - Response Progress Bar: "34 / 50 Responses"
  - Interactive Action: "Review & Give Feedback" (`#F44A22` ghost/filled button)

---

### Screen 038: Explore People
- **Screen ID:** `SCR-038`
- **Route:** `/app/explore/people`
- **Filter Tabs:** All People / Founders / Domain Validators / Investors / Co-founders.
- **Person Card:**
  - Avatar, Name, Verified Credential badge
  - Headline: (e.g., "Ex-Stripe Product Lead | 42 Validations Reviewed")
  - Top Expertise Chips: `#FinTech`, `#Pricing`, `#APIs`
  - Action: "Connect" / "Request Review" / "Follow"

---

### Screen 039: Explore Startups
- **Screen ID:** `SCR-039`
- **Route:** `/app/explore/startups`
- **Purpose:** Startup index focused on auditable traction and validation history.
- **Columns / Card View:**
  - Startup Name & Logo
  - Stage: Pre-Seed / Seed / Bootstrapped
  - Health Radar Score: (e.g., 81/100) with drill-down link
  - Total Evidence Pieces: 14 Verified Assets
  - Founder Profile Link

---

### Screen 040: Global Search Results
- **Screen ID:** `SCR-040`
- **Route:** `/app/search?q={query}`
- **Unified Results Tabs:** All (42) | Validations (18) | Startups (8) | People (12) | Evidence Items (4).
- **Match Highlighting:** Query keywords highlighted in bold orange font inside snippet previews.

---

### Screen 041: Advanced Search & Filters
- **Screen ID:** `SCR-041`
- **Route:** `/app/search/advanced`
- **Filter Facets Drawer:**
  - Industry / Vertical (Multi-select)
  - Validation Stage (Idea, Discovery, Alpha, Beta)
  - Confidence Score Range Slider (0% to 100%)
  - Evidence Type (Has Customer Audio, Has Survey Data, Has LOI)
  - Response Count (0–20, 20–50, 50+)
  - Date Range Picker

---

### Screen 042: Saved Searches
- **Screen ID:** `SCR-042`
- **Route:** `/app/search/saved`
- **Management Table:**
  - Search Name & Query string
  - Notification Frequency: Instant / Daily Digest / Never
  - Last Executed date
  - Actions: Run Now, Edit Query, Delete

---

### Screen 043: Trending Topics & Categories
- **Screen ID:** `SCR-043`
- **Route:** `/app/explore/trending`
- **Visuals:** Velocity charts showing emerging startup hypothesis themes over the past 30 days (e.g., "Autonomous AI Agents for Compliance", "Nuclear Small Modular Reactors", "Local Micro-Logistics").

---

### Screen 044: Bookmarks
- **Screen ID:** `SCR-044`
- **Route:** `/app/bookmarks`
- **Organization:** Custom folders (e.g., "Competitor Inspiration", "Ideas to Review this Weekend", "Potential Co-founders").
- **Bulk Actions:** Export Bookmarks, Move to Folder, Remove.

---

### Screen 045: Search No-Results / Empty State
- **Screen ID:** `SCR-045`
- **Route:** `/app/search?q={no_match}`
- **Experience:** Helpful empty state illustration; message: *"No validations or people matched '{query}'."*
- **Actionable Guidance:**
  - Suggest alternative search terms or broader filter parameters.
  - Button: "Create a Validation for '{query}'" to kickstart the topic on Truthprenuer.
