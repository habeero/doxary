import 'dart:io';

import 'package:open_filex/open_filex.dart';

import '../domain/entities/domain_entities.dart';
import '../domain/source_document_opener.dart';

abstract interface class PlatformSourceFileOpener {
  Future<PlatformSourceFileOpenResult> openPdf(
    String path, {
    required String mediaType,
  });
}

enum PlatformSourceFileOpenResult { opened, unavailable, unsupported, failed }

class DevicePlatformSourceFileOpener implements PlatformSourceFileOpener {
  @override
  Future<PlatformSourceFileOpenResult> openPdf(
    String path, {
    required String mediaType,
  }) async {
    final result = await OpenFilex.open(path, type: mediaType);
    return switch (result.type.name) {
      'done' => PlatformSourceFileOpenResult.opened,
      'fileNotFound' => PlatformSourceFileOpenResult.unavailable,
      'noAppToOpen' ||
      'unsupported' => PlatformSourceFileOpenResult.unsupported,
      _ => PlatformSourceFileOpenResult.failed,
    };
  }
}

/// Resolves persisted source references without changing the Document, its
/// files, analyses, classification, or Tasks.
class LocalSourceDocumentOpener implements SourceDocumentOpener {
  LocalSourceDocumentOpener({PlatformSourceFileOpener? platformFileOpener})
    : _platformFileOpener =
          platformFileOpener ?? DevicePlatformSourceFileOpener();

  final PlatformSourceFileOpener _platformFileOpener;

  @override
  Future<SourceDocumentOpenOutcome> open(List<DocumentFile> files) async {
    final ordered = [...files]
      ..sort((left, right) => left.pageOrder.compareTo(right.pageOrder));
    if (ordered.isEmpty) return const SourceDocumentUnavailable();

    if (ordered.length == 1 && ordered.single.mediaType == 'application/pdf') {
      return _openPdf(ordered.single);
    }
    if (ordered.every((file) => file.mediaType.startsWith('image/'))) {
      return _openImages(ordered);
    }
    return const SourceDocumentUnsupported();
  }

  Future<SourceDocumentOpenOutcome> _openPdf(DocumentFile documentFile) async {
    final localFile = _fileFor(documentFile);
    if (localFile == null || !await localFile.exists()) {
      return const SourceDocumentUnavailable();
    }
    try {
      final result = await _platformFileOpener.openPdf(
        localFile.path,
        mediaType: documentFile.mediaType,
      );
      return switch (result) {
        PlatformSourceFileOpenResult.opened => const SourceDocumentOpened(),
        PlatformSourceFileOpenResult.unavailable =>
          const SourceDocumentUnavailable(),
        PlatformSourceFileOpenResult.unsupported =>
          const SourceDocumentUnsupported(),
        PlatformSourceFileOpenResult.failed => const SourceDocumentOpenFailed(),
      };
    } catch (_) {
      return const SourceDocumentOpenFailed();
    }
  }

  Future<SourceDocumentOpenOutcome> _openImages(
    List<DocumentFile> files,
  ) async {
    var hasAvailablePage = false;
    final pages = <SourceDocumentImagePage>[];
    for (final documentFile in files) {
      final localFile = _fileFor(documentFile);
      if (localFile == null || !await localFile.exists()) {
        pages.add(SourceDocumentImagePage(pageOrder: documentFile.pageOrder));
        continue;
      }
      try {
        final bytes = await localFile.readAsBytes();
        if (bytes.isEmpty) {
          pages.add(SourceDocumentImagePage(pageOrder: documentFile.pageOrder));
          continue;
        }
        hasAvailablePage = true;
        pages.add(
          SourceDocumentImagePage(
            pageOrder: documentFile.pageOrder,
            bytes: bytes,
          ),
        );
      } catch (_) {
        pages.add(SourceDocumentImagePage(pageOrder: documentFile.pageOrder));
      }
    }
    return hasAvailablePage
        ? SourceDocumentImagesOpened(pages)
        : const SourceDocumentUnavailable();
  }

  File? _fileFor(DocumentFile documentFile) =>
      documentFile.localUri.scheme == 'file'
      ? File.fromUri(documentFile.localUri)
      : null;
}
