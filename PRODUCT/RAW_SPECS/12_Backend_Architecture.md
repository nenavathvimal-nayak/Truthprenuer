# DOCUMENT 12 — BACKEND ARCHITECTURE

**Document ID:** DOC-12  
**Version:** 1.0  
**Last Updated:** 2026-08-20  
**Owner:** Backend Architecture  
**Status:** Draft  
**Upstream Dependencies:** DOC-02 (Master PRD), DOC-05 (Feature Catalogue), DOC-11 (Frontend Architecture)  
**Downstream Dependents:** DOC-13 (Error Handling), DOC-18 (Security & Privacy), DOC-21 (Release Rules)  

---

## Table of Contents

1. [Architectural Philosophy (MVP vs. Future Scale)](#1-architectural-philosophy-mvp-vs-future-scale)
2. [API Architecture & Modules](#2-api-architecture--modules)
3. [Database & Schema Foundation](#3-database--schema-foundation)
4. [Authentication & Authorization](#4-authentication--authorization)
5. [Storage & Realtime](#5-storage--realtime)
6. [Asynchronous Processing (Queues & Workers)](#6-asynchronous-processing-queues--workers)
7. [AI Services Integration](#7-ai-services-integration)
8. [Search & Analytics](#8-search--analytics)
9. [Caching & Observability](#9-caching--observability)
10. [Data Management (Migrations & Backups)](#10-data-management-migrations--backups)
11. [Scalability Strategy](#11-scalability-strategy)
12. [Decision Registry Extract](#12-decision-registry-extract)
13. [Document Status](#13-document-status)

---

## 1. Architectural Philosophy (MVP vs. Future Scale)

**BA-001: Pragmatic MVP.**
The MVP Backend will prioritize speed of development, simplicity, and rock-solid reliability over premature microservices. We will use a **Modular Monolith** architecture. This allows for straightforward deployment and debugging while maintaining clear internal boundaries that can be split into microservices post-MVP.

**BA-002: Future Scale Transition.**
When scaling requires it (e.g., specialized AI workloads, high-throughput realtime services), specific modules (like the validation engine or AI reasoning layer) will be extracted into autonomous services.

---

## 2. API Architecture & Modules

**BA-003: RESTful JSON API.**
The primary communication protocol will be REST over HTTPS, producing and consuming JSON. This directly supports the Flutter `dio` implementation defined in DOC-11.

**BA-004: Core Modules.**
The Monolith will be logically partitioned into the following domains:
- **Identity Module:** Auth, Profiles, Sessions, RBAC.
- **Content Module:** Idea submission, Portfolios, Media metadata.
- **Validation Module:** Scoring, Feedback processing, Peer reviews.
- **Social Module:** Connections, Messaging, Feed generation.
- **AI Module:** Prompt generation, LLM orchestration, Context aggregation.
- **Analytics/Admin Module:** Internal dashboards, Reporting, Moderation.

---

## 3. Database & Schema Foundation

**BA-005: Relational Core (PostgreSQL).**
The primary datastore will be PostgreSQL. It provides the ACID compliance necessary for user identities, scores, and relational data (users -> startups -> feedback).

**BA-006: Schema Boundaries.**
- Foreign keys will be strictly enforced within the database.
- Soft Deletes (`deleted_at` timestamp) will be used for all critical entities (Users, Posts, Validations) to support compliance and recovery.

**BA-007: NoSQL / Document Store (Future Scale).**
For highly unstructured or rapidly changing schemas (e.g., complex AI context blobs), a document store (like MongoDB or Firestore) may be evaluated, but MVP will use Postgres `JSONB` columns to reduce infrastructure complexity.

---

## 4. Authentication & Authorization

**BA-008: Authentication.**
- **MVP:** JWT (JSON Web Tokens) or a managed Auth Provider (e.g., Supabase Auth, Firebase Auth, Auth0) issuing access and refresh tokens.
- **Flow:** Client sends short-lived JWT in `Authorization: Bearer` header.

**BA-009: Authorization (RBAC).**
- Role-Based Access Control will be enforced at the API route level.
- Roles: `User`, `Moderator`, `Admin`.
- Resource-level ownership checks (e.g., "Can User A edit Startup B?") must be enforced in the service layer before database mutation.

---

## 5. Storage & Realtime

**BA-010: Object Storage.**
- Images, documents, and videos will be stored in an S3-compatible object store (e.g., AWS S3, Cloudflare R2, Supabase Storage).
- The database will only store URLs or object keys.
- **Uploads:** Clients will use presigned URLs to upload directly to storage, bypassing the API to save bandwidth.

**BA-011: Realtime (WebSockets/SSE).**
- For MVP notifications and live chat, Server-Sent Events (SSE) or WebSockets will be used.
- If using a BaaS like Supabase/Firebase, rely on their native realtime channels.
- **Future Scale:** Extract realtime to a dedicated Node.js/Go service or use a managed service like Pusher/Ably to offload concurrent connection limits from the main API.

---

## 6. Asynchronous Processing (Queues & Workers)

**BA-012: Background Jobs.**
Any task taking longer than 500ms must be processed asynchronously.
- Examples: Email delivery, AI processing, heavy score recalculations, video transcoding.
- **MVP:** Use a Redis-based queue (e.g., BullMQ, Celery, or standard Postgres-based queues like River).
- **Future Scale:** Event-driven architecture using Kafka or AWS SQS/EventBridge.

---

## 7. AI Services Integration

**BA-013: AI Orchestration.**
The Backend acts as a proxy and orchestrator for external LLM APIs (OpenAI, Anthropic, Gemini).
- **NEVER** expose LLM API keys to the Flutter client.
- The Backend validates prompts, enforces rate limits, aggregates context from the DB, and handles timeouts/retries.
- For long-running AI generation, the Backend queues the job and updates the client via WebSockets or polling when complete.

---

## 8. Search & Analytics

**BA-014: Search.**
- **MVP:** PostgreSQL Full-Text Search (FTS).
- **Future Scale:** Dedicated search engine like Elasticsearch, Meilisearch, or Algolia for advanced relevancy, typo tolerance, and faceted search.

**BA-015: Analytics Pipeline.**
- The Backend will log major business events (Signups, Idea Created, Validation Completed).
- These events will be pushed to an analytics data warehouse (e.g., BigQuery, PostHog, Mixpanel) asynchronously so as not to block the main thread.

---

## 9. Caching & Observability

**BA-016: Caching.**
- **MVP:** Redis for caching frequent, heavy reads (e.g., Global Feed, User Profiles) and rate-limiting counters.
- **Invalidation:** Cache invalidation must be handled synchronously during mutation operations.

**BA-017: Observability (Logging & APM).**
- All API errors must be logged with a Request ID.
- Application Performance Monitoring (APM) (e.g., Datadog, Sentry, New Relic) must be integrated to track latency, DB query times, and unhandled exceptions.

---

## 10. Data Management (Migrations & Backups)

**BA-018: Migrations.**
- Schema changes must be managed via version-controlled migration scripts (e.g., Flyway, Prisma Migrate, Alembic).
- Migrations must be run and validated in CI/CD before deployment.

**BA-019: Backups.**
- **MVP:** Automated daily snapshots of the PostgreSQL database. Point-in-time recovery (PITR) enabled for at least 7 days.
- Disaster recovery procedures must be documented and tested quarterly.

---

## 11. Scalability Strategy

**BA-020: Vertical to Horizontal.**
1. **Phase 1 (MVP):** Vertical scaling (larger instances) for the Monolith and Database.
2. **Phase 2 (Growth):** Horizontal scaling of the API (stateless) behind a load balancer; Read-replicas for the Database.
3. **Phase 3 (Scale):** Partitioning the database; extracting heavy background workers and AI orchestration into independent microservices.

---

## 12. Decision Registry Extract

| ID | Decision | Reason | Status |
|---|---|---|---|
| DEC-BACK-001 | Modular Monolith | Balances speed of MVP development with future extraction capabilities. | Approved |
| DEC-BACK-002 | PostgreSQL as Primary DB | Required for relational integrity, JSONB support, and mature ecosystem. | Approved |
| DEC-BACK-003 | Presigned URLs for Uploads | Prevents the API from bottlenecking on large media uploads. | Approved |
| DEC-BACK-004 | Async AI Processing | LLM calls are too slow for synchronous HTTP request/response loops. | Approved |

---

## 13. Document Status

**STATUS:** Draft  
**REVIEW STATE:** Needs Review  

### Consistency Check Against Upstream Docs

| Check | Result |
|-------|--------|
| Matches frontend data requirements (DOC-11). | ✅ |
| AI rules align with backend orchestration (precursor to DOC-15). | ✅ |
| Storage handles requirements from UI/UX (DOC-08). | ✅ |

### Next Actions

1. Proceed to generate DOC-13 (Error Handling).
