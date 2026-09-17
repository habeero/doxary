import '../../../app/localization/app_localizations.dart';
import '../domain/entities/domain_entities.dart';

String documentDisplayTitle(
  LocalDocument document,
  AppLocalizations l10n, {
  DocumentAnalysis? analysis,
  DocumentFile? file,
  String? organizationName,
}) {
  final type = analysis?.classification?.documentType?.trim();
  final date = document.documentDate;
  if (type != null && type.isNotEmpty) {
    final dated = date == null ? type : '$type (${date.year})';
    final organization = organizationName?.trim();
    return organization == null || organization.isEmpty
        ? dated
        : '$organization – $dated';
  }
  final filename = file?.originalFilename?.trim();
  if (filename != null && filename.isNotEmpty) {
    final cleaned = filename.split(RegExp(r'[\\/]')).last;
    if (_isMeaningfulFilename(cleaned)) return cleaned;
  }
  return date == null
      ? l10n.documentFallback
      : '${l10n.documentFallback} (${date.year})';
}

bool _isMeaningfulFilename(String filename) {
  final stem = filename.replaceFirst(RegExp(r'\.[^.]+$'), '').trim();
  if (stem.isEmpty ||
      RegExp(r'^[0-9a-f]{8}-', caseSensitive: false).hasMatch(stem)) {
    return false;
  }
  final normalized = stem.toLowerCase().replaceAll(RegExp(r'[_.-]+'), ' ');
  if (RegExp(r'^(pdf|document|scan|image)( \d|$)').hasMatch(normalized)) {
    return false;
  }
  // A lone opaque label (for example a sender name) is not a document title.
  return normalized.split(RegExp(r'\s+')).length > 1;
}

String documentClassificationLabel(
  AppLocalizations l10n,
  ClassificationState state,
) => switch (state) {
  ClassificationState.unclassified => l10n.unclassified,
  ClassificationState.suggested => l10n.classificationSuggested,
  ClassificationState.confirmed => l10n.classificationConfirmed,
};
