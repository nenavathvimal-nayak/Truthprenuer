# DOCUMENT 11 — FRONTEND ARCHITECTURE

**Document ID:** DOC-11  
**Version:** 1.0  
**Last Updated:** 2026-08-20  
**Owner:** Frontend/Flutter Architecture  
**Status:** Draft  
**Upstream Dependencies:** DOC-02 (Master PRD), DOC-08 (UI/UX Spec), DOC-10 (Design Rules)  
**Downstream Dependents:** DOC-13 (Error Handling), DOC-16 (QA/Test Specification), DOC-21 (Release Rules)  

---

## Table of Contents

1. [Architectural Principles](#1-architectural-principles)
2. [Project Structure](#2-project-structure)
3. [State Management](#3-state-management)
4. [Routing & Navigation](#4-routing--navigation)
5. [Dependency Injection](#5-dependency-injection)
6. [Data Layer (Networking, Models, Repositories)](#6-data-layer)
7. [Local Storage & Caching](#7-local-storage--caching)
8. [Core Systems Integration (Auth, Realtime, AI, Analytics)](#8-core-systems-integration)
9. [Error Handling Foundation](#9-error-handling-foundation)
10. [Performance & Accessibility](#10-performance--accessibility)
11. [Testing Strategy](#11-testing-strategy)
12. [Environment Configuration](#12-environment-configuration)
13. [Decision Registry Extract](#13-decision-registry-extract)
14. [Document Status](#14-document-status)

---

## 1. Architectural Principles

**FA-001: Maintainability over Premature Abstraction.**
The TAEED MVP will use a Feature-First modular architecture combined with Riverpod for state management and dependency injection. We avoid clean-architecture dogmatism (e.g., unnecessary interfaces for every single repository) in favor of pragmatic, readable, and highly cohesive feature folders.

**FA-002: Single Source of Truth.**
UI components must only read state from Providers. They must not maintain local copies of backend data.

**FA-003: Predictable State.**
State mutations must happen exclusively inside `Notifier` or `AsyncNotifier` classes. UI layers trigger actions, not state changes.

---

## 2. Project Structure

**FA-004: Feature-First Structure.**

The `lib/` directory will be organized by feature, not by layer.

```text
lib/
├── core/                   # App-wide infrastructure
│   ├── theme/              # Design System (Colors, Typography, Spacing) - from DOC-09
│   ├── network/            # Dio clients, interceptors
│   ├── error/              # Global error models and handlers
│   ├── utils/              # Extensions, formatters, constants
│   └── routing/            # GoRouter configuration
├── features/               # Feature modules
│   ├── auth/               # e.g., Authentication feature
│   │   ├── domain/         # Models, Enums
│   │   ├── data/           # Repositories, Data Sources
│   │   ├── providers/      # Riverpod Providers
│   │   └── presentation/   # Screens, Widgets specific to auth
│   ├── home/
│   ├── validation/
│   └── profile/
├── shared/                 # Reusable cross-feature widgets (buttons, cards)
└── main.dart               # Entry point
```

---

## 3. State Management

**FA-005: Riverpod as the State Management Standard.**
The app will use `flutter_riverpod`.

- **Asynchronous Data:** Use `AsyncNotifierProvider` or `FutureProvider` (for read-only data).
- **Synchronous/Local State:** Use `NotifierProvider`.
- **UI Reactivity:** Screens extend `ConsumerWidget` or `ConsumerStatefulWidget`. Use `ref.watch()` in the `build` method.
- **Side Effects:** Use `ref.read()` inside callbacks (e.g., `onPressed`) to trigger mutations.

**FA-006: State Segregation.**
Transient UI state (e.g., text field input, scroll position) remains in `StatefulWidget`. Domain state (e.g., current user, feed items) belongs in Riverpod.

---

## 4. Routing & Navigation

**FA-007: GoRouter Implementation.**
All navigation relies on the `go_router` package to support deep linking and predictable state-based routing.

- **Route Definitions:** Centralized in `core/routing/app_router.dart`.
- **Navigation:** Use `context.go()` or `context.push()` with path parameters, never `Navigator.push`.
- **Guards/Redirects:** Auth state changes (login/logout) must automatically trigger router redirects via a `refreshListenable` attached to the AuthNotifier.

---

## 5. Dependency Injection

**FA-008: Riverpod for DI.**
We use Riverpod not just for state, but as our Dependency Injection container.

- **Services/Repositories:** Provided via standard `Provider<T>`.
- **Overrides:** For testing, override Providers with mock implementations. No `get_it` or `injectable` necessary.

---

## 6. Data Layer

**FA-009: Networking (Dio).**
Use `dio` for HTTP requests.
- All requests must pass through centralized interceptors for Auth (token injection), Logging, and Error transformation.

**FA-010: Models (Freezed & JSON Serializable).**
All domain models and Data Transfer Objects (DTOs) must be generated using `freezed` and `json_serializable`.
- Models must be immutable (`@freezed`).
- Avoid manual `fromJson` parsing.

**FA-011: Repositories.**
The Repository layer abstracts data sources (API vs Local).
- Repositories return `Result<T, AppError>` (using a functional package like `fpdart` or a custom Result type) rather than throwing raw Exceptions to the UI.

---

## 7. Local Storage & Caching

**FA-012: Storage Strategy.**
- **Key-Value / Tokens:** Use `flutter_secure_storage` for auth tokens and sensitive data.
- **Preferences:** Use `shared_preferences` for non-sensitive user settings (e.g., theme preference, seen onboarding).
- **Offline Cache:** For MVP, rely on Riverpod's built-in caching (keepAlive). If persistent complex offline capability is needed, evaluate `hive` or `isar` (Post-MVP).

---

## 8. Core Systems Integration

**FA-013: Authentication.**
Auth tokens are managed by an `AuthRepository`. The `AuthNotifier` exposes the current `AuthState` (Initial, Unauthenticated, Authenticated). The router listens to this state.

**FA-014: Realtime (WebSockets/SSE).**
For realtime features (e.g., live feedback, chat), establish a WebSocket connection maintained by a singleton-scoped Provider. Connection lifecycle is tied to the app lifecycle and auth state.

**FA-015: Analytics.**
Use a centralized `AnalyticsService`. UI components call `ref.read(analyticsServiceProvider).trackEvent(...)`. Do not embed vendor-specific SDK calls (e.g., Firebase, Mixpanel) directly in UI code.

**FA-016: AI Integration.**
AI requests are treated as standard async repository calls. The UI must handle specific AI states (Generating, Streaming, Complete) using appropriate skeletal loaders or typing indicators.

---

## 9. Error Handling Foundation

**FA-017: Typed Errors.**
All network and parsing exceptions must be caught in the Repository layer and transformed into a domain-specific `AppError` class (e.g., `AppError.network()`, `AppError.unauthorized()`, `AppError.server()`).

**FA-018: Global Error UI.**
When a provider yields an `AsyncError`, the UI must map it to a standardized Error Component (from DOC-09) with an actionable retry mechanism.

*(Detailed in DOC-13: Error Handling)*

---

## 10. Performance & Accessibility

**FA-019: Performance Constraints.**
- Limit the use of heavy animations; use the Design System's built-in implicit animations.
- Avoid large widget rebuilds by scoping `ref.watch` to the smallest possible widget, or using `select()`.
- Use `const` constructors everywhere possible to optimize the widget tree.

**FA-020: Accessibility (A11y).**
- Leverage `Semantics` widgets as defined in DOC-10.
- Ensure text scaling works by not hardcoding container heights.

---

## 11. Testing Strategy

**FA-021: Layered Testing.**
- **Unit Tests:** Mandatory for all Models, Data parsing, Repositories, and Notifiers (Business Logic).
- **Widget Tests:** Required for reusable Design System components (`shared/`).
- **Integration Tests:** Required for critical paths (e.g., Onboarding, Validation Flow).

*(Detailed in DOC-16: QA / Test Specification)*

---

## 12. Environment Configuration

**FA-022: Flavors / Environments.**
The app must support multiple environments: `development`, `staging`, and `production`.
- Use `--dart-define-from-file` or the `envied` package for injecting environment variables (API URLs, keys).
- Never commit `.env` files with production secrets to source control.

---

## 13. Decision Registry Extract

| ID | Decision | Reason | Status |
|---|---|---|---|
| DEC-FRONT-001 | Feature-First Folder Structure | Better cohesion and scalability than layer-first. | Approved |
| DEC-FRONT-002 | Riverpod for State & DI | Standardizes both state and DI safely; excellent testability. | Approved |
| DEC-FRONT-003 | GoRouter for Navigation | Official flutter routing package, handles deep links and auth guards well. | Approved |
| DEC-FRONT-004 | Freezed + JSON Serializable | Guarantees immutability and safe parsing with minimal boilerplate. | Approved |

---

## 14. Document Status

**STATUS:** Draft  
**REVIEW STATE:** Needs Review  

### Consistency Check Against Upstream Docs

| Check | Result |
|-------|--------|
| Architecture supports the feature catalogue (DOC-05). | ✅ |
| Supports design constraints (DOC-08, DOC-10). | ✅ |
| Adheres to MVP boundaries (No over-engineering). | ✅ |

### Next Actions

1. Proceed to Phase 4, starting with DOC-12 (Backend Architecture).
