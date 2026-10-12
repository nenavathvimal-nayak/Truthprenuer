-- ==============================================================================
-- TRUTHPRENUER — PRODUCTION ROW LEVEL SECURITY (RLS) POLICIES
-- Zero-Trust Multi-Tenant & Role Isolation
-- ==============================================================================

-- Enable RLS on all operational and audit tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE campaigns ENABLE ROW LEVEL SECURITY;
ALTER TABLE validations ENABLE ROW LEVEL SECURITY;
ALTER TABLE claims ENABLE ROW LEVEL SECURITY;
ALTER TABLE votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- ------------------------------------------------------------------------------
-- 1. USERS POLICIES
-- ------------------------------------------------------------------------------
-- Public profiles readable by active authenticated users
CREATE POLICY users_select_active ON users
  FOR SELECT
  USING (status != 'suspended' OR auth.uid() = id);

-- Users can only modify their own profile information
CREATE POLICY users_update_self ON users
  FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id AND role = (SELECT role FROM users WHERE id = auth.uid()));

-- ------------------------------------------------------------------------------
-- 2. CAMPAIGNS & VALIDATIONS POLICIES
-- ------------------------------------------------------------------------------
-- Anyone authenticated can view published campaigns
CREATE POLICY campaigns_select_published ON campaigns
  FOR SELECT
  USING (status = 'active' OR creator_id = auth.uid());

-- Campaign creators can insert campaigns
CREATE POLICY campaigns_insert_creator ON campaigns
  FOR INSERT
  WITH CHECK (auth.uid() = creator_id);

-- ------------------------------------------------------------------------------
-- 3. AUDIT LOGS — STRICT WORM (WRITE-ONCE, READ-ONLY) ENFORCEMENT
-- ------------------------------------------------------------------------------
-- Normal users cannot view audit logs
CREATE POLICY audit_logs_select_admin ON audit_logs
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid() AND users.role IN ('admin', 'superadmin')
    )
  );

-- Backend service role inserts audit entries
CREATE POLICY audit_logs_insert_service ON audit_logs
  FOR INSERT
  WITH CHECK (true);

-- ZERO UPDATE POLICY: No user or admin may update audit logs
-- (No UPDATE policy defined -> updates permanently rejected by default)

-- ZERO DELETE POLICY: No user or admin may delete audit logs
-- (No DELETE policy defined -> deletes permanently rejected by default)
