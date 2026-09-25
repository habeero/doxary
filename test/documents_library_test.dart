import 'dart:async';

import 'package:doxary/app/localization/app_localizations.dart';
import 'package:doxary/app/providers.dart';
import 'package:doxary/app/theme/app_theme.dart';
import 'package:doxary/features/cases/presentation/case_page.dart';
import 'package:doxary/features/document_analysis/domain/analysis_repository.dart';
import 'package:doxary/features/document_analysis/domain/analysis_submission.dart';
import 'package:doxary/features/document_analysis/application/document_attention.dart';
import 'package:doxary/features/document_analysis/presentation/document_detail_page.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:doxary/features/documents/presentation/documents_page.dart';
import 'package:doxary/features/home/presentation/home_page.dart';
import 'package:doxary/features/organizations/presentation/organization_page.dart';
import 'package:doxary/features/settings/domain/settings_repository.dart';
import 'package:doxary/shared/design_system/app_widgets.dart';
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
          completedTasksProvider.overrideWithValue(const AsyncValue.data([])),
          settingsRepositoryProvider.overrideWithValue(_MemorySettings()),
          _browseStatesOverride({
            for (final document in documents)
              document.clientDocumentId: _browseState(usable: true),
          }),
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

  testWidgets('Home surfaces follow Light and Dark theme semantics', (
    tester,
  ) async {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      await _pumpThemedHome(tester, themeMode: mode);

      final home = find.byType(HomePage);
      final theme = Theme.of(tester.element(home));
      final colors = theme.colorScheme;
      final rootSurface = find
          .descendant(of: home, matching: find.byType(Material))
          .first;
      expect(
        tester.widget<Material>(rootSurface).color,
        theme.scaffoldBackgroundColor,
      );

      final action = find.byKey(const Key('home-action-required-theme-action'));
      final actionSurface = find
          .descendant(of: action, matching: find.byType(Material))
          .first;
      expect(
        tester.widget<Material>(actionSurface).color,
        colors.primaryContainer,
      );
      final actionTitle = find
          .descendant(of: action, matching: find.byType(Text))
          .first;
      expect(
        tester.widget<Text>(actionTitle).style?.color,
        colors.onPrimaryContainer,
      );

      final attention = find.byKey(const Key('home-needs-attention'));
      final attentionSurface = find
          .ancestor(of: attention, matching: find.byType(Material))
          .first;
      expect(
        tester.widget<Material>(attentionSurface).color,
        colors.errorContainer,
      );
      final attentionTile = tester.widget<ListTile>(attention);
      expect(attentionTile.textColor, colors.onErrorContainer);
      expect(attentionTile.iconColor, colors.onErrorContainer);

      final processing = find.byKey(
        const Key('home-processing-document-theme-processing'),
      );
      final processingSurface = find
          .descendant(of: processing, matching: find.byType(Material))
          .first;
      expect(tester.widget<Material>(processingSurface).color, colors.surface);
      expect(
        tester
            .widget<CircularProgressIndicator>(
              find.descendant(
                of: processing,
                matching: find.byType(CircularProgressIndicator),
              ),
            )
            .color,
        colors.primary,
      );
      final processingTitle = find
          .descendant(of: processing, matching: find.byType(Text))
          .first;
      expect(
        tester.widget<Text>(processingTitle).style?.color,
        colors.onSurface,
      );

      final recent = find.byKey(
        const Key('home-recent-document-theme-recent-1'),
      );
      final recentTitle = find
          .descendant(of: recent, matching: find.byType(Text))
          .first;
      expect(tester.widget<Text>(recentTitle).style?.color, colors.onSurface);
      final recentIcon = find
          .descendant(of: recent, matching: find.byType(Icon))
          .first;
      expect(tester.widget<Icon>(recentIcon).color, colors.onSurfaceVariant);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Home preserves RTL/LTR and fits narrow widths', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(280, 820);
    tester.view.devicePixelRatio = 1;

    for (final locale in [const Locale('de'), const Locale('ar')]) {
      await _pumpThemedHome(tester, themeMode: ThemeMode.dark, locale: locale);
      expect(
        Directionality.of(tester.element(find.byType(HomePage))),
        locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      );
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Home empty, loading, and error states use the Dark theme', (
    tester,
  ) async {
    final states =
        <
          ({
            AsyncValue<List<LocalDocument>> documents,
            String? expectedMessage,
            bool expectEmpty,
            bool expectLoading,
          })
        >[
          (
            documents: const AsyncValue<List<LocalDocument>>.loading(),
            expectedMessage: null,
            expectEmpty: false,
            expectLoading: true,
          ),
          (
            documents: AsyncValue.error(
              StateError('private'),
              StackTrace.current,
            ),
            expectedMessage: AppLocalizations(const Locale('de'))
                .localDataUnavailable,
            expectEmpty: false,
            expectLoading: false,
          ),
          (
            documents: const AsyncValue<List<LocalDocument>>.data([]),
            expectedMessage: null,
            expectEmpty: true,
            expectLoading: false,
          ),
        ];

    for (final state in states) {
      await tester.pumpWidget(
        ProviderScope(
          key: UniqueKey(),
          overrides: [
            homeDocumentsProvider.overrideWithValue(state.documents),
            activeAnalysisOperationsProvider.overrideWithValue(
              const AsyncValue.data([]),
            ),
            openTasksProvider.overrideWithValue(const AsyncValue.data([])),
            completedTasksProvider.overrideWithValue(const AsyncValue.data([])),
            settingsRepositoryProvider.overrideWithValue(_MemorySettings()),
            _browseStatesOverride({}),
          ],
          child: _app(
            const Scaffold(body: HomePage()),
            themeMode: ThemeMode.dark,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      final theme = Theme.of(tester.element(find.byType(HomePage)));
      final rootSurface = find
          .descendant(
            of: find.byType(HomePage),
            matching: find.byType(Material),
          )
          .first;
      expect(
        tester.widget<Material>(rootSurface).color,
        theme.scaffoldBackgroundColor,
      );
      if (state.expectLoading) {
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      }
      final message = state.expectedMessage;
      if (message != null) expect(find.text(message), findsOneWidget);
      if (state.expectEmpty) expect(find.byType(AppEmptyState), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
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
            completedTasksProvider.overrideWithValue(const AsyncValue.data([])),
            settingsRepositoryProvider.overrideWithValue(_MemorySettings()),
            _browseStatesOverride({'stale-processing': _browseState()}),
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
          completedTasksProvider.overrideWithValue(const AsyncValue.data([])),
          settingsRepositoryProvider.overrideWithValue(_MemorySettings()),
          _browseStatesOverride({
            'active-processing': _browseState(processing: true),
          }),
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

  testWidgets('Home separates Needs Attention from normal Recent Documents', (
    tester,
  ) async {
    final failed = _document('failed-home', status: DocumentStatus.needsReview);
    final usable = _document('usable-home');
    final settings = _MemorySettings();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeDocumentsProvider.overrideWithValue(
            AsyncValue.data([failed, usable]),
          ),
          allDocumentsProvider.overrideWithValue(
            AsyncValue.data([failed, usable]),
          ),
          activeAnalysisOperationsProvider.overrideWithValue(
            const AsyncValue.data([]),
          ),
          openTasksProvider.overrideWithValue(const AsyncValue.data([])),
          completedTasksProvider.overrideWithValue(const AsyncValue.data([])),
          settingsRepositoryProvider.overrideWithValue(settings),
          organizationsProvider.overrideWithValue(const AsyncValue.data([])),
          casesProvider.overrideWithValue(const AsyncValue.data([])),
          documentProvider('failed-home')
              .overrideWithValue(AsyncValue.data(failed)),
          analysisHistoryProvider('failed-home')
              .overrideWithValue(const AsyncValue.data([])),
          _browseStatesOverride({
            'failed-home': _browseState(
              reason: DocumentAttentionReason.failed,
              at: DateTime(2026, 9, 20, 10),
            ),
            'usable-home': _browseState(usable: true),
          }),
          ..._documentOverrides(
            'failed-home',
            analysis: DocumentAnalysis(
              id: 'unavailable-failed-home',
              clientDocumentId: 'failed-home',
              schemaVersion: 'analysis_result.v1',
              targetLanguage: 'de',
              createdAt: DateTime(2026, 9, 19),
              analysisStatus: AnalysisStatus.unavailable,
              actionRequired: ActionRequirement.yes,
            ),
          ),
          ..._documentOverrides(
            'usable-home',
            analysis: _analysisFor('usable-home', 'Usable letter'),
          ),
        ],
        child: _app(Scaffold(body: HomePage())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1 Dokument benötigt Aufmerksamkeit'), findsOneWidget);
    expect(
      find.byKey(const Key('home-recent-document-failed-home')),
      findsNothing,
    );
    expect(
      find.byKey(const Key('home-action-dismiss-failed-home')),
      findsNothing,
    );
    expect(
      find.byKey(const Key('home-recent-document-usable-home')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('home-needs-attention')));
    await _pumpNavigationTransition(tester);
    expect(
      settings.values['home_needs_attention_acknowledged_at_ms'],
      DateTime(2026, 9, 20, 10).millisecondsSinceEpoch.toString(),
    );
    expect(find.byType(NeedsAttentionDocumentsPage), findsOneWidget);
    expect(
      find.byKey(const Key('needs-attention-document-failed-home')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('needs-attention-document-usable-home')),
      findsNothing,
    );

    await tester.tap(
      find.byKey(const Key('needs-attention-document-failed-home')),
    );
    await _pumpNavigationTransition(tester);
    expect(find.byType(DocumentDetailPage), findsOneWidget);
    Navigator.of(tester.element(find.byType(DocumentDetailPage))).pop();
    await _pumpNavigationTransition(tester);
    Navigator.of(tester.element(find.byType(NeedsAttentionDocumentsPage)))
        .pop();
    await _pumpNavigationTransition(tester);
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byKey(const Key('home-needs-attention')), findsNothing);
  });

  testWidgets(
    'Home dismiss acknowledges only its alert and survives provider recreation',
    (tester) async {
      final first = _document('attention-failed');
      final second = _document('attention-deleted');
      final settings = _MemorySettings();
      final states = {
        'attention-failed': _browseState(
          reason: DocumentAttentionReason.failed,
          at: DateTime(2026, 9, 20, 10),
        ),
        'attention-deleted': _browseState(
          reason: DocumentAttentionReason.deleted,
          at: DateTime(2026, 9, 20, 10, 5),
        ),
      };
      var container = _attentionHomeContainer(
        settings: settings,
        documents: [first, second],
        states: states,
      );
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        container.dispose();
      });

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: _app(Scaffold(body: HomePage())),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text(
          AppLocalizations(const Locale('de')).documentsNeedAttention(2),
        ),
        findsOneWidget,
      );
      final dismissButton = tester.widget<IconButton>(
        find.byKey(const Key('home-needs-attention-dismiss')),
      );
      expect(dismissButton.tooltip, 'Ausblenden');
      expect(
        Directionality.of(
          tester.element(find.byKey(const Key('home-needs-attention'))),
        ),
        TextDirection.ltr,
      );

      await tester.tap(find.byKey(const Key('home-needs-attention-dismiss')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('home-needs-attention')), findsNothing);
      expect(find.byType(NeedsAttentionDocumentsPage), findsNothing);
      expect(
        settings.values['home_needs_attention_acknowledged_at_ms'],
        DateTime(2026, 9, 20, 10, 5).millisecondsSinceEpoch.toString(),
      );
      expect(
        container.read(documentAnalysisBrowseStatesProvider).value?.length,
        2,
      );

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      container.dispose();
      container = _attentionHomeContainer(
        settings: settings,
        documents: [first, second],
        states: states,
      );
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: _app(Scaffold(body: HomePage())),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home-needs-attention')), findsNothing);
      expect(
        container.read(documentAnalysisBrowseStatesProvider).value?.length,
        2,
      );
    },
  );

  testWidgets(
    'Home attention returns only for a newer event and keeps the total count',
    (tester) async {
      final first = _document('attention-first');
      final second = _document('attention-second');
      final settings = _MemorySettings();
      final events =
          StreamController<Map<String, DocumentAnalysisBrowseState>>();
      final container = ProviderContainer(
        overrides: [
          homeDocumentsProvider.overrideWithValue(
            AsyncValue.data([first, second]),
          ),
          activeAnalysisOperationsProvider.overrideWithValue(
            const AsyncValue.data([]),
          ),
          openTasksProvider.overrideWithValue(const AsyncValue.data([])),
          completedTasksProvider.overrideWithValue(const AsyncValue.data([])),
          settingsRepositoryProvider.overrideWithValue(settings),
          documentAnalysisBrowseStatesProvider.overrideWith(
            (ref) => events.stream,
          ),
          ..._documentOverrides(first.clientDocumentId),
          ..._documentOverrides(second.clientDocumentId),
        ],
      );
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        container.dispose();
        await events.close();
      });

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: _app(Scaffold(body: HomePage())),
        ),
      );
      events.add({
        'attention-first': _browseState(
          reason: DocumentAttentionReason.failed,
          at: DateTime(2026, 9, 20, 10),
        ),
        'attention-second': _browseState(
          reason: DocumentAttentionReason.deleted,
          at: DateTime(2026, 9, 20, 10, 5),
        ),
      });
      await tester.pump();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('home-needs-attention-dismiss')));
      await tester.pumpAndSettle();

      events.add({
        'attention-first': _browseState(usable: true),
        'attention-second': _browseState(
          reason: DocumentAttentionReason.deleted,
          at: DateTime(2026, 9, 20, 10, 5),
        ),
      });
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('home-needs-attention')), findsNothing);

      events.add({
        'attention-first': _browseState(
          reason: DocumentAttentionReason.failed,
          at: DateTime(2026, 9, 20, 11),
        ),
        'attention-second': _browseState(
          reason: DocumentAttentionReason.deleted,
          at: DateTime(2026, 9, 20, 10, 5),
        ),
      });
      await tester.pump();
      await tester.pumpAndSettle();
      expect(
        find.text(
          AppLocalizations(const Locale('de')).documentsNeedAttention(2),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('home-needs-attention-dismiss')));
      await tester.pumpAndSettle();
      events.add({
        'attention-first': _browseState(
          reason: DocumentAttentionReason.failed,
          at: DateTime(2026, 9, 20, 11),
        ),
        'attention-second': _browseState(
          reason: DocumentAttentionReason.deleted,
          at: DateTime(2026, 9, 20, 12),
        ),
      });
      await tester.pump();
      await tester.pumpAndSettle();
      expect(
        find.text(
          AppLocalizations(const Locale('de')).documentsNeedAttention(2),
        ),
        findsOneWidget,
      );

      events.add({
        'attention-first': _browseState(usable: true),
        'attention-second': _browseState(usable: true),
      });
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('home-needs-attention')), findsNothing);
    },
  );

  testWidgets('Home attention dismiss label is localized in Arabic RTL', (
    tester,
  ) async {
    final document = _document('arabic-attention');
    final container = _attentionHomeContainer(
      settings: _MemorySettings(),
      documents: [document],
      states: {
        document.clientDocumentId: _browseState(
          reason: DocumentAttentionReason.failed,
          at: DateTime(2026, 9, 20),
        ),
      },
    );
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
    });

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: _app(Scaffold(body: HomePage()), locale: const Locale('ar')),
      ),
    );
    await tester.pumpAndSettle();

    final dismissButton = tester.widget<IconButton>(
      find.byKey(const Key('home-needs-attention-dismiss')),
    );
    expect(dismissButton.tooltip, AppLocalizations(const Locale('ar')).dismiss);
    expect(
      Directionality.of(
        tester.element(find.byKey(const Key('home-needs-attention'))),
      ),
      TextDirection.rtl,
    );
  });

  testWidgets('Home hides the Needs Attention affordance when count is zero', (
    tester,
  ) async {
    final document = _document('ordinary-home');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeDocumentsProvider.overrideWithValue(AsyncValue.data([document])),
          activeAnalysisOperationsProvider.overrideWithValue(
            const AsyncValue.data([]),
          ),
          openTasksProvider.overrideWithValue(const AsyncValue.data([])),
          completedTasksProvider.overrideWithValue(const AsyncValue.data([])),
          settingsRepositoryProvider.overrideWithValue(_MemorySettings()),
          _browseStatesOverride({'ordinary-home': _browseState(usable: true)}),
          ..._documentOverrides('ordinary-home'),
        ],
        child: _app(Scaffold(body: HomePage())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-needs-attention')), findsNothing);
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
            _browseStatesOverride({
              document.clientDocumentId: _browseState(usable: true),
            }),
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
          _browseStatesOverride({'unclassified': _browseState(usable: true)}),
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
          _browseStatesOverride({'unclassified': _browseState(usable: true)}),
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

  testWidgets('Unclassified excludes failed-only Documents', (tester) async {
    final failed = _document(
      'failed-unclassified',
      status: DocumentStatus.needsReview,
    );
    final deleted = _document(
      'deleted-unclassified',
      status: DocumentStatus.needsReview,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDocumentsProvider.overrideWithValue(
            AsyncValue.data([failed, deleted]),
          ),
          organizationsProvider.overrideWithValue(const AsyncValue.data([])),
          casesProvider.overrideWithValue(const AsyncValue.data([])),
          _browseStatesOverride({
            'failed-unclassified': _browseState(
              reason: DocumentAttentionReason.failed,
              at: DateTime(2026, 9, 20, 10),
            ),
            'deleted-unclassified': _browseState(
              reason: DocumentAttentionReason.deleted,
              at: DateTime(2026, 9, 21, 10),
            ),
          }),
          ..._documentOverrides('failed-unclassified'),
          ..._documentOverrides('deleted-unclassified'),
        ],
        child: _app(const DocumentsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('unclassified-folder')), findsNothing);
    expect(find.byKey(const Key('needs-attention-folder')), findsOneWidget);
  });

  testWidgets('Needs Attention has a localized empty state when opened empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDocumentsProvider.overrideWithValue(const AsyncValue.data([])),
          _browseStatesOverride(const {}),
        ],
        child: _app(const NeedsAttentionDocumentsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Keine Dokumente benötigen Aufmerksamkeit'),
      findsOneWidget,
    );
  });

  testWidgets('usable unclassified Document stays out of Needs Attention', (
    tester,
  ) async {
    final document = _document('usable-unclassified');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDocumentsProvider.overrideWithValue(AsyncValue.data([document])),
          organizationsProvider.overrideWithValue(const AsyncValue.data([])),
          casesProvider.overrideWithValue(const AsyncValue.data([])),
          _browseStatesOverride({
            'usable-unclassified': _browseState(
              usable: true,
              reason: DocumentAttentionReason.failed,
              at: DateTime(2026, 9, 20, 10),
            ),
          }),
          ..._documentOverrides('usable-unclassified'),
        ],
        child: _app(const DocumentsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('unclassified-folder')), findsOneWidget);
    expect(find.byKey(const Key('needs-attention-folder')), findsNothing);
  });

  testWidgets(
    'Documents archive retains attention documents in Organizations',
    (tester) async {
      final document = _document(
        'organization-failed',
        organizationId: 'org-1',
        status: DocumentStatus.needsReview,
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allDocumentsProvider.overrideWithValue(AsyncValue.data([document])),
            organizationsProvider.overrideWithValue(
              AsyncValue.data([_organization('org-1', 'Housing office')]),
            ),
            casesProvider.overrideWithValue(const AsyncValue.data([])),
            _browseStatesOverride({
              'organization-failed': _browseState(
                reason: DocumentAttentionReason.failed,
                at: DateTime(2026, 9, 20, 10),
              ),
            }),
            ..._documentOverrides('organization-failed'),
          ],
          child: _app(const DocumentsPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('needs-attention-folder')), findsOneWidget);
      expect(find.text('Housing office'), findsOneWidget);
    },
  );

  testWidgets('Needs Attention list shows reasons, local times, and titles', (
    tester,
  ) async {
    final failed = _document(
      'failed-private-id',
      status: DocumentStatus.needsReview,
    );
    final deleted = _document(
      'deleted-private-id',
      status: DocumentStatus.needsReview,
    );
    final ordinary = _document('ordinary-private-id');
    final failedAt = DateTime(2026, 4, 12, 9, 15);
    final deletedAt = DateTime(2026, 4, 11, 16, 5);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDocumentsProvider.overrideWithValue(
            AsyncValue.data([failed, deleted, ordinary]),
          ),
          _browseStatesOverride({
            'failed-private-id': _browseState(
              reason: DocumentAttentionReason.failed,
              at: failedAt,
            ),
            'deleted-private-id': _browseState(
              reason: DocumentAttentionReason.deleted,
              at: deletedAt,
            ),
            'ordinary-private-id': _browseState(usable: true),
          }),
          ..._documentOverrides(
            'failed-private-id',
            files: [_file('failed-private-id', 'Mietbescheid 2026.pdf')],
          ),
          ..._documentOverrides(
            'deleted-private-id',
            files: [_file('deleted-private-id', 'Nebenkosten Brief.pdf')],
          ),
          ..._documentOverrides('ordinary-private-id'),
        ],
        child: _app(const NeedsAttentionDocumentsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('needs-attention-document-failed-private-id')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('needs-attention-document-deleted-private-id')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('needs-attention-document-ordinary-private-id')),
      findsNothing,
    );
    expect(find.text('Mietbescheid 2026.pdf'), findsOneWidget);
    expect(find.text('Nebenkosten Brief.pdf'), findsOneWidget);
    expect(find.text('failed-private-id'), findsNothing);
    expect(find.text('deleted-private-id'), findsNothing);
    expect(find.textContaining('Analyse fehlgeschlagen'), findsOneWidget);
    expect(find.textContaining('Analyse gelöscht'), findsOneWidget);
    final localizations = MaterialLocalizations.of(
      tester.element(find.byType(NeedsAttentionDocumentsPage)),
    );
    final failureTime =
        '${localizations.formatMediumDate(failedAt)} '
        '${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(failedAt))}';
    final deletionTime =
        '${localizations.formatMediumDate(deletedAt)} '
        '${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(deletedAt))}';
    expect(find.textContaining(failureTime), findsOneWidget);
    expect(find.textContaining(deletionTime), findsOneWidget);
  });

  testWidgets('Needs Attention supports Arabic RTL and long document titles', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    const documentId = 'long-attention-document-id';
    const title =
        'Jobcenter Bescheid Aufenthalt Nebenkosten Rueckmeldung 2026.pdf';
    final document = _document(documentId, status: DocumentStatus.needsReview);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDocumentsProvider.overrideWithValue(AsyncValue.data([document])),
          _browseStatesOverride({
            documentId: _browseState(
              reason: DocumentAttentionReason.deleted,
              at: DateTime(2026, 4, 11, 16, 5),
            ),
          }),
          ..._documentOverrides(documentId, files: [_file(documentId, title)]),
        ],
        child: _app(
          const NeedsAttentionDocumentsPage(),
          locale: const Locale('ar'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      Directionality.of(
        tester.element(find.byType(NeedsAttentionDocumentsPage)),
      ),
      TextDirection.rtl,
    );
    final titleWidget = tester.widget<Text>(find.text(title));
    expect(titleWidget.maxLines, 1);
    expect(titleWidget.overflow, TextOverflow.ellipsis);
    expect(tester.takeException(), isNull);
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
            _browseStatesOverride({
              document.clientDocumentId: _browseState(usable: true),
            }),
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
          _browseStatesOverride({
            organizationOnly.clientDocumentId: _browseState(usable: true),
            caseDocument.clientDocumentId: _browseState(usable: true),
          }),
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
          _browseStatesOverride({
            document.clientDocumentId: _browseState(usable: true),
          }),
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
          _browseStatesOverride({
            document.clientDocumentId: _browseState(usable: true),
          }),
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
          _browseStatesOverride({
            matching.clientDocumentId: _browseState(usable: true),
            other.clientDocumentId: _browseState(usable: true),
          }),
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
          _browseStatesOverride({'arabic-doc': _browseState(usable: true)}),
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

DocumentAnalysisBrowseState _browseState({
  bool usable = false,
  bool processing = false,
  DocumentAttentionReason? reason,
  DateTime? at,
}) => resolveDocumentAnalysisBrowseState(
  currentAnalysisStatuses: usable ? const [AnalysisStatus.complete] : const [],
  isProcessing: processing,
  latestFailureAt: reason == DocumentAttentionReason.failed ? at : null,
  latestDeletionAt: reason == DocumentAttentionReason.deleted ? at : null,
);

_browseStatesOverride(Map<String, DocumentAnalysisBrowseState> states) =>
    documentAnalysisBrowseStatesProvider.overrideWithValue(
      AsyncValue.data(states),
    );

ProviderContainer _attentionHomeContainer({
  required SettingsRepository settings,
  required List<LocalDocument> documents,
  required Map<String, DocumentAnalysisBrowseState> states,
}) => ProviderContainer(
  overrides: [
    homeDocumentsProvider.overrideWithValue(AsyncValue.data(documents)),
    activeAnalysisOperationsProvider.overrideWithValue(
      const AsyncValue.data([]),
    ),
    openTasksProvider.overrideWithValue(const AsyncValue.data([])),
    completedTasksProvider.overrideWithValue(const AsyncValue.data([])),
    settingsRepositoryProvider.overrideWithValue(settings),
    _browseStatesOverride(states),
    for (final document in documents)
      ..._documentOverrides(document.clientDocumentId),
  ],
);

DocumentFile _file(String documentId, String filename) => DocumentFile(
  id: 'file-$documentId',
  clientDocumentId: documentId,
  localUri: Uri.parse('file:///source.pdf'),
  mediaType: 'application/pdf',
  originalFilename: filename,
  importedAt: DateTime(2026),
);

List _documentOverrides(
  String id, {
  DocumentAnalysis? analysis,
  List<DocumentFile> files = const [],
}) => [
  latestAnalysisProvider(id).overrideWithValue(AsyncValue.data(analysis)),
  documentFilesProvider(id).overrideWithValue(AsyncValue.data(files)),
];

Future<void> _pumpThemedHome(
  WidgetTester tester, {
  required ThemeMode themeMode,
  Locale locale = const Locale('de'),
}) async {
  final action = _document('theme-action');
  final attention = _document(
    'theme-attention',
    status: DocumentStatus.needsReview,
  );
  final processing = _document(
    'theme-processing',
    status: DocumentStatus.processing,
  );
  final recentOne = _document('theme-recent-1');
  final recentTwo = _document('theme-recent-2');

  await tester.pumpWidget(
    ProviderScope(
      key: ValueKey('home-$themeMode-${locale.languageCode}'),
      overrides: [
        homeDocumentsProvider.overrideWithValue(
          AsyncValue.data([action, attention, processing, recentOne, recentTwo]),
        ),
        activeAnalysisOperationsProvider.overrideWithValue(
          const AsyncValue.data([
            PendingAnalysisOperation(
              operationId: 'theme-processing-operation',
              clientDocumentId: 'theme-processing',
              state: AnalysisLifecycleState.processing,
            ),
          ]),
        ),
        openTasksProvider.overrideWithValue(const AsyncValue.data([])),
        completedTasksProvider.overrideWithValue(const AsyncValue.data([])),
        settingsRepositoryProvider.overrideWithValue(_MemorySettings()),
        _browseStatesOverride({
          'theme-action': _browseState(usable: true),
          'theme-attention': _browseState(
            reason: DocumentAttentionReason.failed,
            at: DateTime(2026, 9, 20, 10),
          ),
          'theme-processing': _browseState(processing: true),
          'theme-recent-1': _browseState(usable: true),
          'theme-recent-2': _browseState(usable: true),
        }),
        ..._documentOverrides(
          'theme-action',
          analysis: DocumentAnalysis(
            id: 'analysis-theme-action',
            clientDocumentId: 'theme-action',
            schemaVersion: 'analysis_result.v1',
            targetLanguage: 'de',
            createdAt: DateTime(2026),
            actionRequired: ActionRequirement.yes,
            nextActions: const [
              'Review the deadline and respond with the requested information.',
            ],
            deadlines: const [
              AnalysisDeadline(
                label: 'response',
                dateOrRange: 'within ten days',
                confidence: 1,
              ),
            ],
          ),
        ),
        ..._documentOverrides('theme-attention'),
        ..._documentOverrides('theme-processing'),
        ..._documentOverrides(
          'theme-recent-1',
          analysis: _analysisFor('theme-recent-1', 'Recent document'),
          files: [_file('theme-recent-1', 'Recent document.pdf')],
        ),
        ..._documentOverrides(
          'theme-recent-2',
          analysis: _analysisFor('theme-recent-2', 'Older document'),
          files: [_file('theme-recent-2', 'Older document.pdf')],
        ),
      ],
      child: _app(
        const Scaffold(body: HomePage()),
        locale: locale,
        themeMode: themeMode,
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

Widget _app(
  Widget home, {
  Locale locale = const Locale('de'),
  ThemeMode? themeMode,
}) => MaterialApp(
  theme: themeMode == null ? null : AppTheme.light(),
  darkTheme: themeMode == null ? null : AppTheme.dark(),
  themeMode: themeMode ?? ThemeMode.system,
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

Future<void> _pumpNavigationTransition(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

class _MemorySettings implements SettingsRepository {
  _MemorySettings([Map<String, String>? initialValues])
    : values = initialValues ?? {};

  final Map<String, String> values;

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }
}
