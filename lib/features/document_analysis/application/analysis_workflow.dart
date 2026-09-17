import '../../../core/errors/app_error.dart';
import '../domain/analysis_repository.dart';
import '../domain/analysis_submission.dart';
import '../../../core/logging/debug_log.dart';

/// Coordinates submission and bounded polling without putting network logic in
/// widgets. A retry polls an existing operation; it never re-uploads it.
class AnalysisWorkflow {
  AnalysisWorkflow(
    this._remote,
    this._local, {
    this.pollInterval = const Duration(seconds: 2),
    this.maxPolls = 90,
    Future<void> Function(Duration)? wait,
  }) : _wait = wait ?? Future.delayed;

  final DocumentAnalysisRemoteDataSource _remote;
  final AnalysisRepository _local;
  final Duration pollInterval;
  final int maxPolls;
  final Future<void> Function(Duration) _wait;

  Future<AcceptedAnalysisOperation> submit(
    AnalysisSubmission submission,
  ) async {
    final accepted = await _remote.submit(submission);
    analysisDebugLog(
      'local_persistence',
      'saving accepted operation ${accepted.operationId}',
    );
    await _local.saveOperation(
      operationId: accepted.operationId,
      clientDocumentId: submission.clientDocumentId,
      state: AnalysisLifecycleState.accepted,
    );
    return accepted;
  }

  Future<BackendOperation> poll(
    String operationId,
    String clientDocumentId,
  ) async {
    analysisDebugLog('polling', 'entered');
    for (var attempt = 0; attempt < maxPolls; attempt++) {
      final operation = await _remote.getOperation(operationId);
      switch (operation.status) {
        case BackendOperationStatus.accepted:
          await _local.saveOperation(
            operationId: operationId,
            clientDocumentId: clientDocumentId,
            state: AnalysisLifecycleState.accepted,
          );
          break;
        case BackendOperationStatus.processing:
          await _local.saveOperation(
            operationId: operationId,
            clientDocumentId: clientDocumentId,
            state: AnalysisLifecycleState.processing,
          );
          break;
        case BackendOperationStatus.succeeded:
          final analysis = operation.result;
          if (analysis == null) {
            throw const MalformedRemoteResponseError(
              'The completed operation had no result.',
            );
          }
          analysisDebugLog('local_persistence', 'entered');
          try {
            await _local.saveCompleted(analysis);
          } catch (error) {
            analysisDebugLog(
              'local_persistence',
              'failed type=${error.runtimeType}',
            );
            rethrow;
          }
          analysisDebugLog(
            'local_persistence',
            'saved completed analysis; cleared operation ${operation.operationId}',
          );
          return operation;
        case BackendOperationStatus.failed:
          await _local.saveOperation(
            operationId: operationId,
            clientDocumentId: clientDocumentId,
            state: AnalysisLifecycleState.failed,
            failureCode: operation.failureCode,
          );
          throw RemoteApiError(
            'The analysis operation failed.',
            statusCode: 200,
            code: operation.failureCode ?? 'processing_failed',
            retryable: operation.failureRetryable ?? false,
            isTerminalOperationFailure: true,
          );
      }
      await _wait(pollInterval);
    }
    throw const RemoteUnavailableError(
      'Analysis is still processing. Please try again shortly.',
    );
  }

  Future<void> resumePending() async {
    final pending = await _local.watchPending().first;
    for (final operation in pending) {
      try {
        await poll(operation.operationId, operation.clientDocumentId);
      } on RemoteApiError catch (error) {
        if (error.code == 'operation_expired') {
          await _local.saveOperation(
            operationId: operation.operationId,
            clientDocumentId: operation.clientDocumentId,
            state: AnalysisLifecycleState.expired,
            failureCode: error.code,
          );
        }
      } on RemoteError {
        // Keep pending state. A later resume retries polling, never submission.
      }
    }
  }
}
