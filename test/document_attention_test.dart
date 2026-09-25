import 'dart:async';

import 'package:drift/native.dart';
import 'package:doxary/app/providers.dart';
import 'package:doxary/core/database/app_database.dart'
    hide Case, DocumentFile, Organization;
import 'package:doxary/features/document_analysis/application/document_attention.dart';
import 'package:doxary/features/document_analysis/data/local_analysis_repository.dart';
import 'package:doxary/features/document_analysis/domain/analysis_submission.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final failedAt = DateTime(2026, 9, 20, 10);
  final deletedAt = DateTime(2026, 9, 21, 11);

  test('failed-only Document needs attention at the terminal event time', () {
    final state = resolveDocumentAnalysisBrowseState(
      currentAnalysisStatuses: const [],
      isProcessing: false,
      latestFailureAt: failedAt,
      latestDeletionAt: null,
    );

    expect(state.hasUsableAnalysis, isFalse);
    expect(state.attention?.reason, DocumentAttentionReason.failed);
    expect(state.attention?.occurredAt, failedAt);
  });

  test('deleted Analysis with no usable result needs attention', () {
    final state = resolveDocumentAnalysisBrowseState(
      currentAnalysisStatuses: const [],
      isProcessing: false,
      latestFailureAt: null,
      latestDeletionAt: deletedAt,
    );

    expect(state.attention?.reason, DocumentAttentionReason.deleted);
    expect(state.attention?.occurredAt, deletedAt);
  });

  test('a usable Analysis suppresses a newer failed retry', () {
    final state = resolveDocumentAnalysisBrowseState(
      currentAnalysisStatuses: const [AnalysisStatus.complete],
      isProcessing: false,
      latestFailureAt: deletedAt,
      latestDeletionAt: null,
    );

    expect(state.hasUsableAnalysis, isTrue);
    expect(state.attention, isNull);
  });

  test('a usable Analysis suppresses an older deletion tombstone', () {
    final state = resolveDocumentAnalysisBrowseState(
      currentAnalysisStatuses: const [AnalysisStatus.partial],
      isProcessing: false,
      latestFailureAt: null,
      latestDeletionAt: failedAt,
    );

    expect(state.hasUsableAnalysis, isTrue);
    expect(state.attention, isNull);
  });

  test('no Analysis or relevant history does not need attention', () {
    final state = resolveDocumentAnalysisBrowseState(
      currentAnalysisStatuses: const [],
      isProcessing: false,
      latestFailureAt: null,
      latestDeletionAt: null,
    );

    expect(state.attention, isNull);
  });

  test('unavailable Analysis without a failure or deletion is neutral', () {
    final state = resolveDocumentAnalysisBrowseState(
      currentAnalysisStatuses: const [AnalysisStatus.unavailable],
      isProcessing: false,
      latestFailureAt: null,
      latestDeletionAt: null,
    );

    expect(state.hasUsableAnalysis, isFalse);
    expect(state.attention, isNull);
  });

  test('a later failure takes precedence over an Analysis deletion', () {
    final state = resolveDocumentAnalysisBrowseState(
      currentAnalysisStatuses: const [],
      isProcessing: false,
      latestFailureAt: deletedAt,
      latestDeletionAt: failedAt,
    );

    expect(state.attention?.reason, DocumentAttentionReason.failed);
    expect(state.attention?.occurredAt, deletedAt);
  });

  test('a later deletion takes precedence over an earlier failure', () {
    final state = resolveDocumentAnalysisBrowseState(
      currentAnalysisStatuses: const [],
      isProcessing: false,
      latestFailureAt: failedAt,
      latestDeletionAt: deletedAt,
    );

    expect(state.attention?.reason, DocumentAttentionReason.deleted);
    expect(state.attention?.occurredAt, deletedAt);
  });

  test('processing suppresses an older failure until work is terminal', () {
    final state = resolveDocumentAnalysisBrowseState(
      currentAnalysisStatuses: const [],
      isProcessing: true,
      latestFailureAt: failedAt,
      latestDeletionAt: null,
    );

    expect(state.isProcessing, isTrue);
    expect(state.attention, isNull);
  });

  test('partial is usable but unavailable is not', () {
    expect(isUsableAnalysisStatus(AnalysisStatus.complete), isTrue);
    expect(isUsableAnalysisStatus(AnalysisStatus.partial), isTrue);
    expect(isUsableAnalysisStatus(AnalysisStatus.unavailable), isFalse);
  });

  test(
    'shared browse provider reacts to retry, success, deletion, and cleanup',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      final now = DateTime(2026, 9, 20, 9);
      for (final id in ['lifecycle-doc', 'failed-only-doc']) {
        await database
            .into(database.documents)
            .insert(
              DocumentsCompanion.insert(
                clientDocumentId: id,
                classificationState: 'unclassified',
                status: 'imported',
                createdAt: now,
                updatedAt: now,
              ),
            );
      }
      final repository = LocalAnalysisRepository(database);
      final container = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(database)],
      );
      final browseSubscription = container.listen(
        documentAnalysisBrowseStatesProvider,
        (previous, next) {},
      );
      addTearDown(() async {
        browseSubscription.close();
        container.dispose();
        await database.close();
      });
      expect(
        (await _waitForBrowseState(
          container,
          'lifecycle-doc',
          (state) => state.attention == null,
        )).attention,
        isNull,
      );

      final failureUpdate = _waitForBrowseState(
        container,
        'lifecycle-doc',
        (state) => state.attention?.reason == DocumentAttentionReason.failed,
      );
      await repository.saveOperation(
        operationId: 'first-failure',
        clientDocumentId: 'lifecycle-doc',
        state: AnalysisLifecycleState.failed,
        failureCode: 'processing_failed',
        retryable: true,
      );
      expect(
        (await failureUpdate).attention?.reason,
        DocumentAttentionReason.failed,
      );

      final successUpdate = _waitForBrowseState(
        container,
        'lifecycle-doc',
        (state) => state.hasUsableAnalysis,
      );
      await repository.saveCompleted(
        DocumentAnalysis(
          id: 'usable-result',
          clientDocumentId: 'lifecycle-doc',
          schemaVersion: 'analysis_result.v1',
          targetLanguage: 'de',
          createdAt: now.add(const Duration(minutes: 1)),
          analysisStatus: AnalysisStatus.complete,
        ),
      );
      final successfulState = await successUpdate;
      expect(successfulState.hasUsableAnalysis, isTrue);
      expect(successfulState.attention, isNull);

      final deletionUpdate = _waitForBrowseState(
        container,
        'lifecycle-doc',
        (state) => state.attention?.reason == DocumentAttentionReason.deleted,
      );
      await repository.deleteAnalysis('usable-result');
      expect(
        (await deletionUpdate).attention?.reason,
        DocumentAttentionReason.deleted,
      );

      final failedOnlyUpdate = _waitForBrowseState(
        container,
        'failed-only-doc',
        (state) => state.attention?.reason == DocumentAttentionReason.failed,
      );
      await repository.saveOperation(
        operationId: 'remove-this-failure',
        clientDocumentId: 'failed-only-doc',
        state: AnalysisLifecycleState.failed,
        failureCode: 'processing_failed',
        retryable: true,
      );
      await failedOnlyUpdate;

      final clearedUpdate = _waitForBrowseState(
        container,
        'failed-only-doc',
        (state) => state.attention == null,
      );
      expect(
        await repository.deleteAnalysisAttempt('remove-this-failure'),
        isTrue,
      );
      expect((await clearedUpdate).attention, isNull);
    },
  );
}

Future<DocumentAnalysisBrowseState> _waitForBrowseState(
  ProviderContainer container,
  String documentId,
  bool Function(DocumentAnalysisBrowseState) matches,
) {
  final current = container
      .read(documentAnalysisBrowseStatesProvider)
      .asData
      ?.value[documentId];
  if (current != null && matches(current)) {
    return Future.value(current);
  }

  final completer = Completer<DocumentAnalysisBrowseState>();
  final subscription = container.listen(documentAnalysisBrowseStatesProvider, (
    previous,
    next,
  ) {
    final state = next.asData?.value[documentId];
    if (state != null && matches(state) && !completer.isCompleted) {
      completer.complete(state);
    }
  });
  return completer.future
      .timeout(const Duration(seconds: 3))
      .whenComplete(subscription.close);
}
