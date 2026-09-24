# TRUTHPRENUER — Master Product & Technical Audit
**Phase 0 Baseline Freeze Deliverable**
**Date:** September 23, 2026  
**Git Branch:** `main`  
**Git Commit:** `24f2c32e6951cd857015531330dc18a558f330f3`  

---

## 1. Executive Summary

This audit establishes the immutable technical and product baseline of the **TRUTHPRENUER** application prior to the execution of the deep product simplification and productionization program.

The application is built using Flutter (Dart 3.3+), Riverpod for state management, GoRouter for navigation, and Supabase for backend authentication, database, and storage. The stated product purpose is:
> **Turn assumptions into evidence-backed decisions through structured validation and real user feedback, with AI helping organize—not replace—human judgment.**

---

## 2. Technical Baseline & Dependency Stack

### 2.1 Dependencies (`pubspec.yaml`)
| Dependency | Version | Purpose | Audit Assessment |
| :--- | :--- | :--- | :--- |
| `flutter` | SDK | Core framework | Current |
| `flutter_riverpod` | `^2.5.1` | State management | Production grade |
| `go_router` | `^14.0.1` | Declarative routing | Requires route deduplication |
| `uuid` | `^4.3.3` | ID generation | Approved |
| `cupertino_icons` | `^1.0.6` | System iconography | Approved |
| `shared_preferences` | `^2.2.3` | Local key-value store | Used for theme/session persistence |
| `google_fonts` | `^6.1.0` | Typography | **FLAGGED**: Downloads fonts at runtime. Must replace with bundled offline fonts |
| `supabase_flutter` | `^2.17.2` | Backend & Auth | Core production database client |
| `flutter_dotenv` | `^6.0.1` | Environment variables | Approved |

### 2.2 Dev Dependencies & Tooling
- `flutter_test`: SDK
- `flutter_lints`: `^3.0.0`
- Target SDK: `>=3.3.0 <4.0.0`

---

## 3. Architecture & File Inventory Baseline

### 3.1 Directory Structure
```text
lib/
├── components/          # 15 reusable UI widgets
├── design_system/       # AppPalette, AppThemeColors, Typography, Spacing
├── models/              # Domain models (models.dart, startup_health_models.dart, role_provider.dart)
├── repositories/        # App providers, validation repository, privacy repository
├── router/              # app_router.dart (GoRouter)
├── utils/               # HapticManager, time ago extensions
├── views/
│   ├── auth/            # Login, Signup, OTP, ForgotPassword, ProfileSetupWizard
│   ├── explore/         # Explore discovery feed
│   ├── home/            # Role containers
│   ├── main/            # DashboardView, MainTabView, SearchOverlay, Notifications
│   ├── messaging/       # ChatsListView, ChatRoomView
│   ├── network/         # NetworkView, TopValidatorsLeaderboard
│   ├── onboarding/      # SplashView, OnboardingView, ActionSelectionView
│   ├── profile/         # ProfileView, EditProfileView, SettingsView, PrivacyDashboardView
│   └── validation/      # ValidationWizard, ValidationDetail, StructuredFeedback, EvidenceLocker, AIValidation
└── main.dart            # App entrypoint & Supabase bootstrap
```

### 3.2 Active Routes Inventory (`lib/router/app_router.dart`)
1. `/splash` → `SplashView`
2. `/onboarding` → `OnboardingView`
3. `/action` → `ActionSelectionView`
4. `/auth` → `LoginView`
5. `/signup` → `SignupView`
6. `/otp` → `OTPVerificationView`
7. `/forgot-password` → `ForgotPasswordView`
8. `/profile-setup` → `ProfileSetupWizardView`
9. `/` → `MainTabView(initialIndex: 0)`
10. `/explore` → `MainTabView(initialIndex: 1)`
11. `/validate` → `MainTabView(initialIndex: 2)`
12. `/network` → `MainTabView(initialIndex: 3)`
13. `/profile` → `MainTabView(initialIndex: 4)`
14. `/search` → `SearchOverlayView`
15. `/validation-wizard` → `ValidationWizardView`
16. `/notifications` → `NotificationsView`
17. `/chats` → `ChatsListView`
18. `/chat-room` → `ChatRoomView`
19. `/team-management` → `TeamManagementView`
20. `/settings` → `SettingsView`
21. `/change-password` → `ChangePasswordView`
22. `/top-validators` & `/leaderboard` → `TopValidatorsLeaderboardView`
23. `/startup-health` → `StartupHealthDashboardView`
24. `/evidence-locker` → `EvidenceLockerView`
25. `/dashboard` → `DashboardView`
26. `/validation-detail/:id` & `/validation-detail` → `ValidationDetailView`
27. `/notification-preferences` → `NotificationPreferencesView`
28. `/edit-profile` → `EditProfileView`
29. `/user-profile` → `UserProfileView`
30. `/structured-feedback` → `StructuredFeedbackView`
31. `/ai-validation` → `AIValidationView`

---

## 4. Supabase Schema & Database Baseline (`supabase/schema.sql`)

### 4.1 Existing Tables
1. `profiles`: `id`, `username`, `full_name`, `avatar_url`, `bio`, `role`, `created_at`, `updated_at`.
2. `validations`: `id`, `author_id`, `title`, `description`, `hypothesis`, `target_audience`, `industry`, `status`, `upvotes`, `created_at`, `updated_at`.
3. `validation_questions`: `id`, `validation_id`, `question_text`, `question_type`, `options`, `created_at`.
4. `evidence_items`: `id`, `validation_id`, `title`, `type`, `summary`, `confidence_score`, `key_insight`, `tags`, `created_at`.
5. `consent_records`: `id`, `user_id`, `purpose`, `consent_version`, `status`, `granted_at`, `withdrawn_at`, `source`.
6. `access_logs`: `id`, `actor_id`, `target_user_id`, `action`, `resource_accessed`, `context`, `created_at`.

### 4.2 Missing Production Tables
The current database lacks tables for:
- `validation_responses` & `validation_answers`
- `ai_analyses` & `ai_analysis_versions`
- `decisions` & `experiments`
- `connections` & `connection_requests`
- `conversations`, `conversation_members`, `messages`
- `notifications`
- `reports` & `blocks`
- `privacy_requests`

### 4.3 RLS Posture Assessment
- **CRITICAL FLAW**: `validations` and `evidence_items` currently employ `USING (true)` for `SELECT`, making private founder hypotheses and sensitive customer interview evidence publicly readable by any authenticated user.
- **REMEDIATION REQUIRED**: Object-level authorization enforcing `visibility IN ('public', 'community')` for general reads, and owner-only checks for `private` or `invite_only` records.

---

## 5. Technical Debt & Anti-Pattern Inventory

| Issue | Severity | Location | Remediation |
| :--- | :--- | :--- | :--- |
| **`MockDataStore` Infiltration** | High | 11+ views (`notifications_view.dart`, `chats_list_view.dart`, `structured_feedback_view.dart`, `edit_profile_view.dart`, etc.) | Delete `mock_data_store_provider.dart` and bind all views to Riverpod repositories. |
| **Untyped Domain Fields** | High | `ValidationRequest.aiReport` (dynamic), `ValidationRequest.startupHealth` (dynamic) in `models.dart` | Strongly type with `AIValidationReport` and `StartupHealth`. |
| **Duplicate Validation Routes** | Medium | `/validation-detail/:id` and `/validation-detail` in `app_router.dart` | Consolidate into `/validation/:id` with unified deep-link and state passing. |
| **Duplicate Home View Files** | Medium | `founder_home_view.dart`, `investor_home_view.dart`, `professional_home_view.dart`, `creator_home_view.dart`, `student_home_view.dart` | Dead code since `dashboard_view.dart` embeds all 4 surfaces. Delete redundant files. |
| **Runtime Font Dependency** | Medium | `google_fonts` in `pubspec.yaml` | Add local font assets in `assets/fonts/` to ensure offline capability and privacy compliance. |
| **Starter Identity Residue** | Medium | `taeed_flutter` in `pubspec.yaml`, `android/app/build.gradle`, `ios/` | Rename to `truthprenuer` and `com.truthprenuer.app`. |
| **Missing Test Suite** | High | `test/` directory is empty | Create comprehensive unit and widget tests for models, repositories, and critical UI flows. |

---

## 6. Baseline Verification Checkpoint

- **Current Build Status**: Compiles and runs cleanly in iOS Simulator (`A0948044-C0CD-4169-923B-9C29A1B83657`).
- **RenderFlex Overflows**: Zero layout overflows on buttons or cards.
- **Static Analysis**: All deprecation warnings for `withOpacity` resolved with `withValues(alpha:)`.
