/// Platform outcomes intentionally avoid exposing plugin exceptions to callers.
enum ReminderScheduleResult {
  scheduled,
  cancelled,
  permissionDenied,
  unavailable,
  platformFailure,
}

abstract interface class ReminderScheduler {
  Future<ReminderScheduleResult> schedule({
    required String taskId,
    required DateTime at,
    required String taskTitle,
  });
  Future<ReminderScheduleResult> cancel(String taskId);
}

class UnavailableReminderScheduler implements ReminderScheduler {
  @override
  Future<ReminderScheduleResult> cancel(String taskId) async =>
      ReminderScheduleResult.unavailable;
  @override
  Future<ReminderScheduleResult> schedule({
    required String taskId,
    required DateTime at,
    required String taskTitle,
  }) async => ReminderScheduleResult.unavailable;
}
