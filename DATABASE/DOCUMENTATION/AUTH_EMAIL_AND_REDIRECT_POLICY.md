# TRUTHPRENUER PRODUCTION AUTHENTICATION EMAIL & REDIRECT POLICY

## 1. Executive Summary

This document specifies the authoritative configuration for Supabase Authentication, email delivery providers, DNS records (SPF, DKIM, DMARC), and redirect URL allowlists for Truthprenuer in production (`https://truthprenuer.pages.dev`).

---

## 2. Supabase Auth URL Configuration

### 2.1 Canonical Site URL
- **Site URL**: `https://truthprenuer.pages.dev`
- **Purpose**: All authentication emails and magic links use this origin as their canonical root.

### 2.2 Redirect Allowlist (Additional Redirect URLs)
Strict allowlist of valid production destinations. No wildcards (`*`) or unvalidated external origins are permitted.
- `https://truthprenuer.pages.dev/auth/callback` (Primary PKCE/OTP exchange route)
- `https://truthprenuer.pages.dev/auth/reset-password` (Password reset entrypoint)
- `https://truthprenuer.pages.dev/change-password` (Authenticated recovery screen)
- `https://truthprenuer.pages.dev/` (Post-login application root)

### 2.3 Strict Exclusion of Localhost in Production
- **Policy**: `http://localhost:*` and `http://127.0.0.1:*` MUST NEVER be included in the production Supabase dashboard redirect allowlist.
- **Development Isolation**: Local development must use a separate local Supabase CLI instance (`supabase start` on Docker) or an isolated development environment project (`dev-truthprenuer`).

---

## 3. Email Delivery & Sender Identity Configuration

### 3.1 Sender Profile
- **Sender Name**: `Truthprenuer`
- **Sender Email**: `no-reply@truthprenuer.pages.dev` (or verified custom domain)
- **Support / Reply-To**: `support@truthprenuer.pages.dev`

### 3.2 DNS Records (Domain Authentication)
To prevent spoofing and guarantee high deliverability into user inboxes:
1. **SPF (Sender Policy Framework)**:
   ```txt
   v=spf1 include:mailgun.org include:_spf.google.com ~all
   ```
2. **DKIM (DomainKeys Identified Mail)**:
   Configure the three distinct CNAME records provided by the verified SMTP provider (e.g. Mailgun/SendGrid/Resend) on Cloudflare DNS.
3. **DMARC (Domain-based Message Authentication, Reporting, and Conformance)**:
   ```txt
   _dmarc.truthprenuer.pages.dev TXT "v=DMARC1; p=quarantine; pct=100; rua=mailto:dmarc-reports@truthprenuer.pages.dev"
   ```

---

## 4. Production Auth Email Templates

### 4.1 Confirm Signup / Verification Email
- **Subject**: Confirm your Truthprenuer Account
- **Body**:
  ```html
  <h2>Welcome to Truthprenuer</h2>
  <p>Please confirm your account by clicking the secure link below:</p>
  <p><a href="{{ .SiteURL }}/auth/callback?token_hash={{ .TokenHash }}&type=signup&next=/">Confirm My Account</a></p>
  <p>If you did not sign up for Truthprenuer, you can safely ignore this email.</p>
  ```

### 4.2 Password Recovery / Reset Email
- **Subject**: Reset Your Truthprenuer Password
- **Body**:
  ```html
  <h2>Password Reset Request</h2>
  <p>We received a request to reset your password for Truthprenuer. Click the button below to set a new password:</p>
  <p><a href="{{ .SiteURL }}/auth/callback?token_hash={{ .TokenHash }}&type=recovery&next=/auth/reset-password">Reset Password</a></p>
  <p>This single-use link expires in 15 minutes. If you did not request this change, please check your account security immediately.</p>
  ```

### 4.3 Magic Link / OTP Email
- **Subject**: Your Truthprenuer Login Code
- **Body**:
  ```html
  <h2>Sign In to Truthprenuer</h2>
  <p>Your 6-digit one-time passcode is:</p>
  <h1 style="letter-spacing: 6px; font-family: monospace;">{{ .Token }}</h1>
  <p>Or click to log in immediately:</p>
  <p><a href="{{ .SiteURL }}/auth/callback?token_hash={{ .TokenHash }}&type=magiclink&next=/">Sign In Now</a></p>
  ```

---

## 5. Token Handling & Verification Lifecycle

1. **Client Exchange**:
   - The Flutter web client handles `/auth/callback` via `AuthCallbackView` ([`USERS/lib/views/auth/auth_callback_view.dart`](../../USERS/lib/views/auth/auth_callback_view.dart)).
   - Tokens received in the URI query or hash fragment are processed through `client.auth.verifyOTP(...)`.
2. **Error Recovery**:
   - If a link has expired or was already used, `AuthCallbackView` displays a clear error explanation and offers a one-tap button to request a fresh link or return to sign-in.
3. **Zero Token Storage**:
   - Verification tokens are never stored in localStorage, cookies, query logs, or persistent disk.
