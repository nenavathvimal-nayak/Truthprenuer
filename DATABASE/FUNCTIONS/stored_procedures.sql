-- ==============================================================================
-- TRUTHPRENUER — STORED PROCEDURES & REPUTATION ENGINE
-- ==============================================================================

-- Recalculate user reputation based on validated accuracy ratio
CREATE OR REPLACE FUNCTION recalculate_user_reputation(p_user_id UUID)
RETURNS NUMERIC AS $$
DECLARE
  v_score NUMERIC := 100.0;
  v_validations_count INT;
  v_accuracy_ratio NUMERIC;
BEGIN
  -- Count total validated contributions
  SELECT COUNT(*) INTO v_validations_count
  FROM validations
  WHERE validator_id = p_user_id;

  IF v_validations_count > 0 THEN
    -- Calculate weight based on consensus alignment
    SELECT COALESCE(AVG(confidence_score), 0.5) INTO v_accuracy_ratio
    FROM validations
    WHERE validator_id = p_user_id;

    v_score := 100.0 + (v_validations_count * 5.0 * v_accuracy_ratio);
  END IF;

  -- Persist updated score
  UPDATE users
  SET reputation_score = ROUND(v_score, 2),
      updated_at = NOW()
  WHERE id = p_user_id;

  RETURN ROUND(v_score, 2);
END;
$$ LANGUAGE plpgsql;
