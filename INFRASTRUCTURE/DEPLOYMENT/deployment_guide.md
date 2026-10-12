# Truthprenuer Production Deployment Blueprint (`INFRASTRUCTURE/DEPLOYMENT/`)

## 1. Public Web Client Deployment (Cloudflare Pages)
```bash
# Build optimized release bundle
flutter build web --release --pwa-strategy offline-first

# Deploy to Cloudflare Pages
npx wrangler pages deploy build/web --project-name=truthprenuer --commit-dirty=true
```

## 2. Authoritative Backend Deployment (Docker / Cloud Run)
```bash
cd backend

# Build minimal production container
docker build -t truthprenuer-backend:v1.0.0 -f Dockerfile .

# Run container with resource limits and health checks
docker run -d \
  --name truthprenuer-api \
  --restart always \
  -p 8000:8000 \
  --env-file .env.production \
  --read-only \
  --cap-drop ALL \
  truthprenuer-backend:v1.0.0
```

## 3. Local Admin Console (Strict Loopback Only)
The Admin Console is **NEVER** deployed to Cloudflare Pages, Vercel, or any cloud environment:
```bash
# Run locally only
./ADMIN/RUN_LOCAL/start_admin_60135.sh
```
Console starts exclusively on `http://127.0.0.1:60135`.
