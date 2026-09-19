import 'package:doxary/app/localization/app_localizations.dart';
import 'package:doxary/app/providers.dart';
import 'package:doxary/features/document_analysis/presentation/document_detail_page.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
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
}

Future<void> _pump(
  WidgetTester tester,
  Locale locale, {
  bool confirmed = true,
}) async {
  final document = LocalDocument(
    clientDocumentId: 'doc',
    organizationId: confirmed ? 'org' : null,
    classificationState: confirmed
        ? ClassificationState.confirmed
        : ClassificationState.suggested,
    status: DocumentStatus.analyzed,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );
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
        organizationsProvider.overrideWithValue(
          AsyncValue.data([
            Organization(
              id: 'org',
              name: 'Techniker Krankenkasse',
              category: OrganizationCategory.healthInsurer,
              createdAt: DateTime(2026),
              updatedAt: DateTime(2026),
            ),
          ]),
        ),
        casesProvider.overrideWithValue(const AsyncValue.data([])),
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
