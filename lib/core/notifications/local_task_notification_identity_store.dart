import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'task_notification_identity_store.dart';

class LocalTaskNotificationIdentityStore
    implements TaskNotificationIdentityStore {
  LocalTaskNotificationIdentityStore(this._database);

  final AppDatabase _database;

  @override
  Future<int?> existing(String taskId) async {
    final row = await _database
        .customSelect(
          'SELECT notification_id FROM task_notification_ids WHERE task_id = ?',
          variables: [Variable<String>(taskId)],
        )
        .getSingleOrNull();
    return row?.read<int>('notification_id');
  }

  @override
  Future<int> resolve(String taskId) async {
    final stored = await existing(taskId);
    if (stored != null) return stored;

    var candidate = notificationIdSeed(taskId);
    while (true) {
      final collision = await _database
          .customSelect(
            'SELECT task_id FROM task_notification_ids WHERE notification_id = ?',
            variables: [Variable<int>(candidate)],
          )
          .getSingleOrNull();
      if (collision == null) {
        await _database.customStatement(
          'INSERT INTO task_notification_ids (task_id, notification_id) VALUES (?, ?)',
          [taskId, candidate],
        );
        return candidate;
      }
      if (collision.read<String>('task_id') == taskId) return candidate;
      candidate = candidate == 0x7fffffff ? 1 : candidate + 1;
    }
  }

  static int notificationIdSeed(String taskId) {
    var hash = 0x811c9dc5;
    for (final unit in taskId.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }
    return hash;
  }
}
