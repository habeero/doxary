# Backend contract, privacy, and retention hardening

## Status

This important phase is **deferred**. It must be completed before release, but it is not the current application-development task and must not interrupt Flutter UI/UX completion or remaining application behavior work.

## Future scope

- Refresh the authoritative backend documentation and make the API, AI, and backend documentation an explicit Codex contract, including allowed and forbidden changes.
- Document the complete analysis-result lifecycle and the server-transient versus local-durable architecture.
- Document PostgreSQL temporary-result storage; verify `expires_at` behavior, the actual cleanup/deletion mechanism, and retention periods.
- Define and document the original-file deletion lifecycle, backups, deletion implications, and privacy/GDPR decisions.
- Review logging and observability for personal or sensitive data.
- Document API and analysis-result schema/versioning rules.

The current integration contract describes intended temporary handling, but this backlog owns the release-grade verification and operational policy work. It does not authorize changing the existing Flutter/backend contract until a deliberate hardening decision is made.
