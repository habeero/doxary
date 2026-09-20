# UI/UX testing and validation

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

- Verify the Result hierarchy: application header, document title, concise summary, required action, applicable primary CTA, meaningful facts, classification, expandable details, and original-document access.
- Verify required-action content outranks secondary explanation.
- Verify absent or meaningless facts are omitted, organizational unassigned states are explicit where useful, and uncertainty appears as review guidance.
- Verify suggestions remain non-confirmed until user action and that Unclassified and Without Case remain distinct.
- Verify Home includes its greeting, keeps the recent preview bounded, uses readable titles rather than opaque identifiers, and does not become the full Documents library.
- Verify Documents Organization → Case → Document navigation and contextual search.
- Verify Tasks keeps Today, Upcoming, and Completed separate; completing a task moves it to Completed.

## RTL, localization, accessibility, and visual review

- Verify Arabic device-locale bootstrap, explicit UI-language persistence, and independent explanation-language choice.
- Verify directional padding/alignment, mixed Arabic/German names, dates, amounts, identifiers, filenames, and the Arabic Case term `المعاملة`.
- Verify screen-reader labels, focus order, contrast, minimum touch targets, dynamic text scaling, and reduced-motion expectations.
- Review the approved Light-theme references on a real device. Light mode and `#F8FAFC` are the current visual baseline; dark mode is deferred and has no approved production palette.
- Use visual/manual checks for hierarchy, spacing, restrained card usage, and application-header/brand treatment without relying on wireframe pixel coordinates.

Tests use synthetic or redacted data and must not expose raw document text, identifiers, addresses, income, or other sensitive values in logs or telemetry.

## Documents folder browsing checks

- Verify the Documents root defaults to a responsive three-column Organization folder grid on a representative phone width and switches to a compact List presentation for the active UI session.
- Verify Organization and Case folder affordances, compact Case document rows, and contextual browsing search.
- Verify Unclassified and Without Case remain visually and semantically distinct from normal Organizations/Cases in LTR and Arabic RTL layouts.
- Verify Organization contextual search filters that Organization's Cases, Without Case and Case searches remain scoped to their own Documents, Organization-to-Case navigation enters a focused flow, and primary bottom navigation remains hidden there.
- Verify normal Documents root browsing renders only the Unclassified special entry rather than duplicate Unclassified document rows; its focused screen owns the document list. Verify empty search-result sections omit their headings.
