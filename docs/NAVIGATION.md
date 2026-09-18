# Navigation and UX foundation

Primary bottom navigation is **Home**, **Documents**, central **Analyze**, **Tasks**, and **Settings**. Analyze is the user's document-understanding intent; camera capture and file import are steps inside that flow, not a separate primary destination. Settings includes profile/account functionality; Profile is not a separate bottom-navigation destination. Deep links are reserved for future document, case, task, and notification routes; they must validate authorization/local availability before displaying content.

Bottom navigation remains visible on those five primary destinations and is hidden in focused or nested flows: camera capture/review, Processing, the state-driven Document route, Organization, Case (`المعاملة`), Unclassified Documents, classification change, Organization/Case selection or creation, Create/Edit Task, and comparable focused subflows. Nested flows use explicit Back or Close navigation. Where practical, Back returns to the actual origin while preserving its prior UI state.

The approved Analyze/Import entry states are: empty (camera capture, PDF/image/file selection, supported-format guidance, and explanation-language choice); PDF/file selected (summary, remove, language, and Analyze Document); and camera/multiple-image selected (ordered previews, individual/remove-all actions, and adding another page before analysis). The current UX design permits up to 10 pages/images per submission; this is a product/UI constraint, not a backend guarantee unless the backend independently enforces it. Camera capture is a launch requirement, and the agreed core capture/import experience is required for final release.

The camera flow is Analyze -> Camera Capture -> single-page Review -> multi-page Review -> selected-pages state -> Analyze. Single-page Review supports retake, accept/use image, crop, and rotate. Multi-page Review supports thumbnails, selected-page preview, individual removal, adding another page, and continue within the 10-page constraint. Auto edge detection/perspective correction may be used only when a maintained reliable implementation supports it; advanced scanner filters such as black-and-white enhancement or shadow removal are not required for the initial release.

Home is an actionable overview, not a second Documents library: action-required items come first, then currently processing analyses, then approximately three to five recent Documents, followed by a route to all Documents. Documents is the complete local library and browses Organization -> Case -> Documents, with unclassified documents in a separate section. Tasks uses Today, Upcoming, and Completed tabs. Settings owns language, privacy, notification, profile/account, and future plan functionality.

```mermaid
flowchart LR
 Analyze[Analyze] --> Review[Capture/import review]
 Review --> Processing[Analysis progress]
 Processing --> Result[Structured result]
 Result --> Correct[Correct organization/case/facts]
 Result --> Task[Accept/edit task or reminder]
 Result --> Chat[Ask question / simple explanation]
 Result --> Reply[Draft German reply]
```

The result starts with sender suggestion, document type, plain explanation, action requirement, deadlines, appointments, amounts, requested documents, next actions, and quality/uncertainty guidance. Suggestions remain suggestions until a user confirms them. Pending analysis states are uploading, accepted, and processing; terminal technical failure and an `unavailable` AnalysisResult are distinct. Offline views show locally persisted results and a clear pending-analysis state; never imply that analysis completed offline.

The import review places a compact analysis-language selector beside the Analyze action. It controls generated explanation language (Arabic or Einfaches Deutsch) independently from the app interface language and persists locally.

### Processing UX

Wireframes may place `active text | completed text` together as design notation. Production UI displays only the copy for the current state. Supported design examples are upload, analyze, and prepare result; each has active/completed wording only when grounded in observable client/server state.

Processing is a user-facing staged timeline, not a raw technical log. A stage has an active and completed label (for example, Arabic `جاري رفع المستند` -> `تم رفع المستند`, then `جاري تحليل المستند` -> `تم تحليل المستند`); wireframes may show both as notation, while production shows only the label matching the current state. The client never invents percentage progress or backend sub-stages that cannot be derived from a real client/server state. Leaving this screen does not cancel analysis: the Document remains visible in Documents as processing. If completion arrives while Processing is open, navigation proceeds to Result. A completion notification is a launch requirement only when notification behavior is explicitly implemented and tested.

### Import submission UX

Analyze captures an immutable submission snapshot. Selected-file presentation is cleared or locked immediately when submission begins, and repeated taps cannot create duplicate logical analyses. The snapshot and existing idempotency lifecycle remain local integration concerns; this does not change the API contract.

### Classification edit and contextual search

Result -> Change Classification uses lightweight modal or bottom-sheet interactions for Organization and Case selection, not needless full navigation destinations. Creating an Organization requires only a name; category is not manually required. Creating a Case (`المعاملة`) happens under an already selected Organization, cannot create an orphan Case, and makes the new Case the current selection.

Search is contextual: Documents root searches library-relevant content, Organization searches content belonging to that Organization, Unclassified searches only unclassified Documents, and Case searches Documents in that Case. A universal standalone Search Results screen is not required. An Unclassified Document has no confirmed Organization; Without Case has a confirmed Organization but no Case. These states are distinct.

### Result UX

Required-action information has stronger prominence than secondary explanation. The long explanation is secondary and must not dominate the first viewport; expandable secondary areas may include the full explanation, required documents, appointments, and other relevant detail groups. Original-document access remains a trust action.

Clearing or locking transient selection after Analyze must never delete the persisted local Document or its DocumentFile records. Initial Analyze and Retry analysis are distinct actions; Retry keeps the same local document identity while a new submission/operation may be created.

Important facts are rendered from returned meaningful values only. The schema may support a broad fact catalog, but the UI does not create empty rows such as “amount: unknown” or “deadline: uncertain”. Organization and Case/Vorgang (`المعاملة`) are organizational metadata and may explicitly show an unassigned state; meaningful uncertainty appears as review guidance, not artificial fact values. The hierarchy is title -> summary -> required action -> relevant facts -> classification -> expandable details -> original document.

Documents uses real local routes: `/documents/organization/:organizationId`, `/documents/organization/:organizationId/case/:caseId`, and `/documents/:clientDocumentId`. An organization view lists its cases and documents directly associated with it; a case view lists its documents. Unclassified documents remain directly available. The detail route presents title and confirmed/suggested classification before original local metadata and analysis. Suggestions are confirmed or changed explicitly; they never classify automatically. Original opening remains deferred because a maintained permission-aware PDF/image adapter is not yet justified.

The Document route is the single stable detail/result entry rather than a redundant Detail-then-Result navigation layer. Its presentation follows state: processing shows Processing; succeeded/complete shows Result/Document Detail; partial or uncertain shows partial Result; failed/unavailable shows failure/unavailable; and pre-analysis states show the appropriate pre-analysis view. The same local `client_document_id` remains stable across these states.

## Phase 2.6.3 screen-design brief

The following designs must be reviewed and approved before their implementation. Every row specifies the primary goal and hierarchy; each also defines primary/secondary actions, navigation entry/exit, loading/empty/failure states, local/offline behavior, partial-analysis treatment where applicable, German and Arabic RTL presentation, and accessibility semantics, order, dynamic type, contrast, and touch targets.

| Screen | Primary goal and information hierarchy | Key actions and navigation |
|---|---|---|
| Home | Re-enter the app and see the most actionable local work: urgent tasks, pending/failed analysis, then recents. | Import is primary; Documents, Tasks, and a relevant document are secondary entries. Empty state directs to import; local data remains available offline. |
| Add / Import | Select and review one logical local Document, its files/order, and explanation language. | Start analysis or cancel; after start, transient selected files are cleared or locked to prevent duplicate submission. Picker/error/cancellation states preserve local work. |
| Processing | Explain upload, accepted, and processing without implying completion. | View document or safely leave; terminal failure offers a deliberate new retry, never automatic resubmission. Pending local operation resumes offline/restart appropriately. |
| Documents | Browse the complete local library by confirmed Organization, then unclassified. | Open Organization, Document, or import. Loading/empty/error preserve accessible local navigation and Arabic RTL grouping. |
| Organization | Understand one confirmed organization: cases first, then documents without a case. | Open Case/Document; return to Documents. Empty state distinguishes no cases from no documents. |
| Case / Vorgang / المعاملة | Follow documents belonging to one continuing matter. | Open Document; return to Organization. Empty and error states retain ownership context. |
| Document route: Result / Detail | Present the local Document by lifecycle state: title, summary, action, relevant facts, classification, details, and original access. | Confirm/change classification and open original when supported; processing, complete, partial, and failure are presentations of this one route. |
| Classification confirm/change | Promote or correct suggestions without conflating them with facts. | Confirm, select/create Organization and organization-owned Case, clear Case, or cancel. Arabic uses المعاملة for Case; focus order follows direction. |
| Tasks | Review actionable work by time/status. | Open source context and update task state; remains unimplemented until an approved design is implemented. |
| Settings | Manage local language, privacy, notifications, and profile/account settings. | Change local preferences; account plans, quotas, and billing remain unimplemented. |

For all analysis-related screens, German labels and Arabic RTL layouts are equally reviewed. Loading, empty, failure, local-only, and partial-analysis states are first-class designs rather than edge cases.

## Approved information architecture

### Documents, Organization, and Case

Documents root is organizational navigation: search, Unclassified, then Organizations. Classified Documents do not need to appear directly at root. An Organization row may show its Case count and Document count; the whole row/card is tappable, so a separate Open button is unnecessary.

An Organization screen contains the Organization name, search within the Organization, Cases as the visually primary content, Documents associated with that Organization but no Case, and an optional All Documents entry. Without Case and All Documents are secondary views.

Case is consistently `المعاملة` in Arabic. A Case screen lists Documents for that continuing matter with a meaningful title, relevant date, and useful status such as action required, completed, or no action required. It must not use a raw filename or opaque ID as the primary title when meaningful metadata exists. The initial design does not force year headings; grouping, filtering, or sorting by year can be introduced later only if justified.

### Tasks and Settings

Tasks has separate Today (`اليوم`), Upcoming (`القادمة`), and Completed (`مكتملة`) tabs. Each tab contains only its own tasks; Today never also shows an Upcoming section. A task row may show title, linked Organization/Document context, due date, and a completion control. It opens the linked Document when available. Completing a task moves it to Completed, where it remains reviewable.

Settings is a primary destination with this root hierarchy: Account (Profile, Plan/account); Language (app language, default explanation language); Notifications (master preference, analysis-completion, task/deadline reminders); Appearance (dark/light mode); Privacy and data (local documents, data management); Legal (Privacy Policy, Terms of Use); and About (About Doxary, Rate app, Share app, version). Profile is not primary navigation.

Notifications are an intended, unimplemented three-layer model: OS permission, Doxary master preference, then category preferences. Disabling one category does not disable unrelated categories. If the master setting is off, category controls are hidden or disabled. If Doxary is enabled but OS permission is denied, Settings explains that device settings block notifications and may offer Open Settings. Disabling an important category may state its consequence. Permission is requested contextually only after its value is clear (for example analysis completion or reminders), never without context on first launch; a decline is not repeatedly nagged, and Settings remains the durable place to change preferences.

### Result, uncertainty, failure, and retry

Result supports a broad fact catalog where applicable: amounts/payment amounts; payment, due, and document dates; deadlines; billing/service periods; reference/file/customer numbers; appointment date/time/location; objection periods; contract dates; salary/working hours; invoice number; IBAN/payment purpose; required documents; travel/flight facts; insurance-specific facts; and other document-type facts. It renders only meaningful returned values, never a fixed universal table.

For partial or uncertain analysis, show only reliable facts and express uncertainty as review guidance. Never turn unknown into a fake fact row or infer “no action required” when action status is uncertain. Original-document access and relevant details should be easy to review.

Failed or unavailable analysis never means the Document was lost: the local Document remains available, classification stays independently editable, and Retry appears where appropriate. Original opening remains available once a local viewer exists. An Available Information section appears only when it has actual meaningful data. Technical failure and a valid unavailable result remain distinct domain states.

Retry Analysis never creates a duplicate local Document: it uses the same `client_document_id` and persisted Document/DocumentFile records, though it may create a new submission, operation, or attempt and retain retry history. Retry Analysis and Import as New Document are distinct actions. Invariant: `Retry × N != N Documents`.

### Release-quality boundary

For technical analysis failure, the recovery action may be Retry analysis. For unreadable or insufficient input, the preferred action may instead be retake or reselect clearer source material; the UI must not blindly retry identical poor input when a better image/file is the actionable remedy.

### Task create and edit

Create/Edit Task is a focused full-screen flow, not a primary destination. Fields may include title, date, optional time or all-day, reminder, linked Document or Case, and optional note. If All Day is selected, time is inactive and not required. When created from a Document Result, the Document association is preserved and Organization is derived from the linked Document/Case rather than being a separately editable conflicting field. Tasks created from Tasks may be unlinked or linked to a Document/Case. Delete Task is destructive and requires confirmation; Complete Task normally does not.

The intended final release requires the agreed core UX: camera/capture, coherent Analyze/import, usable Settings, classification/navigation, state-driven Result, and retry safety. This is separate from future Phase 3/4 work such as assistant, replies, quotas/billing, cloud sync, or speculative integrations.

## Phase 1 implementation

The current implementation still has legacy route labels from the foundation. Approved future UI uses Home, Documents, Analyze, Tasks, and Settings; implementation must align with this design before release. Home renders real local repository streams with empty/loading/error states; it does not inject sample document data. On cold start, Arabic device locales select Arabic UI; all other locales select German unless the user has saved an explicit UI preference.
