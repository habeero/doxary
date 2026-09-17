import '../../../core/logging/debug_log.dart';
import '../../documents/domain/entities/domain_entities.dart';

/// Maps the versioned backend boundary into Flutter-only domain values.
/// No JSON map leaves this data-layer boundary.
DocumentAnalysis mapAnalysisResult(
  Map<String, dynamic> json, {
  required String id,
  required DateTime createdAt,
}) {
  String requiredString(String key) {
    final value = json[key];
    if (value is! String || value.isEmpty) {
      throw const FormatException('Missing required analysis field.');
    }
    return value;
  }

  final facts = _mapOrNull(json['extracted_facts']);
  final explanation = _mapOrNull(json['explanation']);
  final qualityIssues = _list(json['quality_issues'])
      .map(_map)
      .toList(growable: false)
      .asMap()
      .entries
      .map(
        (entry) => _qualityReason(
          entry.value['reason'],
          'quality_issues[${entry.key}].reason',
        ),
      )
      .toList(growable: false);
  return DocumentAnalysis(
    id: id,
    clientDocumentId: requiredString('client_document_id'),
    schemaVersion: requiredString('schema_version'),
    targetLanguage: explanation['language'] as String? ?? 'undetermined',
    createdAt: createdAt,
    summary: explanation['summary'] as String?,
    explanation: explanation['body'] as String?,
    documentDate:
        (_mapOrNull(facts['document_date']))['value'] as String? ??
        (_mapOrNull(facts['document_date']))['source_text'] as String?,
    analysisStatus: _enumByName(
      AnalysisStatus.values,
      requiredString('analysis_status'),
      'analysis_status',
    ),
    explanationStyle: _enumByName(
      ExplanationStyle.values,
      explanation['style'] as String? ?? 'standard',
      'explanation.style',
    ),
    qualityReasons: qualityIssues,
    sourceReferences: _list(json['source_references'])
        .map(_sourceReference)
        .toList(growable: false),
    detectedLanguage: json['detected_language'] as String? ?? 'undetermined',
    actionRequired: _enumByName(
      ActionRequirement.values,
      json['action_required'] as String? ?? 'uncertain',
      'action_required',
    ),
    urgency: _enumByName(
      AnalysisUrgency.values,
      json['urgency'] as String? ?? 'uncertain',
      'urgency',
    ),
    practicalStates: _list(json['practical_states'])
        .whereType<String>()
        .toList(growable: false)
        .asMap()
        .entries
        .map(
          (entry) => _enumByName(
            PracticalState.values,
            _camel(entry.value),
            'practical_states[${entry.key}]',
          ),
        )
        .toList(growable: false),
    uncertainties: _list(json['uncertainties'])
        .map(_map)
        .map((value) => value['message'] as String)
        .toList(growable: false),
    classification: _classification(_mapOrNull(json['classification'])),
    deadlines: _list(facts['deadlines'])
        .map(_map)
        .map(_deadline)
        .toList(growable: false),
    appointments: _list(facts['appointments'])
        .map(_map)
        .map(_appointment)
        .toList(growable: false),
    amounts: _list(facts['amounts'])
        .map(_map)
        .toList(growable: false)
        .asMap()
        .entries
        .map((entry) => _amount(entry.value, 'amounts[${entry.key}]'))
        .toList(growable: false),
    requiredDocuments: _list(facts['required_documents'])
        .map(_map)
        .map(_requiredDocument)
        .toList(growable: false),
    suggestedTasks: _list(facts['suggested_tasks'])
        .map(_map)
        .map(_task)
        .toList(growable: false),
    nextActions: _list(explanation['next_actions'])
        .whereType<String>()
        .toList(growable: false),
  );
}

Map<String, dynamic> _map(Object? value) => value is Map<String, dynamic>
    ? value
    : throw const FormatException('Invalid backend object.');
Map<String, dynamic> _mapOrNull(Object? value) =>
    value == null ? const {} : _map(value);
List<Object?> _list(Object? value) => value is List ? value : const [];

SourceReference _sourceReference(Object? value) {
  final json = _map(value);
  return SourceReference(
    referenceId: json['reference_id'] as String,
    pageNumber: json['page_number'] as int?,
    fileId: json['file_id'] as String?,
    excerptLabel: json['excerpt'] as String?,
    pageIndex: json['page_index'] as int?,
    location: json['location'] as String?,
    provenance: json['provenance'] as String?,
  );
}

ClassificationSuggestion? _classification(Map<String, dynamic> json) =>
    json.isEmpty
    ? null
    : ClassificationSuggestion(
        organizationName: json['sender_organization'] as String?,
        documentType: json['document_type'] as String?,
      );

AnalysisDeadline _deadline(Map<String, dynamic> json) => AnalysisDeadline(
  label: json['description'] as String,
  dateOrRange: json['value'] as String? ?? json['source_text'] as String?,
  confidence: (json['confidence'] as num?)?.toDouble(),
  consequence: json['consequence'] as String?,
  sourceReference: _referenceId(json),
);
AnalysisAppointment _appointment(Map<String, dynamic> json) =>
    AnalysisAppointment(
      label: json['purpose'] as String,
      startOrDate: json['appointment_date'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      location: json['location'] as String?,
      sourceReference: _referenceId(json),
    );
AnalysisAmount _amount(Map<String, dynamic> json, String path) =>
    AnalysisAmount(
      value: json['value'].toString(),
      currency: json['currency'] as String,
      direction: _enumByName(
        AmountDirection.values,
        json['direction'] as String? ?? 'unknown',
        '$path.direction',
      ),
      confidence: (json['confidence'] as num?)?.toDouble(),
      dueDate: json['due_date'] as String?,
      purpose: json['purpose'] as String?,
      sourceReference: _referenceId(json),
    );
AnalysisRequiredDocument _requiredDocument(Map<String, dynamic> json) =>
    AnalysisRequiredDocument(
      description: json['description'] as String,
      confidence: (json['confidence'] as num?)?.toDouble(),
      dueDate: json['due_date'] as String?,
      sourceReference: _referenceId(json),
    );
AnalysisSuggestedTask _task(Map<String, dynamic> json) => AnalysisSuggestedTask(
  title: json['title'] as String,
  confidence: (json['confidence'] as num?)?.toDouble(),
  dueDate: json['due_date'] as String?,
  instructions: json['instructions'] as String?,
  sourceReference: _referenceId(json),
);
String? _referenceId(Map<String, dynamic> json) {
  final values = _list(json['evidence_reference_ids']);
  return values.isEmpty ? null : values.first as String?;
}

DocumentQualityReason _qualityReason(Object? value, String path) =>
    _enumByName(DocumentQualityReason.values, _camel(value as String), path);

T _enumByName<T extends Enum>(List<T> values, String value, String path) {
  try {
    return values.byName(value);
  } on ArgumentError {
    analysisDebugLog(
      'domain_mapping',
      'failed path=$path type=ArgumentError token_category=${_enumTokenCategory(value, values)}',
    );
    rethrow;
  }
}

String _enumTokenCategory<T extends Enum>(String value, List<T> values) {
  final names = values.map((item) => item.name).toSet();
  if (names.contains(value)) return 'lowercase_valid';
  if (value != value.toLowerCase() && names.contains(value.toLowerCase())) {
    return 'uppercase_variant';
  }
  if (value != value.trim() && names.contains(value.trim())) {
    return 'whitespace_variant';
  }
  return 'unknown_enum_token';
}

String _camel(String value) => value.replaceAllMapped(
  RegExp(r'_([a-z])'),
  (match) => match[1]!.toUpperCase(),
);
