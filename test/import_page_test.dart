import 'dart:async';

import 'package:camera/camera.dart';
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
  test('document camera policy prefers rear maximum-resolution capture', () {
    const front = CameraDescription(
      name: 'front',
      lensDirection: CameraLensDirection.front,
      sensorOrientation: 0,
    );
    const rear = CameraDescription(
      name: 'rear',
      lensDirection: CameraLensDirection.back,
      sensorOrientation: 0,
    );

    expect(selectDocumentCamera([front, rear]), rear);
    expect(documentCameraResolutionPreset, ResolutionPreset.max);
    expect(documentCameraEnableAudio, isFalse);
  });

  test('camera draft detection uses import source rather than filename', () {
    final cameraSelection = DocumentImportSelection([
      DocumentImportCandidate(
        localUri: Uri.parse('file:///Nebenkostenabrechnung.pdf'),
        mediaType: ImportedMediaType.image,
        source: ImportSource.camera,
        originalFilename: 'Nebenkostenabrechnung.pdf',
        importedAt: DateTime(2026),
      ),
    ]);
    final imageSelection = DocumentImportSelection([
      DocumentImportCandidate(
        localUri: Uri.parse('file:///camera-1.jpg'),
        mediaType: ImportedMediaType.image,
        source: ImportSource.imageLibrary,
        importedAt: DateTime(2026),
      ),
    ]);

    expect(cameraSelection.isCameraCapture, isTrue);
    expect(imageSelection.isCameraCapture, isFalse);
  });

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

  testWidgets('image-library selection retains the generic selected-file UI', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          importGatewayProvider.overrideWithValue(_SelectionGateway()),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('choose-file-image-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('import-choose-image')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('selected-import-draft')), findsOneWidget);
    expect(find.byKey(const Key('replace-import-draft')), findsOneWidget);
    expect(find.byKey(const Key('camera-draft-thumbnails')), findsNothing);
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
      expect(
        find.byKey(const Key('camera-capture-zoom-gesture')),
        findsNothing,
      );
      expect(gateway.sources, isEmpty);

      await tester.tap(find.byKey(const Key('camera-capture-shutter')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('camera-review-page')), findsOneWidget);
      expect(find.byKey(const Key('camera-review-preview-0')), findsOneWidget);
      expect(camera.session.pauseCalls, 1);
      expect(camera.session.pauseAfterPreviewDetached, isTrue);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(camera.session.resumeCalls, 0);

      await tester.tap(find.byKey(const Key('camera-review-back')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('camera-review-discard-pages')),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('camera-review-discard-pages')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('camera-capture-page')), findsNothing);
      expect(camera.session.discardCalls, 1);
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

  testWidgets(
    'first camera entry keeps one initialization while lifecycle resumes',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final initialization = Completer<CameraCaptureState>();
      final camera = _FakeCameraCaptureGateway(
        pendingInitialization: initialization,
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
      await tester.pump();
      await tester.tap(find.byKey(const Key('capture-document-action')));
      await tester.pump();

      expect(camera.session.initializeCalls, 1);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(camera.session.initializeCalls, 1);
      expect(camera.session.resumeCalls, 0);

      initialization.complete(CameraCaptureState.ready);
      await tester.pump();
      expect(find.byKey(const Key('camera-capture-shutter')), findsOneWidget);
      expect(camera.session.initializeCalls, 1);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(camera.session.initializeCalls, 1);
      expect(camera.session.resumeCalls, 0);
    },
  );

  testWidgets(
    'late initial completion cannot restore Capture after an inactive transition',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final initialization = Completer<CameraCaptureState>();
      final camera = _FakeCameraCaptureGateway(
        pendingInitialization: initialization,
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
      await tester.pump();
      await tester.tap(find.byKey(const Key('capture-document-action')));
      await tester.pump();

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pump();
      initialization.complete(CameraCaptureState.ready);
      await tester.pump();
      expect(find.byKey(const Key('camera-capture-shutter')), findsNothing);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(camera.session.resumeCalls, 1);
      expect(find.byKey(const Key('camera-capture-shutter')), findsOneWidget);
    },
  );

  testWidgets('pending permission result does not trigger a competing resume', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final initialization = Completer<CameraCaptureState>();
    final camera = _FakeCameraCaptureGateway(
      pendingInitialization: initialization,
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
    await tester.pump();
    await tester.tap(find.byKey(const Key('capture-document-action')));
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();

    initialization.complete(CameraCaptureState.permissionDenied);
    await tester.pump();

    expect(camera.session.initializeCalls, 1);
    expect(camera.session.resumeCalls, 0);
    expect(
      find.byKey(const Key('camera-capture-state-message')),
      findsOneWidget,
    );
  });

  testWidgets('late initialization is ignored after leaving Capture', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final initialization = Completer<CameraCaptureState>();
    final camera = _FakeCameraCaptureGateway(
      pendingInitialization: initialization,
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
    await tester.pump();
    await tester.tap(find.byKey(const Key('capture-document-action')));
    await tester.pump();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    initialization.complete(CameraCaptureState.ready);
    await tester.pump();

    expect(find.byKey(const Key('camera-capture-page')), findsNothing);
    expect(find.byKey(const Key('capture-document-action')), findsOneWidget);
    expect(camera.session.disposeCalls, 1);
  });

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
    await tester.tap(find.byKey(const Key('camera-review-add-page')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('camera-capture-shutter')));
    await tester.pumpAndSettle();
    final firstThumbnail = tester.widget<OutlinedButton>(
      find.byKey(const Key('camera-review-thumbnail-0')),
    );
    expect(firstThumbnail.onPressed, isNotNull);
    firstThumbnail.onPressed!();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('camera-review-rotate')));
    await tester.pumpAndSettle();

    expect(camera.session.rotateCalls, 1);
    final preview = tester.widget<Image>(
      find.byKey(const Key('camera-review-preview-0')),
    );
    expect(
      (preview.image as FileImage).file.uri.path,
      '/camera-capture-rotated.jpg',
    );
  });

  testWidgets(
    'Continue returns one camera page as an unsubmitted Analyze draft',
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

      await tester.tap(find.byKey(const Key('camera-review-continue')));
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

  testWidgets('Add another page appends it to the same Camera Review flow', (
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

    await tester.tap(find.byKey(const Key('camera-review-add-page')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('camera-capture-page')), findsOneWidget);
    expect(camera.session.resumeCalls, 1);

    await tester.tap(find.byKey(const Key('camera-capture-shutter')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('camera-review-page')), findsOneWidget);
    expect(find.byKey(const Key('camera-review-thumbnails')), findsOneWidget);
    expect(find.byKey(const Key('camera-review-thumbnail-0')), findsOneWidget);
    expect(find.byKey(const Key('camera-review-thumbnail-1')), findsOneWidget);

    final firstThumbnail = tester.widget<OutlinedButton>(
      find.byKey(const Key('camera-review-thumbnail-0')),
    );
    expect(firstThumbnail.onPressed, isNotNull);
    firstThumbnail.onPressed!();
    await tester.pumpAndSettle();
    final preview = tester.widget<Image>(
      find.byKey(const Key('camera-review-preview-0')),
    );
    expect((preview.image as FileImage).file.uri.path, '/camera-capture-1.jpg');

    await tester.tap(find.byKey(const Key('camera-review-continue')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('selected-import-draft')), findsOneWidget);
    expect(camera.session.discardCalls, 0);
    expect(await database.select(database.documents).get(), isEmpty);
    expect(await database.select(database.analysisOperations).get(), isEmpty);
  });

  testWidgets('one camera page uses the camera-specific Analyze draft card', (
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
    await tester.tap(find.byKey(const Key('camera-review-continue')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('selected-import-draft')), findsOneWidget);
    expect(find.text('Aufgenommenes Dokument'), findsOneWidget);
    expect(find.text('1 Seite'), findsOneWidget);
    expect(find.byKey(const Key('camera-draft-thumbnail-0')), findsOneWidget);
    expect(find.byKey(const Key('camera-draft-thumbnail-1')), findsNothing);
    expect(find.textContaining('camera-'), findsNothing);
    expect(find.byKey(const Key('edit-camera-draft')), findsOneWidget);
    expect(find.byKey(const Key('replace-import-draft')), findsNothing);
    expect(find.byKey(const Key('analysis-language-selector')), findsOneWidget);
    expect(find.byKey(const Key('analyze-draft-action')), findsOneWidget);
  });

  testWidgets('camera Analyze draft shows every selected page in order', (
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
    await tester.tap(find.byKey(const Key('camera-review-add-page')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('camera-capture-shutter')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('camera-review-continue')));
    await tester.pumpAndSettle();

    expect(find.text('2 Seiten'), findsOneWidget);
    expect(find.byKey(const Key('camera-draft-thumbnails')), findsOneWidget);
    final first = tester.widget<Image>(
      find.byKey(const Key('camera-draft-thumbnail-0')),
    );
    final second = tester.widget<Image>(
      find.byKey(const Key('camera-draft-thumbnail-1')),
    );
    expect((first.image as FileImage).file.uri.path, '/camera-capture-1.jpg');
    expect((second.image as FileImage).file.uri.path, '/camera-capture-2.jpg');

    await tester.tap(find.byKey(const Key('edit-camera-draft')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('camera-review-page')), findsOneWidget);
    await tester.tap(find.byKey(const Key('camera-review-continue')));
    await tester.pumpAndSettle();
    final editedFirst = tester.widget<Image>(
      find.byKey(const Key('camera-draft-thumbnail-0')),
    );
    final editedSecond = tester.widget<Image>(
      find.byKey(const Key('camera-draft-thumbnail-1')),
    );
    expect((editedFirst.image as FileImage).file.uri.path, '/camera-edit-1.jpg');
    expect((editedSecond.image as FileImage).file.uri.path, '/camera-edit-2.jpg');
  });

  testWidgets('camera draft Remove clears every captured page from Analyze', (
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
    await tester.tap(find.byKey(const Key('camera-review-continue')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('remove-import-draft')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('selected-import-draft')), findsNothing);
    expect(find.byKey(const Key('capture-document-action')), findsOneWidget);
    expect(camera.session.discardCalls, 1);
  });

  testWidgets('editing a camera draft preserves it on cancel and replaces it on Continue', (
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
    await tester.tap(find.byKey(const Key('camera-review-continue')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('edit-camera-draft')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('camera-review-page')), findsOneWidget);
    expect(camera.session.duplicateCalls, 1);
    await tester.tap(find.byKey(const Key('camera-review-back')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('camera-review-discard-pages')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('selected-import-draft')), findsOneWidget);
    final original = tester.widget<Image>(
      find.byKey(const Key('camera-draft-thumbnail-0')),
    );
    expect((original.image as FileImage).file.uri.path, '/camera-capture-1.jpg');

    await tester.tap(find.byKey(const Key('edit-camera-draft')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('camera-review-continue')));
    await tester.pumpAndSettle();
    final edited = tester.widget<Image>(
      find.byKey(const Key('camera-draft-thumbnail-0')),
    );
    expect((edited.image as FileImage).file.uri.path, '/camera-edit-2.jpg');
  });

  testWidgets(
    'removing camera-review pages updates selection and returns to Capture',
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
      await tester.tap(find.byKey(const Key('camera-review-add-page')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('camera-capture-shutter')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('camera-review-remove-page-1')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('camera-review-thumbnails')), findsNothing);
      expect(find.byKey(const Key('camera-review-page')), findsOneWidget);

      await tester.tap(find.byKey(const Key('camera-review-retake')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('camera-capture-page')), findsOneWidget);
      expect(camera.session.discardCalls, 1);
    },
  );

  testWidgets(
    'Crop cancels without replacement and applies only the selected page',
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
      await tester.tap(find.byKey(const Key('camera-review-add-page')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('camera-capture-shutter')));
      await tester.pumpAndSettle();
      final firstThumbnail = tester.widget<OutlinedButton>(
        find.byKey(const Key('camera-review-thumbnail-0')),
      );
      expect(firstThumbnail.onPressed, isNotNull);
      firstThumbnail.onPressed!();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('camera-review-crop')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('camera-crop-cancel')));
      await tester.pumpAndSettle();
      expect(camera.session.cropCalls, 0);

      await tester.tap(find.byKey(const Key('camera-review-crop')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('camera-crop-apply')));
      await tester.pumpAndSettle();
      expect(camera.session.cropCalls, 1);
      final preview = tester.widget<Image>(
        find.byKey(const Key('camera-review-preview-0')),
      );
      expect(
        (preview.image as FileImage).file.uri.path,
        '/camera-capture-cropped-1.jpg',
      );
    },
  );

  testWidgets('Camera Review caps the unified flow at ten pages', (
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
    for (var page = 0; page < 10; page++) {
      await tester.tap(find.byKey(const Key('camera-capture-shutter')));
      await tester.pumpAndSettle();
      if (page < 9) {
        await tester.tap(find.byKey(const Key('camera-review-add-page')));
        await tester.pumpAndSettle();
      }
    }

    final addPage = tester.widget<OutlinedButton>(
      find.byKey(const Key('camera-review-add-page')),
    );
    expect(addPage.onPressed, isNull);
    expect(find.text('Maximal 10 Seiten'), findsOneWidget);
    expect(camera.session.captureCalls, 10);
  });

  testWidgets(
    'Continue hands camera pages to Analyze exactly once in capture order',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final camera = _FakeCameraCaptureGateway();
      final remote = _FailedOperationRemote();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(database),
            cameraCaptureGatewayProvider.overrideWithValue(camera),
            analysisRemoteDataSourceProvider.overrideWithValue(remote),
            idGeneratorProvider.overrideWithValue(_SequenceIdGenerator()),
          ],
          child: _app(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('capture-document-action')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('camera-capture-shutter')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('camera-review-add-page')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('camera-capture-shutter')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('camera-review-continue')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('analyze-draft-action')));
      await tester.pumpAndSettle();
      expect(remote.submissions, hasLength(1));
      expect(
        remote.submissions.single.files.map((file) => file.localUri.path),
        ['/camera-capture-1.jpg', '/camera-capture-2.jpg'],
      );
    },
  );

  testWidgets('Retake of a current candidate preserves accepted pages', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final camera = _FakeCameraCaptureGateway();
    final remote = _FailedOperationRemote();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          cameraCaptureGatewayProvider.overrideWithValue(camera),
          analysisRemoteDataSourceProvider.overrideWithValue(remote),
          idGeneratorProvider.overrideWithValue(_SequenceIdGenerator()),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('capture-document-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('camera-capture-shutter')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('camera-review-add-page')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('camera-capture-shutter')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('camera-review-retake')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('camera-capture-page')), findsOneWidget);
    expect(camera.session.discardCalls, 1);

    await tester.tap(find.byKey(const Key('camera-capture-shutter')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('camera-review-continue')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('analyze-draft-action')));
    await tester.pumpAndSettle();
    expect(remote.submissions.single.files.map((file) => file.localUri.path), [
      '/camera-capture-1.jpg',
      '/camera-capture-3.jpg',
    ]);
  });

  testWidgets('Retake of an accepted page replaces it in place', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final camera = _FakeCameraCaptureGateway();
    final remote = _FailedOperationRemote();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          cameraCaptureGatewayProvider.overrideWithValue(camera),
          analysisRemoteDataSourceProvider.overrideWithValue(remote),
          idGeneratorProvider.overrideWithValue(_SequenceIdGenerator()),
        ],
        child: _app(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('capture-document-action')));
    await tester.pumpAndSettle();
    for (var page = 0; page < 3; page++) {
      await tester.tap(find.byKey(const Key('camera-capture-shutter')));
      await tester.pumpAndSettle();
      if (page < 2) {
        await tester.tap(find.byKey(const Key('camera-review-add-page')));
        await tester.pumpAndSettle();
      }
    }
    final middleThumbnail = tester.widget<OutlinedButton>(
      find.byKey(const Key('camera-review-thumbnail-1')),
    );
    middleThumbnail.onPressed!();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('camera-review-retake')));
    await tester.pumpAndSettle();
    expect(camera.session.discardCalls, 0);

    await tester.tap(find.byKey(const Key('camera-capture-shutter')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('camera-review-continue')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('analyze-draft-action')));
    await tester.pumpAndSettle();
    expect(remote.submissions.single.files.map((file) => file.localUri.path), [
      '/camera-capture-1.jpg',
      '/camera-capture-4.jpg',
      '/camera-capture-3.jpg',
    ]);
    expect(camera.session.discardCalls, 1);
  });

  testWidgets(
    'leaving replacement Capture restores the original accepted page',
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
      await tester.tap(find.byKey(const Key('camera-review-add-page')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('camera-capture-shutter')));
      await tester.pumpAndSettle();
      final firstThumbnail = tester.widget<OutlinedButton>(
        find.byKey(const Key('camera-review-thumbnail-0')),
      );
      firstThumbnail.onPressed!();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('camera-review-retake')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('camera-capture-back')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('camera-review-page')), findsOneWidget);
      expect(find.byKey(const Key('camera-review-preview-0')), findsOneWidget);
      expect(camera.session.discardCalls, 0);
    },
  );

  testWidgets(
    'Camera controls follow the interface direction without mirroring preview',
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
          child: _app(const Locale('ar')),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('capture-document-action')));
      await tester.pumpAndSettle();
      expect(
        Directionality.of(
          tester.element(find.byKey(const Key('camera-capture-back'))),
        ),
        TextDirection.rtl,
      );
      await tester.tap(find.byKey(const Key('camera-capture-shutter')));
      await tester.pumpAndSettle();
      expect(
        Directionality.of(
          tester.element(find.byKey(const Key('camera-review-back'))),
        ),
        TextDirection.rtl,
      );
      expect(
        tester
            .widget<Image>(find.byKey(const Key('camera-review-preview-0')))
            .matchTextDirection,
        isFalse,
      );
      await tester.tap(find.byKey(const Key('camera-review-continue')));
      await tester.pumpAndSettle();
      expect(
        Directionality.of(
          tester.element(find.byKey(const Key('selected-import-draft'))),
        ),
        TextDirection.rtl,
      );
      expect(
        tester
            .widget<Image>(find.byKey(const Key('camera-draft-thumbnail-0')))
            .matchTextDirection,
        isFalse,
      );
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
    Completer<CameraCaptureState>? pendingInitialization,
  }) : session = _FakeCameraCaptureSession(
         initialState,
         pendingInitialization: pendingInitialization,
       );

  final _FakeCameraCaptureSession session;

  @override
  CameraCaptureSession createSession() => session;
}

class _FakeCameraCaptureSession implements CameraCaptureSession {
  _FakeCameraCaptureSession(this._state, {this._pendingInitialization});

  CameraCaptureState _state;
  final Completer<CameraCaptureState>? _pendingInitialization;
  var initializeCalls = 0;
  var disposeCalls = 0;
  var pauseCalls = 0;
  var resumeCalls = 0;
  var discardCalls = 0;
  var rotateCalls = 0;
  var cropCalls = 0;
  var captureCalls = 0;
  var duplicateCalls = 0;
  var previewDetached = false;
  var pauseAfterPreviewDetached = false;
  var _flashOn = false;

  @override
  CameraCaptureState get state => _state;

  @override
  bool get isFlashControlAvailable => _state == CameraCaptureState.ready;

  @override
  bool get isFlashOn => _flashOn;

  @override
  Future<CameraCaptureState> initialize() async {
    initializeCalls++;
    final pendingInitialization = _pendingInitialization;
    if (pendingInitialization != null) {
      _state = await pendingInitialization.future;
    }
    return _state;
  }

  @override
  Widget buildPreview() =>
      _FakeCameraPreview(onDispose: () => previewDetached = true);

  @override
  Future<void> toggleFlash() async => _flashOn = !_flashOn;

  @override
  Future<CameraCaptureCandidate> capture() async {
    captureCalls++;
    return CameraCaptureCandidate(
      localUri: Uri.parse('file:///camera-capture-$captureCalls.jpg'),
      capturedAt: DateTime(2026, 1, 1, 0, 0, captureCalls),
    );
  }

  @override
  Future<CameraCaptureCandidate> duplicate(
    CameraCaptureCandidate candidate,
  ) async {
    duplicateCalls++;
    return CameraCaptureCandidate(
      localUri: Uri.parse('file:///camera-edit-$duplicateCalls.jpg'),
      capturedAt: candidate.capturedAt,
    );
  }

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
  Future<CameraCaptureCandidate> crop(
    CameraCaptureCandidate candidate,
    CameraCropRegion region,
  ) async {
    cropCalls++;
    return CameraCaptureCandidate(
      localUri: Uri.parse('file:///camera-capture-cropped-$cropCalls.jpg'),
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
    pauseAfterPreviewDetached = previewDetached;
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

class _FakeCameraPreview extends StatefulWidget {
  const _FakeCameraPreview({required this.onDispose});

  final VoidCallback onDispose;

  @override
  State<_FakeCameraPreview> createState() => _FakeCameraPreviewState();
}

class _FakeCameraPreviewState extends State<_FakeCameraPreview> {
  @override
  void dispose() {
    widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const ColoredBox(color: Colors.black);
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
