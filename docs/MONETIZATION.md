# Monetization architecture

Commercial terms are undecided. The product defines an `EntitlementService` port and typed concepts: `UsageQuota`, `SubscriptionStatus`, `FeatureAccess`, `Entitlement`, and `UsageEvent`. UI asks a feature-access use case rather than scattering `if premium` checks. Domain workflows do not know store/provider details.

Possible future models: limited free analyses, subscriptions, one-time entitlements, and credits. Backend is the eventual source of truth for quotas, fraud/abuse control, and store verification; the client can cache an entitlement snapshot for offline UX but may not grant irreversible paid access from an unverified local value. No advertising is planned.

Purchase providers, pricing, trials, restore behavior, regional availability, tax handling, and which features are paid are open decisions. Entitlement checks must fail safely and explain unavailable/retry states without blocking access to a user's existing local documents.
