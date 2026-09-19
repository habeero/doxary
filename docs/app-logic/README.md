# Application logic

This domain is authoritative for Doxary's local/application business logic: domain data behavior, local state transitions, and their invariants. Ordinary application-logic work should be understandable from these documents; consult another domain only when an implementation dependency genuinely crosses its boundary.

## Documents

- [DATA_MODEL.md](DATA_MODEL.md) — local entities, relationships, identity, and persistence-facing invariants.
- [APPLICATION_LOGIC.md](APPLICATION_LOGIC.md) — local-first behavior, lifecycle transitions, classification, and use-case rules.
- [TESTING.md](TESTING.md) — required business-rule, lifecycle, and regression coverage.
- [CHANGELOG.md](CHANGELOG.md) — meaningful application-logic milestones.
