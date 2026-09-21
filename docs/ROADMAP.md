# Roadmap

## Completed milestones

- **Phase 0 — Architecture and documentation:** product boundaries, domain language, privacy principles, and decision records established.
- **Phase 1 — Flutter foundation:** local-first client foundation and feature boundaries established.
- **Phase 1.2 — Product and contract alignment:** document-understanding scope and cross-domain contracts aligned.
- **Phase 2 — Backend foundation:** backend processing foundation and safeguards established.

## Current product status

### Substantially complete — Application / Flutter UI and UX

The current UI/UX phase is closed for this product phase. The implemented experience now covers Home, Documents folder browsing, Analyze/import, Camera Capture and multi-page Review, Processing, the lifecycle-driven Result/Document route, Tasks, classification correction and Organization/Case selection and creation, Settings, and the primary bottom-navigation architecture. Arabic RTL and German LTR behavior, focused nested flows, contextual sheets/dialogs, and established local-state boundaries are documented and have focused regression coverage.

This closure does not claim pixel-perfect runtime wireframe alignment, production readiness, or completion of deferred product capabilities. Final visual review remains a manual runtime responsibility, and bounded presentation follow-ups remain tracked in the UI/UX documents. The current navigation decision is **no Sidebar/Drawer**: Home, Documents, Analyze, Tasks, and Settings remain the primary roots; Organizations and Cases remain contextual within Documents/classification. Reconsider a Sidebar only after multiple independent secondary destinations exist.

## Development sequence

1. **Current — Application behavior / remaining feature gaps:** complete the product behavior that the substantially complete Flutter experience still requires.
2. **Later — AI analysis-quality improvement:** undertake the dedicated measured workstream in [AI analysis-quality roadmap](ai/ROADMAP.md). This does not block current application work.
3. **Before release — Backend contract/privacy/retention hardening:** complete [backend hardening](app-backend/HARDENING_BACKLOG.md), then perform the cross-repository contract audit and regression/release validation.

## Known deferred product gaps

The following are intentionally deferred and are not implied by UI/UX closure:

- **Original/source-document lifecycle:** user-facing source-file display/opening, retention, Document deletion, independent analysis deletion, and optional removal of Doxary-owned copies remain future work. See [application logic](app-logic/APPLICATION_LOGIC.md#source-document-management-deletion-and-future-synchronization).
- **Document identity and canonical title:** duplicate detection across repeated imports, stable canonical titles across repeated analyses, and separation of canonical, analysis-specific, and user-edited titles remain future domain work. See [data model decisions](app-logic/DATA_MODEL.md#deferred-canonical-document-title).
- **Analysis History placement:** history belongs at the Document level; each Result remains focused on one analysis. See [Result information architecture](ui-ux/SCREENS.md#document-route-result-detail).
- **Reminder delivery and deferred Settings capabilities:** reminder scheduling/delivery, notifications, privacy/data, appearance, account, legal, and About behavior remain unavailable or deferred. See [UI interactions](ui-ux/INTERACTIONS.md#settings-and-notifications).
- **Accounts, synchronization, subscriptions, richer search, and other post-MVP features** remain future product work as defined by [MVP scope](MVP_SCOPE.md).
- **Camera quality and stable zoom investigation:** Samsung S22 capture quality and any safe native zoom strategy remain bounded pre-release investigation. See [camera application logic](app-logic/APPLICATION_LOGIC.md#analyze-session-draft).
- **AI quality:** classification, extraction, uncertainty, naming, evidence grounding, and mixed-language quality remain a dedicated later phase in the [AI roadmap](ai/ROADMAP.md).
- **Release hardening:** backend contract/privacy/retention, cleanup, cross-repository audit, and release validation remain release-blocking work in [backend hardening](app-backend/HARDENING_BACKLOG.md) and [release governance](RELEASE.md).

## Superseded planning note

The milestone labels below are retained as history only. They do not describe the current development order; the application-first sequence above is authoritative.

**Phase 2.6 — Flutter/backend integration:** the integration foundation is implemented. Local end-to-end validation against staging remains pending.

## Historical deferred and future work

- **Phase 2.7 — Staging deployment:** production-like staging and operational readiness.
- **Phase 2.8 — Real-device and beta testing:** developer testing, informed trusted testing, then broader closed beta when stable.
- **Phase 2.9 — Beta hardening and release preparation:** observed-failure fixes, privacy/disclosure review, operational limits, monitoring, and release readiness.
- **Phase 3 — Document-scoped assistant:** questions, bounded follow-up context, and German reply drafting.
- **Later:** accounts/sync with an explicit privacy model, richer search/tags, additional languages including Tigrinya, optional cloud storage, and selected integrations.

Phases are outcome-oriented, have no promised dates, and require privacy, quality, and scope review before advancing. The pre-release audit gate and release progression are defined in [DECISIONS.md](DECISIONS.md) and [RELEASE.md](RELEASE.md).
