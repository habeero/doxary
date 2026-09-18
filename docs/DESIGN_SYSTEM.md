# Design system principles

Use a calm, trustworthy, mobile-first system independent of the temporary codename. Typography must support German and Arabic well, use scalable text, adequate line height, and RTL-aware alignment/order/mirroring. All UI strings use Flutter localization; domain values are localized at presentation boundaries. Human-authored localization strings should remain directly readable UTF-8 in source; Unicode escapes are reserved for generated resources or technical constraints.

Use a consistent spacing scale, touch targets suitable for mobile, semantic—not brand-dependent—colors for primary action, information, success, warning, error, and neutral states. Never rely on color alone; pair status with labels/icons. Meet platform accessibility contrast, screen-reader labels, focus order, dynamic text, and reduced-motion needs.

Components include cards for document/action summary, status chips, date/deadline rows, task rows, evidence/uncertainty disclosure, import controls, confirmation dialogs, and inline correction controls. Confidence is phrased plainly (for example, “Please verify”) rather than as a misleading precise score. Loading uses skeleton/progress states; empty states explain a useful next action; errors preserve local work and offer safe retry.

## Phase 2.6.3 design-first gate

Before substantial screen implementation, each approved screen design must define its primary goal, information hierarchy, primary and secondary actions, navigation entry and exit, loading/empty/error states, offline or local-only behavior, partial-analysis behavior where relevant, German and Arabic RTL layouts, and accessibility semantics, focus order, contrast, dynamic type, and touch targets. Wireframes are the implementation source of truth; incremental widget changes must not substitute for an approved flow.

Processing progress uses semantic staged labels with active/completed states, never invented percentages or raw transport logs. Import controls use an immutable Analyze snapshot and become disabled or cleared at submission. Result components are data-driven: absent or meaningless facts are omitted, while explicit organizational unassigned states and useful uncertainty guidance remain visible. Completion, failure, and offline states must be communicated without implying work that the client or server did not actually perform.

Focused flows hide primary navigation and provide explicit Back/Close controls. Reusable design-system patterns, rather than bespoke Figma screens for every standard condition, cover ordinary empty states and notification-permission prompts while respecting the documented context and permission rules. Examples include empty Documents, no Tasks in a tab, no search results, an Organization with no Cases, and no Unclassified Documents. Empty is not Error.

## Phase 1 implementation

The primary navigation component uses Home, Documents, Analyze, Tasks, and Settings. The central Analyze affordance communicates document understanding, not merely file addition. Camera capture and the agreed import states are launch-quality design requirements. A selected multi-image flow supports ordered previews, per-page removal, remove-all, adding pages, and a maximum of 10 pages/images in the current UX design.

The foundation provides a directional spacing scale, Material 3 light/dark semantic color schemes, accessible minimum-height primary actions, reusable section cards, status chips, empty states, and error states. User-visible UI strings are resolved through `AppLocalizations` for German and Arabic; widgets use directional Material layouts and do not contain hardcoded German/Arabic strings. Typography remains system-provided until a future font decision that supports both scripts is made.
