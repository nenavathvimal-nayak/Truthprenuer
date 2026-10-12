"""Graph-based recommendation algorithm for evidence and claims."""
from typing import List, Dict

class VerificationGraphRecommender:
    """Ranks claims and evidence feeds based on graph centrality and user domain expertise."""

    def __init__(self):
        pass

    def rank_claims_for_user(self, user_domains: List[str], claims: List[Dict]) -> List[Dict]:
        """Rank claims by relevance to user domains and dispute volatility."""
        def score(claim):
            domain_match = 1.0 if claim.get("domain") in user_domains else 0.2
            volatility = claim.get("dispute_ratio", 0.5)
            recency_hours = claim.get("age_hours", 24)
            recency_decay = 1.0 / (1.0 + (recency_hours / 24.0))
            return (domain_match * 0.5) + (volatility * 0.3) + (recency_decay * 0.2)

        return sorted(claims, key=score, reverse=True)
