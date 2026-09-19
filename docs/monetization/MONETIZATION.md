# Monetization architecture

## Current status

Commercial terms are undecided. No final price, plan name, paid-feature set, store product, billing provider, quota, credit allowance, trial, restore behavior, regional availability, or tax handling has been approved. These choices remain open and must not be inferred from product or API concepts.

No advertising is planned. Quotas and billing remain outside the approved core document-understanding scope until separately approved. An API error such as `quota_exceeded` does not imply a finalized commercial model.

## Entitlement architecture

Monetization is behind centralized abstractions: `EntitlementService`, `FeatureAccess`, `UsageQuota`, `SubscriptionStatus`, `Entitlement`, and `UsageEvent`. UI asks a feature-access use case; it does not scatter premium booleans. Document and other unrelated business workflows do not know store or provider details.

Future pricing, plans, quota policy, credits, and providers must remain replaceable as commercial decisions evolve. The backend is the eventual source of truth for quota accounting, fraud/abuse controls, and store verification. The client may cache an entitlement snapshot for offline UX but must not grant irreversible paid access from an unverified local value.

Entitlement checks fail safely and communicate unavailable/retry states without blocking access to a user's existing local Documents.

## Future commercial models

The following are possibilities, not approved requirements: limited free analyses, subscriptions, one-time entitlements, and credits. Introducing any of them requires a documented decision covering the associated access and usage rules.
