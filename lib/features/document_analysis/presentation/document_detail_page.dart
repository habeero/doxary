import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/routing/app_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/errors/app_error.dart';
import '../domain/analysis_output_language.dart';
import '../domain/analysis_repository.dart';
import '../domain/analysis_submission.dart';
import '../../documents/domain/entities/domain_entities.dart';
import '../../documents/domain/classification/classification_selection.dart';
import '../../documents/domain/source_document_opener.dart';
import '../../documents/presentation/document_display.dart';
import '../../tasks/presentation/task_draft_prefill.dart';
import 'analysis_result_page.dart';
import 'source_image_viewer_page.dart';

class DocumentDetailPage extends ConsumerStatefulWidget {
  const DocumentDetailPage({required this.clientDocumentId, super.key});
  final String clientDocumentId;

  @override
  ConsumerState<DocumentDetailPage> createState() => _DocumentDetailPageState();
}

class _DocumentDetailPageState extends ConsumerState<DocumentDetailPage> {
  bool _retrying = false;
  String? _actionMessage;
  String? _selectedAnalysisId;

  Future<void> _retryAnalysis(List<DocumentFile> files) async {
    if (_retrying || files.isEmpty) return;
    setState(() {
      _retrying = true;
      _actionMessage = null;
    });
    try {
      final output = ref.read(analysisLanguageProvider);
      final submission = AnalysisSubmission(
        clientDocumentId: widget.clientDocumentId,
        files: files,
        language: output.explanationLanguage,
        style: output.explanationStyle,
        idempotencyKey: ref.read(idGeneratorProvider).newId(),
      );
      final workflow = ref.read(analysisWorkflowProvider);
      final accepted = await workflow.submit(submission);
      await workflow.poll(accepted.operationId, widget.clientDocumentId);
      ref
        ..invalidate(documentProvider(widget.clientDocumentId))
        ..invalidate(latestAnalysisProvider(widget.clientDocumentId))
        ..invalidate(analysisHistoryProvider(widget.clientDocumentId));
    } catch (error) {
      if (!context.mounted) return;
      setState(() {
        _actionMessage = error is RemoteApiError && error.retryable
            ? context.l10n.operationRetryableError
            : context.l10n.operationFailedError;
      });
    } finally {
      if (mounted) setState(() => _retrying = false);
    }
  }

  Future<void> _deleteAnalysis(String analysisId) async {
    final l = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.deleteAnalysisTitle),
        content: Text(l.deleteAnalysisMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.deleteAnalysis),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(analysisRepositoryProvider).deleteAnalysis(analysisId);
    if (!mounted) return;
    setState(() => _selectedAnalysisId = null);
    ref
      ..invalidate(latestAnalysisProvider(widget.clientDocumentId))
      ..invalidate(analysisByIdProvider(analysisId))
      ..invalidate(analysisHistoryProvider(widget.clientDocumentId))
      ..invalidate(documentProvider(widget.clientDocumentId));
  }

  Future<void> _openOriginalDocument(List<DocumentFile> files) async {
    final outcome = await ref.read(sourceDocumentOpenerProvider).open(files);
    if (!mounted) return;
    switch (outcome) {
      case SourceDocumentOpened():
        return;
      case SourceDocumentImagesOpened(:final pages):
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SourceImageViewerPage(pages: pages),
          ),
        );
        return;
      case SourceDocumentUnavailable():
        _showOriginalDocumentMessage(context.l10n.originalDocumentUnavailable);
        return;
      case SourceDocumentUnsupported():
        _showOriginalDocumentMessage(context.l10n.originalDocumentUnsupported);
        return;
      case SourceDocumentOpenFailed():
        _showOriginalDocumentMessage(context.l10n.unableToOpenOriginalDocument);
        return;
    }
  }

  void _showOriginalDocumentMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final document = ref.watch(documentProvider(widget.clientDocumentId));
    final files = ref.watch(documentFilesProvider(widget.clientDocumentId));
    final latestAnalysis = ref.watch(
      latestAnalysisProvider(widget.clientDocumentId),
    );
    final analysis = _selectedAnalysisId == null
        ? latestAnalysis
        : ref.watch(analysisByIdProvider(_selectedAnalysisId!));
    final history = ref.watch(analysisHistoryProvider(widget.clientDocumentId));
    final organizations = ref.watch(organizationsProvider);
    final cases = ref.watch(casesProvider);
    final localDocument = _asyncValue(document);
    final latest = _asyncValue(latestAnalysis);
    final selected = _asyncValue(analysis);
    final organizationId = localDocument?.organizationId;
    final caseId = localDocument?.caseId;
    final confirmedCaseId =
        localDocument?.classificationState == ClassificationState.confirmed
        ? caseId
        : null;
    final organizationName = organizationId == null
        ? null
        : _findOrganization(_asyncValue(organizations), organizationId);
    final caseName = caseId == null
        ? null
        : _findCase(_asyncValue(cases), caseId);
    final hasConfirmedOrganization = organizationId != null;
    final hasUnresolvedOrganizationSuggestion =
        !hasConfirmedOrganization &&
        latest?.classification?.organizationName != null;
    final suggestedClassification = hasUnresolvedOrganizationSuggestion
        ? latest?.classification
        : null;
    final title = documentDisplayTitle(
      localDocument ??
          LocalDocument(
            clientDocumentId: widget.clientDocumentId,
            classificationState: ClassificationState.unclassified,
            status: DocumentStatus.imported,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
      l10n,
      analysis: latest,
      file: _first(_asyncValue(files)),
      organizationName: organizationName,
    );
    final taskPrefill = selected == null
        ? null
        : TaskDraftPrefill.fromAnalysis(
            analysis: selected,
            clientDocumentId: widget.clientDocumentId,
            caseId: confirmedCaseId,
            l10n: l10n,
          );
    final existingSourceTask =
        taskPrefill?.sourceAnalysisId == null ||
            taskPrefill?.sourceActionKey == null
        ? null
        : ref
              .watch(
                taskForSourceActionProvider((
                  analysisId: taskPrefill!.sourceAnalysisId!,
                  actionKey: taskPrefill.sourceActionKey!,
                )),
              )
              .asData
              ?.value;
    Future<void> createTask() async {
      final task = await ref
          .read(taskRepositoryProvider)
          .findBySourceAction(
            taskPrefill!.sourceAnalysisId!,
            taskPrefill.sourceActionKey!,
          );
      if (!context.mounted) return;
      GoRouter.of(context).go(
        task == null
            ? '${AppRoutes.tasks}/create'
            : '${AppRoutes.tasks}/edit/${task.id}',
        extra: task == null ? taskPrefill : null,
      );
    }

    final classificationSection = localDocument == null
        ? null
        : _ClassificationSection(
            organizationName: organizationName,
            caseName: caseName,
            hasConfirmedOrganization: hasConfirmedOrganization,
            suggestion: suggestedClassification,
            onConfirm: hasUnresolvedOrganizationSuggestion
                ? () => _saveClassification(
                    ref,
                    widget.clientDocumentId,
                    organizationName: suggestedClassification!.organizationName,
                    organizations: _asyncValue(organizations) ?? const [],
                    cases: _asyncValue(cases) ?? const [],
                  )
                : null,
            onChange: () => _showClassificationEditor(
              context,
              ref,
              widget.clientDocumentId,
              organizationId: organizationId,
              caseId: caseId,
              organizations: _asyncValue(organizations) ?? const [],
              cases: _asyncValue(cases) ?? const [],
            ),
          );
    final originalSection = _OriginalDocumentSection(
      files: files,
      onOpen: _openOriginalDocument,
    );
    final historySection = _AnalysisHistorySection(
      document: localDocument,
      history: history,
      onOpen: (analysisId) => setState(() => _selectedAnalysisId = analysisId),
      onDelete: _deleteAnalysis,
    );
    final fileItems = _asyncValue(files) ?? const <DocumentFile>[];
    final body = switch (analysis) {
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncError() => DocumentResultView(
        title: title,
        technicalFailure: true,
        classificationSection: classificationSection,
        analysisHistorySection: historySection,
        originalDocumentSection: originalSection,
        onRetry: fileItems.isEmpty ? null : () => _retryAnalysis(fileItems),
        actionInProgress: _retrying,
        actionMessage: _actionMessage,
      ),
      AsyncData(value: final value) =>
        value == null
            ? localDocument?.status == DocumentStatus.needsReview
                  ? DocumentResultView(
                      title: title,
                      technicalFailure: true,
                      classificationSection: classificationSection,
                      analysisHistorySection: historySection,
                      originalDocumentSection: originalSection,
                      onRetry: fileItems.isEmpty
                          ? null
                          : () => _retryAnalysis(fileItems),
                      actionInProgress: _retrying,
                      actionMessage: _actionMessage,
                    )
                  : _NoAnalysisView(
                      title: title,
                      classificationSection: classificationSection,
                      analysisHistorySection: historySection,
                      originalDocumentSection: originalSection,
                    )
            : DocumentResultView(
                title: title,
                analysis: value,
                classificationSection: classificationSection,
                analysisHistorySection: historySection,
                originalDocumentSection: originalSection,
                onAddTask: taskPrefill == null ? null : createTask,
                taskActionLabel: existingSourceTask == null
                    ? null
                    : l10n.viewTask,
                actionInProgress: _retrying,
                actionMessage: _actionMessage,
              ),
    };
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          key: const Key('document-detail-back'),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const BackButtonIcon(),
        ),
      ),
      body: SafeArea(top: false, child: body),
    );
  }
}

class _NoAnalysisView extends StatelessWidget {
  const _NoAnalysisView({
    required this.title,
    required this.classificationSection,
    required this.analysisHistorySection,
    required this.originalDocumentSection,
  });
  final String title;
  final Widget? classificationSection;
  final Widget analysisHistorySection;
  final Widget originalDocumentSection;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppSpacing.lg),
    children: [
      Text(
        context.l10n.productName,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleLarge
            ?.copyWith(fontSize: 22, height: 1.25, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: AppSpacing.lg),
      Text(context.l10n.noSavedAnalysis),
      const SizedBox(height: AppSpacing.lg),
      analysisHistorySection,
      if (classificationSection != null) ...[
        const SizedBox(height: AppSpacing.lg),
        classificationSection!,
      ],
      const Divider(height: AppSpacing.xl),
      originalDocumentSection,
    ],
  );
}

class _AnalysisHistorySection extends StatelessWidget {
  const _AnalysisHistorySection({
    required this.document,
    required this.history,
    required this.onOpen,
    required this.onDelete,
  });

  final LocalDocument? document;
  final AsyncValue<List<AnalysisAttempt>> history;
  final ValueChanged<String> onOpen;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final items = history.asData?.value ?? const <AnalysisAttempt>[];
    final dateFormat = MaterialLocalizations.of(context);
    String dateTime(DateTime value) =>
        '${dateFormat.formatMediumDate(value)} ${dateFormat.formatTimeOfDay(TimeOfDay.fromDateTime(value))}';
    return Column(
      key: const Key('analysis-history-section'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.analysisHistory,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        if (document != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text('${l.documentAdded}: ${dateTime(document!.createdAt)}'),
        ],
        const SizedBox(height: AppSpacing.sm),
        if (history.isLoading)
          const SizedBox(height: AppSpacing.xs)
        else if (items.isEmpty)
          Text(l.noSavedAnalysis)
        else
          for (final attempt in items)
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withValues(alpha: .7),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        switch (attempt.status) {
                          AnalysisAttemptStatus.succeeded =>
                            Icons.check_circle_outline,
                          AnalysisAttemptStatus.failed => Icons.error_outline,
                          AnalysisAttemptStatus.pending =>
                            Icons.hourglass_top_outlined,
                        },
                        color: switch (attempt.status) {
                          AnalysisAttemptStatus.succeeded =>
                            AppColors.successFor(Theme.of(context).brightness),
                          AnalysisAttemptStatus.failed => Theme.of(
                            context,
                          ).colorScheme.error,
                          AnalysisAttemptStatus.pending => Theme.of(
                            context,
                          ).colorScheme.primary,
                        },
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(switch (attempt.status) {
                              AnalysisAttemptStatus.succeeded =>
                                l.analysisSuccessful,
                              AnalysisAttemptStatus.failed =>
                                l.analysisFailedHistory,
                              AnalysisAttemptStatus.pending =>
                                l.analysisPendingHistory,
                            }, style: Theme.of(context).textTheme.titleSmall),
                            Text(
                              '${l.analysisDate}: ${dateTime(attempt.terminalAt ?? attempt.startedAt)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (attempt.analysisId != null) ...[
                              const SizedBox(height: AppSpacing.xs),
                              Wrap(
                                spacing: AppSpacing.sm,
                                children: [
                                  TextButton(
                                    key: Key(
                                      'open-analysis-${attempt.analysisId}',
                                    ),
                                    onPressed: () =>
                                        onOpen(attempt.analysisId!),
                                    child: Text(l.openResult),
                                  ),
                                  TextButton(
                                    key: Key(
                                      'delete-analysis-${attempt.analysisId}',
                                    ),
                                    onPressed: () =>
                                        onDelete(attempt.analysisId!),
                                    child: Text(
                                      l.deleteAnalysis,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ],
    );
  }
}

class _ClassificationSection extends StatelessWidget {
  const _ClassificationSection({
    required this.organizationName,
    required this.caseName,
    required this.hasConfirmedOrganization,
    required this.suggestion,
    required this.onConfirm,
    required this.onChange,
  });
  final String? organizationName;
  final String? caseName;
  final bool hasConfirmedOrganization;
  final ClassificationSuggestion? suggestion;
  final VoidCallback? onConfirm;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Column(
      key: const Key('classification-section'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          key: const Key('classification-card'),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.75),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      suggestion == null
                          ? Icons.folder_outlined
                          : Icons.auto_awesome_outlined,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        suggestion == null
                            ? l.classification
                            : l.suggestedClassification,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (suggestion != null) ...[
                  if (suggestion!.organizationName?.trim().isNotEmpty ?? false)
                    _ClassificationValue(
                      label: l.organization,
                      value: suggestion!.organizationName!,
                    ),
                  if (suggestion!.documentType?.trim().isNotEmpty ?? false)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        top: AppSpacing.xs,
                      ),
                      child: Text(
                        suggestion!.documentType!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ] else ...[
                  _ClassificationValue(
                    label: l.organization,
                    value:
                        organizationName ??
                        (hasConfirmedOrganization
                            ? l.organization
                            : l.unclassified),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _ClassificationValue(
                    label: l.caseLabel,
                    value: caseName ?? l.caseNotAssigned,
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    if (onConfirm != null)
                      FilledButton(
                        key: const Key('classification-confirm'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          tapTargetSize: MaterialTapTargetSize.padded,
                        ),
                        onPressed: onConfirm,
                        child: Text(l.confirm),
                      ),
                    TextButton(
                      key: const Key('classification-change'),
                      style: TextButton.styleFrom(
                        minimumSize: const Size(0, 40),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.sm,
                        ),
                        tapTargetSize: MaterialTapTargetSize.padded,
                      ),
                      onPressed: onChange,
                      child: Text(
                        suggestion == null ? l.editClassification : l.change,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ClassificationValue extends StatelessWidget {
  const _ClassificationValue({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Text(
    '$label: $value',
    style: Theme.of(context).textTheme.bodyMedium
        ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
  );
}

class _OriginalDocumentSection extends StatelessWidget {
  const _OriginalDocumentSection({required this.files, required this.onOpen});
  final AsyncValue<List<DocumentFile>> files;
  final ValueChanged<List<DocumentFile>> onOpen;

  @override
  Widget build(BuildContext context) => Column(
    key: const Key('original-document-section'),
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        context.l10n.originalDocument,
        style: Theme.of(context).textTheme.titleMedium
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: AppSpacing.sm),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.insert_drive_file_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: files.when(
              data: (items) => items.isEmpty
                  ? Text(context.l10n.originalDocumentUnavailable)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.originalDocumentAvailable),
                        const SizedBox(height: AppSpacing.xs),
                        OutlinedButton.icon(
                          key: const Key('open-original-document'),
                          onPressed: () => onOpen(items),
                          icon: const Icon(Icons.open_in_new_outlined),
                          label: Text(context.l10n.openOriginalDocument),
                        ),
                      ],
                    ),
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => Text(context.l10n.originalDocumentUnavailable),
            ),
          ),
        ],
      ),
    ],
  );
}

Future<void> _saveClassification(
  WidgetRef ref,
  String clientDocumentId, {
  required String? organizationName,
  String? caseName,
  required List<Organization> organizations,
  required List<Case> cases,
}) async {
  final candidate = organizationName?.trim() ?? '';
  if (candidate.isEmpty) {
    await ref
        .read(documentRepositoryProvider)
        .updateClassification(
          clientDocumentId,
          state: ClassificationState.unclassified,
        );
    ref.invalidate(documentProvider(clientDocumentId));
    return;
  }
  final now = DateTime.now();
  final organization =
      matchingOrganization(organizations, candidate) ??
      Organization(
        id: ref.read(idGeneratorProvider).newId(),
        name: candidate,
        category: OrganizationCategory.other,
        createdAt: now,
        updatedAt: now,
      );
  if (!organizations.any((item) => item.id == organization.id)) {
    await ref.read(organizationRepositoryProvider).save(organization);
  }
  final caseCandidate = caseName?.trim() ?? '';
  final selectedCase = caseCandidate.isEmpty
      ? null
      : matchingCase(cases, organization.id, caseCandidate) ??
            Case(
              id: ref.read(idGeneratorProvider).newId(),
              organizationId: organization.id,
              title: caseCandidate,
              createdAt: now,
              updatedAt: now,
            );
  if (selectedCase != null &&
      !cases.any((item) => item.id == selectedCase.id)) {
    await ref.read(caseRepositoryProvider).save(selectedCase);
  }
  await ref
      .read(documentRepositoryProvider)
      .updateClassification(
        clientDocumentId,
        organizationId: organization.id,
        caseId: selectedCase?.id,
        state: ClassificationState.confirmed,
      );
  // All values shown above are provider-backed; force their local reads to
  // converge as soon as the atomic persistence work has completed.
  ref.invalidate(organizationsProvider);
  ref.invalidate(casesProvider);
  ref.invalidate(documentProvider(clientDocumentId));
}

Future<void> _showClassificationEditor(
  BuildContext context,
  WidgetRef ref,
  String clientDocumentId, {
  required String? organizationId,
  required String? caseId,
  required List<Organization> organizations,
  required List<Case> cases,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ClassificationEditorSheet(
      ref: ref,
      clientDocumentId: clientDocumentId,
      organizationId: organizationId,
      caseId: caseId,
      organizations: organizations,
      cases: cases,
    ),
  );
}

class _ClassificationEditorSheet extends StatefulWidget {
  const _ClassificationEditorSheet({
    required this.ref,
    required this.clientDocumentId,
    required this.organizationId,
    required this.caseId,
    required this.organizations,
    required this.cases,
  });

  final WidgetRef ref;
  final String clientDocumentId;
  final String? organizationId;
  final String? caseId;
  final List<Organization> organizations;
  final List<Case> cases;

  @override
  State<_ClassificationEditorSheet> createState() =>
      _ClassificationEditorSheetState();
}

class _ClassificationEditorSheetState
    extends State<_ClassificationEditorSheet> {
  late List<Organization> _organizations;
  late List<Case> _cases;
  late String? _selectedOrganizationId;
  late String? _selectedCaseId;
  late bool _clearCase;
  var _clearClassification = false;

  @override
  void initState() {
    super.initState();
    _organizations = [...widget.organizations];
    _cases = [...widget.cases];
    _selectedOrganizationId = widget.organizationId;
    _selectedCaseId = widget.caseId;
    _clearCase = widget.caseId == null;
    if (_selectedCaseId != null &&
        !_cases.any(
          (item) =>
              item.id == _selectedCaseId &&
              item.organizationId == _selectedOrganizationId,
        )) {
      _selectedCaseId = null;
      _clearCase = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final visibleCases = _cases
        .where((item) => item.organizationId == _selectedOrganizationId)
        .toList();
    final selectedOrganization = _organizations
        .where((item) => item.id == _selectedOrganizationId)
        .cast<Organization?>()
        .firstOrNull;
    final selectedCase = _cases
        .where((item) => item.id == _selectedCaseId)
        .cast<Case?>()
        .firstOrNull;
    final canRemoveCase = _selectedCaseId != null || widget.caseId != null;
    final canClearClassification =
        _selectedOrganizationId != null || widget.organizationId != null;
    final media = MediaQuery.sizeOf(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 560,
            maxHeight: media.height * .88,
          ),
          child: Material(
            key: const Key('classification-editor-modal'),
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.productName,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      IconButton(
                        key: const Key('classification-editor-close'),
                        tooltip: MaterialLocalizations.of(context)
                            .closeButtonTooltip,
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.editClassification,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _ClassificationSelectionField(
                    fieldKey: const Key('classification-organization-field'),
                    label: l10n.organization,
                    selectedLabel:
                        selectedOrganization?.name ?? l10n.chooseOrganization,
                    onTap: () async {
                      final selection = await _showOrganizationSelector(
                        context,
                        ref: widget.ref,
                        organizations: _organizations,
                        selectedOrganizationId: _selectedOrganizationId,
                      );
                      if (!mounted || selection == null) return;
                      setState(() {
                        final nextOrganizationId = selection.organization.id;
                        final currentCase = _cases
                            .where((item) => item.id == _selectedCaseId)
                            .cast<Case?>()
                            .firstOrNull;
                        _selectedOrganizationId = nextOrganizationId;
                        if (!_organizations.any(
                          (item) => item.id == selection.organization.id,
                        )) {
                          _organizations = [
                            ..._organizations,
                            selection.organization,
                          ];
                        }
                        if (currentCase?.organizationId != nextOrganizationId) {
                          _selectedCaseId = null;
                          _clearCase = currentCase != null;
                        }
                        _clearClassification = false;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ClassificationSelectionField(
                    fieldKey: const Key('classification-case-field'),
                    label: l10n.caseLabel,
                    selectedLabel: selectedCase?.title ?? l10n.caseNotAssigned,
                    onTap: selectedOrganization == null
                        ? null
                        : () async {
                            final selection = await _showCaseSelector(
                              context,
                              ref: widget.ref,
                              organization: selectedOrganization,
                              cases: visibleCases,
                              selectedCaseId: _selectedCaseId,
                            );
                            if (!mounted || selection == null) return;
                            setState(() {
                              _selectedCaseId = selection.caseItem?.id;
                              _clearCase = selection.noCase;
                              final caseItem = selection.caseItem;
                              if (caseItem != null &&
                                  !_cases.any(
                                    (item) => item.id == caseItem.id,
                                  )) {
                                _cases = [..._cases, caseItem];
                              }
                              _clearClassification = false;
                            });
                          },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    key: const Key('classification-editor-save'),
                    onPressed: () async {
                      await _saveClassification(
                        widget.ref,
                        widget.clientDocumentId,
                        organizationName: _clearClassification
                            ? null
                            : selectedOrganization?.name,
                        caseName: _clearClassification || _clearCase
                            ? null
                            : selectedCase?.title,
                        organizations: _organizations,
                        cases: _cases,
                      );
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: Text(l10n.save),
                  ),
                  if (canRemoveCase) ...[
                    const SizedBox(height: AppSpacing.sm),
                    OutlinedButton(
                      key: const Key('classification-remove-case'),
                      onPressed: () => setState(() {
                        _selectedCaseId = null;
                        _clearCase = true;
                        _clearClassification = false;
                      }),
                      child: Text(l10n.clearCase),
                    ),
                  ],
                  if (canClearClassification) ...[
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      key: const Key('classification-clear'),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () => setState(() {
                        _selectedOrganizationId = null;
                        _selectedCaseId = null;
                        _clearCase = true;
                        _clearClassification = true;
                      }),
                      child: Text(l10n.clearClassification),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ClassificationSelectionField extends StatelessWidget {
  const _ClassificationSelectionField({
    required this.fieldKey,
    required this.label,
    required this.selectedLabel,
    required this.onTap,
  });

  final Key fieldKey;
  final String label;
  final String selectedLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: onTap != null,
    enabled: onTap != null,
    label: label,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        key: fieldKey,
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(labelText: label),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
      ),
    ),
  );
}

class _OrganizationSelectorResult {
  const _OrganizationSelectorResult.select(this.organization);

  final Organization organization;
}

class _CaseSelectorResult {
  const _CaseSelectorResult.select(this.caseItem) : noCase = false;

  const _CaseSelectorResult.noCase() : caseItem = null, noCase = true;

  final Case? caseItem;
  final bool noCase;
}

Future<_OrganizationSelectorResult?> _showOrganizationSelector(
  BuildContext context, {
  required WidgetRef ref,
  required List<Organization> organizations,
  required String? selectedOrganizationId,
}) => showModalBottomSheet<_OrganizationSelectorResult>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  backgroundColor: Colors.transparent,
  builder: (_) => _OrganizationSelectorSheet(
    ref: ref,
    organizations: organizations,
    selectedOrganizationId: selectedOrganizationId,
  ),
);

class _OrganizationSelectorSheet extends StatefulWidget {
  const _OrganizationSelectorSheet({
    required this.ref,
    required this.organizations,
    required this.selectedOrganizationId,
  });

  final WidgetRef ref;
  final List<Organization> organizations;
  final String? selectedOrganizationId;

  @override
  State<_OrganizationSelectorSheet> createState() =>
      _OrganizationSelectorSheetState();
}

class _OrganizationSelectorSheetState
    extends State<_OrganizationSelectorSheet> {
  late final TextEditingController _searchController;
  var _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final normalizedQuery = _query.trim().toLowerCase();
    final visibleOrganizations = widget.organizations
        .where(
          (item) =>
              normalizedQuery.isEmpty ||
              item.name.toLowerCase().contains(normalizedQuery),
        )
        .toList();
    final media = MediaQuery.sizeOf(context);
    return SizedBox(
      height: media.height * .82,
      child: Material(
        key: const Key('organization-selector-modal'),
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.productName,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    key: const Key('organization-selector-close'),
                    tooltip: MaterialLocalizations.of(context)
                        .closeButtonTooltip,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.selectOrganization,
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                key: const Key('organization-selector-search'),
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  labelText: l10n.searchOrganization,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: MaterialLocalizations.of(context)
                              .clearButtonTooltip,
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                          icon: const Icon(Icons.clear),
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: visibleOrganizations.isEmpty
                    ? Center(
                        child: Text(
                          l10n.noMatchingOrganizations,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      )
                    : ListView.separated(
                        key: const Key('organization-selector-list'),
                        itemCount: visibleOrganizations.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final organization = visibleOrganizations[index];
                          final selected =
                              organization.id == widget.selectedOrganizationId;
                          return ListTile(
                            key: Key(
                              'organization-selector-${organization.id}',
                            ),
                            selected: selected,
                            selectedTileColor: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withValues(alpha: .45),
                            title: Text(
                              organization.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: selected
                                ? Icon(
                                    Icons.check,
                                    key: Key(
                                      'organization-selector-selected-${organization.id}',
                                    ),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  )
                                : null,
                            onTap: () => Navigator.pop(
                              context,
                              _OrganizationSelectorResult.select(organization),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                key: const Key('organization-selector-create'),
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final created = await _showCreateOrganization(
                    context,
                    ref: widget.ref,
                    organizations: widget.organizations,
                  );
                  if (!mounted) return;
                  if (created == null) return;
                  navigator.pop(_OrganizationSelectorResult.select(created));
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.createOrganization),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Organization?> _showCreateOrganization(
  BuildContext context, {
  required WidgetRef ref,
  required List<Organization> organizations,
}) => showModalBottomSheet<Organization>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  backgroundColor: Colors.transparent,
  builder: (_) =>
      _CreateOrganizationSheet(ref: ref, organizations: organizations),
);

class _CreateOrganizationSheet extends StatefulWidget {
  const _CreateOrganizationSheet({
    required this.ref,
    required this.organizations,
  });

  final WidgetRef ref;
  final List<Organization> organizations;

  @override
  State<_CreateOrganizationSheet> createState() =>
      _CreateOrganizationSheetState();
}

class _CreateOrganizationSheetState extends State<_CreateOrganizationSheet> {
  late final TextEditingController _nameController;
  var _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = context.l10n.organizationNameRequired);
      return;
    }
    final existing = matchingOrganization(widget.organizations, name);
    if (existing != null) {
      FocusScope.of(context).unfocus();
      Navigator.pop(context, existing);
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final now = DateTime.now();
      final organization = Organization(
        id: widget.ref.read(idGeneratorProvider).newId(),
        name: name,
        category: OrganizationCategory.other,
        createdAt: now,
        updatedAt: now,
      );
      await widget.ref.read(organizationRepositoryProvider).save(organization);
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      Navigator.pop(context, organization);
    } catch (_) {
      if (mounted) {
        setState(() => _error = context.l10n.organizationCreateFailed);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final media = MediaQuery.sizeOf(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: media.height * .58),
        child: Material(
          key: const Key('create-organization-modal'),
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.productName,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      key: const Key('create-organization-close'),
                      tooltip: MaterialLocalizations.of(context)
                          .closeButtonTooltip,
                      onPressed: _submitting
                          ? null
                          : () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.createOrganization,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  key: const Key('create-organization-name'),
                  controller: _nameController,
                  enabled: !_submitting,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  onChanged: (_) {
                    if (_error != null) setState(() => _error = null);
                  },
                  decoration: InputDecoration(
                    labelText: l10n.organizationName,
                    errorText: _error,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  key: const Key('create-organization-submit'),
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.create),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<_CaseSelectorResult?> _showCaseSelector(
  BuildContext context, {
  required WidgetRef ref,
  required Organization organization,
  required List<Case> cases,
  required String? selectedCaseId,
}) => showModalBottomSheet<_CaseSelectorResult>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  backgroundColor: Colors.transparent,
  builder: (_) => _CaseSelectorSheet(
    ref: ref,
    organization: organization,
    cases: cases,
    selectedCaseId: selectedCaseId,
  ),
);

class _CaseSelectorSheet extends StatefulWidget {
  const _CaseSelectorSheet({
    required this.ref,
    required this.organization,
    required this.cases,
    required this.selectedCaseId,
  });

  final WidgetRef ref;
  final Organization organization;
  final List<Case> cases;
  final String? selectedCaseId;

  @override
  State<_CaseSelectorSheet> createState() => _CaseSelectorSheetState();
}

class _CaseSelectorSheetState extends State<_CaseSelectorSheet> {
  late final TextEditingController _searchController;
  var _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final normalizedQuery = _query.trim().toLowerCase();
    final visibleCases = widget.cases
        .where(
          (item) =>
              item.organizationId == widget.organization.id &&
              (normalizedQuery.isEmpty ||
                  item.title.toLowerCase().contains(normalizedQuery)),
        )
        .toList();
    final media = MediaQuery.sizeOf(context);
    return SizedBox(
      height: media.height * .82,
      child: Material(
        key: const Key('case-selector-modal'),
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.productName,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    key: const Key('case-selector-close'),
                    tooltip: MaterialLocalizations.of(context)
                        .closeButtonTooltip,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                widget.organization.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.selectCase,
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                key: const Key('case-selector-search'),
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  labelText: l10n.searchCase,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: MaterialLocalizations.of(context)
                              .clearButtonTooltip,
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                          icon: const Icon(Icons.clear),
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                key: const Key('case-selector-no-case'),
                onPressed: () =>
                    Navigator.pop(context, const _CaseSelectorResult.noCase()),
                child: Text(l10n.withoutCase),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: visibleCases.isEmpty
                    ? Center(
                        child: Text(
                          l10n.noMatchingCases,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      )
                    : ListView.separated(
                        key: const Key('case-selector-list'),
                        itemCount: visibleCases.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = visibleCases[index];
                          final selected = item.id == widget.selectedCaseId;
                          return ListTile(
                            key: Key('case-selector-${item.id}'),
                            selected: selected,
                            selectedTileColor: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withValues(alpha: .45),
                            title: Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: selected
                                ? Icon(
                                    Icons.check,
                                    key: Key(
                                      'case-selector-selected-${item.id}',
                                    ),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  )
                                : null,
                            onTap: () => Navigator.pop(
                              context,
                              _CaseSelectorResult.select(item),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                key: const Key('case-selector-create'),
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final created = await _showCreateCase(
                    context,
                    ref: widget.ref,
                    organization: widget.organization,
                    cases: widget.cases,
                  );
                  if (!mounted) return;
                  if (created == null) return;
                  navigator.pop(_CaseSelectorResult.select(created));
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.createCase),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Case?> _showCreateCase(
  BuildContext context, {
  required WidgetRef ref,
  required Organization organization,
  required List<Case> cases,
}) => showModalBottomSheet<Case>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  backgroundColor: Colors.transparent,
  builder: (_) =>
      _CreateCaseSheet(ref: ref, organization: organization, cases: cases),
);

class _CreateCaseSheet extends StatefulWidget {
  const _CreateCaseSheet({
    required this.ref,
    required this.organization,
    required this.cases,
  });

  final WidgetRef ref;
  final Organization organization;
  final List<Case> cases;

  @override
  State<_CreateCaseSheet> createState() => _CreateCaseSheetState();
}

class _CreateCaseSheetState extends State<_CreateCaseSheet> {
  late final TextEditingController _titleController;
  var _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _error = context.l10n.caseNameRequired);
      return;
    }
    final existing = matchingCase(widget.cases, widget.organization.id, title);
    if (existing != null) {
      FocusScope.of(context).unfocus();
      Navigator.pop(context, existing);
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final now = DateTime.now();
      final item = Case(
        id: widget.ref.read(idGeneratorProvider).newId(),
        organizationId: widget.organization.id,
        title: title,
        createdAt: now,
        updatedAt: now,
      );
      await widget.ref.read(caseRepositoryProvider).save(item);
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      Navigator.pop(context, item);
    } catch (_) {
      if (mounted) setState(() => _error = context.l10n.caseCreateFailed);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final media = MediaQuery.sizeOf(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: media.height * .64),
        child: Material(
          key: const Key('create-case-modal'),
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.productName,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      key: const Key('create-case-close'),
                      tooltip: MaterialLocalizations.of(context)
                          .closeButtonTooltip,
                      onPressed: _submitting
                          ? null
                          : () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.createCase,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.organization,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  widget.organization.name,
                  key: const Key('create-case-organization-context'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  key: const Key('create-case-name'),
                  controller: _titleController,
                  enabled: !_submitting,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  onChanged: (_) {
                    if (_error != null) setState(() => _error = null);
                  },
                  decoration: InputDecoration(
                    labelText: l10n.caseName,
                    errorText: _error,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  key: const Key('create-case-submit'),
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.create),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

T? _asyncValue<T>(AsyncValue<T> value) =>
    value is AsyncData<T> ? value.value : null;

T? _first<T>(List<T>? values) =>
    values == null || values.isEmpty ? null : values.first;

String? _findOrganization(List<Organization>? values, String id) {
  for (final value in values ?? <Organization>[]) {
    if (value.id == id) return value.name;
  }
  return null;
}

String? _findCase(List<Case>? values, String id) {
  for (final value in values ?? <Case>[]) {
    if (value.id == id) return value.title;
  }
  return null;
}
