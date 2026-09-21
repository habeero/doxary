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
| DocumentAnalysis | Document identity, analysis versions, output language/style, action requirement, typed facts, explanation, quality reasons, evidence, confidence | Complete, partial, or unavailable; locally versioned history is retained. `action_required` is nullable only for legacy rows created before it was persisted. |
| AnalysisAttempt | Stable attempt ID, Document identity, started/terminal timestamps, safe status/failure metadata, optional successful analysis ID | Pending, succeeded, or failed; separate from transient polling correlation. |
| Task | Optional Case/Document relationship, title, due date, status, durable reminder intent, optional non-cascading source analysis/action identity | Open, completed, or dismissed. Platform delivery is derived from the Task and is not a second durable reminder record. |
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

Original source material remains device-local by default and outside the structured local data store. The local store persists each `DocumentFile`'s typed metadata and local URI reference, not an implicit ownership guarantee: picker imports may reference an external local file and camera imports may reference a local capture file. A path alone must never be used to infer Doxary ownership. Source availability is checked when opening; an unavailable reference leaves the Document and analyses intact. The local store keeps typed domain concepts rather than loose maps, including ordered files, analyses/history, quality reasons, evidence, action facts, tasks, and non-sensitive settings. Analysis suggestions remain separate from confirmed Document relationships so they survive restart without becoming confirmed data.

Local schema evolution is explicit and forward-only; schemas are never reset or treated as disposable. The analysis-attempt-history migration backfills existing successful analysis rows and terminal operation outcomes without changing Document, Analysis, Task, or classification IDs; Task source-provenance columns are nullable for existing/manual Tasks. Pending analysis metadata is client-owned and only correlates work to an existing Document. Fresh analysis versions persist the mapped `action_required` enum token (`yes`, `no`, or `uncertain`) exactly; the forward migration leaves pre-existing rows null rather than inferring action from facts or text. Persisting a new analysis version must not alter user-confirmed Organization or Case relationships.

Completed analyses persist their supported mapped Result data locally: document date, detected language, urgency, confidence, practical states, root uncertainties, next actions, quality reasons, source references, and typed extracted deadlines, appointments, amounts, required documents, and suggested tasks. These analysis-owned child records are keyed by analysis version and remain distinct from document-level operational facts and user-confirmed Tasks. Re-saving the same analysis version replaces its analysis-owned children atomically; legacy rows without those records restore as empty/null data without inference. Attempt history retains safe success/failure outcomes without duplicating result payloads. Deleting an analysis deletes only its owned result rows and matching successful history entry; Tasks retain non-cascading provenance and Documents/DocumentFiles remain unchanged.

If future synchronization is introduced, it may map a remote resource to the existing client-generated Document identity rather than replace it. It requires explicit revisions/versioning, deletion tombstones, and conflict rules, and must not silently overwrite user corrections. Uploading or permanently storing originals is a separate opt-in lifecycle, not an implication of synchronizing analysis metadata.

## Deferred Organization display naming

Organizations currently expose their actual confirmed name. A future deliberate domain/data and AI-boundary design may add a user- or canonically-managed short display name for compact browsing. It must not be implemented as Flutter word truncation, guessed aliases, or institution-specific hardcoding. That future design must define ownership, validation, provenance, and how any AI-proposed value remains distinct from confirmed user data.

## Deferred canonical Document title

The current displayed Document title may be analysis-derived and can change after a reanalysis. Stable Document-title behavior is not implemented yet. A future Document/domain design must define one canonical user-visible title for each stable Document identity and keep it stable across repeated analysis runs. Reanalysis may provide classification or extracted-title suggestions, but it must not implicitly replace that canonical title or make the same logical Document appear to be a newly titled Document.

That design must deliberately distinguish the canonical Document title, analysis-specific extracted or classification text, and an optional user-edited title. A compact short display title, if introduced later, is a separate presentation concern and must build on this canonical-title model rather than heuristics or analysis-run-specific replacement.

## Deferred Document identity and duplicate detection

The current import flow may treat another import of the same real-world document as a new Document. A deliberate identity and duplicate-detection layer is required before imports can be linked or merged. It must distinguish an exact same file, the same logical document imported or scanned again, a related but different document, and a genuinely different document. Canonical Document identity and its user-visible title must remain independent from any single analysis run; imported source-file copies/versions and analysis-specific title or classification suggestions must remain distinct from both.

The preferred future detection pipeline is: first, a deterministic content fingerprint such as SHA-256 to recognize an exact byte-for-byte duplicate; second, a normalized-content fingerprint for rescans or re-exports with different bytes, using stable OCR/text, sender/Organization, document date, reference/account/case numbers, important amounts, document type, and party names where available; and third, conservative AI-assisted comparison only when deterministic signals are insufficient. AI comparison may classify candidates as same document, likely same document, related document, or different document, but must not automatically merge Documents solely because they appear similar.

Where identity is not certain, the user must confirm whether to attach/import the source as another copy or version of an existing Document, or treat it as a separate Document. A related document must never be collapsed merely because it shares an Organization, Case, account, or topic.
