# TRUTHPRENUER — Screen Flow & Navigation Hierarchy Map
**Phase 2 Information Architecture & Screen Flow**
**Status:** Canonical Routing Specification  

---

## 1. Global Navigation Architecture

The application adopts a **single, unified 5-destination bottom navigation shell** for all user roles. Rather than changing navigation tabs or labels per role, the shell remains constant while the content surfaces inside adapt dynamically based on the active role workspace.

```text
===========================================================
GLOBAL NAVIGATION BAR (Persistent across all roles)
[ HOME ]     [ EXPLORE ]     [ VALIDATE ]     [ NETWORK ]     [ PROFILE ]
===========================================================
```

---

## 2. Navigable Route Hierarchy

### 2.1 Entry & Onboarding Group (P0)
```text
/splash                    SplashView (Session bootstrap & routing logic)
└── /onboarding            OnboardingView (Problem → Validation → Evidence → Decision value concepts)
    └── /action            ActionSelectionView (Intent selection: Validate, Give Feedback, Discover)
```

### 2.2 Authentication Group (P0)
```text
/auth                      LoginView (Email & password credentials)
├── /signup                SignupView (Account registration & legal consent)
├── /otp                   OTPVerificationView (6-digit email confirmation code)
├── /forgot-password       ForgotPasswordView (Password reset link request)
└── /profile-setup         ProfileSetupWizardView (Name, handle, role, skills, avatar)
```

### 2.3 Main Application Shell Group (P0)
```text
/                          MainTabView (Persistent bottom nav container)
├── Tab 0: /home           DashboardView (Role-aware operating surface)
│   ├── Founder Workspace  Current Focus, Latest Signal, Decision Required, Next Experiment
│   ├── Investor Workspace High Evidence Conviction, Watchlist, Opportunity Feed
│   ├── Professional W/S   Validations Seeking Input, Contribution Karma, Expertise
│   └── Creator Workspace  Validation Themes, Domain Insights, Discovery
├── Tab 1: /explore        ExploreView (Unified discovery feed for Validations & People)
├── Tab 2: /validate       ValidationDashboardView (Operating workspace: Active, Drafts, Completed)
├── Tab 3: /network        NetworkView (Peer directory, connections, pending requests)
└── Tab 4: /profile        ProfileView (Identity, verified contributions, settings launcher)
```

### 2.4 Core Validation & Evidence Group (P0)
```text
/validation-wizard         ValidationWizardView (8-step creation flow with autosave)
/validation/:id            ValidationDetailView (Authoritative core object surface)
├── /validation/:id/feedback  StructuredFeedbackView (Question-by-question response form)
├── /evidence-locker       EvidenceLockerView (First-class evidence repository & filter)
└── /ai-validation         AIValidationView (8-part structured evidence synthesis report)
```

### 2.5 Communication & Notifications Group (P0/P1)
```text
/notifications             NotificationsView (Deep-linked event timeline)
/chats                     ChatsListView (Active conversations list)
└── /chat-room             ChatRoomView (1-on-1 message stream & composer)
```

### 2.6 Account, Privacy & Security Group (P0)
```text
/settings                  SettingsView (Security, Privacy, Notifications, Theme, Account)
├── /change-password       ChangePasswordView (Credential update form)
├── /notification-preferences NotificationPreferencesView (Push, email, in-app channels)
├── /privacy               PrivacyDashboardView (DPDP/GDPR rights, data inventory, export)
└── /edit-profile          EditProfileView (Profile fields and avatar update)
```

---

## 3. Subviews & Segmented Containers

Rather than fragmenting the router with dozens of micro-routes, these views operate as tabs or segmented stateful controls:
- **`ValidationDashboardView`**:
  - `Active Validations`
  - `Saved Drafts`
  - `Completed Sprints`
- **`NetworkView`**:
  - `Recommended Peers`
  - `My Connections`
  - `Pending Requests (Received / Sent)`
- **`ExploreView`**:
  - `Validations`
  - `People`

---

## 4. Modals & Bottom Sheets

Compact interactive surfaces reserved for short workflows:
| Component | Trigger Context | Dismiss Action |
| :--- | :--- | :--- |
| `FilterSheet` | Explore search bar filter icon | Apply / Clear All |
| `AddEvidenceSheet` | Evidence Locker CTA | Save / Cancel |
| `RoleSwitcherModal` | Top navigation bar role badge | Select role / Close |
| `AvatarPickerModal` | Profile setup & Edit Profile | Take Photo / Choose / Cancel |
| `ReportModal` | Validation, Profile, or Chat menu | Submit reason / Dismiss |
| `DeleteAccountModal` | Settings Danger Zone | Password confirm / Cancel |

---

## 5. Universal State System (Zero-Route Error & Lifecycle)

Every asynchronous surface embeds a standardized `UniversalStateView`:
1. **Loading**: Skeleton placeholder matching content shape.
2. **Empty**: Explains what is empty, why, and provides a direct primary CTA.
3. **Error**: User-friendly diagnosis with a clear `Retry` CTA.
4. **Offline**: Lightweight non-blocking persistent banner.
5. **Unauthorized**: Explicit notice that private validation or evidence is restricted to authorized accounts.
