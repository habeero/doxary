import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:doxary/app/localization/app_localizations.dart';
import 'package:doxary/app/providers.dart';
import 'package:doxary/app/theme/app_theme.dart';
import 'package:doxary/core/database/app_database.dart';
import 'package:doxary/core/utils/id_generator.dart';
import 'package:doxary/features/document_analysis/domain/analysis_submission.dart';
import 'package:doxary/features/document_analysis/presentation/analysis_result_page.dart';
import 'package:doxary/features/document_analysis/presentation/document_detail_page.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:doxary/features/documents/presentation/documents_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('complete no-action result follows the approved hierarchy', (
    tester,
  ) async {
    await _pumpAnalysis(tester, _analysis());

    expect(find.byKey(const Key('no-action-state')), findsOneWidget);
    expect(find.text('Keine Aktion erforderlich'), findsOneWidget);
    expect(find.text('A clear summary'), findsOneWidget);
    expect(find.text('Wichtige Angaben'), findsOneWidget);
    expect(find.text('Reply'), findsOneWidget);
    expect(find.text('2026-10-01'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('A clear summary')).dy,
      lessThan(tester.getTopLeft(find.byKey(const Key('no-action-state'))).dy),
    );
  });

  testWidgets('classification, details, and original follow primary content', (
    tester,
  ) async {
    await _pumpWidget(
      tester,
      DocumentResultView(
        title: 'Bescheid',
        analysis: _analysis(explanation: 'Full explanation'),
        classificationSection: const Text('Classification slot'),
        originalDocumentSection: const Text('Original slot'),
      ),
    );

    final titleY = tester
        .getTopLeft(find.byKey(const Key('document-result-title')))
        .dy;
    final summaryY = tester.getTopLeft(find.text('A clear summary')).dy;
    final actionY = tester
        .getTopLeft(find.byKey(const Key('no-action-state')))
        .dy;
    final factsY = tester.getTopLeft(find.text('Wichtige Angaben')).dy;
    final classificationY = tester
        .getTopLeft(find.text('Classification slot'))
        .dy;
    final detailsY = tester.getTopLeft(find.text('Weitere Analysedetails')).dy;
    final originalY = tester.getTopLeft(find.text('Original slot')).dy;

    expect(titleY, lessThan(summaryY));
    expect(summaryY, lessThan(actionY));
    expect(actionY, lessThan(factsY));
    expect(factsY, lessThan(classificationY));
    expect(classificationY, lessThan(detailsY));
    expect(detailsY, lessThan(originalY));
  });

  testWidgets('long mixed Arabic and German title stays bounded on mobile', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpWidget(
      tester,
      DocumentResultView(
        title: 'إشعار طويل جدًا zur Betriebskostenabrechnung und Zahlungsaufforderung 2026',
        analysis: _analysis(),
      ),
      locale: const Locale('ar'),
      theme: AppTheme.dark(),
    );

    final title = tester.widget<Text>(
      find.byKey(const Key('document-result-title')),
    );
    expect(title.maxLines, 3);
    expect(title.overflow, TextOverflow.ellipsis);
    expect(title.style?.fontSize, 22);
    expect(tester.takeException(), null);
    final background = tester.widget<ColoredBox>(
      find.byKey(const Key('document-result-background')),
    );
    expect(background.color, AppColors.darkBackground);
  });

  testWidgets('action-required result provides its supported CTA', (
    tester,
  ) async {
    var added = false;
    await _pumpWidget(
      tester,
      DocumentResultView(
        title: 'Bescheid',
        analysis: _analysis(
          action: ActionRequirement.yes,
          nextActions: const ['Reply to the letter'],
        ),
        onAddTask: () => added = true,
      ),
    );

    expect(find.byKey(const Key('action-required-state')), findsOneWidget);
    expect(find.text('Reply to the letter'), findsWidgets);
    await tester.tap(find.text('Aufgabe oder Erinnerung hinzufügen'));
    expect(added, isTrue);
  });

  testWidgets('partial result shows review guidance as a valid outcome', (
    tester,
  ) async {
    await _pumpAnalysis(tester, _analysis(status: AnalysisStatus.partial));

    expect(find.byKey(const Key('partial-state')), findsOneWidget);
    expect(find.text('Bitte prüfen'), findsWidgets);
    expect(find.text('A clear summary'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('partial-state'))).height,
      lessThan(140),
    );
    expect(
      find.text('Gespeicherte Analyse konnte nicht gelesen werden.'),
      findsNothing,
    );
  });

  testWidgets('technical failure offers retry and keeps the document surface', (
    tester,
  ) async {
    var retried = false;
    await _pumpWidget(
      tester,
      DocumentResultView(
        title: 'Dokument',
        technicalFailure: true,
        onRetry: () => retried = true,
        originalDocumentSection: const Text('Original remains'),
      ),
    );

    expect(find.byKey(const Key('technical-failure-state')), findsOneWidget);
    expect(find.text('Original remains'), findsOneWidget);
    await tester.tap(find.text('Analyse erneut starten'));
    expect(retried, isTrue);
  });

  testWidgets(
    'failed Document retry reuses the Document and creates a new submission',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final now = DateTime(2026);
      await database
          .into(database.documents)
          .insert(
            DocumentsCompanion.insert(
              clientDocumentId: 'doc',
              classificationState: 'unclassified',
              status: 'needsReview',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.documentFiles)
          .insert(
            DocumentFilesCompanion.insert(
              id: 'file',
              clientDocumentId: 'doc',
              localUri: 'file:///document.pdf',
              mediaType: 'application/pdf',
              importedAt: now,
            ),
          );
      final remote = _SuccessfulRetryRemote();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(database),
            analysisRemoteDataSourceProvider.overrideWithValue(remote),
            idGeneratorProvider.overrideWithValue(_FixedIdGenerator()),
          ],
          child: _app(
            const DocumentDetailPage(clientDocumentId: 'doc'),
            const Locale('de'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('technical-failure-state')), findsOneWidget);
      await tester.tap(find.text('Analyse erneut starten'));
      await tester.pumpAndSettle();

      expect(remote.submissions, hasLength(1));
      expect(remote.submissions.single.clientDocumentId, 'doc');
      expect(remote.submissions.single.idempotencyKey, 'new-submission-key');
      expect(remote.getCalls, 1);
      expect(find.text('Retry succeeded'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    },
  );

  testWidgets('unreadable result prioritizes a corrective source action', (
    tester,
  ) async {
    var replaced = false;
    await _pumpWidget(
      tester,
      DocumentResultView(
        title: 'Dokument',
        analysis: _analysis(status: AnalysisStatus.unavailable),
        onReplaceDocument: () => replaced = true,
      ),
    );

    expect(find.byKey(const Key('unreadable-state')), findsOneWidget);
    expect(find.text('Dokument nicht ausreichend lesbar'), findsOneWidget);
    await tester.tap(find.text('Klareres Dokument auswählen'));
    expect(replaced, isTrue);
  });

  testWidgets('absent fact values do not create empty fact rows', (
    tester,
  ) async {
    await _pumpAnalysis(
      tester,
      _analysis(
        deadlines: const [
          AnalysisDeadline(
            label: 'Unknown',
            dateOrRange: null,
            confidence: 0.2,
          ),
        ],
      ),
    );

    expect(find.text('Wichtige Angaben'), findsNothing);
    expect(find.text('Unknown'), findsNothing);
    expect(find.textContaining('uncertain'), findsNothing);
  });

  testWidgets('secondary explanation is expandable', (tester) async {
    await _pumpAnalysis(tester, _analysis(explanation: 'Full explanation'));

    expect(find.textContaining('Full explanation'), findsNothing);
    final accordion = find.text('Weitere Analysedetails');
    await tester.ensureVisible(accordion);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.expand_more));
    await tester.pumpAndSettle();
    expect(find.textContaining('Full explanation'), findsOneWidget);
    final explanation = tester.widget<Text>(
      find.byKey(const Key('analysis-explanation-text')),
    );
    expect(explanation.style?.height, 1.55);
    expect(explanation.data, 'Full explanation');
  });

  testWidgets('Arabic result uses RTL and localized state language', (
    tester,
  ) async {
    await _pumpAnalysis(
      tester,
      _analysis(summary: 'ملخص واضح'),
      locale: const Locale('ar'),
    );

    expect(find.text('ملخص واضح'), findsOneWidget);
    expect(find.text('لا يلزم اتخاذ إجراء'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(AnalysisResultPage))),
      TextDirection.rtl,
    );
  });

  testWidgets('reopening reads the latest persisted analysis locally', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final now = DateTime(2026);
    await database
        .into(database.documents)
        .insert(
          DocumentsCompanion.insert(
            clientDocumentId: 'doc',
            classificationState: 'unclassified',
            status: 'analyzed',
            createdAt: now,
            updatedAt: now,
          ),
        );
    await database
        .into(database.analyses)
        .insert(
          AnalysesCompanion.insert(
            id: 'analysis',
            clientDocumentId: 'doc',
            schemaVersion: 'analysis_result.v1',
            targetLanguage: 'de',
            summary: const Value('Persisted summary'),
            explanation: const Value('Persisted explanation'),
            state: 'complete',
            createdAt: now,
            explanationStyle: const Value('simple'),
          ),
        );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: _app(
          const AnalysisResultPage(clientDocumentId: 'doc'),
          const Locale('de'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Persisted summary'), findsOneWidget);
    expect(find.byKey(const Key('document-result-scroll')), findsOneWidget);
  });

  testWidgets('document navigation opens the stable Document Detail surface', (
    tester,
  ) async {
    final document = LocalDocument(
      clientDocumentId: 'doc',
      classificationState: ClassificationState.unclassified,
      status: DocumentStatus.analyzed,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDocumentsProvider.overrideWithValue(AsyncValue.data([document])),
          documentProvider('doc').overrideWithValue(AsyncValue.data(document)),
          documentFilesProvider('doc')
              .overrideWithValue(const AsyncValue.data([])),
          organizationsProvider.overrideWithValue(const AsyncValue.data([])),
          casesProvider.overrideWithValue(const AsyncValue.data([])),
          latestAnalysisProvider('doc')
              .overrideWithValue(AsyncValue.data(_analysis())),
        ],
        child: _app(const DocumentsPage(), const Locale('de')),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Dokument'));
    await tester.pumpAndSettle();

    expect(find.byType(DocumentDetailPage), findsOneWidget);
    expect(find.byKey(const Key('document-result-scroll')), findsOneWidget);
    expect(find.text('A clear summary'), findsOneWidget);
  });
}

Future<void> _pumpAnalysis(
  WidgetTester tester,
  DocumentAnalysis analysis, {
  Locale locale = const Locale('de'),
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        latestAnalysisProvider('doc')
            .overrideWithValue(AsyncValue.data(analysis)),
      ],
      child: _app(const AnalysisResultPage(clientDocumentId: 'doc'), locale),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpWidget(
  WidgetTester tester,
  Widget child, {
  Locale locale = const Locale('de'),
  ThemeData? theme,
}) async {
  await tester.pumpWidget(_app(child, locale, theme: theme));
  await tester.pumpAndSettle();
}

Widget _app(Widget home, Locale locale, {ThemeData? theme}) => MaterialApp(
  theme: theme ?? AppTheme.light(),
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

DocumentAnalysis _analysis({
  AnalysisStatus status = AnalysisStatus.complete,
  ActionRequirement action = ActionRequirement.no,
  String summary = 'A clear summary',
  String? explanation,
  List<String> nextActions = const [],
  List<AnalysisDeadline>? deadlines,
}) => DocumentAnalysis(
  id: 'analysis',
  clientDocumentId: 'doc',
  schemaVersion: 'analysis_result.v1',
  targetLanguage: 'de',
  createdAt: DateTime(2026),
  summary: summary,
  explanation: explanation,
  analysisStatus: status,
  actionRequired: action,
  deadlines:
      deadlines ??
      const [
        AnalysisDeadline(
          label: 'Reply',
          dateOrRange: '2026-10-01',
          confidence: 0.9,
        ),
      ],
  nextActions: nextActions,
  qualityReasons: status == AnalysisStatus.unavailable
      ? const [DocumentQualityReason.blurryImage]
      : const [],
);

class _FixedIdGenerator implements IdGenerator {
  @override
  String newId() => 'new-submission-key';
}

class _SuccessfulRetryRemote implements DocumentAnalysisRemoteDataSource {
  final submissions = <AnalysisSubmission>[];
  int getCalls = 0;

  @override
  Future<AcceptedAnalysisOperation> submit(
    AnalysisSubmission submission,
  ) async {
    submissions.add(submission);
    return const AcceptedAnalysisOperation(
      operationId: 'operation',
      requestId: 'request',
    );
  }

  @override
  Future<BackendOperation> getOperation(String operationId) async {
    getCalls++;
    return BackendOperation(
      operationId: operationId,
      status: BackendOperationStatus.succeeded,
      requestId: null,
      result: DocumentAnalysis(
        id: 'retry-analysis',
        clientDocumentId: 'doc',
        schemaVersion: 'analysis_result.v1',
        targetLanguage: 'de',
        createdAt: DateTime(2026, 1, 2),
        summary: 'Retry succeeded',
        actionRequired: ActionRequirement.no,
      ),
    );
  }
}
