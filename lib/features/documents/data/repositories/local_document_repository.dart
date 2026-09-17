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
  Stream<List<LocalDocument>> watchAll() {
    final query = _database.select(_database.documents)
      ..where((row) => row.status.isNotIn(['deleted']))
      ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)]);
    return query.watch().map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<LocalDocument?> getById(String clientDocumentId) async {
    final row =
        await (_database.select(_database.documents)
              ..where((item) => item.clientDocumentId.equals(clientDocumentId)))
            .getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<List<DocumentFile>> getFiles(String clientDocumentId) async {
    final rows =
        await (_database.select(_database.documentFiles)
              ..where((row) => row.clientDocumentId.equals(clientDocumentId))
              ..orderBy([(row) => OrderingTerm.asc(row.pageOrder)]))
            .get();
    return rows
        .map(
          (row) => DocumentFile(
            id: row.id,
            clientDocumentId: row.clientDocumentId,
            localUri: Uri.parse(row.localUri),
            mediaType: row.mediaType,
            originalFilename: row.originalFilename,
            byteSize: row.byteSize,
            importedAt: row.importedAt,
            pageOrder: row.pageOrder,
            importSource: DocumentFileSource.values.byName(row.importSource),
          ),
        )
        .toList();
  }

  @override
  Future<void> updateClassification(
    String clientDocumentId, {
    String? organizationId,
    String? caseId,
    required ClassificationState state,
  }) async {
    await (_database.update(
      _database.documents,
    )..where((row) => row.clientDocumentId.equals(clientDocumentId))).write(
      DocumentsCompanion(
        organizationId: Value(organizationId),
        caseId: Value(caseId),
        classificationState: Value(state.name),
        updatedAt: Value(DateTime.now()),
      ),
    );
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
