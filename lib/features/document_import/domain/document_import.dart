import '../../../core/errors/app_error.dart';
import '../../../core/errors/result.dart';

enum ImportSource { camera, imageLibrary, pdfFile }

enum ImportedMediaType { image, pdf }

class DocumentImportCandidate {
  const DocumentImportCandidate({
    required this.localUri,
    required this.mediaType,
    required this.source,
    required this.importedAt,
    this.originalFilename,
    this.byteSize,
  });
  final Uri localUri;
  final ImportedMediaType mediaType;
  final ImportSource source;
  final String? originalFilename;
  final int? byteSize;
  final DateTime importedAt;
}

abstract interface class DocumentImportGateway {
  Future<Result<DocumentImportCandidate>> pick(ImportSource source);
}

class UnavailableDocumentImportGateway implements DocumentImportGateway {
  @override
  Future<Result<DocumentImportCandidate>> pick(ImportSource source) async =>
      const Failure(
        CapabilityUnavailableError(
          'Document import is not configured on this device.',
        ),
      );
}
