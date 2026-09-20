# App/backend integration

This domain is authoritative for the contract and interaction boundary between Doxary Flutter and the backend API. Ordinary integration work should be understandable from these documents; consult another domain only when an implementation dependency genuinely crosses this boundary.

## Documents

For the deferred contract, privacy, retention, and release-hardening phase, see [HARDENING_BACKLOG.md](HARDENING_BACKLOG.md).

- [API_CONTRACT.md](API_CONTRACT.md) — versioned routes, identifiers, payloads, statuses, errors, and compatibility rules.
- [INTEGRATION.md](INTEGRATION.md) — submission, polling, retry, resume, transport, and temporary-upload behavior.
- [TESTING.md](TESTING.md) — contract and integration coverage expectations.
- [CHANGELOG.md](CHANGELOG.md) — meaningful integration milestones.
