import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/design_system/app_widgets.dart';
import '../../document_analysis/presentation/analysis_result_page.dart';

class DocumentsPage extends ConsumerWidget {
  const DocumentsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.documents)),
        body: ref
            .watch(recentDocumentsProvider)
            .when(
              data: (items) => items.isEmpty
                  ? AppEmptyState(
                      icon: Icons.folder_open_outlined,
                      title: l10n.noDocuments,
                      description: l10n.emptyDocumentsDescription,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: items.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (_, index) => AppSectionCard(
                        child: ListTile(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AnalysisResultPage(
                                clientDocumentId: items[index].clientDocumentId,
                              ),
                            ),
                          ),
                          title: Text(items[index].clientDocumentId),
                          subtitle: Text(items[index].classificationState.name),
                          leading: const Icon(Icons.description_outlined),
                        ),
                      ),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => AppErrorState(message: error.toString()),
            ),
      ),
    );
  }
}
