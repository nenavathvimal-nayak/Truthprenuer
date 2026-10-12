# TRUTHPRENUER — CONTRIBUTING GUIDELINES

Thank you for contributing to Truthprenuer! We maintain strict engineering standards, reproducible tests, and zero-trust security invariants across the codebase.

---

## 1. Development Workflow

1. Clone or branch from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```
2. Adhere to code conventions:
   - Dart/Flutter: Follow `analysis_options.yaml`, format with `dart format`.
   - Python/FastAPI: Follow PEP 8 and Pydantic v2 schemas.
   - React/TypeScript: Type-check with `tsc -b`, lint with `oxlint`.

---

## 2. Testing Requirements

Every change must include automated tests:
- UI widgets and state changes: Add unit/widget tests under `test/`.
- API endpoints and services: Add pytest cases under `backend/tests/`.
- Admin changes: Must pass `tsc -b && vite build`.

Before submitting a Pull Request, run the master test suite:
```bash
./DEVTOOLS/TESTING/run_all_tests.sh
```

---

## 3. Security Rules (Non-Negotiable)

1. Never commit real credentials, API keys, or JWT secrets.
2. Never expose administrative capabilities to public client builds or external networks.
3. Preserve tamper-evident WORM auditing for all sensitive operations.
