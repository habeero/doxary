import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/routing/app_router.dart';
import '../../../shared/design_system/app_widgets.dart';
import '../application/task_timeframes.dart';
import '../../documents/domain/entities/domain_entities.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final open = ref.watch(openTasksProvider);
    final completed = ref.watch(completedTasksProvider);
    final now = ref.watch(currentTimeProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.tasks),
          actions: [
            IconButton(
              key: const Key('create-task'),
              tooltip: l10n.createTask,
              icon: const Icon(Icons.add_task_outlined),
              onPressed: () =>
                  GoRouter.of(context).go('${AppRoutes.tasks}/create'),
            ),
          ],
        ),
        body: DefaultTabController(
          length: 4,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: l10n.today),
                  Tab(text: l10n.upcoming),
                  Tab(text: l10n.overdue),
                  Tab(text: l10n.completed),
                ],
              ),
              Expanded(
                child: open.when(
                  data: (openItems) => completed.when(
                    data: (completedItems) {
                      final buckets = bucketTasks(
                        open: openItems,
                        completed: completedItems,
                        now: now,
                      );
                      return TabBarView(
                        children: [
                          _TaskList(
                            tasks: buckets.today,
                            emptyTitle: l10n.noTasks,
                          ),
                          _TaskList(
                            tasks: buckets.upcoming,
                            emptyTitle: l10n.noUpcomingTasks,
                          ),
                          _TaskList(
                            tasks: buckets.overdue,
                            emptyTitle: l10n.noTasks,
                            overdue: true,
                          ),
                          _TaskList(
                            tasks: buckets.completed,
                            emptyTitle: l10n.noTasks,
                          ),
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, _) => AppErrorState(
                      message: context.l10n.localDataUnavailable,
                    ),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, _) =>
                      AppErrorState(message: context.l10n.localDataUnavailable),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({
    required this.tasks,
    required this.emptyTitle,
    this.overdue = false,
  });
  final List<LocalTask> tasks;
  final String emptyTitle;
  final bool overdue;
  @override
  Widget build(BuildContext context) => tasks.isEmpty
      ? AppEmptyState(
          icon: Icons.checklist_outlined,
          title: emptyTitle,
          description: '',
        )
      : ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: tasks.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (_, index) {
            final task = tasks[index];
            final dueAt = task.dueAt;
            return AppSectionCard(
              child: ListTile(
                leading: const Icon(Icons.check_box_outline_blank),
                title: Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: overdue && dueAt != null
                    ? Text(
                        '${context.l10n.taskOverdue} · ${MaterialLocalizations.of(context).formatMediumDate(dueAt)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      )
                    : null,
                onTap: () =>
                    GoRouter.of(context)
                        .push('${AppRoutes.tasks}/${task.id}'),
              ),
            );
          },
        );
}
