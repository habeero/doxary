import '../../documents/domain/entities/domain_entities.dart';
import '../domain/repositories/task_repository.dart';
import 'task_reminder_reconciler.dart';

/// Reuses the authoritative local Task lifecycle from every presentation
/// surface without exposing repository or reminder details to those screens.
class TaskLifecycle {
  TaskLifecycle(this._repository, this._reminders);

  final TaskRepository _repository;
  final TaskReminderReconciler _reminders;

  Future<void> complete(LocalTask task, DateTime updatedAt) => _updateStatus(
    task,
    TaskStatus.completed,
    updatedAt,
  );

  Future<void> reopen(LocalTask task, DateTime updatedAt) => _updateStatus(
    task,
    TaskStatus.open,
    updatedAt,
  );

  Future<void> delete(LocalTask task) async {
    // Platform cleanup is best effort and never prevents local deletion.
    await _reminders.cancel(task.id);
    await _repository.delete(task.id);
  }

  Future<void> _updateStatus(
    LocalTask task,
    TaskStatus status,
    DateTime updatedAt,
  ) async {
    await _repository.updateStatus(task.id, status, updatedAt);
    await _reminders.reconcile(_withStatus(task, status, updatedAt));
  }
}

LocalTask _withStatus(
  LocalTask task,
  TaskStatus status,
  DateTime updatedAt,
) => LocalTask(
  id: task.id,
  title: task.title,
  status: status,
  provenance: task.provenance,
  createdAt: task.createdAt,
  updatedAt: updatedAt,
  dueAt: task.dueAt,
  allDay: task.allDay,
  dueTimeMinutes: task.dueTimeMinutes,
  reminderMinutesBefore: task.reminderMinutesBefore,
  note: task.note,
  clientDocumentId: task.clientDocumentId,
  caseId: task.caseId,
  sourceAnalysisId: task.sourceAnalysisId,
  sourceActionKey: task.sourceActionKey,
);
