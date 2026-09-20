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
  String? _pendingOperationId;

  Future<void> _select(ImportSource source) async {
    final result = await ref.read(importGatewayProvider).pickSelection(source);
    if (!mounted) return;
    result.when(
      success: (selection) => setState(() {
        _selection = selection;
        _idempotencyKey = null;
        _submission = null;
        _pendingOperationId = null;
        _message = null;
      }),
      failure: (error) {
        if (error is! ImportCancelledError) {
          setState(() => _message = context.l10n.importError);
        }
      },
    );
  }

  Future<void> _analyze() async {
    final selection = _selection;
    if (selection == null || _busy) return;
    setState(() {
      _busy = true;
      _message = context.l10n.analysisUploading;
    });
    try {
      if (_pendingOperationId != null) {
        final terminal = await ref
            .read(analysisWorkflowProvider)
            .poll(_pendingOperationId!, _submission!.clientDocumentId);
        if (terminal.status == BackendOperationStatus.succeeded && mounted) {
          _pendingOperationId = null;
          _submission = null;
          setState(() => _busy = false);
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DocumentDetailPage(
                clientDocumentId: terminal.result!.clientDocumentId,
              ),
            ),
          );
        }
        return;
      }
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
      _pendingOperationId = accepted.operationId;
      _idempotencyKey = null;
      if (mounted) setState(() => _message = context.l10n.analysisStarted);
      final terminal = await ref
          .read(analysisWorkflowProvider)
          .poll(accepted.operationId, submission.clientDocumentId);
      if (mounted) {
        if (terminal.status != BackendOperationStatus.succeeded) {
          _pendingOperationId = null;
          _submission = null;
          setState(() => _busy = false);
          return;
        }
        _pendingOperationId = null;
        _submission = null;
        analysisDebugLog(
          'controller',
          'analysis success; navigating to result',
        );
        setState(() => _busy = false);
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DocumentDetailPage(
              clientDocumentId: submission.clientDocumentId,
            ),
          ),
        );
      }
    } catch (error) {
      final terminalFailure =
          error is RemoteApiError && error.isTerminalOperationFailure;
      if (terminalFailure) {
        analysisDebugLog('controller', 'terminal failure code=${error.code}');
        _pendingOperationId = null;
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
    return SafeArea(
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
                  AppSectionCard(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.description_outlined),
                          title: Text(l10n.selectedDocument),
                          subtitle: Text('${_selection!.files.length} file(s)'),
                        ),
                        _languageSelector(context, analysisLanguage),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  FilledButton.icon(
                    onPressed: _busy ? null : _analyze,
                    icon: const Icon(Icons.auto_awesome),
                    label: Text(l10n.startAnalysis),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppSectionCard(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.image_outlined),
                          title: Text(l10n.images),
                          onTap: _busy
                              ? null
                              : () => _select(ImportSource.imageLibrary),
                        ),
                        ListTile(
                          leading: const Icon(Icons.picture_as_pdf_outlined),
                          title: Text(l10n.pdf),
                          onTap: _busy
                              ? null
                              : () => _select(ImportSource.pdfFile),
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo_camera_outlined),
                          title: Text(l10n.camera),
                          subtitle: Text(l10n.cameraDeferred),
                          onTap: _busy
                              ? null
                              : () => _select(ImportSource.camera),
                        ),
                      ],
                    ),
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
    );
  }
}
