import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../documents/domain/entities/domain_entities.dart';
import '../../domain/repositories/task_repository.dart';

class LocalTaskRepository implements TaskRepository {
  LocalTaskRepository(this._database);
  final AppDatabase _database;

  @override
  Stream<List<LocalTask>> watchOpen() {
    final query = _database.select(_database.tasks)
      ..where((row) => row.status.equals(TaskStatus.open.name))
      ..orderBy([(row) => OrderingTerm.asc(row.dueAt)]);
    return query.watch().map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Stream<List<LocalTask>> watchCompleted() {
    final query = _database.select(_database.tasks)
      ..where((row) => row.status.equals(TaskStatus.completed.name))
      ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)]);
    return query.watch().map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<void> save(LocalTask task) => _database
      .into(_database.tasks)
      .insertOnConflictUpdate(
        TasksCompanion.insert(
          id: task.id,
          clientDocumentId: Value(task.clientDocumentId),
          caseId: Value(task.caseId),
          title: task.title,
          dueAt: Value(task.dueAt),
          status: task.status.name,
          provenance: task.provenance.name,
          createdAt: task.createdAt,
          updatedAt: task.updatedAt,
        ),
      );

  @override
  Future<void> updateStatus(
    String taskId,
    TaskStatus status,
    DateTime updatedAt,
  ) {
    return (_database.update(
      _database.tasks,
    )..where((row) => row.id.equals(taskId))).write(
      TasksCompanion(status: Value(status.name), updatedAt: Value(updatedAt)),
    );
  }

  LocalTask _toEntity(Task row) => LocalTask(
    id: row.id,
    title: row.title,
    status: TaskStatus.values.byName(row.status),
    provenance: TaskProvenance.values.byName(row.provenance),
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    dueAt: row.dueAt,
    clientDocumentId: row.clientDocumentId,
    caseId: row.caseId,
  );
}
