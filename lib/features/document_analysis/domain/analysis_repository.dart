import '../../documents/domain/entities/domain_entities.dart';
import 'analysis_submission.dart';

abstract interface class AnalysisRepository {
  Future<DocumentAnalysis?> getLatest(String clientDocumentId);
  Stream<DocumentAnalysis?> watchLatest(String clientDocumentId);
  Future<void> saveOperation({
    required String operationId,
    required String clientDocumentId,
    required AnalysisLifecycleState state,
    String? failureCode,
  });
  Future<void> saveCompleted(DocumentAnalysis analysis);

  /// Removes correlations which claim active work for a Document that has
  /// already reached a local terminal lifecycle state.
  Future<void> clearStalePendingOperations();
  Stream<List<PendingAnalysisOperation>> watchPending();
}

class PendingAnalysisOperation {
  const PendingAnalysisOperation({
    required this.operationId,
    required this.clientDocumentId,
    required this.state,
  });
  final String operationId;
  final String clientDocumentId;
  final AnalysisLifecycleState state;
}
