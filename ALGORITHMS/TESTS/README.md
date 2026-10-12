# Truthprenuer Algorithms — Verification & Fuzz Tests (`ALGORITHMS/TESTS/`)

## 1. Domain Responsibility
Maintains unit tests, mathematical boundary assertions, and synthetic stress fixtures for all scoring, consensus, and ranking algorithms.

## 2. Test Suites
- **AI Validation Safety & Injection Tests:** [`backend/tests/test_api_suite.py`](file:///Volumes/NAYAK/taeed_flutter_source/backend/tests/test_api_suite.py)
- **Consensus & Counter Optimistic Rollbacks:** [`test/realtime_and_offline_regression_test.dart`](file:///Volumes/NAYAK/taeed_flutter_source/test/realtime_and_offline_regression_test.dart)
- **Database Trigger Integrity Tests:** [`DATABASE/TESTS/test_db_schema.sql`](file:///Volumes/NAYAK/taeed_flutter_source/DATABASE/TESTS/test_db_schema.sql)

## 3. Running Verification
```bash
./DEVTOOLS/TESTING/run_all_tests.sh
```
