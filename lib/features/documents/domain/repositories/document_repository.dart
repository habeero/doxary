import '../entities/domain_entities.dart';

abstract interface class DocumentRepository {
  Stream<List<LocalDocument>> watchRecent({int limit = 5});
  Stream<List<LocalDocument>> watchAll();
  Future<LocalDocument?> getById(String clientDocumentId);
  Future<List<DocumentFile>> getFiles(String clientDocumentId);
  Future<void> updateClassification(
    String clientDocumentId, {
    String? organizationId,
    String? caseId,
    required ClassificationState state,
  });
  Future<void> saveImportedDocument(LocalDocument document, DocumentFile file);
}
