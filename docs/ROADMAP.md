# Roadmap

- **Phase 0 — Architecture and documentation:** confirm product boundaries, domain language, contracts, privacy, and decisions. No application implementation.
- **Phase 1 — Flutter foundation:** implemented bootstrap, design/localization foundation, feature boundaries, schema v1 local data layer, navigation, and non-provider import/local workflow contracts. Native picker permissions, actual notifications, and document analysis remain deferred.
- **Phase 1.2 — Product and contract alignment:** completed documentation and local schema alignment for document-first vision analysis, ordered multi-file documents, typed outcomes/evidence, and bounded temporary assistant context.
- **Phase 2 — Flask backend foundation:** API shell, validation, provider abstraction, temporary processing lifecycle, structured schema validation, and operational safeguards.
- **Phase 3 — Document understanding MVP:** end-to-end analysis, result/correction flow, organization/case browsing, and task generation.
- **Phase 4 — Assistant and reminders:** scoped questions, reply drafts, local reminders, reliability and test hardening.
- **Later:** accounts/sync with explicit privacy model, entitlement implementation, richer search/tags, additional languages including Tigrinya, optional cloud storage, and selected integrations.

Phases are outcome-oriented, have no promised dates, and require revisiting privacy, quality, and scope before advancing.

Pre-release gate: feature complete -> independent cross-repository audit -> findings report -> human triage/approval -> small reviewed remediation batches -> full regression validation -> release candidate -> final release. The audit covers both repositories and the full checklist in D-018; it occurs before remediation.

Phase 2.6 also includes independent UI-locale and analysis-explanation-language selection, with both preferences persisted locally.

## Phase 2 delivery sequence

Backend staging is verified through the current Phase 2.7a scope; Flutter-to-staging end-to-end validation remains pending.

The backend/analysis pipeline and local document-organization foundation work end-to-end, but their UI/UX is not product-ready. Before substantial new product features, **Phase 2.6.3 — UX Architecture & Screen Design** is a design-first phase: approve coherent information architecture and wireframes before screen implementation resumes.

Near-term sequence: **Phase 2.6.3 UX architecture + wireframes** -> **fix duplicate-analysis submission defect** -> **implement approved Import/Processing UX** -> **implement approved Documents/Organization/Case UX** -> **implement approved Document Detail/Result UX** -> **analysis-performance instrumentation** -> **measured latency optimization** -> **structured real-device testing** -> **Phase 2.9 beta/release hardening** -> **Phase 3 document-scoped assistant/questions/reply drafting** -> **mandatory independent cross-repository pre-release audit** -> **remediation + full regression** -> **release candidate** -> **final release**.

Analysis succeeds, but latency is not yet understood. Instrumentation must produce a timing breakdown before optimization is selected. The known duplicate-analysis UX defect is that selected transient import files remain selectable after analysis starts; the approved Import/Processing UX must clear or lock them so an accidental second submission cannot occur.

- **Phase 2.6 â€” Flutter integration:** typed API client, multipart submission, idempotency, bounded operation polling, backend-result mapping, local Drift persistence, and opt-in local end-to-end validation. Staging deployment begins only after the local flow upload -> operation -> poll -> local result -> UI is proven.
- **Phase 2.7 â€” Staging deployment (deferred):** production-like PostgreSQL, web/API and worker processes, HTTPS, runtime secrets, shared temporary storage strategy, migrations, logging/health/readiness, rollback, and deployment documentation.
- **Phase 2.8 â€” Real-device and beta testing (deferred):** 2.8a developer/self testing on a real phone against staging; 2.8b 2-3 informed trusted testers using real documents with quality/cost/latency/failure evidence; 2.8c broader closed beta when stable.
- **Phase 2.9 â€” Beta hardening/release preparation (deferred):** observed-failure fixes, privacy/disclosure review, operational limits, monitoring, release checklist, and Play testing/release readiness.
- **Phase 3 â€” Document-scoped assistant (deferred):** questions, bounded `FollowUpContext`, and German reply drafting.

Direct camera/scanner capture remains a separate pre-beta task; it should be added only when the real-device workflow demonstrates a need beyond file-provider import.
