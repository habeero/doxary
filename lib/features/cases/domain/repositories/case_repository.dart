import '../../../documents/domain/entities/domain_entities.dart';

abstract interface class CaseRepository {
  Stream<List<Case>> watchAll();
  Stream<List<Case>> watchForOrganization(String organizationId);
  Future<void> save(Case item);
}
