enum ClassificationState { unclassified, suggested, confirmed }

enum AnalysisStatus { complete, partial, unavailable }

enum DocumentQualityReason {
  blurryImage,
  pageCutOff,
  unreadableText,
  missingPages,
  unsupportedFile,
  corruptFile,
  insufficientContent,
}

enum ExplanationLanguage { arabic, german }

enum ExplanationStyle { standard, simple }

enum DocumentFileSource { camera, imageLibrary, filePicker }

enum DocumentStatus {
  imported,
  processing,
  analyzed,
  needsReview,
  archived,
  deleted,
}

enum OrganizationCategory {
  immigrationAuthority,
  jobcenter,
  familyBenefitsOffice,
  healthInsurer,
  taxOffice,
  employer,
  housing,
  other,
}

enum TaskStatus { open, completed, dismissed }

enum TaskProvenance { user, analysis, system }

enum AmountDirection { pay, receive, unknown }

class Organization {
  const Organization({
    required this.id,
    required this.name,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id;
  final String name;
  final OrganizationCategory category;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class Case {
  const Case({
    required this.id,
    required this.organizationId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id;
  final String organizationId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class LocalDocument {
  const LocalDocument({
    required this.clientDocumentId,
    required this.classificationState,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.organizationId,
    this.caseId,
    this.documentDate,
    this.sourceLanguage,
  });
  final String clientDocumentId;
  final String? organizationId;
  final String? caseId;
  final ClassificationState classificationState;
  final DocumentStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? documentDate;
  final String? sourceLanguage;
  bool get isUnclassified =>
      classificationState == ClassificationState.unclassified;
}

class DocumentFile {
  const DocumentFile({
    required this.id,
    required this.clientDocumentId,
    required this.localUri,
    required this.mediaType,
    required this.importedAt,
    this.originalFilename,
    this.byteSize,
    this.pageOrder = 0,
    this.importSource = DocumentFileSource.filePicker,
  });
  final String id;
  final String clientDocumentId;
  final Uri localUri;
  final String mediaType;
  final String? originalFilename;
  final int? byteSize;
  final DateTime importedAt;
  final int pageOrder;
  final DocumentFileSource importSource;
}

class SourceReference {
  const SourceReference({
    required this.referenceId,
    this.pageNumber,
    this.fileId,
    this.excerptLabel,
  });
  final String referenceId;
  final int? pageNumber;
  final String? fileId;
  final String? excerptLabel;
}

class DocumentAnalysis {
  const DocumentAnalysis({
    required this.id,
    required this.clientDocumentId,
    required this.schemaVersion,
    required this.targetLanguage,
    required this.createdAt,
    this.summary,
    this.explanation,
    this.analysisStatus = AnalysisStatus.complete,
    this.explanationStyle = ExplanationStyle.standard,
    this.qualityReasons = const [],
    this.sourceReferences = const [],
  });
  final String id;
  final String clientDocumentId;
  final String schemaVersion;
  final String targetLanguage;
  final String? summary;
  final String? explanation;
  final DateTime createdAt;
  final AnalysisStatus analysisStatus;
  final ExplanationStyle explanationStyle;
  final List<DocumentQualityReason> qualityReasons;
  final List<SourceReference> sourceReferences;
}

class Deadline {
  const Deadline({
    required this.id,
    required this.clientDocumentId,
    required this.label,
    required this.dueAt,
  });
  final String id;
  final String clientDocumentId;
  final String label;
  final DateTime dueAt;
}

class Appointment {
  const Appointment({
    required this.id,
    required this.clientDocumentId,
    required this.label,
    required this.startsAt,
  });
  final String id;
  final String clientDocumentId;
  final String label;
  final DateTime startsAt;
}

class Amount {
  const Amount({
    required this.id,
    required this.clientDocumentId,
    required this.valueInCents,
    required this.currency,
    required this.direction,
  });
  final String id;
  final String clientDocumentId;
  final int valueInCents;
  final String currency;
  final AmountDirection direction;
}

class RequiredDocument {
  const RequiredDocument({
    required this.id,
    required this.clientDocumentId,
    required this.description,
  });
  final String id;
  final String clientDocumentId;
  final String description;
}

class LocalTask {
  const LocalTask({
    required this.id,
    required this.title,
    required this.status,
    required this.provenance,
    required this.createdAt,
    required this.updatedAt,
    this.dueAt,
    this.clientDocumentId,
    this.caseId,
  });
  final String id;
  final String title;
  final TaskStatus status;
  final TaskProvenance provenance;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dueAt;
  final String? clientDocumentId;
  final String? caseId;
}
