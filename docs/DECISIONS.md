# Architecture decisions

Each entry is an ADR-style confirmed decision. Open product/commercial choices remain open unless stated.

## D-001 Flutter, Riverpod, GoRouter, and feature-first Clean Architecture

**Context:** Mobile-first Android delivery must remain iOS-ready and maintainable. **Decision:** Flutter is the client framework; Riverpod provides state/DI, GoRouter navigation, and feature-first Clean Architecture is the boundary model. **Rationale:** shared UI with testable domain/application layers and explicit feature ownership. **Consequences:** UI contains no business logic; domain has no Flutter dependency. **Alternative:** prototype-layer architecture rejected because it would force a major refactor.

## D-002 Drift/SQLite and local-first ownership

**Context:** Documents are sensitive and users need access around unreliable connectivity. **Decision:** use Drift/SQLite locally and retain original files locally by default. **Rationale:** local usability and data minimization. **Consequences:** future sync needs explicit IDs/revisions/conflict policy. **Alternative:** cloud-first storage is deferred.

## D-003 Flask, PostgreSQL, and `/api/v1`

**Context:** Server concerns need a conventional, replaceable API/service boundary. **Decision:** later backend uses Flask, SQLAlchemy/Alembic, PostgreSQL, and versioned REST beginning `/api/v1`. **Rationale:** clear Python ecosystem fit and compatibility management. **Consequences:** no backend implementation or migrations in Phase 0. **Alternative:** hosting/framework changes require a documented ADR.

## D-004 Backend-mediated provider abstraction and structured AI

**Context:** credentials, safety, cost, and provider portability cannot live in Flutter. **Decision:** Flutter never calls providers directly; backend owns provider adapters, routing, prompts, validation, and versioned structured schemas. **Rationale:** security and reliable actionable UX. **Consequences:** model names do not enter domain/client contracts; uncertain facts are explicit. **Alternative:** free-form direct client chat rejected.

## D-005 Organization -> Case -> Document

**Context:** administrative correspondence forms continuing relationships. **Decision:** model Organization -> Case -> Document, with derived action items sourced to documents. **Rationale:** natural browsing and lifecycle context without forcing manual setup. **Consequences:** classifier suggestions are editable; categories are configuration/display labels. **Alternative:** flat document list is insufficient.

## D-006 Language-independent domain, Arabic RTL first

**Context:** German source material needs Arabic explanation now and other languages later. **Decision:** separate source language, target language, and localized labels; support RTL from foundation. **Rationale:** adding Tigrinya or other targets does not alter business logic. **Consequences:** localization is tested as a core concern. **Alternative:** Arabic-only domain values rejected.

## D-007 Entitlement abstraction

**Context:** monetization is undecided but should not contaminate UI/business rules. **Decision:** central EntitlementService/FeatureAccess/UsageQuota concepts. **Rationale:** future pricing/store choices stay replaceable. **Consequences:** no final price or paid feature is implied. **Alternative:** scattered premium booleans rejected.

## D-008 Hosting neutrality

**Context:** deployment is not decided. **Decision:** no hosting/vendor assumptions in architecture. **Rationale:** preserve deployment choice. **Consequences:** deployment provider is an open decision; mobile-domain contracts remain independent.

## D-009 Local-context assistant operations and identifier vocabulary

**Context:** path-based assistant routes implied that a local Document already existed as a permanent backend resource, conflicting with local-first ownership. **Decision:** MVP assistant operations accept a minimum temporary context envelope and use `client_document_id` only to correlate to the local Document. `operation_id` identifies temporary asynchronous work; `request_id` correlates one API request; `server_resource_id` is reserved for future synchronized resources. **Rationale:** questions and reply drafting work without accounts, cloud sync, or permanent server originals. **Consequences:** MVP contracts use explicit local versus server identifier names; future sync can add server resources compatibly. **Alternative:** server-side document lookup for every assistant request was rejected.

## D-010 Imported documents may be unclassified

**Context:** the confirmed Organization -> Case -> Document hierarchy must not block import when classification is unavailable or uncertain. **Decision:** Document organization/case links are optional until confirmation, with `unclassified`, `suggested`, and `confirmed` classification states. AI suggestions remain non-confirmed provenance until the user accepts or corrects them. **Rationale:** documents are safely retained and analyzable even when extraction/classification fails. **Consequences:** no automatic misleading “Unknown” cases; confirmed browsing retains the hierarchy. **Alternative:** mandatory hierarchy creation at import was rejected.

## D-011 Phase 1 Flutter package, dependencies, and schema v1

**Context:** Phase 1 needs a runnable local-first foundation without prematurely building product integrations. **Decision:** use the finalized Doxary product identity with Dart package `doxary` and Android/iOS application identity `de.habeero.doxary`; use Riverpod, GoRouter, Drift/SQLite, path/path_provider, UUID, and Flutter localization. Schema v1 is normalized and includes local organizations, cases, documents, files, analyses, action facts, tasks, and non-sensitive settings. **Rationale:** each dependency directly enables an approved Phase 1 boundary; UUID v7 provides stable client-origin IDs. **Consequences:** Drift mappings are generated code and migration upgrades must be explicit/forward-only. **Alternative:** picker, notification, AI, billing, cloud, and analytics packages were intentionally not added.

## D-012 Explicit unavailable platform capabilities

**Context:** camera/file permissions and notifications require platform integration choices that are outside the foundation scope. **Decision:** expose typed `DocumentImportGateway` and `ReminderScheduler` ports with adapters that return or expose unavailable capability state. **Rationale:** UI can be honest and domain code remains independent of platform libraries. **Consequences:** no fake imports or reminder scheduling occur in Phase 1; native adapters can be introduced later without changing use cases. **Alternative:** silent no-op success and picker coupling in presentation were rejected.

## D-013 Document-first vision analysis and bounded follow-up context

**Decision:** Analysis starts from an imported document before assistant use. Vision-capable backend processing is the MVP path; on-device OCR is optional. Results separate extracted facts from explanation, include output language/style, typed quality outcomes/reasons, and typed evidence. Multiple versioned analyses remain possible per local document. A backend follow-up context, if used, is short-lived, deletable, and limited to structured analysis, summary, evidence, version, and lifecycle timestamps; it never stores original files or creates a permanent Document resource.

## D-014 Phase 2.6 backend integration boundary

**Decision:** Flutter submits one logical local Document to `POST /api/v1/document-analyses`, assigns a high-entropy idempotency key per submission attempt, and polls the backend operation resource using bounded client-side polling. The operation ID is persisted only as pending local metadata and is removed after result persistence; it never replaces `client_document_id`. A terminal backend failure is recorded as a non-pending failed operation, transitions the local Document to `needsReview`, and is surfaced as a typed, user-safe client error; it never causes another POST. **Consequences:** transient upload retry can reuse the in-memory key, polling retry never resubmits, expiry is explicit/recoverable, and an app restart resumes only known accepted/processing operations. A user-initiated reanalysis creates a new submission/idempotency key while retaining local files. Provider APIs and raw result JSON remain outside Flutter domain/presentation.

## D-015 Local persisted-result read path

**Decision:** A document result route reads the latest typed `DocumentAnalysis` through `AnalysisRepository` and Drift. It does not re-submit or poll solely to display an existing result. Optional sections are omitted, while `complete`, `partial`, and `unavailable` remain explicit product outcomes. Classification suggestions and evidence remain non-confirming metadata.

## D-016 Independent interface and analysis-explanation languages

**Context:** Users may prefer Arabic or German interface labels independently from the language used to explain a document. **Decision:** Persist UI locale and analysis-output language as separate local settings. The MVP supports Arabic and Einfaches Deutsch explanations; the default follows the effective UI locale on first use, while an explicit analysis-language choice remains independent. **Rationale:** changing labels must not silently rewrite a user's analysis preference, and cold-start locale detection must work before persisted settings are available. **Consequences:** the import review exposes a compact selector near Analyze and submits the selected language/style as `output_language` and `output_style`; both preferences remain local-first. **Alternative:** deriving output language on every build from UI locale was rejected because it overwrites explicit user intent.

## D-017 Replaceable staging implementation choices

The following choices are current MVP/staging implementations, not permanent architecture commitments. Each replacement requires measured evidence and a documented follow-up decision:

- The configured OpenAI provider/model may change when comparative quality, latency, reliability, privacy, or cost measurements justify it.
- Flutter polling may be replaced by SSE, WebSocket, or push when real product telemetry shows polling latency, battery use, or reliability is inadequate.
- The PostgreSQL row-lock/lease worker queue may move to Redis/Celery or another queue when throughput, lock contention, distributed workers, or operations require it.
- A local temporary filesystem is valid while API and worker share host/storage; object storage becomes appropriate when multi-host or horizontal scaling requires shared artifacts.
- One-host Docker Compose on Hetzner is staging topology; production scale, availability, or isolation requirements trigger a different deployment topology.
- Gunicorn and Caddy remain tunable/replaceable operational components; measured capacity, TLS, or proxy requirements trigger a change.
- Flask remains adequate; a framework change requires a demonstrated bottleneck or capability need, not preference.
- Flutter, Riverpod, GoRouter, and Drift/SQLite are approved foundation choices and are not scheduled for replacement absent a demonstrated product or platform constraint.

## D-018 Mandatory pre-release cross-repository audit

Every release follows: feature complete -> independent cross-repository audit -> severity-classified findings report -> human triage/approval -> reviewed remediation batches (with affected documentation updated in each batch) -> full regression validation -> release candidate -> final release. The cold reviewer audits both Flutter and backend for architecture boundaries, API/domain/schema drift, enums/nullability, duplication/dead code, coupling, migrations/data integrity, async lifecycle/races, retries/idempotency, errors, privacy/security/logging, secrets/configuration, deployment assumptions, performance, dependencies, tests, localization/RTL/accessibility, and release readiness. The audit precedes remediation and is not performed by the implementing author alone.

## D-019 Local classification review and browse hierarchy

**Decision:** Persist typed analysis classification metadata necessary for local review, but require the user to create or reuse confirmed Organization and Case relationships. Exact whitespace-normalized, case-insensitive names may reuse an Organization; Cases may reuse only under that Organization with the same normalization. Manual edits can clear a Case or leave a Document unclassified. **Consequences:** no fuzzy merging or fabricated Unknown records; Documents navigates Organization -> Case -> Document while keeping organization-only and unclassified documents visible. **Alternative:** copying analysis suggestions into confirmed relationships at analysis completion was rejected.
