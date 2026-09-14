import '../../../core/errors/result.dart';
import '../../documents/domain/entities/domain_entities.dart';

abstract interface class DocumentAnalysisRemoteDataSource {
  Future<Result<DocumentAnalysis>> analyze({
    required String clientDocumentId,
    required String targetLanguage,
  });
}
