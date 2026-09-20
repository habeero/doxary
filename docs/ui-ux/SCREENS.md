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

Documents browses the complete local library by confirmed Organization, then Case, with Unclassified Documents remaining visible separately. The root contains the screen title, contextual search, a Grid/List view control, an Unclassified special entry when applicable, and Organizations. Organizations are folders rather than large cards: Grid is the default and uses three columns at normal phone widths (responsive at narrower widths), folder icon, full display name below the icon, and concise useful metadata. List is a compact flat alternative for the active UI session; persistent view preference is future work unless an established lightweight preference mechanism is available. Long Organization names retain their actual value and wrap/ellipsis only as needed.

Unclassified is not an Organization: it is a distinct compact archive/folder-like entry with a useful count and opens only Documents without a confirmed Organization. In its normal state, the Documents root is an index and does not render individual Unclassified Documents below that entry. Root search may show genuinely matching local documents, including Unclassified Documents, without introducing backend search; headings for empty Organization or Document result sections are omitted.

Loading, empty, and error states preserve accessible local navigation and Arabic RTL grouping. A document row uses a meaningful title, relevant date, useful status, and clear tap affordance; it does not promote a raw filename or opaque identifier when meaningful metadata exists.

## Organization

An Organization screen is a focused archive folder with explicit Back/Close behavior, the Organization name, contextual search, and Cases as the visually primary content. Cases are compact folder-like rows, not oversized cards, and show concise local document-count metadata when available. Documents associated with that Organization but no Case appear as a distinct compact **Without Case** folder/archive entry with a useful count; it opens only those organization-only Documents. Without Case is not a normal Case. Its focused screen retains the Organization context and uses the same compact searchable document rows. Empty states distinguish no Cases from no documents and retain the Organization context.

## Case / Vorgang / المعاملة

A Case screen follows Documents belonging to one continuing matter. It uses compact document rows with a document icon, meaningful title, relevant dates, useful status, and a clear tap affordance. It does not require year headings; grouping, filtering, or sorting by year remains a later decision if justified.

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

The primary Result surface shows only the highest-value facts: the primary deadline, directly relevant amount, document date, primary appointment, and at most one or two further facts (approximately five rows total). Remaining extracted facts stay available in collapsed secondary detail. A primary action uses one concrete source in order of next action, suggested task, required document, then localized fallback; any directly associated deadline or amount is shown there once and is not immediately repeated in Important Information. Expanded detail content does not repeat the heading of its containing accordion.

The route presents pre-analysis, processing, complete, partial, action-uncertain, failed, and unavailable states without creating a redundant detail-to-result route. A complete action-uncertain result remains complete and receives review guidance specific to the uncertain action requirement. A failed or unavailable analysis does not mean the Document is lost; the user can see the appropriate recovery action. Unreadable or insufficient input may direct the user to retake or reselect clearer source material, while unsupported or corrupt input must not be described as merely unreadable.

## Classification

Classification correction promotes or corrects suggestions without conflating them with facts. Organization and Case selection/creation are contextual lightweight flows. Creating an Organization requires only a name; creating a Case occurs under a selected Organization and cannot create an orphan Case. Organization-only classification and Unclassified Documents remain distinct.

## Tasks

Tasks has separate Today, Upcoming, and Completed tabs. Each tab contains only its own tasks; Today does not also show an Upcoming section. A task row may show title, linked Organization/Document context, due date, and a completion control. Completing a task moves it to Completed, where it remains reviewable.

## Settings

Settings is a primary destination. Its root hierarchy is Account (Profile, plan/account), Language (app language and default explanation language), Notifications, Appearance, Privacy and data, Legal, and About. Notification behavior follows a three-layer intended model—OS permission, Doxary master preference, then category preferences—but remains unimplemented until behavior is implemented and tested.

## Cross-screen presentation

German labels and Arabic RTL layouts are reviewed equally for all analysis-related screens. Loading, empty, failure, local-only, and partial-analysis states are first-class designs rather than edge cases. Screen designs define accessibility semantics, focus order, dynamic type, contrast, and touch targets before substantial implementation.
