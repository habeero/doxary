# Roadmap

## Completed milestones

- **Phase 0 — Architecture and documentation:** product boundaries, domain language, privacy principles, and decision records established.
- **Phase 1 — Flutter foundation:** local-first client foundation and feature boundaries established.
- **Phase 1.2 — Product and contract alignment:** document-understanding scope and cross-domain contracts aligned.
- **Phase 2 — Backend foundation:** backend processing foundation and safeguards established.

## Current product status

### Closed for the current product phase — UI/UX

The current UI/UX phase is closed for this product phase. The implemented experience now covers Home, Documents folder browsing, Analyze/import, Camera Capture and multi-page Review, Processing, the lifecycle-driven Result/Document route, Tasks, classification correction and Organization/Case selection and creation, Settings, and the primary bottom-navigation architecture. Arabic RTL and German LTR behavior, focused nested flows, contextual sheets/dialogs, and established local-state boundaries are documented and have focused regression coverage.

This closure does not claim pixel-perfect runtime wireframe alignment, production readiness, or completion of deferred product capabilities. Final visual review remains a manual runtime responsibility, and bounded presentation follow-ups remain tracked in the UI/UX documents. The current navigation decision is **no Sidebar/Drawer**: Home, Documents, Analyze, Tasks, and Settings remain the primary roots; Organizations and Cases remain contextual within Documents/classification. Reconsider a Sidebar only after multiple independent secondary destinations exist.

Current implementation work has moved to application behavior and remaining MVP gaps. Pre-release product requirements and release gates below are mandatory before public launch.

## Development sequence

1. **Current — Application behavior / remaining MVP gaps:** complete original source access/opening, local reminder scheduling/delivery, and other explicitly approved application behavior gaps.
2. **Remaining product behavior:** complete Document-level History placement and other bounded application gaps already documented in the owning domains.
3. **Pre-release — Settings capability completion:** make every visible approved Settings capability functional, or remove it from the launch UI through an explicit product decision. The current direction is to implement the visible capabilities.
4. **Pre-release — Monetization decision + implementation:** deliberately choose the commercial model in a dedicated phase, specify entitlement/quota/store behavior as applicable, and implement and test the result. No commercial model is selected by this roadmap update.
5. **Pre-release — Camera/device/staging validation:** complete the documented camera-quality and stable-zoom investigation and realistic staging/integration validation.
6. **Later — AI analysis-quality workstream:** undertake the dedicated measured workstream in [AI analysis-quality roadmap](ai/ROADMAP.md), preserving `analysis_result.v1` during ordinary application work until deliberately revised.
7. **Pre-release — Backend contract/privacy/retention hardening:** complete [backend hardening](app-backend/HARDENING_BACKLOG.md).
8. **Pre-release — Independent cross-repository audit:** perform the mandatory audit across the Flutter and backend repositories.
9. **Pre-release — Full regression/store/privacy/release validation:** validate the release candidate against the product, store, privacy, security, and regression gates.
10. **Release:** progress from release candidate to public release only after all mandatory gates pass.

## Tracked gaps and scope boundaries

The following are tracked explicitly and are not implied to be complete by UI/UX closure:

- **Current application behavior gaps:** user-facing original-source display/opening and local reminder scheduling/delivery remain outstanding MVP behavior. Retention and deletion distinctions, including analysis versus Document versus locally owned source copies, require the documented application/privacy work. See [application logic](app-logic/APPLICATION_LOGIC.md#source-document-management-deletion-and-future-synchronization).
- **Remaining product behavior:** duplicate detection across repeated imports, stable canonical titles across repeated analyses, separation of canonical/analysis-specific/user-edited titles, and Document-level Analysis History remain bounded domain work. See [data model decisions](app-logic/DATA_MODEL.md#deferred-canonical-document-title) and [Result information architecture](ui-ux/SCREENS.md#document-route-result-detail).
- **Settings completion:** visible Account, Language, Notifications, Appearance, Privacy & Data, Legal, and About capabilities are pre-release implementation gaps, not permanent post-MVP placeholders. See [UI interactions](ui-ux/INTERACTIONS.md#settings-and-notifications).
- **Monetization:** the commercial model remains undecided, but a deliberate decision and working implementation are mandatory before public launch. See [monetization architecture](monetization/MONETIZATION.md).
- **Post-MVP product work:** cloud synchronization/storage, multi-device sync, household collaboration, richer search/tags, additional languages including Tigrinya, generic assistant/chat or reply drafting, government portal automation, email inbox integration, a full calendar product, and optional cloud original-file storage remain outside the currently approved core MVP unless separately approved. See [MVP scope](MVP_SCOPE.md).
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
- **Phase 3 — Document-scoped assistant:** historical candidate only; questions, bounded follow-up context, and German reply drafting remain outside the approved core MVP unless separately approved.
- **Later:** accounts/sync with an explicit privacy model, richer search/tags, additional languages including Tigrinya, optional cloud storage, and selected integrations.

Phases are outcome-oriented, have no promised dates, and require privacy, quality, and scope review before advancing. The pre-release audit gate and release progression are defined in [DECISIONS.md](DECISIONS.md) and [RELEASE.md](RELEASE.md).
