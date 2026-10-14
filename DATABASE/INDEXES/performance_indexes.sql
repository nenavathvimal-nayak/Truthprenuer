-- ==============================================================================
-- TRUTHPRENUER PRODUCTION PERFORMANCE & SECURITY INDEXES
-- Optimized for High-Throughput Queries, Full-Text Search & Typo-Tolerant Trigram Lookups
-- ==============================================================================

-- Enable PostgreSQL Trigram extension for fuzzy, typo-tolerant search
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- ------------------------------------------------------------------------------
-- 1. PROFILES & USER DISCOVERY
-- ------------------------------------------------------------------------------
-- Exact normalized case-insensitive username index (B-tree)
CREATE UNIQUE INDEX IF NOT EXISTS idx_profiles_username_lower 
    ON public.profiles (LOWER(username));

-- Trigram GIN indexes for fuzzy/partial user and display name search
CREATE INDEX IF NOT EXISTS idx_profiles_full_name_trgm 
    ON public.profiles USING GIN (full_name gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_profiles_username_trgm 
    ON public.profiles USING GIN (username gin_trgm_ops);

-- User role and status index for active filtering
CREATE INDEX IF NOT EXISTS idx_profiles_role_status 
    ON public.profiles (role, is_suspended);

-- ------------------------------------------------------------------------------
-- 2. VALIDATION SPRINTS & FULL-TEXT SEARCH
-- ------------------------------------------------------------------------------
-- Multi-column visibility and status index for feed queries
CREATE INDEX IF NOT EXISTS idx_validations_author_status_created 
    ON public.validations (author_id, status, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_validations_visibility_status 
    ON public.validations (visibility, status, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_validations_stage_industry 
    ON public.validations (validation_stage, industry);

-- Full-Text Search (FTS) index for title, description, and hypothesis
CREATE INDEX IF NOT EXISTS idx_validations_fts 
    ON public.validations USING GIN (
        to_tsvector('english', coalesce(title, '') || ' ' || coalesce(description, '') || ' ' || coalesce(hypothesis, ''))
    );

-- ------------------------------------------------------------------------------
-- 3. EVIDENCE LOCKER & EVIDENCE ITEMS
-- ------------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_evidence_validation_private 
    ON public.evidence_items (validation_id, is_private, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_evidence_author 
    ON public.evidence_items (author_id);

CREATE INDEX IF NOT EXISTS idx_evidence_classification 
    ON public.evidence_items (classification, confidence_score DESC);

-- ------------------------------------------------------------------------------
-- 4. VALIDATION RESPONSES & QUESTIONS
-- ------------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_questions_validation_order 
    ON public.validation_questions (validation_id, order_index ASC);

CREATE INDEX IF NOT EXISTS idx_responses_validation_created 
    ON public.validation_responses (validation_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_responses_respondent 
    ON public.validation_responses (respondent_id);

CREATE INDEX IF NOT EXISTS idx_answers_response 
    ON public.validation_answers (response_id);

-- ------------------------------------------------------------------------------
-- 5. MESSAGING & REALTIME CHATS
-- ------------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_convo_members_user 
    ON public.conversation_members (user_id);

CREATE INDEX IF NOT EXISTS idx_messages_conversation_created 
    ON public.messages (conversation_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_messages_sender 
    ON public.messages (sender_id);

-- ------------------------------------------------------------------------------
-- 6. NOTIFICATIONS FEED
-- ------------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_notifications_recipient_unread 
    ON public.notifications (recipient_id, is_read, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_notifications_actor 
    ON public.notifications (actor_id);

-- ------------------------------------------------------------------------------
-- 7. NETWORKING & CONNECTIONS
-- ------------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_connections_users 
    ON public.connections (user_id_1, user_id_2);

CREATE INDEX IF NOT EXISTS idx_connection_requests_pair_status 
    ON public.connection_requests (sender_id, receiver_id, status);

CREATE INDEX IF NOT EXISTS idx_connection_requests_receiver_pending 
    ON public.connection_requests (receiver_id, status) 
    WHERE status = 'pending';

-- ------------------------------------------------------------------------------
-- 8. IMMUTABLE SECURITY AUDIT LOGS
-- ------------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_admin_audit_actor_action_timestamp 
    ON public.admin_audit_logs (actor_id, action, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_admin_audit_target 
    ON public.admin_audit_logs (target_type, target_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_admin_audit_created 
    ON public.admin_audit_logs (created_at DESC);
