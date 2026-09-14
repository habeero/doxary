import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/routing/app_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/design_system/app_widgets.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tasks = ref.watch(openTasksProvider);
    final documents = ref.watch(recentDocumentsProvider);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(l10n.home, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.lg),
          Semantics(
            button: true,
            label: l10n.scanImport,
            child: FilledButton.icon(
              onPressed: () => context.go(AppRoutes.importDocument),
              icon: const Icon(Icons.document_scanner_outlined),
              label: Text(l10n.scanImport),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(l10n.upcoming, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          tasks.when(
            data: (items) => items.isEmpty
                ? AppEmptyState(
                    icon: Icons.event_available_outlined,
                    title: l10n.noUpcomingTasks,
                    description: '',
                  )
                : AppSectionCard(
                    child: Column(
                      children: items
                          .take(3)
                          .map(
                            (task) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(task.title),
                              leading: const Icon(
                                Icons.check_box_outline_blank,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
            error: (error, _) => AppErrorState(message: error.toString()),
            loading: () => const LinearProgressIndicator(),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            l10n.recentDocuments,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          documents.when(
            data: (items) => items.isEmpty
                ? AppEmptyState(
                    icon: Icons.description_outlined,
                    title: l10n.noDocuments,
                    description: l10n.emptyDocumentsDescription,
                  )
                : AppSectionCard(
                    child: Column(
                      children: items
                          .map(
                            (item) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(item.clientDocumentId),
                              leading: const Icon(Icons.description_outlined),
                            ),
                          )
                          .toList(),
                    ),
                  ),
            error: (error, _) => AppErrorState(message: error.toString()),
            loading: () => const LinearProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
