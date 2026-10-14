-- ==============================================================================
-- TRUTHPRENUER DATABASE MIGRATION 002: SECURITY & TRUST UPGRADE
-- Authoritative Zero-Trust RLS, Trigram & FTS Indexes, Automated Notification Triggers
-- ==============================================================================

BEGIN;

-- 1. Enable pg_trgm for typo-tolerant fuzzy username and name search
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- 2. Performance & Security Indexes
CREATE UNIQUE INDEX IF NOT EXISTS idx_profiles_username_lower 
    ON public.profiles (LOWER(username));

CREATE INDEX IF NOT EXISTS idx_profiles_full_name_trgm 
    ON public.profiles USING GIN (full_name gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_profiles_username_trgm 
    ON public.profiles USING GIN (username gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_validations_fts 
    ON public.validations USING GIN (
        to_tsvector('english', coalesce(title, '') || ' ' || coalesce(description, '') || ' ' || coalesce(hypothesis, ''))
    );

CREATE INDEX IF NOT EXISTS idx_validations_author_status_created 
    ON public.validations (author_id, status, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_validations_visibility_status 
    ON public.validations (visibility, status, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_messages_conversation_created 
    ON public.messages (conversation_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_notifications_recipient_unread 
    ON public.notifications (recipient_id, is_read, created_at DESC);

-- 3. Update RLS on Profiles (Prevent role hijacking)
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

-- 4. Notification Triggers (Server-Side, Idempotent)
CREATE OR REPLACE FUNCTION public.fn_notify_on_connection_request()
RETURNS TRIGGER AS $$
DECLARE
    v_sender_name TEXT;
BEGIN
    IF NEW.status = 'pending' AND NEW.sender_id != NEW.receiver_id THEN
        SELECT full_name INTO v_sender_name 
        FROM public.profiles 
        WHERE id = NEW.sender_id;

        INSERT INTO public.notifications (
            recipient_id,
            actor_id,
            event_type,
            title,
            body,
            resource_path,
            is_read
        ) VALUES (
            NEW.receiver_id,
            NEW.sender_id,
            'connection_request',
            'New Connection Request',
            COALESCE(v_sender_name, 'A user') || ' sent you a connection request.',
            '/network',
            false
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_notify_connection_request ON public.connection_requests;
CREATE TRIGGER trg_notify_connection_request
    AFTER INSERT ON public.connection_requests
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_notify_on_connection_request();

-- 5. Atomic Upvote RPC Function (Security Definer with lower bound check)
CREATE OR REPLACE FUNCTION public.toggle_validation_upvote(p_validation_id UUID, p_increment BOOLEAN)
RETURNS INTEGER AS $$
DECLARE
    v_new_count INTEGER;
BEGIN
    UPDATE public.validations
    SET upvotes = GREATEST(0, COALESCE(upvotes, 0) + CASE WHEN p_increment THEN 1 ELSE -1 END)
    WHERE id = p_validation_id
    RETURNING upvotes INTO v_new_count;
    
    RETURN v_new_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 6. Storage Buckets & Authoritative Object Policies
INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.buckets (id, name, public)
VALUES ('evidence_vault', 'evidence_vault', false)
ON CONFLICT (id) DO NOTHING;

-- Avatars: Public read, owner manage
DROP POLICY IF EXISTS "avatars_public_select" ON storage.objects;
CREATE POLICY "avatars_public_select" ON storage.objects
    FOR SELECT USING (bucket_id = 'avatars');

DROP POLICY IF EXISTS "avatars_owner_insert" ON storage.objects;
CREATE POLICY "avatars_owner_insert" ON storage.objects
    FOR INSERT WITH CHECK (
        bucket_id = 'avatars' 
        AND auth.role() = 'authenticated'
        AND (storage.foldername(name))[1] = auth.uid()::text
    );

DROP POLICY IF EXISTS "avatars_owner_update" ON storage.objects;
CREATE POLICY "avatars_owner_update" ON storage.objects
    FOR UPDATE USING (
        bucket_id = 'avatars' 
        AND auth.role() = 'authenticated'
        AND (storage.foldername(name))[1] = auth.uid()::text
    );

DROP POLICY IF EXISTS "avatars_owner_delete" ON storage.objects;
CREATE POLICY "avatars_owner_delete" ON storage.objects
    FOR DELETE USING (
        bucket_id = 'avatars' 
        AND auth.role() = 'authenticated'
        AND (storage.foldername(name))[1] = auth.uid()::text
    );

-- Evidence Vault (Confidential): Private read for owner, owner manage
DROP POLICY IF EXISTS "evidence_vault_owner_select" ON storage.objects;
CREATE POLICY "evidence_vault_owner_select" ON storage.objects
    FOR SELECT USING (
        bucket_id = 'evidence_vault' 
        AND auth.role() = 'authenticated'
        AND (storage.foldername(name))[1] = auth.uid()::text
    );

DROP POLICY IF EXISTS "evidence_vault_owner_insert" ON storage.objects;
CREATE POLICY "evidence_vault_owner_insert" ON storage.objects
    FOR INSERT WITH CHECK (
        bucket_id = 'evidence_vault' 
        AND auth.role() = 'authenticated'
        AND (storage.foldername(name))[1] = auth.uid()::text
    );

DROP POLICY IF EXISTS "evidence_vault_owner_delete" ON storage.objects;
CREATE POLICY "evidence_vault_owner_delete" ON storage.objects
    FOR DELETE USING (
        bucket_id = 'evidence_vault' 
        AND auth.role() = 'authenticated'
        AND (storage.foldername(name))[1] = auth.uid()::text
    );

COMMIT;
