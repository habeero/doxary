import 'package:doxary/app/localization/app_localizations.dart';
import 'package:doxary/app/providers.dart';
import 'package:doxary/app/theme/app_theme.dart';
import 'package:doxary/core/notifications/reminder_scheduler.dart';
import 'package:doxary/core/utils/id_generator.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:doxary/features/tasks/application/task_reminder_reconciler.dart';
import 'package:doxary/features/tasks/domain/repositories/task_repository.dart';
import 'package:doxary/features/tasks/presentation/task_draft_prefill.dart';
import 'package:doxary/features/tasks/presentation/task_editor_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Edit Task resolves stored links into bounded display labels', (
    tester,
  ) async {
    const documentId = '01a0c451-1153-7512-b260-internal-id';
    const caseId = 'case-internal-id';
    final now = DateTime(2026, 9, 21);
    final task = LocalTask(
      id: 'task',
      title: 'Reply',
      status: TaskStatus.open,
      provenance: TaskProvenance.user,
      createdAt: now,
      updatedAt: now,
      dueAt: now,
      clientDocumentId: documentId,
      caseId: caseId,
    );
    final document = LocalDocument(
      clientDocumentId: documentId,
      classificationState: ClassificationState.unclassified,
      status: DocumentStatus.analyzed,
      createdAt: now,
      updatedAt: now,
    );
    final file = DocumentFile(
      id: 'file',
      clientDocumentId: documentId,
      localUri: Uri.parse('file:///document.pdf'),
      mediaType: 'application/pdf',
      originalFilename: 'Betriebskostenabrechnung mit einem sehr langen Dokumenttitel 2026.pdf',
      importedAt: now,
    );

    await tester.binding.setSurfaceSize(const Size(320, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository = _TaskRepository(task);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taskRepositoryProvider.overrideWithValue(repository),
          allDocumentsProvider.overrideWithValue(AsyncValue.data([document])),
          casesProvider.overrideWithValue(
            AsyncValue.data([
              Case(
                id: caseId,
                organizationId: 'organization',
                title: 'Nebenkosten 2025',
                createdAt: now,
                updatedAt: now,
              ),
            ]),
          ),
          latestAnalysisProvider(documentId)
              .overrideWithValue(const AsyncValue.data(null)),
          documentFilesProvider(documentId)
              .overrideWithValue(AsyncValue.data([file])),
        ],
        child: MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light(),
          home: const TaskEditorPage.edit(taskId: 'task'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Betriebskostenabrechnung'), findsOneWidget);
    expect(find.text('Nebenkosten 2025'), findsOneWidget);
    expect(find.text(documentId), findsNothing);
    expect(find.text(caseId), findsNothing);
    final documentText = tester.widget<Text>(
      find.textContaining('Betriebskostenabrechnung'),
    );
    expect(documentText.maxLines, 1);
    expect(documentText.overflow, TextOverflow.ellipsis);
    expect(
      Directionality.of(tester.element(find.byType(TaskEditorPage))),
      TextDirection.rtl,
    );

    await tester.tap(find.byKey(const Key('task-save')));
    await tester.pumpAndSettle();
    expect(repository.saved?.clientDocumentId, documentId);
    expect(repository.saved?.caseId, caseId);
  });

  testWidgets('Edit Task replaces missing linked records with neutral labels', (
    tester,
  ) async {
    const documentId = 'missing-document-internal-id';
    const caseId = 'missing-case-internal-id';
    final now = DateTime(2026, 9, 21);
    final task = LocalTask(
      id: 'task',
      title: 'Reply',
      status: TaskStatus.open,
      provenance: TaskProvenance.user,
      createdAt: now,
      updatedAt: now,
      dueAt: now,
      clientDocumentId: documentId,
      caseId: caseId,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taskRepositoryProvider.overrideWithValue(_TaskRepository(task)),
          allDocumentsProvider.overrideWithValue(
            const AsyncValue.data(<LocalDocument>[]),
          ),
          casesProvider.overrideWithValue(const AsyncValue.data(<Case>[])),
        ],
        child: MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light(),
          home: const TaskEditorPage.edit(taskId: 'task'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('\u0645\u0633\u062a\u0646\u062f'), findsOneWidget);
    expect(
      find.text('\u063a\u064a\u0631 \u0645\u062d\u062f\u062f\u0629'),
      findsOneWidget,
    );
    expect(find.text(documentId), findsNothing);
    expect(find.text(caseId), findsNothing);
  });

  testWidgets('Create Task keeps a Result prefill editable until Save', (
    tester,
  ) async {
    const documentId = 'document-id';
    const caseId = 'case-id';
    final now = DateTime(2026, 9, 21);
    final repository = _TaskRepository(
      LocalTask(
        id: 'unused',
        title: 'Unused',
        status: TaskStatus.open,
        provenance: TaskProvenance.user,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taskRepositoryProvider.overrideWithValue(repository),
          idGeneratorProvider.overrideWithValue(const _FixedIdGenerator()),
          allDocumentsProvider.overrideWithValue(
            AsyncValue.data([
              LocalDocument(
                clientDocumentId: documentId,
                classificationState: ClassificationState.confirmed,
                status: DocumentStatus.analyzed,
                createdAt: now,
                updatedAt: now,
                caseId: caseId,
              ),
            ]),
          ),
          casesProvider.overrideWithValue(
            AsyncValue.data([
              Case(
                id: caseId,
                organizationId: 'organization',
                title: 'Nebenkosten 2025',
                createdAt: now,
                updatedAt: now,
              ),
            ]),
          ),
          latestAnalysisProvider(documentId)
              .overrideWithValue(const AsyncValue.data(null)),
          documentFilesProvider(documentId).overrideWithValue(
            AsyncValue.data([
              DocumentFile(
                id: 'file',
                clientDocumentId: documentId,
                localUri: Uri.parse('file:///document.pdf'),
                mediaType: 'application/pdf',
                originalFilename: 'Betriebskostenabrechnung 2026.pdf',
                importedAt: now,
              ),
            ]),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light(),
          home: TaskEditorPage.create(
            prefill: TaskDraftPrefill(
              title: 'Pay the invoice',
              dueDate: DateTime(2026, 10, 14),
              dueTimeMinutes: 9 * 60 + 30,
              allDay: false,
              note: 'Use the reference on the invoice.',
              clientDocumentId: documentId,
              caseId: caseId,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pay the invoice'), findsOneWidget);
    expect(find.text('Betriebskostenabrechnung 2026.pdf'), findsOneWidget);
    expect(find.text('Nebenkosten 2025'), findsOneWidget);
    expect(find.text(documentId), findsNothing);
    expect(repository.saved, isNull, reason: 'Abandoning creates no task.');

    await tester.tap(find.byKey(const Key('task-save')));
    await tester.pumpAndSettle();
    expect(repository.saved?.id, 'new-task');
    expect(repository.saves, 1);
    expect(repository.saved?.title, 'Pay the invoice');
    expect(repository.saved?.clientDocumentId, documentId);
    expect(repository.saved?.caseId, caseId);
    expect(repository.saved?.dueAt, DateTime(2026, 10, 14));
    expect(repository.saved?.dueTimeMinutes, 9 * 60 + 30);
    expect(repository.saved?.allDay, isFalse);
  });

  testWidgets('Completed Task reopens only through the explicit action', (
    tester,
  ) async {
    final now = DateTime(2026, 9, 21, 9);
    final repository = _TaskRepository(
      LocalTask(
        id: 'completed-task',
        title: 'Reply',
        status: TaskStatus.completed,
        provenance: TaskProvenance.user,
        createdAt: now,
        updatedAt: now,
        dueAt: DateTime(2026, 9, 20),
        allDay: false,
        dueTimeMinutes: 9 * 60,
        reminderMinutesBefore: 1440,
        note: 'Keep this note',
        clientDocumentId: 'document-id',
        caseId: 'case-id',
      ),
    );
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taskRepositoryProvider.overrideWithValue(repository),
          allDocumentsProvider.overrideWithValue(
            const AsyncValue.data(<LocalDocument>[]),
          ),
          casesProvider.overrideWithValue(const AsyncValue.data(<Case>[])),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light(),
          home: const TaskEditorPage.edit(taskId: 'completed-task'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('task-reopen')), findsOneWidget);
    expect(find.byKey(const Key('task-complete')), findsNothing);
    await tester.tap(find.byKey(const Key('task-reopen')));
    await tester.pumpAndSettle();
    expect(repository.statusUpdate?.id, 'completed-task');
    expect(repository.statusUpdate?.status, TaskStatus.open);
    expect(repository.saved, isNull);
  });

  testWidgets('Task save persists when local reminder scheduling fails', (
    tester,
  ) async {
    final now = DateTime(2026, 9, 21, 8);
    final task = LocalTask(
      id: 'reminder-task',
      title: 'Reply',
      status: TaskStatus.open,
      provenance: TaskProvenance.user,
      createdAt: now,
      updatedAt: now,
      dueAt: DateTime(2026, 9, 22),
      dueTimeMinutes: 9 * 60,
      reminderMinutesBefore: 0,
    );
    final repository = _TaskRepository(task);
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taskRepositoryProvider.overrideWithValue(repository),
          reminderSchedulerProvider.overrideWithValue(
            _ReminderScheduler(ReminderScheduleResult.platformFailure),
          ),
          taskReminderReconcilerProvider.overrideWithValue(
            TaskReminderReconciler(
              _ReminderScheduler(ReminderScheduleResult.platformFailure),
              now: () => now,
            ),
          ),
          currentTimeProvider.overrideWithValue(now),
          allDocumentsProvider.overrideWithValue(
            const AsyncValue.data(<LocalDocument>[]),
          ),
          casesProvider.overrideWithValue(const AsyncValue.data(<Case>[])),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light(),
          home: const TaskEditorPage.edit(taskId: 'reminder-task'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('task-save')));
    await tester.pump();

    expect(repository.saved?.id, 'reminder-task');
    expect(
      find.textContaining('Erinnerung konnte nicht geplant'),
      findsOneWidget,
    );
  });

  testWidgets(
    'Create Task maps the at-time reminder choice to zero and schedules',
    (tester) async {
      final now = DateTime(2026, 9, 21, 8);
      final repository = _TaskRepository(_taskForEditor(now));
      final scheduler = _ReminderScheduler(ReminderScheduleResult.scheduled);
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        _taskEditorApp(
          repository: repository,
          scheduler: scheduler,
          now: now,
          child: TaskEditorPage.create(
            prefill: TaskDraftPrefill(
              title: 'Reply',
              dueDate: DateTime(2026, 9, 22),
              dueTimeMinutes: 9 * 60,
              allDay: false,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Keine Erinnerung'), findsOneWidget);
      await _selectReminder(tester, 'atTime');
      expect(find.text('Zum Zeitpunkt'), findsOneWidget);
      await tester.tap(find.byKey(const Key('task-save')));
      await tester.pumpAndSettle();

      expect(repository.saved?.reminderMinutesBefore, 0);
      expect(scheduler.scheduled, hasLength(1));
    },
  );

  testWidgets('Edit Task changes no reminder to zero and schedules', (
    tester,
  ) async {
    final now = DateTime(2026, 9, 21, 8);
    final repository = _TaskRepository(_taskForEditor(now));
    final scheduler = _ReminderScheduler(ReminderScheduleResult.scheduled);
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _taskEditorApp(
        repository: repository,
        scheduler: scheduler,
        now: now,
        child: const TaskEditorPage.edit(taskId: 'editor-task'),
      ),
    );
    await tester.pumpAndSettle();

    await _selectReminder(tester, 'atTime');
    expect(find.text('Zum Zeitpunkt'), findsOneWidget);
    await tester.tap(find.byKey(const Key('task-save')));
    await tester.pumpAndSettle();

    expect(repository.saved?.reminderMinutesBefore, 0);
    expect(scheduler.scheduled, hasLength(1));
  });

  testWidgets(
    'Reminder picker maps 5, 60, and 1440 minute options to payloads',
    (tester) async {
      final now = DateTime(2026, 9, 21, 8);
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      for (final option in <({String name, String label, int minutes})>[
        (name: 'fiveMinutes', label: '5 Minuten vorher', minutes: 5),
        (name: 'oneHour', label: 'Eine Stunde vorher', minutes: 60),
        (name: 'oneDay', label: 'Einen Tag vorher', minutes: 1440),
      ]) {
        final repository = _TaskRepository(_taskForEditor(now));
        final scheduler = _ReminderScheduler(ReminderScheduleResult.scheduled);
        await tester.pumpWidget(
          _taskEditorApp(
            repository: repository,
            scheduler: scheduler,
            now: now,
            child: TaskEditorPage.create(
              prefill: TaskDraftPrefill(
                title: 'Reply',
                dueDate: DateTime(2026, 9, 22),
                dueTimeMinutes: 9 * 60,
                allDay: false,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await _selectReminder(tester, option.name);
        expect(find.text(option.label), findsOneWidget);
        await tester.tap(find.byKey(const Key('task-save')));
        await tester.pumpAndSettle();

        expect(repository.saved?.reminderMinutesBefore, option.minutes);
        expect(scheduler.scheduled, hasLength(1));
      }
    },
  );

  testWidgets(
    'No reminder is an explicit choice and picker dismissal preserves selection',
    (tester) async {
      final now = DateTime(2026, 9, 21, 8);
      final repository = _TaskRepository(_taskForEditor(now));
      final scheduler = _ReminderScheduler(ReminderScheduleResult.scheduled);
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        _taskEditorApp(
          repository: repository,
          scheduler: scheduler,
          now: now,
          child: TaskEditorPage.create(
            prefill: TaskDraftPrefill(
              title: 'Reply',
              dueDate: DateTime(2026, 9, 22),
              dueTimeMinutes: 9 * 60,
              allDay: false,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await _selectReminder(tester, 'fiveMinutes');
      await tester.tap(find.byKey(const Key('task-reminder')));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(4, 4));
      await tester.pumpAndSettle();
      expect(find.text('5 Minuten vorher'), findsOneWidget);

      await _selectReminder(tester, 'none');
      expect(find.text('Keine Erinnerung'), findsOneWidget);
      await tester.tap(find.byKey(const Key('task-save')));
      await tester.pumpAndSettle();

      expect(repository.saved?.reminderMinutesBefore, isNull);
      expect(scheduler.scheduled, isEmpty);
    },
  );

  testWidgets(
    'Edit Task preserves an existing zero reminder after another edit',
    (tester) async {
      final now = DateTime(2026, 9, 21, 8);
      final repository = _TaskRepository(
        _taskForEditor(now, reminderMinutesBefore: 0),
      );
      final scheduler = _ReminderScheduler(ReminderScheduleResult.scheduled);
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        _taskEditorApp(
          repository: repository,
          scheduler: scheduler,
          now: now,
          child: const TaskEditorPage.edit(taskId: 'editor-task'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Zum Zeitpunkt'), findsOneWidget);
      await tester.enterText(
        find.byKey(const Key('task-title')),
        'Updated reply',
      );
      await tester.tap(find.byKey(const Key('task-save')));
      await tester.pumpAndSettle();

      expect(repository.saved?.reminderMinutesBefore, 0);
      expect(scheduler.scheduled, hasLength(1));
    },
  );

  testWidgets(
    'Edit Task renders 60 minutes and preserves it through All Day toggles',
    (tester) async {
      final now = DateTime(2026, 9, 21, 8);
      final repository = _TaskRepository(
        _taskForEditor(now, reminderMinutesBefore: 60),
      );
      final scheduler = _ReminderScheduler(ReminderScheduleResult.scheduled);
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        _taskEditorApp(
          repository: repository,
          scheduler: scheduler,
          now: now,
          child: const TaskEditorPage.edit(taskId: 'editor-task'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Eine Stunde vorher'), findsOneWidget);
      await tester.tap(find.byKey(const Key('task-all-day')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('task-all-day')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('task-save')));
      await tester.pumpAndSettle();

      expect(repository.saved?.reminderMinutesBefore, 60);
    },
  );
}

Future<void> _selectReminder(WidgetTester tester, String optionName) async {
  await tester.tap(find.byKey(const Key('task-reminder')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key('task-reminder-option-$optionName')));
  await tester.pumpAndSettle();
}

LocalTask _taskForEditor(DateTime now, {int? reminderMinutesBefore}) =>
    LocalTask(
      id: 'editor-task',
      title: 'Reply',
      status: TaskStatus.open,
      provenance: TaskProvenance.user,
      createdAt: now,
      updatedAt: now,
      dueAt: DateTime(2026, 9, 22),
      allDay: false,
      dueTimeMinutes: 9 * 60,
      reminderMinutesBefore: reminderMinutesBefore,
    );

Widget _taskEditorApp({
  required _TaskRepository repository,
  required _ReminderScheduler scheduler,
  required DateTime now,
  required Widget child,
}) => ProviderScope(
  overrides: [
    taskRepositoryProvider.overrideWithValue(repository),
    reminderSchedulerProvider.overrideWithValue(scheduler),
    taskReminderReconcilerProvider.overrideWithValue(
      TaskReminderReconciler(scheduler, now: () => now),
    ),
    currentTimeProvider.overrideWithValue(now),
    allDocumentsProvider.overrideWithValue(
      const AsyncValue.data(<LocalDocument>[]),
    ),
    casesProvider.overrideWithValue(const AsyncValue.data(<Case>[])),
  ],
  child: MaterialApp(
    key: UniqueKey(),
    locale: const Locale('de'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.light(),
    home: child,
  ),
);

class _TaskRepository implements TaskRepository {
  _TaskRepository(this.task);
  final LocalTask task;
  LocalTask? saved;
  var saves = 0;
  ({String id, TaskStatus status, DateTime updatedAt})? statusUpdate;
  @override
  Future<void> delete(String taskId) async {}
  @override
  Future<LocalTask?> getById(String taskId) async => task;
  @override
  Future<LocalTask?> findBySourceAction(
    String sourceAnalysisId,
    String sourceActionKey,
  ) async => null;
  @override
  Future<void> save(LocalTask task) async {
    saves++;
    saved = task;
  }

  @override
  Future<void> updateStatus(
    String taskId,
    TaskStatus status,
    DateTime updatedAt,
  ) async {
    statusUpdate = (id: taskId, status: status, updatedAt: updatedAt);
  }

  @override
  Stream<List<LocalTask>> watchCompleted() => Stream.value([]);
  @override
  Stream<List<LocalTask>> watchOpen() => Stream.value([]);
}

class _FixedIdGenerator implements IdGenerator {
  const _FixedIdGenerator();
  @override
  String newId() => 'new-task';
}

class _ReminderScheduler implements ReminderScheduler {
  _ReminderScheduler(this.result);
  final ReminderScheduleResult result;
  final scheduled = <({String taskId, DateTime at})>[];

  @override
  Future<ReminderScheduleResult> cancel(String taskId) async =>
      ReminderScheduleResult.cancelled;

  @override
  Future<ReminderScheduleResult> schedule({
    required String taskId,
    required DateTime at,
    required String taskTitle,
  }) async {
    scheduled.add((taskId: taskId, at: at));
    return result;
  }
}
