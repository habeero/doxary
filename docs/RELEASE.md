# Release governance

## Environments and progression

Use separate development, test/staging, and production environments with isolated credentials and data. Progress releases through readiness review, a release candidate, and final release. Rollout and recovery ownership must be defined before public release.

## Release readiness

Each release requires privacy/security review, redacted observability, cross-domain contract and regression validation, store-compliance review, changelog/release notes, and a recovery plan. The pre-release audit gate is defined in [DECISIONS.md](DECISIONS.md).

Detailed migration, API compatibility, configuration, and validation requirements remain in their owning domains. Hosting and deployment-provider choices remain open and must not change established product or domain contracts.
