import 'package:doxary/app/localization/app_localizations.dart';
import 'package:doxary/app/providers.dart';
import 'package:doxary/app/routing/task_notification_intent.dart';
import 'package:doxary/app/routing/task_notification_intent_handler.dart';
import 'package:doxary/core/notifications/task_notification_payload.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:doxary/features/tasks/domain/repositories/task_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('Task reminder payload is only the opaque Task identity', () {
    expect(taskReminderPayload('opaque-task-identity'), 'opaque-task-identity');
    expect(
      TaskNotificationIntent.fromPayload(taskReminderPayload('task-1')).taskId,
      'task-1',
    );
  });

  testWidgets(
    'cold-start intent waits for the shell and opens an overdue Task',
    (tester) async {
      final task = _task('open-task', dueAt: DateTime(2026, 9, 24));
      final repository = _TaskRepository({'open-task': task});
      final container = _container(repository);
      final router = _router();
      _registerCleanup(tester, container, router);

      container
          .read(taskNotificationIntentProvider.notifier)
          .receivePayload('open-task');
      container
          .read(taskNotificationIntentProvider.notifier)
          .receivePayload('open-task');
      await _mount(tester, container: container, router: router);

      expect(find.byKey(const Key('notification-task-detail')), findsOneWidget);
      expect(repository.readCount, 1);
      expect(
        router.routeInformationProvider.value.uri.path,
        '/tasks/open-task',
      );
      expect(find.text('open-task'), findsNothing);
    },
  );

  testWidgets('completed Task reminder opens the same Task Detail route', (
    tester,
  ) async {
    final task = _task('completed-task', status: TaskStatus.completed);
    final repository = _TaskRepository({'completed-task': task});
    final container = _container(repository);
    final router = _router();
    _registerCleanup(tester, container, router);

    await _mount(tester, container: container, router: router);
    container
        .read(taskNotificationIntentProvider.notifier)
        .receivePayload('completed-task');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('notification-task-detail')), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      '/tasks/completed-task',
    );
  });

  testWidgets('running response and duplicate callback navigate only once', (
    tester,
  ) async {
    final repository = _TaskRepository({'running-task': _task('running-task')});
    final container = _container(repository);
    final router = _router();
    _registerCleanup(tester, container, router);

    await _mount(tester, container: container, router: router);
    final intents = container.read(taskNotificationIntentProvider.notifier);
    intents.receivePayload('running-task');
    await tester.pumpAndSettle();
    intents.receivePayload('running-task');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('notification-task-detail')), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      '/tasks/running-task',
    );
    expect(repository.readCount, 2);
  });

  testWidgets('missing Task shows one localized dialog with only OK', (
    tester,
  ) async {
    final repository = _TaskRepository({});
    final container = _container(repository);
    final router = _router();
    _registerCleanup(tester, container, router);

    await _mount(tester, container: container, router: router);
    final intents = container.read(taskNotificationIntentProvider.notifier);
    intents.receivePayload('deleted-task-id');
    intents.receivePayload('deleted-task-id');
    await tester.pumpAndSettle();

    final l10n = AppLocalizations(const Locale('de'));
    expect(find.text(l10n.taskNoLongerAvailable), findsOneWidget);
    expect(find.text(l10n.ok), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);
    expect(find.text('deleted-task-id'), findsNothing);
    expect(router.routeInformationProvider.value.uri.path, '/tasks');

    await tester.tap(find.text(l10n.ok));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('notification-tasks-root')), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('missing Task message is Arabic and the dialog is RTL', (
    tester,
  ) async {
    final container = _container(_TaskRepository({}));
    final router = _router();
    _registerCleanup(tester, container, router);

    await _mount(
      tester,
      container: container,
      router: router,
      locale: const Locale('ar'),
    );
    container
        .read(taskNotificationIntentProvider.notifier)
        .receivePayload('removed-task');
    await tester.pumpAndSettle();

    final message = AppLocalizations(const Locale('ar')).taskNoLongerAvailable;
    expect(find.text(message), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(AlertDialog))),
      TextDirection.rtl,
    );
  });

  testWidgets('invalid and legacy payload safely open Tasks without a dialog', (
    tester,
  ) async {
    final container = _container(_TaskRepository({}));
    final router = _router();
    _registerCleanup(tester, container, router);

    await _mount(tester, container: container, router: router);
    final intents = container.read(taskNotificationIntentProvider.notifier);
    intents.receivePayload(null);
    await tester.pumpAndSettle();
    intents.receivePayload('bad\npayload');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('notification-tasks-root')), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });
}

ProviderContainer _container(_TaskRepository repository) => ProviderContainer(
  overrides: [taskRepositoryProvider.overrideWithValue(repository)],
);

void _registerCleanup(
  WidgetTester tester,
  ProviderContainer container,
  GoRouter router,
) {
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    router.dispose();
    container.dispose();
  });
}

GoRouter _router() => GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          Scaffold(body: TaskNotificationIntentHandler(child: child)),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Text('Home root'),
        ),
        GoRoute(
          path: '/tasks',
          builder: (context, state) =>
              const Text('Tasks root', key: Key('notification-tasks-root')),
        ),
        GoRoute(
          path: '/tasks/:taskId',
          builder: (context, state) =>
              const Text('Task Detail', key: Key('notification-task-detail')),
        ),
      ],
    ),
  ],
);

Future<void> _mount(
  WidgetTester tester, {
  required ProviderContainer container,
  required GoRouter router,
  Locale locale = const Locale('de'),
}) async {
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

LocalTask _task(
  String id, {
  TaskStatus status = TaskStatus.open,
  DateTime? dueAt,
}) => LocalTask(
  id: id,
  title: 'A private title',
  status: status,
  provenance: TaskProvenance.user,
  createdAt: DateTime(2026, 9, 25),
  updatedAt: DateTime(2026, 9, 25),
  dueAt: dueAt,
);

class _TaskRepository implements TaskRepository {
  _TaskRepository(this.tasks);

  final Map<String, LocalTask> tasks;
  int readCount = 0;

  @override
  Stream<List<LocalTask>> watchOpen() => Stream.value(
    tasks.values.where((task) => task.status == TaskStatus.open).toList(),
  );

  @override
  Stream<List<LocalTask>> watchCompleted() => Stream.value(
    tasks.values.where((task) => task.status == TaskStatus.completed).toList(),
  );

  @override
  Future<LocalTask?> getById(String taskId) async {
    readCount++;
    return tasks[taskId];
  }

  @override
  Future<LocalTask?> findBySourceAction(
    String sourceAnalysisId,
    String sourceActionKey,
  ) async => null;

  @override
  Future<void> save(LocalTask task) async {
    tasks[task.id] = task;
  }

  @override
  Future<void> updateStatus(
    String taskId,
    TaskStatus status,
    DateTime updatedAt,
  ) async {}

  @override
  Future<void> delete(String taskId) async {
    tasks.remove(taskId);
  }
}
