# Roadmap

## Completed milestones

- **Phase 0 — Architecture and documentation:** product boundaries, domain language, privacy principles, and decision records established.
- **Phase 1 — Flutter foundation:** local-first client foundation and feature boundaries established.
- **Phase 1.2 — Product and contract alignment:** document-understanding scope and cross-domain contracts aligned.
- **Phase 2 — Backend foundation:** backend processing foundation and safeguards established.

## Development sequence

1. **Current — Application / Flutter UI and UX completion:** complete and refine the Flutter product experience, remaining application screens, navigation, interactions, and app behavior.
2. **Then — Application behavior / remaining feature gaps:** finish product behavior that the completed application experience requires.
3. **Later — AI analysis-quality improvement:** undertake the dedicated measured workstream in [AI analysis-quality roadmap](ai/ROADMAP.md). This does not block the current application phase.
4. **Before release — Backend contract/privacy/retention hardening:** complete [backend hardening](app-backend/HARDENING_BACKLOG.md), then perform the cross-repository release audit and regression/release validation.

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
