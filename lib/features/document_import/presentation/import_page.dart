import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/logging/debug_log.dart';
import '../../../shared/design_system/app_widgets.dart';
import '../../document_analysis/domain/analysis_submission.dart';
import '../../document_analysis/domain/analysis_output_language.dart';
import '../../document_analysis/presentation/document_detail_page.dart';
import '../../documents/domain/entities/domain_entities.dart';
import '../domain/document_import.dart';

class ImportPage extends ConsumerStatefulWidget {
  const ImportPage({super.key});
  @override
  ConsumerState<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends ConsumerState<ImportPage> {
  DocumentImportSelection? _selection;
  String? _message;
  bool _busy = false;
  String? _idempotencyKey;
  AnalysisSubmission? _submission;
  bool _processingModalVisible = false;
  String? _processingModalOperationId;

  void _showProcessingModal(String operationId) {
    if (_processingModalVisible || !mounted) return;
    _processingModalVisible = true;
    _processingModalOperationId = operationId;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ProcessingOverlay(
        operationId: operationId,
        onDismiss: () => _dismissProcessingModal(operationId),
      ),
    ).whenComplete(() {
      if (_processingModalOperationId == operationId) {
        _processingModalVisible = false;
        _processingModalOperationId = null;
      }
    });
  }

  void _dismissProcessingModal(String operationId) {
    if (!_processingModalVisible ||
        _processingModalOperationId != operationId ||
        !mounted) {
      return;
    }
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) navigator.pop();
  }

  Future<void> _select(ImportSource source) async {
    final result = await ref.read(importGatewayProvider).pickSelection(source);
    if (!mounted) return;
    result.when(
      success: (selection) => setState(() {
        _selection = selection;
        _idempotencyKey = null;
        _submission = null;
        _message = null;
      }),
      failure: (error) {
        if (error is! ImportCancelledError) {
          setState(() => _message = context.l10n.importError);
        }
      },
    );
  }

  void _removeSelection() {
    if (_busy) return;
    setState(() {
      _selection = null;
      _idempotencyKey = null;
      _submission = null;
      _message = null;
    });
  }

  Future<void> _analyze() async {
    final selection = _selection;
    if (selection == null || _busy) return;
    setState(() {
      _busy = true;
      _message = context.l10n.analysisUploading;
    });
    try {
      final submission = _submission ??= await _createSubmission(selection);
      final analysisLanguage = ref.read(analysisLanguageProvider);
      final accepted = await ref
          .read(analysisWorkflowProvider)
          .submit(
            submission.copyWith(
              language: analysisLanguage.explanationLanguage,
              style: analysisLanguage.explanationStyle,
              idempotencyKey: _idempotencyKey ??= ref
                  .read(idGeneratorProvider)
                  .newId(),
            ),
          );
      _idempotencyKey = null;
      _submission = null;
      if (mounted) {
        setState(() {
          _selection = null;
          _message = null;
          _busy = false;
        });
        _showProcessingModal(accepted.operationId);
      }
      unawaited(
        _observeAcceptedOperation(
          accepted.operationId,
          submission.clientDocumentId,
        ),
      );
    } catch (error) {
      final terminalFailure =
          error is RemoteApiError && error.isTerminalOperationFailure;
      if (terminalFailure) {
        analysisDebugLog('controller', 'terminal failure code=${error.code}');
        _idempotencyKey = null;
      } else {
        final cause = error is AppError ? error.cause : null;
        analysisDebugLog(
          'controller',
          'failed type=${error.runtimeType} '
              'cause_type=${cause?.runtimeType ?? 'none'}',
        );
      }
      if (mounted) {
        setState(() {
          _busy = false;
          _message = error is RemoteApiError && error.retryable
              ? context.l10n.operationRetryableError
              : error is AppError
              ? context.l10n.operationFailedError
              : context.l10n.analysisFailed;
        });
      }
    }
  }

  Future<void> _observeAcceptedOperation(
    String operationId,
    String clientDocumentId,
  ) async {
    try {
      final terminal = await ref
          .read(analysisWorkflowProvider)
          .poll(operationId, clientDocumentId);
      if (!mounted) return;
      final wasVisible = _processingModalOperationId == operationId;
      _dismissProcessingModal(operationId);
      if (terminal.status == BackendOperationStatus.succeeded && wasVisible) {
        analysisDebugLog(
          'controller',
          'analysis success; navigating to result',
        );
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                DocumentDetailPage(clientDocumentId: clientDocumentId),
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;
      final wasVisible = _processingModalOperationId == operationId;
      _dismissProcessingModal(operationId);
      if (!wasVisible) return;
      final terminalFailure =
          error is RemoteApiError && error.isTerminalOperationFailure;
      if (terminalFailure) {
        analysisDebugLog('controller', 'terminal failure code=${error.code}');
      }
      setState(() {
        _message = error is RemoteApiError && error.retryable
            ? context.l10n.operationRetryableError
            : error is AppError
            ? context.l10n.operationFailedError
            : context.l10n.analysisFailed;
      });
    }
  }

  Future<AnalysisSubmission> _createSubmission(
    DocumentImportSelection selection,
  ) async {
    final id = ref.read(idGeneratorProvider).newId();
    final now = DateTime.now();
    final files = [
      for (var index = 0; index < selection.files.length; index++)
        DocumentFile(
          id: ref.read(idGeneratorProvider).newId(),
          clientDocumentId: id,
          localUri: selection.files[index].localUri,
          mediaType: selection.files[index].mediaType == ImportedMediaType.pdf
              ? 'application/pdf'
              : 'image/jpeg',
          originalFilename: selection.files[index].originalFilename,
          byteSize: selection.files[index].byteSize,
          importedAt: selection.files[index].importedAt,
          pageOrder: index,
        ),
    ];
    final document = LocalDocument(
      clientDocumentId: id,
      classificationState: ClassificationState.unclassified,
      status: DocumentStatus.imported,
      createdAt: now,
      updatedAt: now,
    );
    final repository = ref.read(documentRepositoryProvider);
    for (final file in files) {
      await repository.saveImportedDocument(document, file);
    }
    return AnalysisSubmission(
      clientDocumentId: id,
      files: files,
      language: ExplanationLanguage.german,
      style: ExplanationStyle.simple,
      idempotencyKey: 'pending',
    );
  }

  Future<void> _showFileChoices() => showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            key: const Key('import-choose-image'),
            leading: const Icon(Icons.image_outlined),
            title: Text(context.l10n.images),
            onTap: _busy
                ? null
                : () {
                    Navigator.of(sheetContext).pop();
                    _select(ImportSource.imageLibrary);
                  },
          ),
          ListTile(
            key: const Key('import-choose-pdf'),
            leading: const Icon(Icons.picture_as_pdf_outlined),
            title: Text(context.l10n.pdf),
            onTap: _busy
                ? null
                : () {
                    Navigator.of(sheetContext).pop();
                    _select(ImportSource.pdfFile);
                  },
          ),
        ],
      ),
    ),
  );

  String _selectedFilename(DocumentImportSelection selection) {
    final file = selection.files.first;
    final filename = file.originalFilename;
    if (filename != null && filename.trim().isNotEmpty) return filename;
    final pathSegments = file.localUri.pathSegments;
    return pathSegments.isEmpty ? '' : pathSegments.last;
  }

  Widget _languageSelector(
    BuildContext context,
    AnalysisOutputLanguage analysisLanguage,
  ) {
    final l10n = context.l10n;
    return Semantics(
      label: l10n.analysisLanguageLabel,
      child: DecoratedBox(
        key: const Key('analysis-language-selector'),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 8, 4),
          child: Row(
            children: [
              const Icon(Icons.translate_outlined, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.analysisLanguageLabel,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              PopupMenuButton<AnalysisOutputLanguage>(
                enabled: !_busy,
                tooltip: l10n.analysisLanguageLabel,
                onSelected: (value) => ref
                    .read(analysisLanguageProvider.notifier)
                    .setLanguage(value),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: AnalysisOutputLanguage.arabic,
                    child: Text(l10n.analysisLanguageArabic),
                  ),
                  PopupMenuItem(
                    value: AnalysisOutputLanguage.simpleGerman,
                    child: Text(l10n.analysisLanguageSimpleGerman),
                  ),
                ],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      analysisLanguage == AnalysisOutputLanguage.arabic
                          ? l10n.analysisLanguageArabic
                          : l10n.analysisLanguageSimpleGerman,
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final analysisLanguage = ref.watch(analysisLanguageProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.fromSTEB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.productName,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  if (_selection == null) ...[
                    Text(
                      l10n.addDocumentForAnalysis,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton.icon(
                      key: const Key('capture-document-action'),
                      onPressed: _busy
                          ? null
                          : () => _select(ImportSource.camera),
                      icon: const Icon(Icons.document_scanner_outlined),
                      label: Text(l10n.captureDocument),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    OutlinedButton.icon(
                      key: const Key('choose-file-image-action'),
                      onPressed: _busy ? null : _showFileChoices,
                      icon: const Icon(Icons.insert_drive_file_outlined),
                      label: Text(l10n.chooseFileOrImage),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.supportedFormats,
                      key: const Key('supported-formats-guidance'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _languageSelector(context, analysisLanguage),
                  ] else ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.selectedDocument,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppSectionCard(
                      child: ListTile(
                        key: const Key('selected-import-draft'),
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
                          AppSpacing.md,
                          AppSpacing.sm,
                          AppSpacing.sm,
                          AppSpacing.sm,
                        ),
                        leading: Icon(
                          _selection!.isPdf
                              ? Icons.picture_as_pdf_outlined
                              : Icons.description_outlined,
                        ),
                        title: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            _selectedFilename(_selection!),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        subtitle: Text(
                          _selection!.isPdf ? l10n.pdf : l10n.images,
                        ),
                        trailing: TextButton(
                          key: const Key('remove-import-draft'),
                          onPressed: _busy ? null : _removeSelection,
                          child: Text(l10n.remove),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton.icon(
                        key: const Key('replace-import-draft'),
                        onPressed: _busy ? null : _showFileChoices,
                        icon: const Icon(Icons.swap_horiz_outlined),
                        label: Text(l10n.chooseFileOrImage),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _languageSelector(context, analysisLanguage),
                    const SizedBox(height: AppSpacing.md),
                    FilledButton.icon(
                      key: const Key('analyze-draft-action'),
                      onPressed: _busy ? null : _analyze,
                      icon: const Icon(Icons.auto_awesome),
                      label: Text(l10n.startAnalysis),
                    ),
                  ],
                  if (_message != null)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Text(_message!),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProcessingOverlay extends ConsumerWidget {
  const _ProcessingOverlay({
    required this.operationId,
    required this.onDismiss,
  });

  final String operationId;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final activeOperations = ref.watch(activeAnalysisOperationsProvider);
    final state = activeOperations.when(
      data: (operations) {
        final matching = operations
            .where((operation) => operation.operationId == operationId)
            .toList();
        return matching.isEmpty
            ? AnalysisLifecycleState.accepted
            : matching.first.state;
      },
      loading: () => AnalysisLifecycleState.accepted,
      error: (_, _) => AnalysisLifecycleState.accepted,
    );
    final analysisInProgress = state == AnalysisLifecycleState.processing;

    return Dialog(
      key: const Key('processing-overlay'),
      insetPadding: const EdgeInsets.all(AppSpacing.lg),
      backgroundColor: AppColors.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: IconButton(
                  key: const Key('processing-close'),
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: onDismiss,
                  icon: const Icon(Icons.close),
                ),
              ),
              Icon(
                Icons.document_scanner_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.processingTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.processingDescription,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.lg),
              _ProcessingStages(analysisInProgress: analysisInProgress),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.cancellationUnavailable,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                key: const Key('processing-cancel-unavailable'),
                onPressed: null,
                icon: const Icon(Icons.cancel_outlined),
                label: Text(l10n.cancelAnalysis),
              ),
              const SizedBox(height: AppSpacing.sm),
              FilledButton.icon(
                key: const Key('processing-continue-background'),
                onPressed: onDismiss,
                icon: const Icon(Icons.arrow_forward),
                label: Text(l10n.continueInBackground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProcessingStages extends StatelessWidget {
  const _ProcessingStages({required this.analysisInProgress});

  final bool analysisInProgress;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _ProcessingStage(label: l10n.processingAccepted, complete: true),
          const SizedBox(height: AppSpacing.sm),
          _ProcessingStage(
            label: analysisInProgress
                ? l10n.analysisInProgress
                : l10n.processingWaiting,
            active: true,
          ),
        ],
      ),
    );
  }
}

class _ProcessingStage extends StatelessWidget {
  const _ProcessingStage({
    required this.label,
    this.complete = false,
    this.active = false,
  });

  final String label;
  final bool complete;
  final bool active;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(
        complete ? Icons.check_circle : Icons.schedule,
        color: complete || active ? AppColors.primary : AppColors.textSecondary,
        size: 20,
      ),
      const SizedBox(width: AppSpacing.sm),
      Expanded(
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    ],
  );
}
