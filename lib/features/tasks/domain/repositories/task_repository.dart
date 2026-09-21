import '../../../documents/domain/entities/domain_entities.dart';

abstract interface class TaskRepository {
  Stream<List<LocalTask>> watchOpen();
  Stream<List<LocalTask>> watchCompleted();
  Future<LocalTask?> getById(String taskId);
  Future<void> save(LocalTask task);
  Future<void> updateStatus(
    String taskId,
    TaskStatus status,
    DateTime updatedAt,
  );
  Future<void> delete(String taskId);
}
