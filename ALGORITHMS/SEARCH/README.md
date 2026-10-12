# Truthprenuer Algorithms — Search & Similarity Discovery (`ALGORITHMS/SEARCH/`)

## 1. Domain Responsibility
Enables fast, relevance-ranked full-text and semantic discovery across startup hypotheses, evidence artifacts, and operator profiles.

## 2. Search Ranking Engine
- **Trigram & Vector Indexing:** Employs PostgreSQL `pg_trgm` and GiST/GIN indexes over claim titles, problem statements, and evidence tokens.
- **Freshness vs. Validation Weight:**
  $$\text{Score} = \alpha \cdot \text{TextRelevance} + \beta \cdot \text{TruthScore} + \gamma \cdot \text{RecencyDecay}$$

## 3. Implementation Reference
- Database Indexes: [`DATABASE/INDEXES/performance_indexes.sql`](file:///Volumes/NAYAK/taeed_flutter_source/DATABASE/INDEXES/performance_indexes.sql)
- Search UI Overlay: [`lib/views/main/search_overlay_view.dart`](file:///Volumes/NAYAK/taeed_flutter_source/lib/views/main/search_overlay_view.dart)
