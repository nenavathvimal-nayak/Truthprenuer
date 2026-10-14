-- ==============================================================================
-- TRUTHPRENUER — SEED DATA FOR STAGING AND LOCAL VERIFICATION
-- ==============================================================================

-- PRODUCTION EXECUTION GUARD
-- Ensure seed script is NEVER executed in a production environment
DO $$ 
BEGIN 
  IF current_setting('app.environment', true) = 'production' THEN 
    RAISE EXCEPTION 'CRITICAL: Execution of seed_data.sql is prohibited in production environment.'; 
  END IF; 
END $$;

-- 1. Initial System Roles & Administrator
INSERT INTO public.profiles (id, username, full_name, role, is_verified, reputation_score)
VALUES 
  ('00000000-0000-0000-0000-000000000001', 'sysadmin', 'Local System Admin', 'Super_Admin', true, 1000)
ON CONFLICT (id) DO UPDATE SET
  role = EXCLUDED.role,
  is_verified = EXCLUDED.is_verified,
  reputation_score = EXCLUDED.reputation_score;

-- 2. Initial Sample Verified Truth Seekers & Validators
INSERT INTO public.profiles (id, username, full_name, role, is_verified, reputation_score)
VALUES 
  ('00000000-0000-0000-0000-000000000002', 'truth_verifier_alpha', 'Alpha Verification Lead', 'Investor', true, 750),
  ('00000000-0000-0000-0000-000000000003', 'citizen_investigator', 'Citizen Investigator', 'Founder', false, 120)
ON CONFLICT (id) DO UPDATE SET
  role = EXCLUDED.role,
  is_verified = EXCLUDED.is_verified,
  reputation_score = EXCLUDED.reputation_score;

-- 3. Initial Sample Validation Sprints
INSERT INTO public.validations (id, author_id, thesis, target_audience, stage, status, health_score, upvotes)
VALUES 
  ('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000003', 'Autonomous AI Fact Verification Benchmark 2026', 'Enterprise Operators', 'validation', 'active', 85, 12)
ON CONFLICT (id) DO NOTHING;
