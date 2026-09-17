# Testing strategy

Test domain entities/use cases and business rules without Flutter; test repositories against fakes and later real adapters; test Drift migrations/database behavior when introduced; test Flask schemas/services and API contracts against versioned fixtures. Contract tests ensure client-safe error formats, idempotency, pagination, and backward compatibility.

AI tests validate every schema, required/optional/unknown handling, evidence requirements, multilingual/RTL output, and no-invention rules. Prompt regression suites use redacted or synthetic German administrative fixtures and expected structured assertions, not raw production documents. Test routing, retries, timeouts, fallback, quota accounting, and safe partial failures.

Flutter testing includes localization/RTL, widget accessibility and state rendering, routing, import/result flows, reminder behavior, offline handling, and end-to-end journeys. Security/privacy tests cover log/telemetry redaction, deletion, upload validation, auth/authorization when present, secret scanning, and sensitive-content exclusion from crash/analytics payloads. Regression fixes add a focused test.

## Phase 1 coverage

Foundation tests verify that an imported document can remain unclassified, Drift schema v1 persists a local document/file, task bucketing separates Today/Upcoming/Completed, and the empty Home state localizes and renders RTL in Arabic. The test suite uses an in-memory Drift executor for persistence and repository fakes for UI isolation. Follow-up phases add actual import-adapter, notification-adapter, and remote-contract tests when implementations exist.

## Phase 2.6 coverage

Unit tests use an injected HTTP transport and never call the backend or OpenAI. They verify multipart field names, repeated ordered image page indexes, output language/style, idempotency headers, accepted parsing, expired-result handling, DTO-to-domain mapping, and completion persistence into a new local analysis version without changing a confirmed document relationship. Polling tests use an injected delay and deterministic fake responses. Locale tests cover Arabic device-locale bootstrap, explicit persisted UI overrides, and an independently persisted analysis-language choice. The opt-in local E2E procedure remains separate from normal tests.

Picker tests should exercise the import port with fakes; the production adapter uses the native document provider and is not exercised through brittle system-picker UI tests. PDF selection produces one logical DocumentFile, while multi-image selection produces ordered pages in one logical Document. Cancellation is a neutral outcome; picker failures are typed recoverable errors.

Result presentation tests cover local latest-analysis reads, complete/partial/unavailable statuses, Arabic and German/simple explanation metadata, absent optional sections, and document navigation to the persisted result without a remote request.

Documents-library tests cover an unbounded non-deleted list, bounded Home recents, readable non-ID titles, unclassified visibility, confirmed Organization -> Case navigation, non-promoting persisted AI suggestions, conservative Organization/Case reuse, organization-only classification, original-file metadata, and Arabic RTL labels. Schema v4 migration coverage verifies persisted classification metadata. The original-file viewer remains deferred until an approved adapter exists.
