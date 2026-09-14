enum ReminderScheduleResult { scheduled, unavailable, rejected }

abstract interface class ReminderScheduler {
  Future<ReminderScheduleResult> schedule({
    required String taskId,
    required DateTime at,
  });
  Future<void> cancel(String taskId);
}

class UnavailableReminderScheduler implements ReminderScheduler {
  @override
  Future<void> cancel(String taskId) async {}
  @override
  Future<ReminderScheduleResult> schedule({
    required String taskId,
    required DateTime at,
  }) async => ReminderScheduleResult.unavailable;
}
