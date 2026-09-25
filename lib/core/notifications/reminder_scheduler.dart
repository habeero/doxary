/// Platform outcomes intentionally avoid exposing plugin exceptions to callers.
enum ReminderScheduleResult {
  scheduled,
  cancelled,
  permissionDenied,
  unavailable,
  platformFailure,
}

enum ReminderPermissionStatus { allowed, notAllowed, unavailable }

abstract interface class ReminderPermissionReader {
  Future<ReminderPermissionStatus> readPermissionStatus();
}

abstract interface class ReminderScheduler {
  Future<ReminderScheduleResult> schedule({
    required String taskId,
    required DateTime at,
    required String taskTitle,
    bool requestPermission = true,
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
    bool requestPermission = true,
  }) async => ReminderScheduleResult.unavailable;
}
