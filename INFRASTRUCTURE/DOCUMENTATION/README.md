# Truthprenuer Infrastructure — Architecture & Operations (`INFRASTRUCTURE/DOCUMENTATION/`)

## 1. Production Architecture
- **Web Client Hosting:** Cloudflare Pages edge delivery with global CDN caching.
- **Backend API Hosting:** Stateless container deployment on Fly.io / Google Cloud Run (`backend/fly.toml`).
- **Database & Storage:** Managed Supabase PostgreSQL with automated point-in-time recovery (PITR) and encrypted storage buckets.
- **Admin Console:** Distributed only to trusted operator workstations via secure local repository clone and executed strictly on loopback `127.0.0.1:60135`.

## 2. Security Runbooks
- [Deployment Architecture](file:///Volumes/NAYAK/taeed_flutter_source/PRODUCT/ARCHITECTURE/DEPLOYMENT_ARCHITECTURE.md)
- [Admin Isolation Specification](file:///Volumes/NAYAK/taeed_flutter_source/PRODUCT/SECURITY/ADMIN_ISOLATION.md)
- [Threat Model](file:///Volumes/NAYAK/taeed_flutter_source/PRODUCT/SECURITY/THREAT_MODEL.md)
