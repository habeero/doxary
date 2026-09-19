# Design system principles

Use a calm, trustworthy, mobile-first system independent of the temporary codename. Typography must support German and Arabic well, use scalable text, adequate line height, and RTL-aware alignment/order/mirroring. All UI strings use Flutter localization; domain values are localized at presentation boundaries. Human-authored localization strings should remain directly readable UTF-8 in source; Unicode escapes are reserved for generated resources or technical constraints.

Use a consistent spacing scale, touch targets suitable for mobile, semantic—not brand-dependent—colors for primary action, information, success, warning, error, and neutral states. Never rely on color alone; pair status with labels/icons. Meet platform accessibility contrast, screen-reader labels, focus order, dynamic text, and reduced-motion needs.

Components include selective functional cards where useful, status chips, date/deadline rows, task rows, evidence/uncertainty disclosure, import controls, confirmation dialogs, and inline correction controls. Flat section hierarchy is preferred over wrapping every section in a card. Confidence is phrased plainly (for example, “Please verify”) rather than as a misleading precise score. Loading uses skeleton/progress states; empty states explain a useful next action; errors preserve local work and offer safe retry.

## Phase 2.6.3 design-first gate

Before substantial screen implementation, each approved screen design must define its primary goal, information hierarchy, primary and secondary actions, navigation entry and exit, loading/empty/error states, offline or local-only behavior, partial-analysis behavior where relevant, German and Arabic RTL layouts, and accessibility semantics, focus order, contrast, dynamic type, and touch targets. Wireframes are the implementation source of truth; incremental widget changes must not substitute for an approved flow.

Processing progress uses semantic staged labels with active/completed states, never invented percentages or raw transport logs. Import controls use an immutable Analyze snapshot and become disabled or cleared at submission. Result components are data-driven: absent or meaningless facts are omitted, while explicit organizational unassigned states and useful uncertainty guidance remain visible. Completion, failure, and offline states must be communicated without implying work that the client or server did not actually perform.

Focused flows hide primary navigation and provide explicit Back/Close controls. Reusable design-system patterns, rather than bespoke Figma screens for every standard condition, cover ordinary empty states and notification-permission prompts while respecting the documented context and permission rules. Examples include empty Documents, no Tasks in a tab, no search results, an Organization with no Cases, and no Unclassified Documents. Empty is not Error.

## Phase 1 implementation

The primary navigation component uses Home, Documents, Analyze, Tasks, and Settings. The central Analyze affordance communicates document understanding, not merely file addition. Camera capture and the agreed import states are launch-quality design requirements. A selected multi-image flow supports ordered previews, per-page removal, remove-all, adding pages, and a maximum of 10 pages/images in the current UX design.

The foundation provides a directional spacing scale, Material 3 light/dark semantic color schemes, accessible minimum-height primary actions, reusable section cards, status chips, empty states, and error states. User-visible UI strings are resolved through `AppLocalizations` for German and Arabic; widgets use directional Material layouts and do not contain hardcoded German/Arabic strings. Typography remains system-provided until a future font decision that supports both scripts is made.

## Visual design v1

The approved visual direction for Doxary uses a calm, trustworthy, low-noise interface. The design should feel professional and reassuring without resembling a bank, hospital, or government portal. Prefer flat section hierarchy, spacing, typography, and dividers over placing every section inside a card. Use cards only when they have a clear functional purpose, such as a selectable item, processing state, warning, error, or grouped interactive control.

### Color tokens

Use these semantic tokens as the current Visual Design v1 baseline:

| Token | Value | Intended use |
|---|---:|---|
| `primary` | `#0F766E` | Primary actions, active states, selected controls |
| `primaryDark` | `#115E59` | Pressed/emphasized primary state |
| `primaryLight` | `#CCFBF1` | Subtle selected/info background |
| `secondary` | `#334155` | Secondary emphasis and icons |
| `background` | `#F8FAFC` | Main light-mode app background |
| `surface` | `#FFFFFF` | Sheets, dialogs, and functional surfaces |
| `surfaceAlt` | `#F1F5F9` | Inputs and low-emphasis grouped surfaces |
| `textPrimary` | `#0F172A` | Primary text |
| `textSecondary` | `#475569` | Secondary text and metadata |
| `success` | `#15803D` | Positive/success state |
| `warning` | `#D97706` | Review-needed/warning state |
| `error` | `#B91C1C` | Failure and destructive actions |
| `info` | `#2563EB` | Neutral informational state |

Do not use semantic status colors as decoration. Never communicate status by color alone; pair color with text, iconography, or both.

Dark mode should preserve the same semantic hierarchy rather than invert colors mechanically. A suitable baseline is:
- background `#0B1220`
- surface `#111827`
- surfaceAlt `#1F2937`
- textPrimary `#F8FAFC`
- textSecondary `#CBD5E1`
- primary `#2DD4BF`

These dark-mode values are a starting baseline and may be tuned after real-device review while preserving accessibility contrast.

### Spacing

Use a 4-point spacing system:

`4 / 8 / 12 / 16 / 24 / 32`

Avoid one-off spacing values unless required by a platform control.

Recommended defaults:
- screen horizontal padding: `20–24`
- title-to-value spacing: `8`
- body rows within one fact group: `4–6`
- controls inside one section: `8–12`
- spacing between major sections: `28–32`
- primary CTA separation from surrounding content: `20–24`

Implementation should encode spacing as reusable tokens/constants rather than hardcoded per-screen values.

### Typography

Typography must support Arabic and German equally well and remain readable with dynamic text scaling. Use a small semantic scale rather than screen-specific font sizes:

- document/screen title: approximately `20–22`
- section title: approximately `16–18`, semibold
- body: approximately `15–16`
- metadata/supporting text: approximately `13–14`
- button text: body-sized with medium/semibold emphasis

Arabic headings should not use excessive bold weight. Line height must remain comfortable for Arabic diacritics and mixed Arabic/German content.

The exact font family remains system-provided until a separate cross-script font decision is approved.

### Shape and controls

Use restrained rounding:
- primary/secondary buttons: radius approximately `8–10`
- text fields/selects: radius approximately `8–10`
- sheets/dialogs may use a larger radius appropriate to Material 3
- avoid excessive pill shapes unless the control is conceptually a chip/segmented control

Primary buttons use `primary` with readable light text. Secondary actions should not visually compete with the primary CTA. Destructive actions use `error` only where the action is genuinely destructive.

Touch targets must meet mobile accessibility guidance.

### Result / Document Detail visual hierarchy

The Result / Document Detail screen is the primary visual reference for Visual Design v1.

Preferred hierarchy:
1. brand/logo area
2. document title
3. concise summary
4. required action
5. primary CTA such as creating a task/reminder
6. important data-driven facts
7. classification
8. expandable secondary detail
9. original-document access

The result screen should remain primarily flat. Do not wrap every section in a card. Use spacing, typography, dividers, and selective emphasis. Action-required content must visually outrank secondary explanation.

Important facts remain data-driven; absent values do not create placeholder rows.

### RTL and bidirectional content

For Arabic presentation:
- container alignment and text alignment must both respect RTL
- use directional padding/margins (`start`/`end`) in Flutter
- Arabic text should normally align to the end/right
- embedded German names, identifiers, dates, amounts, and filenames may retain their natural LTR rendering without forcing artificial reversal
- mixed-language rows must be tested on a real device

Auto-layout alignment in Figma is not a substitute for text-direction settings; implementation must explicitly support bidirectional text.

### Navigation and focused flows

Primary bottom navigation appears on:
- Home
- Documents
- Analyze
- Tasks
- Settings

Focused or nested flows hide primary navigation and use Back/Close:
- camera capture/review
- Processing
- Result / Document Detail
- Organization
- Case / المعاملة
- Unclassified Documents
- classification edit/select/create flows
- Create/Edit Task
- similar transactional or modal flows

Bottom sheets are preferred for lightweight selection and small contextual creation forms, such as choosing an Organization/Case or creating a minimal Organization/Case. Full-screen routes are preferred for longer forms such as Create/Edit Task.

### Reusable component patterns

The Flutter implementation should converge on reusable components/tokens for at least:
- primary button
- secondary button
- destructive action
- search field
- select/dropdown row
- segmented control/tabs
- status label/chip
- expandable/accordion row
- document/list row
- task row
- processing timeline
- bottom sheet
- confirmation dialog
- empty state
- error/failure state
- warning/review-needed state

Do not reproduce Figma geometry through screen-specific absolute positioning. Implement responsive Flutter layouts using theme tokens and reusable widgets.

## Design handoff

The approved UX milestone is **Doxary UX Wireframes v1**.

Visual references should be stored in the repository under:

- `docs/design/wireframes/` — exported UX wireframes and flow references
- `docs/design/visual-reference/` — selected high-fidelity visual references, starting with Result / Action Required

PNG is the preferred handoff format for screen references. Use clear deterministic filenames.

The Figma exports are visual references for layout, hierarchy, and intended interaction. Authoritative product behavior remains in the project documentation and code contracts. When a visual reference conflicts with documented domain or behavioral rules, the authoritative documentation wins.

For implementation work, agents should:
1. read `docs/DESIGN_SYSTEM.md`, `docs/NAVIGATION.md`, and relevant product/data-model docs first;
2. inspect the applicable exported visual references;
3. implement with reusable Flutter theme tokens/components rather than copying coordinates;
4. preserve German/Arabic localization and RTL behavior;
5. validate on a real device and tune visual values only when evidence shows the reference needs adjustment.
