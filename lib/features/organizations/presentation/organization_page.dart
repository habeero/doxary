import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/design_system/app_widgets.dart';
import '../../cases/presentation/case_page.dart';
import '../../documents/domain/entities/domain_entities.dart';
import '../../documents/presentation/documents_page.dart';

class OrganizationPage extends ConsumerStatefulWidget {
  const OrganizationPage({required this.organizationId, super.key});
  final String organizationId;

  @override
  ConsumerState<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends ConsumerState<OrganizationPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final organizations =
        _data(ref.watch(organizationsProvider)) ?? const <Organization>[];
    final organization = _firstWhere(
      organizations,
      (item) => item.id == widget.organizationId,
    );
    final cases = (_data(ref.watch(casesProvider)) ?? const <Case>[])
        .where((item) => item.organizationId == widget.organizationId)
        .where((item) => _matches(item.title, _query))
        .toList();
    final documents =
        (_data(ref.watch(allDocumentsProvider)) ?? const <LocalDocument>[])
            .where(
              (item) =>
                  item.classificationState == ClassificationState.confirmed &&
                  item.organizationId == widget.organizationId &&
                  item.caseId == null,
            )
            .toList();
    final allDocuments =
        _data(ref.watch(allDocumentsProvider)) ?? const <LocalDocument>[];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const BackButtonIcon(),
        ),
        title: Text(
          organization?.name ?? l10n.organization,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          TextField(
            key: const Key('organization-context-search'),
            onChanged: (value) => setState(() => _query = value),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l10n.searchCases,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          if (documents.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _WithoutCaseFolder(
              count: documents.length,
              onTap: () => _openWithoutCase(context, widget.organizationId),
            ),
          ],
          if (cases.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.lg),
              child: Text(l10n.noMatchingCases),
            )
          else ...[
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.cases, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            for (final item in cases)
              ListTile(
                key: Key('case-folder-${item.id}'),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                ),
                leading: Icon(
                  Icons.folder_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  _caseDocumentCountLabel(l10n, allDocuments, item.id),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openCase(context, widget.organizationId, item.id),
              ),
          ],
        ],
      ),
    );
  }
}

class _WithoutCaseFolder extends StatelessWidget {
  const _WithoutCaseFolder({required this.count, required this.onTap});
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      color: Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(10),
      child: ListTile(
        key: const Key('without-case-folder'),
        leading: const Icon(Icons.inventory_2_outlined),
        title: Text(l10n.withoutCase),
        subtitle: Text(
          '$count ${count == 1 ? l10n.documentFallback : l10n.documents}',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class OrganizationWithoutCasePage extends ConsumerStatefulWidget {
  const OrganizationWithoutCasePage({required this.organizationId, super.key});
  final String organizationId;

  @override
  ConsumerState<OrganizationWithoutCasePage> createState() =>
      _OrganizationWithoutCasePageState();
}

class _OrganizationWithoutCasePageState
    extends ConsumerState<OrganizationWithoutCasePage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final documents = ref.watch(allDocumentsProvider);
    final organizations =
        _data(ref.watch(organizationsProvider)) ?? const <Organization>[];
    final organization = _firstWhere(
      organizations,
      (item) => item.id == widget.organizationId,
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const BackButtonIcon(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              organization?.name ?? l10n.organization,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              l10n.withoutCase,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: documents.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            AppErrorState(message: context.l10n.localDataUnavailable),
        data: (items) => DocumentCollection(
          documents: items
              .where(
                (item) =>
                    item.classificationState == ClassificationState.confirmed &&
                    item.organizationId == widget.organizationId &&
                    item.caseId == null,
              )
              .toList(),
          query: _query,
          onQueryChanged: (value) => setState(() => _query = value),
        ),
      ),
    );
  }
}

T? _data<T>(AsyncValue<T> value) => value is AsyncData<T> ? value.value : null;

T? _firstWhere<T>(Iterable<T> values, bool Function(T) predicate) {
  for (final value in values) {
    if (predicate(value)) return value;
  }
  return null;
}

bool _matches(String value, String query) =>
    query.trim().isEmpty ||
    value.toLowerCase().contains(query.trim().toLowerCase());

String _caseDocumentCountLabel(
  AppLocalizations l10n,
  List<LocalDocument> documents,
  String caseId,
) {
  final count = documents.where((item) => item.caseId == caseId).length;
  return '$count ${count == 1 ? l10n.documentFallback : l10n.documents}';
}

void _openWithoutCase(BuildContext context, String organizationId) {
  if (GoRouter.maybeOf(context) != null) {
    context.push('/documents/organization/$organizationId/without-case');
    return;
  }
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) =>
          OrganizationWithoutCasePage(organizationId: organizationId),
    ),
  );
}

void _openCase(BuildContext context, String organizationId, String caseId) {
  if (GoRouter.maybeOf(context) != null) {
    context.push('/documents/organization/$organizationId/case/$caseId');
    return;
  }
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => CasePage(caseId: caseId)));
}
