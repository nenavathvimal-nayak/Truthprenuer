"""Hybrid lexical and vector semantic search algorithm."""
from typing import List, Dict

class HybridSearchEngine:
    """Combines BM25 lexical matching with dense vector cosine similarity."""

    @staticmethod
    def cosine_similarity(vec_a: List[float], vec_b: List[float]) -> float:
        """Compute cosine similarity between two vectors."""
        if len(vec_a) != len(vec_b) or not vec_a:
            return 0.0
        dot = sum(a * b for a, b in zip(vec_a, vec_b))
        norm_a = sum(a * a for a in vec_a) ** 0.5
        norm_b = sum(b * b for b in vec_b) ** 0.5
        if norm_a == 0.0 or norm_b == 0.0:
            return 0.0
        return round(dot / (norm_a * norm_b), 4)

    @staticmethod
    def hybrid_rank(lexical_score: float, vector_score: float, alpha: float = 0.6) -> float:
        """Blend lexical (alpha) and vector (1-alpha) scores."""
        return round((alpha * lexical_score) + ((1.0 - alpha) * vector_score), 4)
