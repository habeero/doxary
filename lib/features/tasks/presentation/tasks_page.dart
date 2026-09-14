import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.tasks)),
        body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: l10n.today),
                  Tab(text: l10n.upcoming),
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
                        now: DateTime.now(),
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
                            tasks: buckets.completed,
                            emptyTitle: l10n.noTasks,
                          ),
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) =>
                        AppErrorState(message: error.toString()),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => AppErrorState(message: error.toString()),
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
  const _TaskList({required this.tasks, required this.emptyTitle});
  final List<LocalTask> tasks;
  final String emptyTitle;
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
          itemBuilder: (_, index) => AppSectionCard(
            child: ListTile(
              leading: const Icon(Icons.check_box_outline_blank),
              title: Text(tasks[index].title),
            ),
          ),
        );
}
