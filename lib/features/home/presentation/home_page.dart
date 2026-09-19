import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/routing/app_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/design_system/app_widgets.dart';
import '../../document_analysis/presentation/document_detail_page.dart';
import '../../documents/presentation/documents_page.dart';
import '../../documents/presentation/document_display.dart';
import '../../documents/domain/entities/domain_entities.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final documents = ref.watch(homeDocumentsProvider);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          Text(
            l10n.productName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          documents.when(
            loading: () => const Padding(
              padding: EdgeInsets.only(top: AppSpacing.xl),
              child: LinearProgressIndicator(),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xl),
              child: AppErrorState(message: error.toString()),
            ),
            data: (items) => _HomeOverview(
              query: _HomeOverviewQuery(items),
              onOpenDocument: (id) => _openDocument(context, id),
              onViewAll: () => _openDocuments(context),
              onImport: () => context.go(AppRoutes.importDocument),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeOverview extends ConsumerWidget {
  const _HomeOverview({
    required this.query,
    required this.onOpenDocument,
    required this.onViewAll,
    required this.onImport,
  });

  final _HomeOverviewQuery query;
  final ValueChanged<String> onOpenDocument;
  final VoidCallback onViewAll;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final overview = ref.watch(_homeOverviewProvider(query));
    return overview.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(top: AppSpacing.xl),
        child: LinearProgressIndicator(),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xl),
        child: AppErrorState(message: error.toString()),
      ),
      data: (data) {
        if (data.entries.isEmpty) {
          return Column(
            children: [
              AppEmptyState(
                icon: Icons.description_outlined,
                title: l10n.noDocuments,
                description: l10n.emptyDocumentsDescription,
              ),
              FilledButton.icon(
                onPressed: onImport,
                icon: const Icon(Icons.document_scanner_outlined),
                label: Text(l10n.scanImport),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (data.actionRequired.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl),
              _SectionTitle(title: l10n.actionRequired),
              const SizedBox(height: AppSpacing.sm),
              for (final entry in data.actionRequired) ...[
                _ActionRequiredItem(
                  entry: entry,
                  onTap: () => onOpenDocument(entry.document.clientDocumentId),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
            if (data.processing.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              _SectionTitle(title: l10n.processingDocuments),
              const SizedBox(height: AppSpacing.sm),
              for (final entry in data.processing) ...[
                _ProcessingItem(
                  entry: entry,
                  onTap: () => onOpenDocument(entry.document.clientDocumentId),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
            if (data.recent.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              _SectionTitle(title: l10n.recentDocuments),
              const SizedBox(height: AppSpacing.sm),
              for (var index = 0; index < data.recent.length; index++) ...[
                _RecentDocumentItem(
                  entry: data.recent[index],
                  onTap: () => onOpenDocument(
                    data.recent[index].document.clientDocumentId,
                  ),
                ),
                if (index < data.recent.length - 1) const Divider(),
              ],
            ],
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: onViewAll,
                icon: const Icon(Icons.arrow_forward),
                label: Text(l10n.viewAllDocuments),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
    ),
  );
}

class _ActionRequiredItem extends StatelessWidget {
  const _ActionRequiredItem({required this.entry, required this.onTap});
  final _HomeDocumentEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final analysis = entry.analysis!;
    final primary = Theme.of(context).colorScheme.primary;
    final detail = _firstMeaningful(analysis.nextActions) ??
        l10n.actionRequiredBody;
    final deadline = _firstDeadline(analysis);
    final amount = analysis.amounts.isEmpty
        ? null
        : '${analysis.amounts.first.value} ${analysis.amounts.first.currency}';
    return Semantics(
      button: true,
      label: '${l10n.actionRequired}: ${entry.title(l10n)}',
      child: Material(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(Icons.priority_high_outlined, color: primary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        entry.title(l10n),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(detail),
                if (deadline != null || amount != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.xs,
                    children: [
                      if (deadline != null)
                        _ActionFact(
                          icon: Icons.event_outlined,
                          label: '${l10n.deadline}: $deadline',
                        ),
                      if (amount != null)
                        _ActionFact(
                          icon: Icons.payments_outlined,
                          label: '${l10n.amount}: $amount',
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton(
                    onPressed: onTap,
                    child: Text(l10n.openDocument),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionFact extends StatelessWidget {
  const _ActionFact({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 18),
      const SizedBox(width: AppSpacing.xs),
      Flexible(child: Text(label)),
    ],
  );
}

class _ProcessingItem extends StatelessWidget {
  const _ProcessingItem({required this.entry, required this.onTap});
  final _HomeDocumentEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Semantics(
      button: true,
      label: '${l10n.processingDocuments}: ${entry.title(l10n)}',
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        entry.title(l10n),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.analysisInProgress,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecentDocumentItem extends StatelessWidget {
  const _RecentDocumentItem({required this.entry, required this.onTap});
  final _HomeDocumentEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final date = entry.document.documentDate ?? entry.document.createdAt;
    return Semantics(
      button: true,
      label: entry.title(l10n),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              const Icon(Icons.description_outlined),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      entry.title(l10n),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      MaterialLocalizations.of(context).formatMediumDate(date),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeOverviewQuery {
  const _HomeOverviewQuery(this.documents);
  final List<LocalDocument> documents;

  @override
  bool operator ==(Object other) =>
      other is _HomeOverviewQuery &&
      other.documents.length == documents.length &&
      _queryIdentity(other.documents) == _queryIdentity(documents);

  @override
  int get hashCode => _queryIdentity(documents).hashCode;
}

String _queryIdentity(List<LocalDocument> documents) => documents
    .map(
      (document) =>
          '${document.clientDocumentId}:${document.status.name}:${document.updatedAt.microsecondsSinceEpoch}',
    )
    .join('|');

class _HomeOverviewData {
  const _HomeOverviewData(this.entries);
  final List<_HomeDocumentEntry> entries;

  List<_HomeDocumentEntry> get actionRequired => entries
      .where(
        (entry) =>
            entry.document.status != DocumentStatus.processing &&
            entry.analysis?.actionRequired == ActionRequirement.yes,
      )
      .toList();

  List<_HomeDocumentEntry> get processing => entries
      .where((entry) => entry.document.status == DocumentStatus.processing)
      .toList();

  List<_HomeDocumentEntry> get recent => entries
      .where(
        (entry) =>
            entry.document.status != DocumentStatus.processing &&
            entry.analysis?.actionRequired != ActionRequirement.yes,
      )
      .take(5)
      .toList();
}

class _HomeDocumentEntry {
  const _HomeDocumentEntry({
    required this.document,
    required this.analysis,
    required this.file,
  });
  final LocalDocument document;
  final DocumentAnalysis? analysis;
  final DocumentFile? file;

  String title(AppLocalizations l10n) =>
      documentDisplayTitle(document, l10n, analysis: analysis, file: file);
}

final _homeOverviewProvider =
    FutureProvider.autoDispose.family<_HomeOverviewData, _HomeOverviewQuery>(
      (ref, query) async {
        final entries = await Future.wait(
          query.documents.map((document) async {
            DocumentAnalysis? analysis;
            DocumentFile? file;
            try {
              ref.invalidate(latestAnalysisProvider(document.clientDocumentId));
              analysis = await ref.read(
                latestAnalysisProvider(document.clientDocumentId).future,
              );
            } catch (_) {}
            try {
              ref.invalidate(documentFilesProvider(document.clientDocumentId));
              final files = await ref.read(
                documentFilesProvider(document.clientDocumentId).future,
              );
              file = files.isEmpty ? null : files.first;
            } catch (_) {}
            return _HomeDocumentEntry(
              document: document,
              analysis: analysis,
              file: file,
            );
          }),
        );
        return _HomeOverviewData(entries);
      },
    );

String? _firstMeaningful(List<String> values) {
  for (final value in values) {
    if (value.trim().isNotEmpty) return value;
  }
  return null;
}

String? _firstDeadline(DocumentAnalysis analysis) {
  for (final deadline in analysis.deadlines) {
    final value = deadline.dateOrRange;
    if (value != null && value.trim().isNotEmpty) return value;
  }
  return null;
}

void _openDocument(BuildContext context, String clientDocumentId) {
  if (GoRouter.maybeOf(context) != null) {
    context.push('${AppRoutes.documents}/$clientDocumentId');
    return;
  }
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => DocumentDetailPage(clientDocumentId: clientDocumentId),
    ),
  );
}

void _openDocuments(BuildContext context) {
  if (GoRouter.maybeOf(context) != null) {
    context.go(AppRoutes.documents);
    return;
  }
  Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => const DocumentsPage()));
}
