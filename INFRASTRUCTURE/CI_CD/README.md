# Truthprenuer Infrastructure — Continuous Integration & Deployment (`INFRASTRUCTURE/CI_CD/`)

## 1. Overview
Truthprenuer uses automated GitHub Actions workflows to validate client builds, backend services, security boundaries, and administrative isolation on every pull request.

## 2. Active Workflows
| Workflow File | Trigger | Purpose |
| :--- | :--- | :--- |
| [`.github/workflows/ci.yml`](../../.github/workflows/ci.yml) | `push`, `pull_request` to `main` | Runs Flutter test suite (64 tests), FastAPI pytest suite (13 tests), and Admin Panel build (`npm run build`). |
| [`.github/workflows/security.yml`](../../.github/workflows/security.yml) | `push`, `pull_request` to `main`, scheduled | Scans for hardcoded secrets, verifies loopback binding (`127.0.0.1:60135`), checks for unauthorized admin exposure. |

## 3. Workflow Invariants
1. Admin Panel builds are never deployed to public CDN or cloud storage endpoints.
2. Production builds fail closed if any test, lint, or security scan fails.
