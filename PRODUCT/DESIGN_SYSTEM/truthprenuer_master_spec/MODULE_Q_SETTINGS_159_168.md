# TRUTHPRENUER — MODULE Q: USER SETTINGS, PRIVACY & SECURITY
## Screens 159 – 168 Specification

---

### Module Overview
- **Domain:** User Preferences, Theme Switcher, Session Security, GDPR Data Portability & Account Deletion
- **Privacy Standard:** Zero silent data sharing; user has complete ownership of uploaded evidence, personal metadata, and active session revocations.

---

### Screen 159: Settings Overview
- **Screen ID:** `SCR-159`
- **Route:** `/app/settings`
- **Navigation Layout:**
  - Sidebar: Account, Appearance, Notifications, Connected Accounts, Privacy, Security & Sessions, Data & Export, Danger Zone.
  - Central Pane: High-level overview of account health, active security tier, and membership status.

---

### Screen 160: Account Settings
- **Screen ID:** `SCR-160`
- **Route:** `/app/settings/account`
- **Inputs:** Legal Name, Primary Email (with change email verification flow), Phone Number, Preferred Language (English, Spanish, Hindi, German, Japanese), Timezone selector.

---

### Screen 161: Theme & Appearance
- **Screen ID:** `SCR-161`
- **Route:** `/app/settings/theme`
- **Visual Switcher:**
  - **Light Mode:** High contrast, Silver/Cream `#FEF8E8` canvas, crisp typography.
  - **Dark Mode:** Deep Midnight Black `#161616` canvas, charcoal cards `#1F1F1F`.
  - **System Synchronized:** Automatically mirrors OS preference.
  - High Contrast Accessibility Mode toggle (WCAG AAA compliant borders).

---

### Screen 162: Notification Preferences
- **Screen ID:** `SCR-162`
- **Route:** `/app/settings/notifications`
- **Controls:** Detailed checkboxes for Email, Web Push, and SMS for all platform event categories.

---

### Screen 163: Connected Accounts
- **Screen ID:** `SCR-163`
- **Route:** `/app/settings/connected-accounts`
- **Identity Integrations:**
  - Google (Connected as `sarah@startup.io`) — [Disconnect]
  - GitHub (Connected as `@sarahdev`) — [Disconnect]
  - Apple — [Connect Account]
  - Slack Webhook — [Configure Bot]

---

### Screen 164: Privacy & Visibility
- **Screen ID:** `SCR-164`
- **Route:** `/app/settings/privacy`
- **Permissions:**
  - Search Engine Indexing: Allow Google to index my public validations (On/Off).
  - Profile Visibility: Public / Logged-in Users Only / Private.
  - Anonymize my feedback contributions in aggregated statistics (On/Off).

---

### Screen 165: Security & Active Sessions
- **Screen ID:** `SCR-165`
- **Route:** `/app/settings/security`
- **Security Dashboard:**
  - Two-Factor Authentication (2FA): TOTP Authenticator App (Active) / SMS Fallback.
  - Passkeys / WebAuthn: Register TouchID / Windows Hello / YubiKey.
  - Active Sessions List:
    - *Current Session:* Chrome on macOS (San Francisco, USA) • IP 192.0.2.1
    - *Mobile App:* iOS 17 on iPhone 15 Pro • Last active 2 hours ago
    - Action: "Log Out of All Other Devices" button (`#F44A22` outline).

---

### Screen 166: Data Export Request
- **Screen ID:** `SCR-166`
- **Route:** `/app/settings/data-export`
- **GDPR / CCPA Compliant Export:**
  - Select Data Packages: Profile & Credentials, Validations & Hypotheses, Evidence Locker Files, Discussion & Review History.
  - Action: "Generate Full Data Archive (ZIP)" -> Dispatches encrypted download link to verified email.

---

### Screen 167: Account Deletion Workflow
- **Screen ID:** `SCR-167`
- **Route:** `/app/settings/delete-account`
- **Irreversible Deletion Protocol:**
  - 3-Step Danger Flow:
    1. Warning regarding loss of all validations, reputation badges, and active subscriptions.
    2. Optional feedback prompt: "Why are you leaving?"
    3. Final confirmation: Type `DELETE MY TRUTHPRENUER ACCOUNT` to enable red confirmation button (`#DC2626`).
  - 14-day grace period with instant lockout.

---

### Screen 168: Consent & Data Preferences
- **Screen ID:** `SCR-168`
- **Route:** `/app/settings/consent`
- **Granular Cookie & Telemetry Controls:** Strictly Necessary (Always On), Functional Analytics, AI Training Consent (Explicit Opt-In/Opt-Out for allowing anonymized data to improve synthesis models).
