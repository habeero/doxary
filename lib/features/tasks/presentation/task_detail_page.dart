import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/routing/app_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/design_system/app_widgets.dart';
import '../../documents/domain/entities/domain_entities.dart';
import '../../documents/presentation/document_display.dart';

/// Focused, read-only destination for one persisted local Task.
class TaskDetailPage extends ConsumerWidget {
  const TaskDetailPage({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(taskProvider(taskId));
    return task.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => _MissingTaskScaffold(),
      data: (value) => value == null
          ? const _MissingTaskScaffold()
          : _TaskDetailScaffold(task: value),
    );
  }
}

class _MissingTaskScaffold extends StatelessWidget {
  const _MissingTaskScaffold();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.taskDetail)),
      body: SafeArea(
        child: AppEmptyState(
          key: const Key('task-detail-missing'),
          icon: Icons.task_alt_outlined,
          title: l10n.taskUnavailable,
          description: l10n.localDataUnavailable,
        ),
      ),
    );
  }
}

class _TaskDetailScaffold extends ConsumerWidget {
  const _TaskDetailScaffold({required this.task});

  final LocalTask task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final documents =
        ref.watch(allDocumentsProvider).asData?.value ?? const <LocalDocument>[];
    final cases = ref.watch(casesProvider).asData?.value ?? const <Case>[];
    final linkedDocument = _findDocument(documents, task.clientDocumentId);
    final linkedCase = _findCase(cases, task.caseId);
    final documentLabel = linkedDocument == null
        ? l10n.documentFallback
        : documentDisplayTitle(
            linkedDocument,
            l10n,
            analysis: ref
                .watch(latestAnalysisProvider(linkedDocument.clientDocumentId))
                .asData
                ?.value,
            file: _firstOrNull(
              ref
                      .watch(
                        documentFilesProvider(linkedDocument.clientDocumentId),
                      )
                      .asData
                      ?.value ??
                  const <DocumentFile>[],
            ),
          );
    final caseLabel = linkedCase == null || linkedCase.title.trim().isEmpty
        ? l10n.caseNotAssigned
        : linkedCase.title;
    final timeLabel = task.allDay
        ? l10n.allDay
        : task.dueTimeMinutes == null
        ? l10n.notSpecified
        : TimeOfDay(
            hour: task.dueTimeMinutes! ~/ 60,
            minute: task.dueTimeMinutes! % 60,
          ).format(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.taskDetail),
        actions: [
          IconButton(
            key: const Key('task-detail-edit'),
            tooltip: l10n.editTask,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              await GoRouter.of(context).push(
                '${AppRoutes.tasks}/edit/${task.id}',
              );
              ref.invalidate(taskProvider(task.id));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          key: const Key('task-detail'),
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Text(
              task.title,
              key: const Key('task-detail-title'),
              style: Theme.of(context).textTheme.headlineSmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Chip(
                avatar: Icon(
                  task.status == TaskStatus.completed
                      ? Icons.check_circle_outline
                      : Icons.radio_button_unchecked,
                  size: 18,
                ),
                label: Text(_statusLabel(l10n, task.status)),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _TaskDetailRow(
              label: l10n.date,
              value: task.dueAt == null
                  ? l10n.notSpecified
                  : MaterialLocalizations.of(context).formatMediumDate(
                      task.dueAt!,
                    ),
            ),
            _TaskDetailRow(label: l10n.time, value: timeLabel),
            _TaskDetailRow(
              key: const Key('task-detail-reminder'),
              label: l10n.reminder,
              value: _reminderLabel(l10n, task.reminderMinutesBefore),
            ),
            if (task.clientDocumentId != null)
              _TaskDetailRow(
                label: l10n.linkedDocument,
                value: documentLabel,
              ),
            if (task.caseId != null)
              _TaskDetailRow(label: l10n.linkedCase, value: caseLabel),
            if (task.note?.trim().isNotEmpty ?? false)
              _TaskDetailRow(label: l10n.note, value: task.note!.trim()),
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton.icon(
              key: const Key('task-detail-edit-button'),
              onPressed: () async {
                await GoRouter.of(context).push(
                  '${AppRoutes.tasks}/edit/${task.id}',
                );
                ref.invalidate(taskProvider(task.id));
              },
              icon: const Icon(Icons.edit_outlined),
              label: Text(l10n.editTask),
            ),
            if (task.status == TaskStatus.completed) ...[
              const SizedBox(height: AppSpacing.sm),
              FilledButton.tonalIcon(
                key: const Key('task-detail-reopen'),
                onPressed: () async {
                  await ref
                      .read(taskLifecycleProvider)
                      .reopen(task, ref.read(currentTimeProvider));
                  ref.invalidate(taskProvider(task.id));
                },
                icon: const Icon(Icons.refresh_outlined),
                label: Text(l10n.reopenTask),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              key: const Key('task-detail-delete'),
              onPressed: () => _delete(context, ref, task),
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              label: Text(
                l10n.deleteTask,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _delete(
  BuildContext context,
  WidgetRef ref,
  LocalTask task,
) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.deleteTaskTitle),
      content: Text(l10n.deleteTaskMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(l10n.deleteTask),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;
  await ref.read(taskLifecycleProvider).delete(task);
  if (!context.mounted) return;
  GoRouter.of(context).go(AppRoutes.tasks);
}

class _TaskDetailRow extends StatelessWidget {
  const _TaskDetailRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.md),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ],
    ),
  );
}

LocalDocument? _findDocument(List<LocalDocument> documents, String? id) {
  if (id == null) return null;
  for (final document in documents) {
    if (document.clientDocumentId == id) return document;
  }
  return null;
}

Case? _findCase(List<Case> cases, String? id) {
  if (id == null) return null;
  for (final item in cases) {
    if (item.id == id) return item;
  }
  return null;
}

T? _firstOrNull<T>(List<T> values) => values.isEmpty ? null : values.first;

String _statusLabel(AppLocalizations l10n, TaskStatus status) => switch (status) {
  TaskStatus.open => l10n.taskOpen,
  TaskStatus.completed => l10n.completed,
  TaskStatus.dismissed => l10n.notSpecified,
};

String _reminderLabel(AppLocalizations l10n, int? value) => switch (value) {
  null => l10n.noReminder,
  0 => l10n.reminderAtTime,
  5 => l10n.reminderFiveMinutesBefore,
  10 => l10n.reminderTenMinutesBefore,
  30 => l10n.reminderThirtyMinutesBefore,
  60 => l10n.reminderOneHourBefore,
  1440 => l10n.reminderOneDayBefore,
  _ => l10n.noReminder,
};
