import 'package:doxary/features/documents/domain/classification/classification_selection.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026);
  final organization = Organization(
    id: 'org-1',
    name: 'Techniker Krankenkasse',
    category: OrganizationCategory.healthInsurer,
    createdAt: now,
    updatedAt: now,
  );

  test('obvious organization duplicate is reused conservatively', () {
    expect(
      matchingOrganization([organization], '  techniker   krankenkasse '),
      same(organization),
    );
    expect(matchingOrganization([organization], 'Techniker'), isNull);
  });

  test('a case can only be reused under its confirmed organization', () {
    final matching = Case(
      id: 'case-1',
      organizationId: 'org-1',
      title: 'Membership',
      createdAt: now,
      updatedAt: now,
    );
    final other = Case(
      id: 'case-2',
      organizationId: 'org-2',
      title: 'Membership',
      createdAt: now,
      updatedAt: now,
    );
    expect(
      matchingCase([matching, other], 'org-1', ' membership '),
      same(matching),
    );
    expect(matchingCase([matching, other], 'org-3', 'Membership'), isNull);
  });
}
