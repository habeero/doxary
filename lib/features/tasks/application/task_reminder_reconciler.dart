import '../../../core/logging/debug_log.dart';
import '../../../core/notifications/reminder_scheduler.dart';
import '../../documents/domain/entities/domain_entities.dart';

/// Reconciles durable Task reminder intent with the device scheduler.
///
/// A scheduled notification is derived platform state. It never becomes a
/// second durable reminder model and failures never alter the saved Task.
enum TaskReminderOutcome {
  scheduled,
  cancelled,
  noReminder,
  reminderTimePassed,
  permissionDenied,
  unavailable,
  platformFailure,
}

class TaskReminderReconciler {
  /// MVP local-time anchor for an All Day Task reminder. A future Settings
  /// preference may supply this policy without changing Task persistence.
  static const allDayAnchorMinutes = 9 * 60;

  TaskReminderReconciler(this._scheduler, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final ReminderScheduler _scheduler;
  final DateTime Function() _now;

  Future<TaskReminderOutcome> reconcile(LocalTask task) async {
    reminderTaskStateDebugLog(
      'reconciler',
      event: 'entered',
      reminderMinutesBefore: task.reminderMinutesBefore,
      allDay: task.allDay,
      timePresent: task.dueTimeMinutes != null,
      status: task.status.name,
    );
    if (task.status != TaskStatus.open || task.reminderMinutesBefore == null) {
      reminderDebugLog(
        'reconciler',
        'no active reminder; cancelling '
        'statusOpen=${task.status == TaskStatus.open} '
        'reminderPresent=${task.reminderMinutesBefore != null}',
      );
      return _cancel(task.id, noReminder: task.reminderMinutesBefore == null);
    }

    final reminderAt = reminderInstant(task);
    if (reminderAt == null || !reminderAt.isAfter(_now())) {
      reminderDebugLog('reconciler', 'reminder time unavailable or passed; cancelling');
      await _cancelPlatform(task.id);
      return TaskReminderOutcome.reminderTimePassed;
    }

    reminderDebugLog('reconciler', 'future reminder; scheduling requested');
    final result = await _schedulePlatform(task, reminderAt);
    reminderDebugLog('reconciler', 'scheduler result=${result.name}');
    return _fromSchedule(result);
  }

  Future<TaskReminderOutcome> cancel(String taskId) => _cancel(taskId);

  static DateTime? reminderInstant(LocalTask task) {
    final dueDate = task.dueAt;
    final dueTime = task.allDay ? allDayAnchorMinutes : task.dueTimeMinutes;
    final lead = task.reminderMinutesBefore;
    if (dueDate == null || dueTime == null || lead == null) {
      return null;
    }
    final localDue = DateTime(
      dueDate.year,
      dueDate.month,
      dueDate.day,
      dueTime ~/ 60,
      dueTime % 60,
    );
    return localDue.subtract(Duration(minutes: lead));
  }

  Future<TaskReminderOutcome> _cancel(String taskId, {bool noReminder = false}) async {
    final result = await _cancelPlatform(taskId);
    if (noReminder) return TaskReminderOutcome.noReminder;
    if (result == ReminderScheduleResult.cancelled ||
        result == ReminderScheduleResult.scheduled) {
      return TaskReminderOutcome.cancelled;
    }
    return _fromSchedule(result);
  }

  Future<ReminderScheduleResult> _schedulePlatform(
    LocalTask task,
    DateTime reminderAt,
  ) async {
    try {
      return await _scheduler.schedule(
        taskId: task.id,
        at: reminderAt,
        taskTitle: task.title,
      );
    } catch (error) {
      reminderDebugLog('reconciler', 'scheduler threw ${error.runtimeType}');
      return ReminderScheduleResult.platformFailure;
    }
  }

  Future<ReminderScheduleResult> _cancelPlatform(String taskId) async {
    try {
      return await _scheduler.cancel(taskId);
    } catch (error) {
      reminderDebugLog('reconciler', 'cancellation threw ${error.runtimeType}');
      return ReminderScheduleResult.platformFailure;
    }
  }

  TaskReminderOutcome _fromSchedule(ReminderScheduleResult result) => switch (result) {
    ReminderScheduleResult.scheduled => TaskReminderOutcome.scheduled,
    ReminderScheduleResult.cancelled => TaskReminderOutcome.cancelled,
    ReminderScheduleResult.permissionDenied => TaskReminderOutcome.permissionDenied,
    ReminderScheduleResult.unavailable => TaskReminderOutcome.unavailable,
    ReminderScheduleResult.platformFailure => TaskReminderOutcome.platformFailure,
  };
}
