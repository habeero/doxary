import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' hide Case;
import '../../../documents/domain/entities/domain_entities.dart';
import '../../domain/repositories/case_repository.dart';

class LocalCaseRepository implements CaseRepository {
  LocalCaseRepository(this._database);
  final AppDatabase _database;

  @override
  Stream<List<Case>> watchAll() =>
      (_database.select(
        _database.cases,
      )..orderBy([(row) => OrderingTerm.asc(row.title)])).watch().map(
        (rows) => rows
            .map(
              (row) => Case(
                id: row.id,
                organizationId: row.organizationId,
                title: row.title,
                createdAt: row.createdAt,
                updatedAt: row.updatedAt,
              ),
            )
            .toList(),
      );

  @override
  Stream<List<Case>> watchForOrganization(String organizationId) =>
      (_database.select(_database.cases)
            ..where((row) => row.organizationId.equals(organizationId))
            ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)]))
          .watch()
          .map(
            (rows) => rows
                .map(
                  (row) => Case(
                    id: row.id,
                    organizationId: row.organizationId,
                    title: row.title,
                    createdAt: row.createdAt,
                    updatedAt: row.updatedAt,
                  ),
                )
                .toList(),
          );
  @override
  Future<void> save(Case item) => _database
      .into(_database.cases)
      .insertOnConflictUpdate(
        CasesCompanion.insert(
          id: item.id,
          organizationId: item.organizationId,
          title: item.title,
          createdAt: item.createdAt,
          updatedAt: item.updatedAt,
        ),
      );
}
