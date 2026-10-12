"""Source credibility and validator reputation scoring."""

class CredibilityScorer:
    """Computes trust score for evidence sources and user accounts."""

    @staticmethod
    def calculate_source_score(citation_count: int, domain_age_years: float, peer_reviews: int) -> float:
        """Compute score between 0.0 and 1.0."""
        base = min(0.4, citation_count * 0.04)
        age = min(0.3, domain_age_years * 0.03)
        peer = min(0.3, peer_reviews * 0.05)
        return round(base + age + peer, 4)

    @staticmethod
    def update_validator_reputation(current_rep: float, is_correct: bool, consensus_strength: float) -> float:
        """Update reputation based on consensus alignment."""
        learning_rate = 0.05
        if is_correct:
            new_rep = current_rep + (learning_rate * consensus_strength * (1.0 - current_rep))
        else:
            new_rep = current_rep - (learning_rate * (1.0 + consensus_strength) * current_rep)
        return round(max(0.05, min(0.99, new_rep)), 4)
