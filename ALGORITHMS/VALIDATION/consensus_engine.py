"""Bayesian consensus engine for truth verification aggregation."""
from dataclasses import dataclass
from typing import List

@dataclass
class EvidenceVote:
    validator_id: str
    reputation: float  # [0.0, 1.0]
    verdict: bool      # True = Verified, False = Refuted
    weight: float      # [0.0, 1.0]

class BayesianConsensusEngine:
    """Calculates posterior belief of claim truth based on weighted validator evidence."""

    def __init__(self, prior_probability: float = 0.5):
        self.prior = prior_probability

    def calculate_posterior(self, votes: List[EvidenceVote]) -> float:
        """Compute Bayesian posterior probability."""
        if not votes:
            return self.prior

        log_odds = 0.0
        for vote in votes:
            # Effective confidence weighted by reputation and weight
            p_evidence = 0.5 + (vote.reputation * vote.weight * 0.45)
            if not vote.verdict:
                p_evidence = 1.0 - p_evidence
            
            # Avoid division by zero
            p_evidence = max(0.01, min(0.99, p_evidence))
            log_odds += (p_evidence / (1.0 - p_evidence))

        posterior = log_odds / (1.0 + log_odds)
        return round(max(0.0, min(1.0, posterior)), 4)
