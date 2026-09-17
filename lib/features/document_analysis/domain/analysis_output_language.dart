import '../../documents/domain/entities/domain_entities.dart';

/// The user-facing language choices for generated analysis explanations.
enum AnalysisOutputLanguage { arabic, simpleGerman }

extension AnalysisOutputLanguageMapping on AnalysisOutputLanguage {
  ExplanationLanguage get explanationLanguage => switch (this) {
    AnalysisOutputLanguage.arabic => ExplanationLanguage.arabic,
    AnalysisOutputLanguage.simpleGerman => ExplanationLanguage.german,
  };

  ExplanationStyle get explanationStyle => switch (this) {
    AnalysisOutputLanguage.arabic => ExplanationStyle.standard,
    AnalysisOutputLanguage.simpleGerman => ExplanationStyle.simple,
  };

  String get settingValue => switch (this) {
    AnalysisOutputLanguage.arabic => 'ar',
    AnalysisOutputLanguage.simpleGerman => 'de',
  };
}

AnalysisOutputLanguage? analysisOutputLanguageFromSetting(String? value) =>
    switch (value) {
      'ar' => AnalysisOutputLanguage.arabic,
      'de' => AnalysisOutputLanguage.simpleGerman,
      _ => null,
    };
