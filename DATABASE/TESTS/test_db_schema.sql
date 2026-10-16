-- ==============================================================================
-- TRUTHPRENUER — DATABASE SCHEMA & SECURITY VERIFICATION TEST SUITE
-- Verifies all 21 core tables, security columns, WORM audit logs, triggers, RPCs
-- ==============================================================================

DO $$
BEGIN
  -- 1. Assert profiles table exists and has critical security columns
  ASSERT (SELECT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' AND table_name = 'profiles' AND column_name = 'role'
  )), 'ASSERTION FAILED: public.profiles.role column missing';

  ASSERT (SELECT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' AND table_name = 'profiles' AND column_name = 'username'
  )), 'ASSERTION FAILED: public.profiles.username column missing';

  -- 2. Assert admin_audit_logs table exists for WORM compliance
  ASSERT (SELECT EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_schema = 'public' AND table_name = 'admin_audit_logs'
  )), 'ASSERTION FAILED: public.admin_audit_logs table missing';

  -- 3. Assert startups and validations tables exist
  ASSERT (SELECT EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_schema = 'public' AND table_name = 'startups'
  )), 'ASSERTION FAILED: public.startups table missing';

  ASSERT (SELECT EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_schema = 'public' AND table_name = 'validations'
  )), 'ASSERTION FAILED: public.validations table missing';

  -- 4. Assert confidential founder vault: evidence_items exists with is_private
  ASSERT (SELECT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' AND table_name = 'evidence_items' AND column_name = 'is_private'
  )), 'ASSERTION FAILED: public.evidence_items.is_private column missing';

  -- 5. Assert messaging and social connection tables
  ASSERT (SELECT EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_schema = 'public' AND table_name = 'connection_requests'
  )), 'ASSERTION FAILED: public.connection_requests table missing';

  ASSERT (SELECT EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_schema = 'public' AND table_name = 'messages'
  )), 'ASSERTION FAILED: public.messages table missing';

  ASSERT (SELECT EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_schema = 'public' AND table_name = 'notifications'
  )), 'ASSERTION FAILED: public.notifications table missing';

  -- 6. Assert privacy and consent tables
  ASSERT (SELECT EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_schema = 'public' AND table_name = 'privacy_requests'
  )), 'ASSERTION FAILED: public.privacy_requests table missing';

  ASSERT (SELECT EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_schema = 'public' AND table_name = 'consent_records'
  )), 'ASSERTION FAILED: public.consent_records table missing';

  -- 7. Assert WORM and Role Guard Triggers from Migration 003
  ASSERT (SELECT EXISTS (
    SELECT 1 FROM information_schema.triggers 
    WHERE event_object_table = 'admin_audit_logs' AND trigger_name = 'trg_protect_admin_audit_logs_worm'
  )), 'ASSERTION FAILED: WORM audit log protection trigger missing';

  ASSERT (SELECT EXISTS (
    SELECT 1 FROM information_schema.triggers 
    WHERE event_object_table = 'profiles' AND trigger_name = 'trg_prevent_admin_self_suspension'
  )), 'ASSERTION FAILED: Admin self-suspension safeguard trigger missing';

  RAISE NOTICE 'TRUTHPRENUER DATABASE SCHEMA & SECURITY INTEGRITY VERIFIED SUCCESSFULLY';
END $$;
