# Truthprenuer Infrastructure & Cloud Topology (`INFRASTRUCTURE/DOCUMENTATION/`)

## 1. Cloud Architecture Overview
```mermaid
graph TD
    UserClient[Public Client Apps: Web, Android, iOS] --> CloudLB[Cloud Load Balancer / CDN]
    CloudLB --> FastAPI[FastAPI Backend Service - Cloud Run]
    FastAPI --> Supabase[(Supabase Managed Postgres + Auth + RLS)]
    FastAPI --> Redis[(Redis Cache & Rate Limiting)]
    FastAPI --> Gemini[Google Gemini AI API]
    
    subgraph Zero-Trust Local Isolation
        AdminConsole[Admin Web Console] --> LocalOnly[127.0.0.1:60135 ONLY]
        LocalOnly -.->|Loopback Origin| FastAPI
    end
```

## 2. Security Boundaries
- **Public Domain:** User apps communicate over TLS 1.3 to the backend API.
- **Admin Domain:** Strict localhost loopback binding (`127.0.0.1:60135`). Zero external reachability.
- **Database Domain:** Supabase PostgreSQL with 100% Row Level Security (RLS) enforcement.
