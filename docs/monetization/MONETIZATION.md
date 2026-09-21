# Monetization architecture

## Current status

The monetization architecture exists, but no billing implementation exists and commercial terms are undecided. No final price, plan name, paid-feature set, store product, billing provider, quota, credit allowance, trial, restore behavior, regional availability, or tax handling has been approved. These choices remain open and must not be inferred from product or API concepts.

This is a pre-release requirement, not optional post-launch work: Doxary must have a deliberately chosen commercial model and a working, validated monetization implementation before public launch. This document does not choose that model. No advertising is planned, and an API error such as `quota_exceeded` does not imply a finalized commercial model.

## Entitlement architecture

Monetization is behind centralized abstractions: `EntitlementService`, `FeatureAccess`, `UsageQuota`, `SubscriptionStatus`, `Entitlement`, and `UsageEvent`. UI asks a feature-access use case; it does not scatter premium booleans. Document and other unrelated business workflows do not know store or provider details.

Future pricing, plans, quota policy, credits, and providers must remain replaceable as commercial decisions evolve. The backend is the eventual source of truth for quota accounting, fraud/abuse controls, and store verification. The client may cache an entitlement snapshot for offline UX but must not grant irreversible paid access from an unverified local value.

Entitlement checks fail safely and communicate unavailable/retry states without blocking access to a user's existing local Documents.

## Pre-release requirements

The dedicated monetization phase must, without being predetermined here:

- select and document the commercial model and its free/paid access rules;
- define entitlement, quota, usage-accounting, and account behavior where required by that model;
- define and implement store/billing integration when the chosen model requires it;
- implement and test purchase, restore, error, offline, unavailable, and retry behavior; and
- preserve access to existing local Documents when entitlement cannot be verified.

## Open commercial decisions

The following are possibilities, not approved requirements: limited free analyses, subscriptions, one-time entitlements, and credits. Introducing any of them requires a documented decision covering the associated access and usage rules.
