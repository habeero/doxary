# App/backend integration changelog

## 2026-09-20

- Recorded the implemented transient Processing-overlay dismissal behavior; completion notification and real cancellation remain deferred.
- Clarified restart recovery as non-terminal local-operation correlation only, including safe stale-correlation cleanup and terminal removal from active Processing.
- Recorded the deferred completion-notification and deliberate backend-cancellation contract gap.
- Added the deferred backend contract/privacy/retention hardening backlog required before release.

## 2026-09-19

- Consolidated the established versioned document-analysis contract, temporary-operation lifecycle, idempotency, polling, and recovery rules into the app/backend integration domain.
- Recorded the implemented typed HTTP client boundary, local result persistence, and privacy-safe temporary-upload expectations.
