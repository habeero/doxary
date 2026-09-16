import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' hide DocumentFile;
import '../../domain/entities/domain_entities.dart';
import '../../domain/repositories/document_repository.dart';

class LocalDocumentRepository implements DocumentRepository {
  LocalDocumentRepository(this._database);
  final AppDatabase _database;

  @override
  Stream<List<LocalDocument>> watchRecent({int limit = 5}) {
    final query = _database.select(_database.documents)
      ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)])
      ..limit(limit);
    return query.watch().map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<void> saveImportedDocument(
    LocalDocument document,
    DocumentFile file,
  ) async {
    await _database.transaction(() async {
      await _database
          .into(_database.documents)
          .insertOnConflictUpdate(
            DocumentsCompanion.insert(
              clientDocumentId: document.clientDocumentId,
              organizationId: Value(document.organizationId),
              caseId: Value(document.caseId),
              classificationState: document.classificationState.name,
              status: document.status.name,
              documentDate: Value(document.documentDate),
              sourceLanguage: Value(document.sourceLanguage),
              createdAt: document.createdAt,
              updatedAt: document.updatedAt,
            ),
          );
      await _database
          .into(_database.documentFiles)
          .insertOnConflictUpdate(
            DocumentFilesCompanion.insert(
              id: file.id,
              clientDocumentId: file.clientDocumentId,
              localUri: file.localUri.toString(),
              mediaType: file.mediaType,
              originalFilename: Value(file.originalFilename),
              byteSize: Value(file.byteSize),
              importedAt: file.importedAt,
              pageOrder: Value(file.pageOrder),
              importSource: Value(file.importSource.name),
            ),
          );
    });
  }

  LocalDocument _toEntity(Document row) => LocalDocument(
    clientDocumentId: row.clientDocumentId,
    organizationId: row.organizationId,
    caseId: row.caseId,
    classificationState: ClassificationState.values.byName(
      row.classificationState,
    ),
    status: DocumentStatus.values.byName(row.status),
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    documentDate: row.documentDate,
    sourceLanguage: row.sourceLanguage,
  );
}
