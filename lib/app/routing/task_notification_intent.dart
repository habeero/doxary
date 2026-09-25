import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskNotificationIntent {
  const TaskNotificationIntent._(this.taskId);

  const TaskNotificationIntent.tasksRoot() : this._(null);

  final String? taskId;

  factory TaskNotificationIntent.fromPayload(String? payload) {
    final taskId = payload?.trim();
    if (taskId == null ||
        taskId.isEmpty ||
        taskId.length > 256 ||
        taskId.contains(RegExp(r'[\u0000-\u001f\u007f]'))) {
      return const TaskNotificationIntent.tasksRoot();
    }
    return TaskNotificationIntent._(taskId);
  }

  @override
  bool operator ==(Object other) =>
      other is TaskNotificationIntent && other.taskId == taskId;

  @override
  int get hashCode => taskId.hashCode;
}

class PendingTaskNotificationIntent {
  const PendingTaskNotificationIntent({
    required this.sequence,
    required this.intent,
  });

  final int sequence;
  final TaskNotificationIntent intent;
}

class TaskNotificationIntentController
    extends Notifier<PendingTaskNotificationIntent?> {
  var _sequence = 0;

  @override
  PendingTaskNotificationIntent? build() => null;

  void receivePayload(String? payload) {
    final intent = TaskNotificationIntent.fromPayload(payload);
    if (state?.intent == intent) return;
    state = PendingTaskNotificationIntent(
      sequence: ++_sequence,
      intent: intent,
    );
  }

  void consume(int sequence) {
    if (state?.sequence == sequence) state = null;
  }
}
