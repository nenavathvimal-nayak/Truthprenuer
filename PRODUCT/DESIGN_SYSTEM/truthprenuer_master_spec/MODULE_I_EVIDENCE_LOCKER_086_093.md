# TRUTHPRENUER — MODULE I: EVIDENCE MANAGEMENT
## Screens 086 – 093 Specification

---

### Module Overview
- **Domain:** Cryptographic Evidence Vault, Provenance Auditing, Artifact Tagging & Due Diligence
- **Core Principle:** Replace unverified founder claims with tangible, verifiable artifacts (customer interview recordings, LOIs, Google Analytics exports, raw survey CSVs).
- **Security & Integrity:**
  - SHA-256 cryptographic hash generated for every uploaded file upon ingestion.
  - Granular access controls (Public, Investor-Only Diligence Vault, Internal Team Only).
  - Explicit provenance tagging: `[Verified Evidence]` vs. `[Self-Reported Claim]`.

---

### Screen 086: Evidence Locker Overview
- **Screen ID:** `SCR-086`
- **Route:** `/app/validations/:id/evidence`
- **Layout Architecture:**
  - Storage & Integrity Status: "14 Assets Stored • 100% Hash Verified • 2.4 GB Used".
  - Filter Bar: All (14) | Customer Interviews (6) | LOIs & Contracts (2) | Surveys (4) | Financial / Metrics (2).
  - Asset Grid / Table:
    - Thumbnail / File Type Icon (.mp3, .pdf, .csv, .fig)
    - Asset Name & Provenance Badge (`[Verified Evidence]`)
    - Linked Hypotheses (e.g., `#Hypothesis-2: Willingness to Pay`)
    - Uploader, Upload Date, and File Size
    - Action Menu: View Details, Download, Copy SHA Hash, Manage Permissions.

---

### Screen 087: Evidence Item Details
- **Screen ID:** `SCR-087`
- **Route:** `/app/validations/:id/evidence/:itemId`
- **Deep Inspection Experience:**
  - Integrated Media Player (Audio wave viewer with timestamped transcript for customer recordings) or PDF viewer.
  - Transcript Annotation Tool: Highlight key quotes (e.g., *"We lose $3,000 every month because our current tool crashes during invoices"*).
  - Linked Findings: Displays which AI findings and health scores cite this specific evidence asset.

---

### Screen 088: Upload Evidence
- **Screen ID:** `SCR-088`
- **Route:** `/app/validations/:id/evidence/upload`
- **Interactive Uploader:**
  - Multi-file drag and drop area with progress bars, upload speed, and instant SHA-256 checksum calculation.
  - Supported Formats: MP3/M4A/WAV (Customer calls), PDF (Contracts, Pitch decks), CSV/XLSX (Survey raw exports), PNG/JPG/WEBP (Screenshots).
  - Size Limit: Up to 500MB per file with resumable chunk upload.

---

### Screen 089: Source & Provenance Details
- **Screen ID:** `SCR-089`
- **Route:** `/app/validations/:id/evidence/:itemId/provenance`
- **Metadata Fields:**
  - Primary Source: Customer Name (or Anonymized Identifier `Buyer-04`), Job Title, Company Vertical.
  - Acquisition Method: 1-on-1 Zoom Call / Typeform Survey / Organic LOI Signed / In-person demo.
  - Consent Verification: Checkbox confirmation that participant granted recording/quote consent.

---

### Screen 090: Evidence Tagging & Categorisation
- **Screen ID:** `SCR-090`
- **Route:** `/app/validations/:id/evidence/:itemId/tagging`
- **Taxonomy Framework:**
  - Sentiment: Strong Validation / Soft Validation / Neutral / Contradiction / Fatal Flaw.
  - Topic Tags: Pricing, Usability, Implementation Friction, Legal/Compliance, Alternative Solutions.

---

### Screen 091: Evidence Quality Review
- **Screen ID:** `SCR-091`
- **Route:** `/app/validations/:id/evidence/:itemId/quality`
- **Objective Quality Score:**
  - AI automated audit measuring: Question leading bias (Did founder ask leading questions?), Respondent relevance, and Depth of responses.
  - Visual Score: 88/100 (High-Fidelity Evidence).

---

### Screen 092: Evidence Linking to Hypotheses
- **Screen ID:** `SCR-092`
- **Route:** `/app/validations/:id/evidence/:itemId/link`
- **Interactive Multi-Selector:**
  - Connects the artifact directly to one or more of the validation study's hypotheses.
  - Allows linking specific highlighted transcript timestamps (e.g., `04:12 - 05:48`) to a specific assumption.

---

### Screen 093: Evidence Access, Export & Removal
- **Screen ID:** `SCR-093`
- **Route:** `/app/validations/:id/evidence/:itemId/access`
- **Diligence Room Controls:**
  - Grant investor access via expiring signed URLs with watermark protection.
  - Batch export to zip file with full CSV metadata ledger.
  - Secure deletion with 30-day recovery grace period.
