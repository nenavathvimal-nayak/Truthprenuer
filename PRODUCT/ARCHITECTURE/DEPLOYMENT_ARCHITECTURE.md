# TRUTHPRENUER — DEPLOYMENT ARCHITECTURE SPECIFICATION

**Deployment Topology & Separation of Concerns**

---

## 1. Multi-Tier Deployment Model

Truthprenuer strictly divides its architecture into **Public User Infrastructure** and **Private Localhost Administration**:

```mermaid
graph LR
    subgraph Public Tier (Internet Accessible)
        CloudflarePages[Cloudflare Pages: https://truthprenuer.pages.dev]
        MobileStores[App Store / Play Store: Native Mobile App]
        BackendCloud[Cloud Container: https://api.truthprenuer.com]
        SupabaseCloud[Supabase Managed DB & Auth Engine]
    end

    subgraph Private Tier (Localhost 127.0.0.1 Only)
        AdminLocal[Admin Console: http://127.0.0.1:60135]
        AdminScript[ADMIN/RUN_LOCAL/start_admin_60135.sh]
    end

    CloudflarePages -->|Public REST / AI API| BackendCloud
    MobileStores -->|Public REST / AI API| BackendCloud
    CloudflarePages -->|Client Auth & Data (RLS)| SupabaseCloud
    MobileStores -->|Client Auth & Data (RLS)| SupabaseCloud
    BackendCloud -->|Service Role (JWT Secret Verified)| SupabaseCloud

    AdminLocal -->|Strict Loopback Call Only| BackendCloud
    AdminLocal -->|Direct Auth Session (RLS Protected)| SupabaseCloud
```

---

## 2. Public User Application Deployment

- **Hosting Platform:** Cloudflare Pages (Static Web SPA)
- **Custom Domain:** `https://truthprenuer.pages.dev`
- **Build Script:** [`scripts/build_flutter_web.sh`](file:///Volumes/NAYAK/taeed_flutter_source/scripts/build_flutter_web.sh)
- **Output Directory:** `build/web/`
- **Invariants:**
  - Administrative routes are disabled in release web builds.
  - No service-role key or JWT secret is ever embedded in the web bundle.
  - SPA routing rules configured via `build/web/_redirects`.

---

## 3. Public API / Backend Deployment

- **Hosting Platform:** Cloud Run / Fly.io / Docker Compose
- **Dockerfile:** [`backend/Dockerfile`](file:///Volumes/NAYAK/taeed_flutter_source/backend/Dockerfile)
  - Multi-stage build based on `python:3.11-slim`.
  - Non-root user `appuser` (UID 10001).
  - Healthcheck on `/health/live`.
  - Uvicorn with 2 worker processes and proxy header forwarding.

---

## 4. Private Admin Panel Execution (Never Deployed)

- **Execution Environment:** Authorized Owner's Local Workstation
- **Address:** `http://127.0.0.1:60135`
- **Startup Command:** `ADMIN/RUN_LOCAL/start_admin_60135.sh`
- **Invariants:**
  - Binds strictly to `127.0.0.1`, never `0.0.0.0`.
  - Fail-fast port conflict check (`strictPort: true`).
  - Never published to Cloudflare Pages, Netlify, Vercel, or any remote host.
  - Excluded from public build artifacts.
  - All backend admin endpoints (`/api/v1/admin/*`) reject non-loopback IPs with HTTP 403 Forbidden.
