import '../entities/domain_entities.dart';

/// Conservative local matching for names the user has chosen to confirm.
/// It intentionally does not perform fuzzy or cross-organization matching.
String normalizeClassificationName(String value) =>
    value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

Organization? matchingOrganization(
  Iterable<Organization> organizations,
  String candidate,
) {
  final normalized = normalizeClassificationName(candidate);
  if (normalized.isEmpty) return null;
  for (final organization in organizations) {
    if (normalizeClassificationName(organization.name) == normalized) {
      return organization;
    }
  }
  return null;
}

Case? matchingCase(
  Iterable<Case> cases,
  String organizationId,
  String candidate,
) {
  final normalized = normalizeClassificationName(candidate);
  if (normalized.isEmpty) return null;
  for (final item in cases) {
    if (item.organizationId == organizationId &&
        normalizeClassificationName(item.title) == normalized) {
      return item;
    }
  }
  return null;
}
