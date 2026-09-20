# UI/UX changelog

## 2026-09-20

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
