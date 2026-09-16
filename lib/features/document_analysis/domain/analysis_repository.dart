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
