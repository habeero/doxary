import '../../../documents/domain/entities/domain_entities.dart';

abstract interface class TaskRepository {
  Stream<List<LocalTask>> watchOpen();
  Stream<List<LocalTask>> watchCompleted();
  Future<void> save(LocalTask task);
  Future<void> updateStatus(
    String taskId,
    TaskStatus status,
    DateTime updatedAt,
  );
}
