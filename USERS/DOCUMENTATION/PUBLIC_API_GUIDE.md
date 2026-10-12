# TRUTHPRENUER — PUBLIC API & INTEGRATION GUIDE

## 1. Overview

Truthprenuer exposes public, authenticated APIs for founders, investors, and client applications.

- **Production Base URL:** `https://api.truthprenuer.com`
- **Development Base URL:** `http://localhost:8000`

---

## 2. Authentication

All requests to private user resources require a Bearer token issued by Supabase Auth:
```http
Authorization: Bearer <supabase_jwt_token>
```

---

## 3. Core Public Endpoints

### 3.1 Service Health
- `GET /health/live`: Liveness check (HTTP 200)
- `GET /health/ready`: Readiness check (HTTP 200 if dependencies connected)

### 3.2 AI Validation Engine
- `POST /api/v1/ai/validate`
  - **Rate Limit:** 10 requests / minute
  - **Headers:** `Authorization: Bearer <token>`
  - **Body:**
    ```json
    {
      "problem": "Founders lack objective signal on customer pain points",
      "solution": "Automated validation matrix with counter-metrics",
      "industry": "B2B SaaS",
      "target_audience": "Early stage founders"
    }
    ```
  - **Response:** Validation analysis, hypothesis suggestions, and counter-metric prompts.

---

## 4. Administrative Endpoints Warning

Administrative endpoints under `/api/v1/admin/*` are strictly barred from public internet ingress. Any attempt to access them from non-loopback network addresses will return **HTTP 403 Forbidden**.
