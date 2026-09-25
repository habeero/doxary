import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../localization/app_localizations.dart';
import '../providers.dart';
import '../../features/documents/domain/entities/domain_entities.dart';
import 'task_notification_intent.dart';

/// Resolves Task reminder intents only after the router shell is mounted.
/// Platform notification code never navigates directly.
class TaskNotificationIntentHandler extends ConsumerStatefulWidget {
  const TaskNotificationIntentHandler({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<TaskNotificationIntentHandler> createState() =>
      _TaskNotificationIntentHandlerState();
}

class _TaskNotificationIntentHandlerState
    extends ConsumerState<TaskNotificationIntentHandler> {
  final Set<int> _scheduledSequences = {};
  final Set<String> _shownMissingTaskDialogs = {};
  Future<void> _processing = Future<void>.value();

  @override
  Widget build(BuildContext context) {
    ref.listen<PendingTaskNotificationIntent?>(taskNotificationIntentProvider, (
      _,
      next,
    ) {
      if (next != null) _schedule(next);
    });
    final pending = ref.watch(taskNotificationIntentProvider);
    if (pending != null) _schedule(pending);
    return widget.child;
  }

  void _schedule(PendingTaskNotificationIntent pending) {
    if (!_scheduledSequences.add(pending.sequence)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _processing = _processing
          .then((_) => _handle(pending))
          .catchError((Object _) {});
    });
  }

  Future<void> _handle(PendingTaskNotificationIntent pending) async {
    try {
      final taskId = pending.intent.taskId;
      if (taskId == null) {
        _goToTasks();
        return;
      }

      LocalTask? task;
      try {
        task = await ref.read(taskRepositoryProvider).getById(taskId);
      } catch (_) {
        // A local read failure does not prove that the Task was deleted.
        if (mounted) _goToTasks();
        return;
      }
      if (!mounted) return;

      if (task == null) {
        _goToTasks();
        if (_shownMissingTaskDialogs.add(taskId)) {
          await _showMissingTaskDialog();
        }
        return;
      }

      final target = '/tasks/${Uri.encodeComponent(task.id)}';
      final router = GoRouter.of(context);
      if (router.routeInformationProvider.value.uri.path != target) {
        router.go(target);
      }
    } finally {
      if (mounted) {
        ref
            .read(taskNotificationIntentProvider.notifier)
            .consume(pending.sequence);
      }
    }
  }

  void _goToTasks() {
    if (mounted) GoRouter.of(context).go('/tasks');
  }

  Future<void> _showMissingTaskDialog() async {
    final l10n = context.l10n;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.taskUnavailable),
        content: Text(l10n.taskNoLongerAvailable),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}
