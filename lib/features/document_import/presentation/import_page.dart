import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/logging/debug_log.dart';
import '../../../shared/design_system/app_widgets.dart';
import '../../document_analysis/domain/analysis_submission.dart';
import '../../document_analysis/presentation/analysis_result_page.dart';
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
              builder: (_) => AnalysisResultPage(
                clientDocumentId: terminal.result!.clientDocumentId,
              ),
            ),
          );
        }
        return;
      }
      final submission = _submission ??= await _createSubmission(selection);
      final arabic = ref.read(languageProvider)?.languageCode == 'ar';
      final accepted = await ref
          .read(analysisWorkflowProvider)
          .submit(
            submission.copyWith(
              language: arabic
                  ? ExplanationLanguage.arabic
                  : ExplanationLanguage.german,
              style: arabic
                  ? ExplanationStyle.standard
                  : ExplanationStyle.simple,
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
            builder: (_) => AnalysisResultPage(
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
        analysisDebugLog('controller', 'failed type=${error.runtimeType}');
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.importDocument)),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.foundationMessage,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (_selection != null) ...[
                const SizedBox(height: AppSpacing.md),
                AppSectionCard(
                  child: ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: Text(l10n.selectedDocument),
                    subtitle: Text('${_selection!.files.length} file(s)'),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                FilledButton.icon(
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
                      onTap: _busy ? null : () => _select(ImportSource.pdfFile),
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_camera_outlined),
                      title: Text(l10n.camera),
                      subtitle: Text(l10n.cameraDeferred),
                      onTap: _busy ? null : () => _select(ImportSource.camera),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
