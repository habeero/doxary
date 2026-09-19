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
  String get bottomNavigationHome => _bottomNavigationValue('home');
  String get greeting => locale.languageCode == 'ar' ? 'مرحبًا' : 'Hallo';
  String get documents => _value('documents');
  String get bottomNavigationDocuments => _bottomNavigationValue('documents');
  String get importDocument => _value('importDocument');
  String get analyze => _value('analyze');
  String get bottomNavigationAnalyze => _bottomNavigationValue('analyze');
  String get tasks => _value('tasks');
  String get bottomNavigationTasks => _bottomNavigationValue('tasks');
  String get profile => _value('profile');
  String get settings => _value('settings');
  String get bottomNavigationSettings => _bottomNavigationValue('settings');
  String get scanImport => _value('scanImport');
  String get upcoming => _value('upcoming');
  String get recentDocuments => _value('recentDocuments');
  String get processingDocuments => _value('processingDocuments');
  String get analysisInProgress => _value('analysisInProgress');
  String get openDocument => _value('openDocument');
  String get viewAllDocuments => _value('viewAllDocuments');
  String get noUpcomingTasks => _value('noUpcomingTasks');
  String get noDocuments => _value('noDocuments');
  String get unclassified => _value('unclassified');
  String get classificationSuggested => _value('classificationSuggested');
  String get classificationConfirmed => _value('classificationConfirmed');
  String get documentFallback => _value('documentFallback');
  String get originalDocument => _value('originalDocument');
  String get originalDocumentUnavailable =>
      _value('originalDocumentUnavailable');
  String get documentDate => _value('documentDate');
  String get receivedDate => _value('receivedDate');
  String get analysisState => _value('analysisState');
  String get viewAnalysis => _value('viewAnalysis');
  String get imported => _value('imported');
  String get archived => _value('archived');
  String get deleted => _value('deleted');
  String get confirm => _value('confirm');
  String get organization => _value('organization');
  String get caseLabel => _value('caseLabel');
  String get caseNotAssigned => _value('caseNotAssigned');
  String get suggestedClassification => _value('suggestedClassification');
  String get change => _value('change');
  String get editClassification => _value('editClassification');
  String get save => _value('save');
  String get cancel => _value('cancel');
  String get chooseOrganization => _value('chooseOrganization');
  String get organizationName => _value('organizationName');
  String get caseName => _value('caseName');
  String get clearCase => _value('clearCase');
  String get cases => _value('cases');
  String get organizationDocuments => _value('organizationDocuments');
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
  String get productName => _value('productName');
  String get summary => _value('summary');
  String get importantFacts => _value('importantFacts');
  String get classification => _value('classification');
  String get noActionRequiredTitle => _value('noActionRequiredTitle');
  String get noActionRequiredBody => _value('noActionRequiredBody');
  String get actionRequiredBody => _value('actionRequiredBody');
  String get reviewRequiredTitle => _value('reviewRequiredTitle');
  String get reviewRequiredBody => _value('reviewRequiredBody');
  String get technicalFailureTitle => _value('technicalFailureTitle');
  String get technicalFailureBody => _value('technicalFailureBody');
  String get retryAnalysis => _value('retryAnalysis');
  String get unreadableResultTitle => _value('unreadableResultTitle');
  String get unreadableResultBody => _value('unreadableResultBody');
  String get chooseClearerDocument => _value('chooseClearerDocument');
  String get addTaskReminder => _value('addTaskReminder');
  String get analysisDetails => _value('analysisDetails');
  String get suggestedTasks => _value('suggestedTasks');
  String get deadline => _value('deadline');
  String get appointment => _value('appointment');
  String get amount => _value('amount');
  String get originalDocumentSavedLocally =>
      _value('originalDocumentSavedLocally');
  String _value(String key) =>
      (_strings[locale.languageCode] ?? _strings['de']!)[key] ??
      (_resultStrings[locale.languageCode] ?? _resultStrings['de']!)[key] ??
      (_extraStrings[locale.languageCode] ?? _extraStrings['de']!)[key] ??
      (_analysisLanguageStrings[locale.languageCode] ??
          _analysisLanguageStrings['de']!)[key] ??
      (_documentLibraryStrings[locale.languageCode] ??
          _documentLibraryStrings['de']!)[key] ??
      key;

  String _bottomNavigationValue(String key) =>
      (_bottomNavigationStrings[locale.languageCode] ??
          _bottomNavigationStrings['de']!)[key]!;
}

const _bottomNavigationStrings = <String, Map<String, String>>{
  'de': {
    'home': 'Start',
    'documents': 'Dokumente',
    'analyze': 'Analyse',
    'tasks': 'Aufgaben',
    'settings': 'Einst.',
  },
  'ar': {
    'home': 'الرئيسية',
    'documents': 'المستندات',
    'analyze': 'تحليل',
    'tasks': 'المهام',
    'settings': 'الإعدادات',
  },
};

const _resultStrings = <String, Map<String, String>>{
  'de': {
    'productName': 'Doxary',
    'summary': 'Zusammenfassung',
    'importantFacts': 'Wichtige Angaben',
    'classification': 'Zuordnung',
    'noActionRequiredTitle': 'Keine Aktion erforderlich',
    'noActionRequiredBody': 'Dieses Dokument erfordert derzeit keine Aktion.',
    'actionRequiredBody': 'Dieses Dokument enthält eine erforderliche Aktion.',
    'reviewRequiredTitle': 'Bitte prüfen',
    'reviewRequiredBody': 'Die Analyse ist teilweise oder unsicher. Prüfe die markierten Angaben im Originaldokument.',
    'technicalFailureTitle': 'Analyse nicht abgeschlossen',
    'technicalFailureBody': 'Die Analyse ist technisch fehlgeschlagen. Das gespeicherte Dokument bleibt erhalten.',
    'retryAnalysis': 'Analyse erneut starten',
    'unreadableResultTitle': 'Dokument nicht ausreichend lesbar',
    'unreadableResultBody': 'Für eine verlässliche Analyse wird ein vollständigeres oder klareres Dokument benötigt.',
    'chooseClearerDocument': 'Klareres Dokument auswählen',
    'addTaskReminder': 'Aufgabe oder Erinnerung hinzufügen',
    'analysisDetails': 'Weitere Analysedetails',
    'suggestedTasks': 'Vorgeschlagene Aufgaben',
    'deadline': 'Frist',
    'appointment': 'Termin',
    'amount': 'Betrag',
    'originalDocumentSavedLocally':
        'Das Original ist lokal gespeichert. Öffnen ist noch nicht verfügbar.',
  },
  'ar': {
    'productName': 'Doxary',
    'summary': 'الملخص',
    'importantFacts': 'المعلومات المهمة',
    'classification': 'التصنيف',
    'noActionRequiredTitle': 'لا يلزم اتخاذ إجراء',
    'noActionRequiredBody': 'لا يتطلب هذا المستند أي إجراء حاليًا.',
    'actionRequiredBody': 'يتضمن هذا المستند إجراءً مطلوبًا.',
    'reviewRequiredTitle': 'يرجى المراجعة',
    'reviewRequiredBody':
        'التحليل جزئي أو غير مؤكد. راجع المعلومات المحددة في المستند الأصلي.',
    'technicalFailureTitle': 'لم يكتمل التحليل',
    'technicalFailureBody':
        'تعذر إكمال التحليل بسبب مشكلة تقنية. يبقى المستند المحفوظ متاحًا.',
    'retryAnalysis': 'إعادة التحليل',
    'unreadableResultTitle': 'المستند غير واضح بما يكفي',
    'unreadableResultBody':
        'يلزم مستند أوضح أو أكثر اكتمالًا للحصول على تحليل موثوق.',
    'chooseClearerDocument': 'اختيار مستند أوضح',
    'addTaskReminder': 'إضافة مهمة أو تذكير',
    'analysisDetails': 'تفاصيل التحليل الإضافية',
    'suggestedTasks': 'المهام المقترحة',
    'deadline': 'المهلة',
    'appointment': 'الموعد',
    'amount': 'المبلغ',
    'originalDocumentSavedLocally':
        'المستند الأصلي محفوظ محليًا. الفتح غير متاح بعد.',
  },
};

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

const _documentLibraryStrings = <String, Map<String, String>>{
  'de': {
    'unclassified': 'Nicht zugeordnet',
    'classificationSuggested': 'Vorschlag \u2013 bitte best\u00e4tigen',
    'classificationConfirmed': 'Zugeordnet',
    'documentFallback': 'Dokument',
    'originalDocument': 'Originaldokument',
    'originalDocumentUnavailable': 'Das Originaldokument ist nicht verfügbar.',
    'documentDate': 'Dokumentdatum',
    'receivedDate': 'Empfangen',
    'analysisState': 'Analysestatus',
    'viewAnalysis': 'Analyse ansehen',
    'imported': 'Importiert',
    'archived': 'Archiviert',
    'deleted': 'Gelöscht',
    'confirm': 'Bestätigen',
    'organization': 'Organisation',
    'caseLabel': 'Vorgang',
    'caseNotAssigned': 'Nicht zugeordnet',
    'suggestedClassification': 'Vorgeschlagene Zuordnung',
    'change': 'Ändern',
    'editClassification': 'Zuordnung bearbeiten',
    'save': 'Speichern',
    'cancel': 'Abbrechen',
    'chooseOrganization': 'Organisation wählen',
    'organizationName': 'Name der Organisation',
    'caseName': 'Name des Vorgangs',
    'clearCase': 'Vorgang entfernen',
    'cases': 'Vorgänge',
    'organizationDocuments': 'Dokumente ohne Vorgang',
  },
  'ar': {
    'unclassified': 'غير مصنف',
    'classificationSuggested': '\u0627\u0642\u062a\u0631\u0627\u062d \u2013 \u064a\u0631\u062c\u0649 \u0627\u0644\u062a\u0623\u0643\u064a\u062f',
    'classificationConfirmed': '\u0645\u0635\u0646\u0641',
    'documentFallback': '\u0645\u0633\u062a\u0646\u062f',
    'originalDocument': 'المستند الأصلي',
    'originalDocumentUnavailable': 'المستند الأصلي غير متاح.',
    'documentDate': '\u062a\u0627\u0631\u064a\u062e \u0627\u0644\u0645\u0633\u062a\u0646\u062f',
    'receivedDate': '\u062a\u0627\u0631\u064a\u062e \u0627\u0644\u0627\u0633\u062a\u0644\u0627\u0645',
    'analysisState':
        '\u062d\u0627\u0644\u0629 \u0627\u0644\u062a\u062d\u0644\u064a\u0644',
    'viewAnalysis':
        '\u0639\u0631\u0636 \u0627\u0644\u062a\u062d\u0644\u064a\u0644',
    'imported':
        '\u062a\u0645 \u0627\u0644\u0627\u0633\u062a\u064a\u0631\u0627\u062f',
    'archived': '\u0645\u0624\u0631\u0634\u0641',
    'deleted': '\u0645\u062d\u0630\u0648\u0641',
    'confirm': 'تأكيد',
    'organization': 'الجهة',
    'caseLabel': 'المعاملة',
    'caseNotAssigned': 'غير محددة',
    'suggestedClassification': 'التصنيف المقترح',
    'change': 'تغيير',
    'editClassification': 'تعديل التصنيف',
    'save': '\u062d\u0641\u0638',
    'cancel': '\u0625\u0644\u063a\u0627\u0621',
    'chooseOrganization': 'اختر الجهة',
    'organizationName': 'اسم الجهة',
    'caseName': 'اسم المعاملة',
    'clearCase': 'إزالة المعاملة',
    'cases': 'المعاملات',
    'organizationDocuments': 'مستندات بلا معاملة',
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
    'analysisTitle': 'التحليل',
    'analysisReadError': 'تعذر قراءة التحليل المحفوظ.',
    'noSavedAnalysis': 'لا يوجد تحليل محفوظ بعد.',
    'suggestion': '\u0627\u0642\u062a\u0631\u0627\u062d',
    'explanation': 'الشرح',
    'outputStyle': '\u0623\u0633\u0644\u0648\u0628 \u0627\u0644\u0625\u062e\u0631\u0627\u062c',
    'whatToDo': '\u0645\u0627 \u0627\u0644\u0630\u064a \u064a\u062c\u0628 \u0641\u0639\u0644\u0647؟',
    'actionRequired': 'الإجراء مطلوب',
    'urgency': '\u0627\u0644\u0623\u0648\u0644\u0648\u064a\u0629',
    'deadlines': '\u0627\u0644\u0645\u0648\u0627\u0639\u064a\u062f \u0627\u0644\u0646\u0647\u0627\u0626\u064a\u0629',
    'appointments': '\u0627\u0644\u0645\u0648\u0627\u0639\u064a\u062f',
    'amounts': '\u0627\u0644\u0645\u0628\u0627\u0644\u063a',
    'requiredDocuments': 'المستندات المطلوبة',
    'nextActions': 'الخطوات التالية',
    'documentQuality': 'جودة المستند',
    'pleaseVerify': 'يرجى التحقق',
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
    'qualityBlurry': 'قد تكون الصورة غير واضحة.',
    'qualityCutOff': 'قد تكون الصفحة مقصوصة.',
    'qualityUnreadable': 'بعض النص غير مقروء.',
    'qualityMissing': 'قد تكون هناك صفحات مفقودة.',
    'qualityUnsupported': 'صيغة الملف غير مدعومة.',
    'qualityCorrupt': 'قد يكون الملف تالفًا.',
    'qualityInsufficient': 'قد لا يكون المحتوى كافيًا.',
  },
};

const _strings = <String, Map<String, String>>{
  'de': {
    'appTitle': 'Dokumente',
    'home': 'Start',
    'documents': 'Dokumente',
    'importDocument': 'Neu',
    'analyze': 'Analysieren',
    'tasks': 'Aufgaben',
    'profile': 'Profil',
    'settings': 'Einstellungen',
    'scanImport': 'Dokument importieren',
    'upcoming': 'Anstehende Aufgaben',
    'recentDocuments': 'Letzte Dokumente',
    'processingDocuments': 'In Bearbeitung',
    'analysisInProgress': 'Analyse läuft',
    'openDocument': 'Dokument öffnen',
    'viewAllDocuments': 'Alle Dokumente anzeigen',
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
    'analyze': 'تحليل',
    'tasks': 'المهام',
    'profile': 'الملف الشخصي',
    'settings': 'الإعدادات',
    'scanImport': 'استيراد مستند',
    'upcoming': 'المهام القادمة',
    'recentDocuments': 'أحدث المستندات',
    'processingDocuments': 'قيد التحليل',
    'analysisInProgress': 'جارٍ التحليل',
    'openDocument': 'فتح المستند',
    'viewAllDocuments': 'عرض كل المستندات',
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
