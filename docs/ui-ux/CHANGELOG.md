# UI/UX changelog

## 2026-09-21

- Implemented Create Case as a nested validated modal with immutable Organization context: normalized duplicates reuse only within that Organization, new creation returns to the 10A draft without classifying the Document, and cancellation creates nothing.
- Implemented Create Organization as a nested validated modal: trimmed normalized duplicates reuse the existing Organization, new creation returns to the 10A draft without classifying the Document, and cancellation creates nothing.
- Implemented 10C Select Case as a focused searchable modal scoped to the draft Organization, with distinct No Case and Create Case handoffs; selection remains draft-only until 10A Save.
- Implemented 10B Select Organization as a focused searchable local modal that returns a draft-only Organization to Change Classification, preserves Close/X state, exposes selected status, and opens nested Create Organization.
- Refined Change Classification into a focused draft modal with explicit Save, Close/X discard, separate Remove Case and Clear Classification actions, bounded human-readable labels, and RTL-safe fields.
- Clarified the deferred Document-level placement of Analysis History and the incomplete original-source-file experience; individual Results remain focused on one analysis.
- Reordered Task tabs to Today, Upcoming, Overdue, Completed; classification rules are unchanged.
- Added restrained Document Analysis History with historical-result access and confirmed single-analysis deletion that preserves the original Document and linked Tasks.
- Made Result-to-Task action idempotent per persisted analysis action, resolving an existing source Task to View Task.
- Added the Tasks Overdue tab with restrained due-date emphasis and explicit completed-task reopening; completed status remains authoritative until the user reopens it.
- Added contextual Result-to-Create-Task handoff for confirmed actionable results: one editable deterministic prefill preserves Document/confirmed Case links and requires explicit Save; reminder delivery remains deferred.
- Refined Create/Edit Task link selectors to keep internal Document/Case IDs persisted while displaying bounded human-readable labels with safe RTL ellipsis and localized missing-link fallbacks.
- Implemented focused Create/Edit Task forms with local persistence for All Day, optional time, reminder intent, note, and Document/Case links; completion is immediate and delete requires confirmation. Result-to-Task/Reminder and notification delivery remain pending.
- Reconciled UI/UX documentation with the verified implementation and wireframe-alignment audit: several functionally usable flows still require their approved redesign; Create/Edit Task and Result-to-Task/Reminder remain pending; Unclassified Documents interaction/hierarchy is aligned, while final runtime visual fidelity remains for manual review.
- Added the distinct Analyze camera-draft card with ordered thumbnails, localized page count, Remove-all, and Edit Pages reuse of unified Camera Review.
- Extended Camera Review into one unified one-to-ten-page flow: ordered thumbnails, selected-page preview/removal, Add another page through the existing Capture stage, real crop/rotate, Continue handoff, Review discard confirmation, and RTL controls without mirroring image content.

## 2026-09-20

- Implemented single-photo Camera Review: shutter pauses preview into the captured-file surface, Retake safely resumes capture, Use photo promotes to the normal Analyze draft, and real 90-degree rotation is available; crop, multi-page Review, and final camera-selected polish remain deferred.
- Implemented Camera Capture as the first focused camera-import stage: native preview/shutter, truthful flash control, localized permission and availability states, and no draft/Document/operation creation before Review.
- Implemented the post-acceptance Processing modal overlay: dismissal continues analysis in the background, cancellation remains unavailable, and terminal states close the overlay into the existing lifecycle.
- Recorded the non-cancelling Processing-dismissal rule; cancellation remains contract work.
- Clarified that Analyze submission acceptance feedback is transient and local to the current surface, while ongoing processing belongs to the Document lifecycle.
- Recorded bounded deferred Result follow-ups and marked the current visual redesign substantially complete for this application-design phase.
- Polished Result density: one sourced primary action, a bounded high-value fact set with secondary overflow, immediate action-fact deduplication, and heading-free accordion bodies.
- Refined Result state interpretation so complete action uncertainty is not presented as partial, and unsupported/corrupt input is not labeled unreadable.

## 2026-09-19

### Established

- Clarified Documents and Organization roots as folder indexes: Unclassified and Without Case entries own their focused document lists, while empty search-result sections are omitted.
- Established the smallest-suitable interaction-surface principle: contextual selection and small forms use Bottom Sheets/modals, consequential confirmation uses Dialogs, and focused full-screen flows are reserved for substantial work.
- Established compact folder-based Documents browsing: responsive three-column default Organization grid, session-selectable compact List view, contextual search, special Unclassified/Without Case entries, and compact Case document rows.

- Approved **Doxary UX Wireframes v1** as the reference for the core capture/import, Processing, Documents, classification, task, Settings, and lifecycle-driven Result experiences.
- Established Light-theme references as the current visual baseline, with `#F8FAFC` as the main app background and dark mode deferred for a dedicated design pass.
- Clarified that the Doxary logo belongs in the application header and is not a large scrollable page title.
- Clarified the approved Home hierarchy: application header, greeting, action-required items, processing items, bounded recent preview, and View All Documents.
- Consolidated UI/UX documentation under this domain and clarified presentation/interaction responsibility boundaries.

### Refined

- Refined the primary bottom navigation with compact localized labels and restrained Material NavigationBar hierarchy; the scanner-style Analyze destination now uses the same destination treatment as its peers.
