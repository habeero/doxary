# App/backend integration testing

Unit and contract tests use an injected HTTP transport and never call the backend or an AI provider. Versioned fixtures verify client-safe error formats, idempotency, pagination, and backward compatibility.

## Required coverage

- Multipart submission: field names, repeated ordered image page indexes, PDF versus images rules, output language/style, idempotency headers, accepted-response parsing, and DTO-to-domain mapping.
- Operation lifecycle: deterministic bounded polling of `accepted`, `processing`, `succeeded`, and `failed`; expiry handling; terminal error mapping; and persistence only after a validated success.
- Retry and recovery: a transient upload retry may reuse its in-memory key; status retry does not create another POST; reanalysis uses a new submission/key; restart resumes only known accepted/processing work.
- Contract safety: temporary identifiers do not become local identities, provider internals never reach client-facing errors, request IDs and diagnostics remain privacy-safe, and additive v1 changes preserve compatibility.

The opt-in local integration check remains separate from normal tests. It uses synthetic or non-sensitive PDF/image fixtures and verifies upload, operation polling, result persistence, and restart recovery against a developer-run backend.
