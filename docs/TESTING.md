# Testing strategy

Test domain entities/use cases and business rules without Flutter; test repositories against fakes and later real adapters; test Drift migrations/database behavior when introduced; test Flask schemas/services and API contracts against versioned fixtures. Contract tests ensure client-safe error formats, idempotency, pagination, and backward compatibility.

AI tests validate every schema, required/optional/unknown handling, evidence requirements, multilingual/RTL output, and no-invention rules. Prompt regression suites use redacted or synthetic German administrative fixtures and expected structured assertions, not raw production documents. Test routing, retries, timeouts, fallback, quota accounting, and safe partial failures.

Flutter testing includes localization/RTL, widget accessibility and state rendering, routing, import/result flows, reminder behavior, offline handling, and end-to-end journeys. Security/privacy tests cover log/telemetry redaction, deletion, upload validation, auth/authorization when present, secret scanning, and sensitive-content exclusion from crash/analytics payloads. Regression fixes add a focused test.

## Phase 1 coverage

Foundation tests verify that an imported document can remain unclassified, Drift schema v1 persists a local document/file, task bucketing separates Today/Upcoming/Completed, and the empty Home state localizes and renders RTL in Arabic. The test suite uses an in-memory Drift executor for persistence and repository fakes for UI isolation. Follow-up phases add actual import-adapter, notification-adapter, and remote-contract tests when implementations exist.
