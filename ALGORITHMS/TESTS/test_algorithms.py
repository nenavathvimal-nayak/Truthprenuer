"""Unit tests for proprietary algorithms engine."""
import pytest
import sys
import os

# Ensure ALGORITHMS is on path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from VALIDATION.consensus_engine import BayesianConsensusEngine, EvidenceVote
from SCORING.credibility_scoring import CredibilityScorer
from SEARCH.hybrid_vector_search import HybridSearchEngine
from ANALYTICS.trend_telemetry import TrendTelemetryEngine

def test_bayesian_consensus():
    engine = BayesianConsensusEngine(prior_probability=0.5)
    votes = [
        EvidenceVote(validator_id="v1", reputation=0.9, verdict=True, weight=1.0),
        EvidenceVote(validator_id="v2", reputation=0.8, verdict=True, weight=0.9),
    ]
    posterior = engine.calculate_posterior(votes)
    assert posterior > 0.85

def test_credibility_scoring():
    score = CredibilityScorer.calculate_source_score(citation_count=10, domain_age_years=5, peer_reviews=4)
    assert 0.0 <= score <= 1.0

def test_hybrid_search():
    sim = HybridSearchEngine.cosine_similarity([1.0, 0.0], [1.0, 0.0])
    assert pytest.approx(sim, 0.001) == 1.0
    rank = HybridSearchEngine.hybrid_rank(lexical_score=0.8, vector_score=0.9, alpha=0.5)
    assert rank == 0.85

def test_trend_telemetry():
    velocity = TrendTelemetryEngine.calculate_velocity([100.0, 200.0, 300.0], window_seconds=3600.0)
    assert velocity > 0.0
