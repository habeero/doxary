# Product definition

## Problem and audience

People living in Germany often receive official or organizational correspondence they cannot confidently interpret. Doxary helps a person understand what a German document means, whether action is required, and the practical next step. The initial audience is Arabic-speaking residents interacting with public authorities, insurers, employers, landlords, and similar organizations. It is not a generic translation app, legal adviser, tax adviser, or decision-maker.

## Positioning and value

Doxary turns a document into an understandable, action-oriented case: sender, document type, plain-language explanation, actions, dates, requested evidence, appointments, and amounts. It keeps related documents together so a user can follow an administrative interaction over time.

## Core workflow

`Import -> extract/analyze -> structured result -> user review/correction -> tasks/reminders -> complete case`.

Analysis is shown before optional chat. A user is never required to create an organization or case first: an imported document is valid while unclassified, and AI suggestions become confirmed only after user acceptance or correction.

The app interface language and the language used for generated analysis explanations are independent preferences. The MVP offers Arabic and Einfaches Deutsch explanations through a compact selector near Analyze. The interface follows the device locale on first launch (Arabic for Arabic locales, German otherwise); explicit choices are persisted locally and are not silently overwritten by the other preference.

Home is a recent/actionable overview, while Documents is the complete local library organized as Organization → Case → Document. Unclassified documents remain visible without fabricated “Unknown” records, and the original DocumentFile remains distinct from its analysis result.

The end-to-end analysis and document-organization foundation works, but the current presentation is not yet product-ready. The next product step is design-first UX architecture and screen design; implementation follows approved coherent designs rather than continued incremental widget changes.

The approved UX sequence treats Processing as a staged, truthful progress experience; Analyze as a single immutable logical submission; and Result as a hierarchy of returned facts rather than a schema checklist. Leaving Processing preserves the running local Document, and completion routes to Result when the screen is active. No notification promise is made until notification behavior is implemented and tested.

**Doxary UX Wireframes v1** is the approved Phase 2.6.3 wireframe milestone and the implementation reference before visual-design refinement. It is not executable specification and does not replace authoritative product, domain, API, or implementation documentation. Phase 2.6.3 wireframe architecture is sufficiently defined to proceed into visual design; visual design implementation and Flutter redesign are not complete.

## Product principles

Primary navigation is Home, Documents, Analyze, Tasks, and Settings. Analyze expresses the user's intent to understand a document; importing or capturing is part of that flow. Settings contains profile/account functionality. Camera capture is required for the intended launch experience, as are the agreed PDF/image/file import states; the current wireframe constraint is up to 10 pages/images per submission, without implying a backend limit.

- Be practical: surface the next action in seconds.
- Be transparent: distinguish extracted facts, interpretation, uncertainty, and user edits.
- Be private by default: keep originals on-device unless a future user choice says otherwise.
- Be calm and accessible: minimize administrative jargon, support Arabic RTL, and never present AI output as legal certainty.
- Preserve agency: automated classification and task suggestions are editable.

## Terminology

For Arabic product UI, Organization is **الجهة** or **المؤسسة** as context requires; Case (Vorgang) is consistently **المعاملة**; Document is **المستند**; and the original DocumentFile is **المستند الأصلي** or **الملف الأصلي** as context requires. Case must not be labeled **الملف**.

**Organization** is a sender/recipient body (for example, Jobcenter). **Case (Vorgang)** is a continuing matter with an organization. **Document** is the logical correspondence item; **DocumentFile** is an imported image or PDF. **Analysis** is structured, versioned interpretation. A **task**, **deadline**, **appointment**, **amount**, and **required document** are actionable facts associated with a document and normally visible within its case. A **conversation** is document/case-scoped assistant context.

## Boundaries

Document understanding is presented through one stable Document route whose content changes with lifecycle state; the product does not require a redundant separate Document Detail screen followed by a Result screen. Final release requires the core capture/import experience and coherent state transitions, while assistant, quotas/billing, and other future features remain out of scope.

The MVP explains and organizes documents; it does not determine eligibility, submit forms, automate government portals, or guarantee legal correctness. The temporary codename is not a user-facing brand decision.
