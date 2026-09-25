import '../../documents/domain/entities/domain_entities.dart';

enum DocumentAttentionReason { failed, deleted }

class DocumentAttention {
  const DocumentAttention({required this.reason, required this.occurredAt});

  final DocumentAttentionReason reason;
  final DateTime occurredAt;
}

class DocumentAnalysisBrowseState {
  const DocumentAnalysisBrowseState({
    required this.hasUsableAnalysis,
    required this.isProcessing,
    this.attention,
  });

  final bool hasUsableAnalysis;
  final bool isProcessing;
  final DocumentAttention? attention;
}

bool isUsableAnalysisStatus(AnalysisStatus status) =>
    status == AnalysisStatus.complete || status == AnalysisStatus.partial;

DocumentAnalysisBrowseState resolveDocumentAnalysisBrowseState({
  required Iterable<AnalysisStatus> currentAnalysisStatuses,
  required bool isProcessing,
  required DateTime? latestFailureAt,
  required DateTime? latestDeletionAt,
}) {
  final hasUsableAnalysis = currentAnalysisStatuses.any(isUsableAnalysisStatus);
  DocumentAttention? attention;
  if (!hasUsableAnalysis && !isProcessing) {
    if (latestDeletionAt != null &&
        (latestFailureAt == null ||
            !latestFailureAt.isAfter(latestDeletionAt))) {
      attention = DocumentAttention(
        reason: DocumentAttentionReason.deleted,
        occurredAt: latestDeletionAt,
      );
    } else if (latestFailureAt != null) {
      attention = DocumentAttention(
        reason: DocumentAttentionReason.failed,
        occurredAt: latestFailureAt,
      );
    }
  }
  return DocumentAnalysisBrowseState(
    hasUsableAnalysis: hasUsableAnalysis,
    isProcessing: isProcessing,
    attention: attention,
  );
}
