import '../../documents/domain/entities/domain_entities.dart';
import 'analysis_submission.dart';

abstract interface class AnalysisRepository {
  Future<DocumentAnalysis?> getLatest(String clientDocumentId);
  Stream<DocumentAnalysis?> watchLatest(String clientDocumentId);
  Future<DocumentAnalysis?> getById(String analysisId);
  Future<List<AnalysisAttempt>> getHistory(String clientDocumentId);
  Stream<List<AnalysisAttempt>> watchHistory(String clientDocumentId);
  Future<void> saveOperation({
    required String operationId,
    required String clientDocumentId,
    required AnalysisLifecycleState state,
    String? failureCode,
    bool? retryable,
  });
  Future<void> saveCompleted(DocumentAnalysis analysis);
  Future<void> deleteAnalysis(String analysisId);

  /// Removes only a non-tombstoned failed row with no surviving Analysis.
  /// Returns false when the row is missing or otherwise ineligible.
  Future<bool> deleteAnalysisAttempt(String attemptId);

  /// Removes correlations which claim active work for a Document that has
  /// already reached a local terminal lifecycle state.
  Future<void> clearStalePendingOperations();
  Stream<List<PendingAnalysisOperation>> watchPending();
}

enum AnalysisAttemptStatus { pending, succeeded, failed }

/// Minimal durable, user-safe record of one local analysis attempt.
class AnalysisAttempt {
  const AnalysisAttempt({
    required this.id,
    required this.clientDocumentId,
    required this.startedAt,
    required this.status,
    this.terminalAt,
    this.deletedAt,
    this.analysisId,
    this.resultAnalysisStatus,
    this.failureCode,
    this.retryable,
  });

  final String id;
  final String clientDocumentId;
  final DateTime startedAt;
  final DateTime? terminalAt;
  final DateTime? deletedAt;
  final AnalysisAttemptStatus status;
  final String? analysisId;
  final AnalysisStatus? resultAnalysisStatus;
  final String? failureCode;
  final bool? retryable;
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
