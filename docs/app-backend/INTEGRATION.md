# Flutter/backend integration

## Boundary and transport

Flutter submits document analysis to the backend and never calls an AI provider directly. The remote port uses focused HTTP transport with centralized API configuration; widgets neither construct requests nor parse API errors. Backend DTOs are mapped at the data boundary into typed client entities before local persistence.

The development emulator endpoint is `http://10.0.2.2:5000/api/v1`; a physical device or staging environment supplies `DOXARY_API_BASE_URL`. That setting is not a credential. Debug-only cleartext HTTP is limited to developer-run backends; release, staging, and production require HTTPS/TLS.

## Submission lifecycle

One logical local Document is submitted per analysis request. The client submits its selected PDF or ordered image files through the document-analysis contract and assigns a high-entropy idempotency key for that submission attempt. The backend validates uploads, processes them temporarily, and returns an accepted operation rather than becoming the permanent owner of the original Document.

The client records a known accepted operation only as pending local correlation metadata. The temporary `operation_id` never replaces the local Document identity. On success, the validated result is mapped and persisted locally; existing persisted results are read locally and are never re-requested solely for display.

## Polling, retry, and restart recovery

The client performs bounded polling of a known operation. `accepted` and `processing` are non-terminal. A polling/status retry never creates another POST. A transient upload retry may reuse the same in-memory idempotency key for its submission attempt.

Only user-initiated reanalysis may start a new submission and idempotency key; it retains the existing local Document and its files. A terminal backend failure is surfaced as a typed, user-safe client error and must not silently resubmit. Expiry or another unrecoverable operation state is explicit and recoverable through user-initiated reanalysis.

After restart, the client resumes only known accepted or processing operations. It does not infer or rediscover unknown backend work. Completion removes the pending-operation correlation after the result has been safely persisted.

## Temporary uploads and boundary privacy

Selected files are sent only for requested analysis. Upload artifacts and assistant context are temporary, subject to documented deletion/retention policy, and do not create permanent server originals or a server Document resource. A future synchronization contract must explicitly introduce any persistent server resource or original-file lifecycle.

The client contains no secrets. Requests, errors, and diagnostics use safe correlation identifiers and must not log raw document text, names, addresses, account/insurance numbers, income, or image payloads. Upload validation is authoritative at the backend boundary; client-side file checks are only proactive UX.
