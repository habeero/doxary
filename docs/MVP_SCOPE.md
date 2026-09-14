# MVP scope

## Included

- Camera, image, and PDF import architecture; later implementation will analyze imported German documents.
- Structured analysis: sender, type, language, summary/explanation, action state, urgency, dates, appointments, amounts, requested documents, tasks, warnings, and confidence.
- Document/case questions, simpler explanations, German reply drafts, and access to original German text.
- Automatic and manual tasks, deadlines, appointments, local reminders, and Today/Upcoming/Completed views.
- Browsing by Organization -> Case -> Documents, correction of suggestions, simple search-ready metadata, Arabic explanation/UI architecture with RTL.

## Product acceptance criteria

A user can import and save one document even when classification fails, receive a structured actionable result, correct or accept its organization/case, create or accept tasks, receive a local reminder, mark work complete, and later find a confirmed document under its case. The system never requires hierarchy creation before import, and unclear facts are marked rather than invented.

## Post-MVP candidates

Cloud sync/storage, accounts, push notifications, multilingual launch including Tigrinya, tags and richer search, household collaboration, email/share imports, form filling, exports, knowledge bases, eligibility tools, and workflow automation.

## Explicitly excluded from MVP

Legal/tax advice, automatic legal decisions, government portal automation, email inbox integration, cloud drive, family accounts, push infrastructure, full multi-device sync, advertising, and a full calendar product.
