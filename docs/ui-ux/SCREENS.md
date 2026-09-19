# Screen specifications

Each screen has a clear purpose, information hierarchy, primary and secondary actions, and explicit loading, empty, failure, local/offline, and partial-analysis behavior where relevant. Entry/exit navigation is owned by [Navigation](NAVIGATION.md); interaction mechanics are owned by [Interactions](INTERACTIONS.md).

## Home

Home is an actionable overview for re-entering the app, not a second Documents library. Its approved hierarchy is:

1. Application header / Doxary logo.
2. Greeting.
3. Action-required item(s).
4. Currently processing item(s).
5. Bounded recent-document preview.
6. View All Documents action.

The recent preview remains concise and bounded; Home must not show the full Documents library. Empty Home explains a useful next action, such as importing a document, and empty is not an error. Local work remains available in the user-visible offline/pending states.

## Analyze / Import

Analyze is the document-understanding destination. The empty state offers camera capture, PDF/image/file selection, supported-format guidance, and explanation-language choice. A selected PDF/file state shows a summary, remove action, language, and Analyze Document. A camera or multiple-image state shows ordered previews, per-page removal, remove-all, adding another page, and the 10-page UX constraint. Camera capture/review remains part of the UI/UX design scope.

The capture sequence is Analyze → Camera Capture → single-page Review → multi-page Review → selected-pages state → Analyze. Single-page Review supports retake, accept/use image, crop, and rotate. Multi-page Review supports thumbnails, selected-page preview, individual removal, adding another page, and continuing. Advanced scanner filters are not required for the initial release; auto edge detection/perspective correction is conditional on a maintained reliable implementation.

## Processing

Processing explains upload, accepted, and processing as truthful semantic stages. Wireframes may show active and completed labels together as notation, but production shows only the label matching the observable state. No fake percentage or raw transport log is shown. Leaving the screen does not cancel analysis; the Document remains available in its pending state. Technical failure and unreadable/insufficient input are distinct user-facing states.

## Documents

Documents browses the complete local library by confirmed Organization, then Case, with Unclassified Documents remaining visible separately. Root navigation may include contextual search, Unclassified, and Organizations. Loading, empty, and error states preserve accessible local navigation and Arabic RTL grouping. A document row uses a meaningful title, relevant date, and useful status; it does not promote a raw filename or opaque identifier when meaningful metadata exists.

## Organization

An Organization screen presents the Organization name and contextual search, with Cases as the visually primary content. It also shows documents associated with that Organization but no Case and may offer an All Documents entry. Empty states distinguish no Cases from no documents and retain the Organization context.

## Case / Vorgang / المعاملة

A Case screen follows Documents belonging to one continuing matter. It shows meaningful document titles, relevant dates, and useful status such as action required, completed, or no action required. It does not require year headings; grouping, filtering, or sorting by year remains a later decision if justified.

## Document route: Result / Detail

Result and Document Detail are one stable lifecycle-driven destination. The approved hierarchy is:

1. Application header.
2. Document title.
3. Concise summary.
4. Required action.
5. Primary CTA where applicable, such as creating a task/reminder.
6. Meaningful data-driven facts.
7. Classification.
8. Expandable secondary details.
9. Original-document access.

Required-action information outranks long or secondary explanation. Sender suggestion, document type, plain explanation, action requirement, deadlines, appointments, amounts, requested documents, next actions, and quality/uncertainty guidance appear only when returned and meaningful.

Facts are data-driven. Absent or meaningless values are omitted rather than rendered as “unknown” rows. Organization and Case may explicitly show an unassigned state; uncertainty is review guidance, not a fabricated fact. Suggestions remain suggestions until the user confirms or changes them. Original-document access remains a trust action and is shown only when supported.

The route presents pre-analysis, processing, complete, partial/uncertain, and failed/unavailable states without creating a redundant detail-to-result route. A failed or unavailable analysis does not mean the Document is lost; the user can see the appropriate recovery action. Unreadable or insufficient input may direct the user to retake or reselect clearer source material.

## Classification

Classification correction promotes or corrects suggestions without conflating them with facts. Organization and Case selection/creation are contextual lightweight flows. Creating an Organization requires only a name; creating a Case occurs under a selected Organization and cannot create an orphan Case. Organization-only classification and Unclassified Documents remain distinct.

## Tasks

Tasks has separate Today, Upcoming, and Completed tabs. Each tab contains only its own tasks; Today does not also show an Upcoming section. A task row may show title, linked Organization/Document context, due date, and a completion control. Completing a task moves it to Completed, where it remains reviewable.

## Settings

Settings is a primary destination. Its root hierarchy is Account (Profile, plan/account), Language (app language and default explanation language), Notifications, Appearance, Privacy and data, Legal, and About. Notification behavior follows a three-layer intended model—OS permission, Doxary master preference, then category preferences—but remains unimplemented until behavior is implemented and tested.

## Cross-screen presentation

German labels and Arabic RTL layouts are reviewed equally for all analysis-related screens. Loading, empty, failure, local-only, and partial-analysis states are first-class designs rather than edge cases. Screen designs define accessibility semantics, focus order, dynamic type, contrast, and touch targets before substantial implementation.
