# API contract

## Versioning and conventions

The base path is `/api/v1`. Additive changes remain backward compatible within v1 when practical; breaking schema changes use a versioned contract and explicit deprecation path. JSON uses lower_snake_case, ISO-8601 dates/timestamps, opaque identifiers, and explicit schema versions.

Authentication is initially an implementation assumption: anonymous/device-scoped access may be used only with abuse controls, while future account tokens use `Authorization: Bearer`. Clients never receive AI-provider credentials.

## Public identifiers

- `client_document_id` is the stable opaque client-supplied correlation value for a local Document; it does not imply a server resource.
- `operation_id` is a temporary opaque identifier for asynchronous analysis work and is used only with `/operations/{operation_id}`.
- `request_id` correlates one API request and is propagated only to privacy-safe observability.
- `server_resource_id` is reserved for a future persisted/synchronized backend resource. MVP document and assistant operations neither issue nor require it.

## Routes

| Endpoint | Purpose |
| --- | --- |
| `POST /api/v1/document-analyses` | Receive a validated temporary upload and accept or queue analysis correlated to a local Document. |
| `GET /api/v1/operations/{operation_id}` | Poll asynchronous analysis work. |
| `POST /api/v1/assistant/questions` | Answer from a client-supplied, minimally scoped context envelope. |
| `POST /api/v1/assistant/draft-reply` | Generate a German reply draft from such an envelope. |
| `GET /api/v1/config` | Fetch non-sensitive remote flags/configuration. |
| `GET /api/v1/health` | Return service health without sensitive diagnostics. |

## Document-analysis submission and operation status

`POST /api/v1/document-analyses` is multipart. It accepts repeated `files` parts plus `client_document_id`, `output_language` (`ar|de`), `output_style` (`standard|simple`, with `simple` limited to German), `input_kind` (`pdf|images`), and an `Idempotency-Key` header. Image submissions include one repeated `page_indexes` value per file, contiguous from zero. A PDF has exactly one file and no page indexes.

The accepted response is `202 {operation_id,status:accepted,request_id}`. `GET /api/v1/operations/{operation_id}` exposes `accepted`, `processing`, `succeeded`, or `failed`. `succeeded` carries the validated public `AnalysisResult v1`; expiry returns `410 operation_expired`. The public result is mapped at the client data boundary; raw provider JSON is never exposed to Flutter domain or presentation.

An idempotency key is required when retry could duplicate work. Mutation endpoints added later follow the same rule when retries can duplicate work. File, analysis, and message mutations remain client-safe and versioned.

## Assistant context contract

Assistant operations use a `context` envelope, not a server-document path. Questions and reply drafts require `client_document_id`, `target_language`, and optional validated local `analysis`, `source_evidence`, and `conversation_context`; questions additionally require `question`, and drafts may accept `purpose` and `user_instructions`. Evidence and conversation context are limited to the excerpts/turns needed for the request.

An optional `follow_up_context_id` identifies only a bounded, expiring server cache of that context. It contains no original image/PDF, is deletable by policy, is not a `server_resource_id`, and creates no permanent Document. Responses include `request_id` and use the API's versioned public schemas.

## Errors and collection contracts

Errors have `{error:{code,message,retryable,details?},request_id}`. Details are safe and field-level; they never expose provider internals. Established codes include `invalid_file`, `unsupported_media`, `too_large`, `rate_limited`, `quota_exceeded`, `processing_failed`, `analysis_unavailable`, `validation_failed`, and `unauthorized`.

Future list endpoints use cursor pagination: `?limit=...&cursor=...` with `{items,next_cursor}`. Requests accept or receive `X-Request-ID`; services propagate it only to privacy-safe logs.
