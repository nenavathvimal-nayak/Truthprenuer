# DOCUMENT 21 — RELEASE RULES

**Document ID:** DOC-21  
**Version:** 1.0  
**Last Updated:** 2026-08-20  
**Owner:** DevOps / Release Engineering  
**Status:** Draft  
**Upstream Dependencies:** DOC-11 (Frontend), DOC-12 (Backend), DOC-16 (QA)  
**Downstream Dependents:** DOC-22 (Roadmap)  

---

## Table of Contents

1. [Release Philosophy](#1-release-philosophy)
2. [Environment Architecture](#2-environment-architecture)
3. [Branching & Versioning Strategy](#3-branching--versioning-strategy)
4. [CI/CD Pipeline Gates](#4-cicd-pipeline-gates)
5. [Database Migration Rules](#5-database-migration-rules)
6. [Feature Flags (Dark Launching)](#6-feature-flags-dark-launching)
7. [App Store Submission Rules](#7-app-store-submission-rules)
8. [Rollout & Rollback Strategy](#8-rollout--rollback-strategy)
9. [Incident Response & Hotfixes](#9-incident-response--hotfixes)
10. [Decision Registry Extract](#10-decision-registry-extract)
11. [Document Status](#11-document-status)

---

## 1. Release Philosophy

**REL-001: Done Means Shipped.**
Code sitting in a `develop` branch provides zero value. The goal is small, frequent, highly-validated releases over massive, infrequent overhauls.

**REL-002: Shift Left Quality.**
Issues must be caught locally or in CI, not by QA on a staging environment, and certainly not by users in production.

**REL-003: Decouple Deployment from Release.**
Deploying code to production is an engineering event. Revealing a feature to users is a product event. Use feature flags to separate the two.

---

## 2. Environment Architecture

**REL-004: Standard Environments.**

| Environment | Purpose | Database | Auth / Integrations |
| :--- | :--- | :--- | :--- |
| **Local** | Developer testing | Local Postgres / Docker | Sandbox / Mock |
| **Development** | Merged code preview | Shared Dev DB | Sandbox APIs |
| **Staging** | Production mirror for RC testing | Masked Prod Clone | Prod-like (Test mode) |
| **Production** | Live user traffic | Live Prod DB | Live APIs |

**REL-005: Staging Data Parity.**
The Staging database must be periodically refreshed from Production to ensure migrations and performance are tested against realistic data volume. All PII (emails, passwords) must be masked/anonymized during this sync.

---

## 3. Branching & Versioning Strategy

**REL-006: Trunk-Based Development.**
- Main branch (`main`) is always deployable.
- Developers work in short-lived feature branches (`feat/auth-update`, `fix/feed-crash`).
- Feature branches must be merged via Pull Request (PR) and deleted after merge.

**REL-007: Versioning (SemVer).**
Format: `MAJOR.MINOR.PATCH (BuildNumber)`
- **MAJOR:** Massive UX overhaul or breaking backend change requiring forced update.
- **MINOR:** New features (e.g., AI Sharpening added).
- **PATCH:** Bug fixes, performance tweaks.
- **BuildNumber:** Auto-incremented by CI on every production build.

---

## 4. CI/CD Pipeline Gates

**REL-008: PR Merge Gates.**
Before a PR can be merged to `main`, it must pass the gates defined in DOC-16 (QA-031):
- Static Analysis (`dart analyze`)
- Formatting check
- Unit & Widget Tests
- Successful dry-run build

**REL-009: Release Candidate (RC) Gates.**
When cutting an RC for staging, it must pass DOC-16 (QA-032), plus:
- Database migration dry-run succeeds on Staging DB.
- E2E tests pass against Staging environment.

---

## 5. Database Migration Rules

**REL-010: Forward-Only Migrations.**
- Migrations must be non-destructive wherever possible (e.g., add column, don't rename/drop).
- If a breaking schema change is required, it must be done in 3 phases across 3 deployments:
  1. Add new column. App writes to both, reads from old.
  2. App writes to both, reads from new.
  3. App writes to new. Drop old column.

**REL-011: Automated Execution.**
Migrations are executed automatically by the CD pipeline against the database *before* the new backend service containers are spun up.

---

## 6. Feature Flags (Dark Launching)

**REL-012: Flag Usage.**
All P0 and P1 features (as defined in DOC-05) must be wrapped in a feature flag (e.g., using LaunchDarkly, PostHog, or Firebase Remote Config).

**REL-013: Flag Lifecycle.**
1. Feature deployed to Prod with flag OFF.
2. Flag turned ON for internal team (Staging/Prod testing).
3. Flag turned ON for beta cohort (e.g., 10% of users).
4. Flag turned ON for 100%.
5. **CRITICAL:** Flag code is removed from the codebase in the next sprint to prevent technical debt.

---

## 7. App Store Submission Rules

**REL-014: App Store Guidelines Compliance.**
- **Apple:** Must support "Sign in with Apple" if other social logins are used. Must provide in-app account deletion (DOC-18).
- **Google:** Must declare AI usage and data safety correctly in the Play Console.

**REL-015: Review Rejection Handling.**
If rejected by App Store Review, DO NOT argue extensively. Modify the configuration or feature flag to disable the offending UI, get approved, and resolve the underlying policy issue out-of-band.

---

## 8. Rollout & Rollback Strategy

**REL-016: Phased Rollout.**
Mobile updates are pushed via phased rollout (e.g., 1% → 10% → 50% → 100% over 7 days) to monitor crash rates (Crashlytics/Sentry).

**REL-017: Backend Rollback.**
The backend infrastructure must support instantaneous rollback to the previous container image. Note: Database migrations generally cannot be rolled back easily, which is why REL-010 mandates non-destructive forward migrations.

**REL-018: Forced Updates.**
If a severe security vulnerability (S0) or breaking API change is released, the client must display a blocking "Update Required" screen. This requires a remote config flag (`min_required_version`) built into the MVP.

---

## 9. Incident Response & Hotfixes

**REL-019: Hotfix Protocol.**
For S0/S1 production issues (as defined in DOC-16):
1. Branch `hotfix/issue-name` directly from the current production tag.
2. Fix, test locally.
3. Bypass standard staging cycle if necessary; merge to `main` and trigger emergency release pipeline.
4. Issue post-mortem per DOC-18 (SEC-035).

---

## 10. Decision Registry Extract

| ID | Decision | Reason | Status |
|---|---|---|---|
| DEC-REL-001 | Trunk-based development | Prevents merge hell; forces smaller, testable PRs | Approved |
| DEC-REL-002 | Feature flags for all P0/P1 | Decouples deployment from product launch | Approved |
| DEC-REL-003 | Non-destructive DB migrations | Enables safe backend rollbacks | Approved |
| DEC-REL-004 | In-app "Force Update" mechanism | Required for mobile app lifecycle management | Approved |

---

## 11. Document Status

**STATUS:** Draft  
**REVIEW STATE:** Needs Review  

### Open Questions

| ID | Question | Owner |
|---|---|---|
| OQ-REL-001 | Which Feature Flag provider will we use? | Engineering |
| OQ-REL-002 | Do we have Apple Developer and Google Play Console accounts fully verified? | Ops |

### Consistency Check Against Upstream Docs

| Check | Result |
|-------|--------|
| PR gates enforce QA requirements from DOC-16. | ✅ |
| Account deletion app store rule aligns with DOC-18 privacy architecture. | ✅ |
| Incident response integrates with DOC-18. | ✅ |

### Next Actions

1. Proceed to generate DOC-22 (Roadmap).
