import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:doxary/app/localization/app_localizations.dart';
import 'package:doxary/app/providers.dart';
import 'package:doxary/core/database/app_database.dart';
import 'package:doxary/features/document_analysis/presentation/analysis_result_page.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:doxary/features/documents/presentation/documents_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('complete result renders summary and representative sections', (
    tester,
  ) async {
    await _pump(tester, _complete(), const Locale('de'));
    expect(find.text('Vollständig'), findsOneWidget);
    expect(find.text('A clear summary'), findsOneWidget);
    expect(find.text('Reply: 2026-10-01'), findsOneWidget);
    expect(find.text('Benötigte Dokumente'), findsOneWidget);
    expect(find.text('Ausgabestil: Einfach'), findsOneWidget);
  });

  testWidgets('partial result is presented as a valid outcome', (tester) async {
    await _pump(
      tester,
      _complete(status: AnalysisStatus.partial),
      const Locale('de'),
    );
    expect(find.textContaining('Teilweise'), findsOneWidget);
    expect(find.text('The saved analysis could not be read.'), findsNothing);
  });

  testWidgets('unavailable result renders quality guidance', (tester) async {
    await _pump(
      tester,
      _complete(status: AnalysisStatus.unavailable),
      const Locale('de'),
    );
    expect(find.text('Analyse nicht verfügbar.'), findsOneWidget);
    expect(find.text('Dokumentenqualität'), findsOneWidget);
    expect(find.text('Das Bild ist möglicherweise unscharf.'), findsOneWidget);
  });

  testWidgets('absent optional sections are omitted', (tester) async {
    await _pump(
      tester,
      DocumentAnalysis(
        id: 'a',
        clientDocumentId: 'doc',
        schemaVersion: 'analysis_result.v1',
        targetLanguage: 'de',
        createdAt: DateTime(2026),
        summary: 'Only summary',
        explanation: 'Only explanation',
      ),
      const Locale('de'),
    );
    expect(find.text('Only summary'), findsOneWidget);
    expect(find.text('Deadlines'), findsNothing);
    expect(find.text('Appointments'), findsNothing);
    expect(find.text('Amounts'), findsNothing);
    expect(find.text('Required documents'), findsNothing);
  });

  testWidgets('Arabic result displays Arabic content and RTL direction', (
    tester,
  ) async {
    await _pump(
      tester,
      _complete(language: 'ar', summary: 'ملخص عربي', explanation: 'شرح عربي'),
      const Locale('ar'),
    );
    expect(find.text('ملخص عربي'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(AnalysisResultPage))),
      TextDirection.rtl,
    );
  });

  testWidgets(
    'reopening a document reads its latest persisted analysis without a backend',
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
            const Locale('de'),
            const AnalysisResultPage(clientDocumentId: 'doc'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Persisted summary'), findsOneWidget);
      expect(find.text('Ausgabestil: Einfach'), findsOneWidget);
    },
  );

  testWidgets('document navigation opens persisted result presentation', (
    tester,
  ) async {
    final analysis = _complete();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDocumentsProvider.overrideWithValue(
            AsyncValue.data([
              LocalDocument(
                clientDocumentId: 'doc',
                classificationState: ClassificationState.unclassified,
                status: DocumentStatus.analyzed,
                createdAt: DateTime(2026),
                updatedAt: DateTime(2026),
              ),
            ]),
          ),
          documentProvider('doc').overrideWithValue(
            AsyncValue.data(
              LocalDocument(
                clientDocumentId: 'doc',
                classificationState: ClassificationState.unclassified,
                status: DocumentStatus.analyzed,
                createdAt: DateTime(2026),
                updatedAt: DateTime(2026),
              ),
            ),
          ),
          documentFilesProvider('doc')
              .overrideWithValue(const AsyncValue.data([])),
          organizationsProvider.overrideWithValue(const AsyncValue.data([])),
          casesProvider.overrideWithValue(const AsyncValue.data([])),
          latestAnalysisProvider('doc')
              .overrideWithValue(AsyncValue.data(analysis)),
        ],
        child: _app(const Locale('de'), const DocumentsPage()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Dokument'));
    await tester.pumpAndSettle();
    expect(find.byType(AnalysisResultPage), findsOneWidget);
    expect(find.text('A clear summary'), findsOneWidget);
  });
}

Future<void> _pump(
  WidgetTester tester,
  DocumentAnalysis analysis,
  Locale locale,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        latestAnalysisProvider('doc')
            .overrideWithValue(AsyncValue.data(analysis)),
      ],
      child: _app(locale, const AnalysisResultPage(clientDocumentId: 'doc')),
    ),
  );
  await tester.pumpAndSettle();
}

Widget _app(Locale locale, Widget home) => MaterialApp(
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

DocumentAnalysis _complete({
  AnalysisStatus status = AnalysisStatus.complete,
  String language = 'de',
  String summary = 'A clear summary',
  String explanation = 'Do the next thing',
}) => DocumentAnalysis(
  id: 'analysis',
  clientDocumentId: 'doc',
  schemaVersion: 'analysis_result.v1',
  targetLanguage: language,
  createdAt: DateTime(2026),
  summary: summary,
  explanation: explanation,
  analysisStatus: status,
  explanationStyle: language == 'de'
      ? ExplanationStyle.simple
      : ExplanationStyle.standard,
  deadlines: const [
    AnalysisDeadline(
      label: 'Reply',
      dateOrRange: '2026-10-01',
      confidence: 0.9,
    ),
  ],
  requiredDocuments: const [
    AnalysisRequiredDocument(description: 'Identity document', confidence: 0.8),
  ],
  qualityReasons: const [DocumentQualityReason.blurryImage],
);
