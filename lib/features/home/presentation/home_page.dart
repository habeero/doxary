import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/routing/app_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/design_system/app_widgets.dart';
import '../../document_analysis/application/document_attention.dart';
import '../../document_analysis/presentation/document_detail_page.dart';
import '../../documents/presentation/documents_page.dart';
import '../../documents/presentation/document_display.dart';
import '../../documents/domain/entities/domain_entities.dart';
import '../../tasks/presentation/task_draft_prefill.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documents = ref.watch(homeDocumentsProvider);
    final analysisBrowseStates = ref.watch(
      documentAnalysisBrowseStatesProvider,
    );
    final activeOperations = ref.watch(activeAnalysisOperationsProvider);
    final openTasks = ref.watch(openTasksProvider);
    final completedTasks = ref.watch(completedTasksProvider);
    final activeDocumentIds = activeOperations.when(
      data: (operations) =>
          operations.map((operation) => operation.clientDocumentId).toSet(),
      loading: () => const <String>{},
      error: (_, _) => const <String>{},
    );
    final handledTaskAttentionIds = {
      ..._taskAttentionIds(openTasks),
      ..._taskAttentionIds(completedTasks),
    };

    return Material(
      color: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            const _HomeAppHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                children: [
                  documents.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.only(top: AppSpacing.xl),
                      child: LinearProgressIndicator(),
                    ),
                    error: (_, _) => Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xl),
                      child: AppErrorState(
                        message: context.l10n.localDataUnavailable,
                      ),
                    ),
                    data: (items) => analysisBrowseStates.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.only(top: AppSpacing.xl),
                        child: LinearProgressIndicator(),
                      ),
                      error: (_, _) => Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.xl),
                        child: AppErrorState(
                          message: context.l10n.localDataUnavailable,
                        ),
                      ),
                      data: (states) => _HomeOverview(
                        query: _HomeOverviewQuery(
                          items,
                          activeDocumentIds,
                          handledTaskAttentionIds,
                          states,
                        ),
                        onOpenDocument: (id) => _openDocument(context, id),
                        onViewAll: () => _openDocuments(context),
                        onViewNeedsAttention: () =>
                            _openNeedsAttention(context),
                        onImport: () => context.go(AppRoutes.importDocument),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeAppHeader extends StatelessWidget {
  const _HomeAppHeader();

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    label: context.l10n.productName,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffE2E8F0))),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            context.l10n.productName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

class _HomeOverview extends ConsumerWidget {
  const _HomeOverview({
    required this.query,
    required this.onOpenDocument,
    required this.onViewAll,
    required this.onViewNeedsAttention,
    required this.onImport,
  });

  final _HomeOverviewQuery query;
  final ValueChanged<String> onOpenDocument;
  final VoidCallback onViewAll;
  final VoidCallback onViewNeedsAttention;
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
      error: (_, _) => Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xl),
        child: AppErrorState(message: context.l10n.localDataUnavailable),
      ),
      data: (data) {
        if (data.entries.isEmpty && data.needsAttentionDocumentCount == 0) {
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
            if (data.needsAttentionDocumentCount > 0) ...[
              const SizedBox(height: AppSpacing.md),
              _HomeNeedsAttentionItem(
                count: data.needsAttentionDocumentCount,
                onTap: onViewNeedsAttention,
              ),
            ],
            if (data.actionRequired.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              _SectionTitle(title: l10n.actionRequired),
              const SizedBox(height: AppSpacing.sm),
              for (final entry in data.actionRequired) ...[
                _ActionRequiredItem(
                  entry: entry,
                  onTap: () => onOpenDocument(entry.document.clientDocumentId),
                  onDismiss: () async {
                    final attentionId = entry.attentionId;
                    if (attentionId == null) return;
                    await ref
                        .read(settingsRepositoryProvider)
                        .write(
                          _homeAttentionSettingKey(attentionId),
                          'handled',
                        );
                    ref.invalidate(_homeOverviewProvider(query));
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
            if (data.processing.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
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
              const SizedBox(height: AppSpacing.md),
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
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: onViewAll,
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
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
      color: AppColors.textPrimary,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      height: 1.2,
    ),
  );
}

class _ActionRequiredItem extends StatelessWidget {
  const _ActionRequiredItem({
    required this.entry,
    required this.onTap,
    required this.onDismiss,
  });
  final _HomeDocumentEntry entry;
  final VoidCallback onTap;
  final Future<void> Function() onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final analysis = entry.analysis!;
    const primary = AppColors.primary;
    final detail =
        _firstMeaningful(analysis.nextActions) ?? l10n.actionRequiredBody;
    final deadline = _firstDeadline(analysis);
    final amount = analysis.amounts.isEmpty
        ? null
        : '${analysis.amounts.first.value} ${analysis.amounts.first.currency}';
    return Semantics(
      button: true,
      label: '${l10n.actionRequired}: ${entry.title(l10n)}',
      child: Material(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
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
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    IconButton(
                      key: Key(
                        'home-action-dismiss-${entry.document.clientDocumentId}',
                      ),
                      tooltip: l10n.dismiss,
                      onPressed: () => onDismiss(),
                      icon: const Icon(Icons.close, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  detail,
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
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
                    style: TextButton.styleFrom(foregroundColor: primary),
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

class _HomeNeedsAttentionItem extends StatelessWidget {
  const _HomeNeedsAttentionItem({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.errorContainer,
    borderRadius: BorderRadius.circular(10),
    child: ListTile(
      key: const Key('home-needs-attention'),
      leading: Icon(
        Icons.error_outline,
        color: Theme.of(context).colorScheme.onErrorContainer,
      ),
      title: Text(context.l10n.documentsNeedAttention(count)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
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
      key: Key('home-processing-document-${entry.document.clientDocumentId}'),
      button: true,
      label: '${l10n.processingDocuments}: ${entry.title(l10n)}',
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        entry.title(l10n),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.analysisInProgress,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
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
        key: Key('home-recent-document-${entry.document.clientDocumentId}'),
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              const Icon(
                Icons.description_outlined,
                size: 20,
                color: AppColors.secondary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      entry.title(l10n),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      MaterialLocalizations.of(context).formatMediumDate(date),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeOverviewQuery {
  const _HomeOverviewQuery(
    this.documents,
    this.activeDocumentIds,
    this.handledTaskAttentionIds,
    this.analysisBrowseStates,
  );
  final List<LocalDocument> documents;
  final Set<String> activeDocumentIds;
  final Set<String> handledTaskAttentionIds;
  final Map<String, DocumentAnalysisBrowseState> analysisBrowseStates;

  @override
  bool operator ==(Object other) =>
      other is _HomeOverviewQuery &&
      other.documents.length == documents.length &&
      _queryIdentity(other.documents) == _queryIdentity(documents) &&
      _activeIdentity(other.activeDocumentIds) ==
          _activeIdentity(activeDocumentIds) &&
      _activeIdentity(other.handledTaskAttentionIds) ==
          _activeIdentity(handledTaskAttentionIds) &&
      _browseStateIdentity(other.analysisBrowseStates) ==
          _browseStateIdentity(analysisBrowseStates);

  @override
  int get hashCode => Object.hash(
    _queryIdentity(documents),
    _activeIdentity(activeDocumentIds),
    _activeIdentity(handledTaskAttentionIds),
    _browseStateIdentity(analysisBrowseStates),
  );
}

String _queryIdentity(List<LocalDocument> documents) => documents
    .map(
      (document) =>
          '${document.clientDocumentId}:${document.status.name}:${document.updatedAt.microsecondsSinceEpoch}',
    )
    .join('|');

String _activeIdentity(Set<String> activeDocumentIds) =>
    (activeDocumentIds.toList()..sort()).join('|');

Set<String> _taskAttentionIds(AsyncValue<List<LocalTask>> tasks) => tasks.when(
  data: (items) => items
      .where(
        (task) => task.sourceAnalysisId != null && task.sourceActionKey != null,
      )
      .map(
        (task) => _homeAttentionIdFromParts(
          task.sourceAnalysisId!,
          task.sourceActionKey!,
        ),
      )
      .toSet(),
  loading: () => const <String>{},
  error: (_, _) => const <String>{},
);

String _browseStateIdentity(
  Map<String, DocumentAnalysisBrowseState> states,
) => (states.entries.toList()..sort((a, b) => a.key.compareTo(b.key)))
    .map((entry) {
      final state = entry.value;
      final attention = state.attention;
      return '${entry.key}:${state.hasUsableAnalysis}:${state.isProcessing}:'
          '${attention?.reason.name ?? ''}:'
          '${attention?.occurredAt.microsecondsSinceEpoch ?? ''}';
    })
    .join('|');

String _homeAttentionId(DocumentAnalysis analysis) => _homeAttentionIdFromParts(
  analysis.id,
  sourceActionKeyForAnalysis(analysis),
);

String _homeAttentionIdFromParts(String analysisId, String sourceActionKey) =>
    '$analysisId::$sourceActionKey';

String _homeAttentionSettingKey(String attentionId) =>
    'home_attention_handled::$attentionId';

class _HomeOverviewData {
  const _HomeOverviewData(
    this.entries,
    this.activeDocumentIds,
    this.handledTaskAttentionIds,
    this.analysisBrowseStates,
    this.needsAttentionDocumentCount,
  );
  final List<_HomeDocumentEntry> entries;
  final Set<String> activeDocumentIds;
  final Set<String> handledTaskAttentionIds;
  final Map<String, DocumentAnalysisBrowseState> analysisBrowseStates;
  final int needsAttentionDocumentCount;

  bool _hasUnresolvedAttention(_HomeDocumentEntry entry) =>
      entry.analysis?.actionRequired == ActionRequirement.yes &&
      !entry.attentionHandled &&
      entry.attentionId != null &&
      !handledTaskAttentionIds.contains(entry.attentionId);

  List<_HomeDocumentEntry> get actionRequired => entries
      .where(
        (entry) =>
            !activeDocumentIds.contains(entry.document.clientDocumentId) &&
            analysisBrowseStates[entry.document.clientDocumentId]?.attention ==
                null &&
            _hasUnresolvedAttention(entry),
      )
      .toList();

  List<_HomeDocumentEntry> get processing => entries
      .where(
        (entry) => activeDocumentIds.contains(entry.document.clientDocumentId),
      )
      .toList();

  List<_HomeDocumentEntry> get recent => entries
      .where(
        (entry) =>
            !activeDocumentIds.contains(entry.document.clientDocumentId) &&
            analysisBrowseStates[entry.document.clientDocumentId]?.attention ==
                null &&
            !_hasUnresolvedAttention(entry),
      )
      .take(5)
      .toList();
}

class _HomeDocumentEntry {
  const _HomeDocumentEntry({
    required this.document,
    required this.analysis,
    required this.file,
    this.attentionId,
    this.attentionHandled = false,
  });
  final LocalDocument document;
  final DocumentAnalysis? analysis;
  final DocumentFile? file;
  final String? attentionId;
  final bool attentionHandled;

  String title(AppLocalizations l10n) =>
      documentDisplayTitle(document, l10n, analysis: analysis, file: file);
}

final _homeOverviewProvider = FutureProvider.autoDispose
    .family<_HomeOverviewData, _HomeOverviewQuery>((ref, query) async {
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
          final attentionId = analysis?.actionRequired == ActionRequirement.yes
              ? _homeAttentionId(analysis!)
              : null;
          if (attentionId != null &&
              query.handledTaskAttentionIds.contains(attentionId)) {
            await ref
                .read(settingsRepositoryProvider)
                .write(_homeAttentionSettingKey(attentionId), 'handled');
          }
          final attentionHandled =
              attentionId != null &&
              await ref
                      .read(settingsRepositoryProvider)
                      .read(_homeAttentionSettingKey(attentionId)) ==
                  'handled';
          return _HomeDocumentEntry(
            document: document,
            analysis: analysis,
            file: file,
            attentionId: attentionId,
            attentionHandled: attentionHandled,
          );
        }),
      );
      return _HomeOverviewData(
        entries,
        query.activeDocumentIds,
        query.handledTaskAttentionIds,
        query.analysisBrowseStates,
        query.documents
            .where(
              (document) =>
                  query
                      .analysisBrowseStates[document.clientDocumentId]
                      ?.attention !=
                  null,
            )
            .length,
      );
    });

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
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => const DocumentsPage()));
}

void _openNeedsAttention(BuildContext context) {
  if (GoRouter.maybeOf(context) != null) {
    context.go(AppRoutes.documentsNeedsAttention);
    return;
  }
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const NeedsAttentionDocumentsPage()),
  );
}
