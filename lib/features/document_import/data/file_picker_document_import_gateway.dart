import 'dart:io';

import 'package:file_picker/file_picker.dart';

import '../../../core/errors/app_error.dart';
import '../../../core/errors/result.dart';
import '../domain/document_import.dart';

/// Platform-backed file import. File Picker returns app-usable local paths on
/// Android and iOS; no bytes are copied and no broad storage permission is
/// requested. Camera capture remains a separate deferred capability.
class FilePickerDocumentImportGateway implements DocumentImportGateway {
  FilePickerDocumentImportGateway({DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;
  final DateTime Function() _clock;

  @override
  Future<Result<DocumentImportCandidate>> pick(ImportSource source) async {
    final selection = await pickSelection(source);
    return selection.when(
      success: (value) => Success(value.files.first),
      failure: (error) => Failure(error),
    );
  }

  @override
  Future<Result<DocumentImportSelection>> pickSelection(
    ImportSource source,
  ) async {
    if (source == ImportSource.camera) {
      return const Failure(
        CapabilityUnavailableError('Camera capture is not implemented yet.'),
      );
    }
    try {
      final isPdf = source == ImportSource.pdfFile;
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: isPdf ? ['pdf'] : ['jpg', 'jpeg', 'png'],
        allowMultiple: !isPdf,
        withData: false,
      );
      if (picked == null) return const Failure(ImportCancelledError());
      if (picked.files.isEmpty || (isPdf && picked.files.length != 1)) {
        return const Failure(
          ImportPickerError('No supported document was selected.'),
        );
      }
      final candidates = <DocumentImportCandidate>[];
      for (final file in picked.files) {
        final path = file.path;
        if (path == null || path.isEmpty) {
          return const Failure(
            ImportPickerError('The selected file is not available locally.'),
          );
        }
        final local = File(path);
        if (!await local.exists() || await local.length() == 0) {
          return const Failure(
            ImportPickerError('The selected file cannot be read.'),
          );
        }
        final extension = (file.extension ?? '').toLowerCase();
        final mediaType = isPdf || extension == 'pdf'
            ? ImportedMediaType.pdf
            : ImportedMediaType.image;
        if ((isPdf && extension != 'pdf') ||
            (!isPdf && !{'jpg', 'jpeg', 'png'}.contains(extension))) {
          return const Failure(
            UnsupportedFileError('This file format is not supported.'),
          );
        }
        candidates.add(
          DocumentImportCandidate(
            localUri: local.uri,
            mediaType: mediaType,
            source: source,
            importedAt: _clock(),
            originalFilename: file.name,
            byteSize: await local.length(),
          ),
        );
      }
      return Success(DocumentImportSelection(candidates));
    } on ImportCancelledError {
      return const Failure(ImportCancelledError());
    } catch (error) {
      return Failure(
        ImportPickerError(
          'The document picker could not be opened.',
          cause: error,
        ),
      );
    }
  }
}
