import 'dart:typed_data';

import 'entities/domain_entities.dart';

/// Typed, read-only source-material access for an existing Document.
///
/// Presentation consumes the outcome, never the persisted local URI. Platform
/// and filesystem details belong to the implementing adapter.
abstract interface class SourceDocumentOpener {
  Future<SourceDocumentOpenOutcome> open(List<DocumentFile> files);
}

sealed class SourceDocumentOpenOutcome {
  const SourceDocumentOpenOutcome();
}

/// A PDF was handed to the platform's registered read-only viewer.
final class SourceDocumentOpened extends SourceDocumentOpenOutcome {
  const SourceDocumentOpened();
}

/// Ordered image pages are available for Doxary's read-only local viewer.
final class SourceDocumentImagesOpened extends SourceDocumentOpenOutcome {
  const SourceDocumentImagesOpened(this.pages);
  final List<SourceDocumentImagePage> pages;
}

/// The persisted source reference cannot currently be read.
final class SourceDocumentUnavailable extends SourceDocumentOpenOutcome {
  const SourceDocumentUnavailable();
}

/// Doxary has source metadata, but cannot present that media type here.
final class SourceDocumentUnsupported extends SourceDocumentOpenOutcome {
  const SourceDocumentUnsupported();
}

/// A platform viewer or local read failed without exposing implementation data.
final class SourceDocumentOpenFailed extends SourceDocumentOpenOutcome {
  const SourceDocumentOpenFailed();
}

class SourceDocumentImagePage {
  const SourceDocumentImagePage({required this.pageOrder, this.bytes});

  final int pageOrder;
  final Uint8List? bytes;
  bool get isAvailable => bytes != null;
}
