import 'package:doxary/app/localization/app_localizations.dart';
import 'package:doxary/app/providers.dart';
import 'package:doxary/features/cases/domain/repositories/case_repository.dart';
import 'package:doxary/features/document_analysis/presentation/document_detail_page.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:doxary/features/documents/domain/repositories/document_repository.dart';
import 'package:doxary/features/organizations/domain/repositories/organization_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('confirmed organization replaces the stale suggestion UI', (
    tester,
  ) async {
    await _pump(tester, const Locale('de'));

    expect(find.text('Organisation: Techniker Krankenkasse'), findsOneWidget);
    expect(find.text('Vorgang: Nicht zugeordnet'), findsOneWidget);
    expect(find.text('Vorgeschlagene Zuordnung'), findsNothing);
    expect(find.text('BestÃ¤tigen'), findsNothing);
    expect(find.text('Zuordnung bearbeiten'), findsOneWidget);
  });

  testWidgets(
    'Arabic uses the distinct case term and not ambiguous file term',
    (tester) async {
      await _pump(tester, const Locale('ar'));

      final l10n = AppLocalizations(const Locale('ar'));
      expect(l10n.caseLabel, isNot('\u0627\u0644\u0645\u0644\u0641'));
      expect(find.textContaining(l10n.caseLabel), findsWidgets);
      expect(find.textContaining(l10n.caseNotAssigned), findsOneWidget);
    },
  );

  testWidgets('suggested classification actions stay visually secondary', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pump(tester, const Locale('de'), confirmed: false);

    final confirm = find.byKey(const Key('classification-confirm'));
    final change = find.byKey(const Key('classification-change'));
    expect(confirm, findsOneWidget);
    expect(change, findsOneWidget);
    expect(tester.getSize(confirm).width, lessThan(216));
    expect(tester.widget<TextButton>(change), isA<TextButton>());
  });

  testWidgets('Change Classification is a bounded modal with display labels', (
    tester,
  ) async {
    await _pump(tester, const Locale('de'), withCase: true);

    await tester.tap(find.byKey(const Key('classification-change')));
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsOneWidget);
    expect(
      find.byKey(const Key('classification-editor-modal')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('classification-editor-close')),
      findsOneWidget,
    );
    expect(find.text('Techniker Krankenkasse'), findsWidgets);
    expect(find.text('Nebenkosten 2025'), findsWidgets);
    expect(find.text('org'), findsNothing);
    expect(find.text('case'), findsNothing);
  });

  testWidgets('Organization changes remain draft-only until Save', (
    tester,
  ) async {
    final documents = _RecordingDocuments();
    await _pump(
      tester,
      const Locale('de'),
      withCase: true,
      documentRepository: documents,
    );

    await tester.tap(find.byKey(const Key('classification-change')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('classification-organization-field')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wohnungsamt').last);
    await tester.pumpAndSettle();

    expect(find.text('Nicht zugeordnet'), findsWidgets);
    await tester.tap(find.byKey(const Key('classification-editor-close')));
    await tester.pumpAndSettle();
    expect(documents.classificationUpdates, isEmpty);
  });

  testWidgets('Save commits draft Organization and clears incompatible Case', (
    tester,
  ) async {
    final documents = _RecordingDocuments();
    await _pump(
      tester,
      const Locale('de'),
      withCase: true,
      documentRepository: documents,
    );

    await tester.tap(find.byKey(const Key('classification-change')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('classification-organization-field')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wohnungsamt').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('classification-editor-save')));
    await tester.pumpAndSettle();

    expect(
      documents.classificationUpdates.single,
      const _ClassificationUpdate(
        organizationId: 'housing',
        caseId: null,
        state: ClassificationState.confirmed,
      ),
    );
  });

  testWidgets('Remove Case keeps the Organization until Save', (tester) async {
    final documents = _RecordingDocuments();
    await _pump(
      tester,
      const Locale('de'),
      withCase: true,
      documentRepository: documents,
    );

    await tester.tap(find.byKey(const Key('classification-change')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('classification-remove-case')));
    await tester.tap(find.byKey(const Key('classification-editor-save')));
    await tester.pumpAndSettle();

    expect(
      documents.classificationUpdates.single,
      const _ClassificationUpdate(
        organizationId: 'org',
        caseId: null,
        state: ClassificationState.confirmed,
      ),
    );
  });

  testWidgets('Clear Classification preserves the Document record', (
    tester,
  ) async {
    final documents = _RecordingDocuments();
    await _pump(
      tester,
      const Locale('de'),
      withCase: true,
      documentRepository: documents,
    );

    await tester.tap(find.byKey(const Key('classification-change')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('classification-clear')));
    await tester.tap(find.byKey(const Key('classification-editor-save')));
    await tester.pumpAndSettle();

    expect(
      documents.classificationUpdates.single,
      const _ClassificationUpdate(
        organizationId: null,
        caseId: null,
        state: ClassificationState.unclassified,
      ),
    );
    expect(await documents.getById('doc'), isNotNull);
  });

  testWidgets('long labels remain bounded in RTL classification fields', (
    tester,
  ) async {
    const name = 'Sehr lange Organisation mit einem aussagekraeftigen Namen';
    await _pump(
      tester,
      const Locale('ar'),
      organizationName: name,
      withCase: true,
    );

    await tester.tap(find.byKey(const Key('classification-change')));
    await tester.pumpAndSettle();

    final field = find.byKey(const Key('classification-organization-field'));
    final label = find.descendant(of: field, matching: find.text(name));
    expect(label, findsWidgets);
    expect(
      tester
          .widgetList<Text>(label)
          .any(
            (item) =>
                item.maxLines == 1 && item.overflow == TextOverflow.ellipsis,
          ),
      isTrue,
    );
    expect(
      Directionality.of(
        tester.element(find.byKey(const Key('classification-editor-modal'))),
      ),
      TextDirection.rtl,
    );
  });
}

Future<void> _pump(
  WidgetTester tester,
  Locale locale, {
  bool confirmed = true,
  bool withCase = false,
  String organizationName = 'Techniker Krankenkasse',
  DocumentRepository? documentRepository,
}) async {
  final document = LocalDocument(
    clientDocumentId: 'doc',
    organizationId: confirmed ? 'org' : null,
    caseId: withCase ? 'case' : null,
    classificationState: confirmed
        ? ClassificationState.confirmed
        : ClassificationState.suggested,
    status: DocumentStatus.analyzed,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );
  final organizations = [
    Organization(
      id: 'org',
      name: organizationName,
      category: OrganizationCategory.healthInsurer,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    ),
    Organization(
      id: 'housing',
      name: 'Wohnungsamt',
      category: OrganizationCategory.other,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    ),
  ];
  final cases = withCase
      ? [
          Case(
            id: 'case',
            organizationId: 'org',
            title: 'Nebenkosten 2025',
            createdAt: DateTime(2026),
            updatedAt: DateTime(2026),
          ),
        ]
      : const <Case>[];
  final analysis = DocumentAnalysis(
    id: 'analysis',
    clientDocumentId: 'doc',
    schemaVersion: 'analysis_result.v1',
    targetLanguage: 'de',
    createdAt: DateTime(2026),
    classification: const ClassificationSuggestion(
      organizationName: 'Techniker Krankenkasse',
      documentType: 'Bescheid',
    ),
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        documentProvider('doc').overrideWithValue(AsyncValue.data(document)),
        documentFilesProvider('doc')
            .overrideWithValue(const AsyncValue.data([])),
        latestAnalysisProvider('doc')
            .overrideWithValue(AsyncValue.data(analysis)),
        analysisHistoryProvider('doc')
            .overrideWithValue(const AsyncValue.data([])),
        organizationsProvider.overrideWithValue(AsyncValue.data(organizations)),
        casesProvider.overrideWithValue(AsyncValue.data(cases)),
        if (documentRepository != null)
          documentRepositoryProvider.overrideWithValue(documentRepository),
        organizationRepositoryProvider.overrideWithValue(
          _MemoryOrganizations(),
        ),
        caseRepositoryProvider.overrideWithValue(_MemoryCases()),
      ],
      child: MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const DocumentDetailPage(clientDocumentId: 'doc'),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _ClassificationUpdate {
  const _ClassificationUpdate({
    required this.organizationId,
    required this.caseId,
    required this.state,
  });

  final String? organizationId;
  final String? caseId;
  final ClassificationState state;

  @override
  bool operator ==(Object other) =>
      other is _ClassificationUpdate &&
      other.organizationId == organizationId &&
      other.caseId == caseId &&
      other.state == state;

  @override
  int get hashCode => Object.hash(organizationId, caseId, state);
}

class _RecordingDocuments implements DocumentRepository {
  final classificationUpdates = <_ClassificationUpdate>[];
  final _document = LocalDocument(
    clientDocumentId: 'doc',
    classificationState: ClassificationState.confirmed,
    status: DocumentStatus.analyzed,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  @override
  Future<LocalDocument?> getById(String clientDocumentId) async => _document;

  @override
  Future<List<DocumentFile>> getFiles(String clientDocumentId) async => [];

  @override
  Future<void> saveImportedDocument(
    LocalDocument document,
    DocumentFile file,
  ) async {}

  @override
  Future<void> updateClassification(
    String clientDocumentId, {
    String? organizationId,
    String? caseId,
    required ClassificationState state,
  }) async {
    classificationUpdates.add(
      _ClassificationUpdate(
        organizationId: organizationId,
        caseId: caseId,
        state: state,
      ),
    );
  }

  @override
  Stream<List<LocalDocument>> watchAll() => Stream.value([_document]);

  @override
  Stream<List<LocalDocument>> watchRecent({int limit = 5}) =>
      Stream.value([_document]);
}

class _MemoryOrganizations implements OrganizationRepository {
  @override
  Future<void> save(Organization organization) async {}

  @override
  Stream<List<Organization>> watchAll() => Stream.value([]);
}

class _MemoryCases implements CaseRepository {
  @override
  Future<void> save(Case item) async {}

  @override
  Stream<List<Case>> watchAll() => Stream.value([]);

  @override
  Stream<List<Case>> watchForOrganization(String organizationId) =>
      Stream.value([]);
}
