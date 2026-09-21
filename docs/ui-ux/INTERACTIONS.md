# UI/UX interactions

## Import and Analyze

## Home attention

Action-required Home cards are dismissible attention items. A locally persisted dismissal, or successful persistence of a Task with the exact analysis/source-action provenance, removes only that card from Home; it does not rewrite the analysis, delete the Document, or remove it from Recent Documents. Existing open and completed source Tasks suppress the corresponding unresolved alert, while a later actionable analysis may surface a new one.

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

**Current implementation status:** Classification correction semantics and local persistence are implemented through a contextual modal. Field changes are draft-only until Save, and Close/X discards them. 10B provides a focused searchable Organization selector with local trimmed case-insensitive name matching and selected-state indication. Its nested Create Organization modal requires a trimmed name, reuses an exact normalized match, otherwise creates only the Organization entity, and returns it to the 10A draft without classifying the Document. 10C provides the corresponding locally searched Case selector, scoped to the selected draft Organization, with No Case and Create Case actions. Its nested Create Case modal inherits that immutable Organization, requires a trimmed title, reuses an exact normalized match only within that Organization, otherwise creates only the Case entity, and returns it to the 10A draft without classifying the Document.

Result → Change Classification uses a focused modal above the current Document/Result rather than a permanent destination. Organization selection opens a focused searchable modal over that draft and returns a real Organization without persisting classification; Close/X retains the prior draft selection. Create Organization opens as a nested focused modal: cancellation creates nothing, a normalized exact existing name is reused, and a successful new Organization returns through selection to the 10A draft. Case selection opens an equivalent focused modal only after an Organization is selected, lists only Cases belonging to that Organization, and returns either a real Case or No Case to the draft. No Case preserves Organization and is distinct from Clear Classification. Create Case opens as a nested focused modal with immutable human-readable Organization context: cancellation creates nothing, a normalized exact title is reused only within that Organization, and a successful new Case returns through selection to the 10A draft. Values are human-readable and bounded for long labels. The user may confirm a suggestion, change it, remove only a Case association, or leave a Document Unclassified; selection changes commit only through explicit Save.

Search is contextual: Documents root searches library-relevant content; Organization searches that Organization; Unclassified searches only Unclassified Documents; and Case searches Documents in that Case. A universal standalone Search Results screen is not required.

## Result actions

**Current implementation status:** A confirmed action-required Result may open Create Task with one editable in-memory draft. The action is absent for no-action, partial, unavailable, and action-uncertain results. The handoff preserves the current Document link and prepopulates a confirmed Case only when already associated with that Document; it never infers a Case or creates a Task until the user saves. After save, the exact source analysis/action identity resolves to View Task—including completed Tasks—instead of creating a duplicate. Deleting that Task restores Create Task; manual Task creation and different actions remain unrestricted.

Required-action content receives stronger prominence than secondary explanation. Full explanation, required documents, appointments, and other secondary groups may be expandable. Important facts render only when meaningful. Original-document access is a trust action. Classification suggestions never become confirmed automatically.

## Sheets, dialogs, and focused forms

**Current implementation status:** Create/Edit Task is implemented as a focused full-screen flow rather than a primary destination. Local task persistence supports title, status, provenance, timestamps, date, All Day, optional time-of-day, reminder intent, optional note, and optional Document/Case links. Timed reminders schedule locally after a successful save; All Day reminders use the MVP 09:00 local due-date anchor. A safe localized message explains a denial, unavailable capability, past instant, or failure without undoing the save. The future Settings default-anchor preference is not implemented. Edit can mark complete without confirmation, and a completed Task can be explicitly reopened without confirmation; ordinary edits and Save do not reopen it. Delete still requires confirmation.

The Task interaction requirements below are approved intended behavior for future implementation.

Bottom sheets are preferred for lightweight selection and small contextual creation forms, including choosing or minimally creating an Organization/Case. Confirmation dialogs are used for consequential or destructive actions. Create/Edit Task is a focused full-screen flow rather than a primary destination.

Use the smallest interaction surface that preserves clarity and task completion. Lightweight contextual selection uses a Bottom Sheet or modal; small contextual creation/edit forms use a Bottom Sheet where appropriate; consequential or destructive confirmation uses a Dialog; and multi-step, information-dense, interruption-sensitive, or task-focused work uses a focused full-screen flow. In Doxary, Organization/Case selection and minimal Organization/Case creation use Bottom Sheets, classification correction uses a Bottom Sheet/modal, delete confirmation uses a Dialog, Processing uses its transient modal overlay, and Document Detail/Result, camera review, and Create/Edit Task remain focused full-screen flows. Do not create a full-screen route for a lightweight contextual interaction solely because navigation is convenient.

Create/Edit Task may include title, date, optional time or all-day, reminder, linked Document or Case, and optional note. When All Day is selected, time is inactive and not required. When created from a Document Result, the Document association is preserved and Organization is derived from the linked Document/Case rather than becoming a conflicting editable field. The deterministic prefill order is suggested task, next action, required-action fallback; a suggested-task date, then primary deadline, then primary appointment supplies an editable date/time only when parseable. Delete Task requires confirmation; completing a task normally does not.

## Settings and notifications

**Current implementation status:** Settings is a bottom-navigation root with Account, Language, Notifications, Appearance, Privacy & Data, Legal, and About sections. Its app-language value row opens a focused sheet, applies the existing persisted locale preference immediately, and closes without changing state when dismissed. Default explanation-language persistence exists elsewhere but has no Settings control; profile/account, plan/account, notifications, appearance, privacy/data, legal, and about are visible but currently unavailable and non-navigating. These are pre-release implementation gaps, not permanent post-MVP placeholders.

The remaining Settings and notification behavior below is approved intended behavior and required pre-release work, not current implementation.

Settings owns local language, default explanation language, privacy, notification, appearance, profile/account, legal, and about changes. The visible hierarchy must not ship with permanent unavailable rows: before public launch, each visible capability must become functional or be removed from the launch UI through an explicit product decision. The current direction is to implement the visible capabilities.

### Account

Account behavior requires a deliberate product design consistent with the final monetization and account model. The visible Account capability must become real before launch if it remains in the launch UI; its presence does not by itself establish that an account is required before the commercial model is decided.

### Language

App-language behavior is implemented. Settings must eventually expose the approved default explanation-language control while preserving the existing independent UI-language and analysis-output-language preferences, current persisted behavior, and the rule that changing a preference never silently rewrites prior analysis content.

### Notifications

Notifications must become real before launch, including the intended notification model and local reminder scheduling/delivery. Push infrastructure is not required for the MVP unless separately approved. Intended controls have three layers: OS permission, a Doxary master preference, and category preferences. Turning off the master hides or disables categories; denying OS permission is explained as a device-setting restriction. Permission is requested contextually only after its value is clear, not as an unexplained first-launch prompt.

### Appearance

Appearance must have real behavior before launch if it remains in the launch UI. Light mode and `#F8FAFC` remain the current visual baseline. Dark mode has no approved production palette, so it requires a dedicated design and implementation task rather than being represented as already supported.

### Privacy & Data

Privacy & Data must become functional before launch and align with local-first ownership and the future source-file/Document lifecycle. Required behavior areas include local document/source visibility, data management, clear distinctions between deleting analyses, Documents, and locally owned source copies, retention information, and AI-processing/data-handling transparency. Deletion behavior must be deliberately designed and implemented; this document does not fabricate a deletion policy.

### Legal

Legal must become functional before launch through approved release/legal work. Actual Privacy Policy, Terms, and required disclosures must be supplied through that work; no legal text or URLs are invented here.

### About

About must become functional before launch and show real application/version information. Version and build values must come from the actual application metadata rather than hard-coded fake values.

## Deferred product-design follow-ups

### Local reminder notification tap destination

Local Task reminder delivery exists, but the product behavior after tapping a delivered notification is deliberately undefined. No deep link, notification-payload navigation, Task or Document route launch, or notification-center behavior is implemented or implied. The next product-design decision must consider opening the linked Task directly, preserving normal app/navigation state, deleted or stale Tasks, Arabic/German navigation, and cold-start versus already-running app behavior. Do not infer a final destination from the current scheduling implementation.

### Create/Edit Task presentation refinement

Create/Edit Task is functionally implemented and is not being redesigned in this phase. A future design pass will review visual hierarchy and usability across date/time and All Day controls, reminder presentation, linked Document/Case presentation, notes, Save/completion/delete action hierarchy, spacing, RTL/LTR behavior, long labels, keyboard behavior, and consistency with the Doxary design system. This is a bounded presentation refinement only; it does not change the Task domain model or persistence semantics.
