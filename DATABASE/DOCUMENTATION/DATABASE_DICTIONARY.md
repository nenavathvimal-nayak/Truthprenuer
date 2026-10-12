# TRUTHPRENUER — DATABASE DATA DICTIONARY & RLS POLICIES

## 1. Relational Schema Overview

Truthprenuer uses a normalized relational PostgreSQL database hosted on Supabase with Row Level Security (RLS) enabled on all public tables.

### 2. Core Tables

| Table | Primary Key | Foreign Keys | Purpose | RLS Policy |
| :--- | :--- | :--- | :--- | :--- |
| `profiles` | `id` (UUID) | `auth.users(id)` | User identity, verified role, bio, suspension state | Public read, owner update |
| `startups` | `id` (UUID) | `founder_id -> profiles(id)` | Startup ventures, stage, industry | Public read, founder write |
| `validations` | `id` (UUID) | `author_id -> profiles(id)`, `startup_id` | Core validation sprint, hypothesis, target market | Public/community read, author write |
| `hypotheses` | `id` (UUID) | `validation_id -> validations(id)` | Specific testable assumptions | Author write, community read |
| `feedback` | `id` (UUID) | `validation_id`, `author_id` | Structured operator critique & evidence rating | Author write, public read |
| `evidence_items`| `id` (UUID) | `feedback_id` | Concrete artifacts (screenshots, logs, links) | Author write, public read |
| `votes` | `id` (UUID) | `validation_id`, `user_id` | Upvotes with unique user constraints | Owner manage, public read count |
| `comments` | `id` (UUID) | `validation_id`, `author_id` | Discussion comments on validation pitches | Author manage, public read |
| `conversations` | `id` (UUID) | - | Private chat threads between verified peers | Member read/write only |
| `conversation_members` | `id` (UUID) | `conversation_id`, `user_id` | Membership junction with cascade deletion | Member read only |
| `messages` | `id` (UUID) | `conversation_id`, `sender_id` | Chat messages with timestamps | Member read, sender insert |
| `connection_requests` | `id` (UUID) | `sender_id`, `receiver_id` | Professional networking invitations | Sender/receiver only |
| `notifications` | `id` (UUID) | `user_id` | Realtime in-app alerts and notifications | Recipient read/update only |
| `reports` | `id` (UUID) | `reporter_id` | User-submitted content & trust reports | Reporter insert, Admin manage |
| `admin_audit_logs` | `id` (UUID) | `actor_id` | Immutable append-only WORM audit entries | Admin insert/read, NO UPDATE/DELETE |
| `privacy_requests` | `id` (UUID) | `user_id` | GDPR / DPDP right-to-erasure and export log | Owner insert, Admin read |
| `user_reputations` | `user_id` (UUID) | `profiles(id)` | Operator credibility score and badge tracking | System manage, public read |
| `validation_scores`| `validation_id` (UUID)| `validations(id)` | Calculated algorithmic traction score | System manage, public read |

---

## 3. WORM Audit Table Invariants

The `admin_audit_logs` table enforces Write-Once-Read-Many (WORM) semantics:
- Policies only grant `INSERT` and `SELECT` to verified administrators.
- No `UPDATE` or `DELETE` policies exist. Even administrative users cannot modify or erase existing audit trails.
