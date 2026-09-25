import 'package:doxary/app/localization/app_localizations.dart';
import 'package:doxary/app/providers.dart';
import 'package:doxary/app/theme/app_theme.dart';
import 'package:doxary/core/notifications/reminder_scheduler.dart';
import 'package:doxary/features/document_analysis/presentation/analysis_result_page.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:doxary/features/tasks/application/task_lifecycle.dart';
import 'package:doxary/features/tasks/application/task_reminder_reconciler.dart';
import 'package:doxary/features/tasks/domain/repositories/task_repository.dart';
import 'package:doxary/features/tasks/presentation/task_detail_page.dart';
import 'package:doxary/features/tasks/presentation/task_editor_page.dart';
import 'package:doxary/features/tasks/presentation/tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  final dueDate = DateTime(2026, 9, 25);

  LocalTask task({
    String id = 'task-id',
    TaskStatus status = TaskStatus.open,
    bool allDay = false,
    int? reminderMinutesBefore = 60,
    String? note = 'Bitte Unterlagen mitbringen.',
    String? documentId = 'document-internal-id',
    String? caseId = 'case-internal-id',
    String title = 'Betriebskostenabrechnung beantworten',
  }) => LocalTask(
    id: id,
    title: title,
    status: status,
    provenance: TaskProvenance.user,
    createdAt: dueDate,
    updatedAt: dueDate,
    dueAt: dueDate,
    allDay: allDay,
    dueTimeMinutes: allDay ? null : 9 * 60 + 30,
    reminderMinutesBefore: reminderMinutesBefore,
    note: note,
    clientDocumentId: documentId,
    caseId: caseId,
  );

  testWidgets('Task Detail renders readable persisted values without IDs', (
    tester,
  ) async {
    final value = task();
    await _pumpDetail(tester, repository: _TaskRepository(value));

    expect(find.byKey(const Key('task-detail')), findsOneWidget);
    expect(find.text(value.title), findsOneWidget);
    expect(find.text('Offen'), findsOneWidget);
    expect(find.text('Eine Stunde vorher'), findsOneWidget);
    expect(find.text('Betriebskostenabrechnung 2026.pdf'), findsOneWidget);
    expect(find.text('Nebenkosten 2025'), findsOneWidget);
    expect(find.text(value.note!), findsOneWidget);
    expect(find.text(value.id), findsNothing);
    expect(find.text(value.clientDocumentId!), findsNothing);
    expect(find.text(value.caseId!), findsNothing);
  });

  testWidgets('All Day Task has no fake time and no reminder is explicit', (
    tester,
  ) async {
    await _pumpDetail(
      tester,
      repository: _TaskRepository(
        task(allDay: true, reminderMinutesBefore: null, note: null),
      ),
    );

    expect(find.text('Ganztägig'), findsOneWidget);
    expect(find.text('Keine Erinnerung'), findsOneWidget);
    expect(find.text('09:00'), findsNothing);
    expect(find.text('Notiz'), findsNothing);
  });

  testWidgets('zero-minute reminder renders At time instead of a raw value', (
    tester,
  ) async {
    await _pumpDetail(
      tester,
      repository: _TaskRepository(task(reminderMinutesBefore: 0)),
    );

    expect(find.text('Zum Zeitpunkt'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('completed Task can reopen without changing its metadata', (
    tester,
  ) async {
    final value = task(status: TaskStatus.completed);
    final repository = _TaskRepository(value);
    await _pumpDetail(tester, repository: repository);

    expect(find.text('Erledigt'), findsOneWidget);
    await tester.drag(
      find.byKey(const Key('task-detail')),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('task-detail-reopen')), findsOneWidget);
    await tester.tap(find.byKey(const Key('task-detail-reopen')));
    await tester.pumpAndSettle();

    expect(repository.statusUpdate, TaskStatus.open);
    expect(repository.task?.id, value.id);
    expect(repository.task?.dueAt, value.dueAt);
    expect(repository.task?.note, value.note);
    expect(repository.task?.reminderMinutesBefore, value.reminderMinutesBefore);
    expect(repository.task?.clientDocumentId, value.clientDocumentId);
    expect(repository.task?.caseId, value.caseId);
  });

  testWidgets('open Task does not offer Reopen', (tester) async {
    await _pumpDetail(tester, repository: _TaskRepository(task()));
    expect(find.byKey(const Key('task-detail-reopen')), findsNothing);
  });

  testWidgets('missing Task is a safe localized state', (tester) async {
    await _pumpDetail(tester, repository: _TaskRepository(null));
    expect(find.byKey(const Key('task-detail-missing')), findsOneWidget);
    expect(find.text('Aufgabe nicht verfügbar'), findsOneWidget);
    expect(find.text('task-id'), findsNothing);
  });

  testWidgets('Task row opens Detail instead of Edit', (tester) async {
    final value = task(title: 'Heute antworten');
    final repository = _TaskRepository(value);
    final router = _router();
    await _pumpRouter(tester, router: router, repository: repository);

    await tester.tap(find.text(value.title));
    await tester.pumpAndSettle();

    expect(find.byType(TaskDetailPage), findsOneWidget);
    expect(find.byType(TaskEditorPage), findsNothing);
  });

  testWidgets('Result-derived View Task opens Task Detail', (tester) async {
    final existingTask = task(id: 'source-task');
    final repository = _TaskRepository(existingTask);
    final analysis = DocumentAnalysis(
      id: 'analysis-id',
      clientDocumentId: 'doc',
      schemaVersion: 'analysis_result.v1',
      targetLanguage: 'de',
      createdAt: dueDate,
      actionRequired: ActionRequirement.yes,
      nextActions: const ['Antworten'],
    );
    final router = _resultRouter();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ..._overrides(repository),
          documentProvider('doc')
              .overrideWithValue(const AsyncValue.data(null)),
          latestAnalysisProvider('doc')
              .overrideWithValue(AsyncValue.data(analysis)),
          taskForSourceActionProvider((
            analysisId: 'analysis-id',
            actionKey: 'next-action:0',
          )).overrideWithValue(AsyncValue.data(existingTask)),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('de'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Aufgabe ansehen'));
    await tester.pumpAndSettle();

    expect(find.byType(TaskDetailPage), findsOneWidget);
    expect(find.byType(TaskEditorPage), findsNothing);
  });

  testWidgets('saving an edit returns to refreshed Task Detail', (
    tester,
  ) async {
    final repository = _TaskRepository(task());
    final router = _router(initialLocation: '/tasks/task-id');
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpRouter(tester, router: router, repository: repository);

    await tester.tap(find.byKey(const Key('task-detail-edit')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('task-title')), 'Neue Aufgabe');
    await tester.ensureVisible(find.byKey(const Key('task-save')));
    await tester.tap(find.byKey(const Key('task-save')));
    await tester.pumpAndSettle();

    expect(find.byType(TaskDetailPage), findsOneWidget);
    expect(find.text('Neue Aufgabe'), findsOneWidget);
  });

  testWidgets('Edit opens the existing editor and Delete confirms then exits', (
    tester,
  ) async {
    final repository = _TaskRepository(task());
    final router = _router(initialLocation: '/tasks/task-id');
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _pumpRouter(tester, router: router, repository: repository);

    await tester.tap(find.byKey(const Key('task-detail-edit')));
    await tester.pumpAndSettle();
    expect(find.byType(TaskEditorPage), findsOneWidget);
    router.pop();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('task-detail-delete')));
    await tester.pumpAndSettle();
    expect(find.text('Aufgabe löschen?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Aufgabe löschen'));
    await tester.pumpAndSettle();
    expect(repository.deletedTaskId, 'task-id');
    expect(find.byType(TasksPage), findsOneWidget);
  });

  testWidgets('Task Detail follows Arabic directionality and bounds long title', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final longTitle =
        'عنوان طويل جدًا zur Betriebskostenabrechnung mit einer Zahlungsaufforderung 2026';
    await _pumpDetail(
      tester,
      repository: _TaskRepository(task(title: longTitle)),
      locale: const Locale('ar'),
    );

    final title = tester.widget<Text>(
      find.byKey(const Key('task-detail-title')),
    );
    expect(title.maxLines, 3);
    expect(title.overflow, TextOverflow.ellipsis);
    expect(
      Directionality.of(tester.element(find.byType(TaskDetailPage))),
      TextDirection.rtl,
    );
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpDetail(
  WidgetTester tester, {
  required _TaskRepository repository,
  Locale locale = const Locale('de'),
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [..._overrides(repository)],
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        home: const TaskDetailPage(taskId: 'task-id'),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpRouter(
  WidgetTester tester, {
  required GoRouter router,
  required _TaskRepository repository,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [..._overrides(repository)],
      child: MaterialApp.router(
        routerConfig: router,
        locale: const Locale('de'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

List<dynamic> _overrides(_TaskRepository repository) {
  final reconciler = TaskReminderReconciler(
    _ReminderScheduler(),
    now: () => DateTime(2026, 9, 1),
  );
  return [
    taskRepositoryProvider.overrideWithValue(repository),
    taskReminderReconcilerProvider.overrideWithValue(reconciler),
    taskLifecycleProvider.overrideWithValue(
      TaskLifecycle(repository, reconciler),
    ),
    currentTimeProvider.overrideWithValue(DateTime(2026, 9, 25)),
    allDocumentsProvider.overrideWithValue(
      AsyncValue.data([
        LocalDocument(
          clientDocumentId: 'document-internal-id',
          classificationState: ClassificationState.unclassified,
          status: DocumentStatus.analyzed,
          createdAt: DateTime(2026, 9, 1),
          updatedAt: DateTime(2026, 9, 1),
        ),
      ]),
    ),
    casesProvider.overrideWithValue(
      AsyncValue.data([
        Case(
          id: 'case-internal-id',
          organizationId: 'organization-id',
          title: 'Nebenkosten 2025',
          createdAt: DateTime(2026, 9, 1),
          updatedAt: DateTime(2026, 9, 1),
        ),
      ]),
    ),
    latestAnalysisProvider('document-internal-id')
        .overrideWithValue(const AsyncValue.data(null)),
    documentFilesProvider('document-internal-id').overrideWithValue(
      AsyncValue.data([
        DocumentFile(
          id: 'file-id',
          clientDocumentId: 'document-internal-id',
          localUri: Uri.parse('file:///document.pdf'),
          mediaType: 'application/pdf',
          originalFilename: 'Betriebskostenabrechnung 2026.pdf',
          importedAt: DateTime(2026, 9, 1),
        ),
      ]),
    ),
  ];
}

GoRouter _router({String initialLocation = '/tasks'}) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    GoRoute(
      path: '/tasks',
      builder: (_, _) => const TasksPage(),
      routes: [
        GoRoute(path: 'create', builder: (_, _) => const SizedBox()),
        GoRoute(
          path: 'edit/:taskId',
          builder: (_, state) =>
              TaskEditorPage.edit(taskId: state.pathParameters['taskId']!),
        ),
        GoRoute(
          path: ':taskId',
          builder: (_, state) =>
              TaskDetailPage(taskId: state.pathParameters['taskId']!),
        ),
      ],
    ),
  ],
);

GoRouter _resultRouter() => GoRouter(
  initialLocation: '/result',
  routes: [
    GoRoute(
      path: '/result',
      builder: (_, _) => const AnalysisResultPage(clientDocumentId: 'doc'),
    ),
    GoRoute(
      path: '/tasks/:taskId',
      builder: (_, state) =>
          TaskDetailPage(taskId: state.pathParameters['taskId']!),
    ),
  ],
);

class _TaskRepository implements TaskRepository {
  _TaskRepository(this.task);

  LocalTask? task;
  TaskStatus? statusUpdate;
  String? deletedTaskId;

  @override
  Future<void> delete(String taskId) async {
    deletedTaskId = taskId;
    task = null;
  }

  @override
  Future<LocalTask?> findBySourceAction(
    String sourceAnalysisId,
    String sourceActionKey,
  ) async => null;

  @override
  Future<LocalTask?> getById(String taskId) async =>
      task?.id == taskId ? task : null;

  @override
  Future<void> save(LocalTask value) async => task = value;

  @override
  Future<void> updateStatus(
    String taskId,
    TaskStatus status,
    DateTime updatedAt,
  ) async {
    statusUpdate = status;
    final value = task!;
    task = LocalTask(
      id: value.id,
      title: value.title,
      status: status,
      provenance: value.provenance,
      createdAt: value.createdAt,
      updatedAt: updatedAt,
      dueAt: value.dueAt,
      allDay: value.allDay,
      dueTimeMinutes: value.dueTimeMinutes,
      reminderMinutesBefore: value.reminderMinutesBefore,
      note: value.note,
      clientDocumentId: value.clientDocumentId,
      caseId: value.caseId,
      sourceAnalysisId: value.sourceAnalysisId,
      sourceActionKey: value.sourceActionKey,
    );
  }

  @override
  Stream<List<LocalTask>> watchCompleted() => Stream.value(
    task?.status == TaskStatus.completed ? [task!] : const <LocalTask>[],
  );

  @override
  Stream<List<LocalTask>> watchOpen() => Stream.value(
    task?.status == TaskStatus.open ? [task!] : const <LocalTask>[],
  );
}

class _ReminderScheduler implements ReminderScheduler {
  @override
  Future<ReminderScheduleResult> cancel(String taskId) async =>
      ReminderScheduleResult.cancelled;

  @override
  Future<ReminderScheduleResult> schedule({
    required String taskId,
    required DateTime at,
    required String taskTitle,
    bool requestPermission = true,
  }) async => ReminderScheduleResult.scheduled;
}
