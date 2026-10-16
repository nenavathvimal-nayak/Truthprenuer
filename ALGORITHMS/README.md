# Truthprenuer Algorithms & Verification Engine (`ALGORITHMS/`)

## 1. Overview
The `ALGORITHMS/` subsystem defines the mathematical, probabilistic, and statistical models governing truth verification, reputation weighting, anti-sybil consensus, and content ranking across Truthprenuer.

## 2. Module Index

| Module | Core Logic | Implementation Reference |
| :--- | :--- | :--- |
| [`ALGORITHMS/VALIDATION/`](../ALGORITHMS/VALIDATION) | Bayesian consensus probability aggregation | [`backend/app/services/`](../backend/app/services) & [`lib/core/`](../USERS/lib/core) |
| [`ALGORITHMS/SCORING/`](../ALGORITHMS/SCORING) | Multi-factor validator reputation scoring | [`DATABASE/FUNCTIONS/stored_procedures.sql`](../DATABASE/FUNCTIONS/stored_procedures.sql) |
| [`ALGORITHMS/RECOMMENDATIONS/`](../ALGORITHMS/RECOMMENDATIONS) | Proof-of-evidence feed ranking algorithm | [`lib/repositories/`](../USERS/lib/repositories) |
| [`ALGORITHMS/ANALYTICS/`](../ALGORITHMS/ANALYTICS) | Real-time consensus velocity telemetry | [`admin_panel/src/components/visuals/`](../ADMIN/src/components/visuals) |
| [`ALGORITHMS/SEARCH/`](../ALGORITHMS/SEARCH) | Semantic claim matching and duplicate detection | [`backend/app/api/v1/ai.py`](../backend/app/api/v1/ai.py) |
| [`ALGORITHMS/TESTS/`](../ALGORITHMS/TESTS) | Mathematical verification tests and benchmarks | [`backend/tests/`](../backend/tests) |

## 3. Core Principles
1. **Mathematical Objectivity:** Claims are evaluated using empirical evidence weights, not raw popularity or engagement loops.
2. **Anti-Sybil Resistance:** New or unverified accounts cannot collude to swing validation verdicts without building audited reputation history.
3. **Deterministic Verification:** Given the same set of evidence and validator reputation states, consensus outputs are 100% reproducible.
