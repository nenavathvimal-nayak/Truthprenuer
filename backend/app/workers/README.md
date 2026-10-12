# Truthprenuer Backend — Asynchronous Background Workers (`BACKEND/WORKERS/`)

## 1. Responsibility
Handles asynchronous task processing including:
- Asynchronous AI synthesis and model evaluation batches.
- Reputation score recalculations and Bayesian credibility weight updates.
- WORM audit log archival and integrity verification.

## 2. Worker Architecture
Workers utilize non-blocking async task loops designed for containerized deployment or Celery/Redis queue backends as volume scales.
