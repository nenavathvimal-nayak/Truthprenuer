# Truthprenuer CI/CD Architecture (`INFRASTRUCTURE/CI_CD/`)

## 1. Overview
Automated pipelines ensure that every pull request and release tag is strictly validated against all quality gates, static analysis checks, unit test suites, and security isolation policies.

## 2. Workflows
- **Validation Pipeline:** Linting, formatting, Flutter tests (64 passed), Backend Pytest (13 passed), Algorithm tests (4 passed).
- **Security Pipeline:** Zero secrets in code, Admin loopback isolation verified, Supabase RLS coverage verified.
- **Artifact Pipeline:** Web and mobile release artifacts built in isolation.
