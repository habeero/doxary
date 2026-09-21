import '../../documents/domain/entities/domain_entities.dart';

enum TaskTimeframe { overdue, today, upcoming, completed }

class TaskBuckets {
  const TaskBuckets({
    required this.overdue,
    required this.today,
    required this.upcoming,
    required this.completed,
  });
  final List<LocalTask> overdue;
  final List<LocalTask> today;
  final List<LocalTask> upcoming;
  final List<LocalTask> completed;
}

TaskBuckets bucketTasks({
  required List<LocalTask> open,
  required List<LocalTask> completed,
  required DateTime now,
}) {
  final today = DateTime(now.year, now.month, now.day);
  final active = open.where((task) => task.status == TaskStatus.open).toList();
  final completedItems = [...completed, ...open]
      .where((task) => task.status == TaskStatus.completed)
      .toList();
  return TaskBuckets(
    overdue: active
        .where((task) => _dueDate(task)?.isBefore(today) ?? false)
        .toList(),
    today: active
        .where(
          (task) => _dueDate(task) == today,
        )
        .toList(),
    upcoming: active
        .where(
          (task) =>
              task.dueAt == null || _dueDate(task)!.isAfter(today),
        )
        .toList(),
    completed: completedItems,
  );
}

DateTime? _dueDate(LocalTask task) {
  final dueAt = task.dueAt;
  return dueAt == null ? null : DateTime(dueAt.year, dueAt.month, dueAt.day);
}
