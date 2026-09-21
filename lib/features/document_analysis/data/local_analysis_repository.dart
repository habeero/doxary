import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart'
    hide
        AnalysisAmount,
        AnalysisAppointment,
        AnalysisDeadline,
        AnalysisRequiredDocument,
        AnalysisSuggestedTask;
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
    return rows.isEmpty ? null : await _toDomain(rows.single);
  }

  @override
  Stream<DocumentAnalysis?> watchLatest(String clientDocumentId) async* {
    yield* (_database.select(_database.analyses)
          ..where((row) => row.clientDocumentId.equals(clientDocumentId))
          ..orderBy([(row) => OrderingTerm.desc(row.createdAt)])
          ..limit(1))
        .watch()
        .asyncMap((rows) => rows.isEmpty ? null : _toDomain(rows.single));
  }

  @override
  Future<DocumentAnalysis?> getById(String analysisId) async {
    final row = await (_database.select(
      _database.analyses,
    )..where((item) => item.id.equals(analysisId))).getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<List<AnalysisAttempt>> getHistory(String clientDocumentId) =>
      _historyQuery(clientDocumentId)
          .get()
          .then((rows) => rows.map(_attemptFromRow).toList(growable: false));

  @override
  Stream<List<AnalysisAttempt>> watchHistory(String clientDocumentId) =>
      _historyQuery(clientDocumentId)
          .watch()
          .map((rows) => rows.map(_attemptFromRow).toList(growable: false));

  Selectable<QueryRow> _historyQuery(String clientDocumentId) =>
      _database.customSelect(
        '''SELECT attempt_id, client_document_id, started_at, terminal_at,
            status, result_analysis_id, failure_code, retryable
           FROM analysis_attempt_history
           WHERE client_document_id = ?
           ORDER BY COALESCE(terminal_at, started_at) DESC, started_at DESC''',
        variables: [Variable<String>(clientDocumentId)],
        readsFrom: {_database.analyses, _database.analysisOperations},
      );

  AnalysisAttempt _attemptFromRow(QueryRow row) => AnalysisAttempt(
    id: row.read<String>('attempt_id'),
    clientDocumentId: row.read<String>('client_document_id'),
    startedAt: _dateTime(row.read<int>('started_at')),
    terminalAt: _dateTimeOrNull(row.readNullable<int>('terminal_at')),
    status: AnalysisAttemptStatus.values.byName(row.read<String>('status')),
    analysisId: row.readNullable<String>('result_analysis_id'),
    failureCode: row.readNullable<String>('failure_code'),
    retryable: _boolOrNull(row.readNullable<int>('retryable')),
  );

  Future<DocumentAnalysis> _toDomain(Analyse row) async {
    final qualityRows = await (_database.select(
      _database.analysisQualityReasons,
    )..where((item) => item.analysisId.equals(row.id))).get();
    final nextActions =
        await (_database.select(_database.analysisNextActions)
              ..where((item) => item.analysisId.equals(row.id))
              ..orderBy([(item) => OrderingTerm.asc(item.position)]))
            .get();
    final uncertainties =
        await (_database.select(_database.analysisUncertainties)
              ..where((item) => item.analysisId.equals(row.id))
              ..orderBy([(item) => OrderingTerm.asc(item.position)]))
            .get();
    final practicalStates =
        await (_database.select(_database.analysisPracticalStates)
              ..where((item) => item.analysisId.equals(row.id))
              ..orderBy([(item) => OrderingTerm.asc(item.position)]))
            .get();
    final deadlines =
        await (_database.select(_database.analysisDeadlines)
              ..where((item) => item.analysisId.equals(row.id))
              ..orderBy([(item) => OrderingTerm.asc(item.position)]))
            .get();
    final appointments =
        await (_database.select(_database.analysisAppointments)
              ..where((item) => item.analysisId.equals(row.id))
              ..orderBy([(item) => OrderingTerm.asc(item.position)]))
            .get();
    final amounts =
        await (_database.select(_database.analysisAmounts)
              ..where((item) => item.analysisId.equals(row.id))
              ..orderBy([(item) => OrderingTerm.asc(item.position)]))
            .get();
    final requiredDocuments =
        await (_database.select(_database.analysisRequiredDocuments)
              ..where((item) => item.analysisId.equals(row.id))
              ..orderBy([(item) => OrderingTerm.asc(item.position)]))
            .get();
    final suggestedTasks =
        await (_database.select(_database.analysisSuggestedTasks)
              ..where((item) => item.analysisId.equals(row.id))
              ..orderBy([(item) => OrderingTerm.asc(item.position)]))
            .get();
    return DocumentAnalysis(
      id: row.id,
      clientDocumentId: row.clientDocumentId,
      schemaVersion: row.schemaVersion,
      targetLanguage: row.targetLanguage,
      summary: row.summary,
      explanation: row.explanation,
      documentDate: row.documentDate,
      createdAt: row.createdAt,
      analysisStatus: AnalysisStatus.values.byName(row.analysisStatus),
      actionRequired: row.actionRequired == null
          ? null
          : ActionRequirement.values.byName(row.actionRequired!),
      explanationStyle: ExplanationStyle.values.byName(row.explanationStyle),
      detectedLanguage: row.detectedLanguage,
      urgency: AnalysisUrgency.values.byName(row.urgency),
      confidence: row.confidence,
      practicalStates: practicalStates
          .map((item) => PracticalState.values.byName(item.state))
          .toList(growable: false),
      uncertainties: uncertainties
          .map((item) => item.message)
          .toList(growable: false),
      classification:
          row.suggestedOrganizationName == null &&
              row.suggestedDocumentType == null
          ? null
          : ClassificationSuggestion(
              organizationName: row.suggestedOrganizationName,
              documentType: row.suggestedDocumentType,
            ),
      qualityReasons: qualityRows
          .map((item) => DocumentQualityReason.values.byName(item.reason))
          .toList(growable: false),
      nextActions: nextActions
          .map((item) => item.value)
          .toList(growable: false),
      deadlines: deadlines
          .map(
            (item) => AnalysisDeadline(
              label: item.label,
              dateOrRange: item.dateOrRange,
              confidence: item.confidence,
              time: item.time,
              timezone: item.timezone,
              consequence: item.consequence,
              sourceReference: item.sourceReference,
            ),
          )
          .toList(growable: false),
      appointments: appointments
          .map(
            (item) => AnalysisAppointment(
              label: item.label,
              startOrDate: item.startOrDate,
              confidence: item.confidence,
              end: item.end,
              location: item.location,
              preparation: item.preparation,
              sourceReference: item.sourceReference,
            ),
          )
          .toList(growable: false),
      amounts: amounts
          .map(
            (item) => AnalysisAmount(
              value: item.value,
              currency: item.currency,
              direction: AmountDirection.values.byName(item.direction),
              confidence: item.confidence,
              dueDate: item.dueDate,
              purpose: item.purpose,
              sourceReference: item.sourceReference,
            ),
          )
          .toList(growable: false),
      requiredDocuments: requiredDocuments
          .map(
            (item) => AnalysisRequiredDocument(
              description: item.description,
              confidence: item.confidence,
              dueDate: item.dueDate,
              submissionMethod: item.submissionMethod,
              sourceReference: item.sourceReference,
            ),
          )
          .toList(growable: false),
      suggestedTasks: suggestedTasks
          .map(
            (item) => AnalysisSuggestedTask(
              title: item.title,
              confidence: item.confidence,
              dueDate: item.dueDate,
              instructions: item.instructions,
              sourceReference: item.sourceReference,
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<void> saveOperation({
    required String operationId,
    required String clientDocumentId,
    required AnalysisLifecycleState state,
    String? failureCode,
    bool? retryable,
  }) async {
    final now = DateTime.now();
    await _database.transaction(() async {
      final existing = await (_database.select(
        _database.analysisOperations,
      )..where((row) => row.operationId.equals(operationId))).getSingleOrNull();
      if (existing != null &&
          existing.clientDocumentId == clientDocumentId &&
          existing.state == state.name &&
          existing.lastFailureCode == failureCode) {
        return;
      }
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
      await _database.customStatement(
        '''INSERT INTO analysis_attempt_history (
            attempt_id, client_document_id, started_at, terminal_at, status,
            result_analysis_id, failure_code, retryable
          ) VALUES (?, ?, ?, ?, ?, NULL, ?, ?)
          ON CONFLICT(attempt_id) DO UPDATE SET
            terminal_at = excluded.terminal_at,
            status = excluded.status,
            failure_code = excluded.failure_code,
            retryable = excluded.retryable''',
        [
          operationId,
          clientDocumentId,
          now.millisecondsSinceEpoch,
          state == AnalysisLifecycleState.failed ||
                  state == AnalysisLifecycleState.expired
              ? now.millisecondsSinceEpoch
              : null,
          _attemptStatus(state).name,
          failureCode,
          retryable == null ? null : (retryable ? 1 : 0),
        ],
      );
      await (_database.update(
        _database.documents,
      )..where((row) => row.clientDocumentId.equals(clientDocumentId))).write(
        DocumentsCompanion(
          status: Value(_documentStatus(state).name),
          updatedAt: Value(now),
        ),
      );
      if (state == AnalysisLifecycleState.failed ||
          state == AnalysisLifecycleState.expired) {
        await (_database.delete(_database.analysisOperations)
              ..where((row) => row.operationId.equals(operationId)))
            .go();
      }
    });
  }

  @override
  Future<void> saveCompleted(DocumentAnalysis analysis) async {
    await _database.transaction(() async {
      final pendingOperation =
          await (_database.select(_database.analysisOperations)
                ..where(
                  (row) =>
                      row.clientDocumentId.equals(analysis.clientDocumentId) &
                      row.state.isIn([
                        AnalysisLifecycleState.accepted.name,
                        AnalysisLifecycleState.processing.name,
                      ]),
                )
                ..orderBy([(row) => OrderingTerm.desc(row.createdAt)])
                ..limit(1))
              .getSingleOrNull();
      await _database
          .into(_database.analyses)
          .insertOnConflictUpdate(
            AnalysesCompanion.insert(
              id: analysis.id,
              clientDocumentId: analysis.clientDocumentId,
              schemaVersion: analysis.schemaVersion,
              targetLanguage: analysis.targetLanguage,
              summary: Value(analysis.summary),
              explanation: Value(analysis.explanation),
              state: analysis.analysisStatus.name,
              analysisStatus: Value(analysis.analysisStatus.name),
              actionRequired: Value(analysis.actionRequired?.name),
              documentDate: Value(analysis.documentDate),
              detectedLanguage: Value(analysis.detectedLanguage),
              urgency: Value(analysis.urgency.name),
              confidence: Value(analysis.confidence),
              explanationStyle: Value(analysis.explanationStyle.name),
              suggestedOrganizationName: Value(
                analysis.classification?.organizationName,
              ),
              suggestedDocumentType: Value(
                analysis.classification?.documentType,
              ),
              createdAt: analysis.createdAt,
            ),
          );
      await (_database.delete(
        _database.analysisQualityReasons,
      )..where((item) => item.analysisId.equals(analysis.id))).go();
      await (_database.delete(
        _database.sourceReferences,
      )..where((item) => item.analysisId.equals(analysis.id))).go();
      await (_database.delete(
        _database.analysisNextActions,
      )..where((item) => item.analysisId.equals(analysis.id))).go();
      await (_database.delete(
        _database.analysisUncertainties,
      )..where((item) => item.analysisId.equals(analysis.id))).go();
      await (_database.delete(
        _database.analysisPracticalStates,
      )..where((item) => item.analysisId.equals(analysis.id))).go();
      await (_database.delete(
        _database.analysisDeadlines,
      )..where((item) => item.analysisId.equals(analysis.id))).go();
      await (_database.delete(
        _database.analysisAppointments,
      )..where((item) => item.analysisId.equals(analysis.id))).go();
      await (_database.delete(
        _database.analysisAmounts,
      )..where((item) => item.analysisId.equals(analysis.id))).go();
      await (_database.delete(
        _database.analysisRequiredDocuments,
      )..where((item) => item.analysisId.equals(analysis.id))).go();
      await (_database.delete(
        _database.analysisSuggestedTasks,
      )..where((item) => item.analysisId.equals(analysis.id))).go();
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
      for (final (index, value) in analysis.nextActions.indexed) {
        await _database
            .into(_database.analysisNextActions)
            .insert(
              AnalysisNextActionsCompanion.insert(
                id: '${analysis.id}-next-$index',
                analysisId: analysis.id,
                position: index,
                value: value,
              ),
            );
      }
      for (final (index, value) in analysis.uncertainties.indexed) {
        await _database
            .into(_database.analysisUncertainties)
            .insert(
              AnalysisUncertaintiesCompanion.insert(
                id: '${analysis.id}-uncertainty-$index',
                analysisId: analysis.id,
                position: index,
                message: value,
              ),
            );
      }
      for (final (index, value) in analysis.practicalStates.indexed) {
        await _database
            .into(_database.analysisPracticalStates)
            .insert(
              AnalysisPracticalStatesCompanion.insert(
                id: '${analysis.id}-state-$index',
                analysisId: analysis.id,
                position: index,
                state: value.name,
              ),
            );
      }
      for (final (index, value) in analysis.deadlines.indexed) {
        await _database
            .into(_database.analysisDeadlines)
            .insert(
              AnalysisDeadlinesCompanion.insert(
                id: '${analysis.id}-deadline-$index',
                analysisId: analysis.id,
                position: index,
                label: value.label,
                dateOrRange: Value(value.dateOrRange),
                confidence: Value(value.confidence),
                time: Value(value.time),
                timezone: Value(value.timezone),
                consequence: Value(value.consequence),
                sourceReference: Value(value.sourceReference),
              ),
            );
      }
      for (final (index, value) in analysis.appointments.indexed) {
        await _database
            .into(_database.analysisAppointments)
            .insert(
              AnalysisAppointmentsCompanion.insert(
                id: '${analysis.id}-appointment-$index',
                analysisId: analysis.id,
                position: index,
                label: value.label,
                startOrDate: Value(value.startOrDate),
                confidence: Value(value.confidence),
                end: Value(value.end),
                location: Value(value.location),
                preparation: Value(value.preparation),
                sourceReference: Value(value.sourceReference),
              ),
            );
      }
      for (final (index, value) in analysis.amounts.indexed) {
        await _database
            .into(_database.analysisAmounts)
            .insert(
              AnalysisAmountsCompanion.insert(
                id: '${analysis.id}-amount-$index',
                analysisId: analysis.id,
                position: index,
                value: value.value,
                currency: value.currency,
                direction: value.direction.name,
                confidence: Value(value.confidence),
                dueDate: Value(value.dueDate),
                purpose: Value(value.purpose),
                sourceReference: Value(value.sourceReference),
              ),
            );
      }
      for (final (index, value) in analysis.requiredDocuments.indexed) {
        await _database
            .into(_database.analysisRequiredDocuments)
            .insert(
              AnalysisRequiredDocumentsCompanion.insert(
                id: '${analysis.id}-required-$index',
                analysisId: analysis.id,
                position: index,
                description: value.description,
                confidence: Value(value.confidence),
                dueDate: Value(value.dueDate),
                submissionMethod: Value(value.submissionMethod),
                sourceReference: Value(value.sourceReference),
              ),
            );
      }
      for (final (index, value) in analysis.suggestedTasks.indexed) {
        await _database
            .into(_database.analysisSuggestedTasks)
            .insert(
              AnalysisSuggestedTasksCompanion.insert(
                id: '${analysis.id}-task-$index',
                analysisId: analysis.id,
                position: index,
                title: value.title,
                confidence: Value(value.confidence),
                dueDate: Value(value.dueDate),
                instructions: Value(value.instructions),
                sourceReference: Value(value.sourceReference),
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
      await _database.customStatement(
        '''INSERT INTO analysis_attempt_history (
            attempt_id, client_document_id, started_at, terminal_at, status,
            result_analysis_id, failure_code, retryable
          ) VALUES (?, ?, ?, ?, 'succeeded', ?, NULL, NULL)
          ON CONFLICT(attempt_id) DO UPDATE SET
            terminal_at = excluded.terminal_at,
            status = 'succeeded',
            result_analysis_id = excluded.result_analysis_id,
            failure_code = NULL,
            retryable = NULL''',
        [
          pendingOperation?.operationId ?? 'analysis:${analysis.id}',
          analysis.clientDocumentId,
          pendingOperation?.createdAt.millisecondsSinceEpoch ??
              analysis.createdAt.millisecondsSinceEpoch,
          analysis.createdAt.millisecondsSinceEpoch,
          analysis.id,
        ],
      );
    });
  }

  @override
  Future<void> deleteAnalysis(String analysisId) async {
    await _database.transaction(() async {
      final analysis = await (_database.select(
        _database.analyses,
      )..where((row) => row.id.equals(analysisId))).getSingleOrNull();
      if (analysis == null) return;
      await _deleteAnalysisChildren(analysisId);
      await (_database.delete(
        _database.analyses,
      )..where((row) => row.id.equals(analysisId))).go();
      await _database.customStatement(
        'DELETE FROM analysis_attempt_history WHERE result_analysis_id = ?',
        [analysisId],
      );
      final remaining = await (_database.select(_database.analyses)
            ..where(
              (row) => row.clientDocumentId.equals(analysis.clientDocumentId),
            )
            ..limit(1))
          .getSingleOrNull();
      await (_database.update(_database.documents)
            ..where(
              (row) => row.clientDocumentId.equals(analysis.clientDocumentId),
            ))
          .write(
            DocumentsCompanion(
              status: Value(
                remaining == null
                    ? DocumentStatus.needsReview.name
                    : DocumentStatus.analyzed.name,
              ),
              updatedAt: Value(DateTime.now()),
            ),
          );
    });
  }

  Future<void> _deleteAnalysisChildren(String analysisId) async {
    await (_database.delete(_database.analysisQualityReasons)
          ..where((item) => item.analysisId.equals(analysisId)))
        .go();
    await (_database.delete(_database.sourceReferences)
          ..where((item) => item.analysisId.equals(analysisId)))
        .go();
    await (_database.delete(_database.analysisNextActions)
          ..where((item) => item.analysisId.equals(analysisId)))
        .go();
    await (_database.delete(_database.analysisUncertainties)
          ..where((item) => item.analysisId.equals(analysisId)))
        .go();
    await (_database.delete(_database.analysisPracticalStates)
          ..where((item) => item.analysisId.equals(analysisId)))
        .go();
    await (_database.delete(_database.analysisDeadlines)
          ..where((item) => item.analysisId.equals(analysisId)))
        .go();
    await (_database.delete(_database.analysisAppointments)
          ..where((item) => item.analysisId.equals(analysisId)))
        .go();
    await (_database.delete(_database.analysisAmounts)
          ..where((item) => item.analysisId.equals(analysisId)))
        .go();
    await (_database.delete(_database.analysisRequiredDocuments)
          ..where((item) => item.analysisId.equals(analysisId)))
        .go();
    await (_database.delete(_database.analysisSuggestedTasks)
          ..where((item) => item.analysisId.equals(analysisId)))
        .go();
  }

  @override
  Future<void> clearStalePendingOperations() async {
    await _database.transaction(() async {
      final operations =
          await (_database.select(_database.analysisOperations)..where(
                (row) => row.state.isIn([
                  AnalysisLifecycleState.accepted.name,
                  AnalysisLifecycleState.processing.name,
                ]),
              ))
              .get();
      for (final operation in operations) {
        final document =
            await (_database.select(_database.documents)..where(
                  (row) =>
                      row.clientDocumentId.equals(operation.clientDocumentId),
                ))
                .getSingleOrNull();
        if (document != null &&
            document.status != DocumentStatus.processing.name) {
          await (_database.delete(_database.analysisOperations)
                ..where((row) => row.operationId.equals(operation.operationId)))
              .go();
        }
      }
    });
  }

  @override
  Stream<List<PendingAnalysisOperation>> watchPending() {
    final query =
        _database.select(_database.analysisOperations).join([
            innerJoin(
              _database.documents,
              _database.documents.clientDocumentId.equalsExp(
                _database.analysisOperations.clientDocumentId,
              ),
            ),
          ])
          ..where(
            _database.analysisOperations.state.isIn([
              AnalysisLifecycleState.accepted.name,
              AnalysisLifecycleState.processing.name,
            ]),
          )
          ..where(
            _database.documents.status.equals(DocumentStatus.processing.name),
          );
    return query.watch().map(
      (rows) => rows.map((row) {
        final operation = row.readTable(_database.analysisOperations);
        return PendingAnalysisOperation(
          operationId: operation.operationId,
          clientDocumentId: operation.clientDocumentId,
          state: AnalysisLifecycleState.values.byName(operation.state),
        );
      }).toList(),
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

  AnalysisAttemptStatus _attemptStatus(AnalysisLifecycleState state) =>
      switch (state) {
        AnalysisLifecycleState.failed || AnalysisLifecycleState.expired =>
          AnalysisAttemptStatus.failed,
        AnalysisLifecycleState.succeeded => AnalysisAttemptStatus.succeeded,
        _ => AnalysisAttemptStatus.pending,
      };

  DateTime _dateTime(int value) => DateTime.fromMillisecondsSinceEpoch(value);
  DateTime? _dateTimeOrNull(int? value) =>
      value == null ? null : _dateTime(value);
  bool? _boolOrNull(int? value) => value == null ? null : value != 0;
}
