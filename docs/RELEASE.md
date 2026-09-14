# Release principles

Use separate development, test/staging, and production environments with isolated credentials/data. Version Android/iOS releases independently from the versioned API; define a minimum supported app version and a supported API compatibility window before public release. Prefer additive API/schema changes and explicit deprecation periods.

Database changes use reviewed, forward-only migrations, tested on representative non-production data. Rollback plans favor application rollback compatible with migrated data; do not erase production data to recover from a migration issue. Feature flags and remote configuration allow controlled rollout, kill switches, and experiments without embedding provider credentials in clients.

Releases need privacy/security review, redacted observability, contract and regression checks, store compliance review, changelog/release notes, and recovery ownership. Hosting and deployment provider choices remain open and must not change the mobile-domain contract.
