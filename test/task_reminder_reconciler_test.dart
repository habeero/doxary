import 'package:doxary/core/notifications/reminder_scheduler.dart';
import 'package:doxary/core/notifications/local_task_notification_identity_store.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:doxary/features/tasks/application/task_reminder_reconciler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 9, 21, 8);

  test('Timed Task schedules at local due time minus its reminder lead', () async {
    final scheduler = _FakeScheduler();
    final reconciler = TaskReminderReconciler(scheduler, now: () => now);

    final outcome = await reconciler.reconcile(_task(
      dueAt: DateTime(2026, 9, 22),
      dueTimeMinutes: 10 * 60 + 30,
      reminderMinutesBefore: 90,
    ));

    expect(outcome, TaskReminderOutcome.scheduled);
    expect(scheduler.scheduled['task-1']?.at, DateTime(2026, 9, 22, 9));
  });

  test('Only null is no reminder; zero remains an active timed reminder', () async {
    final scheduler = _FakeScheduler();
    final reconciler = TaskReminderReconciler(scheduler, now: () => now);

    expect(
      await reconciler.reconcile(_task(reminderMinutesBefore: null)),
      TaskReminderOutcome.noReminder,
    );
    expect(
      await reconciler.reconcile(_task(
        dueAt: DateTime(2026, 9, 22),
        dueTimeMinutes: 9 * 60,
        reminderMinutesBefore: 0,
      )),
      TaskReminderOutcome.scheduled,
    );
    expect(scheduler.scheduled['task-1']?.at, DateTime(2026, 9, 22, 9));
  });

  test('Repeated save and edits reconcile one Task-owned reminder', () async {
    final scheduler = _FakeScheduler();
    final reconciler = TaskReminderReconciler(scheduler, now: () => now);
    final original = _task(
      dueAt: DateTime(2026, 9, 24),
      dueTimeMinutes: 9 * 60,
      reminderMinutesBefore: 0,
    );

    await reconciler.reconcile(original);
    await reconciler.reconcile(original);
    await reconciler.reconcile(_task(
      dueAt: DateTime(2026, 9, 25),
      dueTimeMinutes: 11 * 60,
      reminderMinutesBefore: 60,
    ));

    expect(scheduler.scheduled, hasLength(1));
    expect(scheduler.scheduled['task-1']?.at, DateTime(2026, 9, 25, 10));
  });

  test('Removing a reminder, completing, and deleting cancel delivery', () async {
    final scheduler = _FakeScheduler();
    final reconciler = TaskReminderReconciler(scheduler, now: () => now);
    final reminder = _task(
      dueAt: DateTime(2026, 9, 24),
      dueTimeMinutes: 9 * 60,
      reminderMinutesBefore: 0,
    );

    await reconciler.reconcile(reminder);
    expect(
      await reconciler.reconcile(_task(reminderMinutesBefore: null)),
      TaskReminderOutcome.noReminder,
    );
    expect(
      await reconciler.reconcile(_task(
        status: TaskStatus.completed,
        reminderMinutesBefore: 0,
      )),
      TaskReminderOutcome.cancelled,
    );
    await reconciler.cancel('task-1');

    expect(scheduler.cancelled, ['task-1', 'task-1', 'task-1']);
  });

  test('Reopening only schedules a reminder whose local instant is future', () async {
    final scheduler = _FakeScheduler();
    final reconciler = TaskReminderReconciler(scheduler, now: () => now);

    expect(
      await reconciler.reconcile(_task(
        dueAt: DateTime(2026, 9, 20),
        dueTimeMinutes: 9 * 60,
        reminderMinutesBefore: 0,
      )),
      TaskReminderOutcome.reminderTimePassed,
    );
    expect(
      await reconciler.reconcile(_task(
        dueAt: DateTime(2026, 9, 22),
        dueTimeMinutes: 9 * 60,
        reminderMinutesBefore: 0,
      )),
      TaskReminderOutcome.scheduled,
    );
  });

  test('All Day reminder at due time uses the 09:00 local MVP anchor', () async {
    final scheduler = _FakeScheduler();
    final reconciler = TaskReminderReconciler(scheduler, now: () => now);
    final allDay = _task(
      dueAt: DateTime(2026, 10, 10),
      allDay: true,
      dueTimeMinutes: null,
      reminderMinutesBefore: 0,
    );

    expect(await reconciler.reconcile(allDay), TaskReminderOutcome.scheduled);
    expect(scheduler.scheduled['task-1']?.at, DateTime(2026, 10, 10, 9));
  });

  test('All Day reminder lead time is applied to the 09:00 local anchor', () async {
    final scheduler = _FakeScheduler();
    final reconciler = TaskReminderReconciler(scheduler, now: () => now);

    await reconciler.reconcile(_task(
      dueAt: DateTime(2026, 10, 10),
      allDay: true,
      dueTimeMinutes: null,
      reminderMinutesBefore: 60,
    ));
    expect(scheduler.scheduled['task-1']?.at, DateTime(2026, 10, 10, 8));

    await reconciler.reconcile(_task(
      dueAt: DateTime(2026, 10, 10),
      allDay: true,
      dueTimeMinutes: null,
      reminderMinutesBefore: 1440,
    ));
    expect(scheduler.scheduled['task-1']?.at, DateTime(2026, 10, 9, 9));
  });

  test('All Day anchor remains a local 09:00 time across DST dates', () async {
    final scheduler = _FakeScheduler();
    final reconciler = TaskReminderReconciler(scheduler, now: () => now);

    await reconciler.reconcile(_task(
      dueAt: DateTime(2027, 3, 28),
      allDay: true,
      dueTimeMinutes: null,
      reminderMinutesBefore: 0,
    ));

    final scheduledAt = scheduler.scheduled['task-1']!.at;
    expect(scheduledAt, DateTime(2027, 3, 28, 9));
    expect(scheduledAt.isUtc, isFalse);
  });

  test('Past All Day reminder remains unscheduled and preserves intent', () async {
    final scheduler = _FakeScheduler();
    final reconciler = TaskReminderReconciler(scheduler, now: () => now);
    final allDay = _task(
      dueAt: DateTime(2026, 9, 20),
      allDay: true,
      dueTimeMinutes: null,
      reminderMinutesBefore: 0,
    );

    expect(
      await reconciler.reconcile(allDay),
      TaskReminderOutcome.reminderTimePassed,
    );
    expect(allDay.reminderMinutesBefore, 0);
    expect(scheduler.scheduled, isEmpty);
  });

  test('Timed and All Day transitions replace the same Task reminder', () async {
    final scheduler = _FakeScheduler();
    final reconciler = TaskReminderReconciler(scheduler, now: () => now);

    await reconciler.reconcile(_task(
      dueAt: DateTime(2026, 9, 25),
      dueTimeMinutes: 14 * 60,
      reminderMinutesBefore: 0,
    ));
    await reconciler.reconcile(_task(
      dueAt: DateTime(2026, 9, 25),
      allDay: true,
      dueTimeMinutes: null,
      reminderMinutesBefore: 0,
    ));
    expect(scheduler.scheduled['task-1']?.at, DateTime(2026, 9, 25, 9));

    await reconciler.reconcile(_task(
      dueAt: DateTime(2026, 9, 25),
      dueTimeMinutes: 16 * 60 + 30,
      reminderMinutesBefore: 0,
    ));
    expect(scheduler.scheduled['task-1']?.at, DateTime(2026, 9, 25, 16, 30));
    expect(scheduler.scheduled, hasLength(1));
  });

  test('All Day save, edits, removal, completion, reopen, and delete reconcile', () async {
    final scheduler = _FakeScheduler();
    final reconciler = TaskReminderReconciler(scheduler, now: () => now);
    final initial = _task(
      dueAt: DateTime(2026, 10, 10),
      allDay: true,
      reminderMinutesBefore: 0,
    );

    await reconciler.reconcile(initial);
    await reconciler.reconcile(initial);
    expect(scheduler.scheduled, hasLength(1));
    expect(scheduler.scheduled['task-1']?.at, DateTime(2026, 10, 10, 9));

    await reconciler.reconcile(_task(
      dueAt: DateTime(2026, 10, 11),
      allDay: true,
      reminderMinutesBefore: 60,
    ));
    expect(scheduler.scheduled['task-1']?.at, DateTime(2026, 10, 11, 8));

    expect(
      await reconciler.reconcile(_task(allDay: true, reminderMinutesBefore: null)),
      TaskReminderOutcome.noReminder,
    );
    expect(
      await reconciler.reconcile(_task(
        allDay: true,
        status: TaskStatus.completed,
        reminderMinutesBefore: 0,
      )),
      TaskReminderOutcome.cancelled,
    );
    expect(
      await reconciler.reconcile(_task(
        dueAt: DateTime(2026, 10, 12),
        allDay: true,
        reminderMinutesBefore: 0,
      )),
      TaskReminderOutcome.scheduled,
    );
    expect(
      await reconciler.reconcile(_task(
        dueAt: DateTime(2026, 9, 20),
        allDay: true,
        reminderMinutesBefore: 0,
      )),
      TaskReminderOutcome.reminderTimePassed,
    );
    await reconciler.cancel('task-1');

    expect(scheduler.cancelled, hasLength(4));
  });

  test('Permission and platform failures are typed and do not escape', () async {
    final denied = _FakeScheduler(result: ReminderScheduleResult.permissionDenied);
    final failed = _FakeScheduler(result: ReminderScheduleResult.platformFailure);
    final task = _task(
      dueAt: DateTime(2026, 9, 22),
      dueTimeMinutes: 9 * 60,
      reminderMinutesBefore: 0,
    );

    expect(
      await TaskReminderReconciler(denied, now: () => now).reconcile(task),
      TaskReminderOutcome.permissionDenied,
    );
    expect(
      await TaskReminderReconciler(failed, now: () => now).reconcile(task),
      TaskReminderOutcome.platformFailure,
    );
    expect(
      await TaskReminderReconciler(
        _ThrowingScheduler(),
        now: () => now,
      ).reconcile(task),
      TaskReminderOutcome.platformFailure,
    );
  });

  test('One Task cannot cancel or replace another Task reminder', () async {
    final scheduler = _FakeScheduler();
    final reconciler = TaskReminderReconciler(scheduler, now: () => now);
    await reconciler.reconcile(_task(
      id: 'task-1',
      dueAt: DateTime(2026, 9, 22),
      dueTimeMinutes: 9 * 60,
      reminderMinutesBefore: 0,
    ));
    await reconciler.reconcile(_task(
      id: 'task-2',
      dueAt: DateTime(2026, 9, 23),
      dueTimeMinutes: 9 * 60,
      reminderMinutesBefore: 0,
    ));
    await reconciler.cancel('task-1');

    expect(scheduler.scheduled.keys, containsAll(['task-1', 'task-2']));
    expect(scheduler.cancelled, ['task-1']);
  });

  test('Platform notification identity is deterministic and task-specific', () {
    expect(
      LocalTaskNotificationIdentityStore.notificationIdSeed('task-1'),
      LocalTaskNotificationIdentityStore.notificationIdSeed('task-1'),
    );
    expect(
      LocalTaskNotificationIdentityStore.notificationIdSeed('task-1'),
      isNot(LocalTaskNotificationIdentityStore.notificationIdSeed('task-2')),
    );
  });
}

LocalTask _task({
  String id = 'task-1',
  TaskStatus status = TaskStatus.open,
  DateTime? dueAt,
  bool allDay = false,
  int? dueTimeMinutes,
  int? reminderMinutesBefore,
}) {
  final createdAt = DateTime(2026, 9, 1);
  return LocalTask(
    id: id,
    title: 'Reply to Doxary',
    status: status,
    provenance: TaskProvenance.user,
    createdAt: createdAt,
    updatedAt: createdAt,
    dueAt: dueAt ?? DateTime(2026, 9, 25),
    allDay: allDay,
    dueTimeMinutes: allDay ? null : (dueTimeMinutes ?? 9 * 60),
    reminderMinutesBefore: reminderMinutesBefore,
  );
}

class _FakeScheduler implements ReminderScheduler {
  _FakeScheduler({this.result = ReminderScheduleResult.scheduled});
  final ReminderScheduleResult result;
  final scheduled = <String, ({DateTime at, String title})>{};
  final cancelled = <String>[];

  @override
  Future<ReminderScheduleResult> cancel(String taskId) async {
    cancelled.add(taskId);
    return ReminderScheduleResult.cancelled;
  }

  @override
  Future<ReminderScheduleResult> schedule({
    required String taskId,
    required DateTime at,
    required String taskTitle,
  }) async {
    if (result == ReminderScheduleResult.scheduled) {
      scheduled[taskId] = (at: at, title: taskTitle);
    }
    return result;
  }
}

class _ThrowingScheduler implements ReminderScheduler {
  @override
  Future<ReminderScheduleResult> cancel(String taskId) =>
      throw StateError('platform failure');

  @override
  Future<ReminderScheduleResult> schedule({
    required String taskId,
    required DateTime at,
    required String taskTitle,
  }) => throw StateError('platform failure');
}
