# Screen specifications

Each screen has a clear purpose, information hierarchy, primary and secondary actions, and explicit loading, empty, failure, local/offline, and partial-analysis behavior where relevant. Entry/exit navigation is owned by [Navigation](NAVIGATION.md); interaction mechanics are owned by [Interactions](INTERACTIONS.md).

The screen descriptions below are approved design intent. **Current implementation status** records verified user-visible behavior as of 2026-09-21 and must not be inferred from approved design alone. The listed reference PNGs were inspected during the audit, but production Flutter screens were not runtime-captured; pixel, spacing, typography, and other final visual alignment still require manual runtime review.

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

Analyze is the document-understanding destination. The empty state offers camera capture, PDF/image/file selection, supported-format guidance, and explanation-language choice. A selected PDF/file state shows a summary, remove action, language, and Analyze Document. A camera-selected state shows the ordered captured pages, page count, remove-all, and Edit Pages; per-page removal, replacement, and adding pages remain in Camera Review with its 10-page constraint. Camera capture/review remains part of the UI/UX design scope.

The capture sequence is Analyze → Camera Capture → single-page Review → multi-page Review → selected-pages state → Analyze. Single-page Review supports retake, accept/use image, crop, and rotate. Multi-page Review supports thumbnails, selected-page preview, individual removal, adding another page, and continuing. Advanced scanner filters are not required for the initial release; auto edge detection/perspective correction is conditional on a maintained reliable implementation.

**Current implementation status:** Camera Capture and unified Review are implemented focused stages. Capture shows a real preview, a Back affordance, shutter, and flash only when supported. Permission denied, settings-required/restricted, unavailable, and initialization-failure states use localized user-safe messaging. Shutter pauses the camera and adds a temporary page to Review. Review supports one to ten ordered pages in the same surface: Retake removes the current temporary page and safely resumes Capture; Add another page loops through the same Capture-to-Review flow; thumbnails select or remove individual pages; and Continue promotes the ordered pages to one existing Analyze session draft without creating a Document or operation. Rotation and Crop are real temporary-file transformations. A camera-sourced Analyze draft has a distinct selected-document card with a localized page count, ordered compact image thumbnails, Remove-all, and Edit Pages; it does not use a filename-centric PDF/file row. Its language selector and Analyze CTA remain the normal Analyze controls.

## Processing

Processing is a focused transient modal overlay shown after operation acceptance, not a route replacement. It explains accepted and processing through truthful semantic stages. Wireframes may show active and completed labels together as notation, but production shows only the label matching the observable state. No fake percentage or raw transport log is shown. Close/X and Continue in background dismiss only the overlay; analysis continues and the Document/Home lifecycle owns its background status. The Cancel action is visibly unavailable until a real cancellation contract exists. The overlay closes on terminal success or failure; completion notification remains deferred. Technical failure and unreadable/insufficient input are distinct user-facing states.

## Documents

Documents browses the complete local library by confirmed Organization, then Case, with Unclassified Documents remaining visible separately. The root contains the screen title, contextual search, a Grid/List view control, an Unclassified special entry when applicable, and Organizations. Organizations are folders rather than large cards: Grid is the default and uses three columns at normal phone widths (responsive at narrower widths), folder icon, full display name below the icon, and concise useful metadata. List is a compact flat alternative for the active UI session; persistent view preference is future work unless an established lightweight preference mechanism is available. Long Organization names retain their actual value and wrap/ellipsis only as needed.

Unclassified is not an Organization: it is a distinct compact archive/folder-like entry with a useful count and opens only Documents without a confirmed Organization. In its normal state, the Documents root is an index and does not render individual Unclassified Documents below that entry. Root search may show genuinely matching local documents, including Unclassified Documents, without introducing backend search; headings for empty Organization or Document result sections are omitted.

Loading, empty, and error states preserve accessible local navigation and Arabic RTL grouping. A document row uses a meaningful title, relevant date, useful status, and clear tap affordance; it does not promote a raw filename or opaque identifier when meaningful metadata exists.

## Unclassified Documents

**Current implementation status:** Unclassified Documents is a focused nested archive screen with Back behavior, scoped search, a document list, and opening into the Document route. Its interaction/hierarchy is aligned with the approved reference. The reference PNG was inspected, but final runtime visual fidelity remains for manual review because the production screen was not runtime-captured during the audit.

## Organization

An Organization screen is a focused archive folder with explicit Back/Close behavior, the Organization name, contextual search, and Cases as the visually primary content. Cases are compact folder-like rows, not oversized cards, and show concise local document-count metadata when available. Documents associated with that Organization but no Case appear as a distinct compact **Without Case** folder/archive entry with a useful count; it opens only those organization-only Documents. Without Case is not a normal Case. Its focused screen retains the Organization context and uses the same compact searchable document rows. Empty states distinguish no Cases from no documents and retain the Organization context.

## Case / Vorgang / المعاملة

A Case screen follows Documents belonging to one continuing matter. It uses compact document rows with a document icon, meaningful title, relevant dates, useful status, and a clear tap affordance. It does not require year headings; grouping, filtering, or sorting by year remains a later decision if justified.

## Document route: Result / Detail

**Current implementation status:** Classification correction is reachable from the Document route and is functionally implemented. The approved contextual Task/Reminder CTA is **not implemented**: the Result presentation has no production-wired task-creation action. It remains an approved future action only when the analyzed Document has meaningful context such as a required action, deadline, appointment, suggested task, or next action. That future action must preserve the linked Document and derive Organization/Case context where available; it must not become a generic CTA on every Document.

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

### Deferred Result follow-ups

The Result visual redesign is substantially complete for the current application-design phase and must not be reopened without a concrete usability issue. Future UI/application follow-up work is limited to implementing actual **Open original document** behavior, improving responsive handling of long Important Information values (especially long dates and text), revisiting document-title presentation only if a deliberate short display-title capability becomes available, and reviewing classification display/semantics separately from Result layout.

The route presents pre-analysis, processing, complete, partial, action-uncertain, failed, and unavailable states without creating a redundant detail-to-result route. A complete action-uncertain result remains complete and receives review guidance specific to the uncertain action requirement. A failed or unavailable analysis does not mean the Document is lost; the user can see the appropriate recovery action. Unreadable or insufficient input may direct the user to retake or reselect clearer source material, while unsupported or corrupt input must not be described as merely unreadable.

## Classification

**Current implementation status:** Change Classification, Organization and Case persistence, inline creation, Clear Case, organization-only classification, and leaving a Document Unclassified are functionally implemented. The current UI is usable but its Organization/Case selection and creation presentation is still simpler than the approved Bottom Sheet/modal wireframes: searchable dedicated selection hierarchy and approved creation-flow presentation remain pending. Functionally implemented; approved UI redesign still pending.

Classification correction promotes or corrects suggestions without conflating them with facts. Organization and Case selection/creation are contextual lightweight flows. Creating an Organization requires only a name; creating a Case occurs under a selected Organization and cannot create an orphan Case. Organization-only classification and Unclassified Documents remain distinct.

## Tasks

**Current implementation status:** Today, Upcoming, and Completed bucketing/views are functionally implemented and reachable from the Tasks root. Create Task and Edit Task are implemented as focused full-screen forms with title, required date, optional time, All Day, persisted reminder intent, optional Document/Case links, optional note, save, completion, and confirmed delete. Row presentation remains incomplete: contextual metadata and the approved root redesign are still pending.

The following is approved intended behavior for the pending Tasks implementation.

Tasks has separate Today, Upcoming, and Completed tabs. Each tab contains only its own tasks; Today does not also show an Upcoming section. A task row may show title, linked Organization/Document context, due date, and a completion control. Completing a task moves it to Completed, where it remains reviewable.

## Settings

**Current implementation status:** App-language selection and persistence are implemented. Default explanation-language persistence exists elsewhere in the app, but Settings has no control for it. Profile/account, plan/account, notifications, appearance, privacy/data, legal, and about remain unimplemented. Functionally partial; approved Settings redesign still pending.

The following hierarchy is approved intended behavior for the pending Settings implementation.

Settings is a primary destination. Its root hierarchy is Account (Profile, plan/account), Language (app language and default explanation language), Notifications, Appearance, Privacy and data, Legal, and About. Notification behavior follows a three-layer intended model—OS permission, Doxary master preference, then category preferences—but remains unimplemented until behavior is implemented and tested.

## Cross-screen presentation

German labels and Arabic RTL layouts are reviewed equally for all analysis-related screens. Loading, empty, failure, local-only, and partial-analysis states are first-class designs rather than edge cases. Screen designs define accessibility semantics, focus order, dynamic type, contrast, and touch targets before substantial implementation.
