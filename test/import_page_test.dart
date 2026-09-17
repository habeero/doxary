import 'package:drift/native.dart';
import 'package:doxary/app/localization/app_localizations.dart';
import 'package:doxary/app/providers.dart';
import 'package:doxary/core/database/app_database.dart';
import 'package:doxary/core/errors/app_error.dart';
import 'package:doxary/core/errors/result.dart';
import 'package:doxary/core/utils/id_generator.dart';
import 'package:doxary/features/document_analysis/domain/analysis_submission.dart';
import 'package:doxary/features/document_import/domain/document_import.dart';
import 'package:doxary/features/document_import/presentation/import_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
            idGeneratorProvider.overrideWithValue(_SequenceIdGenerator()),
            importGatewayProvider.overrideWithValue(_SelectionGateway()),
            analysisRemoteDataSourceProvider.overrideWithValue(remote),
          ],
          child: _app(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Bilder'));
      await tester.pump();
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
}

Widget _app() => MaterialApp(
  locale: const Locale('de'),
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
