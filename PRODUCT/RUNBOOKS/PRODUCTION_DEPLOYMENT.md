# TRUTHPRENUER — PRODUCTION DEPLOYMENT RUNBOOK

## 1. Deployment Principles

- **Public Applications (Web & Mobile):** Deployed to Cloudflare Pages and App Stores.
- **Backend API:** Packaged into multi-stage Docker container deployed to Cloud Run or Fly.io.
- **Admin Console:** **NEVER DEPLOYED TO CLOUD.** Remains local on `127.0.0.1:60135`.

---

## 2. Pre-Deployment Stage Gate Checklist

Prior to triggering production releases, all automated gates must pass:
- [ ] `flutter test` passes (64 tests)
- [ ] `pytest backend/tests/ -v` passes (13 tests)
- [ ] `npm run build` in `admin_panel/` passes with 0 errors
- [ ] Gitleaks secret scan passes with 0 findings
- [ ] Git working tree is clean on `main` branch

---

## 3. Public Web Deployment (Cloudflare Pages)

1. Compile the production Flutter Web bundle:
   ```bash
   ./scripts/build_flutter_web.sh
   ```
2. The output directory is generated at `build/web/`.
3. Verify that SPA redirects rule is present:
   ```bash
   cat build/web/_redirects
   # Expected: /* /index.html 200
   ```
4. Deploy to Cloudflare Pages:
   ```bash
   npx wrangler pages deploy build/web --project-name=truthprenuer
   ```

---

## 4. Backend API Deployment (Container)

1. Build the production container image:
   ```bash
   cd backend
   docker build -t truthprenuer-api:latest .
   ```
2. Test container healthcheck locally:
   ```bash
   docker run -d -p 8000:8000 --name test-api truthprenuer-api:latest
   sleep 3
   curl http://localhost:8000/health/live
   docker rm -f test-api
   ```
3. Deploy to container registry / Cloud Run / Fly.io:
   ```bash
   fly deploy
   # Or push to Google Cloud Artifact Registry and deploy to Cloud Run
   ```

---

## 5. Post-Deployment Verification

1. Verify public web availability:
   `curl -I https://truthprenuer.pages.dev/`
2. Verify public API liveness:
   `curl https://api.truthprenuer.com/health/live`
3. Verify admin endpoints reject external public calls:
   `curl -I https://api.truthprenuer.com/api/v1/admin/audit-logs`
   Expected response: **HTTP 403 Forbidden**
