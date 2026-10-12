# DOCUMENT 16 — QA / TEST SPECIFICATION

**Document ID:** DOC-16  
**Version:** 1.0  
**Last Updated:** 2026-08-20  
**Owner:** QA Lead + Engineering  
**Status:** Draft  
**Upstream Dependencies:** DOC-02 (Master PRD), DOC-05 (Feature Catalogue), DOC-11 (Frontend), DOC-12 (Backend), DOC-13 (Error Handling), DOC-15 (AI Rules)  
**Downstream Dependents:** DOC-21 (Release Rules)  

---

## Table of Contents

1. [QA Philosophy](#1-qa-philosophy)
2. [Test Pyramid & Coverage Targets](#2-test-pyramid--coverage-targets)
3. [Bug Severity & Priority Classification](#3-bug-severity--priority-classification)
4. [Definition of Done](#4-definition-of-done)
5. [Unit Tests](#5-unit-tests)
6. [Widget Tests](#6-widget-tests)
7. [Integration & API Tests](#7-integration--api-tests)
8. [End-to-End (E2E) Tests](#8-end-to-end-e2e-tests)
9. [Accessibility Testing](#9-accessibility-testing)
10. [Performance Testing](#10-performance-testing)
11. [Security Testing](#11-security-testing)
12. [AI Evaluation Testing](#12-ai-evaluation-testing)
13. [Offline & Realtime Testing](#13-offline--realtime-testing)
14. [Device & Platform Testing](#14-device--platform-testing)
15. [Regression & Release Gates](#15-regression--release-gates)
16. [Critical Path Test Cases](#16-critical-path-test-cases)
17. [Decision Registry Extract](#17-decision-registry-extract)
18. [Document Status](#18-document-status)

---

## 1. QA Philosophy

**QA-001: Prevent, Don't React.**
The default mode is to catch defects before they reach production. Every merge request must pass automated gates. Manual QA is the backstop, not the frontline.

**QA-002: Risk-Based Testing.**
Invest testing effort proportional to risk. The Validation Flow (core product loop) requires the deepest coverage. A cosmetic misalignment on a rarely-visited settings sub-screen does not warrant the same investment.

**QA-003: Real Devices, Real Conditions.**
Emulators are acceptable for development. Release gates must pass on at least 2 physical devices (1 iOS, 1 Android) before production deployment.

---

## 2. Test Pyramid & Coverage Targets

**QA-004: Test Pyramid.**

```
          ┌─────────────┐
          │   E2E (5%)   │  ← Slowest, most expensive. Critical paths only.
         ┌┴─────────────┴┐
         │ Integration   │  ← API contracts, feature flows.
         │    (15%)      │
        ┌┴───────────────┴┐
        │  Widget (20%)    │  ← UI component behavior.
       ┌┴─────────────────┴┐
       │   Unit (60%)       │  ← Models, logic, repositories, notifiers.
       └────────────────────┘
```

**QA-005: Coverage Targets (MVP).**

| Layer | Scope | Coverage Target |
| :--- | :--- | :--- |
| Unit | Models, Notifiers, Repositories, Utilities | ≥ 80% line coverage |
| Widget | Design System components (`shared/`), critical screens | ≥ 60% of shared components |
| Integration | API contract tests, critical multi-screen flows | All P0 features |
| E2E | Onboarding → Idea Submission → Feedback loop | 3–5 critical path scenarios |

---

## 3. Bug Severity & Priority Classification

**QA-006: Severity Definitions.**

| Severity | Definition | Examples | Response |
| :--- | :--- | :--- | :--- |
| **S0 — Critical** | App crash, data loss, security vulnerability, complete feature broken | Auth broken, data corruption, XSS/injection | Hotfix within 4 hours |
| **S1 — Major** | Core feature impaired but has workaround, or significant UX breakage | Validation submission fails intermittently, feed doesn't load on first try | Fix in current sprint |
| **S2 — Moderate** | Non-core feature broken, or minor UX issue that confuses users | Profile avatar doesn't resize correctly, notification badge count wrong | Fix in next sprint |
| **S3 — Minor** | Cosmetic, polish, or edge-case issue | Slight misalignment on landscape rotation, typo in tooltip | Backlog |

**QA-007: Priority Mapping.**

| Priority | Meaning | Maps to Features |
| :--- | :--- | :--- |
| P0 — Critical | Must work for launch | Auth, Onboarding, Idea Submission, Feedback, Feed |
| P1 — High | Must work within 2 weeks of launch | Profile, Networking, Search, Notifications |
| P2 — Medium | Important but not launch-blocking | AI features, Evidence uploads, Health Score Explainer |
| P3 — Later | Scheduled for post-MVP | Advanced analytics, Community forums |

---

## 4. Definition of Done

**QA-008: A feature is "Done" when ALL of the following are satisfied.**

| # | Criterion |
| :--- | :--- |
| 1 | Code compiles without errors or warnings on both iOS and Android targets. |
| 2 | Unit tests pass for all new/modified Models, Notifiers, and Repositories. |
| 3 | Widget tests pass for any new shared Design System component. |
| 4 | All 4 UI states implemented: Loading, Empty, Data, Error (per DOC-08 / DOC-13). |
| 5 | Error states map to the Error Taxonomy (DOC-13) with user-facing messages. |
| 6 | Analytics events fire correctly per DOC-14. Verified in analytics debug mode. |
| 7 | Accessibility: Semantics labels present on all interactive elements (DOC-10, DSR-005). |
| 8 | Code reviewed and approved by at least 1 peer engineer. |
| 9 | No S0 or S1 bugs open against the feature. |
| 10 | Manual smoke test passed on 1 physical device (pre-release gate requires 2). |

---

## 5. Unit Tests

**QA-009: Scope.**
Unit tests validate isolated business logic with no Flutter framework dependency.

| Target | What to Test | Framework |
| :--- | :--- | :--- |
| **Models (Freezed)** | Serialization/deserialization, equality, copyWith | `flutter_test` |
| **Notifiers** | State transitions, error handling, edge cases | `flutter_test` + `mocktail` |
| **Repositories** | Correct API call mapping, error transformation to `AppError` | `flutter_test` + `mocktail` |
| **Utilities** | Formatters, validators, extensions | `flutter_test` |

**QA-010: Mocking.**
Use `mocktail` (not `mockito`) for consistency. Mock at the Repository boundary. Never mock the model layer.

---

## 6. Widget Tests

**QA-011: Scope.**
Widget tests validate that Design System components render correctly and respond to interactions.

| Target | What to Test |
| :--- | :--- |
| **Buttons** | Renders label, responds to tap, shows disabled state |
| **Cards (Idea, Feedback)** | Renders data fields, truncation behavior, tap navigation |
| **Form Inputs** | Validation error display, character limits, focus behavior |
| **Error/Empty States** | Correct illustration, retry button fires callback |
| **Skeletons/Loaders** | Renders shimmer during loading state |

**QA-012: Golden Tests (Post-MVP).**
Visual regression via golden image tests will be introduced post-MVP to catch unintentional visual drift. Not required for MVP launch.

---

## 7. Integration & API Tests

**QA-013: API Contract Tests.**
Every backend endpoint consumed by the Flutter client must have a contract test that validates:
- HTTP method and path correctness
- Request body schema (sent by client)
- Response body schema (parsed by Freezed model)
- Error response schema (maps to AppError)

**QA-014: Multi-Step Flow Tests.**
Test multi-screen interactions using Riverpod Provider overrides to inject mock data.

| Flow | Minimum Scenarios |
| :--- | :--- |
| Onboarding → Sign Up → Profile Setup | Happy path + validation errors |
| Idea Submission → Feed Appearance | Happy path + offline + server error |
| Feedback Submission → Score Update | Happy path + rate limit + AI scorer failure |

---

## 8. End-to-End (E2E) Tests

**QA-015: E2E Scope.**
E2E tests run the full app against a staging backend. They are expensive and slow. Limit to critical user journeys.

**QA-016: MVP Critical E2E Scenarios.**

| E2E ID | Scenario | Priority |
| :--- | :--- | :--- |
| E2E-001 | New user: Onboard → Create Account → Complete Profile → Submit First Idea | P0 |
| E2E-002 | Reviewer: Open Feed → View Idea → Submit Feedback → Author Receives Notification | P0 |
| E2E-003 | Auth: Login → Session Expiry → Auto-Redirect to Login → Re-Login | P0 |
| E2E-004 | AI: Submit Idea → Tap Sharpen → Accept AI Suggestion → Submit | P1 |
| E2E-005 | Offline: Go Offline → Attempt Submit → See Offline Error → Reconnect → Retry Succeeds | P1 |

**QA-017: E2E Framework.**
Use `integration_test` (Flutter's built-in package) targeting real emulators or physical devices. Patrol package may be evaluated for more reliable native interaction testing.

---

## 9. Accessibility Testing

**QA-018: Automated Checks.**
Run Flutter's `Semantics` debugger and `AccessibilityGuideline` tests in widget tests to verify:
- All interactive elements have semantic labels (DOC-10, DSR-005-A/B).
- Touch targets meet 44×44 minimum (DOC-10, DSR-005-C).
- Text contrast ratios meet WCAG 2.1 AA (DOC-10, DSR-004-C).

**QA-019: Manual Screen Reader Pass.**
Before each release, perform a manual navigation pass using:
- **iOS:** VoiceOver
- **Android:** TalkBack

Focus on: Onboarding, Feed, Idea Submission, and Profile screens.

---

## 10. Performance Testing

**QA-020: Key Performance Indicators.**

| Metric | Target | Measurement |
| :--- | :--- | :--- |
| App Cold Start (Time to Interactive) | < 3 seconds | Measured on mid-range Android device |
| Feed First Contentful Paint | < 1.5 seconds | With cached auth token |
| Frame Rate (Normal Scroll) | ≥ 55 FPS | Flutter Performance Overlay |
| Frame Rate (Animated Transitions) | ≥ 50 FPS | Flutter Performance Overlay |
| APK Size | < 30 MB (compressed) | `flutter build apk --release` |
| Jank (Dropped Frames) | < 3% of total frames | Flutter DevTools |

**QA-021: Profiling Cadence.**
Performance profiling must be run before each release candidate using Flutter DevTools on a mid-range Android device (e.g., Pixel 5a or equivalent).

---

## 11. Security Testing

**QA-022: Automated Security Checks.**
- Static Application Security Testing (SAST) via `dart analyze` and custom lint rules to detect common issues (hardcoded secrets, insecure storage usage).
- Dependency vulnerability scanning via `dart pub outdated` and tools like Snyk or GitHub Dependabot.

**QA-023: Manual Security Review (Pre-Launch).**
Before MVP launch, a manual security review must cover:
- Token storage (must use `flutter_secure_storage`, not `shared_preferences`).
- API key exposure (no keys in client-side code — enforced by DOC-12, BA-013).
- Certificate pinning evaluation (Post-MVP, but flag if absent).
- Deep link injection testing.

*(Detailed security requirements in DOC-18)*

---

## 12. AI Evaluation Testing

**QA-024: Prompt Regression Tests.**
For each AI feature (DOC-15), maintain a test suite of ≥ 20 input/expected-output pairs. Run these against the AI endpoint before deploying any prompt or model version change.

**QA-025: AI Quality Metrics.**
Monitor in production (per DOC-14 and DOC-15):
- `ai_response_accepted` rate ≥ 60%
- `ai_response_rejected` rate < 40% (trigger review if exceeded — AI-028)
- Latency within SLA (AI-029)

**QA-026: Adversarial Prompt Testing.**
Before launching any user-facing AI feature, run ≥ 10 prompt injection test cases to validate defense mechanisms (DOC-15, AI-020/021).

---

## 13. Offline & Realtime Testing

**QA-027: Offline Scenarios.**

| Scenario | Expected Behavior |
| :--- | :--- |
| App opens with no connection | Show offline screen with cached data if available |
| Connection lost mid-submission | Show error toast; preserve form state for retry |
| Connection restored | Auto-reconnect WebSocket; sync pending actions |

**QA-028: Realtime Testing.**
- WebSocket disconnect: Verify silent reconnection with exponential backoff (DOC-13, ERR SYS_WS_DISCONNECT).
- Concurrent message delivery: Verify messages arrive in order in chat screens.

---

## 14. Device & Platform Testing

**QA-029: Minimum Device Matrix (MVP).**

| Platform | Minimum OS | Test Devices |
| :--- | :--- | :--- |
| **iOS** | iOS 15+ | iPhone 12 or newer (physical) |
| **Android** | Android 10 (API 29)+ | Pixel 5a or equivalent mid-range (physical) |

**QA-030: Screen Size Testing.**
Test on:
- Small: iPhone SE 3 / Pixel 4a (≤ 5.5")
- Standard: iPhone 14 / Pixel 7 (~6.1")
- Large: iPhone 15 Pro Max / Samsung Galaxy S24 Ultra (~6.7")

Landscape orientation is **not** required for MVP but layout must not break if rotated.

---

## 15. Regression & Release Gates

**QA-031: CI Pipeline Gates.**
Every merge to `main` must pass:

| Gate | Tool | Blocking? |
| :--- | :--- | :--- |
| Static Analysis | `dart analyze` (zero warnings) | Yes |
| Formatting | `dart format --set-exit-if-changed .` | Yes |
| Unit Tests | `flutter test` | Yes |
| Widget Tests | `flutter test` (widget test directory) | Yes |
| Build (iOS) | `flutter build ios --release --no-codesign` | Yes |
| Build (Android) | `flutter build apk --release` | Yes |

**QA-032: Release Candidate Gate.**
Before tagging a release candidate:

| Gate | Requirement |
| :--- | :--- |
| All CI gates pass | Mandatory |
| Integration tests pass | All P0 flows |
| E2E critical paths pass | E2E-001, E2E-002, E2E-003 |
| Manual QA smoke test | Passed on 1 iOS + 1 Android physical device |
| No open S0 or S1 bugs | Mandatory |
| Performance metrics within target | QA-020 thresholds met |
| Security checklist reviewed | QA-023 |
| Analytics events verified | Debug mode validation |

---

## 16. Critical Path Test Cases

**QA-033: Traceability to Features.**

| Test Case ID | Feature (DOC-05) | Flow (DOC-06) | Screens (DOC-07) | Error (DOC-13) | Analytics (DOC-14) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| TC-001 | Auth / Signup | Onboarding Flow | Splash, Onboarding, Login, Signup | SEC_401, VAL_400 | AN-ACT-001 to 004 |
| TC-002 | Idea Submission | Submission Flow | Idea Form, Submission Confirmation | VAL_400, NET_001, NET_002 | AN-VAL-001 to 003 |
| TC-003 | Peer Feedback | Feedback Flow | Idea Detail, Feedback Form | VAL_429, SYS_500 | AN-VAL-004 to 006 |
| TC-004 | Health Score View | Score View Flow | Startup Dashboard | AI_503 | AN-VAL-007 |
| TC-005 | AI Sharpening | AI Interaction Flow | Idea Form (AI panel) | AI_503, NET_002 | AN-AI-001 to 005 |

---

## 17. Decision Registry Extract

| ID | Decision | Reason | Status |
|---|---|---|---|
| DEC-QA-001 | Test Pyramid (60/20/15/5 split) | Maximize coverage at lowest cost; E2E only for critical paths | Approved |
| DEC-QA-002 | mocktail over mockito | Code-generation-free mocking; simpler setup with Riverpod | Approved |
| DEC-QA-003 | Physical device release gate | Emulators miss real-world rendering, gesture, and performance issues | Approved |
| DEC-QA-004 | Golden tests Post-MVP | Adds CI complexity; not worth the trade-off before product-market fit | Approved |

---

## 18. Document Status

**STATUS:** Draft  
**REVIEW STATE:** Needs Review  

### Open Questions

| ID | Question | Owner |
|---|---|---|
| OQ-QA-001 | Which CI provider? (GitHub Actions, Codemagic, Bitrise) | Engineering |
| OQ-QA-002 | Should we use Patrol for E2E or stick with `integration_test`? | Engineering |
| OQ-QA-003 | Exact physical test devices available to the team? | QA / Ops |

### Consistency Check Against Upstream Docs

| Check | Result |
|-------|--------|
| Test cases cover all P0 features from DOC-05. | ✅ |
| Error scenarios map to DOC-13 error codes. | ✅ |
| Analytics verification references DOC-14 event IDs. | ✅ |
| AI evaluation aligns with DOC-15 thresholds (AI-026 to AI-028). | ✅ |
| Accessibility checks enforce DOC-10 rules (DSR-005). | ✅ |
| Definition of Done enforces DOC-08 (4 UI states). | ✅ |

### Next Actions

1. Proceed to generate DOC-17 (Community & Moderation).
