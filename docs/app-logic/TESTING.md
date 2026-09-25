# Application-logic testing

Test domain entities, use cases, and business rules without Flutter. Use repository fakes where adapters need isolation, and an in-memory local database executor for persistence behavior. Every regression fix adds a focused regression test.

## Required coverage

- Data invariants: stable local Document identity, nullable pre-confirmation relationships, Case-to-Organization ownership, typed concepts, ordered files, and forward-only schema behavior.
- Classification: imported Documents remain unclassified; suggestions do not promote themselves; user confirmation/correction wins; exact normalized Organization/Case reuse is conservative; organization-only classification and unclassified visibility work.
- Lifecycle: import persists a Document and file; complete, partial, unavailable, and failed outcomes remain explicit; failure retains the local Document; a persisted new analysis does not change confirmed relationships.
- Actions: task bucketing separates Today, Upcoming, Overdue, and Completed; manual and suggested task behavior stays distinct and editable.
- Local reminders: timed local due-date/time minus lead-time calculation; All Day's 09:00 local MVP anchor minus lead time; repeated-save reconciliation, edits/removal, completion/reopen/delete cancellation behavior, future-only scheduling, DST-safe local semantics, permission/platform-safe outcomes, and Task-specific notification identity. The `task_reminders_enabled` preference defaults to true, persists/reloads through `UserSettings`, cancels scheduled Task notifications while preserving reminder intent when disabled, and restores only eligible future open reminders without prompting when re-enabled; OS permission denial does not change the Doxary preference.
- Retry and duplicate prevention: resuming known work, observing status, and retrying failures do not create duplicate local Documents; user-initiated reanalysis keeps local files and creates another analysis version.
- Original-source access: a PDF resolves through the typed platform opener; image sources resolve as ordered read-only pages; missing, unsupported, and platform-failed sources remain typed safe outcomes. Opening never creates or deletes a Document, analysis, Task, classification, or source metadata; analysis deletion and reanalysis retain source access.

Persisted classification metadata and analysis history require migration coverage. Test Document-library behavior against an unbounded non-deleted local list, with Organization → Case navigation and original-file metadata available from local data.

System picker UI tests are not required for application behavior: exercise the import port with fakes. Cancellation is neutral; import failures are typed recoverable errors. A PDF produces one logical DocumentFile, while multiple selected images form ordered pages of one logical Document.
