# TRUTHPRENUER PRODUCTION RATE LIMITING & ABUSE PREVENTION POLICY

## 1. Overview & Defense-in-Depth Model

Truthprenuer applies a layered multi-tier defense strategy against abuse, volumetric attacks, automated scraping, credential stuffing, and resource exhaustion.

```
+-------------------------------------------------------------------+
| 1. Cloudflare Edge WAF (DDoS Mitigation, Bot Fight Mode, Rate Limit) |
+-------------------------------------------------------------------+
                                  |
+-------------------------------------------------------------------+
| 2. Client-Side Debouncing, Form In-Flight Locks & Optimistic Guard |
+-------------------------------------------------------------------+
                                  |
+-------------------------------------------------------------------+
| 3. Application Gateway / FastAPI SlowAPI & Redis Token Bucket     |
+-------------------------------------------------------------------+
                                  |
+-------------------------------------------------------------------+
| 4. Supabase Auth Native Limits & PostgreSQL Connection Limits     |
+-------------------------------------------------------------------+
```

---

## 2. Configurable Rate Limits by Operation

| Category | Endpoint / Action | Limit (Per IP) | Limit (Per User / Account) | Window | HTTP Response |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Auth** | Sign Up | 5 req | 3 accounts | 1 hour | `429 Too Many Requests` |
| **Auth** | Login / Password Verify | 10 req | 5 failures | 15 mins | `429 Too Many Requests` |
| **Auth** | OTP / Password Reset Email | 3 req | 3 req | 1 hour | `429 Too Many Requests` |
| **Profile**| Username / Profile Update | 10 req | 5 req | 1 hour | `429 Too Many Requests` |
| **Core** | Create Validation Sprint | 10 req | 5 sprints | 1 hour | `429 Too Many Requests` |
| **Core** | Submit Feedback / Response | 30 req | 20 responses | 1 hour | `429 Too Many Requests` |
| **Social**| Send Connection Request | 20 req | 15 requests | 1 hour | `429 Too Many Requests` |
| **Chat** | Send Direct Message | 60 req | 60 messages | 1 minute | `429 Too Many Requests` |
| **Search**| Global & Username Search | 30 req | 30 queries | 1 minute | `429 Too Many Requests` |
| **Storage**| Upload Evidence Artifact | 15 uploads | 10 uploads | 1 hour | `413 / 429` |
| **AI** | Generate Evidence Synthesis | 10 req | 10 analyses | 24 hours | `429 Quota Exceeded` |

---

## 3. Implementation Details

### 3.1 Client-Side Debouncing & Locks
- **Search Inputs**: Debounced at 300ms; queries under 2 characters are not submitted to remote endpoints.
- **Upvotes / Interactions**: Debounced with an in-flight lock (`_inFlight.contains(id)`) with a minimum 250ms guard window to eliminate UI double-click oscillations.
- **Connection Toggles**: State machine validates transitions (`none -> requested -> connected`) and locks while pending server response.

### 3.2 Backend / API Enforcement (`backend/app/`)
- Protected endpoints use the `SlowAPI` limiter with key derivation based on authenticated user ID (or client IP fallback).
- Returns standard RFC 6585 headers:
  - `Retry-After: <seconds>`
  - `X-RateLimit-Limit: <max>`
  - `X-RateLimit-Remaining: <left>`
  - `X-RateLimit-Reset: <timestamp>`

### 3.3 Storage Upload Guardrails
- **Max File Size**: 10 Megabytes.
- **Allowed MIME Types**: `image/jpeg`, `image/png`, `image/webp`, `application/pdf`.
- **Virus & Malware Scanning**: Client uploads must be uploaded to private, authenticated buckets (`evidence_vault`) accessible only via short-lived signed URLs.

### 3.4 AI Quota Management
- AI synthesis calls (`ai_analyses`) require an active validated user session.
- Per-user daily analysis quotas are enforced before calling Google Gemini or Anthropic Claude APIs to prevent runaway API billing.
