# Truthprenuer Universal Client Test Suite (`USERS/TESTS/`)

## 1. Overview
The customer-facing universal application test suite is codified under the top-level [`test/`](file:///Volumes/NAYAK/taeed_flutter_source/test/) directory to comply with standard Flutter test discovery invariants.

## 2. Test Architecture
| Test Category | Test File | Primary Coverage |
| :--- | :--- | :--- |
| **P1: Optimistic Rollbacks & Counters** | [`test/realtime_and_offline_regression_test.dart`](file:///Volumes/NAYAK/taeed_flutter_source/test/realtime_and_offline_regression_test.dart) | Distributed counter increments, offline queuing, auto-reconvergence |
| **P2: Offline Detection & Banner** | [`test/realtime_and_offline_regression_test.dart`](file:///Volumes/NAYAK/taeed_flutter_source/test/realtime_and_offline_regression_test.dart) | AdaptiveAppShell network loss detection, assistive live semantics |
| **P3: Assistive Live-Region Semantics** | [`test/realtime_and_offline_regression_test.dart`](file:///Volumes/NAYAK/taeed_flutter_source/test/realtime_and_offline_regression_test.dart) | Screen reader live announcements for upvotes and endorsements |
| **Authentication & Authorization** | [`test/auth_authorization_flow_test.dart`](file:///Volumes/NAYAK/taeed_flutter_source/test/auth_authorization_flow_test.dart) | Signup validation, password mismatch checks, OTP verification |
| **Admin Route Isolation & Telemetry** | [`test/admin_and_realtime_test.dart`](file:///Volumes/NAYAK/taeed_flutter_source/test/admin_and_realtime_test.dart) | Non-admin client access blocks, role notifier state |
| **Universal State Views** | [`test/universal_state_view_test.dart`](file:///Volumes/NAYAK/taeed_flutter_source/test/universal_state_view_test.dart) | Empty, loading, and error state widget renderings |

## 3. Running Client Tests
```bash
flutter test
```
All 64 tests pass with zero regressions.
