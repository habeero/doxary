# Release governance

## Environments and progression

Use separate development, test/staging, and production environments with isolated credentials and data. Progress releases through readiness review, a release candidate, and final release. Rollout and recovery ownership must be defined before public release.

## Release readiness

Each release requires privacy/security review, redacted observability, cross-domain contract and regression validation, store-compliance review, changelog/release notes, and a recovery plan. The pre-release audit gate is defined in [DECISIONS.md](DECISIONS.md).

## Public-launch gates

Before public release, readiness review must also confirm:

- the approved monetization model is documented, implemented, and validated, including entitlement/access rules, required usage/quota/accounting behavior, store or billing integration when the chosen model requires it, purchase/restore/error/offline entitlement behavior, and continued access to existing local Documents when entitlement cannot be verified;
- every visible capability in the approved Settings hierarchy is functional, or an explicit product decision has removed it from the launch UI; no visible permanent placeholder Settings rows remain without that approval;
- original source access and local reminder delivery meet the approved MVP acceptance behavior.

Detailed migration, API compatibility, configuration, and validation requirements remain in their owning domains. Hosting and deployment-provider choices remain open and must not change established product or domain contracts.
