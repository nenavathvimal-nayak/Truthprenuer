# Truthprenuer Design System & Aesthetics Specification

## 1. Brand Identity & Visual Language
Truthprenuer is designed around clarity, cryptographic authority, transparency, and high contrast.
- **Primary Color:** Electric Vermilion / Truth Accent (`#F44A22`, `--color-primary`)
- **Primary Hover:** Deep Vermilion (`#D73D19`, `--color-primary-hover`)
- **Surface Dark:** Deep Obsidian (`#0F172A`)
- **Surface Elevation:** Glassmorphic Layering with 8px blur and 1px border (`rgba(255, 255, 255, 0.08)`)
- **Typography:** Inter & system sans-serif hierarchy for maximum readability across screens.

## 2. Interactive States & Micro-interactions
- **Buttons & Calls to Action:** Subtle hover lift, active press indentation, focus rings with accessible contrast ratio (>= 4.5:1).
- **Consensus Meters:** Dynamic color progression (Red: Disputed <40%, Amber: Unverified 40-75%, Emerald: Truth Verified >=75%).
- **Live Sync Badges:** Pulsing indicator showing connection state (Green = Realtime Active, Amber = Reconnecting/Syncing, Red = Offline Cached).

## 3. Assistive Semantics & Accessibility (WCAG 2.2 AA)
- Live regions (`liveRegion: true`) announce consensus and endorsement updates to screen readers.
- Keyboard navigation: Full focus trap support in modals and complete tab indexing across feeds.
- High contrast support across Light and Dark system modes.
