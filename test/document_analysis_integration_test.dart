import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:doxary/core/config/doxary_api_config.dart';
import 'package:doxary/core/database/app_database.dart'
    hide
        AnalysisAmount,
        AnalysisAppointment,
        AnalysisDeadline,
        AnalysisRequiredDocument,
        AnalysisSuggestedTask,
        DocumentFile;
import 'package:doxary/core/errors/app_error.dart';
import 'package:doxary/core/network/doxary_api_client.dart';
import 'package:doxary/features/document_analysis/application/analysis_workflow.dart';
import 'package:doxary/features/document_analysis/data/analysis_result_mapper.dart';
import 'package:doxary/features/document_analysis/data/doxary_document_analysis_remote_data_source.dart';
import 'package:doxary/features/document_analysis/data/local_analysis_repository.dart';
import 'package:doxary/features/document_analysis/domain/analysis_submission.dart';
import 'package:doxary/features/document_analysis/domain/analysis_repository.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:doxary/features/tasks/data/repositories/local_task_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('API config normalizes bare host and preserves versioned base path', () {
    expect(
      DoxaryApiConfig(baseUri: Uri.parse('https://dox-api.habeero.de'))
          .resolve('document-analyses')
          .toString(),
      'https://dox-api.habeero.de/api/v1/document-analyses',
    );
    expect(
      DoxaryApiConfig(baseUri: Uri.parse('https://example.test/api/v1/'))
          .resolve('operations/op-1')
          .toString(),
      'https://example.test/api/v1/operations/op-1',
    );
  });

  test(
    'maps a complete Arabic result with typed facts and quality outcomes',
    () {
      final result = mapAnalysisResult(
        _result(),
        id: 'analysis-1',
        createdAt: DateTime(2026),
      );
      expect(result.targetLanguage, 'ar');
      expect(result.analysisStatus, AnalysisStatus.partial);
      expect(result.classification?.organizationName, 'Jobcenter');
      expect(result.deadlines.single.dateOrRange, '2026-10-01');
      expect(result.amounts.single.direction, AmountDirection.pay);
      expect(result.qualityReasons, [DocumentQualityReason.blurryImage]);
    },
  );

  test('maps the complete staging-shaped result including document date and evidence metadata', () {
    final payload = _result()
      ..['analysis_status'] = 'complete'
      ..['quality_issues'] = []
      ..['extracted_facts'] = {
        'document_date': {'value': '2026-09-01', 'source_text': '01.09.2026'},
        'deadlines': [],
        'appointments': [],
        'amounts': [],
        'required_documents': [],
        'suggested_tasks': [],
      };
    final result = mapAnalysisResult(
      payload,
      id: 'analysis-complete',
      createdAt: DateTime(2026),
    );
    expect(result.analysisStatus, AnalysisStatus.complete);
    expect(result.documentDate, '2026-09-01');
    expect(result.sourceReferences.single.pageIndex, isNull);
    expect(result.sourceReferences.single.fileId, isNull);
  });

  test('persists and restores every mapped action requirement', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LocalAnalysisRepository(database);
    final now = DateTime(2026);
    await _insertDocument(database, 'document-action');

    for (final action in ActionRequirement.values) {
      await repository.saveCompleted(
        DocumentAnalysis(
          id: 'analysis-${action.name}',
          clientDocumentId: 'document-action',
          schemaVersion: 'analysis_result.v1',
          targetLanguage: 'de',
          createdAt: now.add(Duration(seconds: action.index)),
          analysisStatus: AnalysisStatus.complete,
          actionRequired: action,
        ),
      );
      expect(
        (await repository.getLatest('document-action'))?.actionRequired,
        action,
      );
    }
  });

  test('legacy analysis row retains a missing action requirement', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LocalAnalysisRepository(database);
    final now = DateTime(2026);
    await _insertDocument(database, 'document-legacy-action');
    await database
        .into(database.analyses)
        .insert(
          AnalysesCompanion.insert(
            id: 'legacy-analysis',
            clientDocumentId: 'document-legacy-action',
            schemaVersion: 'analysis_result.v1',
            targetLanguage: 'de',
            state: AnalysisStatus.complete.name,
            analysisStatus: Value(AnalysisStatus.complete.name),
            actionRequired: const Value(null),
            explanationStyle: Value(ExplanationStyle.standard.name),
            createdAt: now,
          ),
        );

    final restored = await repository.getLatest('document-legacy-action');
    expect(restored?.analysisStatus, AnalysisStatus.complete);
    expect(restored?.actionRequired, isNull);
  });

  test(
    'completed analysis round trip retains normalized Result facts',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await _insertDocument(database, 'document-round-trip');
      final repository = LocalAnalysisRepository(database);
      final analysis = DocumentAnalysis(
        id: 'analysis-round-trip',
        clientDocumentId: 'document-round-trip',
        schemaVersion: 'analysis_result.v1',
        targetLanguage: 'de',
        createdAt: DateTime(2026),
        documentDate: '2026-09-15',
        detectedLanguage: 'de',
        urgency: AnalysisUrgency.high,
        confidence: .9,
        actionRequired: ActionRequirement.yes,
        analysisStatus: AnalysisStatus.complete,
        practicalStates: const [PracticalState.payment],
        uncertainties: const ['Verify the date'],
        nextActions: const ['Pay the amount'],
        deadlines: const [
          AnalysisDeadline(
            label: 'Pay',
            dateOrRange: '2026-10-01',
            confidence: .8,
            consequence: 'Reminder',
          ),
        ],
        appointments: const [
          AnalysisAppointment(
            label: 'Meeting',
            startOrDate: '2026-10-02',
            confidence: .7,
            location: 'Berlin',
          ),
        ],
        amounts: const [
          AnalysisAmount(
            value: '128.40',
            currency: 'EUR',
            direction: AmountDirection.pay,
            confidence: .9,
            dueDate: '2026-10-01',
            purpose: 'Invoice',
          ),
        ],
        requiredDocuments: const [
          AnalysisRequiredDocument(
            description: 'Proof',
            confidence: .8,
            dueDate: '2026-10-03',
          ),
        ],
        suggestedTasks: const [
          AnalysisSuggestedTask(
            title: 'Pay invoice',
            confidence: .9,
            dueDate: '2026-10-01',
            instructions: 'Use reference',
          ),
        ],
        qualityReasons: const [DocumentQualityReason.blurryImage],
        classification: const ClassificationSuggestion(
          organizationName: 'SAGA',
        ),
      );
      await repository.saveCompleted(analysis);
      await repository.saveCompleted(analysis);
      final restored = await repository.getLatest('document-round-trip');
      expect(restored?.documentDate, analysis.documentDate);
      expect(restored?.nextActions, analysis.nextActions);
      expect(restored?.uncertainties, analysis.uncertainties);
      expect(restored?.deadlines.single.consequence, 'Reminder');
      expect(restored?.appointments.single.location, 'Berlin');
      expect(restored?.amounts.single.purpose, 'Invoice');
      expect(restored?.requiredDocuments.single.description, 'Proof');
      expect(restored?.suggestedTasks.single.instructions, 'Use reference');
      expect(restored?.practicalStates, analysis.practicalStates);
      expect(restored?.qualityReasons, analysis.qualityReasons);
      expect(restored?.classification?.organizationName, 'SAGA');
      expect(
        await database.select(database.analysisAmounts).get(),
        hasLength(1),
      );
    },
  );

  test('incompatible result payload fails safely', () {
    expect(
      () => mapAnalysisResult(
        {'schema_version': 'analysis_result.v1'},
        id: 'a',
        createdAt: DateTime(2026),
      ),
      throwsA(isA<FormatException>()),
    );
  });

  test('submission retry preserves key and client document while new submission differs', () {
    final first = AnalysisSubmission(
      clientDocumentId: 'document-1',
      files: const [],
      language: ExplanationLanguage.german,
      style: ExplanationStyle.simple,
      idempotencyKey: 'key-1',
    );
    final retry = first.copyWith();
    final second = AnalysisSubmission(
      clientDocumentId: 'document-2',
      files: const [],
      language: ExplanationLanguage.german,
      style: ExplanationStyle.simple,
      idempotencyKey: 'key-2',
    );
    expect(retry.idempotencyKey, first.idempotencyKey);
    expect(retry.clientDocumentId, first.clientDocumentId);
    expect(second.idempotencyKey, isNot(first.idempotencyKey));
    expect(second.clientDocumentId, isNot(first.clientDocumentId));
  });

  test('a cold local store has no active processing operations', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    expect(
      await LocalAnalysisRepository(database).watchPending().first,
      isEmpty,
    );
  });

  test('multipart submission preserves files, language, idempotency, and repeated page indexes', () async {
    final directory = await Directory.systemTemp.createTemp(
      'doxary-analysis-test',
    );
    addTearDown(() => directory.delete(recursive: true));
    final first = File('${directory.path}/first.jpg')
      ..writeAsBytesSync([0xff, 0xd8, 0xff]);
    final second = File('${directory.path}/second.png')
      ..writeAsBytesSync([0x89, 0x50, 0x4e, 0x47]);
    final transport = _RecordingClient(
      _jsonResponse({
        'operation_id': 'op-1',
        'status': 'accepted',
        'request_id': 'request-1',
      }, 202),
    );
    final source = DoxaryDocumentAnalysisRemoteDataSource(
      DoxaryApiClient(
        DoxaryApiConfig(baseUri: Uri.parse('http://example.test/api/v1/')),
        client: transport,
      ),
    );
    await source.submit(
      AnalysisSubmission(
        clientDocumentId: 'document-1',
        language: ExplanationLanguage.german,
        style: ExplanationStyle.simple,
        idempotencyKey: 'idempotency-1',
        files: [
          _file('file-2', second, 'image/png', 1),
          _file('file-1', first, 'image/jpeg', 0),
        ],
      ),
    );
    expect(transport.request!.headers['Idempotency-Key'], 'idempotency-1');
    expect(transport.body, contains('name="output_language"\r\n\r\nde'));
    expect(transport.body, contains('name="output_style"\r\n\r\nsimple'));
    expect(_allIndexes(transport.body), ['0', '1']);

    final arabicTransport = _RecordingClient(
      _jsonResponse({
        'operation_id': 'op-arabic',
        'status': 'accepted',
        'request_id': 'request-arabic',
      }, 202),
    );
    final arabicSource = DoxaryDocumentAnalysisRemoteDataSource(
      DoxaryApiClient(
        DoxaryApiConfig(baseUri: Uri.parse('http://example.test/api/v1/')),
        client: arabicTransport,
      ),
    );
    await arabicSource.submit(
      AnalysisSubmission(
        clientDocumentId: 'document-1',
        language: ExplanationLanguage.arabic,
        style: ExplanationStyle.standard,
        idempotencyKey: 'idempotency-arabic',
        files: [_file('file-1', first, 'image/jpeg', 0)],
      ),
    );
    expect(arabicTransport.body, contains('name="output_language"\r\n\r\nar'));
  });

  test('polling persists a new completed analysis version without changing document identity', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final now = DateTime(2026);
    await database
        .into(database.documents)
        .insert(
          DocumentsCompanion.insert(
            clientDocumentId: 'document-1',
            classificationState: 'confirmed',
            status: 'imported',
            createdAt: now,
            updatedAt: now,
          ),
        );
    final local = LocalAnalysisRepository(database);
    final remote = _FakeRemote([
      const BackendOperation(
        operationId: 'op-1',
        status: BackendOperationStatus.processing,
        requestId: 'r-1',
      ),
      BackendOperation(
        operationId: 'op-1',
        status: BackendOperationStatus.succeeded,
        requestId: 'r-2',
        result: mapAnalysisResult(_result(), id: 'version-2', createdAt: now),
      ),
    ]);
    final workflow = AnalysisWorkflow(
      remote,
      local,
      maxPolls: 3,
      wait: (_) async {},
    );
    final terminal = await workflow.poll('op-1', 'document-1');
    expect(terminal.status, BackendOperationStatus.succeeded);
    expect(await database.select(database.analyses).get(), hasLength(1));
    expect((await local.getLatest('document-1'))?.qualityReasons, [
      DocumentQualityReason.blurryImage,
    ]);
    expect(
      (await database.select(database.documents).get()).single.clientDocumentId,
      'document-1',
    );
    expect(await database.select(database.analysisOperations).get(), isEmpty);
    expect(remote.submitCalls, 0);
  });

  test('only non-terminal pending operations are exposed and duplicate saves are idempotent', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final local = LocalAnalysisRepository(database);
    await _insertDocument(database, 'document-one');
    await _insertDocument(database, 'document-two');

    await local.saveOperation(
      operationId: 'op-one',
      clientDocumentId: 'document-one',
      state: AnalysisLifecycleState.accepted,
    );
    final firstSaved =
        (await database.select(database.analysisOperations).get())
            .single
            .updatedAt;
    await local.saveOperation(
      operationId: 'op-one',
      clientDocumentId: 'document-one',
      state: AnalysisLifecycleState.accepted,
    );
    await local.saveOperation(
      operationId: 'op-two',
      clientDocumentId: 'document-two',
      state: AnalysisLifecycleState.processing,
    );

    final operations = await local.watchPending().first;
    final saved = await database.select(database.analysisOperations).get();
    expect(operations.map((operation) => operation.operationId).toSet(), {
      'op-one',
      'op-two',
    });
    expect(saved, hasLength(2));
    expect(
      saved
          .singleWhere((operation) => operation.operationId == 'op-one')
          .updatedAt,
      firstSaved,
    );
  });

  test('startup removes stale active correlations without polling or fabricating completion', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final local = LocalAnalysisRepository(database);
    await _insertDocument(database, 'document-terminal');
    final now = DateTime(2026);
    await (database.update(
      database.documents,
    )..where((row) => row.clientDocumentId.equals('document-terminal'))).write(
      DocumentsCompanion(
        status: Value(DocumentStatus.analyzed.name),
        updatedAt: Value(now),
      ),
    );
    await database
        .into(database.analysisOperations)
        .insert(
          AnalysisOperationsCompanion.insert(
            operationId: 'stale-operation',
            clientDocumentId: 'document-terminal',
            state: AnalysisLifecycleState.processing.name,
            createdAt: now,
            updatedAt: now,
          ),
        );
    final remote = _FakeRemote([]);
    final workflow = AnalysisWorkflow(remote, local, wait: (_) async {});

    await workflow.resumePending();

    expect(await local.watchPending().first, isEmpty);
    expect(await database.select(database.analysisOperations).get(), isEmpty);
    expect(remote.getCalls, 0);
    expect(
      (await database.select(database.documents).get()).single.status,
      DocumentStatus.analyzed.name,
    );
  });

  test(
    'accepted operation transitions to terminal failure without another POST',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final local = LocalAnalysisRepository(database);
      await _insertDocument(database, 'document-failed');
      await local.saveOperation(
        operationId: 'op-failed',
        clientDocumentId: 'document-failed',
        state: AnalysisLifecycleState.accepted,
      );
      final remote = _FakeRemote([
        const BackendOperation(
          operationId: 'op-failed',
          status: BackendOperationStatus.failed,
          requestId: null,
          failureCode: 'processing_failed',
          failureRetryable: false,
        ),
      ]);
      final workflow = AnalysisWorkflow(remote, local, wait: (_) async {});

      await expectLater(
        workflow.poll('op-failed', 'document-failed'),
        throwsA(
          isA<RemoteApiError>()
              .having((error) => error.code, 'code', 'processing_failed')
              .having(
                (error) => error.isTerminalOperationFailure,
                'isTerminalOperationFailure',
                true,
              )
              .having((error) => error.retryable, 'retryable', false),
        ),
      );

      final operations = await database
          .select(database.analysisOperations)
          .get();
      final documents = await database.select(database.documents).get();
      expect(remote.getCalls, 1);
      expect(remote.submitCalls, 0);
      expect(operations, isEmpty);
      final history = await local.getHistory('document-failed');
      expect(history.single.status, AnalysisAttemptStatus.failed);
      expect(history.single.failureCode, 'processing_failed');
      expect(documents.single.status, DocumentStatus.needsReview.name);
      expect(await local.watchPending().first, isEmpty);
    },
  );

  test('processing operation stops polling when it reaches failed', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final local = LocalAnalysisRepository(database);
    await _insertDocument(database, 'document-processing-failed');
    final remote = _FakeRemote([
      const BackendOperation(
        operationId: 'op-processing-failed',
        status: BackendOperationStatus.processing,
        requestId: null,
      ),
      const BackendOperation(
        operationId: 'op-processing-failed',
        status: BackendOperationStatus.failed,
        requestId: null,
        failureCode: 'analysis_unavailable',
        failureRetryable: true,
      ),
    ]);
    final workflow = AnalysisWorkflow(
      remote,
      local,
      maxPolls: 3,
      wait: (_) async {},
    );

    await expectLater(
      workflow.poll('op-processing-failed', 'document-processing-failed'),
      throwsA(
        isA<RemoteApiError>()
            .having((error) => error.code, 'code', 'analysis_unavailable')
            .having((error) => error.retryable, 'retryable', true),
      ),
    );

    final operations = await database.select(database.analysisOperations).get();
    expect(remote.getCalls, 2);
    expect(remote.submitCalls, 0);
    expect(operations, isEmpty);
    final history = await local.getHistory('document-processing-failed');
    expect(history.single.status, AnalysisAttemptStatus.failed);
    expect(history.single.failureCode, 'analysis_unavailable');
    expect(history.single.retryable, isTrue);
    expect(await local.watchPending().first, isEmpty);
  });

  test(
    'expired results are explicit and failed operations stay distinct',
    () async {
      final source = DoxaryDocumentAnalysisRemoteDataSource(
        DoxaryApiClient(
          DoxaryApiConfig(baseUri: Uri.parse('http://example.test/api/v1/')),
          client: _RecordingClient(
            _jsonResponse({
              'error': {
                'code': 'operation_expired',
                'message': 'expired',
                'retryable': false,
              },
              'request_id': 'r',
            }, 410),
          ),
        ),
      );
      await expectLater(
        source.getOperation('op'),
        throwsA(
          isA<RemoteApiError>().having(
            (error) => error.code,
            'code',
            'operation_expired',
          ),
        ),
      );
    },
  );

  test('unknown operation status is a safe malformed-response error', () async {
    final source = DoxaryDocumentAnalysisRemoteDataSource(
      DoxaryApiClient(
        DoxaryApiConfig(baseUri: Uri.parse('http://example.test')),
        client: _RecordingClient(
          _jsonResponse({
            'operation_id': 'op',
            'status': 'mystery',
            'request_id': 'r',
          }, 200),
        ),
      ),
    );
    await expectLater(
      source.getOperation('op'),
      throwsA(isA<MalformedRemoteResponseError>()),
    );
  });

  test(
    'failed operation parses safe code and retryability without its message',
    () async {
      final source = DoxaryDocumentAnalysisRemoteDataSource(
        DoxaryApiClient(
          DoxaryApiConfig(baseUri: Uri.parse('http://example.test')),
          client: _RecordingClient(
            _jsonResponse({
              'failure': {
                'code': 'analysis_unavailable',
                'message': 'This must never reach Flutter logs or UI.',
                'retryable': true,
              },
              'operation_id': 'op-failed',
              'status': 'failed',
            }, 200),
          ),
        ),
      );

      final operation = await source.getOperation('op-failed');
      expect(operation.status, BackendOperationStatus.failed);
      expect(operation.failureCode, 'analysis_unavailable');
      expect(operation.failureRetryable, true);
    },
  );

  test('succeeded operation envelope without request_id maps through production DTO path', () async {
    final payload = _result()
      ..['analysis_status'] = 'complete'
      ..['quality_issues'] = [];
    final source = DoxaryDocumentAnalysisRemoteDataSource(
      DoxaryApiClient(
        DoxaryApiConfig(baseUri: Uri.parse('http://example.test')),
        client: _RecordingClient(
          _jsonResponse({
            'failure': null,
            'operation_id': 'op-succeeded',
            'result': payload,
            'status': 'succeeded',
          }, 200),
        ),
      ),
    );
    final operation = await source.getOperation('op-succeeded');
    expect(operation.status, BackendOperationStatus.succeeded);
    expect(operation.requestId, isNull);
    expect(operation.result?.analysisStatus, AnalysisStatus.complete);
  });

  test('invalid enum mapping reports only path and token category', () async {
    final payload = _result()
      ..['extracted_facts'] = {
        'deadlines': [],
        'appointments': [],
        'amounts': [
          {
            'value': '12.50',
            'currency': 'EUR',
            'purpose': 'Fee',
            'direction': 'invalid',
            'evidence_reference_ids': [],
          },
        ],
        'required_documents': [],
        'suggested_tasks': [],
      };
    final logs = <String>[];
    final previous = debugPrint;
    debugPrint = (message, {wrapWidth}) {
      if (message is String) logs.add(message);
    };
    addTearDown(() => debugPrint = previous);
    final source = DoxaryDocumentAnalysisRemoteDataSource(
      DoxaryApiClient(
        DoxaryApiConfig(baseUri: Uri.parse('http://example.test')),
        client: _RecordingClient(
          _jsonResponse({
            'failure': null,
            'operation_id': 'op-invalid-enum',
            'result': payload,
            'status': 'succeeded',
          }, 200),
        ),
      ),
    );
    await expectLater(
      source.getOperation('op-invalid-enum'),
      throwsA(isA<MalformedRemoteResponseError>()),
    );
    expect(
      logs,
      contains(
        '[DoxaryAnalysis][domain_mapping] failed path=amounts[0].direction type=ArgumentError token_category=unknown_enum_token',
      ),
    );
  });

  test('uppercase enum variant remains invalid and is classified without its value', () async {
    final payload = _result()
      ..['extracted_facts'] = {
        'deadlines': [],
        'appointments': [],
        'amounts': [
          {
            'value': '12.50',
            'currency': 'EUR',
            'purpose': 'Fee',
            'direction': 'PAY',
            'evidence_reference_ids': [],
          },
        ],
        'required_documents': [],
        'suggested_tasks': [],
      };
    final logs = <String>[];
    final previous = debugPrint;
    debugPrint = (message, {wrapWidth}) {
      if (message is String) logs.add(message);
    };
    addTearDown(() => debugPrint = previous);

    expect(
      () =>
          mapAnalysisResult(payload, id: 'analysis', createdAt: DateTime(2026)),
      throwsA(isA<ArgumentError>()),
    );
    expect(
      logs,
      contains(
        '[DoxaryAnalysis][domain_mapping] failed path=amounts[0].direction type=ArgumentError token_category=uppercase_variant',
      ),
    );
  });

  test(
    'analysis history keeps failures and successful versions independently',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      const documentId = 'history-document';
      await _insertDocument(database, documentId);
      final repository = LocalAnalysisRepository(database);
      await repository.saveOperation(
        operationId: 'failed-attempt',
        clientDocumentId: documentId,
        state: AnalysisLifecycleState.failed,
        failureCode: 'processing_failed',
        retryable: true,
      );
      await repository.saveOperation(
        operationId: 'successful-attempt',
        clientDocumentId: documentId,
        state: AnalysisLifecycleState.accepted,
      );
      final firstCreated = DateTime(2026, 9, 20, 9);
      final secondCreated = DateTime(2026, 9, 21, 9);
      await repository.saveCompleted(
        DocumentAnalysis(
          id: 'analysis-one',
          clientDocumentId: documentId,
          schemaVersion: 'analysis_result.v1',
          targetLanguage: 'de',
          createdAt: firstCreated,
        ),
      );
      await repository.saveOperation(
        operationId: 'successful-attempt-two',
        clientDocumentId: documentId,
        state: AnalysisLifecycleState.accepted,
      );
      await repository.saveCompleted(
        DocumentAnalysis(
          id: 'analysis-two',
          clientDocumentId: documentId,
          schemaVersion: 'analysis_result.v1',
          targetLanguage: 'de',
          createdAt: secondCreated,
        ),
      );

      final history = await repository.getHistory(documentId);
      expect(history, hasLength(3));
      expect(
        history.where((item) => item.status == AnalysisAttemptStatus.succeeded),
        hasLength(2),
      );
      expect(history.any((item) => item.analysisId == 'analysis-two'), isTrue);
      expect(await repository.getById('analysis-one'), isNotNull);

      await repository.deleteAnalysis('analysis-two');
      expect(await repository.getById('analysis-two'), isNull);
      expect(await repository.getById('analysis-one'), isNotNull);
      final remainingHistory = await repository.getHistory(documentId);
      expect(remainingHistory, hasLength(3));
      expect(
        remainingHistory.any(
          (item) => item.status == AnalysisAttemptStatus.failed,
        ),
        isTrue,
      );
      final deleted = remainingHistory.singleWhere(
        (item) => item.analysisId == 'analysis-two',
      );
      expect(deleted.deletedAt, isNotNull);
      expect(deleted.resultAnalysisStatus, AnalysisStatus.complete);
    },
  );

  test(
    'schema v9-to-v11 migration repairs seconds-scale history timestamps',
    () async {
      final expectedInstant = DateTime(2026, 9, 24, 12);
      final expectedMilliseconds = expectedInstant.millisecondsSinceEpoch;
      final legacySeconds = expectedMilliseconds ~/ 1000;
      final executor = NativeDatabase.memory(
        setup: (raw) {
          raw.execute('PRAGMA user_version = 9');
          raw.execute('''
          CREATE TABLE analysis_attempt_history (
            attempt_id TEXT PRIMARY KEY NOT NULL,
            client_document_id TEXT NOT NULL,
            started_at INTEGER NOT NULL,
            terminal_at INTEGER,
            status TEXT NOT NULL,
            result_analysis_id TEXT,
            failure_code TEXT,
            retryable INTEGER
          )
        ''');
          raw.execute('''
          INSERT INTO analysis_attempt_history VALUES
            ('legacy-seconds', 'history-document', $legacySeconds,
             $legacySeconds, 'failed', NULL, 'processing_failed', 1),
            ('existing-milliseconds', 'history-document',
             $expectedMilliseconds, $expectedMilliseconds, 'pending',
             NULL, NULL, NULL),
            ('null-terminal', 'history-document', $expectedMilliseconds,
             NULL, 'pending', NULL, NULL, NULL),
            ('mixed-units', 'history-document', $expectedMilliseconds,
             $legacySeconds, 'failed', NULL, 'processing_failed', 1)
        ''');
        },
      );
      final database = AppDatabase(executor);
      addTearDown(database.close);

      final raw = await database
          .customSelect(
            'SELECT attempt_id, started_at, terminal_at FROM analysis_attempt_history',
          )
          .get();
      final rawById = {
        for (final row in raw) row.read<String>('attempt_id'): row,
      };
      expect(
        rawById['legacy-seconds']!.read<int>('started_at'),
        expectedMilliseconds,
      );
      expect(
        rawById['legacy-seconds']!.read<int>('terminal_at'),
        expectedMilliseconds,
      );
      expect(
        rawById['existing-milliseconds']!.read<int>('started_at'),
        expectedMilliseconds,
      );
      expect(
        rawById['existing-milliseconds']!.read<int>('terminal_at'),
        expectedMilliseconds,
      );
      expect(
        rawById['null-terminal']!.readNullable<int>('terminal_at'),
        isNull,
      );
      expect(
        rawById['mixed-units']!.read<int>('started_at'),
        expectedMilliseconds,
      );
      expect(
        rawById['mixed-units']!.read<int>('terminal_at'),
        expectedMilliseconds,
      );

      final history = await LocalAnalysisRepository(database)
          .getHistory('history-document');
      final legacyAttempt = history.singleWhere(
        (attempt) => attempt.id == 'legacy-seconds',
      );
      final expectedLocalInstant = DateTime.fromMillisecondsSinceEpoch(
        expectedMilliseconds,
      );
      expect(legacyAttempt.startedAt, expectedLocalInstant);
      expect(legacyAttempt.startedAt.year, 2026);
      expect(legacyAttempt.terminalAt, expectedLocalInstant);
      expect(
        history
            .singleWhere((attempt) => attempt.id == 'existing-milliseconds')
            .terminalAt,
        expectedLocalInstant,
      );
      expect(
        history
            .singleWhere((attempt) => attempt.id == 'null-terminal')
            .terminalAt,
        isNull,
      );
    },
  );

  test(
    'schema v11 preserves existing history without inventing deletions',
    () async {
      final executor = NativeDatabase.memory(
        setup: (raw) {
          raw.execute('PRAGMA user_version = 10');
          raw.execute('''
          CREATE TABLE analysis_attempt_history (
            attempt_id TEXT PRIMARY KEY NOT NULL,
            client_document_id TEXT NOT NULL,
            started_at INTEGER NOT NULL,
            terminal_at INTEGER,
            status TEXT NOT NULL,
            result_analysis_id TEXT,
            failure_code TEXT,
            retryable INTEGER
          )
        ''');
          raw.execute('''
          INSERT INTO analysis_attempt_history VALUES
            ('prior-failure', 'legacy-document', 1790251200000,
             1790251200000, 'failed', NULL, 'processing_failed', 1),
            ('prior-success', 'legacy-document', 1790164800000,
             1790168400000, 'succeeded', 'removed-before-v11', NULL, NULL)
        ''');
        },
      );
      final database = AppDatabase(executor);
      addTearDown(database.close);

      final history = await LocalAnalysisRepository(database)
          .getHistory('legacy-document');

      expect(history, hasLength(2));
      final failed = history.singleWhere((item) => item.id == 'prior-failure');
      expect(failed.status, AnalysisAttemptStatus.failed);
      expect(failed.failureCode, 'processing_failed');
      expect(failed.retryable, isTrue);
      expect(failed.deletedAt, isNull);
      expect(failed.resultAnalysisStatus, isNull);
      final success = history.singleWhere((item) => item.id == 'prior-success');
      expect(success.status, AnalysisAttemptStatus.succeeded);
      expect(success.analysisId, 'removed-before-v11');
      expect(success.deletedAt, isNull);
      expect(success.resultAnalysisStatus, isNull);
    },
  );

  test(
    'failed attempt deletion removes only an eligible history row',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      const documentId = 'attempt-delete-document';
      await _insertDocument(database, documentId);
      await database
          .into(database.documentFiles)
          .insert(
            DocumentFilesCompanion.insert(
              id: 'attempt-delete-file',
              clientDocumentId: documentId,
              localUri: 'file:///attempt-delete.pdf',
              mediaType: 'application/pdf',
              importedAt: DateTime(2026),
            ),
          );
      final repository = LocalAnalysisRepository(database);
      final now = DateTime(2026);
      await repository.saveOperation(
        operationId: 'failed-to-remove',
        clientDocumentId: documentId,
        state: AnalysisLifecycleState.failed,
        failureCode: 'processing_failed',
        retryable: true,
      );
      await repository.saveOperation(
        operationId: 'other-failed-attempt',
        clientDocumentId: documentId,
        state: AnalysisLifecycleState.failed,
        failureCode: 'processing_failed',
        retryable: false,
      );
      await repository.saveCompleted(
        DocumentAnalysis(
          id: 'kept-analysis',
          clientDocumentId: documentId,
          schemaVersion: 'analysis_result.v1',
          targetLanguage: 'de',
          createdAt: now,
        ),
      );
      await repository.saveCompleted(
        DocumentAnalysis(
          id: 'deleted-analysis',
          clientDocumentId: documentId,
          schemaVersion: 'analysis_result.v1',
          targetLanguage: 'de',
          createdAt: now.add(const Duration(minutes: 1)),
        ),
      );
      await repository.deleteAnalysis('deleted-analysis');
      await repository.saveOperation(
        operationId: 'pending-attempt',
        clientDocumentId: documentId,
        state: AnalysisLifecycleState.accepted,
      );
      final tasks = LocalTaskRepository(database);
      await tasks.save(
        LocalTask(
          id: 'unaffected-task',
          title: 'Keep task',
          status: TaskStatus.open,
          provenance: TaskProvenance.user,
          createdAt: now,
          updatedAt: now,
          clientDocumentId: documentId,
        ),
      );

      expect(
        await repository.deleteAnalysisAttempt('failed-to-remove'),
        isTrue,
      );
      expect(
        await repository.deleteAnalysisAttempt('failed-to-remove'),
        isFalse,
      );
      expect(
        await repository.deleteAnalysisAttempt('analysis:kept-analysis'),
        isFalse,
      );
      expect(
        await repository.deleteAnalysisAttempt('analysis:deleted-analysis'),
        isFalse,
      );
      expect(
        await repository.deleteAnalysisAttempt('pending-attempt'),
        isFalse,
      );

      final history = await repository.getHistory(documentId);
      expect(
        history.map((item) => item.id),
        contains('analysis:kept-analysis'),
      );
      expect(
        history.map((item) => item.id),
        contains('analysis:deleted-analysis'),
      );
      expect(history.map((item) => item.id), contains('pending-attempt'));
      expect(history.map((item) => item.id), contains('other-failed-attempt'));
      expect(
        history.map((item) => item.id),
        isNot(contains('failed-to-remove')),
      );
      expect(await database.select(database.documents).get(), hasLength(1));
      expect(await database.select(database.documentFiles).get(), hasLength(1));
      expect(await database.select(database.analyses).get(), hasLength(1));
      expect(await tasks.getById('unaffected-task'), isNotNull);
    },
  );

  test('deleting an analysis preserves its Document, file, and Task', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    const documentId = 'retained-document';
    await _insertDocument(database, documentId);
    await database
        .into(database.documentFiles)
        .insert(
          DocumentFilesCompanion.insert(
            id: 'retained-file',
            clientDocumentId: documentId,
            localUri: 'file:///retained.pdf',
            mediaType: 'application/pdf',
            importedAt: DateTime(2026, 9, 20),
          ),
        );
    final repository = LocalAnalysisRepository(database);
    final olderAttemptAt = DateTime(2026, 9, 10).millisecondsSinceEpoch;
    await database.customStatement(
      '''INSERT INTO analysis_attempt_history (
        attempt_id, client_document_id, started_at, terminal_at, status,
        result_analysis_id, failure_code, retryable, deleted_at,
        result_analysis_status
      ) VALUES (?, ?, ?, ?, ?, NULL, ?, ?, NULL, NULL)''',
      [
        'older-failed-attempt',
        documentId,
        olderAttemptAt,
        olderAttemptAt,
        'failed',
        'processing_failed',
        1,
      ],
    );
    await repository.saveCompleted(
      DocumentAnalysis(
        id: 'other-analysis',
        clientDocumentId: documentId,
        schemaVersion: 'analysis_result.v1',
        targetLanguage: 'de',
        createdAt: DateTime(2026, 9, 20),
      ),
    );
    await repository.saveCompleted(
      DocumentAnalysis(
        id: 'retained-analysis',
        clientDocumentId: documentId,
        schemaVersion: 'analysis_result.v1',
        targetLanguage: 'de',
        createdAt: DateTime(2026, 9, 21),
        summary: 'PRIVATE analysis summary',
        analysisStatus: AnalysisStatus.partial,
      ),
    );
    await database
        .into(database.analysisAmounts)
        .insert(
          AnalysisAmountsCompanion.insert(
            id: 'private-payload',
            analysisId: 'retained-analysis',
            position: 0,
            value: '1234',
            currency: 'EUR',
            direction: 'payable',
            purpose: const Value('PRIVATE analysis purpose'),
          ),
        );
    final tasks = LocalTaskRepository(database);
    await tasks.save(
      LocalTask(
        id: 'retained-task',
        title: 'Keep me',
        status: TaskStatus.open,
        provenance: TaskProvenance.analysis,
        createdAt: DateTime(2026, 9, 21),
        updatedAt: DateTime(2026, 9, 21),
        clientDocumentId: documentId,
        sourceAnalysisId: 'retained-analysis',
        sourceActionKey: 'action-required',
      ),
    );

    await repository.deleteAnalysis('missing-historical-analysis');
    expect(await repository.getHistory(documentId), hasLength(3));
    await database.customStatement(
      'DELETE FROM analysis_attempt_history WHERE result_analysis_id = ?',
      ['retained-analysis'],
    );
    await repository.deleteAnalysis('retained-analysis');

    expect(await repository.getById('retained-analysis'), isNull);
    expect(await repository.getById('other-analysis'), isNotNull);
    expect(await database.select(database.analyses).get(), hasLength(1));
    expect(
      await (database.select(
        database.analysisAmounts,
      )..where((row) => row.analysisId.equals('retained-analysis'))).get(),
      isEmpty,
    );
    expect(
      await (database.select(database.documents)
            ..where((row) => row.clientDocumentId.equals(documentId)))
          .getSingleOrNull(),
      isNotNull,
    );
    expect(await database.select(database.documentFiles).get(), hasLength(1));
    expect(await tasks.getById('retained-task'), isNotNull);
    final history = await repository.getHistory(documentId);
    expect(history, hasLength(3));
    expect(history.first.id, 'analysis:retained-analysis');
    expect(history.first.analysisId, 'retained-analysis');
    expect(history.first.status, AnalysisAttemptStatus.succeeded);
    expect(history.first.resultAnalysisStatus, AnalysisStatus.partial);
    expect(history.first.deletedAt, isNotNull);
    expect(history.any((item) => item.id == 'older-failed-attempt'), isTrue);
    expect(history.any((item) => item.analysisId == 'other-analysis'), isTrue);
    final storedDeletedAt = await database
        .customSelect(
          '''SELECT deleted_at FROM analysis_attempt_history
         WHERE result_analysis_id = ?''',
          variables: const [Variable<String>('retained-analysis')],
        )
        .getSingle();
    expect(
      history.first.deletedAt,
      DateTime.fromMillisecondsSinceEpoch(
        storedDeletedAt.read<int>('deleted_at'),
      ),
    );
    final attemptColumns = await database
        .customSelect('PRAGMA table_info(analysis_attempt_history)')
        .get();
    expect(
      attemptColumns.map((row) => row.read<String>('name')),
      isNot(contains('summary')),
    );
    expect(
      attemptColumns.map((row) => row.read<String>('name')),
      isNot(contains('explanation')),
    );
  });
}

Future<void> _insertDocument(
  AppDatabase database,
  String clientDocumentId,
) async {
  final now = DateTime(2026);
  await database
      .into(database.documents)
      .insert(
        DocumentsCompanion.insert(
          clientDocumentId: clientDocumentId,
          classificationState: 'unclassified',
          status: 'imported',
          createdAt: now,
          updatedAt: now,
        ),
      );
}

DocumentFile _file(String id, File file, String mediaType, int pageOrder) =>
    DocumentFile(
      id: id,
      clientDocumentId: 'document-1',
      localUri: file.uri,
      mediaType: mediaType,
      originalFilename: file.uri.pathSegments.last,
      pageOrder: pageOrder,
      importedAt: DateTime(2026),
    );

List<String> _allIndexes(String value) =>
    RegExp(r'name="page_indexes"\r\n\r\n(\d+)')
        .allMatches(value)
        .map((match) => match.group(1)!)
        .toList();
http.StreamedResponse _jsonResponse(Map<String, dynamic> body, int status) =>
    http.StreamedResponse(
      Stream.value(utf8.encode(jsonEncode(body))),
      status,
      headers: const {'content-type': 'application/json'},
    );

class _RecordingClient extends http.BaseClient {
  _RecordingClient(this.response);
  final http.StreamedResponse response;
  http.BaseRequest? request;
  String body = '';
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    this.request = request;
    body = utf8.decode(
      await request.finalize().toBytes(),
      allowMalformed: true,
    );
    return response;
  }
}

class _FakeRemote implements DocumentAnalysisRemoteDataSource {
  _FakeRemote(this._responses);
  final List<BackendOperation> _responses;
  int submitCalls = 0;
  int getCalls = 0;
  @override
  Future<BackendOperation> getOperation(String operationId) async {
    getCalls++;
    return _responses.removeAt(0);
  }

  @override
  Future<AcceptedAnalysisOperation> submit(
    AnalysisSubmission submission,
  ) async {
    submitCalls++;
    return const AcceptedAnalysisOperation(
      operationId: 'op-1',
      requestId: 'r-1',
    );
  }
}

Map<String, dynamic> _result() => {
  'schema_version': 'analysis_result.v1',
  'analysis_status': 'partial',
  'client_document_id': 'document-1',
  'detected_language': 'de',
  'action_required': 'yes',
  'urgency': 'high',
  'practical_states': ['action_required', 'payment'],
  'classification': {
    'sender_organization': 'Jobcenter',
    'document_type': 'notice',
    'evidence_reference_ids': [],
    'uncertainties': [],
  },
  'explanation': {
    'language': 'ar',
    'style': 'standard',
    'summary': 'Summary',
    'body': 'Body',
    'next_actions': ['Do this'],
  },
  'source_references': [
    {'reference_id': 'e-1', 'page_number': 1, 'provenance': 'analysis'},
  ],
  'uncertainties': [
    {
      'code': 'wording_unclear',
      'message': 'Verify this',
      'evidence_reference_ids': [],
    },
  ],
  'quality_issues': [
    {'reason': 'blurry_image', 'message': 'Blur', 'evidence_reference_ids': []},
  ],
  'extracted_facts': {
    'deadlines': [
      {
        'description': 'Reply',
        'value': '2026-10-01',
        'evidence_reference_ids': [],
        'uncertainties': [],
      },
    ],
    'appointments': [],
    'amounts': [
      {
        'value': '12.50',
        'currency': 'EUR',
        'purpose': 'Fee',
        'direction': 'pay',
        'evidence_reference_ids': [],
        'uncertainties': [],
      },
    ],
    'required_documents': [],
    'suggested_tasks': [],
  },
};
