# AI output schemas

All schemas are JSON objects with `schema_version`, `analysis_status` (`complete`, `partial`, `unavailable`), `confidence` (0–1), `uncertainties[]`, and evidence references where source text supports a claim. Required fields remain present; unknown optional facts are `null` or omitted as specified. An AI must never substitute a guess for an unavailable fact.

AI outputs use `client_document_id` only for MVP document correlation. `operation_id` and `request_id` belong to the API processing/observability envelope, while `server_resource_id` is reserved for future sync; their definitions are authoritative in `API_CONTRACT.md`.

## DocumentAnalysis v1

Required: `client_document_id`, `detected_language` (or `undetermined`), `summary`, `explanation`, `action_required` (`yes|no|uncertain`), `urgency` (`low|normal|high|critical|uncertain`), `practical_states[]`, `confidence`, `warnings[]`, `uncertainties[]`. Optional: `organization_suggestion` `{name, category, confidence}`, `document_type`, `document_date`, `case_suggestion`, `deadlines[]`, `appointments[]`, `amounts[]`, `required_documents[]`, `suggested_tasks[]`, `source_references[]`.

`client_document_id` is the stable opaque identifier supplied by the client for its local Document. It is the correlation value for the response and never implies a persisted server resource. A returned organization or case is a suggestion, not a confirmed relationship.

`practical_states` is a non-exclusive set: `informational`, `action_required`, `appointment`, `payment`, `documents_required`.

## Nested values

- **Deadline:** required `label`, `date_or_range`, `confidence`; optional `time`, `timezone`, `source_reference`, `consequence`.
- **Appointment:** required `label`, `start_or_date`, `confidence`; optional `end`, `location`, `remote_details`, `preparation`, `source_reference`.
- **Amount:** required `value`, `currency`, `direction` (`pay|receive|unknown`), `confidence`; optional `due_date`, `purpose`, `payment_reference`, `source_reference`.
- **RequiredDocument:** required `description`, `confidence`; optional `due_date`, `submission_method`, `source_reference`.
- **SuggestedTask:** required `title`, `confidence`; optional `due_date`, `linked_deadline_reference`, `instructions`, `source_reference`.
- **Warning:** required `code`, `message`, `severity`; optional `source_reference`. Codes distinguish ambiguity, unreadable input, potential deadline, and verification need.

## Assistant schemas

**QuestionAnswer v1** requires `client_document_id`, `answer`, `answer_language`, `confidence`, `uncertainties[]`, and `source_references[]`; optional `suggested_next_steps[]`. It answers only from client-supplied scoped document/case context and explicitly says when that context does not contain the answer.

**ReplyDraft v1** requires `client_document_id`, `german_draft`, `purpose`, `assumptions[]`, `missing_information[]`, and `confidence`; optional `arabic_explanation`, `subject`, `attachments_to_include[]`. It must not claim events, identity facts, or documents not supplied by the user/context.
