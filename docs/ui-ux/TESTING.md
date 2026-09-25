# UI/UX testing and validation

## Current regression checks

The following are implemented and have focused regression coverage: primary-root navigation; Tasks Today/Upcoming/Overdue/Completed bucketing, focused Create/Edit behavior (including timed/At-time new-task defaults, explicit No reminder, persisted Edit values, paired scheduling controls, and RTL-safe bounded links), and local reminder reconciliation for timed and All Day Tasks; app-language persistence; Document-route classification correction; the confirmed Result-to-Create-Task handoff; and Unclassified Documents focused browsing, scoped search, document opening, and distinction from Without Case. All Day uses the MVP 09:00 local anchor.

The approved wireframe PNGs for Tasks, Settings, classification, task forms, and Unclassified Documents were visually inspected in the 2026-09-21 audit. Production screens were not runtime-captured, so final pixel, spacing, typography, and visual-fidelity judgments remain manual runtime-review work.

## Future acceptance requirements

## Screen-level acceptance

Every approved screen design defines its primary goal, information hierarchy, primary and secondary actions, navigation entry/exit, loading/empty/error states, offline or local-only behavior, and partial-analysis behavior where relevant. Validate German and Arabic RTL layouts, accessibility semantics, focus order, contrast, dynamic type, and touch targets before substantial implementation.

## Navigation and state coverage

- Verify primary destinations Home, Documents, Analyze, Tasks, and Settings.
- Verify Profile is reachable within Settings rather than being a primary destination.
- Verify primary bottom navigation is visible only on primary roots and hidden in focused/nested flows.
- Verify explicit Back/Close behavior and origin-state preservation where practical.
- Verify the single state-driven Document route presents pre-analysis, Processing, complete, partial, unavailable, and failure states without a redundant Detail-to-Result route.
- Verify empty states are useful and are not rendered as errors.

## Import, camera, and processing

- Cover empty, PDF/file-selected, and camera/multiple-image-selected states.
- Verify ordered previews, per-page removal, remove-all, adding pages, and the 10-page UX limit.
- Verify single-page retake/accept/crop/rotate and multi-page preview/removal/addition.
- Verify repeated Analyze actions do not create duplicate visible or logical results.
- Verify selected input becomes safely locked or cleared after Analyze begins and existing local work remains available.
- Verify active versus completed semantic processing labels, no invented percentage/sub-stage, leaving without cancellation, Documents visibility while processing, and completion-to-Result navigation.
- Verify technical failure and unreadable/insufficient input are distinct recovery experiences.

## Result, Documents, and Tasks

The confirmed Result-to-Create-Task handoff and local reminder reconciliation for timed and All Day Tasks have focused coverage. Current Task coverage includes bucket views and focused Create/Edit form behavior, including responsive Date/Time and All Day/Reminder grouping; the All Day anchor is 09:00 local for MVP, and the Tasks root redesign remains separate work.

- Verify the Result hierarchy: application header, document title, concise summary, required action, applicable primary CTA, meaningful facts, classification, expandable details, and original-document access.
- Verify original-document access uses localized action/error feedback, does not expose source paths or IDs, and presents ordered image pages without mirroring image content in RTL.
- Verify required-action content outranks secondary explanation.
- Verify absent or meaningless facts are omitted, organizational unassigned states are explicit where useful, and uncertainty appears as review guidance.
- Verify suggestions remain non-confirmed until user action and that Unclassified and Without Case remain distinct.
- Verify Home includes its greeting, keeps the recent preview bounded, uses readable titles rather than opaque identifiers, and does not become the full Documents library.
- Verify Documents Organization → Case → Document navigation and contextual search.
- Verify Tasks keeps Today, Upcoming, Overdue, and Completed separate; completing a task moves it to Completed.

## Settings pre-release acceptance

- Verify the visible Account, Language, Notifications, Appearance, Privacy & Data, Legal, and About capabilities have real behavior before public launch, or that each removed launch row has an explicit product decision.
- Verify Settings exposes the approved default explanation-language control independently from UI language and does not rewrite prior analysis content.
- Verify About reads version/build from runtime metadata, handles metadata/share failures with localized safe states, shares through the native UI without a fabricated URL, and keeps Rate disabled until a real store listing is configured.
- Verify local reminder scheduling/delivery, privacy/data lifecycle behavior, approved legal disclosures, and real application/version information before launch.
- Verify no visible permanent unavailable placeholder Settings rows remain in a public release.

## RTL, localization, accessibility, and visual review

- Verify Arabic device-locale bootstrap, explicit UI-language persistence, and independent explanation-language choice.
- Verify directional padding/alignment, mixed Arabic/German names, dates, amounts, identifiers, filenames, and the Arabic Case term `المعاملة`.
- Verify screen-reader labels, focus order, contrast, minimum touch targets, dynamic text scaling, and reduced-motion expectations.
- Review System, Light, and Dark appearance on a real device, including platform-following behavior, Settings contrast, and narrow layouts. This focused Appearance change does not audit individual feature screens for hardcoded light colors; validate those screens physically before treating dark mode as fully visually verified.
- Use visual/manual checks for hierarchy, spacing, restrained card usage, and application-header/brand treatment without relying on wireframe pixel coordinates.
- Do not mark approved wireframe visual alignment as verified until the production Flutter screen has been runtime-captured or manually inspected alongside its referenced PNG.

Tests use synthetic or redacted data and must not expose raw document text, identifiers, addresses, income, or other sensitive values in logs or telemetry.

## Documents folder browsing checks

- Verify the Documents root defaults to a responsive three-column Organization folder grid on a representative phone width and switches to a compact List presentation for the active UI session.
- Verify Organization and Case folder affordances, compact Case document rows, and contextual browsing search.
- Verify Unclassified and Without Case remain visually and semantically distinct from normal Organizations/Cases in LTR and Arabic RTL layouts.
- Verify Organization contextual search filters that Organization's Cases, Without Case and Case searches remain scoped to their own Documents, Organization-to-Case navigation enters a focused flow, and primary bottom navigation remains hidden there.
- Verify normal Documents root browsing renders only the Unclassified special entry rather than duplicate Unclassified document rows; its focused screen owns the document list. Verify empty search-result sections omit their headings.
