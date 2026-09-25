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

Action-required cards are a durable Home-attention surface, not permanent Document state. A card disappears after explicit dismiss or after a Task is saved for its exact analysis/action provenance; the Document, analysis, and task remain intact and dismissed/handled Documents may remain in Recent Documents. A later actionable analysis has its own attention identity and may surface again. Separately, when failed/deleted-only Documents need action, Home shows one concise count/link to the Documents Needs Attention collection; it does not show those individual Documents as ordinary Recent items.

The recent preview remains concise and bounded; Home must not show the full Documents library. Empty Home explains a useful next action, such as importing a document, and empty is not an error. Local work remains available in the user-visible offline/pending states.

The separate Needs Attention count is an acknowledgement-style Home alert. Tapping it acknowledges the current attention snapshot before opening the existing collection. Its localized, accessible X dismisses only the Home alert and stays on Home; neither action changes underlying Documents or Analysis history. A later failed/deleted attention event can make the alert reappear, while its displayed count remains the total current unresolved count.

## Analyze / Import

Analyze is the document-understanding destination. The empty state offers camera capture, PDF/image/file selection, supported-format guidance, and explanation-language choice. A selected PDF/file state shows a summary, remove action, language, and Analyze Document. A camera-selected state shows the ordered captured pages, page count, remove-all, and Edit Pages; per-page removal, replacement, and adding pages remain in Camera Review with its 10-page constraint. Camera capture/review remains part of the UI/UX design scope.

The capture sequence is Analyze → Camera Capture → single-page Review → multi-page Review → selected-pages state → Analyze. Single-page Review supports retake, accept/use image, crop, and rotate. Multi-page Review supports thumbnails, selected-page preview, individual removal, adding another page, and continuing. Advanced scanner filters are not required for the initial release; auto edge detection/perspective correction is conditional on a maintained reliable implementation.

**Current implementation status:** Camera Capture and unified Review are implemented focused stages. Capture shows a real preview, a Back affordance, shutter, and flash only when supported. Permission denied, settings-required/restricted, unavailable, and initialization-failure states use localized user-safe messaging. Shutter pauses the camera and adds a temporary page to Review. Review supports one to ten ordered pages in the same surface: Retake removes the current temporary page and safely resumes Capture; Add another page loops through the same Capture-to-Review flow; thumbnails select or remove individual pages; and Continue promotes the ordered pages to one existing Analyze session draft without creating a Document or operation. Rotation and Crop are real temporary-file transformations. A camera-sourced Analyze draft has a distinct selected-document card with a localized page count, ordered compact image thumbnails, Remove-all, and Edit Pages; it does not use a filename-centric PDF/file row. Its language selector and Analyze CTA remain the normal Analyze controls.

## Processing

Processing is a focused transient modal overlay shown after operation acceptance, not a route replacement. It explains accepted and processing through truthful semantic stages. Wireframes may show active and completed labels together as notation, but production shows only the label matching the observable state. No fake percentage or raw transport log is shown. Close/X and Continue in background dismiss only the overlay; analysis continues and the Document/Home lifecycle owns its background status. The Cancel action is visibly unavailable until a real cancellation contract exists. The overlay closes on terminal success or failure; completion notification remains deferred. Technical failure and unreadable/insufficient input are distinct user-facing states.

## Documents

Documents browses the complete local library by confirmed Organization, then Case, with Unclassified Documents and Needs Attention remaining distinct special collections. The root contains the screen title, contextual search, a Grid/List view control, a Needs Attention entry when its count is nonzero, an Unclassified entry when applicable, and Organizations. Needs Attention lists only Documents with no usable current Analysis whose latest relevant persisted event is a failed attempt or explicit Analysis deletion. Attention-only Documents do not enter Home Recent or Unclassified; current complete/partial results remain normally browsable even after a newer retry failed. The Documents root remains a complete archive: attention Documents continue to be reachable in their Organization/Case folders and are visibly marked in document rows. Organizations are folders rather than large cards: Grid is the default and uses three columns at normal phone widths (responsive at narrower widths), folder icon, full display name below the icon, and concise useful metadata. List is a compact flat alternative for the active UI session; persistent view preference is future work unless an established lightweight preference mechanism is available. Long Organization names retain their actual value and wrap/ellipsis only as needed.

Unclassified is not an Organization: it is a distinct compact archive/folder-like entry with a useful count and opens only Documents without a confirmed Organization that also have at least one usable Analysis (`complete` or `partial`). Failed-only and deleted/no-usable-result Documents are excluded from this collection. In its normal state, the Documents root is an index and does not render individual Unclassified Documents below that entry. Root search may show genuinely matching local documents, including Unclassified Documents, without introducing backend search; headings for empty Organization or Document result sections are omitted.

Needs Attention is a separate focused Documents collection. Each compact Document row shows its human-readable identity, localized reason (Analysis failed or Analysis deleted), and the device-local failed-event/deletion time. Tapping opens the existing Document Detail route, where Retry/Re-analyze remains authoritative. The collection has a localized empty state and is not a bottom-navigation destination.

Loading, empty, and error states preserve accessible local navigation and Arabic RTL grouping. A document row uses a meaningful title, relevant date, useful status, and clear tap affordance; it does not promote a raw filename or opaque identifier when meaningful metadata exists.

## Unclassified Documents

**Current implementation status:** Unclassified Documents is a focused nested archive screen with Back behavior, scoped search, a document list, and opening into the Document route. Its interaction/hierarchy is aligned with the approved reference. The reference PNG was inspected, but final runtime visual fidelity remains for manual review because the production screen was not runtime-captured during the audit.

## Organization

An Organization screen is a focused archive folder with explicit Back/Close behavior, the Organization name, contextual search, and Cases as the visually primary content. Cases are compact folder-like rows, not oversized cards, and show concise local document-count metadata when available. Documents associated with that Organization but no Case appear as a distinct compact **Without Case** folder/archive entry with a useful count; it opens only those organization-only Documents. Without Case is not a normal Case. Its focused screen retains the Organization context and uses the same compact searchable document rows. Empty states distinguish no Cases from no documents and retain the Organization context.

## Case / Vorgang / المعاملة

A Case screen follows Documents belonging to one continuing matter. It uses compact document rows with a document icon, meaningful title, relevant dates, useful status, and a clear tap affordance. It does not require year headings; grouping, filtering, or sorting by year remains a later decision if justified.

## Document route: Result / Detail

**Current implementation status:** Classification correction is reachable from the Document route and is functionally implemented. Result offers **Create Task** only for a confirmed action-required result. It opens the existing editor with an editable deterministic draft; it never creates a Task automatically. The draft preserves the current Document and an already-confirmed Case, but does not infer a Case or introduce an Organization field. Informational/no-action, unavailable, and uncertain/partial results do not show a misleading task action. Timed Task reminders are delivered locally after the Task is saved; All Day reminders use the MVP 09:00 local due-date anchor.

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

**Deferred information architecture clarification:** Analysis History belongs to the Document-level experience, not inside an individual Analysis Result. The intended Document-level model is imported/source information followed by newest-first analysis attempts, successful historical results, and failed attempts. Each individual Result remains focused on one selected analysis/result. A history item must never expose internal IDs or raw backend errors. This clarification does not move or redesign the current UI.

Required-action information outranks long or secondary explanation. Sender suggestion, document type, plain explanation, action requirement, deadlines, appointments, amounts, requested documents, next actions, and quality/uncertainty guidance appear only when returned and meaningful.

Facts are data-driven. Absent or meaningless values are omitted rather than rendered as “unknown” rows. Organization and Case may explicitly show an unassigned state; uncertainty is review guidance, not a fabricated fact. Suggestions remain suggestions until the user confirms or changes them. Original-document access is a trust action shown when source metadata is available. It opens a PDF through the device's supported viewer or presents ordered image pages in Doxary's read-only viewer; unavailable source material receives user-safe feedback without exposing paths or platform errors. Source ownership, retention, replacement, and deletion remain deferred application behavior in [APPLICATION_LOGIC.md](../app-logic/APPLICATION_LOGIC.md#source-document-access-deletion-and-future-synchronization).

The primary Result surface shows only the highest-value facts: the primary deadline, directly relevant amount, document date, primary appointment, and at most one or two further facts (approximately five rows total). Remaining extracted facts stay available in collapsed secondary detail. A primary action uses one concrete source in order of next action, suggested task, required document, then localized fallback; any directly associated deadline or amount is shown there once and is not immediately repeated in Important Information. Expanded detail content does not repeat the heading of its containing accordion.

### Deferred Result follow-ups

The Result visual redesign is substantially complete for the current application-design phase and must not be reopened without a concrete usability issue. Future UI/application follow-up work is limited to improving responsive handling of long Important Information values (especially long dates and text), revisiting document-title presentation only after the deferred canonical-title model is deliberately defined, and reviewing classification display/semantics separately from Result layout.

The route presents pre-analysis, processing, complete, partial, action-uncertain, failed, unavailable, and neutral no-current-analysis states without creating a redundant detail-to-result route. A complete action-uncertain result remains complete and receives review guidance specific to the uncertain action requirement. A failed or unavailable analysis does not mean the Document is lost; the user can see the appropriate recovery action. Explicit Analysis deletion is a distinct deleted/no-current-analysis state, not a technical failure, and retains Re-analyze and original-source access. When no usable Analysis remains, persisted attempt history determines whether the latest relevant event is a deletion or a newer real failure; a surviving usable Analysis remains authoritative. Removing the final failed-attempt history row returns to neutral no-current-analysis rather than continuing to show failure. Unreadable or insufficient input may direct the user to retake or reselect clearer source material, while unsupported or corrupt input must not be described as merely unreadable.

## Classification

**Current implementation status:** Change Classification, Organization and Case persistence, Clear Case, organization-only classification, and leaving a Document Unclassified are functionally implemented. Change Classification uses the approved focused modal pattern: Organization and Case changes remain draft state until explicit Save; Close/X discards changes; Remove Case preserves Organization until Save; and Clear Classification is a distinct destructive draft action. 10B is a focused searchable Organization-selection modal with local filtering and selected-state indication; its nested Create Organization modal validates and creates/reuses only an Organization, then returns it as the 10A draft selection. 10C is the equivalent focused searchable Case selector, scoped to the draft Organization, with a distinct No Case return that preserves Organization. Its nested Create Case modal inherits immutable Organization context, validates and creates/reuses a Case only within that Organization, then returns it as the 10A draft Case selection.

Classification correction promotes or corrects suggestions without conflating them with facts. Organization and Case selection/creation are contextual lightweight flows. Creating an Organization requires only a name; creating a Case occurs under a selected Organization and cannot create an orphan Case. Organization-only classification and Unclassified Documents remain distinct.

## Tasks

**Current implementation status:** Today, Upcoming, Overdue, and Completed bucketing/views are functionally implemented and reachable from the Tasks root in that order. Active tasks use local calendar dates: Overdue is before today, Today is today, and Upcoming is after today; Completed always overrides date grouping. Overdue rows use restrained due-date emphasis. Tapping a Task row opens the focused read-only Task Detail destination, not Edit. Detail presents meaningful persisted Task data, offers explicit Edit, reuses confirmed Delete, and offers Reopen only for completed Tasks. Create/Edit Task is a focused, calm editing surface: title first, paired Date/Time controls, explicit All Day opt-in, paired All Day/Reminder controls, bounded human-readable links, restrained note, and a clear Save action. New Tasks are timed by default with `reminderMinutesBefore = 0` (At time); No reminder is explicit, while Edit preserves persisted values exactly. Narrow or large-text layouts stack paired controls responsively. The current root is functionally complete; richer contextual row metadata and the approved root redesign remain bounded future presentation work.

The following remains approved intended behavior for the bounded Tasks presentation follow-up.

Tasks has separate Today, Upcoming, Overdue, and Completed tabs. Each tab contains only its own tasks; Today does not also show an Upcoming or Overdue section. A task row may show title, linked Organization/Document context, due date, and a completion control. Completing a task moves it to Completed, where it remains reviewable.

## Settings

**Current implementation status:** Settings is implemented as a primary bottom-navigation destination with the approved Account, Language, Notifications, Appearance, Privacy & Data, Legal, and About hierarchy. App language is shown as a human-readable current value and changes through a focused selection sheet using the existing persisted preference. All other approved rows are visible but currently unavailable and non-navigating; they are pre-release implementation gaps, not permanent post-MVP placeholders. Default explanation-language persistence remains separate in Analyze and has no Settings control.

The hierarchy above is visible now. Before public launch, every visible approved capability must have real functional behavior or be removed from the launch UI through an explicit product decision; the current product direction is to implement the visible capabilities.

During a future Settings design/review session, consider a discoverable entry for historical Analysis activity (for example, “Analysis history” or “Document / Analysis history”), outside the context of one current Result. Its final name, section, destination, and behavior are deliberately undecided; do not add a Settings tile until that product decision is made. Overall navigation information architecture may be revisited during that Settings phase after its actual capabilities are implemented. This note does not reverse the current no-sidebar decision.

Settings is a primary destination. Its root hierarchy is Account (Profile, plan/account), Language (app language and default explanation language), Notifications, Appearance, Privacy and data, Legal, and About. Notification behavior follows a three-layer intended model—OS permission, Doxary master preference, then category preferences. Timed local Task delivery and Task notification taps to Task Detail are implemented at the platform/application layer; no Doxary master/category Settings controls are implemented yet.

## Cross-screen presentation

German labels and Arabic RTL layouts are reviewed equally for all analysis-related screens. Loading, empty, failure, local-only, and partial-analysis states are first-class designs rather than edge cases. Screen designs define accessibility semantics, focus order, dynamic type, contrast, and touch targets before substantial implementation.
