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

enum DocumentsViewMode { grid, list }

class DocumentsPage extends ConsumerStatefulWidget {
  const DocumentsPage({super.key});

  @override
  ConsumerState<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends ConsumerState<DocumentsPage> {
  final _searchController = TextEditingController();
  DocumentsViewMode _viewMode = DocumentsViewMode.grid;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final documents = ref.watch(allDocumentsProvider);
    final organizations = ref.watch(organizationsProvider);
    final cases = ref.watch(casesProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.documents)),
        body: documents.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) =>
              AppErrorState(message: context.l10n.localDataUnavailable),
          data: (items) {
            if (items.isEmpty) {
              return AppEmptyState(
                icon: Icons.folder_open_outlined,
                title: l10n.noDocuments,
                description: l10n.emptyDocumentsDescription,
              );
            }
            final allOrganizations = _asyncValue(organizations) ?? [];
            final allCases = _asyncValue(cases) ?? [];
            final visibleOrganizations = allOrganizations
                .where((organization) => _matches(organization.name, _query))
                .toList();
            final unclassified = items.where(_hasNoConfirmedOrganization).toList();
            final matchingDocuments = _query.trim().isEmpty
                ? const <LocalDocument>[]
                : items
                    .where(
                      (document) => _documentMatchesQuery(
                        ref,
                        document,
                        l10n,
                        _query,
                      ),
                    )
                    .toList();
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.lg,
              ),
              children: [
                _LibraryToolbar(
                  controller: _searchController,
                  viewMode: _viewMode,
                  onQueryChanged: (value) => setState(() => _query = value),
                  onViewModeChanged: (value) => setState(() => _viewMode = value),
                ),
                if (unclassified.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  _SpecialFolderRow(
                    key: const Key('unclassified-folder'),
                    icon: Icons.inventory_2_outlined,
                    title: l10n.unclassified,
                    subtitle: _countLabel(l10n, unclassified.length),
                    onTap: () => _openUnclassified(context),
                  ),
                ],
                if (visibleOrganizations.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(l10n.organizations, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  _OrganizationBrowser(
                    organizations: visibleOrganizations,
                    cases: allCases,
                    documents: items,
                    viewMode: _viewMode,
                  ),
                ],
                if (matchingDocuments.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.documents,
                    key: const Key('document-search-results-heading'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  for (final document in matchingDocuments)
                    _SearchableDocumentListTile(
                      document: document,
                      query: _query,
                      onTap: () => _openDocument(context, document.clientDocumentId),
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

class _LibraryToolbar extends StatelessWidget {
  const _LibraryToolbar({
    required this.controller,
    required this.viewMode,
    required this.onQueryChanged,
    required this.onViewModeChanged,
  });

  final TextEditingController controller;
  final DocumentsViewMode viewMode;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<DocumentsViewMode> onViewModeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final nextMode = viewMode == DocumentsViewMode.grid
        ? DocumentsViewMode.list
        : DocumentsViewMode.grid;
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onQueryChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l10n.searchDocuments,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        IconButton(
          key: const Key('documents-view-toggle'),
          tooltip: nextMode == DocumentsViewMode.grid ? l10n.gridView : l10n.listView,
          onPressed: () => onViewModeChanged(nextMode),
          icon: Icon(
            viewMode == DocumentsViewMode.grid
                ? Icons.view_list_outlined
                : Icons.grid_view_outlined,
          ),
        ),
      ],
    );
  }
}

class _OrganizationBrowser extends StatelessWidget {
  const _OrganizationBrowser({
    required this.organizations,
    required this.cases,
    required this.documents,
    required this.viewMode,
  });

  final List<Organization> organizations;
  final List<Case> cases;
  final List<LocalDocument> documents;
  final DocumentsViewMode viewMode;

  @override
  Widget build(BuildContext context) {
    if (viewMode == DocumentsViewMode.list) {
      return Column(
        key: const Key('documents-organization-list'),
        children: [
          for (final organization in organizations)
            _FolderListRow(
              title: organization.name,
              subtitle: _organizationMetadata(context.l10n, organization.id),
              onTap: () => context.push('/documents/organization/${organization.id}'),
            ),
        ],
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 320 ? 3 : 2;
        return GridView.builder(
          key: const Key('documents-organization-grid'),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: 0.96,
          ),
          itemCount: organizations.length,
          itemBuilder: (context, index) {
            final organization = organizations[index];
            return _FolderGridTile(
              title: organization.name,
              subtitle: _organizationMetadata(context.l10n, organization.id),
              onTap: () => context.push('/documents/organization/${organization.id}'),
            );
          },
        );
      },
    );
  }

  String _organizationMetadata(AppLocalizations l10n, String organizationId) {
    final documentCount = documents
        .where(
          (document) =>
              document.classificationState == ClassificationState.confirmed &&
              document.organizationId == organizationId,
        )
        .length;
    final caseCount = cases.where((item) => item.organizationId == organizationId).length;
    if (caseCount == 0) return _countLabel(l10n, documentCount);
    return '${_caseCountLabel(l10n, caseCount)} · ${_countLabel(l10n, documentCount)}';
  }
}

class _FolderGridTile extends StatelessWidget {
  const _FolderGridTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '$title, $subtitle',
    child: InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_outlined, size: 46, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    ),
  );
}

class _FolderListRow extends StatelessWidget {
  const _FolderListRow({
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.icon = Icons.folder_outlined,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
    leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
    title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
    subtitle: Text(subtitle),
    trailing: const Icon(Icons.chevron_right),
    onTap: onTap,
  );
}

class _SpecialFolderRow extends StatelessWidget {
  const _SpecialFolderRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.primaryContainer,
    borderRadius: BorderRadius.circular(10),
    child: _FolderListRow(title: title, subtitle: subtitle, icon: icon, onTap: onTap),
  );
}

class UnclassifiedDocumentsPage extends ConsumerStatefulWidget {
  const UnclassifiedDocumentsPage({super.key});

  @override
  ConsumerState<UnclassifiedDocumentsPage> createState() => _UnclassifiedDocumentsPageState();
}

class _UnclassifiedDocumentsPageState extends ConsumerState<UnclassifiedDocumentsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final documents = ref.watch(allDocumentsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.unclassified)),
      body: documents.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            AppErrorState(message: context.l10n.localDataUnavailable),
        data: (items) => DocumentCollection(
          documents: items.where(_hasNoConfirmedOrganization).toList(),
          query: _query,
          onQueryChanged: (value) => setState(() => _query = value),
        ),
      ),
    );
  }
}

class DocumentCollection extends StatelessWidget {
  const DocumentCollection({
    required this.documents,
    required this.query,
    required this.onQueryChanged,
    super.key,
  });

  final List<LocalDocument> documents;
  final String query;
  final ValueChanged<String> onQueryChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (documents.isEmpty) {
      return AppEmptyState(
        icon: Icons.description_outlined,
        title: l10n.noDocuments,
        description: l10n.emptyDocumentsDescription,
      );
    }
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        TextField(
          key: const Key('context-document-search'),
          onChanged: onQueryChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: l10n.searchDocuments,
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final document in documents)
          _SearchableDocumentListTile(
            document: document,
            query: query,
            onTap: () => _openDocument(context, document.clientDocumentId),
          ),
      ],
    );
  }
}

class DocumentListTile extends ConsumerWidget {
  const DocumentListTile({required this.document, this.onTap, super.key});
  final LocalDocument document;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) => _DocumentListTile(document: document, onTap: onTap);
}

class _SearchableDocumentListTile extends ConsumerWidget {
  const _SearchableDocumentListTile({
    required this.document,
    required this.query,
    required this.onTap,
  });

  final LocalDocument document;
  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      _DocumentListTile(document: document, query: query, onTap: onTap);
}

class _DocumentListTile extends ConsumerWidget {
  const _DocumentListTile({required this.document, this.onTap, this.query = ''});
  final LocalDocument document;
  final VoidCallback? onTap;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final analysis = ref.watch(latestAnalysisProvider(document.clientDocumentId));
    final files = ref.watch(documentFilesProvider(document.clientDocumentId));
    final title = documentDisplayTitle(
      document,
      l10n,
      analysis: analysis is AsyncData<DocumentAnalysis?> ? analysis.value : null,
      file: _first(_asyncValue(files)),
    );
    if (!_matches(title, query)) return const SizedBox.shrink();
    final date = document.documentDate ?? document.createdAt;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      onTap: onTap,
      leading: const Icon(Icons.description_outlined),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text('${_compactDate(date)} · ${documentClassificationLabel(l10n, document.classificationState)}'),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

bool _matches(String value, String query) =>
    query.trim().isEmpty || value.toLowerCase().contains(query.trim().toLowerCase());

bool _hasNoConfirmedOrganization(LocalDocument document) =>
    document.classificationState != ClassificationState.confirmed ||
    document.organizationId == null;

bool _documentMatchesQuery(
  WidgetRef ref,
  LocalDocument document,
  AppLocalizations l10n,
  String query,
) {
  final analysis = ref.watch(latestAnalysisProvider(document.clientDocumentId));
  final files = ref.watch(documentFilesProvider(document.clientDocumentId));
  final title = documentDisplayTitle(
    document,
    l10n,
    analysis: analysis is AsyncData<DocumentAnalysis?> ? analysis.value : null,
    file: _first(_asyncValue(files)),
  );
  return _matches(title, query);
}

String _compactDate(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

String _countLabel(AppLocalizations l10n, int count) =>
    '$count ${count == 1 ? l10n.documentFallback : l10n.documents}';

String _caseCountLabel(AppLocalizations l10n, int count) =>
    '$count ${count == 1 ? l10n.caseLabel : l10n.cases}';

void _openDocument(BuildContext context, String clientDocumentId) {
  if (GoRouter.maybeOf(context) != null) {
    context.push('/documents/$clientDocumentId');
    return;
  }
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => DocumentDetailPage(clientDocumentId: clientDocumentId)),
  );
}

void _openUnclassified(BuildContext context) {
  if (GoRouter.maybeOf(context) != null) {
    context.push('/documents/unclassified');
    return;
  }
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const UnclassifiedDocumentsPage()),
  );
}

T? _asyncValue<T>(AsyncValue<T> value) => value is AsyncData<T> ? value.value : null;

T? _first<T>(List<T>? values) => values == null || values.isEmpty ? null : values.first;
