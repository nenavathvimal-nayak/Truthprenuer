-- ==============================================================================
-- TRUTHPRENUER — DATABASE TRIGGERS
-- Automatic Timestamps, Reputation Calibration, and Immutability Guards
-- ==============================================================================

-- 1. Automatic updated_at trigger function
CREATE OR REPLACE FUNCTION set_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at to mutable tables
DROP TRIGGER IF EXISTS trg_users_updated_at ON users;
CREATE TRIGGER trg_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION set_updated_at_column();

DROP TRIGGER IF EXISTS trg_campaigns_updated_at ON campaigns;
CREATE TRIGGER trg_campaigns_updated_at
  BEFORE UPDATE ON campaigns
  FOR EACH ROW
  EXECUTE FUNCTION set_updated_at_column();

-- 2. Strict Audit Log Immutability Trigger (Double Layer on top of RLS)
CREATE OR REPLACE FUNCTION prevent_audit_log_modification()
RETURNS TRIGGER AS $$
BEGIN
  RAISE EXCEPTION 'CRITICAL SECURITY VIOLATION: Audit logs are strictly WORM (Write-Once, Read-Only). Updates and Deletions are forbidden by system law.';
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_audit_log_prevent_update ON audit_logs;
CREATE TRIGGER trg_audit_log_prevent_update
  BEFORE UPDATE OR DELETE ON audit_logs
  FOR EACH ROW
  EXECUTE FUNCTION prevent_audit_log_modification();
