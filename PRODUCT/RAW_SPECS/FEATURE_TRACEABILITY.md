# TRUTHPRENUER — Feature & Action Traceability Matrix
**Phase 0 End-to-End Architectural Traceability**
**Status:** Verification Baseline  

---

## 1. Traceability Standard

Every button, action, and interactive element in TRUTHPRENUER must follow a strict, auditable path from user interaction to backend security enforcement:
```text
UI ACTION / CTA 
→ STATE PROVIDER (Riverpod)
→ REPOSITORY METHOD
→ SUPABASE API / CLIENT
→ DATABASE TABLE
→ ROW LEVEL SECURITY (RLS) POLICY
```

No screen may bypass repositories or invoke raw Supabase operations directly.

---

## 2. Core Traceability Matrix

| UI Action / CTA | Screen Source | State Provider | Repository Method | Supabase Table | RLS Enforcement Rule |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Publish Validation** | `ValidationWizardView` | `validationsProvider` | `ValidationRepository.createValidation()` | `validations` | `INSERT WITH CHECK (auth.uid() = author_id)` |
| **Save Draft** | `ValidationWizardView` | `validationDraftsProvider` | `ValidationRepository.saveDraft()` | `validations` | `INSERT / UPDATE (auth.uid() = author_id)` |
| **Submit Feedback** | `StructuredFeedbackView` | `feedbackSubmissionProvider` | `FeedbackRepository.submitResponse()` | `validation_responses`, `validation_answers` | `INSERT WITH CHECK (auth.uid() = respondent_id)` + duplicate check |
| **Add Evidence Item** | `EvidenceLockerView` | `evidenceListProvider` | `EvidenceRepository.addEvidence()` | `evidence_items` | `INSERT WITH CHECK (EXISTS validation owner = auth.uid())` |
| **Request AI Synthesis** | `AIValidationView` | `aiAnalysisProvider` | `AIRepository.generateAnalysis()` | `ai_analyses` | `SELECT / INSERT (EXISTS validation owner = auth.uid())` |
| **Record Decision** | `ValidationDetailView` | `decisionProvider` | `DecisionRepository.recordDecision()` | `decisions` | `INSERT WITH CHECK (auth.uid() = author_id)` |
| **Start Experiment** | `ValidationDetailView` | `experimentProvider` | `DecisionRepository.createExperiment()` | `experiments` | `INSERT WITH CHECK (auth.uid() = author_id)` |
| **Send Connection Request**| `NetworkView` | `networkStateProvider` | `NetworkRepository.sendRequest()` | `connection_requests` | `INSERT WITH CHECK (auth.uid() = sender_id)` |
| **Accept Connection** | `NetworkView` | `networkStateProvider` | `NetworkRepository.acceptRequest()` | `connections` | `INSERT / UPDATE (auth.uid() = receiver_id)` |
| **Send Direct Message** | `ChatRoomView` | `activeChatProvider` | `MessagingRepository.sendMessage()` | `messages` | `INSERT WITH CHECK (EXISTS conversation_member = auth.uid())` |
| **Update Profile** | `EditProfileView` | `currentUserProvider` | `ProfileRepository.updateProfile()` | `profiles` | `UPDATE USING (auth.uid() = id)` |
| **Upload Avatar** | `AvatarPickerModal` | `currentUserProvider` | `ProfileRepository.uploadAvatar()` | Storage: `avatars` bucket | `INSERT / UPDATE (storage.foldername = auth.uid())` |
| **Submit Content Report**| `ReportModal` | `trustSafetyProvider` | `ModerationRepository.submitReport()` | `reports` | `INSERT WITH CHECK (auth.uid() = reporter_id)` |
| **Block User** | `UserProfileView` | `trustSafetyProvider` | `ModerationRepository.blockUser()` | `blocks` | `INSERT WITH CHECK (auth.uid() = blocker_id)` |
| **Export Data** | `PrivacyDashboardView` | `privacyRequestProvider` | `PrivacyRepository.requestExport()` | `privacy_requests` | `INSERT WITH CHECK (auth.uid() = user_id)` |
| **Delete Account** | `SettingsView` | `authProvider` | `AuthRepository.deleteAccount()` | `auth.users` | `DELETE USING (auth.uid() = id)` with CASCADE |

---

## 3. Failure & Recovery Circuit

For every traced action:
1. **Network Failure**: Dispatches `NETWORK_ERROR` through Riverpod; button returns from loading state to interactive state with a snackbar and retry handle.
2. **Permission Denied**: Catches Supabase RLS error `42501`; renders `PermissionDeniedView` without leaking private record metadata.
3. **Draft Safety**: If validation creation fails on publish, the local draft remains persisted in SharedPreferences / local cache to prevent data loss.
