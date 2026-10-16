-- ==============================================================================
-- TRUTHPRENUER DATABASE MIGRATION 003: AUDIT WORM COMPLIANCE & ROLE GUARDS
-- Immutability enforcement on admin_audit_logs, self-suspension safeguards,
-- and high-velocity query index optimization.
-- ==============================================================================

BEGIN;

-- 1. True WORM (Write-Once-Read-Many) Immutability on Audit Logs
-- Ensure admin_audit_logs records can NEVER be modified or deleted by anyone
CREATE OR REPLACE FUNCTION public.prevent_audit_log_modification()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'COMPLIANCE VIOLATION: Records in admin_audit_logs are immutable and cannot be updated or deleted.';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_protect_admin_audit_logs_worm ON public.admin_audit_logs;
CREATE TRIGGER trg_protect_admin_audit_logs_worm
    BEFORE UPDATE OR DELETE ON public.admin_audit_logs
    FOR EACH ROW
    EXECUTE FUNCTION public.prevent_audit_log_modification();

-- 2. Database-Level Admin Self-Suspension Safeguard
-- Prevents an administrator or system process from suspending themselves
CREATE OR REPLACE FUNCTION public.prevent_admin_self_suspension()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.is_suspended = true AND OLD.is_suspended = false THEN
        IF auth.uid() IS NOT NULL AND auth.uid() = NEW.id THEN
            RAISE EXCEPTION 'AUTHORIZATION VIOLATION: Administrators cannot suspend their own active accounts.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_prevent_admin_self_suspension ON public.profiles;
CREATE TRIGGER trg_prevent_admin_self_suspension
    BEFORE UPDATE OF is_suspended ON public.profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.prevent_admin_self_suspension();

-- 3. High-Velocity Activity & Moderation Indexes
CREATE INDEX IF NOT EXISTS idx_admin_audit_logs_action_created 
    ON public.admin_audit_logs (action, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_admin_audit_logs_admin_created 
    ON public.admin_audit_logs (admin_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_admin_audit_logs_target_created 
    ON public.admin_audit_logs (target_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_reports_status_priority_created 
    ON public.reports (status, priority, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_profiles_role_suspended 
    ON public.profiles (role, is_suspended);

COMMIT;
