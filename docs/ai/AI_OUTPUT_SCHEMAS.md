# AI output schemas

All schemas are JSON objects with an explicit `schema_version`, typed values, and validation before client-facing use. Required fields remain present; unknown optional facts are `null` or omitted as specified. Schema changes are additive and compatible where practical; breaking changes require a versioned schema.

## Common analysis constraints

`analysis_status` is `complete`, `partial`, or `unavailable`. All analysis output includes confidence from 0 to 1, `uncertainties[]`, and evidence references whenever source material supports a claim. An unavailable fact must not be replaced with a guess.

Facts, explanation, evidence, and quality/uncertainty are distinct values. A Document identifier is only an opaque correlation value, never proof of a permanent server resource. Organization and Case outputs are suggestions/provenance, not confirmed relationships.

## DocumentAnalysis v1

Required fields are `client_document_id`, `analysis_status`, `detected_language` (or `undetermined`), `action_required` (`yes|no|uncertain`), `urgency` (`low|normal|high|critical|uncertain`), `confidence`, `warnings[]`, `uncertainties[]`, and typed `quality_reasons[]`.

`extracted_facts` and `explanation` are separate. Explanation includes `output_language` (`arabic|german`) and `explanation_style` (`standard|simple`). Optional typed fields include `summary`, Organization/Case suggestions, document facts, action facts, and `source_references[]` with `reference_id`, `page_number?`, `file_id?`, and `excerpt_label?`.

`quality_reasons` is limited to `blurry_image`, `page_cut_off`, `unreadable_text`, `missing_pages`, `unsupported_file`, `corrupt_file`, and `insufficient_content`. These are semantic quality outcomes, distinct from technical processing failures. `practical_states` is a non-exclusive set of `informational`, `action_required`, `appointment`, `payment`, and `documents_required`.

## Nested values

- **Deadline:** required `label`, `date_or_range`, `confidence`; optional `time`, `timezone`, `source_reference`, `consequence`.
- **Appointment:** required `label`, `start_or_date`, `confidence`; optional `end`, `location`, `remote_details`, `preparation`, `source_reference`.
- **Amount:** required `value`, `currency`, `direction` (`pay|receive|unknown`), `confidence`; optional `due_date`, `purpose`, `payment_reference`, `source_reference`.
- **RequiredDocument:** required `description`, `confidence`; optional `due_date`, `submission_method`, `source_reference`.
- **SuggestedTask:** required `title`, `confidence`; optional `due_date`, `linked_deadline_reference`, `instructions`, `source_reference`.
- **Warning:** required `code`, `message`, `severity`; optional `source_reference`. Codes distinguish ambiguity, unreadable input, potential deadline, and verification need.

## Implemented analysis-result compatibility

The implemented `analysis_result.v1` public result does not emit nested confidence fields for extracted facts; Flutter preserves those domain fields as nullable rather than fabricating scores. Wire quality is represented by `quality_issues` rather than `quality_reasons`. Evidence references retain `file_id`, `page_number`, `page_index`, `location`, `excerpt`, and `provenance` when present.

## Assistant outputs

**QuestionAnswer v1** requires `client_document_id`, `answer`, `answer_language`, `confidence`, `uncertainties[]`, and `source_references[]`; `suggested_next_steps[]` is optional. It answers only from the supplied scoped document/case context and explicitly states when that context lacks the answer.

**ReplyDraft v1** requires `client_document_id`, `german_draft`, `purpose`, `assumptions[]`, `missing_information[]`, and `confidence`; `arabic_explanation`, `subject`, and `attachments_to_include[]` are optional. It must not claim events, identity facts, or documents absent from the supplied context.
