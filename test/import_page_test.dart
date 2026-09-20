import 'dart:async';

import 'package:drift/native.dart';
import 'package:doxary/app/localization/app_localizations.dart';
import 'package:doxary/app/providers.dart';
import 'package:doxary/core/database/app_database.dart';
import 'package:doxary/core/errors/app_error.dart';
import 'package:doxary/core/errors/result.dart';
import 'package:doxary/core/utils/id_generator.dart';
import 'package:doxary/features/document_analysis/domain/analysis_submission.dart';
import 'package:doxary/features/document_import/data/camera_capture_gateway.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:doxary/features/document_import/domain/document_import.dart';
import 'package:doxary/features/document_import/presentation/import_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Arabic device locale defaults the next submission to Arabic', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final remote = _FailedOperationRemote();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          deviceLocaleProvider.overrideWithValue(const Locale('ar')),
          idGeneratorProvider.overrideWithValue(_SequenceIdGenerator()),
          importGatewayProvider.overrideWithValue(_SelectionGateway()),
          analysisRemoteDataSourceProvider.overrideWithValue(remote),
        ],
        child: _app(const Locale('ar')),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      Directionality.of(tester.element(find.byType(ImportPage))),
      TextDirection.rtl,
    );
    expect(find.byKey(const Key('analysis-language-selector')), findsOneWidget);

    await tester.tap(find.byKey(const Key('choose-file-image-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('import-choose-image')));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(remote.submissions.single.language, ExplanationLanguage.arabic);
  });

  testWidgets(
    'terminal operation failure exits the consumed Analyze draft with a localized message',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final remote = _FailedOperationRemote();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(database),
            deviceLocaleProvider.overrideWithValue(const Locale('de')),
            idGeneratorProvider.overrideWithValue(_SequenceIdGenerator()),
            importGatewayProvider.overrideWithValue(_SelectionGateway()),
            analysisRemoteDataSourceProvider.overrideWithValue(remote),
            activeAnalysisOperationsProvider.overrideWithValue(
              const AsyncValue.data([]),
            ),
            organizationsProvider.overrideWithValue(const AsyncValue.data([])),
            casesProvider.overrideWithValue(const AsyncValue.data([])),
          ],
          child: _app(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('choose-file-image-action')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('import-choose-image')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Analyse starten'));
      await tester.pumpAndSettle();

      expect(
        find.text('Die Analyse konnte nicht abgeschlossen werden.'),
        findsOneWidget,
      );
      expect(find.text('Analyse gestartet'), findsNothing);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
      expect(remote.submitCalls, 1);
      expect(remote.getCalls, 1);
      expect(remote.submissions.single.language, ExplanationLanguage.german);
      expect(find.byKey(const Key('selected-import-draft')), findsNothing);
      expect(find.byKey(const Key('analyze-draft-action')), findsNothing);
      expect(find.byKey(const Key('capture-document-action')), findsOneWidget);
      final operations = await database
          .select(database.analysisOperations)
          .get();
      expect(operations, hasLength(1));
      expect(
        operations.every(
          (row) => row.state == AnalysisLifecycleState.failed.name,
        ),
        isTrue,
      );
      expect(
        (await database.select(database.documents).get()).single.status,
        'needsReview',
      );
      expect(await database.select(database.documentFiles).get(), hasLength(1));
    },
  );

  testWidgets('selected PDF shows its filename, type, and Analyze controls', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          importGatewayProvider.overrideWithValue(_PdfSelectionGateway()),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('choose-file-image-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('import-choose-pdf')));
    await tester.pumpAndSettle();

    final filename = find.text('Nebenkostenabrechnung.pdf');
    expect(filename, findsOneWidget);
    expect(Directionality.of(tester.element(filename)), TextDirection.ltr);
    expect(find.text('PDF'), findsOneWidget);
    expect(find.text('file(s) 1'), findsNothing);
    expect(find.byKey(const Key('remove-import-draft')), findsOneWidget);
    expect(find.byKey(const Key('analysis-language-selector')), findsOneWidget);
    expect(find.byKey(const Key('analyze-draft-action')), findsOneWidget);
    expect(find.byKey(const Key('replace-import-draft')), findsOneWidget);
    expect(find.byKey(const Key('import-choose-image')), findsNothing);
  });

  testWidgets('Remove clears the selected PDF and returns to empty Analyze', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          importGatewayProvider.overrideWithValue(_PdfSelectionGateway()),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('choose-file-image-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('import-choose-pdf')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('remove-import-draft')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('capture-document-action')), findsOneWidget);
    expect(find.byKey(const Key('choose-file-image-action')), findsOneWidget);
    expect(find.byKey(const Key('selected-import-draft')), findsNothing);
    expect(find.byKey(const Key('analyze-draft-action')), findsNothing);
  });

  testWidgets('unsubmitted PDF draft survives temporarily leaving Analyze', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          importGatewayProvider.overrideWithValue(_PdfSelectionGateway()),
        ],
        child: _appWithHome(const _AnalyzeDraftHost()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('choose-file-image-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('import-choose-pdf')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('leave-analyze-root')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('return-analyze-root')));
    await tester.pumpAndSettle();

    expect(find.text('Nebenkostenabrechnung.pdf'), findsOneWidget);
    expect(find.byKey(const Key('analyze-draft-action')), findsOneWidget);
  });

  testWidgets(
    'accepted submission opens Processing modal and clears the draft',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final remote = _AcceptedProcessingRemote();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(database),
            idGeneratorProvider.overrideWithValue(_SequenceIdGenerator()),
            importGatewayProvider.overrideWithValue(_SelectionGateway()),
            analysisRemoteDataSourceProvider.overrideWithValue(remote),
            activeAnalysisOperationsProvider.overrideWithValue(
              const AsyncValue.data([]),
            ),
          ],
          child: _app(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('choose-file-image-action')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('import-choose-image')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Analyse starten'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('processing-overlay')), findsOneWidget);
      expect(find.byKey(const Key('selected-import-draft')), findsNothing);
      expect(find.byKey(const Key('analyze-draft-action')), findsNothing);
      expect(find.byKey(const Key('capture-document-action')), findsOneWidget);
      expect(find.text('Dokument wird hochgeladen …'), findsNothing);

      expect(find.text('Analyse gestartet'), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
  );

  testWidgets(
    'started feedback closes when leaving Analyze and does not return',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final remote = _AcceptedProcessingRemote();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(database),
            idGeneratorProvider.overrideWithValue(_SequenceIdGenerator()),
            importGatewayProvider.overrideWithValue(_SelectionGateway()),
            analysisRemoteDataSourceProvider.overrideWithValue(remote),
            activeAnalysisOperationsProvider.overrideWithValue(
              const AsyncValue.data([]),
            ),
          ],
          child: _app(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('choose-file-image-action')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('import-choose-image')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Analyse starten'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('processing-overlay')), findsOneWidget);

      await tester.tap(find.byKey(const Key('processing-close')));
      await tester.pumpAndSettle();
      expect(
        await database.select(database.analysisOperations).get(),
        hasLength(1),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(database),
            idGeneratorProvider.overrideWithValue(_SequenceIdGenerator()),
            importGatewayProvider.overrideWithValue(_RecordingGateway()),
            analysisRemoteDataSourceProvider.overrideWithValue(remote),
            activeAnalysisOperationsProvider.overrideWithValue(
              const AsyncValue.data([]),
            ),
          ],
          child: _app(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Analyse gestartet'), findsNothing);
      expect(find.byKey(const Key('processing-overlay')), findsNothing);
      expect(find.byKey(const Key('capture-document-action')), findsOneWidget);
      expect(find.byKey(const Key('analyze-draft-action')), findsNothing);
    },
  );

  testWidgets(
    'Continue in background dismisses Processing without cancellation',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final remote = _AcceptedProcessingRemote();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(database),
            idGeneratorProvider.overrideWithValue(_SequenceIdGenerator()),
            importGatewayProvider.overrideWithValue(_SelectionGateway()),
            analysisRemoteDataSourceProvider.overrideWithValue(remote),
            activeAnalysisOperationsProvider.overrideWithValue(
              const AsyncValue.data([]),
            ),
          ],
          child: _app(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('choose-file-image-action')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('import-choose-image')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('analyze-draft-action')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('processing-overlay')), findsOneWidget);
      expect(find.textContaining('%'), findsNothing);
      expect(find.text('Abbrechen ist noch nicht verfügbar.'), findsOneWidget);
      expect(
        tester
            .widget<OutlinedButton>(
              find.byKey(const Key('processing-cancel-unavailable')),
            )
            .onPressed,
        isNull,
      );

      await tester.tap(find.byKey(const Key('processing-continue-background')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('processing-overlay')), findsNothing);
      expect(
        await database.select(database.analysisOperations).get(),
        hasLength(1),
      );
      expect(remote.submitCalls, 1);

      await tester.tap(find.byKey(const Key('choose-file-image-action')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('import-choose-image')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('analyze-draft-action')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('processing-overlay')), findsOneWidget);
      expect(remote.submitCalls, 2);
      expect(
        await database.select(database.analysisOperations).get(),
        hasLength(2),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
  );

  testWidgets(
    'terminal success closes Processing into the existing Document lifecycle',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final remote = _AcceptedProcessingRemote();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(database),
            idGeneratorProvider.overrideWithValue(_SequenceIdGenerator()),
            importGatewayProvider.overrideWithValue(_SelectionGateway()),
            analysisRemoteDataSourceProvider.overrideWithValue(remote),
            activeAnalysisOperationsProvider.overrideWithValue(
              const AsyncValue.data([]),
            ),
            organizationsProvider.overrideWithValue(const AsyncValue.data([])),
            casesProvider.overrideWithValue(const AsyncValue.data([])),
          ],
          child: _app(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('choose-file-image-action')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('import-choose-image')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('analyze-draft-action')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('processing-overlay')), findsOneWidget);
      remote.completeSuccess();
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('processing-overlay')), findsNothing);
      expect(await database.select(database.analysisOperations).get(), isEmpty);
      final resultSurface = find.byKey(const Key('document-result-background'));
      expect(resultSurface, findsOneWidget);
      Navigator.of(tester.element(resultSurface)).pop();
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
  );

  testWidgets(
    'terminal failure closes Processing into the existing recovery lifecycle',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final remote = _AcceptedProcessingRemote();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(database),
            idGeneratorProvider.overrideWithValue(_SequenceIdGenerator()),
            importGatewayProvider.overrideWithValue(_SelectionGateway()),
            analysisRemoteDataSourceProvider.overrideWithValue(remote),
            activeAnalysisOperationsProvider.overrideWithValue(
              const AsyncValue.data([]),
            ),
          ],
          child: _app(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('choose-file-image-action')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('import-choose-image')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('analyze-draft-action')));
      await tester.pumpAndSettle();

      remote.completeFailure();
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('processing-overlay')), findsNothing);
      expect(
        find.text('Die Analyse konnte nicht abgeschlossen werden.'),
        findsOneWidget,
      );
      expect(
        (await database.select(database.documents).get()).single.status,
        DocumentStatus.needsReview.name,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
  );

  testWidgets('duplicate submission is prevented while the draft submits', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final remote = _AcceptedProcessingRemote();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          idGeneratorProvider.overrideWithValue(_SequenceIdGenerator()),
          importGatewayProvider.overrideWithValue(_SelectionGateway()),
          analysisRemoteDataSourceProvider.overrideWithValue(remote),
          activeAnalysisOperationsProvider.overrideWithValue(
            const AsyncValue.data([]),
          ),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('choose-file-image-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('import-choose-image')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('analyze-draft-action')));
    await tester.tap(find.byKey(const Key('analyze-draft-action')));
    await tester.pumpAndSettle();

    expect(remote.submitCalls, 1);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('pre-acceptance failure leaves no started feedback', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          idGeneratorProvider.overrideWithValue(_SequenceIdGenerator()),
          importGatewayProvider.overrideWithValue(_SelectionGateway()),
          analysisRemoteDataSourceProvider.overrideWithValue(
            _SubmitFailsRemote(),
          ),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('choose-file-image-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('import-choose-image')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Analyse starten'));
    await tester.pumpAndSettle();

    expect(find.text('Analyse gestartet'), findsNothing);
    expect(find.byKey(const Key('processing-overlay')), findsNothing);
    expect(
      find.text('Der Dienst ist vorübergehend nicht verfügbar.'),
      findsOneWidget,
    );
    expect(find.text('Analyse starten'), findsOneWidget);
    expect(find.byKey(const Key('selected-import-draft')), findsOneWidget);
  });

  testWidgets('started feedback is gone once the draft is consumed', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final remote = _SuccessfulOperationRemote();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          idGeneratorProvider.overrideWithValue(_SequenceIdGenerator()),
          importGatewayProvider.overrideWithValue(_SelectionGateway()),
          analysisRemoteDataSourceProvider.overrideWithValue(remote),
          organizationsProvider.overrideWithValue(const AsyncValue.data([])),
          casesProvider.overrideWithValue(const AsyncValue.data([])),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('choose-file-image-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('import-choose-image')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Analyse starten'));
    await tester.pumpAndSettle();

    expect(await database.select(database.analyses).get(), hasLength(1));
    expect(await database.select(database.analysisOperations).get(), isEmpty);
    expect(find.text('Analyse gestartet'), findsNothing);
    expect(find.byKey(const Key('processing-overlay')), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('empty Analyze root has focused actions and language selection', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          importGatewayProvider.overrideWithValue(_RecordingGateway()),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('capture-document-action')), findsOneWidget);
    expect(find.byKey(const Key('choose-file-image-action')), findsOneWidget);
    expect(find.byKey(const Key('supported-formats-guidance')), findsOneWidget);
    expect(find.byKey(const Key('analysis-language-selector')), findsOneWidget);

    await tester.tap(find.byKey(const Key('choose-file-image-action')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('import-choose-image')), findsOneWidget);
    expect(find.byKey(const Key('import-choose-pdf')), findsOneWidget);
  });

  testWidgets(
    'camera shutter opens Review and Back returns to Capture without a draft',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final gateway = _RecordingGateway();
      final camera = _FakeCameraCaptureGateway();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(database),
            importGatewayProvider.overrideWithValue(gateway),
            cameraCaptureGatewayProvider.overrideWithValue(camera),
          ],
          child: _app(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('capture-document-action')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('camera-capture-page')), findsOneWidget);
      expect(find.byKey(const Key('camera-capture-shutter')), findsOneWidget);
      expect(gateway.sources, isEmpty);

      await tester.tap(find.byKey(const Key('camera-capture-shutter')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('camera-review-page')), findsOneWidget);
      expect(find.byKey(const Key('camera-review-preview')), findsOneWidget);
      expect(camera.session.pauseCalls, 1);

      await tester.tap(find.byKey(const Key('camera-review-back')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('camera-capture-page')), findsOneWidget);
      expect(camera.session.discardCalls, 1);
      expect(camera.session.resumeCalls, 1);

      await tester.tap(find.byKey(const Key('camera-capture-back')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('camera-capture-page')), findsNothing);
      expect(find.byKey(const Key('capture-document-action')), findsOneWidget);
      expect(await database.select(database.documents).get(), isEmpty);
      expect(await database.select(database.analysisOperations).get(), isEmpty);
      expect(camera.session.disposeCalls, greaterThanOrEqualTo(1));

      await tester.tap(find.byKey(const Key('choose-file-image-action')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('import-choose-image')));
      await tester.pumpAndSettle();
      expect(gateway.sources, [ImportSource.imageLibrary]);
    },
  );

  testWidgets('Retake discards the reviewed capture and resumes the camera', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final camera = _FakeCameraCaptureGateway();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          cameraCaptureGatewayProvider.overrideWithValue(camera),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('capture-document-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('camera-capture-shutter')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('camera-review-retake')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('camera-review-page')), findsNothing);
    expect(find.byKey(const Key('camera-capture-shutter')), findsOneWidget);
    expect(camera.session.discardCalls, 1);
    expect(camera.session.resumeCalls, 1);
    expect(await database.select(database.documents).get(), isEmpty);
  });

  testWidgets('Review rotates the candidate file before it can be accepted', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final camera = _FakeCameraCaptureGateway();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          cameraCaptureGatewayProvider.overrideWithValue(camera),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('capture-document-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('camera-capture-shutter')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('camera-review-rotate')));
    await tester.pumpAndSettle();

    expect(camera.session.rotateCalls, 1);
    expect(find.byKey(const Key('camera-review-preview')), findsOneWidget);
  });

  testWidgets(
    'Use photo returns a camera image as an unsubmitted Analyze draft',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final camera = _FakeCameraCaptureGateway();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(database),
            cameraCaptureGatewayProvider.overrideWithValue(camera),
          ],
          child: _app(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('capture-document-action')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('camera-capture-shutter')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('camera-review-use')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('camera-review-page')), findsNothing);
      expect(find.byKey(const Key('selected-import-draft')), findsOneWidget);
      expect(find.byKey(const Key('analyze-draft-action')), findsOneWidget);
      expect(await database.select(database.documents).get(), isEmpty);
      expect(await database.select(database.analysisOperations).get(), isEmpty);
      expect(camera.session.discardCalls, 0);
      expect(camera.session.disposeCalls, greaterThanOrEqualTo(1));
    },
  );

  testWidgets('camera permission denial renders a safe localized state', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final camera = _FakeCameraCaptureGateway(
      initialState: CameraCaptureState.permissionDenied,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          cameraCaptureGatewayProvider.overrideWithValue(camera),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('capture-document-action')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('camera-capture-state-message')),
      findsOneWidget,
    );
    expect(
      find.text(
        'Der Kamerazugriff wurde nicht erlaubt. Du kannst ihn später erneut erlauben.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('camera initialization failure renders a safe localized state', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final camera = _FakeCameraCaptureGateway(
      initialState: CameraCaptureState.failed,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          cameraCaptureGatewayProvider.overrideWithValue(camera),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('capture-document-action')));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Die Kamera konnte nicht gestartet werden. Bitte versuche es erneut.',
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'selected Analyze draft leaves the host bottom navigation visible',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(database),
            importGatewayProvider.overrideWithValue(_PdfSelectionGateway()),
          ],
          child: MaterialApp(
            locale: const Locale('de'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Scaffold(
              body: const ImportPage(),
              bottomNavigationBar: NavigationBar(
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    label: 'Start',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.document_scanner_outlined),
                    label: 'Analyse',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('choose-file-image-action')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('import-choose-pdf')));
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byKey(const Key('selected-import-draft')), findsOneWidget);
    },
  );
}

Widget _app([Locale locale = const Locale('de')]) =>
    _appWithHome(const ImportPage(), locale);

Widget _appWithHome(Widget home, [Locale locale = const Locale('de')]) =>
    MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: home,
    );

class _FakeCameraCaptureGateway implements CameraCaptureGateway {
  _FakeCameraCaptureGateway({
    CameraCaptureState initialState = CameraCaptureState.ready,
  }) : session = _FakeCameraCaptureSession(initialState);

  final _FakeCameraCaptureSession session;

  @override
  CameraCaptureSession createSession() => session;
}

class _FakeCameraCaptureSession implements CameraCaptureSession {
  _FakeCameraCaptureSession(this._state);

  CameraCaptureState _state;
  var disposeCalls = 0;
  var pauseCalls = 0;
  var resumeCalls = 0;
  var discardCalls = 0;
  var rotateCalls = 0;
  var _flashOn = false;

  @override
  CameraCaptureState get state => _state;

  @override
  bool get isFlashControlAvailable => _state == CameraCaptureState.ready;

  @override
  bool get isFlashOn => _flashOn;

  @override
  Future<CameraCaptureState> initialize() async => _state;

  @override
  Widget buildPreview() => const ColoredBox(color: Colors.black);

  @override
  Future<void> toggleFlash() async => _flashOn = !_flashOn;

  @override
  Future<CameraCaptureCandidate> capture() async => CameraCaptureCandidate(
    localUri: Uri.parse('file:///camera-capture.jpg'),
    capturedAt: DateTime(2026),
  );

  @override
  Future<CameraCaptureCandidate> rotateRight(
    CameraCaptureCandidate candidate,
  ) async {
    rotateCalls++;
    return CameraCaptureCandidate(
      localUri: Uri.parse('file:///camera-capture-rotated.jpg'),
      capturedAt: candidate.capturedAt,
    );
  }

  @override
  Future<void> discard(CameraCaptureCandidate candidate) async {
    discardCalls++;
  }

  @override
  Future<void> pause() async {
    pauseCalls++;
  }

  @override
  Future<CameraCaptureState> resume() async {
    resumeCalls++;
    _state = CameraCaptureState.ready;
    return _state;
  }

  @override
  Future<void> dispose() async {
    disposeCalls++;
  }
}

class _SelectionGateway implements DocumentImportGateway {
  @override
  Future<Result<DocumentImportCandidate>> pick(ImportSource source) async =>
      const Failure(ImportCancelledError());

  @override
  Future<Result<DocumentImportSelection>> pickSelection(
    ImportSource source,
  ) async => Success(
    DocumentImportSelection([
      DocumentImportCandidate(
        localUri: Uri.parse('file:///test-image.jpg'),
        mediaType: ImportedMediaType.image,
        source: ImportSource.imageLibrary,
        importedAt: DateTime(2026),
      ),
    ]),
  );
}

class _PdfSelectionGateway implements DocumentImportGateway {
  @override
  Future<Result<DocumentImportCandidate>> pick(ImportSource source) async =>
      const Failure(ImportCancelledError());

  @override
  Future<Result<DocumentImportSelection>> pickSelection(
    ImportSource source,
  ) async => Success(
    DocumentImportSelection([
      DocumentImportCandidate(
        localUri: Uri.parse('file:///Nebenkostenabrechnung.pdf'),
        mediaType: ImportedMediaType.pdf,
        source: ImportSource.pdfFile,
        originalFilename: 'Nebenkostenabrechnung.pdf',
        importedAt: DateTime(2026),
      ),
    ]),
  );
}

class _AnalyzeDraftHost extends StatefulWidget {
  const _AnalyzeDraftHost();

  @override
  State<_AnalyzeDraftHost> createState() => _AnalyzeDraftHostState();
}

class _AnalyzeDraftHostState extends State<_AnalyzeDraftHost> {
  var _showAnalyze = true;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        Expanded(
          child: Offstage(offstage: !_showAnalyze, child: const ImportPage()),
        ),
        if (_showAnalyze)
          TextButton(
            key: const Key('leave-analyze-root'),
            onPressed: () => setState(() => _showAnalyze = false),
            child: const Text('Leave Analyze'),
          )
        else
          TextButton(
            key: const Key('return-analyze-root'),
            onPressed: () => setState(() => _showAnalyze = true),
            child: const Text('Return to Analyze'),
          ),
      ],
    ),
  );
}

class _RecordingGateway implements DocumentImportGateway {
  final sources = <ImportSource>[];

  @override
  Future<Result<DocumentImportCandidate>> pick(ImportSource source) async =>
      const Failure(ImportCancelledError());

  @override
  Future<Result<DocumentImportSelection>> pickSelection(
    ImportSource source,
  ) async {
    sources.add(source);
    return const Failure(ImportCancelledError());
  }
}

class _FailedOperationRemote implements DocumentAnalysisRemoteDataSource {
  final submissions = <AnalysisSubmission>[];
  int getCalls = 0;

  int get submitCalls => submissions.length;

  @override
  Future<AcceptedAnalysisOperation> submit(
    AnalysisSubmission submission,
  ) async {
    submissions.add(submission);
    return AcceptedAnalysisOperation(
      operationId: 'op-${submissions.length}',
      requestId: 'request-${submissions.length}',
    );
  }

  @override
  Future<BackendOperation> getOperation(String operationId) async {
    getCalls++;
    return BackendOperation(
      operationId: operationId,
      status: BackendOperationStatus.failed,
      requestId: null,
      failureCode: 'processing_failed',
      failureRetryable: false,
    );
  }
}

class _AcceptedProcessingRemote implements DocumentAnalysisRemoteDataSource {
  final _operation = Completer<BackendOperation>();
  var submitCalls = 0;
  String? _clientDocumentId;
  String? _operationId;

  @override
  Future<AcceptedAnalysisOperation> submit(
    AnalysisSubmission submission,
  ) async {
    submitCalls++;
    _clientDocumentId = submission.clientDocumentId;
    _operationId = 'accepted-operation-$submitCalls';
    return AcceptedAnalysisOperation(
      operationId: _operationId!,
      requestId: 'request-$submitCalls',
    );
  }

  @override
  Future<BackendOperation> getOperation(String operationId) =>
      _operation.future;

  void completeSuccess() => _operation.complete(
    BackendOperation(
      operationId: _operationId!,
      status: BackendOperationStatus.succeeded,
      requestId: 'request',
      result: DocumentAnalysis(
        id: 'accepted-analysis',
        clientDocumentId: _clientDocumentId!,
        schemaVersion: 'analysis_result.v1',
        targetLanguage: 'de',
        createdAt: DateTime(2026),
        actionRequired: ActionRequirement.no,
      ),
    ),
  );

  void completeFailure() => _operation.complete(
    BackendOperation(
      operationId: _operationId!,
      status: BackendOperationStatus.failed,
      requestId: 'request',
      failureCode: 'processing_failed',
      failureRetryable: false,
    ),
  );
}

class _SuccessfulOperationRemote implements DocumentAnalysisRemoteDataSource {
  String? _clientDocumentId;

  @override
  Future<AcceptedAnalysisOperation> submit(
    AnalysisSubmission submission,
  ) async {
    _clientDocumentId = submission.clientDocumentId;
    return const AcceptedAnalysisOperation(
      operationId: 'successful-operation',
      requestId: 'request',
    );
  }

  @override
  Future<BackendOperation> getOperation(String operationId) async =>
      BackendOperation(
        operationId: operationId,
        status: BackendOperationStatus.succeeded,
        requestId: 'request',
        result: DocumentAnalysis(
          id: 'completed-analysis',
          clientDocumentId: _clientDocumentId!,
          schemaVersion: 'analysis_result.v1',
          targetLanguage: 'de',
          createdAt: DateTime(2026),
          summary: 'Completed',
          actionRequired: ActionRequirement.no,
        ),
      );
}

class _SubmitFailsRemote implements DocumentAnalysisRemoteDataSource {
  @override
  Future<AcceptedAnalysisOperation> submit(
    AnalysisSubmission submission,
  ) async => throw const RemoteApiError(
    'Submission failed.',
    statusCode: 503,
    code: 'unavailable',
    retryable: true,
  );

  @override
  Future<BackendOperation> getOperation(String operationId) =>
      throw UnimplementedError();
}

class _SequenceIdGenerator implements IdGenerator {
  int _counter = 0;

  @override
  String newId() => 'generated-${++_counter}';
}
