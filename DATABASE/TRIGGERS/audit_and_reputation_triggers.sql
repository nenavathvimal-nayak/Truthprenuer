-- ==============================================================================
-- TRUTHPRENUER PRODUCTION DATABASE TRIGGERS
-- Automatic Timestamps, Profile Roles Protection & Immutability Guards
-- ==============================================================================

-- 1. Automatic updated_at trigger function
CREATE OR REPLACE FUNCTION public.set_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = timezone('utc'::text, now());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at to mutable tables
DROP TRIGGER IF EXISTS trg_profiles_updated_at ON public.profiles;
CREATE TRIGGER trg_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at_column();

DROP TRIGGER IF EXISTS trg_startups_updated_at ON public.startups;
CREATE TRIGGER trg_startups_updated_at
  BEFORE UPDATE ON public.startups
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at_column();

DROP TRIGGER IF EXISTS trg_validations_updated_at ON public.validations;
CREATE TRIGGER trg_validations_updated_at
  BEFORE UPDATE ON public.validations
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at_column();

DROP TRIGGER IF EXISTS trg_connection_requests_updated_at ON public.connection_requests;
CREATE TRIGGER trg_connection_requests_updated_at
  BEFORE UPDATE ON public.connection_requests
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at_column();

-- 2. Strict Admin Audit Log Immutability Trigger (Double Layer on top of RLS)
CREATE OR REPLACE FUNCTION public.prevent_audit_log_modification()
RETURNS TRIGGER AS $$
BEGIN
  RAISE EXCEPTION 'CRITICAL SECURITY VIOLATION: Admin audit logs are strictly WORM (Write-Once, Read-Only). Updates and Deletions are forbidden by system policy.';
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_admin_audit_log_prevent_update ON public.admin_audit_logs;
CREATE TRIGGER trg_admin_audit_log_prevent_update
  BEFORE UPDATE OR DELETE ON public.admin_audit_logs
  FOR EACH ROW
  EXECUTE FUNCTION public.prevent_audit_log_modification();
