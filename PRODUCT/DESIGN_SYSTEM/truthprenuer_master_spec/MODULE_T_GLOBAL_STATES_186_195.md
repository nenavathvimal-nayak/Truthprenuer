# TRUTHPRENUER — MODULE T: GLOBAL STATES & RESPONSIVE VARIANTS
## Screens 186 – 195 Specification

---

### Module Overview
- **Domain:** Global Resiliency States, Empty Views, Network Disconnections, Permission Boundaries & Mobile Adaptation
- **Resilience Standard:**
  - Zero raw uncaught errors: Every failure or boundary state provides clear explanations, recovery paths, and helpful actions.
  - Consistent layout skeleton shimmers matching the exact bounding dimensions of loaded content to prevent layout shifts (CLS < 0.05).
  - High accessible contrast across all alerts.

---

### Screen 186: Global Loading / Skeleton State
- **Screen ID:** `SCR-186`
- **Route:** Global Component State across all routes
- **Visual Mechanics:**
  - Pulsing animated gradient shimmers (Light: `#E4E2E3` to `#F5F5F5`; Dark: `#1F1F1F` to `#2A2A2A`).
  - Skeleton outlines for: Top header, Left 240px sidebar, 4 metric cards, and 3-row validation feeds.
  - Screen reader announcement via `aria-live="polite"`: "Loading workspace contents..."

---

### Screen 187: Empty Dashboard State
- **Screen ID:** `SCR-187`
- **Route:** `/app/dashboard` (when user has 0 activities and 0 validations)
- **Visuals:** Engaging illustration of a founder deconstructing a concept block.
- **Copy:** "Your Validation Studio is ready. Great startups begin with falsifying assumptions."
- **Direct Action:** "Create Your First Validation" (`#F44A22` filled button).

---

### Screen 188: Empty Explore State
- **Screen ID:** `SCR-188`
- **Route:** `/app/explore` (when filter combination yields 0 matches)
- **Visuals:** Clear filters icon with message: "No active validations match your chosen filters."
- **Action:** "Reset All Filters" button.

---

### Screen 189: Empty Validation State
- **Screen ID:** `SCR-189`
- **Route:** `/app/validations/:id` (immediately after launch, before any responses received)
- **Visuals:** Live radar with dashed placeholder rings and status ticker: "Listening for your first human reviewer... Share your study link to accelerate responses."
- **Action:** "Copy Shareable Link" & "Invite Community Validators".

---

### Screen 190: No Search Results State
- **Screen ID:** `SCR-190`
- **Route:** `/app/search`
- **Experience:** Friendly empty search illustration; offers search tips (check spelling, use broader tags, try searching people or startup names).

---

### Screen 191: Permission Denied State
- **Screen ID:** `SCR-191`
- **Route:** `/403` or inline boundary
- **Use Case:** Non-admin trying to access `/admin`, or non-team member trying to open private Evidence Locker.
- **Copy:** "Restricted Access. You do not have permission to view this resource."
- **Action:** "Return to Dashboard" | "Request Access from Project Owner".

---

### Screen 192: Session Expired State
- **Screen ID:** `SCR-192`
- **Route:** `/session-expired`
- **Experience:** Non-destructive modal keeping existing form inputs cached locally. Prompts for password re-entry or biometric TouchID / Windows Hello to instantly resume work.

---

### Screen 193: Network or Server Error State
- **Screen ID:** `SCR-193`
- **Route:** `/500` or network failure
- **Copy:** "Something went wrong on our end. Our engineering team has been automatically alerted."
- **Action:** "Retry Request" (`#F44A22` button) + System Status page link (`status.truthprenuer.com`).

---

### Screen 194: Offline / Reconnection State
- **Screen ID:** `SCR-194`
- **Route:** Global toast banner & offline fallback
- **Behavior:**
  - Sticky amber top banner: "You are currently offline. Changes are saved locally and will sync once connection is restored."
  - Auto-reconnect polling every 5 seconds; changes to green "Connection restored. Synced 4 changes" upon reconnect.

---

### Screen 195: Responsive Navigation & Mobile Adaptation
- **Screen ID:** `SCR-195`
- **Route:** Global 390px Mobile & 768px Tablet Viewport System
- **Mobile Layout Rules:**
  - Desktop 240px sidebar transforms into a fixed 5-tab Mobile Bottom Navigation Bar:
    1. Home (`/app/dashboard`)
    2. Explore (`/app/explore`)
    3. Validate (`/app/validations/create`) — Elevated central orange pill
    4. Network (`/app/network`)
    5. Profile (`/app/profile`)
  - Sticky mobile header with Truthprenuer logo, search icon, and notification bell.
  - Touch targets minimum 48×48px with 8px thumb margin.
  - Modals convert into bottom slide-up sheets with swipe-down dismissal.
