import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/errors/app_error.dart';
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

  Future<void> _select(ImportSource source) async {
    final result = await ref.read(importGatewayProvider).pickSelection(source);
    if (!mounted) return;
    result.when(
      success: (selection) => setState(() {
        _selection = selection;
        _message = null;
      }),
      failure: (error) {
        if (error is! ImportCancelledError) {
          setState(() => _message = error.message);
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
    final id = ref.read(idGeneratorProvider).newId();
    final now = DateTime.now();
    final files = <DocumentFile>[];
    for (var index = 0; index < selection.files.length; index++) {
      final candidate = selection.files[index];
      files.add(
        DocumentFile(
          id: ref.read(idGeneratorProvider).newId(),
          clientDocumentId: id,
          localUri: candidate.localUri,
          mediaType: candidate.mediaType == ImportedMediaType.pdf
              ? 'application/pdf'
              : (candidate.originalFilename?.toLowerCase().endsWith('.png') ==
                        true
                    ? 'image/png'
                    : 'image/jpeg'),
          originalFilename: candidate.originalFilename,
          byteSize: candidate.byteSize,
          importedAt: candidate.importedAt,
          pageOrder: index,
        ),
      );
    }
    final document = LocalDocument(
      clientDocumentId: id,
      classificationState: ClassificationState.unclassified,
      status: DocumentStatus.imported,
      createdAt: now,
      updatedAt: now,
    );
    final repository = ref.read(documentRepositoryProvider);
    await repository.saveImportedDocument(document, files.first);
    for (final file in files.skip(1)) {
      await repository.saveImportedDocument(document, file);
    }
    try {
      final arabic = ref.read(languageProvider)?.languageCode == 'ar';
      final accepted = await ref
          .read(analysisWorkflowProvider)
          .submit(
            AnalysisSubmission(
              clientDocumentId: id,
              files: files,
              language: arabic
                  ? ExplanationLanguage.arabic
                  : ExplanationLanguage.german,
              style: arabic
                  ? ExplanationStyle.standard
                  : ExplanationStyle.simple,
              idempotencyKey: ref.read(idGeneratorProvider).newId(),
            ),
          );
      if (mounted) setState(() => _message = context.l10n.analysisStarted);
      await ref.read(analysisWorkflowProvider).poll(accepted.operationId, id);
      if (mounted) {
        setState(() => _busy = false);
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AnalysisResultPage(clientDocumentId: id),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _busy = false;
          _message = error is AppError
              ? error.message
              : context.l10n.analysisFailed;
        });
      }
    }
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
