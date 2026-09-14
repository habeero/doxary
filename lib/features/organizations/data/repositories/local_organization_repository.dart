import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' hide Organization;
import '../../../documents/domain/entities/domain_entities.dart';
import '../../domain/repositories/organization_repository.dart';

class LocalOrganizationRepository implements OrganizationRepository {
  LocalOrganizationRepository(this._database);
  final AppDatabase _database;
  @override
  Stream<List<Organization>> watchAll() =>
      (_database.select(
        _database.organizations,
      )..orderBy([(row) => OrderingTerm.asc(row.name)])).watch().map(
        (rows) => rows
            .map(
              (row) => Organization(
                id: row.id,
                name: row.name,
                category: OrganizationCategory.values.byName(row.category),
                createdAt: row.createdAt,
                updatedAt: row.updatedAt,
              ),
            )
            .toList(),
      );
  @override
  Future<void> save(Organization organization) => _database
      .into(_database.organizations)
      .insertOnConflictUpdate(
        OrganizationsCompanion.insert(
          id: organization.id,
          name: organization.name,
          category: organization.category.name,
          createdAt: organization.createdAt,
          updatedAt: organization.updatedAt,
        ),
      );
}
