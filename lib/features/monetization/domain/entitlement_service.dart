enum SubscriptionStatus { unknown, inactive, active }

enum FeatureAccess { granted, unavailable, requiresVerification }

class UsageQuota {
  const UsageQuota({
    required this.feature,
    required this.used,
    required this.limit,
  });
  final String feature;
  final int used;
  final int? limit;
}

abstract interface class EntitlementService {
  Future<FeatureAccess> accessFor(String feature);
  Future<SubscriptionStatus> subscriptionStatus();
  Future<UsageQuota> usageFor(String feature);
}

class DevelopmentEntitlementService implements EntitlementService {
  @override
  Future<FeatureAccess> accessFor(String feature) async =>
      FeatureAccess.granted;
  @override
  Future<SubscriptionStatus> subscriptionStatus() async =>
      SubscriptionStatus.unknown;
  @override
  Future<UsageQuota> usageFor(String feature) async =>
      UsageQuota(feature: feature, used: 0, limit: null);
}
