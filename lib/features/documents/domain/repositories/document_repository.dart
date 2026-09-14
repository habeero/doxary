import '../entities/domain_entities.dart';

abstract interface class DocumentRepository {
  Stream<List<LocalDocument>> watchRecent({int limit = 5});
  Future<void> saveImportedDocument(LocalDocument document, DocumentFile file);
}
