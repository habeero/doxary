import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/errors/app_error.dart';
import '../domain/analysis_output_language.dart';
import '../domain/analysis_submission.dart';
import '../../documents/domain/entities/domain_entities.dart';
import '../../documents/domain/classification/classification_selection.dart';
import '../../documents/presentation/document_display.dart';
import 'analysis_result_page.dart';

class DocumentDetailPage extends ConsumerStatefulWidget {
  const DocumentDetailPage({required this.clientDocumentId, super.key});
  final String clientDocumentId;

  @override
  ConsumerState<DocumentDetailPage> createState() => _DocumentDetailPageState();
}

class _DocumentDetailPageState extends ConsumerState<DocumentDetailPage> {
  bool _retrying = false;
  String? _actionMessage;

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
        ..invalidate(latestAnalysisProvider(widget.clientDocumentId));
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _actionMessage = error is RemoteApiError && error.retryable
            ? context.l10n.operationRetryableError
            : context.l10n.operationFailedError;
      });
    } finally {
      if (mounted) setState(() => _retrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final document = ref.watch(documentProvider(widget.clientDocumentId));
    final files = ref.watch(documentFilesProvider(widget.clientDocumentId));
    final analysis = ref.watch(latestAnalysisProvider(widget.clientDocumentId));
    final organizations = ref.watch(organizationsProvider);
    final cases = ref.watch(casesProvider);
    final localDocument = _asyncValue(document);
    final latest = _asyncValue(analysis);
    final organizationId = localDocument?.organizationId;
    final caseId = localDocument?.caseId;
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
    final originalSection = _OriginalDocumentSection(files: files);
    final fileItems = _asyncValue(files) ?? const <DocumentFile>[];
    final body = switch (analysis) {
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncError() => DocumentResultView(
        title: title,
        technicalFailure: true,
        classificationSection: classificationSection,
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
                      originalDocumentSection: originalSection,
                    )
            : DocumentResultView(
                title: title,
                analysis: value,
                classificationSection: classificationSection,
                originalDocumentSection: originalSection,
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
    required this.originalDocumentSection,
  });
  final String title;
  final Widget? classificationSection;
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
      if (classificationSection != null) ...[
        const SizedBox(height: AppSpacing.lg),
        classificationSection!,
      ],
      const Divider(height: AppSpacing.xl),
      originalDocumentSection,
    ],
  );
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
  const _OriginalDocumentSection({required this.files});
  final AsyncValue<List<DocumentFile>> files;

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
              data: (items) => Text(
                items.isEmpty
                    ? context.l10n.originalDocumentUnavailable
                    : context.l10n.originalDocumentSavedLocally,
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
  final l10n = context.l10n;
  final organizationController = TextEditingController();
  final caseController = TextEditingController();
  var selectedOrganizationId = organizationId;
  var selectedCaseId = caseId;
  var clearCase = false;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        final visibleCases = cases
            .where((item) => item.organizationId == selectedOrganizationId)
            .toList();
        return AlertDialog(
          title: Text(l10n.editClassification),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  key: ValueKey(selectedOrganizationId),
                  initialValue: selectedOrganizationId ?? '__new__',
                  decoration: InputDecoration(
                    labelText: l10n.chooseOrganization,
                  ),
                  items: [
                    const DropdownMenuItem(value: '__new__', child: Text('+')),
                    ...organizations.map(
                      (item) => DropdownMenuItem(
                        value: item.id,
                        child: Text(item.name),
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(() {
                    selectedOrganizationId = value == '__new__' ? null : value;
                    selectedCaseId = null;
                  }),
                ),
                if (selectedOrganizationId == null)
                  TextField(
                    controller: organizationController,
                    decoration: InputDecoration(
                      labelText: l10n.organizationName,
                    ),
                  ),
                DropdownButtonFormField<String>(
                  key: ValueKey('$selectedOrganizationId:$selectedCaseId'),
                  initialValue: selectedCaseId ?? '__none__',
                  decoration: InputDecoration(labelText: l10n.caseLabel),
                  items: [
                    DropdownMenuItem(
                      value: '__none__',
                      child: Text(l10n.clearCase),
                    ),
                    const DropdownMenuItem(value: '__new__', child: Text('+')),
                    ...visibleCases.map(
                      (item) => DropdownMenuItem(
                        value: item.id,
                        child: Text(item.title),
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(() {
                    selectedCaseId = value == '__none__' || value == '__new__'
                        ? null
                        : value;
                    clearCase = value == '__none__';
                  }),
                ),
                if (!clearCase && selectedCaseId == null)
                  TextField(
                    controller: caseController,
                    decoration: InputDecoration(labelText: l10n.caseName),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                final selectedOrganization = organizations
                    .where((item) => item.id == selectedOrganizationId)
                    .cast<Organization?>()
                    .firstOrNull;
                final selectedCase = cases
                    .where((item) => item.id == selectedCaseId)
                    .cast<Case?>()
                    .firstOrNull;
                await _saveClassification(
                  ref,
                  clientDocumentId,
                  organizationName:
                      selectedOrganization?.name ?? organizationController.text,
                  caseName: clearCase
                      ? null
                      : selectedCase?.title ?? caseController.text,
                  organizations: organizations,
                  cases: cases,
                );
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    ),
  );
  organizationController.dispose();
  caseController.dispose();
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
