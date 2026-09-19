# Local domain data model

## Entities and relationships

The confirmed browsing hierarchy is `Organization 1--* Case 1--* Document 1--* DocumentFile`. A newly imported Document is valid without either an Organization or Case: its organization and case relationships are absent until confirmed. A Document has zero or more analyses, tasks, deadlines, appointments, amounts, required documents, and conversations. Case-level views aggregate related document facts without changing their source document. A task may be manual or analysis-suggested and may link to one Document or Case.

| Entity | Key data | Lifecycle or relationship rule |
| --- | --- | --- |
| Organization | Name, normalized name, category, contact hints | Active or archived. A category is a configurable label, not business logic. |
| Case | Organization, title, status, opened/closed dates | Active, completed, or archived. It belongs to exactly one Organization and cannot be orphaned. |
| Document | Client document ID, optional Organization/Case, classification state, type, dates, status, source language | Imported, processing, analyzed, needs review, archived, or deleted. |
| DocumentFile | Document identity, local reference, media type, stable file ID, original metadata, import source, ordered page index | Locally available, temporary processing, unavailable, or deleted. |
| ExtractedText | Document identity, text/range, extraction confidence | Available, partial, or unavailable. |
| DocumentAnalysis | Document identity, analysis versions, output language/style, typed facts, explanation, quality reasons, evidence, confidence | Complete, partial, or unavailable; locally versioned history is retained. |
| Task | Optional Case/Document relationship, title, due date, status, reminder | Open, completed, or dismissed. |
| Deadline / Appointment | Source Document, date/time range, timezone, confidence | Active, completed/past, or cancelled. |
| Amount | Value/currency, direction, due date, purpose | Active, paid/received, or uncertain. |
| RequiredDocument | Description, status, due date | Requested, obtained, submitted, or not applicable. |
| ConversationMessage | Scope, role, localized content, citations | Active or deleted. |

## Identity, provenance, and dates

Entities use opaque stable identities with creation and update timestamps. The Document's client-generated ID is its stable local identity and correlates local analysis work; transient operation or request identifiers never replace it. Provenance is `user`, `analysis`, or `system`, with optional source-analysis/version references. User corrections take precedence over suggestions while preserving provenance where it supports explainability.

Dates retain their source precision (date versus timestamp), source wording, inferred timezone when applicable, and uncertainty. A deadline or appointment retains its source excerpt/reference when available.

## Classification data invariants

On import, a Document is `unclassified` with no confirmed Organization or Case. Analysis may store Organization and Case suggestions as analysis provenance and set the state to `suggested`; it must not copy them into confirmed relationships. User acceptance or manual entry creates confirmed relationships and sets the state to `confirmed`.

A confirmed Case must belong to the confirmed Organization. An Organization-only classification is valid, and manual edits may clear a Case or leave a Document unclassified. Do not create fabricated “Unknown” Organization or Case records. A confirmed Organization always takes precedence over an AI suggestion.

Organization reuse is permitted only for exact whitespace-normalized, case-insensitive name matches. Case reuse uses the same normalization and is permitted only under that Organization. Fuzzy merging is not permitted.

## Local ownership and evolution

Original files remain locally owned by default and outside the structured local data store. The local store keeps typed domain concepts rather than loose maps, including ordered files, analyses/history, quality reasons, evidence, action facts, tasks, and non-sensitive settings. Analysis suggestions remain separate from confirmed Document relationships so they survive restart without becoming confirmed data.

Local schema evolution is explicit and forward-only; schemas are never reset or treated as disposable. Pending analysis metadata is client-owned and only correlates work to an existing Document. Persisting a new analysis version must not alter user-confirmed Organization or Case relationships.

If future synchronization is introduced, it may map a remote resource to the existing client-generated Document identity rather than replace it. It requires explicit revisions/versioning, deletion tombstones, and conflict rules, and must not silently overwrite user corrections. Uploading or permanently storing originals is a separate opt-in lifecycle, not an implication of synchronizing analysis metadata.
