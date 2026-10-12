-- ==============================================================================
-- TRUTHPRENUER — PERFORMANCE AND CONCURRENCY INDEXES
-- Optimized for high-throughput fact verification and live client feeds
-- ==============================================================================

-- 1. Campaign & Query Filters
CREATE INDEX IF NOT EXISTS idx_campaigns_status_created 
  ON campaigns (status, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_campaigns_category 
  ON campaigns (category);

CREATE INDEX IF NOT EXISTS idx_campaigns_creator 
  ON campaigns (creator_id);

-- 2. Validations & Claims Lookups
CREATE INDEX IF NOT EXISTS idx_validations_campaign_created 
  ON validations (campaign_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_claims_campaign_status 
  ON claims (campaign_id, status);

-- 3. Audit Logs Multi-Column Index
CREATE INDEX IF NOT EXISTS idx_audit_logs_actor_action_timestamp 
  ON audit_logs (actor_id, action, timestamp DESC);

CREATE INDEX IF NOT EXISTS idx_audit_logs_target 
  ON audit_logs (target_id, timestamp DESC);

-- 4. User Status & Email Index
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_email_lower 
  ON users (LOWER(email));

CREATE INDEX IF NOT EXISTS idx_users_status_reputation 
  ON users (status, reputation_score DESC);
