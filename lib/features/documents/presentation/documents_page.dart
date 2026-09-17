import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/design_system/app_widgets.dart';
import '../../document_analysis/presentation/document_detail_page.dart';
import '../domain/entities/domain_entities.dart';
import 'document_display.dart';

class DocumentsPage extends ConsumerWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final documents = ref.watch(allDocumentsProvider);
    final organizations = ref.watch(organizationsProvider);
    final cases = ref.watch(casesProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.documents)),
        body: documents.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => AppErrorState(message: error.toString()),
          data: (items) {
            if (items.isEmpty) {
              return AppEmptyState(
                icon: Icons.folder_open_outlined,
                title: l10n.noDocuments,
                description: l10n.emptyDocumentsDescription,
              );
            }
            final organizationById = {
              for (final organization in _asyncValue(organizations) ?? [])
                organization.id: organization,
            };
            final Map<String, Case> caseById = {
              for (final item in _asyncValue(cases) ?? []) item.id: item,
            };
            final unclassified = items
                .where((item) => item.organizationId == null)
                .toList();
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                for (final organization in organizationById.values) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Text(
                      organization.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  AppSectionCard(
                    child: ListTile(
                      leading: const Icon(Icons.account_balance_outlined),
                      title: Text(organization.name),
                      subtitle: Text(
                        _organizationSubtitle(
                          l10n,
                          caseById.values,
                          organization.id,
                          items
                              .where(
                                (item) =>
                                    item.organizationId == organization.id,
                              )
                              .length,
                        ),
                      ),
                      onTap: () => context.push(
                        '/documents/organization/${organization.id}',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                if (unclassified.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Text(
                      l10n.unclassified,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  AppSectionCard(
                    child: Column(
                      children: [
                        for (final document in unclassified)
                          _DocumentListTile(
                            document: document,
                            caseById: caseById,
                            onTap: () => _openDocument(
                              context,
                              document.clientDocumentId,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

String _organizationSubtitle(
  AppLocalizations l10n,
  Iterable<Case> cases,
  String organizationId,
  int documentCount,
) {
  final matches = cases.where((item) => item.organizationId == organizationId);
  if (matches.isEmpty) return '$documentCount';
  return '${matches.first.title} \u00b7 ${documentClassificationLabel(l10n, ClassificationState.confirmed)}';
}

void _openDocument(BuildContext context, String clientDocumentId) {
  if (GoRouter.maybeOf(context) != null) {
    context.push('/documents/$clientDocumentId');
    return;
  }
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => DocumentDetailPage(clientDocumentId: clientDocumentId),
    ),
  );
}

class DocumentListTile extends ConsumerWidget {
  const DocumentListTile({required this.document, this.onTap, super.key});
  final LocalDocument document;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) => _DocumentListTile(
    document: document,
    onTap: onTap,
    caseById: const <String, Case>{},
  );
}

class _DocumentListTile extends ConsumerWidget {
  const _DocumentListTile({
    required this.document,
    required this.caseById,
    this.onTap,
  });
  final LocalDocument document;
  final Map<String, Case> caseById;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final analysis = ref.watch(
      latestAnalysisProvider(document.clientDocumentId),
    );
    final files = ref.watch(documentFilesProvider(document.clientDocumentId));
    final title = documentDisplayTitle(
      document,
      l10n,
      analysis: analysis is AsyncData<DocumentAnalysis?>
          ? analysis.value
          : null,
      file: _first(_asyncValue(files)),
    );
    final caseTitle = document.caseId == null
        ? null
        : caseById[document.caseId]?.title;
    return ListTile(
      onTap: onTap,
      leading: const Icon(Icons.description_outlined),
      title: Text(title),
      subtitle: Text(
        caseTitle == null
            ? documentClassificationLabel(l10n, document.classificationState)
            : '$caseTitle · ${documentClassificationLabel(l10n, document.classificationState)}',
      ),
    );
  }
}

T? _asyncValue<T>(AsyncValue<T> value) =>
    value is AsyncData<T> ? value.value : null;

T? _first<T>(List<T>? values) =>
    values == null || values.isEmpty ? null : values.first;
