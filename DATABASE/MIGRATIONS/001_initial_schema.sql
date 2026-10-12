-- ==============================================================================
-- TRUTHPRENUER PRODUCTION SUPABASE DATABASE SCHEMA
-- Comprehensive Normalized Relational Model with Object-Level RLS Enforcement
-- ==============================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ------------------------------------------------------------------------------
-- 1. IDENTITY & PROFILES
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    username TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    avatar_url TEXT,
    bio TEXT DEFAULT '',
    role TEXT NOT NULL DEFAULT 'Founder' CHECK (role IN ('Founder', 'Investor', 'Professional', 'Creator', 'Admin', 'Super_Admin', 'Security')),
    skills JSONB DEFAULT '[]'::jsonb,
    location TEXT DEFAULT '',
    website TEXT DEFAULT '',
    is_verified BOOLEAN DEFAULT false,
    is_suspended BOOLEAN DEFAULT false,
    suspended_at TIMESTAMP WITH TIME ZONE,
    suspension_reason TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ------------------------------------------------------------------------------
-- 2. STARTUPS & TEAMS
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.startups (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    founder_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    tagline TEXT DEFAULT '',
    description TEXT DEFAULT '',
    industry TEXT NOT NULL DEFAULT 'Tech',
    stage TEXT NOT NULL DEFAULT 'Idea',
    logo_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ------------------------------------------------------------------------------
-- 3. CORE VALIDATION SPRINTS
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.validations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    author_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    startup_id UUID REFERENCES public.startups(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    hypothesis TEXT NOT NULL,
    target_audience TEXT NOT NULL,
    industry TEXT NOT NULL DEFAULT 'General',
    validation_stage TEXT NOT NULL DEFAULT 'idea' CHECK (validation_stage IN ('idea', 'prototype', 'mvp', 'launched', 'growing')),
    status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'active', 'completed', 'paused', 'archived')),
    visibility TEXT NOT NULL DEFAULT 'community' CHECK (visibility IN ('public', 'community', 'connections', 'invite_only', 'private')),
    upvotes INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ------------------------------------------------------------------------------
-- 4. VALIDATION QUESTIONS
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.validation_questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    validation_id UUID NOT NULL REFERENCES public.validations(id) ON DELETE CASCADE,
    order_index INTEGER DEFAULT 0 NOT NULL,
    question_text TEXT NOT NULL,
    question_type TEXT NOT NULL CHECK (question_type IN ('multiple_choice', 'rating', 'scale', 'yes_no', 'text')),
    options JSONB, -- For multiple_choice questions
    is_required BOOLEAN DEFAULT true NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ------------------------------------------------------------------------------
-- 5. RESPONSES & STRUCTURED FEEDBACK
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.validation_responses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    validation_id UUID NOT NULL REFERENCES public.validations(id) ON DELETE CASCADE,
    respondent_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT unique_validation_response_per_user UNIQUE(validation_id, respondent_id)
);

CREATE TABLE IF NOT EXISTS public.validation_answers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    response_id UUID NOT NULL REFERENCES public.validation_responses(id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES public.validation_questions(id) ON DELETE CASCADE,
    answer_text TEXT,
    numeric_value NUMERIC,
    selected_options JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ------------------------------------------------------------------------------
-- 6. EVIDENCE LOCKER (First-Class Empirical Evidence)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.evidence_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    validation_id UUID NOT NULL REFERENCES public.validations(id) ON DELETE CASCADE,
    author_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('interview', 'survey', 'data', 'other')),
    summary TEXT NOT NULL,
    confidence_score INTEGER NOT NULL CHECK (confidence_score >= 1 AND confidence_score <= 100),
    key_insight TEXT NOT NULL,
    classification TEXT NOT NULL DEFAULT 'Supports' CHECK (classification IN ('Supports', 'Contradicts', 'Mixed', 'Inconclusive')),
    provenance TEXT,
    tags JSONB DEFAULT '[]'::jsonb,
    is_private BOOLEAN DEFAULT true NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ------------------------------------------------------------------------------
-- 7. AI EVIDENCE SYNTHESIS & REPORTING
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.ai_analyses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    validation_id UUID NOT NULL REFERENCES public.validations(id) ON DELETE CASCADE,
    author_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    observations JSONB DEFAULT '[]'::jsonb NOT NULL,
    observed_patterns JSONB DEFAULT '[]'::jsonb NOT NULL,
    contradictions JSONB DEFAULT '[]'::jsonb NOT NULL,
    evidence_strength TEXT NOT NULL,
    uncertainties JSONB DEFAULT '[]'::jsonb NOT NULL,
    missing_information JSONB DEFAULT '[]'::jsonb NOT NULL,
    suggested_questions JSONB DEFAULT '[]'::jsonb NOT NULL,
    next_experiment JSONB DEFAULT '{}'::jsonb NOT NULL,
    raw_summary TEXT DEFAULT '',
    model_version TEXT DEFAULT 'gemini-1.5-pro',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ------------------------------------------------------------------------------
-- 8. DECISIONS & EXPERIMENT LOOPS
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.decisions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    validation_id UUID NOT NULL REFERENCES public.validations(id) ON DELETE CASCADE,
    author_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    decision_type TEXT NOT NULL CHECK (decision_type IN ('Gather Evidence', 'Iterate', 'Build', 'Re-test', 'Pivot', 'Pause')),
    rationale TEXT NOT NULL,
    supporting_evidence_ids JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.experiments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    decision_id UUID REFERENCES public.decisions(id) ON DELETE SET NULL,
    validation_id UUID NOT NULL REFERENCES public.validations(id) ON DELETE CASCADE,
    author_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    hypothesis TEXT NOT NULL,
    target_audience TEXT NOT NULL,
    test_description TEXT NOT NULL,
    success_criteria TEXT NOT NULL,
    duration_days INTEGER DEFAULT 7,
    status TEXT NOT NULL DEFAULT 'planned' CHECK (status IN ('planned', 'running', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ------------------------------------------------------------------------------
-- 9. CONNECTIONS & NETWORKING
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.connections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id_1 UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    user_id_2 UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT unique_connection_pair UNIQUE(user_id_1, user_id_2)
);

CREATE TABLE IF NOT EXISTS public.connection_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    receiver_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    intro_note TEXT,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'declined', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT unique_pending_connection_request UNIQUE(sender_id, receiver_id)
);

-- ------------------------------------------------------------------------------
-- 10. DIRECT MESSAGING
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.conversation_members (
    conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    last_read_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    PRIMARY KEY (conversation_id, user_id)
);

CREATE TABLE IF NOT EXISTS public.messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ------------------------------------------------------------------------------
-- 11. NOTIFICATIONS
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recipient_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    actor_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    event_type TEXT NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    resource_path TEXT,
    is_read BOOLEAN DEFAULT false NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ------------------------------------------------------------------------------
-- 12. TRUST, SAFETY & PRIVACY
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reporter_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    target_type TEXT NOT NULL CHECK (target_type IN ('validation', 'profile', 'message', 'evidence')),
    target_id TEXT NOT NULL,
    reason TEXT NOT NULL,
    explanation TEXT,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'resolved', 'dismissed')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.blocks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    blocker_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    blocked_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT unique_block_pair UNIQUE(blocker_id, blocked_id)
);

CREATE TABLE IF NOT EXISTS public.privacy_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    request_type TEXT NOT NULL CHECK (request_type IN ('export', 'rectification', 'erasure', 'inquiry')),
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'rejected')),
    details TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    completed_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE IF NOT EXISTS public.consent_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    purpose TEXT NOT NULL,
    consent_version TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('granted', 'withdrawn')),
    granted_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    withdrawn_at TIMESTAMP WITH TIME ZONE,
    source TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.access_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    actor_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    target_user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    action TEXT NOT NULL,
    resource_accessed TEXT NOT NULL,
    context TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.admin_audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id TEXT NOT NULL,
    actor_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    actor_role TEXT NOT NULL,
    action TEXT NOT NULL,
    target_type TEXT NOT NULL,
    target_id TEXT,
    result TEXT NOT NULL DEFAULT 'SUCCESS',
    ip_address TEXT,
    user_agent TEXT,
    request_id TEXT,
    reason TEXT,
    details JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_audit_action ON public.admin_audit_logs(action);
CREATE INDEX IF NOT EXISTS idx_audit_actor ON public.admin_audit_logs(actor_id);
CREATE INDEX IF NOT EXISTS idx_audit_target ON public.admin_audit_logs(target_type, target_id);
CREATE INDEX IF NOT EXISTS idx_audit_created ON public.admin_audit_logs(created_at DESC);

-- ==============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==============================================================================

-- 1. Profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public profiles are viewable by everyone" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Users can insert own profile" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- 2. Startups
ALTER TABLE public.startups ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Startups are viewable by everyone" ON public.startups FOR SELECT USING (true);
CREATE POLICY "Founders can insert own startup" ON public.startups FOR INSERT WITH CHECK (auth.uid() = founder_id);
CREATE POLICY "Founders can update own startup" ON public.startups FOR UPDATE USING (auth.uid() = founder_id);
CREATE POLICY "Founders can delete own startup" ON public.startups FOR DELETE USING (auth.uid() = founder_id);

-- 3. Validations (Object-level visibility rule: private validations restricted to owners)
ALTER TABLE public.validations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authorized users can view validations" ON public.validations FOR SELECT USING (
    author_id = auth.uid()
    OR (status != 'draft' AND visibility IN ('public', 'community'))
);
CREATE POLICY "Users can insert own validations" ON public.validations FOR INSERT WITH CHECK (auth.uid() = author_id);
CREATE POLICY "Users can update own validations" ON public.validations FOR UPDATE USING (auth.uid() = author_id);
CREATE POLICY "Users can delete own validations" ON public.validations FOR DELETE USING (auth.uid() = author_id);

-- 4. Validation Questions
ALTER TABLE public.validation_questions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Viewable questions for accessible validations" ON public.validation_questions FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.validations WHERE validations.id = validation_id AND (
        validations.author_id = auth.uid() OR (validations.status != 'draft' AND validations.visibility IN ('public', 'community'))
    ))
);
CREATE POLICY "Validation owner can insert questions" ON public.validation_questions FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM public.validations WHERE validations.id = validation_id AND validations.author_id = auth.uid())
);
CREATE POLICY "Validation owner can update questions" ON public.validation_questions FOR UPDATE USING (
    EXISTS (SELECT 1 FROM public.validations WHERE validations.id = validation_id AND validations.author_id = auth.uid())
);
CREATE POLICY "Validation owner can delete questions" ON public.validation_questions FOR DELETE USING (
    EXISTS (SELECT 1 FROM public.validations WHERE validations.id = validation_id AND validations.author_id = auth.uid())
);

-- 5. Validation Responses & Answers
ALTER TABLE public.validation_responses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Respondents and owners can view responses" ON public.validation_responses FOR SELECT USING (
    respondent_id = auth.uid()
    OR EXISTS (SELECT 1 FROM public.validations WHERE validations.id = validation_id AND validations.author_id = auth.uid())
);
CREATE POLICY "Authenticated users can submit responses" ON public.validation_responses FOR INSERT WITH CHECK (auth.uid() = respondent_id);

ALTER TABLE public.validation_answers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Respondents and owners can view answers" ON public.validation_answers FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.validation_responses WHERE validation_responses.id = response_id AND (
        validation_responses.respondent_id = auth.uid()
        OR EXISTS (SELECT 1 FROM public.validations WHERE validations.id = validation_responses.validation_id AND validations.author_id = auth.uid())
    ))
);
CREATE POLICY "Respondents can insert answers" ON public.validation_answers FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM public.validation_responses WHERE validation_responses.id = response_id AND validation_responses.respondent_id = auth.uid())
);

-- 6. Evidence Items (Strict Owner Authorization)
ALTER TABLE public.evidence_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Evidence viewable by validation owner or public if explicit" ON public.evidence_items FOR SELECT USING (
    author_id = auth.uid()
    OR EXISTS (SELECT 1 FROM public.validations WHERE validations.id = validation_id AND (
        validations.author_id = auth.uid()
        OR (validations.visibility = 'public' AND NOT evidence_items.is_private)
    ))
);
CREATE POLICY "Validation owner can insert evidence" ON public.evidence_items FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM public.validations WHERE validations.id = validation_id AND validations.author_id = auth.uid())
);
CREATE POLICY "Validation owner can update evidence" ON public.evidence_items FOR UPDATE USING (
    EXISTS (SELECT 1 FROM public.validations WHERE validations.id = validation_id AND validations.author_id = auth.uid())
);
CREATE POLICY "Validation owner can delete evidence" ON public.evidence_items FOR DELETE USING (
    EXISTS (SELECT 1 FROM public.validations WHERE validations.id = validation_id AND validations.author_id = auth.uid())
);

-- 7. AI Analyses (Strict Owner Authorization)
ALTER TABLE public.ai_analyses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Validation owner can view AI analyses" ON public.ai_analyses FOR SELECT USING (
    author_id = auth.uid()
    OR EXISTS (SELECT 1 FROM public.validations WHERE validations.id = validation_id AND validations.author_id = auth.uid())
);
CREATE POLICY "Validation owner can insert AI analyses" ON public.ai_analyses FOR INSERT WITH CHECK (
    author_id = auth.uid()
    AND EXISTS (SELECT 1 FROM public.validations WHERE validations.id = validation_id AND validations.author_id = auth.uid())
);

-- 8. Decisions & Experiments
ALTER TABLE public.decisions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Validation owner can view decisions" ON public.decisions FOR SELECT USING (
    author_id = auth.uid()
    OR EXISTS (SELECT 1 FROM public.validations WHERE validations.id = validation_id AND validations.author_id = auth.uid())
);
CREATE POLICY "Validation owner can insert decisions" ON public.decisions FOR INSERT WITH CHECK (auth.uid() = author_id);

ALTER TABLE public.experiments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Validation owner can view experiments" ON public.experiments FOR SELECT USING (
    author_id = auth.uid()
    OR EXISTS (SELECT 1 FROM public.validations WHERE validations.id = validation_id AND validations.author_id = auth.uid())
);
CREATE POLICY "Validation owner can insert experiments" ON public.experiments FOR INSERT WITH CHECK (auth.uid() = author_id);
CREATE POLICY "Validation owner can update experiments" ON public.experiments FOR UPDATE USING (auth.uid() = author_id);

-- 9. Connections & Connection Requests
ALTER TABLE public.connections ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Connection members can view connection" ON public.connections FOR SELECT USING (
    auth.uid() = user_id_1 OR auth.uid() = user_id_2
);

ALTER TABLE public.connection_requests ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Request parties can view requests" ON public.connection_requests FOR SELECT USING (
    auth.uid() = sender_id OR auth.uid() = receiver_id
);
CREATE POLICY "Senders can insert connection requests" ON public.connection_requests FOR INSERT WITH CHECK (auth.uid() = sender_id);
CREATE POLICY "Parties can update connection requests" ON public.connection_requests FOR UPDATE USING (
    auth.uid() = sender_id OR auth.uid() = receiver_id
);

-- 10. Direct Messaging
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Conversation members can view conversations" ON public.conversations FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.conversation_members WHERE conversation_members.conversation_id = id AND conversation_members.user_id = auth.uid())
);

ALTER TABLE public.conversation_members ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Members can view membership" ON public.conversation_members FOR SELECT USING (
    user_id = auth.uid()
    OR EXISTS (SELECT 1 FROM public.conversation_members m WHERE m.conversation_id = conversation_id AND m.user_id = auth.uid())
);

ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Conversation members can view messages" ON public.messages FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.conversation_members WHERE conversation_members.conversation_id = messages.conversation_id AND conversation_members.user_id = auth.uid())
);
CREATE POLICY "Members can send messages" ON public.messages FOR INSERT WITH CHECK (
    auth.uid() = sender_id
    AND EXISTS (SELECT 1 FROM public.conversation_members WHERE conversation_members.conversation_id = messages.conversation_id AND conversation_members.user_id = auth.uid())
);

-- 11. Notifications
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own notifications" ON public.notifications FOR SELECT USING (auth.uid() = recipient_id);
CREATE POLICY "Users can update own notifications" ON public.notifications FOR UPDATE USING (auth.uid() = recipient_id);

-- 12. Privacy, Consent & Trust
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Reporters can insert reports" ON public.reports FOR INSERT WITH CHECK (auth.uid() = reporter_id);
CREATE POLICY "Admins can view reports" ON public.reports FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = auth.uid() AND profiles.role IN ('Admin', 'Super_Admin', 'Security'))
);

ALTER TABLE public.blocks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own blocks" ON public.blocks FOR SELECT USING (auth.uid() = blocker_id);
CREATE POLICY "Users can insert own blocks" ON public.blocks FOR INSERT WITH CHECK (auth.uid() = blocker_id);
CREATE POLICY "Users can delete own blocks" ON public.blocks FOR DELETE USING (auth.uid() = blocker_id);

ALTER TABLE public.privacy_requests ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own privacy requests" ON public.privacy_requests FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own privacy requests" ON public.privacy_requests FOR INSERT WITH CHECK (auth.uid() = user_id);

ALTER TABLE public.consent_records ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own consent" ON public.consent_records FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own consent" ON public.consent_records FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own consent" ON public.consent_records FOR UPDATE USING (auth.uid() = user_id);

ALTER TABLE public.access_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Admins can view access logs" ON public.access_logs FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = auth.uid() AND profiles.role IN ('Admin', 'Super_Admin', 'Security'))
);
CREATE POLICY "Actors can insert own access logs" ON public.access_logs FOR INSERT WITH CHECK (auth.uid() = actor_id);

-- 13. Admin Audit Logs (Immutable Security Audit Trail)
ALTER TABLE public.admin_audit_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can view audit logs" ON public.admin_audit_logs FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = auth.uid() AND profiles.role IN ('Admin', 'Super_Admin', 'Security'))
);

CREATE POLICY "Privileged service can insert audit logs" ON public.admin_audit_logs FOR INSERT WITH CHECK (
    auth.role() = 'service_role' OR EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = auth.uid() AND profiles.role IN ('Admin', 'Super_Admin', 'Security'))
);
-- Note: NO UPDATE and NO DELETE policies exist. Admin audit logs are strictly Write-Once-Read-Many (WORM).

-- ==============================================================================
-- DATABASE TRIGGERS & PROCEDURES
-- ==============================================================================

-- 1. Prevent role escalation and unauthorized self-unsuspension
CREATE OR REPLACE FUNCTION public.prevent_role_update()
RETURNS TRIGGER AS $$
DECLARE
    is_privileged BOOLEAN;
BEGIN
    -- Check if executing actor is an admin/super_admin/security role
    SELECT (role IN ('Admin', 'Super_Admin', 'Security')) INTO is_privileged 
    FROM public.profiles 
    WHERE id = auth.uid();

    IF NOT COALESCE(is_privileged, false) THEN
        -- Non-admins cannot alter their role
        IF NEW.role IS DISTINCT FROM OLD.role THEN
            NEW.role = OLD.role;
        END IF;
        -- Non-admins cannot lift their own suspension
        IF NEW.is_suspended IS DISTINCT FROM OLD.is_suspended THEN
            NEW.is_suspended = OLD.is_suspended;
        END IF;
        IF NEW.suspended_at IS DISTINCT FROM OLD.suspended_at THEN
            NEW.suspended_at = OLD.suspended_at;
        END IF;
        IF NEW.suspension_reason IS DISTINCT FROM OLD.suspension_reason THEN
            NEW.suspension_reason = OLD.suspension_reason;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_profile_update_prevent_role_change ON public.profiles;
CREATE TRIGGER on_profile_update_prevent_role_change
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE PROCEDURE public.prevent_role_update();

-- 2. Auto-create profile on auth signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, username, role)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', 'Founder'),
    COALESCE(NEW.raw_user_meta_data->>'username', 'user_' || SUBSTRING(NEW.id::text, 1, 8)),
    'Founder'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
