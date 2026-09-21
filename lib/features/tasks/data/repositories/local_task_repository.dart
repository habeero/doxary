import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../documents/domain/entities/domain_entities.dart';
import '../../domain/repositories/task_repository.dart';

class LocalTaskRepository implements TaskRepository {
  LocalTaskRepository(this._database);
  final AppDatabase _database;

  @override
  Stream<List<LocalTask>> watchOpen() => _watchByStatus(TaskStatus.open);

  @override
  Stream<List<LocalTask>> watchCompleted() =>
      _watchByStatus(TaskStatus.completed, descending: true);

  @override
  Future<LocalTask?> getById(String taskId) async {
    final rows = await _select(
      where: 'id = ?',
      variables: [Variable<String>(taskId)],
    ).get();
    return rows.isEmpty ? null : _toEntity(rows.single);
  }

  @override
  Future<LocalTask?> findBySourceAction(
    String sourceAnalysisId,
    String sourceActionKey,
  ) async {
    final rows = await _select(
      where: 'source_analysis_id = ? AND source_action_key = ?',
      variables: [
        Variable<String>(sourceAnalysisId),
        Variable<String>(sourceActionKey),
      ],
    ).get();
    return rows.isEmpty ? null : _toEntity(rows.single);
  }

  @override
  Future<void> save(LocalTask task) async {
    await _database.customStatement(
      '''INSERT INTO tasks (
          id, client_document_id, case_id, title, due_at, all_day,
          due_time_minutes, reminder_minutes_before, note, status, provenance,
          source_analysis_id, source_action_key, created_at, updated_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ON CONFLICT(id) DO UPDATE SET
          client_document_id = excluded.client_document_id,
          case_id = excluded.case_id,
          title = excluded.title,
          due_at = excluded.due_at,
          all_day = excluded.all_day,
          due_time_minutes = excluded.due_time_minutes,
          reminder_minutes_before = excluded.reminder_minutes_before,
          note = excluded.note,
          status = excluded.status,
          provenance = excluded.provenance,
          source_analysis_id = excluded.source_analysis_id,
          source_action_key = excluded.source_action_key,
          updated_at = excluded.updated_at''',
      [
        task.id,
        task.clientDocumentId,
        task.caseId,
        task.title,
        _milliseconds(task.dueAt),
        task.allDay ? 1 : 0,
        task.allDay ? null : task.dueTimeMinutes,
        task.reminderMinutesBefore,
        task.note,
        task.status.name,
        task.provenance.name,
        task.sourceAnalysisId,
        task.sourceActionKey,
        _milliseconds(task.createdAt),
        _milliseconds(task.updatedAt),
      ],
    );
    _database.notifyUpdates({TableUpdate.onTable(_database.tasks)});
  }

  @override
  Future<void> updateStatus(
    String taskId,
    TaskStatus status,
    DateTime updatedAt,
  ) {
    return _update('UPDATE tasks SET status = ?, updated_at = ? WHERE id = ?', [
      status.name,
      _milliseconds(updatedAt),
      taskId,
    ]);
  }

  @override
  Future<void> delete(String taskId) =>
      _update('DELETE FROM tasks WHERE id = ?', [taskId]);

  Stream<List<LocalTask>> _watchByStatus(
    TaskStatus status, {
    bool descending = false,
  }) => _select(
    where: 'status = ?',
    variables: [Variable<String>(status.name)],
    orderBy: descending ? 'updated_at DESC' : 'due_at ASC',
  ).watch().map((rows) => rows.map(_toEntity).toList());

  Selectable<QueryRow> _select({
    String? where,
    List<Variable> variables = const [],
    String? orderBy,
  }) => _database.customSelect(
    '''SELECT id, client_document_id, case_id, title, due_at, all_day,
        due_time_minutes, reminder_minutes_before, note, status, provenance,
        source_analysis_id, source_action_key,
        created_at, updated_at FROM tasks
        ${where == null ? '' : 'WHERE $where'}
        ${orderBy == null ? '' : 'ORDER BY $orderBy'}''',
    variables: variables,
    readsFrom: {_database.tasks},
  );

  Future<void> _update(String statement, List<Object?> args) async {
    await _database.customStatement(statement, args);
    _database.notifyUpdates({TableUpdate.onTable(_database.tasks)});
  }

  LocalTask _toEntity(QueryRow row) => LocalTask(
    id: row.read<String>('id'),
    title: row.read<String>('title'),
    status: TaskStatus.values.byName(row.read<String>('status')),
    provenance: TaskProvenance.values.byName(row.read<String>('provenance')),
    createdAt: _dateTime(row.read<int>('created_at')),
    updatedAt: _dateTime(row.read<int>('updated_at')),
    dueAt: _dateTimeOrNull(row.readNullable<int>('due_at')),
    allDay: row.read<int>('all_day') != 0,
    dueTimeMinutes: row.readNullable<int>('due_time_minutes'),
    reminderMinutesBefore: row.readNullable<int>('reminder_minutes_before'),
    note: row.readNullable<String>('note'),
    clientDocumentId: row.readNullable<String>('client_document_id'),
    caseId: row.readNullable<String>('case_id'),
    sourceAnalysisId: row.readNullable<String>('source_analysis_id'),
    sourceActionKey: row.readNullable<String>('source_action_key'),
  );

  int? _milliseconds(DateTime? value) => value?.millisecondsSinceEpoch;

  DateTime _dateTime(int value) => DateTime.fromMillisecondsSinceEpoch(value);

  DateTime? _dateTimeOrNull(int? value) =>
      value == null ? null : _dateTime(value);
}
