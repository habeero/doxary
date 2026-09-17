import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);
  final Locale locale;
  static const supportedLocales = [Locale('de'), Locale('ar')];
  static const delegate = _AppLocalizationsDelegate();
  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  String get appTitle => _value('appTitle');
  String get home => _value('home');
  String get documents => _value('documents');
  String get importDocument => _value('importDocument');
  String get tasks => _value('tasks');
  String get profile => _value('profile');
  String get scanImport => _value('scanImport');
  String get upcoming => _value('upcoming');
  String get recentDocuments => _value('recentDocuments');
  String get noUpcomingTasks => _value('noUpcomingTasks');
  String get noDocuments => _value('noDocuments');
  String get today => _value('today');
  String get completed => _value('completed');
  String get noTasks => _value('noTasks');
  String get camera => _value('camera');
  String get image => _value('image');
  String get pdf => _value('pdf');
  String get importUnavailable => _value('importUnavailable');
  String get language => _value('language');
  String get german => _value('german');
  String get arabic => _value('arabic');
  String get foundationMessage => _value('foundationMessage');
  String get emptyDocumentsDescription => _value('emptyDocumentsDescription');
  String get selectedDocument => _value('selectedDocument');
  String get startAnalysis => _value('startAnalysis');
  String get analysisUploading => _value('analysisUploading');
  String get analysisStarted => _value('analysisStarted');
  String get analysisComplete => _value('analysisComplete');
  String get analysisFailed => _value('analysisFailed');
  String get images => _value('images');
  String get cameraDeferred => _value('cameraDeferred');
  String get operationRetryableError => _value('operationRetryableError');
  String get operationFailedError => _value('operationFailedError');
  String get importError => _value('importError');
  String get analysisLanguageLabel => _value('analysisLanguageLabel');
  String get analysisLanguageArabic => _value('analysisLanguageArabic');
  String get analysisLanguageSimpleGerman =>
      _value('analysisLanguageSimpleGerman');
  String get analysisTitle => _value('analysisTitle');
  String get analysisReadError => _value('analysisReadError');
  String get noSavedAnalysis => _value('noSavedAnalysis');
  String get suggestion => _value('suggestion');
  String get explanation => _value('explanation');
  String get outputStyle => _value('outputStyle');
  String get whatToDo => _value('whatToDo');
  String get actionRequired => _value('actionRequired');
  String get urgency => _value('urgency');
  String get deadlines => _value('deadlines');
  String get appointments => _value('appointments');
  String get amounts => _value('amounts');
  String get requiredDocuments => _value('requiredDocuments');
  String get nextActions => _value('nextActions');
  String get documentQuality => _value('documentQuality');
  String get pleaseVerify => _value('pleaseVerify');
  String get evidence => _value('evidence');
  String get sourceReferences => _value('sourceReferences');
  String get standard => _value('standard');
  String get simple => _value('simple');
  String get complete => _value('complete');
  String get partial => _value('partial');
  String get analysisUnavailable => _value('analysisUnavailable');
  String get yes => _value('yes');
  String get no => _value('no');
  String get uncertain => _value('uncertain');
  String get low => _value('low');
  String get normal => _value('normal');
  String get high => _value('high');
  String get critical => _value('critical');
  String get qualityBlurry => _value('qualityBlurry');
  String get qualityCutOff => _value('qualityCutOff');
  String get qualityUnreadable => _value('qualityUnreadable');
  String get qualityMissing => _value('qualityMissing');
  String get qualityUnsupported => _value('qualityUnsupported');
  String get qualityCorrupt => _value('qualityCorrupt');
  String get qualityInsufficient => _value('qualityInsufficient');
  String _value(String key) =>
      (_strings[locale.languageCode] ?? _strings['de']!)[key] ??
      (_extraStrings[locale.languageCode] ?? _extraStrings['de']!)[key] ??
      (_analysisLanguageStrings[locale.languageCode] ??
          _analysisLanguageStrings['de']!)[key] ??
      key;
}

const _analysisLanguageStrings = <String, Map<String, String>>{
  'de': {
    'analysisLanguageLabel': 'Sprache der Erkl\u00e4rung',
    'analysisLanguageArabic': 'Arabisch',
    'analysisLanguageSimpleGerman': 'Einfaches Deutsch',
  },
  'ar': {
    'analysisLanguageLabel':
        '\u0644\u063a\u0629 \u0627\u0644\u0634\u0631\u062d',
    'analysisLanguageArabic': '\u0627\u0644\u0639\u0631\u0628\u064a\u0629',
    'analysisLanguageSimpleGerman': '\u0627\u0644\u0623\u0644\u0645\u0627\u0646\u064a\u0629 \u0627\u0644\u0628\u0633\u064a\u0637\u0629',
  },
};

const _extraStrings = <String, Map<String, String>>{
  'de': {
    'analysisTitle': 'Analyse',
    'analysisReadError': 'Gespeicherte Analyse konnte nicht gelesen werden.',
    'noSavedAnalysis': 'Noch keine Analyse gespeichert.',
    'suggestion': 'Vorschlag',
    'explanation': 'Erklärung',
    'outputStyle': 'Ausgabestil',
    'whatToDo': 'Was ist zu tun?',
    'actionRequired': 'Aktion erforderlich',
    'urgency': 'Dringlichkeit',
    'deadlines': 'Fristen',
    'appointments': 'Termine',
    'amounts': 'Beträge',
    'requiredDocuments': 'Benötigte Dokumente',
    'nextActions': 'Nächste Schritte',
    'documentQuality': 'Dokumentenqualität',
    'pleaseVerify': 'Bitte prüfen',
    'evidence': 'Nachweise',
    'sourceReferences': 'Quellenangaben',
    'standard': 'Standard',
    'simple': 'Einfach',
    'complete': 'Vollständig',
    'partial': 'Teilweise – bitte prüfen.',
    'analysisUnavailable': 'Analyse nicht verfügbar.',
    'yes': 'Ja',
    'no': 'Nein',
    'uncertain': 'Unsicher',
    'low': 'Niedrig',
    'normal': 'Normal',
    'high': 'Hoch',
    'critical': 'Kritisch',
    'qualityBlurry': 'Das Bild ist möglicherweise unscharf.',
    'qualityCutOff': 'Eine Seite ist möglicherweise abgeschnitten.',
    'qualityUnreadable': 'Ein Teil des Textes ist nicht lesbar.',
    'qualityMissing': 'Möglicherweise fehlen Seiten.',
    'qualityUnsupported': 'Das Dateiformat wird nicht unterstützt.',
    'qualityCorrupt': 'Die Datei ist möglicherweise beschädigt.',
    'qualityInsufficient':
        'Möglicherweise sind nicht genügend Inhalte vorhanden.',
  },
  'ar': {
    'analysisTitle': '\u0627\u0644\u062a\u062d\u0644\u064a\u0644',
    'analysisReadError': '\u062a\u0639\u0630\u0631 \u0642\u0631\u0627\u0621\u0629 \u0627\u0644\u062a\u062d\u0644\u064a\u0644 \u0627\u0644\u0645\u062d\u0641\u0648\u0638.',
    'noSavedAnalysis': '\u0644\u0627 \u064a\u0648\u062c\u062f \u062a\u062d\u0644\u064a\u0644 \u0645\u062d\u0641\u0648\u0638 \u0628\u0639\u062f.',
    'suggestion': '\u0627\u0642\u062a\u0631\u0627\u062d',
    'explanation': '\u0627\u0644\u0634\u0631\u062d',
    'outputStyle': '\u0623\u0633\u0644\u0648\u0628 \u0627\u0644\u0625\u062e\u0631\u0627\u062c',
    'whatToDo': '\u0645\u0627 \u0627\u0644\u0630\u064a \u064a\u062c\u0628 \u0641\u0639\u0644\u0647؟',
    'actionRequired': '\u0627\u0644\u0625\u062c\u0631\u0627\u0621 \u0645\u0637\u0644\u0648\u0628',
    'urgency': '\u0627\u0644\u0623\u0648\u0644\u0648\u064a\u0629',
    'deadlines': '\u0627\u0644\u0645\u0648\u0627\u0639\u064a\u062f \u0627\u0644\u0646\u0647\u0627\u0626\u064a\u0629',
    'appointments': '\u0627\u0644\u0645\u0648\u0627\u0639\u064a\u062f',
    'amounts': '\u0627\u0644\u0645\u0628\u0627\u0644\u063a',
    'requiredDocuments': '\u0627\u0644\u0645\u0633\u062a\u0646\u062f\u0627\u062a \u0627\u0644\u0645\u0637\u0644\u0648\u0628\u0629',
    'nextActions': '\u0627\u0644\u062e\u0637\u0648\u0627\u062a \u0627\u0644\u062a\u0627\u0644\u064a\u0629',
    'documentQuality':
        '\u062c\u0648\u062f\u0629 \u0627\u0644\u0645\u0633\u062a\u0646\u062f',
    'pleaseVerify':
        '\u064a\u0631\u062c\u0649 \u0627\u0644\u062a\u062d\u0642\u0642',
    'evidence': '\u0627\u0644\u0623\u062f\u0644\u0629',
    'sourceReferences': '\u0627\u0644\u0645\u0631\u0627\u062c\u0639',
    'standard': '\u0642\u064a\u0627\u0633\u064a',
    'simple': '\u0628\u0633\u064a\u0637',
    'complete': '\u0645\u0643\u062a\u0645\u0644',
    'partial': '\u062c\u0632\u0626\u064a – \u064a\u0631\u062c\u0649 \u0627\u0644\u062a\u062d\u0642\u0642.',
    'analysisUnavailable': '\u0627\u0644\u062a\u062d\u0644\u064a\u0644 \u063a\u064a\u0631 \u0645\u062a\u0627\u062d.',
    'yes': '\u0646\u0639\u0645',
    'no': '\u0644\u0627',
    'uncertain': '\u063a\u064a\u0631 \u0645\u0624\u0643\u062f',
    'low': '\u0645\u0646\u062e\u0641\u0636',
    'normal': '\u0639\u0627\u062f\u064a',
    'high': '\u0645\u0631\u062a\u0641\u0639',
    'critical': '\u062d\u0631\u062c',
    'qualityBlurry': '\u0642\u062f \u062a\u0643\u0648\u0646 \u0627\u0644\u0635\u0648\u0631\u0629 \u063a\u064a\u0631 \u0648\u0627\u0636\u062d\u0629.',
    'qualityCutOff': '\u0642\u062f \u062a\u0643\u0648\u0646 \u0627\u0644\u0635\u0641\u062d\u0629 \u0645\u0642\u0635\u0648\u0635\u0629.',
    'qualityUnreadable': '\u0628\u0639\u0636 \u0627\u0644\u0646\u0635 \u063a\u064a\u0631 \u0645\u0642\u0631\u0648\u0621.',
    'qualityMissing': '\u0642\u062f \u062a\u0643\u0648\u0646 \u0647\u0646\u0627\u0643 \u0635\u0641\u062d\u0627\u062a \u0645\u0641\u0642\u0648\u062f\u0629.',
    'qualityUnsupported': '\u0635\u064a\u063a\u0629 \u0627\u0644\u0645\u0644\u0641 \u063a\u064a\u0631 \u0645\u062f\u0639\u0648\u0645\u0629.',
    'qualityCorrupt': '\u0642\u062f \u064a\u0643\u0648\u0646 \u0627\u0644\u0645\u0644\u0641 \u062a\u0627\u0644\u0641\u0627.',
    'qualityInsufficient': '\u0642\u062f \u0644\u0627 \u064a\u0643\u0648\u0646 \u0627\u0644\u0645\u062d\u062a\u0648\u0649 \u0643\u0627\u0641\u064a\u0627ً.',
  },
};

const _strings = <String, Map<String, String>>{
  'de': {
    'appTitle': 'Dokumente',
    'home': 'Start',
    'documents': 'Dokumente',
    'importDocument': 'Neu',
    'tasks': 'Aufgaben',
    'profile': 'Profil',
    'scanImport': 'Dokument importieren',
    'upcoming': 'Anstehende Aufgaben',
    'recentDocuments': 'Letzte Dokumente',
    'noUpcomingTasks': 'Keine anstehenden Aufgaben',
    'noDocuments': 'Noch keine Dokumente',
    'today': 'Heute',
    'completed': 'Erledigt',
    'noTasks': 'Noch keine Aufgaben',
    'camera': 'Kamera',
    'image': 'Bild',
    'pdf': 'PDF',
    'importUnavailable':
        'Der Dokumentimport ist auf diesem Gerät noch nicht eingerichtet.',
    'language': 'Sprache',
    'german': 'Deutsch',
    'arabic': 'Arabisch',
    'foundationMessage':
        'Die Grundlage für den lokalen Dokumentimport ist bereit.',
    'emptyDocumentsDescription':
        'Importiere ein Dokument, um hier den Überblick zu behalten.',
    'selectedDocument': 'Ausgewähltes Dokument',
    'startAnalysis': 'Analyse starten',
    'analysisUploading': 'Dokument wird hochgeladen …',
    'analysisStarted': 'Analyse gestartet',
    'analysisComplete': 'Analyse abgeschlossen',
    'analysisFailed': 'Analyse konnte nicht abgeschlossen werden.',
    'images': 'Bilder',
    'cameraDeferred': 'Kamera wird später unterstützt.',
    'operationRetryableError': 'Der Dienst ist vorübergehend nicht verfügbar.',
    'operationFailedError': 'Die Analyse konnte nicht abgeschlossen werden.',
    'importError': 'Der Dokumentimport ist fehlgeschlagen.',
  },
  'ar': {
    'appTitle': 'المستندات',
    'home': 'الرئيسية',
    'documents': 'المستندات',
    'importDocument': 'إضافة',
    'tasks': 'المهام',
    'profile': 'الملف الشخصي',
    'scanImport': 'استيراد مستند',
    'upcoming': 'المهام القادمة',
    'recentDocuments': 'أحدث المستندات',
    'noUpcomingTasks': 'لا توجد مهام قادمة',
    'noDocuments': 'لا توجد مستندات بعد',
    'today': 'اليوم',
    'completed': 'مكتملة',
    'noTasks': 'لا توجد مهام بعد',
    'camera': 'الكاميرا',
    'image': 'صورة',
    'pdf': 'PDF',
    'importUnavailable': 'لم يتم إعداد استيراد المستندات على هذا الجهاز بعد.',
    'language': 'اللغة',
    'german': 'الألمانية',
    'arabic': 'العربية',
    'foundationMessage': 'أساس الاستيراد المحلي للمستندات جاهز.',
    'emptyDocumentsDescription': 'استورد مستندًا للاحتفاظ بنظرة عامة هنا.',
    'selectedDocument': 'المستند المحدد',
    'startAnalysis': 'بدء التحليل',
    'analysisUploading': 'جارٍ رفع المستند …',
    'analysisStarted': 'بدأ التحليل',
    'analysisComplete': 'اكتمل التحليل',
    'analysisFailed': 'تعذر إكمال التحليل.',
    'images': 'الصور',
    'cameraDeferred': 'سيتم دعم الكاميرا لاحقًا.',
    'operationRetryableError': 'الخدمة غير متاحة مؤقتًا.',
    'operationFailedError': 'تعذر إكمال التحليل.',
    'importError': 'تعذر استيراد المستند.',
  },
};

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.contains(Locale(locale.languageCode));
  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension LocalizationContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
