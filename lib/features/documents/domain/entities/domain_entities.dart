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
    this.pageIndex,
    this.location,
    this.provenance,
  });
  final String referenceId;
  final int? pageNumber;
  final String? fileId;
  final String? excerptLabel;
  final int? pageIndex;
  final String? location;
  final String? provenance;
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
    this.detectedLanguage = 'undetermined',
    this.actionRequired,
    this.urgency = AnalysisUrgency.uncertain,
    this.confidence,
    this.practicalStates = const [],
    this.uncertainties = const [],
    this.classification,
    this.deadlines = const [],
    this.appointments = const [],
    this.amounts = const [],
    this.requiredDocuments = const [],
    this.suggestedTasks = const [],
    this.nextActions = const [],
    this.documentDate,
  });
  final String id;
  final String clientDocumentId;
  final String schemaVersion;
  final String targetLanguage;
  final String? summary;
  final String? explanation;
  final String? documentDate;
  final DateTime createdAt;
  final AnalysisStatus analysisStatus;
  final ExplanationStyle explanationStyle;
  final List<DocumentQualityReason> qualityReasons;
  final List<SourceReference> sourceReferences;
  final String detectedLanguage;

  /// Null is retained only for analyses created before action state persistence.
  final ActionRequirement? actionRequired;
  final AnalysisUrgency urgency;
  final double? confidence;
  final List<PracticalState> practicalStates;
  final List<String> uncertainties;
  final ClassificationSuggestion? classification;
  final List<AnalysisDeadline> deadlines;
  final List<AnalysisAppointment> appointments;
  final List<AnalysisAmount> amounts;
  final List<AnalysisRequiredDocument> requiredDocuments;
  final List<AnalysisSuggestedTask> suggestedTasks;
  final List<String> nextActions;
}

enum ActionRequirement { yes, no, uncertain }

enum AnalysisUrgency { low, normal, high, critical, uncertain }

enum PracticalState {
  informational,
  actionRequired,
  appointment,
  payment,
  documentsRequired,
}

class ClassificationSuggestion {
  const ClassificationSuggestion({this.organizationName, this.documentType});
  final String? organizationName;
  final String? documentType;
}

class AnalysisDeadline {
  const AnalysisDeadline({
    required this.label,
    required this.dateOrRange,
    required this.confidence,
    this.time,
    this.timezone,
    this.consequence,
    this.sourceReference,
  });
  final String label;
  final String? dateOrRange;
  final double? confidence;
  final String? time;
  final String? timezone;
  final String? consequence;
  final String? sourceReference;
}

class AnalysisAppointment {
  const AnalysisAppointment({
    required this.label,
    required this.startOrDate,
    required this.confidence,
    this.end,
    this.location,
    this.preparation,
    this.sourceReference,
  });
  final String label;
  final String? startOrDate;
  final double? confidence;
  final String? end;
  final String? location;
  final String? preparation;
  final String? sourceReference;
}

class AnalysisAmount {
  const AnalysisAmount({
    required this.value,
    required this.currency,
    required this.direction,
    required this.confidence,
    this.dueDate,
    this.purpose,
    this.sourceReference,
  });
  final String value;
  final String currency;
  final AmountDirection direction;
  final double? confidence;
  final String? dueDate;
  final String? purpose;
  final String? sourceReference;
}

class AnalysisRequiredDocument {
  const AnalysisRequiredDocument({
    required this.description,
    required this.confidence,
    this.dueDate,
    this.submissionMethod,
    this.sourceReference,
  });
  final String description;
  final double? confidence;
  final String? dueDate;
  final String? submissionMethod;
  final String? sourceReference;
}

class AnalysisSuggestedTask {
  const AnalysisSuggestedTask({
    required this.title,
    required this.confidence,
    this.dueDate,
    this.instructions,
    this.sourceReference,
  });
  final String title;
  final double? confidence;
  final String? dueDate;
  final String? instructions;
  final String? sourceReference;
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
    this.allDay = false,
    this.dueTimeMinutes,
    this.reminderMinutesBefore,
    this.note,
    this.clientDocumentId,
    this.caseId,
    this.sourceAnalysisId,
    this.sourceActionKey,
  });
  final String id;
  final String title;
  final TaskStatus status;
  final TaskProvenance provenance;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dueAt;
  final bool allDay;
  final int? dueTimeMinutes;
  final int? reminderMinutesBefore;
  final String? note;
  final String? clientDocumentId;
  final String? caseId;
  /// Non-cascading provenance for an action-derived Task. It remains useful
  /// even if its source analysis is later deliberately deleted.
  final String? sourceAnalysisId;
  final String? sourceActionKey;
}
