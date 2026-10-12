# TRUTHPRENUER — Launch Readiness & Quality Standards
**Phase 0 Production Quality Gate**
**Status:** Verification Baseline  

---

## 1. Quality Gates & Release Standard

The product is only considered ready for production release when every quality gate across Security, Privacy, Performance, and Accessibility passes without exception.

```text
===========================================================
TRUTHPRENUER LAUNCH READINESS CHECKLIST
[x] Milestone 0: Baseline Freeze & Documentation
[ ] Milestone 1: Domain Models & Database Schema with Strict RLS
[ ] Milestone 2: Repository Layer & Mock Elimination
[ ] Milestone 3: Design System Tokens & Component Library
[ ] Milestone 4: Core Validation Loop & Detail Surface
[ ] Milestone 5: Role Workspaces, Navigation & Explore
[ ] Milestone 6: Router Consolidation, Settings & Privacy
[ ] Milestone 7: App Identity, Typography & Test Suite
===========================================================
```

---

## 2. Security & Authorization Gates

- [ ] **Object-Level RLS Enforcement**:
  - `validations`: Private validations must never be returned in queries by non-owners.
  - `evidence_items`: Private customer interviews and financial evidence must reject unauthorized read attempts.
  - `validation_responses`: Respondents cannot view or alter other users' private feedback.
- [ ] **IDOR Prevention**:
  - Direct navigation to `/validation/:id` for an unauthorized private validation must display `UnauthorizedView` without leaking title or metadata.
- [ ] **Credential Safety**:
  - Zero hardcoded production secrets in repository. `.env` loaded via `flutter_dotenv`.
- [ ] **Role Escalation Protection**:
  - Database trigger `prevent_role_update` active on `profiles` to block privilege escalation.

---

## 3. Privacy & Regulatory Compliance (DPDP / GDPR)

- [ ] **Data Minimization**:
  - Only collect fields essential for validation credibility (name, handle, role, bio, skills).
- [ ] **Consent Records**:
  - Explicit consent records logged in `consent_records` on signup.
- [ ] **Authentic Account Deletion**:
  - Triggering Delete Account in Settings executes complete deletion of user record, personal identifiers, and dependent data.
- [ ] **Data Export Capability**:
  - Users can initiate a self-serve data archive export from the Privacy Dashboard.
- [ ] **Self-Hosted Offline Fonts**:
  - Google Fonts removed from runtime network fetching to prevent user IP leakage.

---

## 4. Performance & Reliability Gates

- [ ] **Cold Startup Time**: `< 1.8s` on target mobile devices.
- [ ] **Frame Rate Stability**: Smooth 60fps scrolling on complex validation detail and explore lists.
- [ ] **Zero Unhandled Layout Overflows**: Zero `RenderFlex` exceptions across all screen resolutions (small phone to tablet).
- [ ] **Offline Resilience**: Offline state displays clear visual indicators without crashing or losing uncommitted drafts.

---

## 5. Accessibility (a11y) Standards

- [ ] **Color Contrast**: Minimum 4.5:1 contrast ratio across Midnight `#161616` and Silver `#FEF8E8` surfaces.
- [ ] **Touch Target Sizing**: Minimum 48x48dp for all interactive buttons, icon buttons, and navigation elements.
- [ ] **Screen Reader Semantics**: All interactive components wrapped in `Semantics(button: true)` with accurate accessibility labels.

---

## 6. Platform Identity & Release Packaging

- [ ] Package name updated to `truthprenuer` in `pubspec.yaml`.
- [ ] Android Application ID: `com.truthprenuer.app`.
- [ ] iOS Bundle Identifier: `com.truthprenuer.app`.
- [ ] App Label: `Truthprenuer`.
- [ ] All legacy `taeed_flutter` text purged from customer-facing strings.
