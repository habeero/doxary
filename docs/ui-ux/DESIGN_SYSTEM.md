# Doxary design system

## Visual direction and theme baseline

Doxary uses a calm, trustworthy, low-noise, mobile-first visual direction. It should feel professional and reassuring without resembling a bank, hospital, or government portal. Typography and layout support German and Arabic equally well, including scalable text, comfortable line height, and RTL-aware alignment and mirroring.

The approved Figma references are Light-theme references. Light mode is the current visual implementation baseline, the main app background is `#F8FAFC`, and current UI/UX visual validation is performed against Light mode. Dark mode is deferred for a later dedicated design pass; there is currently no approved production dark palette.

The `Doxary` text shown in wireframes represents the application logo/brand. It belongs in the application header and is not a large page title inside scrollable content. Primary root screens use a consistent app-header brand treatment. Focused or nested flows may instead use contextual Back/Close headers.

## Color tokens

Use semantic tokens rather than screen-specific colors:

| Token | Value | Intended use |
| --- | --- | --- |
| `primary` | `#0F766E` | Primary actions, active states, selected controls |
| `primaryDark` | `#115E59` | Pressed or emphasized primary state |
| `primaryLight` | `#CCFBF1` | Subtle selected or informational background |
| `secondary` | `#334155` | Secondary emphasis and icons |
| `background` | `#F8FAFC` | Main Light-mode app background |
| `surface` | `#FFFFFF` | Sheets, dialogs, and functional surfaces |
| `surfaceAlt` | `#F1F5F9` | Inputs and low-emphasis grouped surfaces |
| `textPrimary` | `#0F172A` | Primary text |
| `textSecondary` | `#475569` | Secondary text and metadata |
| `success` | `#15803D` | Positive or success state |
| `warning` | `#D97706` | Review-needed or warning state |
| `error` | `#B91C1C` | Failure and destructive actions |
| `info` | `#2563EB` | Neutral informational state |

Status colors are never used as decoration or communicated by color alone. Pair status with a label, icon, or both.

## Spacing

Use the 4-point spacing scale: `4 / 8 / 12 / 16 / 24 / 32`.

- Screen horizontal padding: approximately `20–24`.
- Title-to-value spacing: `8`.
- Body rows within one fact group: `4–6`.
- Controls within one section: `8–12`.
- Major section spacing: `28–32`.
- Primary CTA separation: `20–24`.

Prefer reusable spacing constants. Avoid one-off values unless required by a platform control, and do not reproduce wireframe pixel coordinates with absolute positioning.

## Typography

Use a small semantic scale that remains readable with dynamic text scaling:

- Document or screen title: approximately `20–22`.
- Section title: approximately `16–18`, semibold.
- Body: approximately `15–16`.
- Metadata or supporting text: approximately `13–14`.
- Button text: body-sized with medium or semibold emphasis.

Arabic headings should not use excessive bold weight. Line height must accommodate Arabic diacritics and mixed Arabic/German content. The font family remains system-provided until a separate cross-script font decision is approved.

## Shape, controls, and visual hierarchy

Use restrained rounding: approximately `8–10` for primary/secondary buttons and fields, larger radii where appropriate for Material sheets/dialogs, and pill shapes only for conceptual chips or segmented controls. Primary buttons use `primary` with readable light text. Secondary actions should not compete with the primary action; use `error` only for genuinely destructive actions. Touch targets meet mobile accessibility guidance.

Prefer flat hierarchy through spacing, typography, dividers, and selective emphasis. Use cards or functional containers only for a selectable item, processing state, warning, error, or grouped interactive control. Do not wrap every section in a card.

Required-action content visually outranks secondary explanation. The ordered Result / Document Detail hierarchy is defined in [Screens](SCREENS.md) and must be applied consistently there and in visual reviews.

## RTL and accessibility

For Arabic presentation, container alignment and text alignment both respect RTL. Use directional padding and margins (`start`/`end`); Arabic text normally aligns to the end/right. Embedded German names, identifiers, dates, amounts, and filenames may retain their natural LTR rendering without artificial reversal. Mixed-language rows require real-device review.

All UI strings use Flutter localization; domain values are localized at the presentation boundary. Widgets use directional Material layouts and do not contain hardcoded German or Arabic strings. Human-authored localization strings remain directly readable UTF-8. Meet contrast requirements, screen-reader semantics, focus order, dynamic type, and reduced-motion needs.

## Reusable patterns

The design system should converge on reusable patterns for primary, secondary, and destructive actions; search fields; select/dropdown rows; segmented controls; status labels/chips; expandable rows; document and task rows; processing timelines; bottom sheets; confirmation dialogs; empty states; errors; and warning/review-needed states.

Loading uses skeleton or progress states. Empty states explain a useful next action and are not errors. Errors preserve local work and offer safe recovery. Confidence is phrased plainly, such as “Please verify”, rather than as a misleading precise score.

## Design handoff

The approved UX milestone is **Doxary UX Wireframes v1**. PNG is the preferred handoff format. The exported references are visual guidance for layout, hierarchy, and interaction; this UI/UX domain is authoritative for presentation and interaction decisions.
