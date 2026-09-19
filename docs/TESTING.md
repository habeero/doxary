# Testing governance

Testing protects confirmed behavior at the appropriate ownership boundary. Use focused, deterministic tests; use synthetic or redacted fixtures for document-related behavior; and add a focused regression test for every regression fix.

## Domain test requirements

- [UI/UX testing](ui-ux/TESTING.md)
- [Application-logic testing](app-logic/TESTING.md)
- [App/backend integration testing](app-backend/TESTING.md)
- [AI testing](ai/TESTING.md)
- [Monetization testing](monetization/TESTING.md)

## Cross-domain and release validation

Cross-domain changes require validation at the affected boundaries. Release validation includes contract and regression coverage, privacy/security review, redacted observability, and the independent audit gate described in [DECISIONS.md](DECISIONS.md) and [RELEASE.md](RELEASE.md).
