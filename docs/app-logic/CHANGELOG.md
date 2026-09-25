# Application-logic changelog

## 2026-09-25

- Clarified the deferred permanent removal gap for failed Analysis attempts and deleted-Analysis tombstones, distinct from deleting a Document or source.
- Implemented app-owned Task reminder response handling for cold-start and running/background taps, repository-based Task resolution, and safe Tasks fallback for missing or legacy payloads.
- Added durable timestamp-based Home Needs Attention acknowledgement using the existing settings store; later failed/deleted events can resurface the alert without mutating Documents or history.

## 2026-09-24

- Added a shared local Document-browse projection for usable Analysis, processing, and latest failed/deleted lifecycle attention; Home, Documents, and Unclassified use the same persisted-state precedence.
- Clarified deleted Analysis versus failed-attempt lifecycle precedence and added protected deletion of failed attempt-history rows only.
- Added minimal Document-scoped Analysis deletion history: result payloads remain physically deleted while deletion time and prior result status survive in attempt history; added schema v11 migration without inferring older deletions.
- Refresh Document-scoped attempt history and Document state after retry errors, and migrate legacy seconds-scale attempt-history timestamps to milliseconds without rewriting existing millisecond values.
- Defined Task Editor Save validation at the application boundary: nonblank title, due date, and time unless explicitly All Day; No reminder and Document/Case/Note remain optional.

## 2026-09-23

- Defined the new local Task defaults: newly created Tasks are timed and store `reminderMinutesBefore = 0` (At time); existing persisted reminder values remain unchanged until explicitly edited.
- Corrected Result-derived date-only Task prefills so they retain the timed Create default instead of silently setting All Day; All Day remains an explicit editor choice.

## 2026-09-22

- Recorded physical-device verification of reminder selection, persistence, reconciliation, contextual Android permission, and future scheduling; notification-tap navigation and full Settings Notifications controls remain undefined/deferred.
- Clarified and regression-covered local reminder intent: `0` minutes means notify at the due time, while only `null` means no reminder; debug-only structural tracing now identifies the editor, persisted-row, and reconciler values without logging user content.
- Fixed Task Editor reminder control binding: its non-null visual option is derived from and writes directly to the one authoritative nullable reminder-minutes state, including explicit No reminder versus zero-minute selections.
- Corrected Android reminder-permission retry ownership: only a granted result is session-cached, so a later explicit Task save can reach Android again after a denied or unavailable request. Added debug-only privacy-safe trace points across Task save, reconciliation, scheduler initialization, permission request, and scheduling.

## 2026-09-21

- Finalized All Day Task reminders: 09:00 local device time on the due date is the MVP anchor, lead time applies from that anchor, and All Day/Timed transitions reconcile normally. Future Settings may make the anchor configurable.
- Implemented local Task reminder delivery through a typed platform scheduler: persistence-first reconciliation, contextual permission, safe failure outcomes, cancellation on completion/deletion, reopening re-evaluation, privacy-limited notification content, and Android reboot registration.
- Implemented read-only original-source access from the Document route: PDF sources use a typed platform opener, ordered image pages use a local viewer, and unavailable/unsupported/platform-failed references remain user-safe without changing Document or analysis state. Clarified that source-copy ownership, retention, and deletion remain deferred.
- Defined durable provenance-keyed Home action-attention handling: explicit dismiss and successfully persisted source Tasks suppress only the matching alert without changing analysis truth.
- Reclassified local reminder scheduling/delivery from an indefinite future capability to an outstanding MVP behavior; persisted reminder intent remains local metadata until implementation.

- Recorded deferred Document identity and duplicate-detection requirements: deterministic fingerprints first, conservative AI comparison only when needed, and user confirmation before uncertain linking or merging.
- Clarified deferred Document lifecycle decisions: canonical titles must remain stable across reanalysis, source-file management is not yet implemented, and future deletion distinguishes analyses, Documents, and locally owned source files.
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
