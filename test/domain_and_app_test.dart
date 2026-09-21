import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doxary/app/app.dart';
import 'package:doxary/app/localization/app_localizations.dart';
import 'package:doxary/app/providers.dart';
import 'package:doxary/core/database/app_database.dart' hide DocumentFile;
import 'package:doxary/features/documents/data/repositories/local_document_repository.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:doxary/features/documents/domain/repositories/document_repository.dart';
import 'package:doxary/features/documents/presentation/documents_page.dart';
import 'package:doxary/features/document_import/domain/document_import.dart';
import 'package:doxary/features/document_import/presentation/import_page.dart';
import 'package:doxary/core/errors/result.dart';
import 'package:doxary/features/document_analysis/domain/analysis_output_language.dart';
import 'package:doxary/features/home/presentation/home_page.dart';
import 'package:doxary/features/settings/presentation/profile_page.dart';
import 'package:doxary/features/tasks/application/task_timeframes.dart';
import 'package:doxary/features/tasks/domain/repositories/task_repository.dart';
import 'package:doxary/features/tasks/presentation/tasks_page.dart';
import 'package:doxary/features/settings/domain/settings_repository.dart';

void main() {
  test('Arabic device locale bootstraps Arabic UI and analysis language', () {
    final settings = _MemorySettings();
    final container = ProviderContainer(
      overrides: [
        deviceLocaleProvider.overrideWithValue(const Locale('ar')),
        settingsRepositoryProvider.overrideWithValue(settings),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(languageProvider), const Locale('ar'));
    expect(
      container.read(analysisLanguageProvider),
      AnalysisOutputLanguage.arabic,
    );
  });

  test(
    'non-Arabic device locale bootstraps German UI and analysis language',
    () {
      final container = ProviderContainer(
        overrides: [
          deviceLocaleProvider.overrideWithValue(const Locale('en', 'GB')),
          settingsRepositoryProvider.overrideWithValue(_MemorySettings()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(languageProvider), const Locale('de'));
      expect(
        container.read(analysisLanguageProvider),
        AnalysisOutputLanguage.simpleGerman,
      );
    },
  );

  test('explicit persisted UI language overrides device locale', () async {
    final settings = _MemorySettings({'ui_language': 'ar'});
    final container = ProviderContainer(
      overrides: [
        deviceLocaleProvider.overrideWithValue(const Locale('de')),
        settingsRepositoryProvider.overrideWithValue(settings),
      ],
    );
    addTearDown(container.dispose);

    container.read(languageProvider);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(languageProvider), const Locale('ar'));
  });

  test(
    'analysis language defaults from a persisted UI locale when not selected',
    () async {
      final container = ProviderContainer(
        overrides: [
          deviceLocaleProvider.overrideWithValue(const Locale('de')),
          settingsRepositoryProvider.overrideWithValue(
            _MemorySettings({'ui_language': 'ar'}),
          ),
        ],
      );
      addTearDown(container.dispose);

      container.read(languageProvider);
      container.read(analysisLanguageProvider);
      await Future<void>.delayed(Duration.zero);

      expect(container.read(languageProvider), const Locale('ar'));
      expect(
        container.read(analysisLanguageProvider),
        AnalysisOutputLanguage.arabic,
      );
    },
  );

  test('analysis language persists independently from UI language', () async {
    final settings = _MemorySettings();
    final first = ProviderContainer(
      overrides: [
        deviceLocaleProvider.overrideWithValue(const Locale('ar')),
        settingsRepositoryProvider.overrideWithValue(settings),
      ],
    );
    await first
        .read(analysisLanguageProvider.notifier)
        .setLanguage(AnalysisOutputLanguage.simpleGerman);
    await first.read(languageProvider.notifier).setLocale(const Locale('ar'));
    expect(
      first.read(analysisLanguageProvider),
      AnalysisOutputLanguage.simpleGerman,
    );
    first.dispose();

    final restarted = ProviderContainer(
      overrides: [
        deviceLocaleProvider.overrideWithValue(const Locale('ar')),
        settingsRepositoryProvider.overrideWithValue(settings),
      ],
    );
    addTearDown(restarted.dispose);
    restarted.read(languageProvider);
    restarted.read(analysisLanguageProvider);
    await Future<void>.delayed(Duration.zero);
    expect(restarted.read(languageProvider), const Locale('ar'));
    expect(
      restarted.read(analysisLanguageProvider),
      AnalysisOutputLanguage.simpleGerman,
    );
  });

  test('an imported document is valid before classification', () {
    final document = LocalDocument(
      clientDocumentId: 'client-1',
      classificationState: ClassificationState.unclassified,
      status: DocumentStatus.imported,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );
    expect(document.organizationId, isNull);
    expect(document.caseId, isNull);
    expect(document.isUnclassified, isTrue);
  });

  test(
    'schema v1 persists an unclassified document and its local file',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      final repository = LocalDocumentRepository(database);
      final now = DateTime(2026, 1, 1);
      await repository.saveImportedDocument(
        LocalDocument(
          clientDocumentId: 'client-1',
          classificationState: ClassificationState.unclassified,
          status: DocumentStatus.imported,
          createdAt: now,
          updatedAt: now,
        ),
        DocumentFile(
          id: 'file-1',
          clientDocumentId: 'client-1',
          localUri: Uri.parse('file:///private/document.pdf'),
          mediaType: 'application/pdf',
          importedAt: now,
        ),
      );
      expect(await repository.watchRecent().first, hasLength(1));
      await database.close();
    },
  );

  test('task buckets separate overdue, today, upcoming, and completed', () {
    final now = DateTime(2026, 1, 10, 9);
    LocalTask task(
      String id,
      TaskStatus status,
      DateTime? dueAt, {
      bool allDay = false,
    }) => LocalTask(
      id: id,
      title: id,
      status: status,
      provenance: TaskProvenance.user,
      createdAt: now,
      updatedAt: now,
      dueAt: dueAt,
      allDay: allDay,
    );
    final buckets = bucketTasks(
      open: [
        task('overdue', TaskStatus.open, DateTime(2026, 1, 9)),
        task('timed-overdue', TaskStatus.open, DateTime(2026, 1, 9, 23)),
        task(
          'all-day-overdue',
          TaskStatus.open,
          DateTime(2026, 1, 9),
          allDay: true,
        ),
        task('done-in-open', TaskStatus.completed, DateTime(2026, 1, 9)),
        task('today', TaskStatus.open, DateTime(2026, 1, 10, 18)),
        task('later', TaskStatus.open, DateTime(2026, 1, 11)),
      ],
      completed: [
        task('done-yesterday', TaskStatus.completed, DateTime(2026, 1, 9)),
        task('done-today', TaskStatus.completed, DateTime(2026, 1, 10)),
      ],
      now: now,
    );
    expect(
      buckets.overdue.map((task) => task.id),
      ['overdue', 'timed-overdue', 'all-day-overdue'],
    );
    expect(buckets.today.single.id, 'today');
    expect(buckets.upcoming.single.id, 'later');
    expect(
      buckets.completed.map((task) => task.id),
      ['done-yesterday', 'done-today', 'done-in-open'],
    );
  });

  test('unavailable import is an explicit typed capability failure', () async {
    final result = await UnavailableDocumentImportGateway().pick(
      ImportSource.pdfFile,
    );
    expect(result, isA<Failure<DocumentImportCandidate>>());
  });

  test('German bottom navigation labels are compact and localized', () {
    final localizations = AppLocalizations(const Locale('de'));

    expect(localizations.bottomNavigationHome, 'Start');
    expect(localizations.bottomNavigationDocuments, 'Dokumente');
    expect(localizations.bottomNavigationAnalyze, 'Analyse');
    expect(localizations.bottomNavigationTasks, 'Aufgaben');
    expect(localizations.bottomNavigationSettings, 'Einst.');
  });

  testWidgets('primary navigation preserves destination-to-branch mapping', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          documentRepositoryProvider.overrideWithValue(_EmptyDocuments()),
          taskRepositoryProvider.overrideWithValue(_EmptyTasks()),
          organizationsProvider.overrideWithValue(const AsyncValue.data([])),
          casesProvider.overrideWithValue(const AsyncValue.data([])),
          activeAnalysisOperationsProvider.overrideWithValue(
            const AsyncValue.data([]),
          ),
          resumePendingAnalysesProvider.overrideWith(
            (ref) => Future<void>.value(),
          ),
        ],
        child: const ProjectApp(),
      ),
    );
    await tester.pumpAndSettle();

    final destinations = <(String, Type)>[
      ('Start', HomePage),
      ('Dokumente', DocumentsPage),
      ('Analyse', ImportPage),
      ('Aufgaben', TasksPage),
      ('Einst.', ProfilePage),
    ];

    for (final destination in destinations) {
      await tester.tap(find.text(destination.$1).last);
      await tester.pumpAndSettle();

      expect(find.byType(destination.$2), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
    }
  });

  testWidgets('empty home is localized and switches to RTL in Arabic', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          documentRepositoryProvider.overrideWithValue(_EmptyDocuments()),
          taskRepositoryProvider.overrideWithValue(_EmptyTasks()),
          organizationsProvider.overrideWithValue(const AsyncValue.data([])),
          casesProvider.overrideWithValue(const AsyncValue.data([])),
          activeAnalysisOperationsProvider.overrideWithValue(
            const AsyncValue.data([]),
          ),
          resumePendingAnalysesProvider.overrideWith(
            (ref) => Future<void>.value(),
          ),
        ],
        child: const ProjectApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Noch keine Dokumente'), findsOneWidget);
    await tester.tap(find.text('Dokumente').last);
    await tester.pumpAndSettle();
    expect(find.byType(DocumentsPage), findsOneWidget);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          documentRepositoryProvider.overrideWithValue(_EmptyDocuments()),
          taskRepositoryProvider.overrideWithValue(_EmptyTasks()),
          organizationsProvider.overrideWithValue(const AsyncValue.data([])),
          casesProvider.overrideWithValue(const AsyncValue.data([])),
          activeAnalysisOperationsProvider.overrideWithValue(
            const AsyncValue.data([]),
          ),
          resumePendingAnalysesProvider.overrideWith(
            (ref) => Future<void>.value(),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('ar'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const HomePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      Directionality.of(tester.element(find.byType(HomePage))),
      TextDirection.rtl,
    );
  });
}

class _EmptyDocuments implements DocumentRepository {
  @override
  Future<void> updateClassification(
    String clientDocumentId, {
    String? organizationId,
    String? caseId,
    required ClassificationState state,
  }) async {}
  @override
  Future<LocalDocument?> getById(String clientDocumentId) async => null;

  @override
  Future<List<DocumentFile>> getFiles(String clientDocumentId) async => [];

  @override
  Future<void> saveImportedDocument(
    LocalDocument document,
    DocumentFile file,
  ) async {}
  @override
  Stream<List<LocalDocument>> watchRecent({int limit = 5}) => Stream.value([]);

  @override
  Stream<List<LocalDocument>> watchAll() => Stream.value([]);
}

class _EmptyTasks implements TaskRepository {
  @override
  Future<void> delete(String taskId) async {}
  @override
  Future<LocalTask?> getById(String taskId) async => null;
  @override
  Future<LocalTask?> findBySourceAction(
    String sourceAnalysisId,
    String sourceActionKey,
  ) async => null;
  @override
  Future<void> save(LocalTask task) async {}
  @override
  Future<void> updateStatus(
    String taskId,
    TaskStatus status,
    DateTime updatedAt,
  ) async {}
  @override
  Stream<List<LocalTask>> watchCompleted() => Stream.value([]);
  @override
  Stream<List<LocalTask>> watchOpen() => Stream.value([]);
}

class _MemorySettings implements SettingsRepository {
  _MemorySettings([Map<String, String>? initial]) : _values = {...?initial};
  final Map<String, String> _values;

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async => _values[key] = value;
}
