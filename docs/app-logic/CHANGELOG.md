# Application-logic changelog

## 2026-09-21

- Established independent Document/Analysis lifecycles: successful versions and safe failed-attempt history are retained per Document, while active operation correlation remains transient; analysis deletion preserves Documents, files, classification, and Tasks.
- Added non-cascading Result-action Task provenance and source-action idempotency; an existing source Task is reopened rather than duplicated.
- Defined the future separate Document/source-file deletion decision and its required distinctions.
- Defined local-calendar Task grouping (Overdue/Today/Upcoming/Completed) and explicit reopen semantics that preserve Task metadata and due date.
- Added the ephemeral Result-to-Task draft boundary: deterministic analysis prefill is editable, preserves authoritative Document/Case IDs, and never persists or creates a Task before explicit Save.
- Added durable local Task form state: explicit All Day, optional time-of-day, reminder intent, note, and deletion, with reminder delivery deliberately deferred.
- Defined Analyze camera-draft editing ownership: Review uses working copies, cancel preserves the original draft, Continue replaces it, and only submission creates a Document or operation.
- Deferred native pinch zoom and Samsung S22 camera-quality investigation after real-device CameraX/session instability; stable camera lifecycle remains the release prerequisite.
- Refined unified Camera Review Retake into candidate discard versus in-place accepted-page replacement, and set document capture to rear-camera maximum resolution with audio disabled.
- Defined unified Camera Review temporary-page ownership: one-to-ten ordered pages remain camera-owned through real crop/rotate, removal, retake, and discard, and transfer only on Continue into one Analyze session draft.
- Serialized first-open camera lifecycle transitions and made initial startup single-flight, preventing a resumed callback from racing controller initialization.
- Corrected the Capture-to-Review controller lifecycle: Review detaches CameraPreview before the capture session releases its controller.

## 2026-09-20

- Defined Camera Review ownership: capture candidates stay temporary through Retake/Back, and only Use photo promotes them to the existing Analyze session draft without creating a Document or operation.
- Defined first-stage camera capture as a temporary candidate before Review, with no Document, session draft, or operation created by shutter capture itself.
- Defined Processing as the non-terminal accepted-operation set, with safe startup cleanup of stale correlations and idempotent polling persistence that does not refresh unrelated Home content.
- Established Analyze input as a non-persistent session draft: it survives temporary navigation before submission, is consumed at backend acceptance, and is retained only for pre-acceptance failure.
- Added normalized, analysis-owned local persistence for mapped Result facts, next actions, uncertainties, suggested tasks, and semantic metadata; analysis suggestions remain separate from user-owned operational records.
- Added forward-only local persistence for `DocumentAnalysis.action_required`; legacy analysis rows retain a null value rather than inferred action state.

## 2026-09-20

- Established result-state selection: complete action uncertainty remains complete, partial takes precedence over action state, and unavailable quality reasons distinguish corrective unreadable input from unsupported/corrupt input problems.

## 2026-09-19

- Consolidated the established local domain model, classification invariants, document lifecycle, and regression expectations into the application-logic domain.
- Recorded deferred deliberate Organization short-display-name modeling; no UI heuristic or aliasing is authorized.
- Recorded the implemented local-first document-analysis behavior: durable local identity, typed persisted analysis versions, non-promoting suggestions, and duplicate-safe reanalysis.
