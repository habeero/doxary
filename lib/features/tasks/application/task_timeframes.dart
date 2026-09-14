import '../../documents/domain/entities/domain_entities.dart';

enum TaskTimeframe { today, upcoming, completed }

class TaskBuckets {
  const TaskBuckets({
    required this.today,
    required this.upcoming,
    required this.completed,
  });
  final List<LocalTask> today;
  final List<LocalTask> upcoming;
  final List<LocalTask> completed;
}

TaskBuckets bucketTasks({
  required List<LocalTask> open,
  required List<LocalTask> completed,
  required DateTime now,
}) {
  final startOfTomorrow = DateTime(now.year, now.month, now.day + 1);
  return TaskBuckets(
    today: open
        .where(
          (task) => task.dueAt != null && task.dueAt!.isBefore(startOfTomorrow),
        )
        .toList(),
    upcoming: open
        .where(
          (task) =>
              task.dueAt == null || !task.dueAt!.isBefore(startOfTomorrow),
        )
        .toList(),
    completed: completed,
  );
}
