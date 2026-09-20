# UI/UX interactions

## Import and Analyze

Submission acceptance may acknowledge “Analysis started” through short-lived feedback local to the current Analyze surface. It is never durable page state, does not survive leaving Analyze, and is cleared when the draft progresses into the Document/Processing lifecycle. Loading and pre-acceptance failure feedback remain distinct; a pre-acceptance failure preserves the selected draft and shows no success acknowledgement.

When Analyze begins, the selected input becomes safely locked or cleared so repeated taps cannot create duplicate visible or logical submissions. Existing local work is not lost when transient selection is cleared. Picker cancellation is neutral; picker failures are recoverable errors that preserve the user’s work.

The import review places a compact analysis-language selector beside Analyze. It controls generated explanation language—Arabic or Einfaches Deutsch—independently from the app interface language and remains available as a user preference.

## Camera and page review

Single-page review supports retake, accept/use image, crop, and rotate. Multi-page review supports ordered thumbnails, selected-page preview, individual removal, remove-all, adding another page, and continuing up to 10 pages/images. A maintained reliable implementation is required before using automatic edge detection or perspective correction; advanced scanner filters are not required initially.

Camera Capture is a focused nested flow without bottom navigation. It owns native camera initialization, permission feedback, app-lifecycle release/resume, and disposal. Shutter releases the live preview into single-photo Review. Review displays the captured file, may rotate the actual temporary file by 90 degrees, and owns it until the user chooses Retake, Back, or Use photo. Retake and Back discard the candidate and resume Capture; Use photo transfers it to the existing Analyze session draft. Neither Capture nor Review creates a Document or operation. Crop is deferred until a truthful editing implementation is available.

## Processing and retry

Processing uses semantic staged labels derived from observable state. It never shows invented percentages, unsupported sub-stages, or raw technical logs. Terminal technical failure offers deliberate Retry analysis where appropriate; retry is not automatic resubmission.

After a successful operation acceptance, Processing opens as a focused transient modal overlay over the current shell. Close/X and Continue in background dismiss only the overlay while the local Document/Home Processing lifecycle continues in the background. The overlay is not restored by ordinary navigation. It closes when the current operation reaches terminal success or failure, leaving the existing Result or recovery lifecycle authoritative. Cancellation remains visibly unavailable and completion notification remains deferred; the required cancellation contract is owned by [app/backend integration](../app-backend/INTEGRATION.md#processing-dismissal-and-cancellation-contract).

Initial Analyze and Retry analysis are distinct actions. Retry re-analyzes the same local Document and must not create a duplicate Document. Import as New Document is separate. For unreadable or insufficient input, retake or reselect clearer source material may be the actionable remedy instead of retrying identical input.

## Classification and search

Result → Change Classification uses lightweight modal or bottom-sheet selection for Organization and Case rather than needless full navigation destinations. Creating an Organization requires only a name. Creating a Case happens under an already selected Organization, cannot create an orphan Case, and makes the new Case the current selection. The user may confirm a suggestion, change it, clear a Case, or leave a Document Unclassified.

Search is contextual: Documents root searches library-relevant content; Organization searches that Organization; Unclassified searches only Unclassified Documents; and Case searches Documents in that Case. A universal standalone Search Results screen is not required.

## Result actions

Required-action content receives stronger prominence than secondary explanation. Full explanation, required documents, appointments, and other secondary groups may be expandable. Important facts render only when meaningful. Original-document access is a trust action. Classification suggestions never become confirmed automatically.

## Sheets, dialogs, and focused forms

Bottom sheets are preferred for lightweight selection and small contextual creation forms, including choosing or minimally creating an Organization/Case. Confirmation dialogs are used for consequential or destructive actions. Create/Edit Task is a focused full-screen flow rather than a primary destination.

Use the smallest interaction surface that preserves clarity and task completion. Lightweight contextual selection uses a Bottom Sheet or modal; small contextual creation/edit forms use a Bottom Sheet where appropriate; consequential or destructive confirmation uses a Dialog; and multi-step, information-dense, interruption-sensitive, or task-focused work uses a focused full-screen flow. In Doxary, Organization/Case selection and minimal Organization/Case creation use Bottom Sheets, classification correction uses a Bottom Sheet/modal, delete confirmation uses a Dialog, Processing uses its transient modal overlay, and Document Detail/Result, camera review, and Create/Edit Task remain focused full-screen flows. Do not create a full-screen route for a lightweight contextual interaction solely because navigation is convenient.

Create/Edit Task may include title, date, optional time or all-day, reminder, linked Document or Case, and optional note. When All Day is selected, time is inactive and not required. When created from a Document Result, the Document association is preserved and Organization is derived from the linked Document/Case rather than becoming a conflicting editable field. Delete Task requires confirmation; completing a task normally does not.

## Settings and notifications

Settings owns local language, default explanation language, privacy, notification, appearance, profile/account, legal, and about changes. Intended notification controls have three layers: OS permission, Doxary master preference, and category preferences. Turning off the master hides or disables categories; denying OS permission is explained as a device-setting restriction. Permission is requested contextually only after its value is clear, not as an unexplained first-launch prompt.
