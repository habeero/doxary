import 'package:doxary/app/localization/app_localizations.dart';
import 'package:doxary/app/providers.dart';
import 'package:doxary/features/document_analysis/presentation/document_detail_page.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:doxary/features/documents/presentation/documents_page.dart';
import 'package:doxary/features/home/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home keeps the recent preview bounded to five records', (
    tester,
  ) async {
    final documents = [
      for (var i = 0; i < 5; i++)
        LocalDocument(
          clientDocumentId: 'recent-$i',
          classificationState: ClassificationState.unclassified,
          status: DocumentStatus.imported,
          createdAt: DateTime(2026, 1, i + 1),
          updatedAt: DateTime(2026, 1, i + 1),
        ),
    ];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeDocumentsProvider.overrideWithValue(AsyncValue.data(documents)),
          for (final document in documents)
            ..._documentOverrides(document.clientDocumentId),
        ],
        child: _homeApp(const HomePage()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Dokument'), findsNWidgets(5));
  });

  testWidgets('Documents library shows all records and no opaque IDs', (
    tester,
  ) async {
    final documents = [
      for (var i = 0; i < 6; i++)
        LocalDocument(
          clientDocumentId: 'opaque-$i',
          classificationState: ClassificationState.unclassified,
          status: DocumentStatus.imported,
          createdAt: DateTime(2026, 1, i + 1),
          updatedAt: DateTime(2026, 1, i + 1),
        ),
    ];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDocumentsProvider.overrideWithValue(AsyncValue.data(documents)),
          organizationsProvider.overrideWithValue(const AsyncValue.data([])),
          casesProvider.overrideWithValue(const AsyncValue.data([])),
          for (final document in documents)
            ..._documentOverrides(document.clientDocumentId),
        ],
        child: _app(const DocumentsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dokument'), findsNWidgets(6));
    expect(find.text('opaque-0'), findsNothing);
  });

  testWidgets(
    'confirmed hierarchy groups documents while suggestions stay unclassified',
    (tester) async {
      final confirmed = LocalDocument(
        clientDocumentId: 'confirmed-id',
        organizationId: 'org-1',
        caseId: 'case-1',
        classificationState: ClassificationState.confirmed,
        status: DocumentStatus.analyzed,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );
      final suggested = LocalDocument(
        clientDocumentId: 'suggested-id',
        classificationState: ClassificationState.suggested,
        status: DocumentStatus.analyzed,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );
      final analysis = DocumentAnalysis(
        id: 'analysis',
        clientDocumentId: suggested.clientDocumentId,
        schemaVersion: 'analysis_result.v1',
        targetLanguage: 'de',
        createdAt: DateTime(2026),
        classification: const ClassificationSuggestion(
          organizationName: 'Suggested office',
          documentType: 'Bescheid',
        ),
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allDocumentsProvider.overrideWithValue(
              AsyncValue.data([confirmed, suggested]),
            ),
            organizationsProvider.overrideWithValue(
              AsyncValue.data([
                Organization(
                  id: 'org-1',
                  name: 'Jobcenter',
                  category: OrganizationCategory.jobcenter,
                  createdAt: DateTime(2026),
                  updatedAt: DateTime(2026),
                ),
              ]),
            ),
            casesProvider.overrideWithValue(
              AsyncValue.data([
                Case(
                  id: 'case-1',
                  organizationId: 'org-1',
                  title: 'Wohnkosten',
                  createdAt: DateTime(2026),
                  updatedAt: DateTime(2026),
                ),
              ]),
            ),
            ..._documentOverrides(confirmed.clientDocumentId),
            ..._documentOverrides(
              suggested.clientDocumentId,
              analysis: analysis,
            ),
          ],
          child: _app(const DocumentsPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Jobcenter'), findsNWidgets(2));
      expect(find.text('Wohnkosten · Zugeordnet'), findsOneWidget);
      expect(find.text('Nicht zugeordnet'), findsOneWidget);
      expect(find.text('Bescheid'), findsOneWidget);
      expect(find.text('Vorschlag – bitte bestätigen'), findsOneWidget);
      expect(find.text('Suggested office'), findsNothing);
    },
  );

  testWidgets(
    'document detail separates original file metadata from analysis',
    (tester) async {
      final document = LocalDocument(
        clientDocumentId: 'doc-1',
        classificationState: ClassificationState.unclassified,
        status: DocumentStatus.analyzed,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );
      final analysis = DocumentAnalysis(
        id: 'analysis',
        clientDocumentId: 'doc-1',
        schemaVersion: 'analysis_result.v1',
        targetLanguage: 'de',
        createdAt: DateTime(2026),
        summary: 'Persisted summary',
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            documentProvider('doc-1')
                .overrideWithValue(AsyncValue.data(document)),
            documentFilesProvider('doc-1').overrideWithValue(
              AsyncValue.data([
                DocumentFile(
                  id: 'file-1',
                  clientDocumentId: 'doc-1',
                  localUri: Uri.parse('file:///private/letter.pdf'),
                  mediaType: 'application/pdf',
                  originalFilename: 'letter.pdf',
                  importedAt: DateTime(2026),
                ),
              ]),
            ),
            latestAnalysisProvider('doc-1')
                .overrideWithValue(AsyncValue.data(analysis)),
            organizationsProvider.overrideWithValue(const AsyncValue.data([])),
            casesProvider.overrideWithValue(const AsyncValue.data([])),
          ],
          child: _app(const DocumentDetailPage(clientDocumentId: 'doc-1')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Originaldokument'), findsOneWidget);
      expect(
        find.text(
          'Das Original ist lokal gespeichert. Öffnen ist noch nicht verfügbar.',
        ),
        findsOneWidget,
      );
      expect(find.text('letter.pdf'), findsNothing);
      expect(find.text('Persisted summary'), findsOneWidget);
    },
  );
}

List _documentOverrides(String id, {DocumentAnalysis? analysis}) => [
  latestAnalysisProvider(id).overrideWithValue(AsyncValue.data(analysis)),
  documentFilesProvider(id).overrideWithValue(const AsyncValue.data([])),
];

Widget _app(Widget home) => MaterialApp(
  locale: const Locale('de'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  home: home,
);

Widget _homeApp(Widget home) => _app(Scaffold(body: home));
