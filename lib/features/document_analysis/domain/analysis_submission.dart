import '../../documents/domain/entities/domain_entities.dart';

enum BackendOperationStatus { accepted, processing, succeeded, failed }

enum AnalysisLifecycleState {
  uploading,
  accepted,
  processing,
  succeeded,
  failed,
  expired,
}

class AnalysisSubmission {
  const AnalysisSubmission({
    required this.clientDocumentId,
    required this.files,
    required this.language,
    required this.style,
    required this.idempotencyKey,
  });

  final String clientDocumentId;
  final List<DocumentFile> files;
  final ExplanationLanguage language;
  final ExplanationStyle style;
  final String idempotencyKey;

  AnalysisSubmission copyWith({
    ExplanationLanguage? language,
    ExplanationStyle? style,
    String? idempotencyKey,
  }) => AnalysisSubmission(
    clientDocumentId: clientDocumentId,
    files: files,
    language: language ?? this.language,
    style: style ?? this.style,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
  );

  bool get isPdf =>
      files.length == 1 && files.single.mediaType == 'application/pdf';
}

class AcceptedAnalysisOperation {
  const AcceptedAnalysisOperation({
    required this.operationId,
    required this.requestId,
  });
  final String operationId;
  final String requestId;
}

class BackendOperation {
  const BackendOperation({
    required this.operationId,
    required this.status,
    required this.requestId,
    this.result,
    this.failureCode,
    this.failureRetryable,
  });
  final String operationId;
  final BackendOperationStatus status;
  final String? requestId;
  final DocumentAnalysis? result;
  final String? failureCode;
  final bool? failureRetryable;
}

abstract interface class DocumentAnalysisRemoteDataSource {
  Future<AcceptedAnalysisOperation> submit(AnalysisSubmission submission);
  Future<BackendOperation> getOperation(String operationId);
}
