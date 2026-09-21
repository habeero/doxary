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
    await tester.tap(find.byKey(const Key('organization-selector-housing')));
    await tester.pumpAndSettle();

    expect(find.text('Nicht zugeordnet'), findsWidgets);
    expect(
      find.descendant(
        of: find.byKey(const Key('classification-organization-field')),
        matching: find.text('Wohnungsamt'),
      ),
      findsOneWidget,
    );
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
    await tester.tap(find.byKey(const Key('organization-selector-housing')));
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

  testWidgets('Select Organization is a focused modal with selected state', (
    tester,
  ) async {
    await _pump(tester, const Locale('de'), withCase: true);

    await tester.tap(find.byKey(const Key('classification-change')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('classification-organization-field')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('organization-selector-modal')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('organization-selector-close')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('organization-selector-org')), findsOneWidget);
    expect(
      find.byKey(const Key('organization-selector-selected-org')),
      findsOneWidget,
    );
    expect(find.text('Techniker Krankenkasse'), findsWidgets);
    expect(find.text('org'), findsNothing);
    expect(
      Directionality.of(
        tester.element(find.byKey(const Key('organization-selector-modal'))),
      ),
      TextDirection.ltr,
    );
  });

  testWidgets(
    'Organization selector filters locally with trimmed case-insensitive search',
    (tester) async {
      await _pump(tester, const Locale('de'));
      await tester.tap(find.byKey(const Key('classification-change')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('classification-organization-field')),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('organization-selector-search')),
        '  WOHN  ',
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('organization-selector-housing')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('organization-selector-org')), findsNothing);

      await tester.enterText(
        find.byKey(const Key('organization-selector-search')),
        '',
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('organization-selector-org')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('organization-selector-housing')),
        findsOneWidget,
      );

      await tester.enterText(
        find.byKey(const Key('organization-selector-search')),
        'does-not-exist',
      );
      await tester.pumpAndSettle();
      expect(find.text('Keine passenden Organisationen'), findsOneWidget);
      expect(
        find.byKey(const Key('organization-selector-create')),
        findsOneWidget,
      );
    },
  );

  testWidgets('closing Organization selector preserves the 10A draft', (
    tester,
  ) async {
    final documents = _RecordingDocuments();
    await _pump(tester, const Locale('de'), documentRepository: documents);
    await tester.tap(find.byKey(const Key('classification-change')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('classification-organization-field')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('organization-selector-close')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('classification-editor-modal')),
      findsOneWidget,
    );
    expect(find.text('Techniker Krankenkasse'), findsWidgets);
    expect(documents.classificationUpdates, isEmpty);
  });

  testWidgets('Create Organization opens a nested focused modal', (
    tester,
  ) async {
    await _pump(tester, const Locale('de'));
    await tester.tap(find.byKey(const Key('classification-change')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('classification-organization-field')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('organization-selector-create')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('create-organization-modal')), findsOneWidget);
    expect(find.byKey(const Key('create-organization-name')), findsOneWidget);
    expect(find.byKey(const Key('create-organization-submit')), findsOneWidget);
    final modal = find.byKey(const Key('create-organization-modal'));
    expect(
      find.descendant(
        of: modal,
        matching: find.text('Neue Organisation erstellen'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: modal, matching: find.text('Name der Organisation')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: modal, matching: find.text('Erstellen')),
      findsOneWidget,
    );
  });

  testWidgets('Create Organization rejects blank and whitespace-only names', (
    tester,
  ) async {
    await _pump(tester, const Locale('de'));
    await _openCreateOrganization(tester);
    await tester.tap(find.byKey(const Key('create-organization-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Bitte geben Sie einen Namen ein.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('create-organization-name')),
      '   ',
    );
    await tester.tap(find.byKey(const Key('create-organization-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Bitte geben Sie einen Namen ein.'), findsOneWidget);
  });

  testWidgets(
    'Create Organization trims, saves once, and returns draft selection',
    (tester) async {
      final organizations = _RecordingOrganizations();
      final documents = _RecordingDocuments();
      await _pump(
        tester,
        const Locale('de'),
        documentRepository: documents,
        organizationRepository: organizations,
      );
      await _openCreateOrganization(tester);
      await tester.enterText(
        find.byKey(const Key('create-organization-name')),
        '  Neue Behörde  ',
      );
      await tester.tap(find.byKey(const Key('create-organization-submit')));
      await tester.pumpAndSettle();

      expect(organizations.saved, hasLength(1));
      expect(organizations.saved.single.name, 'Neue Behörde');
      expect(
        find.descendant(
          of: find.byKey(const Key('classification-organization-field')),
          matching: find.text('Neue Behörde'),
        ),
        findsOneWidget,
      );
      expect(documents.classificationUpdates, isEmpty);
    },
  );

  testWidgets('Create Organization reuses normalized duplicate names', (
    tester,
  ) async {
    final organizations = _RecordingOrganizations();
    await _pump(
      tester,
      const Locale('de'),
      organizationRepository: organizations,
    );
    await _openCreateOrganization(tester);
    await tester.enterText(
      find.byKey(const Key('create-organization-name')),
      '  techniker   krankenkasse  ',
    );
    await tester.tap(find.byKey(const Key('create-organization-submit')));
    await tester.pumpAndSettle();

    expect(organizations.saved, isEmpty);
    expect(
      find.descendant(
        of: find.byKey(const Key('classification-organization-field')),
        matching: find.text('Techniker Krankenkasse'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Create Organization close and failure preserve draft input', (
    tester,
  ) async {
    final failingOrganizations = _RecordingOrganizations(fail: true);
    await _pump(
      tester,
      const Locale('de'),
      organizationRepository: failingOrganizations,
    );
    await _openCreateOrganization(tester);
    await tester.enterText(
      find.byKey(const Key('create-organization-name')),
      'Neue Behörde',
    );
    await tester.tap(find.byKey(const Key('create-organization-submit')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('create-organization-modal')), findsOneWidget);
    expect(find.text('Neue Behörde'), findsOneWidget);
    expect(
      find.text('Die Organisation konnte nicht erstellt werden.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('create-organization-close')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('organization-selector-modal')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('organization-selector-close')));
    await tester.pumpAndSettle();
    expect(find.text('Techniker Krankenkasse'), findsWidgets);
    expect(failingOrganizations.saved, isEmpty);
  });

  testWidgets('Create Organization modal inherits Arabic RTL', (tester) async {
    await _pump(tester, const Locale('ar'));
    await _openCreateOrganization(tester);

    expect(
      Directionality.of(
        tester.element(find.byKey(const Key('create-organization-modal'))),
      ),
      TextDirection.rtl,
    );
  });

  testWidgets('Organization selector retains bounded labels in Arabic RTL', (
    tester,
  ) async {
    const name = 'Sehr lange Organisation mit einem aussagekraeftigen Namen';
    await _pump(tester, const Locale('ar'), organizationName: name);
    await tester.tap(find.byKey(const Key('classification-change')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('classification-organization-field')),
    );
    await tester.pumpAndSettle();

    final option = find.byKey(const Key('organization-selector-org'));
    final label = find.descendant(of: option, matching: find.text(name));
    expect(label, findsOneWidget);
    expect(tester.widget<Text>(label).overflow, TextOverflow.ellipsis);
    expect(
      Directionality.of(
        tester.element(find.byKey(const Key('organization-selector-modal'))),
      ),
      TextDirection.rtl,
    );
  });

  testWidgets('Select Case is scoped to the draft Organization', (
    tester,
  ) async {
    await _pump(tester, const Locale('de'), withCase: true);
    await tester.tap(find.byKey(const Key('classification-change')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('classification-case-field')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('case-selector-modal')), findsOneWidget);
    expect(find.text('Techniker Krankenkasse'), findsWidgets);
    expect(find.byKey(const Key('case-selector-case')), findsOneWidget);
    expect(find.byKey(const Key('case-selector-rent')), findsOneWidget);
    expect(find.byKey(const Key('case-selector-foreign')), findsNothing);
    expect(find.byKey(const Key('case-selector-no-case')), findsOneWidget);
    expect(find.text('case'), findsNothing);
    expect(
      find.byKey(const Key('case-selector-selected-case')),
      findsOneWidget,
    );
    expect(
      Directionality.of(
        tester.element(find.byKey(const Key('case-selector-modal'))),
      ),
      TextDirection.ltr,
    );
  });

  testWidgets('No Case changes only the 10A draft until Save', (tester) async {
    final documents = _RecordingDocuments();
    await _pump(
      tester,
      const Locale('de'),
      withCase: true,
      documentRepository: documents,
    );
    await tester.tap(find.byKey(const Key('classification-change')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('classification-case-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('case-selector-no-case')));
    await tester.pumpAndSettle();

    expect(find.text('Techniker Krankenkasse'), findsWidgets);
    expect(find.text('Nicht zugeordnet'), findsWidgets);
    expect(documents.classificationUpdates, isEmpty);
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

  testWidgets('Case selector filters locally and keeps No Case reachable', (
    tester,
  ) async {
    await _pump(tester, const Locale('de'), withCase: true);
    await tester.tap(find.byKey(const Key('classification-change')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('classification-case-field')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('case-selector-search')),
      '  MIET  ',
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('case-selector-rent')), findsOneWidget);
    expect(find.byKey(const Key('case-selector-case')), findsNothing);

    await tester.enterText(find.byKey(const Key('case-selector-search')), '');
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('case-selector-case')), findsOneWidget);
    expect(find.byKey(const Key('case-selector-rent')), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('case-selector-search')),
      'does-not-exist',
    );
    await tester.pumpAndSettle();
    expect(find.text('Keine passenden Vorgänge'), findsOneWidget);
    expect(find.byKey(const Key('case-selector-no-case')), findsOneWidget);
    expect(find.byKey(const Key('case-selector-create')), findsOneWidget);
  });

  testWidgets('Case choice returns to the 10A draft without persistence', (
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
    await tester.tap(find.byKey(const Key('classification-case-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('case-selector-rent')));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const Key('classification-case-field')),
        matching: find.text('Mietvertrag'),
      ),
      findsOneWidget,
    );
    expect(documents.classificationUpdates, isEmpty);
  });

  testWidgets('closing Case selector preserves the existing draft context', (
    tester,
  ) async {
    await _pump(tester, const Locale('de'), withCase: true);
    await tester.tap(find.byKey(const Key('classification-change')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('classification-case-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('case-selector-close')));
    await tester.pumpAndSettle();
    expect(find.text('Nebenkosten 2025'), findsWidgets);
  });

  testWidgets('Create Case opens a nested Organization-scoped modal', (
    tester,
  ) async {
    await _pump(tester, const Locale('de'), withCase: true);
    await _openCreateCase(tester);

    final modal = find.byKey(const Key('create-case-modal'));
    expect(modal, findsOneWidget);
    expect(find.byKey(const Key('create-case-name')), findsOneWidget);
    expect(find.byKey(const Key('create-case-submit')), findsOneWidget);
    expect(
      find.descendant(
        of: modal,
        matching: find.text('Neuen Vorgang erstellen'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: modal, matching: find.text('Techniker Krankenkasse')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: modal, matching: find.text('Name des Vorgangs')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: modal, matching: find.text('Erstellen')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: modal,
        matching: find.byKey(const Key('classification-organization-field')),
      ),
      findsNothing,
    );
    expect(find.text('org'), findsNothing);
  });

  testWidgets('Create Case rejects blank and whitespace-only titles', (
    tester,
  ) async {
    await _pump(tester, const Locale('de'), withCase: true);
    await _openCreateCase(tester);
    await tester.tap(find.byKey(const Key('create-case-submit')));
    await tester.pumpAndSettle();
    expect(
      find.text('Bitte geben Sie einen Vorgangsnamen ein.'),
      findsOneWidget,
    );

    await tester.enterText(find.byKey(const Key('create-case-name')), '   ');
    await tester.tap(find.byKey(const Key('create-case-submit')));
    await tester.pumpAndSettle();
    expect(
      find.text('Bitte geben Sie einen Vorgangsnamen ein.'),
      findsOneWidget,
    );
  });

  testWidgets('Create Case trims, saves once, and returns draft selection', (
    tester,
  ) async {
    final cases = _RecordingCases();
    final documents = _RecordingDocuments();
    await _pump(
      tester,
      const Locale('de'),
      withCase: true,
      documentRepository: documents,
      caseRepository: cases,
    );
    await _openCreateCase(tester);
    await tester.enterText(
      find.byKey(const Key('create-case-name')),
      '  Neuer Vorgang  ',
    );
    await tester.tap(find.byKey(const Key('create-case-submit')));
    await tester.pumpAndSettle();

    expect(cases.saved, hasLength(1));
    expect(cases.saved.single.title, 'Neuer Vorgang');
    expect(cases.saved.single.organizationId, 'org');
    expect(
      find.descendant(
        of: find.byKey(const Key('classification-case-field')),
        matching: find.text('Neuer Vorgang'),
      ),
      findsOneWidget,
    );
    expect(documents.classificationUpdates, isEmpty);
  });

  testWidgets('Create Case reuses only a same-Organization normalized match', (
    tester,
  ) async {
    final cases = _RecordingCases();
    await _pump(
      tester,
      const Locale('de'),
      withCase: true,
      caseRepository: cases,
    );
    await _openCreateCase(tester);
    await tester.enterText(
      find.byKey(const Key('create-case-name')),
      '  mietvertrag  ',
    );
    await tester.tap(find.byKey(const Key('create-case-submit')));
    await tester.pumpAndSettle();
    expect(cases.saved, isEmpty);
    expect(
      find.descendant(
        of: find.byKey(const Key('classification-case-field')),
        matching: find.text('Mietvertrag'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Create Case permits a title used by another Organization', (
    tester,
  ) async {
    final cases = _RecordingCases();
    await _pump(
      tester,
      const Locale('de'),
      withCase: true,
      foreignCaseTitle: 'Anderer Vorgang',
      caseRepository: cases,
    );
    await _openCreateCase(tester);
    await tester.enterText(
      find.byKey(const Key('create-case-name')),
      'Anderer Vorgang',
    );
    await tester.tap(find.byKey(const Key('create-case-submit')));
    await tester.pumpAndSettle();
    expect(cases.saved, hasLength(1));
    expect(cases.saved.single.organizationId, 'org');
  });

  testWidgets('Create Case failure and Close preserve the draft', (
    tester,
  ) async {
    final failingCases = _RecordingCases(fail: true);
    await _pump(
      tester,
      const Locale('de'),
      withCase: true,
      caseRepository: failingCases,
    );
    await _openCreateCase(tester);
    await tester.enterText(
      find.byKey(const Key('create-case-name')),
      'Neuer Vorgang',
    );
    await tester.tap(find.byKey(const Key('create-case-submit')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('create-case-modal')), findsOneWidget);
    expect(find.text('Neuer Vorgang'), findsOneWidget);
    expect(
      find.text('Der Vorgang konnte nicht erstellt werden.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('create-case-close')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('case-selector-modal')), findsOneWidget);
    await tester.tap(find.byKey(const Key('case-selector-close')));
    await tester.pumpAndSettle();
    expect(find.text('Nebenkosten 2025'), findsWidgets);
    expect(failingCases.saved, isEmpty);
  });

  testWidgets('Case selector bounds long labels in Arabic RTL', (tester) async {
    const title = 'Sehr langer Vorgang mit einem aussagekraeftigen Namen';
    await _pump(tester, const Locale('ar'), withCase: true, caseTitle: title);
    await tester.tap(find.byKey(const Key('classification-change')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('classification-case-field')));
    await tester.pumpAndSettle();

    final option = find.byKey(const Key('case-selector-case'));
    final label = find.descendant(of: option, matching: find.text(title));
    expect(label, findsOneWidget);
    expect(tester.widget<Text>(label).overflow, TextOverflow.ellipsis);
    expect(
      Directionality.of(
        tester.element(find.byKey(const Key('case-selector-modal'))),
      ),
      TextDirection.rtl,
    );
  });

  testWidgets('Create Case bounds inherited context in Arabic RTL', (
    tester,
  ) async {
    const name = 'Sehr lange Organisation mit einem aussagekraeftigen Namen';
    await _pump(
      tester,
      const Locale('ar'),
      withCase: true,
      organizationName: name,
    );
    await _openCreateCase(tester);

    final context = find.byKey(const Key('create-case-organization-context'));
    expect(context, findsOneWidget);
    expect(tester.widget<Text>(context).overflow, TextOverflow.ellipsis);
    expect(
      Directionality.of(
        tester.element(find.byKey(const Key('create-case-modal'))),
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
  String caseTitle = 'Nebenkosten 2025',
  String foreignCaseTitle = 'Fremder Vorgang',
  DocumentRepository? documentRepository,
  OrganizationRepository? organizationRepository,
  CaseRepository? caseRepository,
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
            title: caseTitle,
            createdAt: DateTime(2026),
            updatedAt: DateTime(2026),
          ),
          Case(
            id: 'rent',
            organizationId: 'org',
            title: 'Mietvertrag',
            createdAt: DateTime(2026),
            updatedAt: DateTime(2026),
          ),
          Case(
            id: 'foreign',
            organizationId: 'housing',
            title: foreignCaseTitle,
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
          organizationRepository ?? _MemoryOrganizations(),
        ),
        caseRepositoryProvider.overrideWithValue(
          caseRepository ?? _MemoryCases(),
        ),
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

Future<void> _openCreateOrganization(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('classification-change')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('classification-organization-field')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('organization-selector-create')));
  await tester.pumpAndSettle();
}

Future<void> _openCreateCase(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('classification-change')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('classification-case-field')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('case-selector-create')));
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

class _RecordingOrganizations implements OrganizationRepository {
  _RecordingOrganizations({this.fail = false});

  final bool fail;
  final saved = <Organization>[];

  @override
  Future<void> save(Organization organization) async {
    if (fail) throw StateError('save failed');
    saved.add(organization);
  }

  @override
  Stream<List<Organization>> watchAll() => Stream.value(saved);
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

class _RecordingCases implements CaseRepository {
  _RecordingCases({this.fail = false});

  final bool fail;
  final saved = <Case>[];

  @override
  Future<void> save(Case item) async {
    if (fail) throw StateError('save failed');
    saved.add(item);
  }

  @override
  Stream<List<Case>> watchAll() => Stream.value(saved);

  @override
  Stream<List<Case>> watchForOrganization(String organizationId) =>
      Stream.value(
        saved.where((item) => item.organizationId == organizationId).toList(),
      );
}
