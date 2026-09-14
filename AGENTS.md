# Project D agent guidance

## Before changing anything

1. Read every applicable `AGENTS.md`, the relevant files in `docs/`, and `README.md`.
2. Treat documented decisions as authoritative. Do not change architecture silently; record material changes in `docs/DECISIONS.md` and update affected documentation in the same change.
3. Keep code and documentation synchronized. Resolve ambiguity by documenting it, not by inventing a product requirement.

## Architecture rules

- Keep Flutter UI free of business logic. Domain code must be independent of Flutter and infrastructure.
- Use feature-first Clean Architecture; keep features modular and avoid duplicated business rules.
- Persist typed domain concepts, not loose maps. Do not leak persistence or API models into UI.
- Flutter must never call OpenAI or any AI provider directly. Provider-specific code stays behind backend abstractions.
- Preserve the Organization -> Case -> Document model. Do not remove future-facing boundaries merely because the first implementation is small; equally, do not add abstraction without an identified purpose.
- Keep API changes backward compatible when practical and version API routes. Do not add dependencies without a clear reason.

## Data, privacy, and operations

- Never commit secrets. Do not log raw document content, identifiers, addresses, income, or other sensitive values.
- Treat document data as privacy-sensitive. Follow `docs/SECURITY_PRIVACY.md` for retention, deletion, and telemetry.
- Use forward database migrations only. Never reset or delete a production database to solve migration problems.
- Add tests for business rules and regression fixes.
