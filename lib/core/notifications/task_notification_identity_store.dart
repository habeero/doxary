/// Private platform metadata for mapping a durable Task identity to the
/// integer identifier required by local-notification APIs.
abstract interface class TaskNotificationIdentityStore {
  Future<int> resolve(String taskId);
  Future<int?> existing(String taskId);
}
