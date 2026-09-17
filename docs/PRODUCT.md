# Product definition

## Problem and audience

People living in Germany often receive official or organizational correspondence they cannot confidently interpret. Doxary helps a person understand what a German document means, whether action is required, and the practical next step. The initial audience is Arabic-speaking residents interacting with public authorities, insurers, employers, landlords, and similar organizations. It is not a generic translation app, legal adviser, tax adviser, or decision-maker.

## Positioning and value

Doxary turns a document into an understandable, action-oriented case: sender, document type, plain-language explanation, actions, dates, requested evidence, appointments, and amounts. It keeps related documents together so a user can follow an administrative interaction over time.

## Core workflow

`Import -> extract/analyze -> structured result -> user review/correction -> tasks/reminders -> complete case`.

Analysis is shown before optional chat. A user is never required to create an organization or case first: an imported document is valid while unclassified, and AI suggestions become confirmed only after user acceptance or correction.

The app interface language and the language used for generated analysis explanations are independent preferences. The MVP offers Arabic and Einfaches Deutsch explanations through a compact selector near Analyze. The interface follows the device locale on first launch (Arabic for Arabic locales, German otherwise); explicit choices are persisted locally and are not silently overwritten by the other preference.

## Product principles

- Be practical: surface the next action in seconds.
- Be transparent: distinguish extracted facts, interpretation, uncertainty, and user edits.
- Be private by default: keep originals on-device unless a future user choice says otherwise.
- Be calm and accessible: minimize administrative jargon, support Arabic RTL, and never present AI output as legal certainty.
- Preserve agency: automated classification and task suggestions are editable.

## Terminology

**Organization** is a sender/recipient body (for example, Jobcenter). **Case (Vorgang)** is a continuing matter with an organization. **Document** is the logical correspondence item; **DocumentFile** is an imported image or PDF. **Analysis** is structured, versioned interpretation. A **task**, **deadline**, **appointment**, **amount**, and **required document** are actionable facts associated with a document and normally visible within its case. A **conversation** is document/case-scoped assistant context.

## Boundaries

The MVP explains and organizes documents; it does not determine eligibility, submit forms, automate government portals, or guarantee legal correctness. The temporary codename is not a user-facing brand decision.
