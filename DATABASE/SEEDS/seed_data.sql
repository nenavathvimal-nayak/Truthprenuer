-- ==============================================================================
-- TRUTHPRENUER — SEED DATA FOR STAGING AND LOCAL VERIFICATION
-- ==============================================================================

-- 1. Initial System Roles & Administrator
INSERT INTO users (id, email, username, full_name, role, status, reputation_score)
VALUES 
  ('00000000-0000-0000-0000-000000000001', 'admin@truthprenuer.local', 'sysadmin', 'Local System Admin', 'superadmin', 'active', 1000)
ON CONFLICT (email) DO NOTHING;

-- 2. Initial Sample Verified Truth Seekers & Validators
INSERT INTO users (id, email, username, full_name, role, status, reputation_score)
VALUES 
  ('00000000-0000-0000-0000-000000000002', 'validator1@truthprenuer.org', 'truth_verifier_alpha', 'Alpha Verification Lead', 'validator', 'active', 750),
  ('00000000-0000-0000-0000-000000000003', 'user1@truthprenuer.org', 'citizen_investigator', 'Citizen Investigator', 'user', 'active', 120)
ON CONFLICT (email) DO NOTHING;

-- 3. Initial Sample Validation Campaigns
INSERT INTO campaigns (id, title, description, category, creator_id, status, target_confidence)
VALUES 
  ('10000000-0000-0000-0000-000000000001', 'Autonomous AI Fact Verification Benchmark 2026', 'Independent algorithmic corroboration of enterprise generative claims.', 'AI & Technology', '00000000-0000-0000-0000-00000001', 'active', 0.95)
ON CONFLICT (id) DO NOTHING;
