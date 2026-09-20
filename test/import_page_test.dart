import 'package:drift/native.dart';
import 'package:doxary/app/localization/app_localizations.dart';
import 'package:doxary/app/providers.dart';
import 'package:doxary/core/database/app_database.dart';
import 'package:doxary/core/errors/app_error.dart';
import 'package:doxary/core/errors/result.dart';
import 'package:doxary/core/utils/id_generator.dart';
import 'package:doxary/features/document_analysis/domain/analysis_submission.dart';
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
    'terminal operation failure replaces loading state with a localized retry-safe message',
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

      final firstSubmission = remote.submissions.single;
      await tester.tap(find.text('Analyse starten'));
      await tester.pumpAndSettle();

      expect(remote.submitCalls, 2);
      expect(remote.getCalls, 2);
      expect(
        remote.submissions.last.clientDocumentId,
        firstSubmission.clientDocumentId,
      );
      expect(
        remote.submissions.last.idempotencyKey,
        isNot(firstSubmission.idempotencyKey),
      );
      final operations = await database
          .select(database.analysisOperations)
          .get();
      expect(operations, hasLength(2));
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

  testWidgets('empty Analyze root has focused actions and language selection', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
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
    'empty Analyze root preserves capture and file-picker callbacks',
    (tester) async {
      final gateway = _RecordingGateway();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [importGatewayProvider.overrideWithValue(gateway)],
          child: _app(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('capture-document-action')));
      await tester.pumpAndSettle();
      expect(gateway.sources, [ImportSource.camera]);

      await tester.tap(find.byKey(const Key('choose-file-image-action')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('import-choose-image')));
      await tester.pumpAndSettle();
      expect(gateway.sources, [ImportSource.camera, ImportSource.imageLibrary]);
    },
  );

  testWidgets('empty Analyze root leaves the host bottom navigation visible', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          importGatewayProvider.overrideWithValue(_RecordingGateway()),
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

    expect(find.byType(NavigationBar), findsOneWidget);
  });
}

Widget _app([Locale locale = const Locale('de')]) => MaterialApp(
  locale: locale,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  home: const ImportPage(),
);

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

class _SequenceIdGenerator implements IdGenerator {
  int _counter = 0;

  @override
  String newId() => 'generated-${++_counter}';
}
