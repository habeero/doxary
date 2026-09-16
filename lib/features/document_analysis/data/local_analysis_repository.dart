import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../documents/domain/entities/domain_entities.dart';
import '../domain/analysis_repository.dart';
import '../domain/analysis_submission.dart';

class LocalAnalysisRepository implements AnalysisRepository {
  LocalAnalysisRepository(this._database);
  final AppDatabase _database;

  @override
  Future<DocumentAnalysis?> getLatest(String clientDocumentId) async {
    final rows =
        await (_database.select(_database.analyses)
              ..where((row) => row.clientDocumentId.equals(clientDocumentId))
              ..orderBy([(row) => OrderingTerm.desc(row.createdAt)])
              ..limit(1))
            .get();
    return rows.isEmpty ? null : _toDomain(rows.single);
  }

  @override
  Stream<DocumentAnalysis?> watchLatest(String clientDocumentId) async* {
    yield* (_database.select(_database.analyses)
          ..where((row) => row.clientDocumentId.equals(clientDocumentId))
          ..orderBy([(row) => OrderingTerm.desc(row.createdAt)])
          ..limit(1))
        .watch()
        .map((rows) => rows.isEmpty ? null : _toDomain(rows.single));
  }

  DocumentAnalysis _toDomain(Analyse row) => DocumentAnalysis(
    id: row.id,
    clientDocumentId: row.clientDocumentId,
    schemaVersion: row.schemaVersion,
    targetLanguage: row.targetLanguage,
    summary: row.summary,
    explanation: row.explanation,
    createdAt: row.createdAt,
    analysisStatus: AnalysisStatus.values.byName(row.analysisStatus),
    explanationStyle: ExplanationStyle.values.byName(row.explanationStyle),
  );

  @override
  Future<void> saveOperation({
    required String operationId,
    required String clientDocumentId,
    required AnalysisLifecycleState state,
    String? failureCode,
  }) async {
    final now = DateTime.now();
    await _database.transaction(() async {
      await _database
          .into(_database.analysisOperations)
          .insertOnConflictUpdate(
            AnalysisOperationsCompanion.insert(
              operationId: operationId,
              clientDocumentId: clientDocumentId,
              state: state.name,
              lastFailureCode: Value(failureCode),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await (_database.update(
        _database.documents,
      )..where((row) => row.clientDocumentId.equals(clientDocumentId))).write(
        DocumentsCompanion(
          status: Value(_documentStatus(state).name),
          updatedAt: Value(now),
        ),
      );
    });
  }

  @override
  Future<void> saveCompleted(DocumentAnalysis analysis) async {
    await _database.transaction(() async {
      await _database
          .into(_database.analyses)
          .insert(
            AnalysesCompanion.insert(
              id: analysis.id,
              clientDocumentId: analysis.clientDocumentId,
              schemaVersion: analysis.schemaVersion,
              targetLanguage: analysis.targetLanguage,
              summary: Value(analysis.summary),
              explanation: Value(analysis.explanation),
              state: analysis.analysisStatus.name,
              analysisStatus: Value(analysis.analysisStatus.name),
              explanationStyle: Value(analysis.explanationStyle.name),
              createdAt: analysis.createdAt,
            ),
          );
      for (var i = 0; i < analysis.qualityReasons.length; i++) {
        await _database
            .into(_database.analysisQualityReasons)
            .insert(
              AnalysisQualityReasonsCompanion.insert(
                id: '${analysis.id}-quality-$i',
                analysisId: analysis.id,
                reason: analysis.qualityReasons[i].name,
              ),
            );
      }
      for (final reference in analysis.sourceReferences) {
        await _database
            .into(_database.sourceReferences)
            .insert(
              SourceReferencesCompanion.insert(
                id: '${analysis.id}-${reference.referenceId}',
                analysisId: analysis.id,
                clientDocumentId: analysis.clientDocumentId,
                fileId: Value(reference.fileId),
                pageNumber: Value(reference.pageNumber),
                excerptLabel: Value(reference.excerptLabel),
              ),
            );
      }
      await (_database.update(_database.documents)..where(
            (row) => row.clientDocumentId.equals(analysis.clientDocumentId),
          ))
          .write(
            DocumentsCompanion(
              status: Value(_documentStatusForResult(analysis).name),
              updatedAt: Value(analysis.createdAt),
            ),
          );
      await (_database.delete(_database.analysisOperations)..where(
            (row) => row.clientDocumentId.equals(analysis.clientDocumentId),
          ))
          .go();
    });
  }

  @override
  Stream<List<PendingAnalysisOperation>> watchPending() {
    final query = _database.select(_database.analysisOperations)
      ..where(
        (row) => row.state.isIn([
          AnalysisLifecycleState.accepted.name,
          AnalysisLifecycleState.processing.name,
        ]),
      );
    return query.watch().map(
      (rows) => rows
          .map(
            (row) => PendingAnalysisOperation(
              operationId: row.operationId,
              clientDocumentId: row.clientDocumentId,
              state: AnalysisLifecycleState.values.byName(row.state),
            ),
          )
          .toList(),
    );
  }

  DocumentStatus _documentStatus(AnalysisLifecycleState state) =>
      switch (state) {
        AnalysisLifecycleState.succeeded => DocumentStatus.analyzed,
        AnalysisLifecycleState.failed ||
        AnalysisLifecycleState.expired => DocumentStatus.needsReview,
        _ => DocumentStatus.processing,
      };
  DocumentStatus _documentStatusForResult(DocumentAnalysis result) =>
      result.analysisStatus == AnalysisStatus.complete
      ? DocumentStatus.analyzed
      : DocumentStatus.needsReview;
}
