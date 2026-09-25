import 'package:doxary/app/providers.dart';
import 'package:doxary/core/notifications/reminder_scheduler.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:doxary/features/settings/domain/settings_repository.dart';
import 'package:doxary/features/tasks/domain/repositories/task_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('missing and invalid preferences default to enabled', () async {
    for (final initial in <Map<String, String>>[
      <String, String>{},
      <String, String>{taskRemindersEnabledSettingKey: 'invalid'},
    ]) {
      final container = _container(settings: _MemorySettings(initial));
      addTearDown(container.dispose);

      expect(await container.read(taskRemindersEnabledProvider.future), isTrue);
    }
  });

  test('valid persisted values restore enabled and disabled state', () async {
    for (final entry in [('true', true), ('false', false)]) {
      final container = _container(
        settings: _MemorySettings({taskRemindersEnabledSettingKey: entry.$1}),
      );
      addTearDown(container.dispose);

      expect(
        await container.read(taskRemindersEnabledProvider.future),
        entry.$2,
      );
    }
  });

  test(
    'toggle writes stable values and survives provider recreation',
    () async {
      final settings = _MemorySettings();
      final first = _container(settings: settings);
      expect(await first.read(taskRemindersEnabledProvider.future), isTrue);
      await first.read(taskRemindersEnabledProvider.notifier).setEnabled(false);
      expect(settings.values[taskRemindersEnabledSettingKey], 'false');
      first.dispose();

      final restarted = _container(settings: settings);
      addTearDown(restarted.dispose);
      expect(
        await restarted.read(taskRemindersEnabledProvider.future),
        isFalse,
      );
      await restarted
          .read(taskRemindersEnabledProvider.notifier)
          .setEnabled(true);
      expect(settings.values[taskRemindersEnabledSettingKey], 'true');
      expect(restarted.read(taskRemindersEnabledProvider).requireValue, isTrue);
    },
  );

  test(
    'disabling cancels Task notifications without clearing reminder intent',
    () async {
      final task = _task(id: 'open-task', reminderMinutesBefore: 30);
      final completed = _task(
        id: 'completed-task',
        status: TaskStatus.completed,
        reminderMinutesBefore: 10,
      );
      final settings = _MemorySettings();
      final scheduler = _RecordingScheduler();
      scheduler.scheduled['open-task'] = DateTime(2030, 1, 1);
      scheduler.scheduled['completed-task'] = DateTime(2030, 1, 1);
      final container = _container(
        settings: settings,
        tasks: _FakeTaskRepository(open: [task], completed: [completed]),
        scheduler: scheduler,
      );
      addTearDown(container.dispose);
      await container.read(taskRemindersEnabledProvider.future);

      final complete = await container
          .read(taskRemindersEnabledProvider.notifier)
          .setEnabled(false);

      expect(complete, isTrue);
      expect(scheduler.cancelled, containsAll(['open-task', 'completed-task']));
      expect(scheduler.scheduled, isEmpty);
      expect(task.reminderMinutesBefore, 30);
      expect(completed.reminderMinutesBefore, 10);
      expect(settings.values[taskRemindersEnabledSettingKey], 'false');
    },
  );

  test(
    'cancellation failure is reported while the preference remains off',
    () async {
      final settings = _MemorySettings();
      final scheduler = _RecordingScheduler(
        cancelResult: ReminderScheduleResult.platformFailure,
      );
      final container = _container(
        settings: settings,
        tasks: _FakeTaskRepository(
          open: [_task(id: 'task', reminderMinutesBefore: 30)],
        ),
        scheduler: scheduler,
      );
      addTearDown(container.dispose);
      await container.read(taskRemindersEnabledProvider.future);

      final reconciled = await container
          .read(taskRemindersEnabledProvider.notifier)
          .setEnabled(false);

      expect(reconciled, isFalse);
      expect(settings.values[taskRemindersEnabledSettingKey], 'false');
      expect(
        container.read(taskRemindersEnabledProvider).requireValue,
        isFalse,
      );
    },
  );

  test(
    'enabling schedules only eligible open Tasks without prompting',
    () async {
      final future = _task(id: 'future', reminderMinutesBefore: 30);
      final past = _task(
        id: 'past',
        dueAt: DateTime(2020, 1, 1),
        reminderMinutesBefore: 0,
      );
      final noReminder = _task(id: 'none', reminderMinutesBefore: null);
      final completed = _task(
        id: 'completed',
        status: TaskStatus.completed,
        reminderMinutesBefore: 10,
      );
      final scheduler = _RecordingScheduler();
      final container = _container(
        settings: _MemorySettings({taskRemindersEnabledSettingKey: 'false'}),
        tasks: _FakeTaskRepository(
          open: [future, past, noReminder],
          completed: [completed],
        ),
        scheduler: scheduler,
      );
      addTearDown(container.dispose);
      await container.read(taskRemindersEnabledProvider.future);

      final complete = await container
          .read(taskRemindersEnabledProvider.notifier)
          .setEnabled(true);

      expect(complete, isTrue);
      expect(scheduler.scheduled.keys.toList(), ['future']);
      expect(scheduler.scheduled.containsKey('past'), isFalse);
      expect(scheduler.scheduled.containsKey('none'), isFalse);
      expect(scheduler.scheduled.containsKey('completed'), isFalse);
      expect(scheduler.permissionRequestValues, everyElement(isFalse));
      expect(past.reminderMinutesBefore, 0);
      expect(noReminder.reminderMinutesBefore, isNull);
    },
  );

  test('denied OS permission leaves the Doxary preference enabled', () async {
    final scheduler = _RecordingScheduler(
      result: ReminderScheduleResult.permissionDenied,
      permissionStatus: ReminderPermissionStatus.notAllowed,
    );
    final settings = _MemorySettings({taskRemindersEnabledSettingKey: 'false'});
    final container = _container(
      settings: settings,
      tasks: _FakeTaskRepository(open: [_task(reminderMinutesBefore: 30)]),
      scheduler: scheduler,
    );
    addTearDown(container.dispose);
    await container.read(taskRemindersEnabledProvider.future);

    expect(
      await container.read(taskReminderPermissionStatusProvider.future),
      ReminderPermissionStatus.notAllowed,
    );
    await container
        .read(taskRemindersEnabledProvider.notifier)
        .setEnabled(true);

    expect(settings.values[taskRemindersEnabledSettingKey], 'true');
    expect(container.read(taskRemindersEnabledProvider).requireValue, isTrue);
    expect(scheduler.permissionRequestValues, [false]);
  });
}

ProviderContainer _container({
  required _MemorySettings settings,
  _FakeTaskRepository? tasks,
  _RecordingScheduler? scheduler,
}) => ProviderContainer(
  overrides: [
    settingsRepositoryProvider.overrideWithValue(settings),
    taskRepositoryProvider.overrideWithValue(tasks ?? _FakeTaskRepository()),
    reminderSchedulerProvider.overrideWithValue(
      scheduler ?? _RecordingScheduler(),
    ),
  ],
);

LocalTask _task({
  String id = 'task',
  TaskStatus status = TaskStatus.open,
  DateTime? dueAt,
  int? reminderMinutesBefore,
}) {
  final now = DateTime.now();
  return LocalTask(
    id: id,
    title: 'Task title',
    status: status,
    provenance: TaskProvenance.user,
    createdAt: now,
    updatedAt: now,
    dueAt: dueAt ?? DateTime.now().add(const Duration(days: 4)),
    allDay: false,
    dueTimeMinutes: 10 * 60,
    reminderMinutesBefore: reminderMinutesBefore,
  );
}

class _MemorySettings implements SettingsRepository {
  _MemorySettings([Map<String, String>? values]) : values = {...?values};

  final Map<String, String> values;

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }
}

class _FakeTaskRepository implements TaskRepository {
  _FakeTaskRepository({this.open = const [], this.completed = const []});

  final List<LocalTask> open;
  final List<LocalTask> completed;

  @override
  Stream<List<LocalTask>> watchOpen() => Stream.value(open);

  @override
  Stream<List<LocalTask>> watchCompleted() => Stream.value(completed);

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
  Future<void> delete(String taskId) async {}
}

class _RecordingScheduler
    implements ReminderScheduler, ReminderPermissionReader {
  _RecordingScheduler({
    this.result = ReminderScheduleResult.scheduled,
    this.permissionStatus = ReminderPermissionStatus.allowed,
    this.cancelResult = ReminderScheduleResult.cancelled,
  });

  final ReminderScheduleResult result;
  final ReminderScheduleResult cancelResult;
  final ReminderPermissionStatus permissionStatus;
  final scheduled = <String, DateTime>{};
  final cancelled = <String>[];
  final permissionRequestValues = <bool>[];

  @override
  Future<ReminderPermissionStatus> readPermissionStatus() async =>
      permissionStatus;

  @override
  Future<ReminderScheduleResult> schedule({
    required String taskId,
    required DateTime at,
    required String taskTitle,
    bool requestPermission = true,
  }) async {
    permissionRequestValues.add(requestPermission);
    if (result == ReminderScheduleResult.scheduled) {
      scheduled[taskId] = at;
    }
    return result;
  }

  @override
  Future<ReminderScheduleResult> cancel(String taskId) async {
    cancelled.add(taskId);
    if (cancelResult == ReminderScheduleResult.cancelled) {
      scheduled.remove(taskId);
    }
    return cancelResult;
  }
}
