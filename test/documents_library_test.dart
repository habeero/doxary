import 'package:doxary/app/localization/app_localizations.dart';
import 'package:doxary/app/providers.dart';
import 'package:doxary/features/cases/presentation/case_page.dart';
import 'package:doxary/features/document_analysis/domain/analysis_repository.dart';
import 'package:doxary/features/document_analysis/domain/analysis_submission.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:doxary/features/documents/presentation/documents_page.dart';
import 'package:doxary/features/home/presentation/home_page.dart';
import 'package:doxary/features/organizations/presentation/organization_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('Home keeps its recent preview bounded', (tester) async {
    final documents = [for (var i = 0; i < 5; i++) _document('recent-$i')];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeDocumentsProvider.overrideWithValue(AsyncValue.data(documents)),
          activeAnalysisOperationsProvider.overrideWithValue(
            const AsyncValue.data([]),
          ),
          openTasksProvider.overrideWithValue(const AsyncValue.data([])),
          completedTasksProvider.overrideWithValue(
            const AsyncValue.data([]),
          ),
          for (final document in documents)
            ..._documentOverrides(document.clientDocumentId),
        ],
        child: _app(Scaffold(body: HomePage())),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('home-recent-document-recent-0')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('home-recent-document-recent-5')),
      findsNothing,
    );
  });

  testWidgets(
    'Home derives processing from active operations, not stale document status',
    (tester) async {
      final document = _document(
        'stale-processing',
        status: DocumentStatus.processing,
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            homeDocumentsProvider.overrideWithValue(
              AsyncValue.data([document]),
            ),
            activeAnalysisOperationsProvider.overrideWithValue(
              const AsyncValue.data([]),
            ),
            openTasksProvider.overrideWithValue(const AsyncValue.data([])),
            completedTasksProvider.overrideWithValue(
              const AsyncValue.data([]),
            ),
            ..._documentOverrides(document.clientDocumentId),
          ],
          child: _app(Scaffold(body: HomePage())),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('In Bearbeitung'), findsNothing);
    },
  );

  testWidgets('Home shows each active operation Document once', (tester) async {
    final document = _document(
      'active-processing',
      status: DocumentStatus.processing,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeDocumentsProvider.overrideWithValue(AsyncValue.data([document])),
          activeAnalysisOperationsProvider.overrideWithValue(
            const AsyncValue.data([
              PendingAnalysisOperation(
                operationId: 'operation-1',
                clientDocumentId: 'active-processing',
                state: AnalysisLifecycleState.processing,
              ),
            ]),
          ),
          openTasksProvider.overrideWithValue(const AsyncValue.data([])),
          completedTasksProvider.overrideWithValue(
            const AsyncValue.data([]),
          ),
          ..._documentOverrides(document.clientDocumentId),
        ],
        child: _app(Scaffold(body: HomePage())),
      ),
    );
    // The active Processing indicator is intentionally indeterminate, so the
    // test must not wait for all animations to settle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1));

    expect(find.text('In Bearbeitung'), findsOneWidget);
    expect(
      find.byKey(const Key('home-processing-document-active-processing')),
      findsOneWidget,
    );
  });

  testWidgets(
    'Documents root defaults to a three-column folder grid and switches to list',
    (tester) async {
      final document = _document('doc', organizationId: 'org-0');
      final organizations = [
        for (var i = 0; i < 3; i++) _organization('org-$i', 'Organization $i'),
      ];
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allDocumentsProvider.overrideWithValue(AsyncValue.data([document])),
            organizationsProvider.overrideWithValue(
              AsyncValue.data(organizations),
            ),
            casesProvider.overrideWithValue(const AsyncValue.data([])),
            ..._documentOverrides(document.clientDocumentId),
          ],
          child: _app(const DocumentsPage()),
        ),
      );
      await tester.pumpAndSettle();

      final grid = tester.widget<GridView>(
        find.byKey(const Key('documents-organization-grid')),
      );
      expect(
        (grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount)
            .crossAxisCount,
        3,
      );
      expect(find.text('Organization 0'), findsOneWidget);

      await tester.tap(find.byKey(const Key('documents-view-toggle')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('documents-organization-list')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('documents-organization-grid')),
        findsNothing,
      );
    },
  );

  testWidgets('Unclassified remains separate from Organization folders', (
    tester,
  ) async {
    final unclassified = _document('unclassified');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDocumentsProvider.overrideWithValue(
            AsyncValue.data([unclassified]),
          ),
          organizationsProvider.overrideWithValue(const AsyncValue.data([])),
          casesProvider.overrideWithValue(const AsyncValue.data([])),
          ..._documentOverrides(unclassified.clientDocumentId),
        ],
        child: _app(const DocumentsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('unclassified-folder')), findsOneWidget);
    expect(find.byKey(const Key('documents-organization-grid')), findsNothing);
    expect(find.text('Dokument'), findsNothing);
  });

  testWidgets('Unclassified entry opens its focused document list', (
    tester,
  ) async {
    final unclassified = _document('unclassified');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDocumentsProvider.overrideWithValue(
            AsyncValue.data([unclassified]),
          ),
          organizationsProvider.overrideWithValue(const AsyncValue.data([])),
          casesProvider.overrideWithValue(const AsyncValue.data([])),
          ..._documentOverrides(unclassified.clientDocumentId),
        ],
        child: _app(const DocumentsPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('unclassified-folder')));
    await tester.pumpAndSettle();
    expect(find.byType(UnclassifiedDocumentsPage), findsOneWidget);
    expect(find.text('Dokument'), findsOneWidget);
  });

  testWidgets('Organization keeps Without Case distinct from Case folders', (
    tester,
  ) async {
    final document = _document('org-only', organizationId: 'org-1');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDocumentsProvider.overrideWithValue(AsyncValue.data([document])),
          organizationsProvider.overrideWithValue(
            AsyncValue.data([_organization('org-1', 'Long organization name')]),
          ),
          casesProvider.overrideWithValue(
            AsyncValue.data([
              Case(
                id: 'case-1',
                organizationId: 'org-1',
                title: 'Normal case',
                createdAt: DateTime(2026),
                updatedAt: DateTime(2026),
              ),
            ]),
          ),
          ..._documentOverrides(document.clientDocumentId),
        ],
        child: _app(const OrganizationPage(organizationId: 'org-1')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('without-case-folder')), findsOneWidget);
    expect(find.text('Normal case'), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('Long organization name')).overflow,
      TextOverflow.ellipsis,
    );
  });

  testWidgets(
    'Without Case retains Organization context and compact document rows',
    (tester) async {
      final document = _document('org-only', organizationId: 'org-1');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allDocumentsProvider.overrideWithValue(AsyncValue.data([document])),
            organizationsProvider.overrideWithValue(
              AsyncValue.data([_organization('org-1', 'Organization context')]),
            ),
            casesProvider.overrideWithValue(const AsyncValue.data([])),
            ..._documentOverrides(document.clientDocumentId),
          ],
          child: _app(
            const OrganizationWithoutCasePage(organizationId: 'org-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Organization context'), findsOneWidget);
      expect(
        tester.widget<Text>(find.text('Organization context')).overflow,
        TextOverflow.ellipsis,
      );
      expect(find.byKey(const Key('context-document-search')), findsOneWidget);
      expect(find.byIcon(Icons.description_outlined), findsOneWidget);
      expect(find.byType(Card), findsNothing);
    },
  );

  testWidgets('Without Case entry opens only organization-only documents', (
    tester,
  ) async {
    final organizationOnly = _document(
      'organization-only',
      organizationId: 'org-1',
    );
    final caseDocument = _document(
      'case-document',
      organizationId: 'org-1',
      caseId: 'case-1',
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDocumentsProvider.overrideWithValue(
            AsyncValue.data([organizationOnly, caseDocument]),
          ),
          organizationsProvider.overrideWithValue(
            AsyncValue.data([_organization('org-1', 'Organization context')]),
          ),
          casesProvider.overrideWithValue(
            AsyncValue.data([_case('case-1', 'org-1', 'Case')]),
          ),
          ..._documentOverrides(organizationOnly.clientDocumentId),
          ..._documentOverrides(caseDocument.clientDocumentId),
        ],
        child: _app(const OrganizationPage(organizationId: 'org-1')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('without-case-folder')));
    await tester.pumpAndSettle();
    expect(find.byType(OrganizationWithoutCasePage), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
  });

  testWidgets('Documents search omits an empty document results section', (
    tester,
  ) async {
    final document = _document('document', organizationId: 'org-1');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDocumentsProvider.overrideWithValue(AsyncValue.data([document])),
          organizationsProvider.overrideWithValue(
            AsyncValue.data([_organization('org-1', 'Housing office')]),
          ),
          casesProvider.overrideWithValue(const AsyncValue.data([])),
          ..._documentOverrides(document.clientDocumentId),
        ],
        child: _app(const DocumentsPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Housing');
    await tester.pumpAndSettle();
    expect(find.text('Organisationen'), findsOneWidget);
    expect(
      find.byKey(const Key('document-search-results-heading')),
      findsNothing,
    );
  });

  testWidgets('Case uses compact document rows', (tester) async {
    final document = _document('case-doc', caseId: 'case-1');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDocumentsProvider.overrideWithValue(AsyncValue.data([document])),
          organizationsProvider.overrideWithValue(const AsyncValue.data([])),
          casesProvider.overrideWithValue(
            AsyncValue.data([
              Case(
                id: 'case-1',
                organizationId: 'org-1',
                title: 'Case title',
                createdAt: DateTime(2026),
                updatedAt: DateTime(2026),
              ),
            ]),
          ),
          ..._documentOverrides(document.clientDocumentId),
        ],
        child: _app(const CasePage(caseId: 'case-1')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.description_outlined), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);
    expect(find.byType(Card), findsNothing);
    expect(
      tester.widget<Text>(find.text('Case title')).overflow,
      TextOverflow.ellipsis,
    );
  });

  testWidgets('Organization search filters Cases in its context', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDocumentsProvider.overrideWithValue(const AsyncValue.data([])),
          organizationsProvider.overrideWithValue(
            AsyncValue.data([_organization('org-1', 'Organization')]),
          ),
          casesProvider.overrideWithValue(
            AsyncValue.data([
              _case('case-1', 'org-1', 'Housing support'),
              _case('case-2', 'org-1', 'Residence permit'),
            ]),
          ),
        ],
        child: _app(const OrganizationPage(organizationId: 'org-1')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('organization-context-search')),
      'Housing',
    );
    await tester.pumpAndSettle();
    expect(find.text('Housing support'), findsOneWidget);
    expect(find.text('Residence permit'), findsNothing);
  });

  testWidgets('Case search filters compact document rows in its context', (
    tester,
  ) async {
    final matching = _document('matching', caseId: 'case-1');
    final other = _document('other', caseId: 'case-1');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDocumentsProvider.overrideWithValue(
            AsyncValue.data([matching, other]),
          ),
          organizationsProvider.overrideWithValue(const AsyncValue.data([])),
          casesProvider.overrideWithValue(
            AsyncValue.data([_case('case-1', 'org-1', 'Case title')]),
          ),
          ..._documentOverrides(
            matching.clientDocumentId,
            analysis: _analysisFor(
              matching.clientDocumentId,
              'Housing decision',
            ),
          ),
          ..._documentOverrides(
            other.clientDocumentId,
            analysis: _analysisFor(other.clientDocumentId, 'Tax decision'),
          ),
        ],
        child: _app(const CasePage(caseId: 'case-1')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('context-document-search')),
      'Housing',
    );
    await tester.pumpAndSettle();
    expect(find.text('Housing decision'), findsOneWidget);
    expect(find.text('Tax decision'), findsNothing);
  });

  testWidgets('Organization opens Case as a focused nested flow', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/documents/organization/org-1',
      routes: [
        GoRoute(
          path: '/documents/organization/:organizationId',
          builder: (context, state) => OrganizationPage(
            organizationId: state.pathParameters['organizationId']!,
          ),
          routes: [
            GoRoute(
              path: 'case/:caseId',
              builder: (context, state) =>
                  CasePage(caseId: state.pathParameters['caseId']!),
            ),
          ],
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDocumentsProvider.overrideWithValue(const AsyncValue.data([])),
          organizationsProvider.overrideWithValue(
            AsyncValue.data([_organization('org-1', 'Organization')]),
          ),
          casesProvider.overrideWithValue(
            AsyncValue.data([_case('case-1', 'org-1', 'Case title')]),
          ),
        ],
        child: _routerApp(router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('case-folder-case-1')));
    await tester.pumpAndSettle();
    expect(find.byType(CasePage), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('folder layouts remain directional in Arabic RTL', (
    tester,
  ) async {
    final document = _document('arabic-doc');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDocumentsProvider.overrideWithValue(AsyncValue.data([document])),
          organizationsProvider.overrideWithValue(const AsyncValue.data([])),
          casesProvider.overrideWithValue(const AsyncValue.data([])),
          ..._documentOverrides(document.clientDocumentId),
        ],
        child: _app(
          const Directionality(
            textDirection: TextDirection.rtl,
            child: DocumentsPage(),
          ),
          locale: const Locale('ar'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('unclassified-folder')), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(DocumentsPage))),
      TextDirection.rtl,
    );
  });
}

LocalDocument _document(
  String id, {
  String? organizationId,
  String? caseId,
  DocumentStatus status = DocumentStatus.analyzed,
}) => LocalDocument(
  clientDocumentId: id,
  organizationId: organizationId,
  caseId: caseId,
  classificationState: organizationId == null
      ? ClassificationState.unclassified
      : ClassificationState.confirmed,
  status: status,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

Organization _organization(String id, String name) => Organization(
  id: id,
  name: name,
  category: OrganizationCategory.other,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

Case _case(String id, String organizationId, String title) => Case(
  id: id,
  organizationId: organizationId,
  title: title,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

DocumentAnalysis _analysisFor(String documentId, String type) =>
    DocumentAnalysis(
      id: 'analysis-$documentId',
      clientDocumentId: documentId,
      schemaVersion: 'analysis_result.v1',
      targetLanguage: 'de',
      createdAt: DateTime(2026),
      classification: ClassificationSuggestion(documentType: type),
    );

List _documentOverrides(String id, {DocumentAnalysis? analysis}) => [
  latestAnalysisProvider(id).overrideWithValue(AsyncValue.data(analysis)),
  documentFilesProvider(id).overrideWithValue(const AsyncValue.data([])),
];

Widget _app(Widget home, {Locale locale = const Locale('de')}) => MaterialApp(
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

Widget _routerApp(GoRouter router) => MaterialApp.router(
  locale: const Locale('de'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  routerConfig: router,
);
