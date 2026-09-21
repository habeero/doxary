# Application logic

## Boundaries and modularity

Flutter presentation contains no business logic. Domain and application logic remain independent of Flutter presentation, persistence, network, and provider implementation details. Features remain modular, with business rules defined once in domain/application code rather than duplicated across presentation or adapters. Persistence and API models do not leak into UI-facing business logic.

The device owns local Documents, structured analyses, corrections, tasks, and reminder schedules. Original files remain local by default. Local views and reminders continue to use locally persisted data; remote processing does not make server ownership or synchronization a prerequisite for core use.

Interface locale and analysis-explanation language are separate persisted local preferences. On first use, the explanation preference defaults from the effective interface locale; an explicit explanation-language choice is not silently overwritten when interface labels change.

Platform-dependent import and reminder capabilities are accessed through typed application ports. When a capability is unavailable, its state is explicit; the application does not fabricate a successful import or scheduled reminder.

## Document lifecycle

Document-first processing saves the local Document and its selected file references before analysis. Import does not require a prior Organization or Case. A document may progress through imported, processing, analyzed, needs-review, archived, and deleted states; classification is tracked independently as unclassified, suggested, or confirmed.

Analysis results are persisted as a new typed local analysis version. Existing results are read locally; reopening a result must not itself initiate another analysis. Optional result sections may be absent, but complete, partial, and unavailable remain explicit outcomes. Result presentation selects `partial` before action state; a complete result with `action_required: uncertain` remains complete and receives action-specific review guidance. An unavailable result is corrective-input recovery only for `blurry_image`, `page_cut_off`, `unreadable_text`, `missing_pages`, or `insufficient_content`; `unsupported_file` and `corrupt_file` use a distinct truthful input-problem state.

If analysis is unavailable, partial, or fails, the local Document and its originals remain available. Classification failure leaves the Document unclassified and analyzable. A terminal failure moves the Document to needs review and is surfaced as a typed, user-safe error. Failure never deletes a local Document or invents classification data.

## Analyze session draft

Analyze input is a session draft. It may survive temporary root navigation before submission, is consumed when the backend operation is accepted, and is retained only when submission fails before acceptance. It is not permanently persisted. After acceptance, selected-input UI and its CTA are cleared; ongoing work belongs to the local Document and Processing lifecycle rather than the Analyze draft.

Camera Capture precedes the Analyze session draft. Its shutter produces a temporary camera-owned candidate, not a Document, file reference, session draft, or analysis operation. The same focused flow holds an ordered temporary set of one to ten accepted pages, the selected review page, and any current shutter candidate. Add another page accepts the current candidate and returns through the same Capture stage to append the next page. Retake of a current candidate discards only that candidate and preserves accepted pages. Retake of an accepted page begins a replacement at its existing index; the original remains owned until a replacement candidate is accepted, and abandoning replacement restores the original unchanged. Page removal discards the requested accepted page; confirmed Back discards the camera-owned flow. Crop and rotate deliberately replace only the selected candidate and clean up superseded files. Only Continue transfers the ordered pages into the existing Analyze session draft; normal submission rules then apply.

An Analyze camera draft is identified from its `ImportSource.camera` selection data, never filenames. Edit Pages reopens unified Camera Review with camera-owned working copies: cancel/back discards only those working copies and preserves the original Analyze draft; Continue deliberately replaces the draft and releases its superseded original files. Remove clears the complete camera draft. Neither editing nor removing creates a Document or operation; normal Analyze submission remains the boundary that creates the ordered local Document files and analysis operation.

Camera startup is single-flight and serializes initialization, resume, pause, and disposal; stale lifecycle completions cannot replace the current Capture state. Capture switches presentation to Review before releasing its controller, so no mounted CameraPreview can reference a disposed controller.

Document capture prefers the physical rear-facing camera and uses `ResolutionPreset.max` with audio disabled: Doxary must not intentionally constrain readable document stills to a 1280x720-quality pipeline, upscale low-resolution images, or add artificial sharpening. **Deferred pre-release camera-quality and zoom investigation:** real Samsung S22 document captures remain below expected quality despite this policy. Native pinch zoom was prototyped and then temporarily removed after real-device testing showed poor gesture behavior and CameraX/session instability, including `Surface is NULL` and `GRAPH_ERROR` camera-session failures. Before release, deliberately verify final JPEG pixel dimensions after `takePicture()`, selected physical rear lens, autofocus/focus-distance behavior, CameraX/plugin device behavior, image format/compression, preview-versus-still resolution, device-specific behavior, and whether another capture strategy is needed. Evaluate a stable native zoom strategy separately, including update throttling/coalescing, restoring default zoom across session recreation, and whether `CameraController` or another capture strategy is suitable. Zoom is deferred, not permanently cancelled. A prior 1280x720 log is not evidence of final JPEG dimensions until verified.

## Classification confirmation and correction

AI classification is a suggestion, not a confirmed Organization or Case relationship. The user can accept, edit, reject, clear, or manually create/reuse the relationship. Only user acceptance or manual input changes confirmed classification. Confirmed relationships are preserved when a new analysis is persisted.

The Organization → Case → Document hierarchy governs confirmed browsing, while organization-only and unclassified Documents remain visible. The exact reuse rules and relationship invariants are defined in [DATA_MODEL.md](DATA_MODEL.md).

## Actions, tasks, and reminders

Analysis-derived facts retain their source Document. Tasks may be suggested or manual and may be connected to a Document or Case. Deadlines, appointments, amounts, and required documents retain typed state and source information. A user can create or accept tasks and mark work complete; suggestions remain editable.

Local Tasks persist title, status, provenance, timestamps, required date, explicit All Day state, optional time-of-day, optional reminder intent in minutes before the task, optional note, and optional Document/Case links. All Day clears time-of-day. Reminder intent is durable local metadata only: OS notification scheduling/delivery remains a future capability and must not be implied by the stored value. Deleting a Task removes its local record after user confirmation; completion retains it for the Completed bucket.

## Retry and reanalysis

Retrying unavailable or failed analysis, polling for accepted work, or resuming known in-progress work must never create a duplicate local Document. Reanalysis is user initiated and retains the existing local files and Document identity while producing a new analysis version. A retry of status observation does not create a second analysis submission; only explicit reanalysis starts new analysis work.

Local pending-work state is recoverable after restart only when the local Document and pending correlation are known. Expired or otherwise unrecoverable work remains explicit and recoverable by user-initiated reanalysis.

## Processing lifecycle

Processing is derived only from non-terminal accepted operations locally correlated to a Document that is still processing. Terminal success or failure removes an operation from the active-processing set while the Document itself remains in its appropriate lifecycle state: a successful result is persisted locally, and a terminal failure remains available in needs review for recovery. Startup resumes only these known non-terminal correlations; it safely clears a correlation that conflicts with an already terminal local Document, without fabricating an unknown completion. Repeated identical polling states do not rewrite local Document metadata or cause unrelated Home content to reload.

## Deletion and future synchronization

Deleting a Document removes derived local items only after user confirmation, or linked records become explicitly orphaned/manual according to a future interaction decision. A future synchronization capability must use explicit conflict handling and must not silently replace local user corrections.
