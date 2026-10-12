# Truthprenuer Algorithms — Operator & Hypothesis Recommendations (`ALGORITHMS/RECOMMENDATIONS/`)

## 1. Domain Responsibility
Matches startup hypotheses with vetted domain operators based on demonstrated domain track record, past feedback accuracy, and sector expertise.

## 2. Recommendation Invariants
1. **Zero Pay-to-Play:** Operator rankings cannot be boosted via paid promotions or synthetic signals.
2. **Conflict of Interest Filtering:** Operators with direct competitive ties or identical domain registrations are filtered out of the recommendation candidate set.
3. **Domain Affinity Scoring:**
   $$\text{Affinity}(O, H) = w_1 \cdot \text{SectorSimilarity}(O, H) + w_2 \cdot \text{ReputationScore}(O) + w_3 \cdot \text{FeedbackQuality}(O)$$

## 3. Implementation Reference
- Algorithm Specification: [`PRODUCT/RAW_SPECS/TAEED SEARCH, RECOMMENDATION, DISCOVERY & PERSONALIZATION SYSTEM`](file:///Volumes/NAYAK/taeed_flutter_source/PRODUCT/RAW_SPECS/TAEED%20SEARCH,%20RECOMMENDATION,%20DISCOVERY%20&%20PERSONALIZATION%20SYSTEM)
- Database Indexes: [`DATABASE/INDEXES/performance_indexes.sql`](file:///Volumes/NAYAK/taeed_flutter_source/DATABASE/INDEXES/performance_indexes.sql)
