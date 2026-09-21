# UI/UX interactions

## Import and Analyze

Submission acceptance may acknowledge “Analysis started” through short-lived feedback local to the current Analyze surface. It is never durable page state, does not survive leaving Analyze, and is cleared when the draft progresses into the Document/Processing lifecycle. Loading and pre-acceptance failure feedback remain distinct; a pre-acceptance failure preserves the selected draft and shows no success acknowledgement.

When Analyze begins, the selected input becomes safely locked or cleared so repeated taps cannot create duplicate visible or logical submissions. Existing local work is not lost when transient selection is cleared. Picker cancellation is neutral; picker failures are recoverable errors that preserve the user’s work.

The import review places a compact analysis-language selector beside Analyze. It controls generated explanation language—Arabic or Einfaches Deutsch—independently from the app interface language and remains available as a user preference.

## Camera and page review

One unified Camera Review supports both one-page and multi-page capture. It owns up to ten ordered temporary pages, a selected page, and any current image edit. Add another page returns to the same Capture stage and appends the next captured page; it does not enter a second camera mode. Review supports selected-page preview, ordered thumbnails, individual removal, retake, real crop, real 90-degree rotation, and Continue. Continue transfers the ordered 1-10 images into one Analyze session draft; neither Capture nor Review creates a Document or operation. Back from Review asks whether to discard camera-owned temporary pages rather than silently transferring them. Arabic controls and thumbnail order follow inherited RTL directionality, while camera preview and captured content are not mirrored. A maintained reliable implementation is required before using automatic edge detection or perspective correction; advanced scanner filters are not required initially.

Camera Capture is a focused nested flow without bottom navigation. It owns native camera initialization, permission feedback, app-lifecycle release/resume, and disposal. Shutter releases the live preview into Review. While Review is visible, no live camera preview restarts on app resume. Only Retake, removing the final page, or Add another page deliberately returns to Capture. Each page stays camera-owned until Continue transfers the ordered selection to Analyze; superseded rotate/crop files and discarded pages are cleaned up by the camera session.

Analyze presents a camera-sourced draft as one captured document with its full ordered page set, not as a single filename. Remove clears the whole camera draft; per-page changes use Edit Pages, which reopens the existing unified Review flow rather than duplicating editing controls in Analyze. The camera card follows inherited RTL directionality while captured images remain unmirrored.

## Processing and retry

Processing uses semantic staged labels derived from observable state. It never shows invented percentages, unsupported sub-stages, or raw technical logs. Terminal technical failure offers deliberate Retry analysis where appropriate; retry is not automatic resubmission.

After a successful operation acceptance, Processing opens as a focused transient modal overlay over the current shell. Close/X and Continue in background dismiss only the overlay while the local Document/Home Processing lifecycle continues in the background. The overlay is not restored by ordinary navigation. It closes when the current operation reaches terminal success or failure, leaving the existing Result or recovery lifecycle authoritative. Cancellation remains visibly unavailable and completion notification remains deferred; the required cancellation contract is owned by [app/backend integration](../app-backend/INTEGRATION.md#processing-dismissal-and-cancellation-contract).

Initial Analyze and Retry analysis are distinct actions. Retry re-analyzes the same local Document and must not create a duplicate Document. Import as New Document is separate. For unreadable or insufficient input, retake or reselect clearer source material may be the actionable remedy instead of retrying identical input.

## Classification and search

**Current implementation status:** Classification correction semantics and their local persistence are implemented through a contextual modal. The approved searchable Organization/Case selection and minimal creation presentation is not yet aligned with the wireframes; the current inline controls are functionally usable, but the approved redesign remains pending.

Result → Change Classification uses lightweight modal or bottom-sheet selection for Organization and Case rather than needless full navigation destinations. Creating an Organization requires only a name. Creating a Case happens under an already selected Organization, cannot create an orphan Case, and makes the new Case the current selection. The user may confirm a suggestion, change it, clear a Case, or leave a Document Unclassified.

Search is contextual: Documents root searches library-relevant content; Organization searches that Organization; Unclassified searches only Unclassified Documents; and Case searches Documents in that Case. A universal standalone Search Results screen is not required.

## Result actions

**Current implementation status:** A confirmed action-required Result may open Create Task with one editable in-memory draft. The action is absent for no-action, partial, unavailable, and action-uncertain results. The handoff preserves the current Document link and prepopulates a confirmed Case only when already associated with that Document; it never infers a Case or creates a Task until the user saves. After save, the exact source analysis/action identity resolves to View Task—including completed Tasks—instead of creating a duplicate. Deleting that Task restores Create Task; manual Task creation and different actions remain unrestricted.

Required-action content receives stronger prominence than secondary explanation. Full explanation, required documents, appointments, and other secondary groups may be expandable. Important facts render only when meaningful. Original-document access is a trust action. Classification suggestions never become confirmed automatically.

## Sheets, dialogs, and focused forms

**Current implementation status:** Create/Edit Task is implemented as a focused full-screen flow rather than a primary destination. Local task persistence supports title, status, provenance, timestamps, date, All Day, optional time-of-day, reminder intent, optional note, and optional Document/Case links. Edit can mark complete without confirmation, and a completed Task can be explicitly reopened without confirmation; ordinary edits and Save do not reopen it. Delete still requires confirmation. Reminder delivery/scheduling is not implemented.

The Task interaction requirements below are approved intended behavior for future implementation.

Bottom sheets are preferred for lightweight selection and small contextual creation forms, including choosing or minimally creating an Organization/Case. Confirmation dialogs are used for consequential or destructive actions. Create/Edit Task is a focused full-screen flow rather than a primary destination.

Use the smallest interaction surface that preserves clarity and task completion. Lightweight contextual selection uses a Bottom Sheet or modal; small contextual creation/edit forms use a Bottom Sheet where appropriate; consequential or destructive confirmation uses a Dialog; and multi-step, information-dense, interruption-sensitive, or task-focused work uses a focused full-screen flow. In Doxary, Organization/Case selection and minimal Organization/Case creation use Bottom Sheets, classification correction uses a Bottom Sheet/modal, delete confirmation uses a Dialog, Processing uses its transient modal overlay, and Document Detail/Result, camera review, and Create/Edit Task remain focused full-screen flows. Do not create a full-screen route for a lightweight contextual interaction solely because navigation is convenient.

Create/Edit Task may include title, date, optional time or all-day, reminder, linked Document or Case, and optional note. When All Day is selected, time is inactive and not required. When created from a Document Result, the Document association is preserved and Organization is derived from the linked Document/Case rather than becoming a conflicting editable field. The deterministic prefill order is suggested task, next action, required-action fallback; a suggested-task date, then primary deadline, then primary appointment supplies an editable date/time only when parseable. Delete Task requires confirmation; completing a task normally does not.

## Settings and notifications

**Current implementation status:** Settings currently exposes app-language selection only. Default explanation-language persistence exists elsewhere but has no Settings control; profile/account, plan/account, notifications, appearance, privacy/data, legal, and about remain pending.

The remaining Settings and notification behavior below is approved intended behavior, not current implementation.

Settings owns local language, default explanation language, privacy, notification, appearance, profile/account, legal, and about changes. Intended notification controls have three layers: OS permission, Doxary master preference, and category preferences. Turning off the master hides or disables categories; denying OS permission is explained as a device-setting restriction. Permission is requested contextually only after its value is clear, not as an unexplained first-launch prompt.
