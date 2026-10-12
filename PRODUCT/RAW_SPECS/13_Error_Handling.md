# DOCUMENT 13 — ERROR HANDLING

**Document ID:** DOC-13  
**Version:** 1.0  
**Last Updated:** 2026-08-20  
**Owner:** Product & Engineering  
**Status:** Draft  
**Upstream Dependencies:** DOC-08 (UI/UX Spec), DOC-11 (Frontend), DOC-12 (Backend)  
**Downstream Dependents:** DOC-14 (Analytics), DOC-16 (QA)  

---

## Table of Contents

1. [Error Handling Philosophy](#1-error-handling-philosophy)
2. [Global Error Taxonomy](#2-global-error-taxonomy)
3. [Client & Network Errors](#3-client--network-errors)
4. [Authentication & Authorization Errors](#4-authentication--authorization-errors)
5. [Data & Validation Errors](#5-data--validation-errors)
6. [System & AI Errors](#6-system--ai-errors)
7. [UI State & Recovery Mapping](#7-ui-state--recovery-mapping)
8. [Decision Registry Extract](#8-decision-registry-extract)
9. [Document Status](#9-document-status)

---

## 1. Error Handling Philosophy

**ERR-001: Human, Not Technical.**
Users must never see raw JSON, stack traces, or generic "Something went wrong" messages without an action. Every error must explain *what happened* in plain language and *what the user can do next*.

**ERR-002: Actionable Recovery.**
Every error state must have a recovery path: a retry button, a fallback UI, or a clear instruction (e.g., "Check your connection").

**ERR-003: Silent vs. Loud Failures.**
- **Silent (Background):** Non-critical telemetry or pre-fetching failures fail silently and retry with exponential backoff.
- **Subtle (Toasts/Snackbars):** Minor mutations (e.g., liking a post failed) show a temporary toast and revert optimistic UI updates.
- **Loud (Full Screen/Modals):** Critical blocking failures (e.g., Feed failed to load, Login failed) require explicit user action.

---

## 2. Global Error Taxonomy

All errors must map to this standard taxonomy across Frontend and Backend.

| Category | HTTP Status | Internal Code Prefix | Logging Level | Analytics Event |
| :--- | :--- | :--- | :--- | :--- |
| **Network/Client** | None / 0 | `NET_` | Info / Warn | `error_network` |
| **Auth/Security** | 401, 403 | `SEC_` | Warn / Security | `error_security` |
| **Validation/Data** | 400, 404, 409, 422 | `VAL_` | Info | `error_validation` |
| **System/Server** | 500, 502, 503, 504 | `SYS_` | Error / Critical | `error_system` |
| **AI/External** | 502, 504 | `AI_` | Error | `error_ai` |

---

## 3. Client & Network Errors

### 3.1 Offline / No Connection
- **Trigger:** Device has no internet, or network request immediately fails.
- **Developer Code:** `NET_001_OFFLINE`
- **User Message:** "You're offline. Please check your connection and try again."
- **UI State:** Full-screen offline illustration (if primary data), or subtle banner (if cached data is available).
- **Recovery:** Polling for connection restoration; manual "Retry" button.
- **Logging/Analytics:** Only logged locally; syncs `error_network_offline` when reconnected.

### 3.2 Request Timeout
- **Trigger:** Request exceeds 15 seconds (30s for uploads/AI).
- **Developer Code:** `NET_002_TIMEOUT`
- **User Message:** "This is taking longer than expected. Please try again."
- **UI State:** Stop loading spinner, revert to previous state or show error card.
- **Recovery:** Manual retry.
- **Logging/Analytics:** Log as warning; track `error_network_timeout`.

---

## 4. Authentication & Authorization Errors

### 4.1 Unauthorized (Invalid Session)
- **Trigger:** 401 response (Token expired and refresh failed, or logged out remotely).
- **Developer Code:** `SEC_401_UNAUTHORIZED`
- **User Message:** "Your session has expired. Please log in again to continue."
- **UI State:** Force redirect to Login/Onboarding screen.
- **Recovery:** User logs in again.
- **Logging/Analytics:** Log as Info. Track `auth_session_expired`.

### 4.2 Forbidden (Permissions)
- **Trigger:** 403 response (User tries to edit someone else's startup, or lacks admin rights).
- **Developer Code:** `SEC_403_FORBIDDEN`
- **User Message:** "You don't have permission to do this."
- **UI State:** Bottom Sheet / Snackbar error message.
- **Recovery:** Hide the UI element that triggered the action; revert optimistic update.
- **Logging/Analytics:** Log as Security Alert (potential abuse). Track `error_permission_denied`.

---

## 5. Data & Validation Errors

### 5.1 Validation Error (Bad Request)
- **Trigger:** 400 or 422 response (Form validation failed on server).
- **Developer Code:** `VAL_400_BAD_REQUEST`
- **User Message:** Dynamic based on field (e.g., "That startup name is already taken.")
- **UI State:** Inline red text below the specific form field.
- **Recovery:** User corrects the input.
- **Logging/Analytics:** Track `error_form_validation` with field name to identify confusing UX.

### 5.2 Not Found
- **Trigger:** 404 response (Requested profile or startup does not exist).
- **Developer Code:** `VAL_404_NOT_FOUND`
- **User Message:** "We couldn't find what you were looking for. It may have been deleted."
- **UI State:** Dedicated "Empty/Not Found" illustration screen.
- **Recovery:** "Go Back" or "Return Home" button.
- **Logging/Analytics:** Track `error_404` to monitor broken links.

### 5.3 Conflict (Optimistic Concurrency)
- **Trigger:** 409 response (Two users editing the same resource).
- **Developer Code:** `VAL_409_CONFLICT`
- **User Message:** "This information was just updated by someone else. Please refresh and try again."
- **UI State:** Dialog box prompting a refresh.
- **Recovery:** Reload data from server.
- **Logging/Analytics:** Track `error_data_conflict`.

### 5.4 Rate Limit
- **Trigger:** 429 response (Too many requests, anti-spam).
- **Developer Code:** `VAL_429_RATE_LIMIT`
- **User Message:** "You're doing that too fast. Please wait a moment."
- **UI State:** Snackbar, disable the submit button temporarily.
- **Recovery:** Auto-enable button after `Retry-After` header duration.
- **Logging/Analytics:** Log as Warn (potential abuse/bot). Track `error_rate_limit`.

---

## 6. System & AI Errors

### 6.1 Server Error
- **Trigger:** 500+ response (Backend crashed, DB down).
- **Developer Code:** `SYS_500_INTERNAL`
- **User Message:** "Something went wrong on our end. Our team has been notified."
- **UI State:** Global error boundary or Toast (depending on severity).
- **Recovery:** Manual retry.
- **Logging/Analytics:** Trigger PagerDuty/Critical APM Alert.

### 6.2 AI Generation Failure
- **Trigger:** LLM timeout, content filter triggered, or upstream API down.
- **Developer Code:** `AI_503_UNAVAILABLE`
- **User Message:** "Our AI assistant is currently busy or unavailable. Please try again in a few minutes."
- **UI State:** Replace AI skeleton loader with an error block and a "Regenerate" button.
- **Recovery:** Manual retry, or fallback to a deterministic human workflow.
- **Logging/Analytics:** Track `error_ai_failure` with sub-reason (timeout, filter, rate_limit).

### 6.3 Media Upload Failure
- **Trigger:** S3 presigned URL fails, or file too large.
- **Developer Code:** `SYS_UPLOAD_FAILED`
- **User Message:** "Your upload failed. Please ensure the file is under 10MB."
- **UI State:** Red exclamation mark on the image thumbnail.
- **Recovery:** Tap thumbnail to retry upload.
- **Logging/Analytics:** Track `error_media_upload`.

### 6.4 Realtime / WebSocket Failure
- **Trigger:** Socket disconnects abruptly.
- **Developer Code:** `SYS_WS_DISCONNECT`
- **User Message:** None (Silent failure).
- **UI State:** Show a subtle "Reconnecting..." indicator if a live chat/feed is open.
- **Recovery:** Exponential backoff auto-reconnect.
- **Logging/Analytics:** Log socket drops to monitor infrastructure stability.

---

## 7. UI State & Recovery Mapping

Every frontend feature must implement these states:

| State | Visual | Action |
| :--- | :--- | :--- |
| **Initial / Loading** | Skeletons / Shimmer | Wait. |
| **Empty** | Illustration + Text | "Create New" or "Explore". |
| **Data (Success)** | Standard Layout | Normal interaction. |
| **Error (Inline)** | Red text / Border | Fix input. |
| **Error (Component)**| Error Icon + Text inside the card | Tap to retry that specific component. |
| **Error (Screen)** | Full page error illustration | "Try Again" or "Go Home". |

---

## 8. Decision Registry Extract

| ID | Decision | Reason | Status |
|---|---|---|---|
| DEC-ERR-001 | Human-Readable Errors | Raw errors erode trust. All errors must map to consumer-friendly copy. | Approved |
| DEC-ERR-002 | Actionable Recoveries | Dead-ends cause churn. Every error must have a way out. | Approved |
| DEC-ERR-003 | Silent Realtime Drops | Socket drops happen constantly on mobile. Don't spam the user; silently reconnect. | Approved |

---

## 9. Document Status

**STATUS:** Draft  
**REVIEW STATE:** Needs Review  

### Consistency Check Against Upstream Docs

| Check | Result |
|-------|--------|
| Matches UI states defined in DOC-08 (Empty, Loading, Error). | ✅ |
| Supports Backend HTTP codes (DOC-12). | ✅ |
| Provides Analytics telemetry triggers (Precursor to DOC-14). | ✅ |

### Next Actions

1. Proceed to generate DOC-14 (Analytics).
