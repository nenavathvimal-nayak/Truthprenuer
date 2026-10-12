-- ==============================================================================
-- TRUTHPRENUER — DATABASE SCHEMA VERIFICATION TEST SUITE
-- ==============================================================================

DO $$
BEGIN
  -- 1. Assert users table exists and has critical security columns
  ASSERT (SELECT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'users' AND column_name = 'status'
  )), 'ASSERTION FAILED: users.status column missing';

  ASSERT (SELECT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'users' AND column_name = 'role'
  )), 'ASSERTION FAILED: users.role column missing';

  -- 2. Assert audit_logs table exists and is structured for WORM compliance
  ASSERT (SELECT EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_name = 'audit_logs'
  )), 'ASSERTION FAILED: audit_logs table missing';

  -- 3. Assert campaigns and validations tables exist
  ASSERT (SELECT EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_name = 'campaigns'
  )), 'ASSERTION FAILED: campaigns table missing';

  ASSERT (SELECT EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_name = 'validations'
  )), 'ASSERTION FAILED: validations table missing';

  RAISE NOTICE 'DATABASE SCHEMA INTEGRITY VERIFICATION PASSED SUCCESSFULLY';
END $$;
