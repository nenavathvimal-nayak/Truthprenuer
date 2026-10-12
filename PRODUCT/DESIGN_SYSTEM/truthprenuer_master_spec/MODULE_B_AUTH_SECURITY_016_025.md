# TRUTHPRENUER — MODULE B: AUTHENTICATION & ACCOUNT RECOVERY
## Screens 016 – 025 Specification

---

### Module Overview
- **Domain:** Authentication, Identity Verification, Session Management & Security Recovery
- **Security Posture:** Zero cleartext storage, strict rate-limiting, accessible error handling, biometric & passkey readiness, resilient multi-factor verification (SMS/Email OTP & WebAuthn).
- **Brand Palette Adherence:**
  - Background: Neutral Cream `#FEF8E8` / Dark `#161616`.
  - Auth Modal Card: `#FFFFFF` (Light) / `#1F1F1F` (Dark), with 1px border `#E4E2E3` / `#2A2A2A`.
  - Primary Action CTA: `#F44A22` (Empower Orange), minimum height 48px, minimum tap target 48x48px.
  - Form Fields: 44px height, 1px border `#A8AAAC`, focused border 2px `#F44A22` with 2px offset focus ring.

---

### Screen 016: Sign Up — Phone
- **Screen ID:** `SCR-016`
- **Route:** `/signup/phone`
- **Primary Persona:** Mobile-first founder or validator preferring SMS authentication
- **Layout Architecture:** Centered auth card (480px width on desktop, 100% full-width with 16px margins on mobile 390px).

#### Layout Structure
```
+--------------------------------------------------------------------------------+
| [Truthprenuer Logo]                                                            |
|                                                                                |
| CREATE YOUR ACCOUNT                                                            |
| Start testing hypotheses with unbiased human & AI evidence.                    |
|                                                                                |
| [ Phone Number Input with International Dial Code Dropdown (+1, +44, +91, ...) ]
| [x] I agree to the Terms of Service and Privacy Policy.                        |
|                                                                                |
| [ Send Verification Code (Primary Orange Button) ]                             |
|                                                                                |
| -------------------------- OR CONTINUE WITH ---------------------------------- |
| [ Email Sign Up ]      [ Google ]      [ GitHub ]      [ Apple ]               |
|                                                                                |
| Already have an account? [ Log In ]                                            |
+--------------------------------------------------------------------------------+
```

#### States & Validation Rules
- **Invalid Phone Number:** Real-time regex validation based on selected country dial code; shows red helper message below field: *"Please enter a valid 10-digit phone number for India (+91)"*.
- **Rate Limit State:** If > 3 SMS requests in 10 minutes: disables button, displays amber alert: *"Rate limit reached. Please wait 4 minutes and 32 seconds before requesting another SMS."*
- **Terms Checkbox Unchecked:** Submit button disabled or triggers accessible error state with red border.

---

### Screen 017: Sign Up — Email
- **Screen ID:** `SCR-017`
- **Route:** `/signup`
- **Primary Persona:** Desktop founder or enterprise operator
- **Form Fields:** Full Name, Work/Personal Email, Password (with interactive 4-rule strength meter: Min 8 chars, 1 uppercase, 1 number, 1 special character).
- **Micro-Interactions:** Password visibility toggle button with accessible aria-label ("Show password" / "Hide password").

---

### Screen 018: Phone OTP Verification
- **Screen ID:** `SCR-018`
- **Route:** `/signup/verify-phone`
- **Primary Persona:** User completing SMS registration
- **Form Fields:** 6-digit segmented OTP input box with auto-focus, paste auto-distribution, and numeric keypad trigger on mobile.
- **Resend Countdown:** Active 60-second ticker (`Resend code in 0:48`); upon 0:00, transforms into clickable link *"Resend SMS"* and fallback *"Receive Code via Voice Call"*.
- **Invalid Code State:** Shakes input on incorrect OTP; red error text *"Incorrect 6-digit code. 2 attempts remaining before temporary lockout."*

---

### Screen 019: Email Verification
- **Screen ID:** `SCR-019`
- **Route:** `/signup/verify-email`
- **Experience:** Clean illustration of an inbox envelope; displays target email address (e.g., `founder@startup.io`) with an *"Edit email"* button if typed incorrectly.
- **Deep Link Support:** "Open Gmail" / "Open Outlook" smart action buttons on desktop; polling websocket detects verification in background and transitions automatically to Welcome Screen `SCR-026`.

---

### Screen 020: Login
- **Screen ID:** `SCR-020`
- **Route:** `/login`
- **Form Fields:**
  - Identifier (Email or Phone Number)
  - Password
  - "Remember this device for 30 days" checkbox
  - "Forgot password?" right-aligned link -> Routes to `SCR-023`
- **Security Features:** Progressive captcha trigger after 2 consecutive failed attempts; account lockout notice after 5 failed attempts.

---

### Screen 021: Social Login / Connected Identity
- **Screen ID:** `SCR-021`
- **Route:** `/login/connected-identity`
- **Use Case:** Multi-identity resolution (e.g., user signed up with Google, now attempts email password login with the same address).
- **Interface:** Explanatory modal stating: *"An account with founder@example.com already exists using Google Sign-In. Connect your password to this account or continue with Google."*

---

### Screen 022: Create or Reset Password
- **Screen ID:** `SCR-022`
- **Route:** `/auth/reset-password`
- **Inputs:** New Password, Confirm New Password.
- **Security Requirements:** Checks against HaveIBeenPwned common password dictionary; prevents reuse of last 3 passwords.

---

### Screen 023: Forgot Password
- **Screen ID:** `SCR-023`
- **Route:** `/forgot-password`
- **Inputs:** Registered email address.
- **Privacy Preservation:** Regardless of whether the email exists in the database, displays universal confirmation message: *"If an account matches this email, a reset link has been dispatched."* (Prevents account enumeration attacks).

---

### Screen 024: Account Recovery
- **Screen ID:** `SCR-024`
- **Route:** `/account-recovery`
- **Use Case:** User lost access to both primary phone and 2FA authenticator.
- **Workflow:** Secure 24-word recovery seed phrase entry or verified identity backup request with 48-hour security cool-off period.

---

### Screen 025: Session Expired / Re-authentication
- **Screen ID:** `SCR-025`
- **Route:** Modal overlay / `/session-expired`
- **Context:** User was inactive for > 2 hours or performed a sensitive action (e.g., changing payout bank details, deleting validation project).
- **Behavior:** Non-destructive overlay that preserves unsaved form state in localStorage, requests password or biometric passkey, and resumes user exactly where they paused.
