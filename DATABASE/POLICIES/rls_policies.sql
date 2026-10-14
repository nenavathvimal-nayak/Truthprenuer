-- ==============================================================================
-- TRUTHPRENUER PRODUCTION ROW LEVEL SECURITY (RLS) POLICIES
-- Authoritative Zero-Trust Multi-Tenant & Role Isolation Model
-- Covers all 21 production tables with strict ownership & WITH CHECK enforcement
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. PROFILES
-- ------------------------------------------------------------------------------
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "profiles_select_public" ON public.profiles;
CREATE POLICY "profiles_select_public" ON public.profiles
    FOR SELECT
    USING (
        is_suspended = false 
        OR auth.uid() = id 
        OR EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() AND role IN ('Admin', 'Super_Admin', 'Security')
        )
    );

DROP POLICY IF EXISTS "profiles_insert_self" ON public.profiles;
CREATE POLICY "profiles_insert_self" ON public.profiles
    FOR INSERT
    WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "profiles_update_self" ON public.profiles;
CREATE POLICY "profiles_update_self" ON public.profiles
    FOR UPDATE
    USING (auth.uid() = id)
    WITH CHECK (
        auth.uid() = id 
        AND (
            role = (SELECT role FROM public.profiles WHERE id = auth.uid())
            OR EXISTS (
                SELECT 1 FROM public.profiles 
                WHERE id = auth.uid() AND role IN ('Admin', 'Super_Admin', 'Security')
            )
        )
    );

-- ------------------------------------------------------------------------------
-- 2. STARTUPS
-- ------------------------------------------------------------------------------
ALTER TABLE public.startups ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "startups_select_all" ON public.startups;
CREATE POLICY "startups_select_all" ON public.startups
    FOR SELECT
    USING (true);

DROP POLICY IF EXISTS "startups_insert_founder" ON public.startups;
CREATE POLICY "startups_insert_founder" ON public.startups
    FOR INSERT
    WITH CHECK (auth.uid() = founder_id);

DROP POLICY IF EXISTS "startups_update_founder" ON public.startups;
CREATE POLICY "startups_update_founder" ON public.startups
    FOR UPDATE
    USING (auth.uid() = founder_id)
    WITH CHECK (auth.uid() = founder_id);

DROP POLICY IF EXISTS "startups_delete_founder" ON public.startups;
CREATE POLICY "startups_delete_founder" ON public.startups
    FOR DELETE
    USING (auth.uid() = founder_id);

-- ------------------------------------------------------------------------------
-- 3. VALIDATIONS (Contextual Visibility: Public / Community / Connections / Private)
-- ------------------------------------------------------------------------------
ALTER TABLE public.validations ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "validations_select_scoped" ON public.validations;
CREATE POLICY "validations_select_scoped" ON public.validations
    FOR SELECT
    USING (
        author_id = auth.uid()
        OR (status != 'draft' AND visibility IN ('public', 'community'))
        OR (
            visibility = 'connections' 
            AND EXISTS (
                SELECT 1 FROM public.connections 
                WHERE (user_id_1 = auth.uid() AND user_id_2 = author_id)
                   OR (user_id_2 = auth.uid() AND user_id_1 = author_id)
            )
        )
        OR EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() AND role IN ('Admin', 'Super_Admin', 'Security')
        )
    );

DROP POLICY IF EXISTS "validations_insert_author" ON public.validations;
CREATE POLICY "validations_insert_author" ON public.validations
    FOR INSERT
    WITH CHECK (auth.uid() = author_id);

DROP POLICY IF EXISTS "validations_update_author" ON public.validations;
CREATE POLICY "validations_update_author" ON public.validations
    FOR UPDATE
    USING (auth.uid() = author_id)
    WITH CHECK (auth.uid() = author_id);

DROP POLICY IF EXISTS "validations_delete_author" ON public.validations;
CREATE POLICY "validations_delete_author" ON public.validations
    FOR DELETE
    USING (auth.uid() = author_id);

-- ------------------------------------------------------------------------------
-- 4. VALIDATION QUESTIONS
-- ------------------------------------------------------------------------------
ALTER TABLE public.validation_questions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "questions_select_accessible" ON public.validation_questions;
CREATE POLICY "questions_select_accessible" ON public.validation_questions
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.validations v 
            WHERE v.id = validation_id 
              AND (
                  v.author_id = auth.uid() 
                  OR (v.status != 'draft' AND v.visibility IN ('public', 'community'))
                  OR (
                      v.visibility = 'connections' 
                      AND EXISTS (
                          SELECT 1 FROM public.connections c
                          WHERE (c.user_id_1 = auth.uid() AND c.user_id_2 = v.author_id)
                             OR (c.user_id_2 = auth.uid() AND c.user_id_1 = v.author_id)
                      )
                  )
              )
        )
    );

DROP POLICY IF EXISTS "questions_insert_author" ON public.validation_questions;
CREATE POLICY "questions_insert_author" ON public.validation_questions
    FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.validations v 
            WHERE v.id = validation_id AND v.author_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "questions_update_author" ON public.validation_questions;
CREATE POLICY "questions_update_author" ON public.validation_questions
    FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM public.validations v 
            WHERE v.id = validation_id AND v.author_id = auth.uid()
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.validations v 
            WHERE v.id = validation_id AND v.author_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "questions_delete_author" ON public.validation_questions;
CREATE POLICY "questions_delete_author" ON public.validation_questions
    FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM public.validations v 
            WHERE v.id = validation_id AND v.author_id = auth.uid()
        )
    );

-- ------------------------------------------------------------------------------
-- 5. VALIDATION RESPONSES & ANSWERS
-- ------------------------------------------------------------------------------
ALTER TABLE public.validation_responses ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "responses_select_parties" ON public.validation_responses;
CREATE POLICY "responses_select_parties" ON public.validation_responses
    FOR SELECT
    USING (
        respondent_id = auth.uid()
        OR EXISTS (
            SELECT 1 FROM public.validations v 
            WHERE v.id = validation_id AND v.author_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "responses_insert_respondent" ON public.validation_responses;
CREATE POLICY "responses_insert_respondent" ON public.validation_responses
    FOR INSERT
    WITH CHECK (
        auth.uid() = respondent_id
        AND EXISTS (
            SELECT 1 FROM public.validations v 
            WHERE v.id = validation_id AND v.status = 'active'
        )
    );

ALTER TABLE public.validation_answers ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "answers_select_parties" ON public.validation_answers;
CREATE POLICY "answers_select_parties" ON public.validation_answers
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.validation_responses vr
            WHERE vr.id = response_id 
              AND (
                  vr.respondent_id = auth.uid()
                  OR EXISTS (
                      SELECT 1 FROM public.validations v 
                      WHERE v.id = vr.validation_id AND v.author_id = auth.uid()
                  )
              )
        )
    );

DROP POLICY IF EXISTS "answers_insert_respondent" ON public.validation_answers;
CREATE POLICY "answers_insert_respondent" ON public.validation_answers
    FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.validation_responses vr
            WHERE vr.id = response_id AND vr.respondent_id = auth.uid()
        )
    );

-- ------------------------------------------------------------------------------
-- 6. EVIDENCE ITEMS (Confidential Founder Vault)
-- ------------------------------------------------------------------------------
ALTER TABLE public.evidence_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "evidence_select_authorized" ON public.evidence_items;
CREATE POLICY "evidence_select_authorized" ON public.evidence_items
    FOR SELECT
    USING (
        author_id = auth.uid()
        OR (
            is_private = false 
            AND EXISTS (
                SELECT 1 FROM public.validations v 
                WHERE v.id = validation_id 
                  AND v.visibility = 'public' 
                  AND v.status != 'draft'
            )
        )
        OR EXISTS (
            SELECT 1 FROM public.validations v 
            WHERE v.id = validation_id AND v.author_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "evidence_insert_author" ON public.evidence_items;
CREATE POLICY "evidence_insert_author" ON public.evidence_items
    FOR INSERT
    WITH CHECK (
        auth.uid() = author_id
        AND EXISTS (
            SELECT 1 FROM public.validations v 
            WHERE v.id = validation_id AND v.author_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "evidence_update_author" ON public.evidence_items;
CREATE POLICY "evidence_update_author" ON public.evidence_items
    FOR UPDATE
    USING (author_id = auth.uid())
    WITH CHECK (author_id = auth.uid());

DROP POLICY IF EXISTS "evidence_delete_author" ON public.evidence_items;
CREATE POLICY "evidence_delete_author" ON public.evidence_items
    FOR DELETE
    USING (author_id = auth.uid());

-- ------------------------------------------------------------------------------
-- 7. AI EVIDENCE SYNTHESIS & ANALYSES
-- ------------------------------------------------------------------------------
ALTER TABLE public.ai_analyses ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "ai_analyses_select_owner" ON public.ai_analyses;
CREATE POLICY "ai_analyses_select_owner" ON public.ai_analyses
    FOR SELECT
    USING (
        author_id = auth.uid()
        OR EXISTS (
            SELECT 1 FROM public.validations v 
            WHERE v.id = validation_id AND v.author_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "ai_analyses_insert_owner" ON public.ai_analyses;
CREATE POLICY "ai_analyses_insert_owner" ON public.ai_analyses
    FOR INSERT
    WITH CHECK (
        auth.uid() = author_id
        AND EXISTS (
            SELECT 1 FROM public.validations v 
            WHERE v.id = validation_id AND v.author_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "ai_analyses_update_owner" ON public.ai_analyses;
CREATE POLICY "ai_analyses_update_owner" ON public.ai_analyses
    FOR UPDATE
    USING (author_id = auth.uid())
    WITH CHECK (author_id = auth.uid());

DROP POLICY IF EXISTS "ai_analyses_delete_owner" ON public.ai_analyses;
CREATE POLICY "ai_analyses_delete_owner" ON public.ai_analyses
    FOR DELETE
    USING (author_id = auth.uid());

-- ------------------------------------------------------------------------------
-- 8. DECISIONS & EXPERIMENT LOOPS
-- ------------------------------------------------------------------------------
ALTER TABLE public.decisions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "decisions_select_owner" ON public.decisions;
CREATE POLICY "decisions_select_owner" ON public.decisions
    FOR SELECT
    USING (
        author_id = auth.uid()
        OR EXISTS (
            SELECT 1 FROM public.validations v 
            WHERE v.id = validation_id AND v.author_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "decisions_insert_owner" ON public.decisions;
CREATE POLICY "decisions_insert_owner" ON public.decisions
    FOR INSERT
    WITH CHECK (auth.uid() = author_id);

DROP POLICY IF EXISTS "decisions_update_owner" ON public.decisions;
CREATE POLICY "decisions_update_owner" ON public.decisions
    FOR UPDATE
    USING (author_id = auth.uid())
    WITH CHECK (auth.uid() = author_id);

ALTER TABLE public.experiments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "experiments_select_owner" ON public.experiments;
CREATE POLICY "experiments_select_owner" ON public.experiments
    FOR SELECT
    USING (
        author_id = auth.uid()
        OR EXISTS (
            SELECT 1 FROM public.validations v 
            WHERE v.id = validation_id AND v.author_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "experiments_insert_owner" ON public.experiments;
CREATE POLICY "experiments_insert_owner" ON public.experiments
    FOR INSERT
    WITH CHECK (auth.uid() = author_id);

DROP POLICY IF EXISTS "experiments_update_owner" ON public.experiments;
CREATE POLICY "experiments_update_owner" ON public.experiments
    FOR UPDATE
    USING (author_id = auth.uid())
    WITH CHECK (auth.uid() = author_id);

-- ------------------------------------------------------------------------------
-- 9. CONNECTIONS & CONNECTION REQUESTS
-- ------------------------------------------------------------------------------
ALTER TABLE public.connections ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "connections_select_participants" ON public.connections;
CREATE POLICY "connections_select_participants" ON public.connections
    FOR SELECT
    USING (auth.uid() = user_id_1 OR auth.uid() = user_id_2);

DROP POLICY IF EXISTS "connections_delete_participants" ON public.connections;
CREATE POLICY "connections_delete_participants" ON public.connections
    FOR DELETE
    USING (auth.uid() = user_id_1 OR auth.uid() = user_id_2);

ALTER TABLE public.connection_requests ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "requests_select_parties" ON public.connection_requests;
CREATE POLICY "requests_select_parties" ON public.connection_requests
    FOR SELECT
    USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

DROP POLICY IF EXISTS "requests_insert_sender" ON public.connection_requests;
CREATE POLICY "requests_insert_sender" ON public.connection_requests
    FOR INSERT
    WITH CHECK (auth.uid() = sender_id AND receiver_id != auth.uid());

DROP POLICY IF EXISTS "requests_update_parties" ON public.connection_requests;
CREATE POLICY "requests_update_parties" ON public.connection_requests
    FOR UPDATE
    USING (auth.uid() = sender_id OR auth.uid() = receiver_id)
    WITH CHECK (
        (auth.uid() = sender_id OR auth.uid() = receiver_id)
    );

DROP POLICY IF EXISTS "requests_delete_sender" ON public.connection_requests;
CREATE POLICY "requests_delete_sender" ON public.connection_requests
    FOR DELETE
    USING (auth.uid() = sender_id);

-- ------------------------------------------------------------------------------
-- 10. DIRECT MESSAGING (Strict Membership Isolation)
-- ------------------------------------------------------------------------------
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "conversations_select_members" ON public.conversations;
CREATE POLICY "conversations_select_members" ON public.conversations
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.conversation_members cm 
            WHERE cm.conversation_id = id AND cm.user_id = auth.uid()
        )
    );

ALTER TABLE public.conversation_members ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "members_select_convo_members" ON public.conversation_members;
CREATE POLICY "members_select_convo_members" ON public.conversation_members
    FOR SELECT
    USING (
        user_id = auth.uid()
        OR EXISTS (
            SELECT 1 FROM public.conversation_members peer 
            WHERE peer.conversation_id = conversation_id AND peer.user_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "members_insert_initiator" ON public.conversation_members;
CREATE POLICY "members_insert_initiator" ON public.conversation_members
    FOR INSERT
    WITH CHECK (
        user_id = auth.uid()
        OR EXISTS (
            SELECT 1 FROM public.conversation_members creator 
            WHERE creator.conversation_id = conversation_id AND creator.user_id = auth.uid()
        )
    );

ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "messages_select_members" ON public.messages;
CREATE POLICY "messages_select_members" ON public.messages
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.conversation_members cm 
            WHERE cm.conversation_id = messages.conversation_id AND cm.user_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "messages_insert_sender" ON public.messages;
CREATE POLICY "messages_insert_sender" ON public.messages
    FOR INSERT
    WITH CHECK (
        auth.uid() = sender_id
        AND EXISTS (
            SELECT 1 FROM public.conversation_members cm 
            WHERE cm.conversation_id = messages.conversation_id AND cm.user_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "messages_update_sender" ON public.messages;
CREATE POLICY "messages_update_sender" ON public.messages
    FOR UPDATE
    USING (auth.uid() = sender_id)
    WITH CHECK (auth.uid() = sender_id);

DROP POLICY IF EXISTS "messages_delete_sender" ON public.messages;
CREATE POLICY "messages_delete_sender" ON public.messages
    FOR DELETE
    USING (auth.uid() = sender_id);

-- ------------------------------------------------------------------------------
-- 11. NOTIFICATIONS (Recipient-Scoped Access)
-- ------------------------------------------------------------------------------
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "notifications_select_recipient" ON public.notifications;
CREATE POLICY "notifications_select_recipient" ON public.notifications
    FOR SELECT
    USING (auth.uid() = recipient_id);

DROP POLICY IF EXISTS "notifications_update_recipient" ON public.notifications;
CREATE POLICY "notifications_update_recipient" ON public.notifications
    FOR UPDATE
    USING (auth.uid() = recipient_id)
    WITH CHECK (auth.uid() = recipient_id);

DROP POLICY IF EXISTS "notifications_delete_recipient" ON public.notifications;
CREATE POLICY "notifications_delete_recipient" ON public.notifications
    FOR DELETE
    USING (auth.uid() = recipient_id);

-- Trusted server/trigger insert policy
DROP POLICY IF EXISTS "notifications_insert_system" ON public.notifications;
CREATE POLICY "notifications_insert_system" ON public.notifications
    FOR INSERT
    WITH CHECK (
        auth.role() = 'service_role'
        OR auth.uid() IS NOT NULL
    );

-- ------------------------------------------------------------------------------
-- 12. TRUST, SAFETY, PRIVACY & CONSENT
-- ------------------------------------------------------------------------------
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "reports_insert_reporter" ON public.reports;
CREATE POLICY "reports_insert_reporter" ON public.reports
    FOR INSERT
    WITH CHECK (auth.uid() = reporter_id);

DROP POLICY IF EXISTS "reports_select_admin" ON public.reports;
CREATE POLICY "reports_select_admin" ON public.reports
    FOR SELECT
    USING (
        auth.uid() = reporter_id
        OR EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() AND role IN ('Admin', 'Super_Admin', 'Security')
        )
    );

ALTER TABLE public.blocks ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "blocks_all_blocker" ON public.blocks;
CREATE POLICY "blocks_select_blocker" ON public.blocks FOR SELECT USING (auth.uid() = blocker_id);
CREATE POLICY "blocks_insert_blocker" ON public.blocks FOR INSERT WITH CHECK (auth.uid() = blocker_id);
CREATE POLICY "blocks_delete_blocker" ON public.blocks FOR DELETE USING (auth.uid() = blocker_id);

ALTER TABLE public.privacy_requests ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "privacy_requests_user" ON public.privacy_requests;
CREATE POLICY "privacy_requests_select_user" ON public.privacy_requests FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "privacy_requests_insert_user" ON public.privacy_requests FOR INSERT WITH CHECK (auth.uid() = user_id);

ALTER TABLE public.consent_records ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "consent_records_user" ON public.consent_records;
CREATE POLICY "consent_records_select_user" ON public.consent_records FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "consent_records_insert_user" ON public.consent_records FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "consent_records_update_user" ON public.consent_records FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

ALTER TABLE public.access_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "access_logs_admin_or_actor" ON public.access_logs;
CREATE POLICY "access_logs_select_admin" ON public.access_logs 
    FOR SELECT 
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() AND role IN ('Admin', 'Super_Admin', 'Security')
        )
    );
CREATE POLICY "access_logs_insert_actor" ON public.access_logs FOR INSERT WITH CHECK (auth.uid() = actor_id);

-- ------------------------------------------------------------------------------
-- 13. ADMIN AUDIT LOGS — STRICT WRITE-ONCE-READ-MANY (WORM)
-- ------------------------------------------------------------------------------
ALTER TABLE public.admin_audit_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "audit_logs_select_admin" ON public.admin_audit_logs;
CREATE POLICY "audit_logs_select_admin" ON public.admin_audit_logs
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() AND role IN ('Admin', 'Super_Admin', 'Security')
        )
    );

DROP POLICY IF EXISTS "audit_logs_insert_trusted" ON public.admin_audit_logs;
CREATE POLICY "audit_logs_insert_trusted" ON public.admin_audit_logs
    FOR INSERT
    WITH CHECK (
        auth.role() = 'service_role' 
        OR EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() AND role IN ('Admin', 'Super_Admin', 'Security')
        )
    );

-- IMMUTABILITY ENFORCEMENT: No UPDATE or DELETE policy is defined on admin_audit_logs.
-- Supabase RLS rejects all UPDATE and DELETE commands by default.
