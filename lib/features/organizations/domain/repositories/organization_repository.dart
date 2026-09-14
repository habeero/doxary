import '../../../documents/domain/entities/domain_entities.dart';

abstract interface class OrganizationRepository {
  Stream<List<Organization>> watchAll();
  Future<void> save(Organization organization);
}
