# AI architecture

Flutter invokes product endpoints only. The backend owns an `AIProvider` port with `analyze_document`, `explain_document`, `answer_question`, `draft_reply`, and `extract_structured_data`. Provider adapters, `ModelRouter`, `PromptRegistry`, and `StructuredOutputValidator` stay server-side.

For MVP questions and reply drafts, the backend has no permanent Document resource. The client submits a minimum, operation-scoped envelope containing `client_document_id`, validated structured analysis, and only the required source evidence/text and conversation context. The client ID correlates the result to its local Document; it is not a server lookup key. Request context is temporary processing data and does not require accounts, cloud sync, or permanent original-file storage. A bounded, expiring follow-up context may retain only structured analysis, concise summary, evidence references, version, timestamps, and deletion state; it never becomes a durable server document. A future synchronized `server_resource_id` may be accepted by a separate compatible route.

## Pipeline

1. Validate the upload or scoped context, assign a `request_id`, and use a temporary processing object when asynchronous work is needed.
2. Extract text/layout as appropriate; classify/extract with a cost-conscious model route.
3. Validate the versioned structured schema; retry boundedly on transport or validation failure.
4. Escalate or fall back only under explicit route policy; return normalized partial/failed states when facts cannot be established.
5. Generate explanation in requested target language and style from validated data and source evidence. Delete temporary uploads and request context according to the retention policy.

Prompts are immutable, versioned records with purpose, input contract, output schema version, safety instructions, and evaluation fixtures. Model names are configuration, never domain values. Low-cost routes may classify/extract; stronger routes may improve explanation or difficult reasoning. Every request records provider/model configuration identifier, token/cost metrics, latency, schema/prompt version, outcome, and redacted error category—never raw document content.

## Safety, language, and reliability

Schemas require uncertainty where evidence is missing. The system must not fabricate sender, dates, legal obligations, citations, or reply facts. Explanations state that they are informational and prompt verification for consequential matters. Source language and target explanation language/style are separate parameters; extracted facts remain distinct from explanatory prose, and domain enums remain language-neutral. Vision-capable processing is the MVP strategy; on-device OCR is not a prerequisite. Fallback is bounded, idempotent where possible, timeout-controlled, and does not expose provider errors to clients.

Provider data-processing terms, retention, regional handling, and user consent must be evaluated before selection; architecture alone does not establish GDPR compliance.
