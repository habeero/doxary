import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/design_system/app_widgets.dart';
import '../../documents/domain/entities/domain_entities.dart';
import '../../documents/domain/classification/classification_selection.dart';
import '../../documents/presentation/document_display.dart';
import 'analysis_result_page.dart';

class DocumentDetailPage extends ConsumerWidget {
  const DocumentDetailPage({required this.clientDocumentId, super.key});
  final String clientDocumentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final document = ref.watch(documentProvider(clientDocumentId));
    final files = ref.watch(documentFilesProvider(clientDocumentId));
    final analysis = ref.watch(latestAnalysisProvider(clientDocumentId));
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
    final title = documentDisplayTitle(
      localDocument ??
          LocalDocument(
            clientDocumentId: clientDocumentId,
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
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                if (localDocument != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '${l10n.organization}: ${organizationName ?? (hasConfirmedOrganization ? l10n.organization : l10n.unclassified)}',
                  ),
                  Text(
                    '${l10n.caseLabel}: ${caseName ?? l10n.caseNotAssigned}',
                  ),
                  if (hasUnresolvedOrganizationSuggestion) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(l10n.suggestedClassification),
                    Text(latest!.classification!.organizationName!),
                    if (latest.classification!.documentType != null)
                      Text(latest.classification!.documentType!),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.sm,
                      children: [
                        FilledButton(
                          onPressed: () => _saveClassification(
                            ref,
                            clientDocumentId,
                            organizationName:
                                latest.classification!.organizationName,
                            organizations:
                                _asyncValue(organizations) ?? const [],
                            cases: _asyncValue(cases) ?? const [],
                          ),
                          child: Text(l10n.confirm),
                        ),
                        OutlinedButton(
                          onPressed: () => _showClassificationEditor(
                            context,
                            ref,
                            clientDocumentId,
                            organizationId: organizationId,
                            caseId: caseId,
                            organizations:
                                _asyncValue(organizations) ?? const [],
                            cases: _asyncValue(cases) ?? const [],
                          ),
                          child: Text(l10n.change),
                        ),
                      ],
                    ),
                  ],
                  if (!hasUnresolvedOrganizationSuggestion)
                    TextButton(
                      onPressed: () => _showClassificationEditor(
                        context,
                        ref,
                        clientDocumentId,
                        organizationId: organizationId,
                        caseId: caseId,
                        organizations: _asyncValue(organizations) ?? const [],
                        cases: _asyncValue(cases) ?? const [],
                      ),
                      child: Text(l10n.editClassification),
                    ),
                  Text(
                    '${l10n.analysisState}: ${_documentStatus(l10n, localDocument.status)}',
                  ),
                  Text(
                    localDocument.documentDate == null
                        ? '${l10n.receivedDate}: ${localDocument.createdAt.year}'
                        : '${l10n.documentDate}: ${localDocument.documentDate!.year}',
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppSectionCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.insert_drive_file_outlined),
              title: Text(l10n.originalDocument),
              subtitle: files.when(
                data: (items) => items.isEmpty
                    ? Text(l10n.originalDocumentUnavailable)
                    : Text(
                        items.first.originalFilename ??
                            l10n.originalDocumentUnavailable,
                      ),
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => Text(l10n.originalDocumentUnavailable),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 520,
            child: AnalysisResultPage(
              clientDocumentId: clientDocumentId,
              embedded: true,
            ),
          ),
        ],
      ),
    );
  }
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
  await showDialog<void>(
    context: context,
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

String _documentStatus(AppLocalizations l10n, DocumentStatus status) =>
    switch (status) {
      DocumentStatus.imported => l10n.imported,
      DocumentStatus.processing => l10n.analysisUploading,
      DocumentStatus.analyzed => l10n.analysisComplete,
      DocumentStatus.needsReview => l10n.analysisFailed,
      DocumentStatus.archived => l10n.archived,
      DocumentStatus.deleted => l10n.deleted,
    };
