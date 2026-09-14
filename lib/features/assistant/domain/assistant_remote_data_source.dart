import '../../../core/errors/result.dart';

abstract interface class AssistantRemoteDataSource {
  Future<Result<String>> answerQuestion({
    required String clientDocumentId,
    required String question,
    required String targetLanguage,
  });
  Future<Result<String>> draftReply({
    required String clientDocumentId,
    required String targetLanguage,
  });
}
