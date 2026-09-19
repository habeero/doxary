# Application-logic testing

Test domain entities, use cases, and business rules without Flutter. Use repository fakes where adapters need isolation, and an in-memory local database executor for persistence behavior. Every regression fix adds a focused regression test.

## Required coverage

- Data invariants: stable local Document identity, nullable pre-confirmation relationships, Case-to-Organization ownership, typed concepts, ordered files, and forward-only schema behavior.
- Classification: imported Documents remain unclassified; suggestions do not promote themselves; user confirmation/correction wins; exact normalized Organization/Case reuse is conservative; organization-only classification and unclassified visibility work.
- Lifecycle: import persists a Document and file; complete, partial, unavailable, and failed outcomes remain explicit; failure retains the local Document; a persisted new analysis does not change confirmed relationships.
- Actions: task bucketing separates Today, Upcoming, and Completed; manual and suggested task behavior stays distinct and editable.
- Retry and duplicate prevention: resuming known work, observing status, and retrying failures do not create duplicate local Documents; user-initiated reanalysis keeps local files and creates another analysis version.

Persisted classification metadata and analysis history require migration coverage. Test Document-library behavior against an unbounded non-deleted local list, with Organization → Case navigation and original-file metadata available from local data.

System picker UI tests are not required for application behavior: exercise the import port with fakes. Cancellation is neutral; import failures are typed recoverable errors. A PDF produces one logical DocumentFile, while multiple selected images form ordered pages of one logical Document.
