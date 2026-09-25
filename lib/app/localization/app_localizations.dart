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
  String get addDocumentForAnalysis => _value('addDocumentForAnalysis');
  String get captureDocument => _value('captureDocument');
  String get chooseFileOrImage => _value('chooseFileOrImage');
  String get supportedFormats => _value('supportedFormats');
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
  String get originalDocumentAvailable => _value('originalDocumentAvailable');
  String get openOriginalDocument => _value('openOriginalDocument');
  String get unableToOpenOriginalDocument =>
      _value('unableToOpenOriginalDocument');
  String get originalDocumentUnsupported =>
      _value('originalDocumentUnsupported');
  String originalDocumentPageCount(int current, int total) =>
      _value('originalDocumentPageCount')
          .replaceFirst('{current}', '$current')
          .replaceFirst('{total}', '$total');
  String originalDocumentPageUnavailable(int page) =>
      _value('originalDocumentPageUnavailable').replaceFirst('{page}', '$page');
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
  String get dismiss => _value('dismiss');
  String get chooseOrganization => _value('chooseOrganization');
  String get selectOrganization => _value('selectOrganization');
  String get searchOrganization => _value('searchOrganization');
  String get createOrganization => _value('createOrganization');
  String get create => _value('create');
  String get organizationNameRequired => _value('organizationNameRequired');
  String get organizationCreateFailed => _value('organizationCreateFailed');
  String get selectCase => _value('selectCase');
  String get searchCase => _value('searchCase');
  String get createCase => _value('createCase');
  String get caseNameRequired => _value('caseNameRequired');
  String get caseCreateFailed => _value('caseCreateFailed');
  String get organizationName => _value('organizationName');
  String get caseName => _value('caseName');
  String get clearCase => _value('clearCase');
  String get clearClassification => _value('clearClassification');
  String get cases => _value('cases');
  String get organizationDocuments => _value('organizationDocuments');
  String get organizations => _value('organizations');
  String get withoutCase => _value('withoutCase');
  String get searchDocuments => _value('searchDocuments');
  String get searchCases => _value('searchCases');
  String get gridView => _value('gridView');
  String get listView => _value('listView');
  String get noMatchingOrganizations => _value('noMatchingOrganizations');
  String get noMatchingCases => _value('noMatchingCases');
  String get needsAttention => _value('needsAttention');
  String documentsNeedAttention(int count) => locale.languageCode == 'ar'
      ? count == 1
            ? '1 مستند يحتاج إلى انتباه'
            : '$count مستندات تحتاج إلى انتباه'
      : count == 1
      ? '1 Dokument benötigt Aufmerksamkeit'
      : '$count Dokumente benötigen Aufmerksamkeit';
  String get noDocumentsNeedAttention => _value('noDocumentsNeedAttention');
  String get attentionResolvedDescription =>
      _value('attentionResolvedDescription');
  String get attentionAnalysisFailed => _value('attentionAnalysisFailed');
  String get attentionAnalysisDeleted => _value('attentionAnalysisDeleted');
  String get today => _value('today');
  String get overdue => _value('overdue');
  String get taskOverdue => _value('taskOverdue');
  String get completed => _value('completed');
  String get noTasks => _value('noTasks');
  String get createTask => _value('createTask');
  String get editTask => _value('editTask');
  String get taskDetail => _value('taskDetail');
  String get taskStatus => _value('taskStatus');
  String get taskOpen => _value('taskOpen');
  String get taskUnavailable => _value('taskUnavailable');
  String get taskNoLongerAvailable => _value('taskNoLongerAvailable');
  String get ok => _value('ok');
  String get notSpecified => _value('notSpecified');
  String get taskTitle => _value('taskTitle');
  String get taskTitleRequired => _value('taskTitleRequired');
  String get date => _value('date');
  String get chooseDate => _value('chooseDate');
  String get dateRequired => _value('dateRequired');
  String get time => _value('time');
  String get chooseTime => _value('chooseTime');
  String get timeRequired => _value('timeRequired');
  String get allDay => _value('allDay');
  String get reminder => _value('reminder');
  String get noReminder => _value('noReminder');
  String get reminderAtTime => _value('reminderAtTime');
  String get reminderFiveMinutesBefore => _value('reminderFiveMinutesBefore');
  String get reminderTenMinutesBefore => _value('reminderTenMinutesBefore');
  String get reminderThirtyMinutesBefore =>
      _value('reminderThirtyMinutesBefore');
  String get reminderOneHourBefore => _value('reminderOneHourBefore');
  String get reminderOneDayBefore => _value('reminderOneDayBefore');
  String get reminderPermissionDenied => _value('reminderPermissionDenied');
  String get reminderPermissionNeeded => _value('reminderPermissionNeeded');
  String get reminderUnavailable => _value('reminderUnavailable');
  String get reminderNotScheduled => _value('reminderNotScheduled');
  String get reminderTimePassed => _value('reminderTimePassed');
  String get linkedDocument => _value('linkedDocument');
  String get linkedCase => _value('linkedCase');
  String get noLinkedDocument => _value('noLinkedDocument');
  String get noLinkedCase => _value('noLinkedCase');
  String get note => _value('note');
  String get optional => _value('optional');
  String get markCompleted => _value('markCompleted');
  String get reopenTask => _value('reopenTask');
  String get deleteTask => _value('deleteTask');
  String get deleteTaskTitle => _value('deleteTaskTitle');
  String get deleteTaskMessage => _value('deleteTaskMessage');
  String get camera => _value('camera');
  String get image => _value('image');
  String get pdf => _value('pdf');
  String get importUnavailable => _value('importUnavailable');
  String get language => _value('language');
  String get applicationLanguage => _value('applicationLanguage');
  String get account => _value('account');
  String get planAccount => _value('planAccount');
  String get notifications => _value('notifications');
  String get analysisNotifications => _value('analysisNotifications');
  String get taskNotifications => _value('taskNotifications');
  String get appearance => _value('appearance');
  String get darkAppearance => _value('darkAppearance');
  String get appearanceSystem => _value('appearanceSystem');
  String get appearanceLight => _value('appearanceLight');
  String get appearanceDark => _value('appearanceDark');
  String get privacyAndData => _value('privacyAndData');
  String get localDocuments => _value('localDocuments');
  String get dataManagement => _value('dataManagement');
  String get legal => _value('legal');
  String get privacyPolicy => _value('privacyPolicy');
  String get terms => _value('terms');
  String get about => _value('about');
  String get rateApp => _value('rateApp');
  String get shareApp => _value('shareApp');
  String get shareAppMessage => _value('shareAppMessage');
  String get shareUnavailable => _value('shareUnavailable');
  String get appVersion => _value('appVersion');
  String get versionLoading => _value('versionLoading');
  String get versionUnavailable => _value('versionUnavailable');
  String get rateAppUnavailable => _value('rateAppUnavailable');
  String get notAvailableYet => _value('notAvailableYet');
  String get german => _value('german');
  String get arabic => _value('arabic');
  String get foundationMessage => _value('foundationMessage');
  String get emptyDocumentsDescription => _value('emptyDocumentsDescription');
  String get selectedDocument => _value('selectedDocument');
  String get remove => _value('remove');
  String get startAnalysis => _value('startAnalysis');
  String get analysisUploading => _value('analysisUploading');
  String get analysisStarted => _value('analysisStarted');
  String get processingTitle => _value('processingTitle');
  String get processingDescription => _value('processingDescription');
  String get processingAccepted => _value('processingAccepted');
  String get processingWaiting => _value('processingWaiting');
  String get continueInBackground => _value('continueInBackground');
  String get cancelAnalysis => _value('cancelAnalysis');
  String get cancellationUnavailable => _value('cancellationUnavailable');
  String get analysisComplete => _value('analysisComplete');
  String get analysisFailed => _value('analysisFailed');
  String get images => _value('images');
  String get cameraDeferred => _value('cameraDeferred');
  String get cameraFlash => _value('cameraFlash');
  String get cameraPreparing => _value('cameraPreparing');
  String get cameraPermissionDenied => _value('cameraPermissionDenied');
  String get cameraPermissionSettingsRequired =>
      _value('cameraPermissionSettingsRequired');
  String get cameraPermissionRestricted => _value('cameraPermissionRestricted');
  String get cameraUnavailable => _value('cameraUnavailable');
  String get cameraInitializationFailed => _value('cameraInitializationFailed');
  String get cameraCaptureStored => _value('cameraCaptureStored');
  String get cameraRetake => _value('cameraRetake');
  String get cameraUsePhoto => _value('cameraUsePhoto');
  String get cameraRotate => _value('cameraRotate');
  String get cameraRotateFailed => _value('cameraRotateFailed');
  String get cameraCrop => _value('cameraCrop');
  String get cameraCropFailed => _value('cameraCropFailed');
  String get cameraAddAnotherPage => _value('cameraAddAnotherPage');
  String get cameraContinue => _value('cameraContinue');
  String get cameraPagesForAnalysis => _value('cameraPagesForAnalysis');
  String get cameraMaximumPages => _value('cameraMaximumPages');
  String get cameraDiscardPagesTitle => _value('cameraDiscardPagesTitle');
  String get cameraDiscardPagesMessage => _value('cameraDiscardPagesMessage');
  String get cameraKeepEditing => _value('cameraKeepEditing');
  String get cameraDiscardPages => _value('cameraDiscardPages');
  String get cameraCapturedDocument => _value('cameraCapturedDocument');
  String get cameraPage => _value('cameraPage');
  String get cameraPages => _value('cameraPages');
  String cameraPageCount(int count) =>
      '$count ${count == 1 ? cameraPage : cameraPages}';
  String get cameraManagePages => _value('cameraManagePages');
  String get cameraReadyForAnalysis => _value('cameraReadyForAnalysis');
  String get operationRetryableError => _value('operationRetryableError');
  String get operationFailedError => _value('operationFailedError');
  String get localDataUnavailable => locale.languageCode == 'ar'
      ? '\u062a\u0639\u0630\u0631 \u062a\u062d\u0645\u064a\u0644 \u0627\u0644\u0628\u064a\u0627\u0646\u0627\u062a \u0627\u0644\u0645\u062d\u0644\u064a\u0629.'
      : 'Lokale Daten konnten nicht geladen werden.';
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
  String get actionQuestion => _value('actionQuestion');
  String get actionUncertainTitle => _value('actionUncertainTitle');
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
  String get documentRetainedMessage => _value('documentRetainedMessage');
  String get chooseClearerDocument => _value('chooseClearerDocument');
  String get unavailableInputTitle => _value('unavailableInputTitle');
  String get unavailableInputBody => _value('unavailableInputBody');
  String get chooseAnotherDocument => _value('chooseAnotherDocument');
  String get addTaskReminder => _value('addTaskReminder');
  String get followUpDocument => _value('followUpDocument');
  String get analysisDetails => _value('analysisDetails');
  String get suggestedTasks => _value('suggestedTasks');
  String get deadline => _value('deadline');
  String get appointment => _value('appointment');
  String get amount => _value('amount');
  String get originalDocumentSavedLocally =>
      _value('originalDocumentSavedLocally');
  String get analysisHistory => locale.languageCode == 'ar'
      ? '\u0633\u062c\u0644 \u0627\u0644\u062a\u062d\u0644\u064a\u0644'
      : _value('analysisHistory');
  String get documentAdded => locale.languageCode == 'ar'
      ? '\u062a\u0645\u062a \u0625\u0636\u0627\u0641\u0629 \u0627\u0644\u0645\u0633\u062a\u0646\u062f'
      : _value('documentAdded');
  String get analysisSuccessful => locale.languageCode == 'ar'
      ? '\u0646\u0627\u062c\u062d'
      : _value('analysisSuccessful');
  String get analysisFailedHistory => locale.languageCode == 'ar'
      ? '\u0641\u0634\u0644 \u0627\u0644\u062a\u062d\u0644\u064a\u0644'
      : _value('analysisFailedHistory');
  String get analysisPendingHistory => locale.languageCode == 'ar'
      ? '\u062c\u0627\u0631\u064d \u0627\u0644\u062a\u062d\u0644\u064a\u0644'
      : _value('analysisPendingHistory');
  String get analysisDate => locale.languageCode == 'ar'
      ? '\u062a\u0627\u0631\u064a\u062e \u0627\u0644\u062a\u062d\u0644\u064a\u0644'
      : _value('analysisDate');
  String get openResult => locale.languageCode == 'ar'
      ? '\u0641\u062a\u062d \u0627\u0644\u0646\u062a\u064a\u062c\u0629'
      : _value('openResult');
  String get deleteAnalysis => locale.languageCode == 'ar'
      ? '\u062d\u0630\u0641 \u0627\u0644\u062a\u062d\u0644\u064a\u0644'
      : _value('deleteAnalysis');
  String get deleteAnalysisTitle => locale.languageCode == 'ar'
      ? '\u062d\u0630\u0641 \u0627\u0644\u062a\u062d\u0644\u064a\u0644\u061f'
      : _value('deleteAnalysisTitle');
  String get deleteAnalysisMessage => locale.languageCode == 'ar'
      ? '\u0633\u064a\u064f\u062d\u0630\u0641 \u0647\u0630\u0627 \u0627\u0644\u062a\u062d\u0644\u064a\u0644 \u0641\u0642\u0637. \u064a\u0628\u0642\u0649 \u0627\u0644\u0645\u0633\u062a\u0646\u062f \u0627\u0644\u0623\u0635\u0644\u064a \u0648\u0627\u0644\u062a\u062d\u0644\u064a\u0644\u0627\u062a \u0627\u0644\u0623\u062e\u0631\u0649 \u0648\u0627\u0644\u0645\u0647\u0627\u0645 \u0627\u0644\u0645\u0631\u062a\u0628\u0637\u0629 \u0645\u062d\u0641\u0648\u0638\u0629.'
      : _value('deleteAnalysisMessage');
  String get analysisDeletedTitle => locale.languageCode == 'ar'
      ? '\u062a\u0645 \u062d\u0630\u0641 \u0627\u0644\u062a\u062d\u0644\u064a\u0644'
      : _value('analysisDeletedTitle');
  String get analysisDeletedBody => locale.languageCode == 'ar'
      ? '\u0627\u0644\u0645\u0633\u062a\u0646\u062f \u0627\u0644\u0623\u0635\u0644\u064a \u0645\u0627 \u0632\u0627\u0644 \u0645\u062d\u0641\u0648\u0638\u064b\u0627 \u0648\u064a\u0645\u0643\u0646 \u0625\u0639\u0627\u062f\u0629 \u062a\u062d\u0644\u064a\u0644\u0647.'
      : _value('analysisDeletedBody');
  String get analysisDeletedDate => locale.languageCode == 'ar'
      ? '\u062d\u064f\u0630\u0641 \u0641\u064a'
      : _value('analysisDeletedDate');
  String get deleteAnalysisAttempt => locale.languageCode == 'ar'
      ? '\u062d\u0630\u0641 \u0627\u0644\u0645\u062d\u0627\u0648\u0644\u0629'
      : _value('deleteAnalysisAttempt');
  String get deleteAnalysisAttemptTitle => locale.languageCode == 'ar'
      ? '\u062d\u0630\u0641 \u0645\u062d\u0627\u0648\u0644\u0629 \u0627\u0644\u062a\u062d\u0644\u064a\u0644\u061f'
      : _value('deleteAnalysisAttemptTitle');
  String get deleteAnalysisAttemptMessage => locale.languageCode == 'ar'
      ? '\u0633\u064a\u062a\u0645 \u062d\u0630\u0641 \u0633\u062c\u0644 \u0645\u062d\u0627\u0648\u0644\u0629 \u0627\u0644\u062a\u062d\u0644\u064a\u0644 \u0627\u0644\u0641\u0627\u0634\u0644\u0629 \u0641\u0642\u0637. \u0633\u064a\u0628\u0642\u0649 \u0627\u0644\u0645\u0633\u062a\u0646\u062f \u0627\u0644\u0623\u0635\u0644\u064a \u0645\u062d\u0641\u0648\u0638\u064b\u0627.'
      : _value('deleteAnalysisAttemptMessage');
  String get viewTask => locale.languageCode == 'ar'
      ? '\u0639\u0631\u0636 \u0627\u0644\u0645\u0647\u0645\u0629'
      : _value('viewTask');
  String _value(String key) =>
      (_strings[locale.languageCode] ?? _strings['de']!)[key] ??
      (_resultStrings[locale.languageCode] ?? _resultStrings['de']!)[key] ??
      (_extraStrings[locale.languageCode] ?? _extraStrings['de']!)[key] ??
      (_analysisLanguageStrings[locale.languageCode] ??
          _analysisLanguageStrings['de']!)[key] ??
      (_documentLibraryStrings[locale.languageCode] ??
          _documentLibraryStrings['de']!)[key] ??
      (_documentBrowserStrings[locale.languageCode] ??
          _documentBrowserStrings['de']!)[key] ??
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
    'createTask': '\u0625\u0646\u0634\u0627\u0621 \u0645\u0647\u0645\u0629',
    'editTask':
        '\u062a\u0639\u062f\u064a\u0644 \u0627\u0644\u0645\u0647\u0645\u0629',
    'taskTitle':
        '\u0639\u0646\u0648\u0627\u0646 \u0627\u0644\u0645\u0647\u0645\u0629',
    'taskTitleRequired': '\u064a\u0631\u062c\u0649 \u0625\u062f\u062e\u0627\u0644 \u0639\u0646\u0648\u0627\u0646 \u0627\u0644\u0645\u0647\u0645\u0629.',
    'date': '\u0627\u0644\u062a\u0627\u0631\u064a\u062e',
    'chooseDate':
        '\u0627\u062e\u062a\u0631 \u0627\u0644\u062a\u0627\u0631\u064a\u062e',
    'time': '\u0627\u0644\u0648\u0642\u062a',
    'chooseTime': '\u0627\u062e\u062a\u0631 \u0627\u0644\u0648\u0642\u062a',
    'allDay': '\u0637\u0648\u0627\u0644 \u0627\u0644\u064a\u0648\u0645',
    'reminder': '\u0627\u0644\u062a\u0630\u0643\u064a\u0631',
    'noReminder': '\u0628\u062f\u0648\u0646 \u062a\u0630\u0643\u064a\u0631',
    'reminderAtTime': '\u0639\u0646\u062f \u0627\u0644\u0648\u0642\u062a',
    'reminderFiveMinutesBefore':
        '\u0642\u0628\u0644 5 \u062f\u0642\u0627\u0626\u0642',
    'reminderTenMinutesBefore':
        '\u0642\u0628\u0644 10 \u062f\u0642\u0627\u0626\u0642',
    'reminderThirtyMinutesBefore':
        '\u0642\u0628\u0644 30 \u062f\u0642\u064a\u0642\u0629',
    'reminderOneHourBefore': '\u0642\u0628\u0644 \u0633\u0627\u0639\u0629',
    'reminderOneDayBefore': '\u0642\u0628\u0644 \u064a\u0648\u0645',
    'linkedDocument': '\u0627\u0644\u0645\u0633\u062a\u0646\u062f \u0627\u0644\u0645\u0631\u062a\u0628\u0637',
    'linkedCase': '\u0627\u0644\u0645\u0639\u0627\u0645\u0644\u0629 \u0627\u0644\u0645\u0631\u062a\u0628\u0637\u0629',
    'noLinkedDocument':
        '\u0628\u062f\u0648\u0646 \u0645\u0633\u062a\u0646\u062f',
    'noLinkedCase':
        '\u0628\u062f\u0648\u0646 \u0645\u0639\u0627\u0645\u0644\u0629',
    'note': '\u0645\u0644\u0627\u062d\u0638\u0629',
    'optional': '\u0627\u062e\u062a\u064a\u0627\u0631\u064a',
    'markCompleted': '\u062a\u062d\u062f\u064a\u062f \u0643\u0645\u0643\u062a\u0645\u0644\u0629',
    'deleteTask': '\u062d\u0630\u0641 \u0627\u0644\u0645\u0647\u0645\u0629',
    'deleteTaskTitle':
        '\u062d\u0630\u0641 \u0627\u0644\u0645\u0647\u0645\u0629\u061f',
    'deleteTaskMessage': '\u0633\u062a\u064f\u062d\u0630\u0641 \u0647\u0630\u0647 \u0627\u0644\u0645\u0647\u0645\u0629 \u0646\u0647\u0627\u0626\u064a\u064b\u0627.',
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
    'unavailableInputTitle': 'Dokument kann nicht verarbeitet werden',
    'unavailableInputBody': 'Dieses Dokument kann in seinem aktuellen Format oder Zustand nicht analysiert werden.',
    'chooseAnotherDocument': 'Anderes Dokument auswÃ¤hlen',
    'summary': 'Zusammenfassung',
    'importantFacts': 'Wichtige Angaben',
    'classification': 'Zuordnung',
    'noActionRequiredTitle': 'Keine Aktion erforderlich',
    'noActionRequiredBody': 'Dieses Dokument erfordert derzeit keine Aktion.',
    'actionRequiredBody': 'Dieses Dokument enthält eine erforderliche Aktion.',
    'actionQuestion': 'Muss etwas getan werden?',
    'actionUncertainTitle': 'Nicht sicher feststellbar',
    'reviewRequiredTitle': 'Bitte prüfen',
    'reviewRequiredBody': 'Die Analyse ist teilweise oder unsicher. Prüfe die markierten Angaben im Originaldokument.',
    'technicalFailureTitle': 'Analyse nicht abgeschlossen',
    'technicalFailureBody': 'Die Analyse ist technisch fehlgeschlagen. Das gespeicherte Dokument bleibt erhalten.',
    'retryAnalysis': 'Analyse erneut starten',
    'unreadableResultTitle': 'Dokument nicht ausreichend lesbar',
    'unreadableResultBody': 'Für eine verlässliche Analyse wird ein vollständigeres oder klareres Dokument benötigt.',
    'documentRetainedMessage':
        'Das importierte Dokument bleibt in Doxary erhalten.',
    'chooseClearerDocument': 'Klareres Dokument auswählen',
    'addTaskReminder': 'Aufgabe oder Erinnerung hinzufügen',
    'followUpDocument': 'Zum Dokument nachfassen',
    'analysisDetails': 'Weitere Analysedetails',
    'suggestedTasks': 'Vorgeschlagene Aufgaben',
    'deadline': 'Frist',
    'appointment': 'Termin',
    'amount': 'Betrag',
    'analysisHistory': 'Analyseverlauf',
    'documentAdded': 'Dokument hinzugefügt',
    'analysisSuccessful': 'Erfolgreich',
    'analysisFailedHistory': 'Fehlgeschlagen',
    'analysisPendingHistory': 'Wird analysiert',
    'analysisDate': 'Analysiert',
    'openResult': 'Ergebnis öffnen',
    'deleteAnalysis': 'Analyse löschen',
    'deleteAnalysisTitle': 'Analyse löschen?',
    'deleteAnalysisMessage': 'Nur dieses Analyseergebnis wird gelöscht. Das Originaldokument, andere Analysen und verknüpfte Aufgaben bleiben in Doxary erhalten.',
    'analysisDeletedTitle': 'Analyse gelöscht',
    'analysisDeletedBody': 'Das Originaldokument ist weiterhin gespeichert und kann erneut analysiert werden.',
    'analysisDeletedDate': 'Gelöscht',
    'deleteAnalysisAttempt': 'Versuch löschen',
    'deleteAnalysisAttemptTitle': 'Analyseversuch löschen?',
    'deleteAnalysisAttemptMessage': 'Nur der fehlgeschlagene Analyseversuch wird gelöscht. Das Originaldokument bleibt gespeichert.',
    'viewTask': 'Aufgabe ansehen',
    'originalDocumentSavedLocally':
        'Das Original ist lokal gespeichert. Öffnen ist noch nicht verfügbar.',
  },
  'ar': {
    'productName': 'Doxary',
    'unavailableInputTitle': 'تعذر معالجة المستند',
    'unavailableInputBody':
        'لا يمكن تحليل هذا المستند بصيغته أو حالته الحالية.',
    'chooseAnotherDocument': 'اختر مستندًا آخر',
    'summary': 'الملخص',
    'importantFacts': 'المعلومات المهمة',
    'classification': 'التصنيف',
    'noActionRequiredTitle': 'لا يلزم اتخاذ إجراء',
    'noActionRequiredBody': 'لا يتطلب هذا المستند أي إجراء حاليًا.',
    'actionRequiredBody': 'يتضمن هذا المستند إجراءً مطلوبًا.',
    'actionQuestion': 'هل يلزم اتخاذ إجراء؟',
    'actionUncertainTitle': 'لا يمكن تحديد ذلك بثقة',
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
    'documentRetainedMessage': 'يبقى المستند المستورد محفوظًا في Doxary.',
    'chooseClearerDocument': 'اختيار مستند أوضح',
    'addTaskReminder': 'إضافة مهمة أو تذكير',
    'followUpDocument': '\u0645\u062a\u0627\u0628\u0639\u0629 \u0627\u0644\u0645\u0633\u062a\u0646\u062f',
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
    'originalDocumentAvailable': 'Originalquelle verfügbar.',
    'openOriginalDocument': 'Original öffnen',
    'unableToOpenOriginalDocument':
        'Das Originaldokument konnte nicht geöffnet werden.',
    'originalDocumentUnsupported':
        'Dieses Originaldokument kann hier nicht geöffnet werden.',
    'originalDocumentPageCount': 'Seite {current} von {total}',
    'originalDocumentPageUnavailable': 'Seite {page} ist nicht verfügbar.',
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
    'dismiss': 'Ausblenden',
    'chooseOrganization': 'Organisation wählen',
    'selectOrganization': 'Organisation auswählen',
    'searchOrganization': 'Organisation suchen',
    'createOrganization': 'Neue Organisation erstellen',
    'create': 'Erstellen',
    'organizationNameRequired': 'Bitte geben Sie einen Namen ein.',
    'organizationCreateFailed':
        'Die Organisation konnte nicht erstellt werden.',
    'selectCase': 'Vorgang auswählen',
    'searchCase': 'Vorgang suchen',
    'createCase': 'Neuen Vorgang erstellen',
    'caseNameRequired': 'Bitte geben Sie einen Vorgangsnamen ein.',
    'caseCreateFailed': 'Der Vorgang konnte nicht erstellt werden.',
    'organizationName': 'Name der Organisation',
    'caseName': 'Name des Vorgangs',
    'clearCase': 'Vorgang entfernen',
    'clearClassification': 'Zuordnung aufheben',
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
    'originalDocumentAvailable': '\u0627\u0644\u0645\u0635\u062f\u0631 \u0627\u0644\u0623\u0635\u0644\u064a \u0645\u062a\u0627\u062d.',
    'openOriginalDocument': '\u0641\u062a\u062d \u0627\u0644\u0623\u0635\u0644',
    'unableToOpenOriginalDocument': '\u062a\u0639\u0630\u0631 \u0641\u062a\u062d \u0627\u0644\u0645\u0633\u062a\u0646\u062f \u0627\u0644\u0623\u0635\u0644\u064a.',
    'originalDocumentUnsupported': '\u0644\u0627 \u064a\u0645\u0643\u0646 \u0641\u062a\u062d \u0647\u0630\u0627 \u0627\u0644\u0645\u0633\u062a\u0646\u062f \u0627\u0644\u0623\u0635\u0644\u064a \u0647\u0646\u0627.',
    'originalDocumentPageCount':
        '\u0635\u0641\u062d\u0629 {current} \u0645\u0646 {total}',
    'originalDocumentPageUnavailable': '\u0627\u0644\u0635\u0641\u062d\u0629 {page} \u063a\u064a\u0631 \u0645\u062a\u0627\u062d\u0629.',
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
    'dismiss': '\u0625\u062e\u0641\u0627\u0621',
    'chooseOrganization': 'اختر الجهة',
    'selectOrganization': 'اختر الجهة',
    'searchOrganization': 'ابحث عن جهة',
    'createOrganization': 'إنشاء جهة جديدة',
    'create': 'إنشاء',
    'organizationNameRequired': 'يرجى إدخال اسم الجهة.',
    'organizationCreateFailed': 'تعذر إنشاء الجهة.',
    'selectCase': 'اختر المعاملة',
    'searchCase': 'ابحث عن معاملة',
    'createCase': 'إنشاء معاملة جديدة',
    'caseNameRequired': 'يرجى إدخال اسم المعاملة.',
    'caseCreateFailed': 'تعذر إنشاء المعاملة.',
    'organizationName': 'اسم الجهة',
    'caseName': 'اسم المعاملة',
    'clearCase': 'إزالة المعاملة',
    'clearClassification': '\u0625\u0644\u063a\u0627\u0621 \u0627\u0644\u062a\u0635\u0646\u064a\u0641',
    'cases': 'المعاملات',
    'organizationDocuments': 'مستندات بلا معاملة',
  },
};

const _documentBrowserStrings = <String, Map<String, String>>{
  'de': {
    'organizations': 'Organisationen',
    'withoutCase': 'Ohne Vorgang',
    'searchDocuments': 'Dokumente suchen',
    'searchCases': 'Vorgänge suchen',
    'gridView': 'Rasteransicht',
    'listView': 'Listenansicht',
    'noMatchingOrganizations': 'Keine passenden Organisationen',
    'noMatchingCases': 'Keine passenden Vorgänge',
    'needsAttention': 'Aufmerksamkeit erforderlich',
    'noDocumentsNeedAttention': 'Keine Dokumente benötigen Aufmerksamkeit',
    'attentionResolvedDescription':
        'Alle Dokumente sind bereit oder werden bereits analysiert.',
    'attentionAnalysisFailed': 'Analyse fehlgeschlagen',
    'attentionAnalysisDeleted': 'Analyse gelöscht',
  },
  'ar': {
    'organizations': '\u0627\u0644\u062c\u0647\u0627\u062a',
    'withoutCase': '\u0628\u0644\u0627 \u0645\u0639\u0627\u0645\u0644\u0629',
    'searchDocuments': '\u0627\u0628\u062d\u062b \u0639\u0646 \u0627\u0644\u0645\u0633\u062a\u0646\u062f\u0627\u062a',
    'searchCases': '\u0627\u0628\u062d\u062b \u0639\u0646 \u0627\u0644\u0645\u0639\u0627\u0645\u0644\u0627\u062a',
    'gridView': '\u0639\u0631\u0636 \u0634\u0628\u0643\u064a',
    'listView': '\u0639\u0631\u0636 \u0642\u0627\u0626\u0645\u0629',
    'noMatchingOrganizations': '\u0644\u0627 \u062a\u0648\u062c\u062f \u062c\u0647\u0627\u062a \u0645\u0637\u0627\u0628\u0642\u0629',
    'noMatchingCases': '\u0644\u0627 \u062a\u0648\u062c\u062f \u0645\u0639\u0627\u0645\u0644\u0627\u062a \u0645\u0637\u0627\u0628\u0642\u0629',
    'needsAttention': '\u062a\u062d\u062a\u0627\u062c \u0625\u0644\u0649 \u0627\u0646\u062a\u0628\u0627\u0647',
    'noDocumentsNeedAttention': '\u0644\u0627 \u062a\u0648\u062c\u062f \u0645\u0633\u062a\u0646\u062f\u0627\u062a \u062a\u062d\u062a\u0627\u062c \u0625\u0644\u0649 \u0627\u0646\u062a\u0628\u0627\u0647',
    'attentionResolvedDescription': '\u062c\u0645\u064a\u0639 \u0627\u0644\u0645\u0633\u062a\u0646\u062f\u0627\u062a \u062c\u0627\u0647\u0632\u0629 \u0623\u0648 \u0642\u064a\u062f \u0627\u0644\u062a\u062d\u0644\u064a\u0644.',
    'attentionAnalysisFailed':
        '\u0641\u0634\u0644 \u0627\u0644\u062a\u062d\u0644\u064a\u0644',
    'attentionAnalysisDeleted': '\u062a\u0645 \u062d\u0630\u0641 \u0627\u0644\u062a\u062d\u0644\u064a\u0644',
  },
};

const _extraStrings = <String, Map<String, String>>{
  'de': {
    'reminderPermissionNeeded':
        'Erlaube Benachrichtigungen, um Aufgaben-Erinnerungen zu erhalten.',
    'reminderPermissionDenied':
        'Die Aufgabe wurde gespeichert. Benachrichtigungen sind nicht erlaubt.',
    'reminderUnavailable': 'Die Aufgabe wurde gespeichert. Erinnerungen sind auf diesem Gerät nicht verfügbar.',
    'reminderNotScheduled': 'Die Aufgabe wurde gespeichert, aber die Erinnerung konnte nicht geplant werden.',
    'reminderTimePassed': 'Die Aufgabe wurde gespeichert. Der Erinnerungszeitpunkt liegt bereits in der Vergangenheit.',
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
    'reminderPermissionNeeded': 'اسمح بالإشعارات لتلقي تذكيرات المهام.',
    'reminderPermissionDenied': 'تم حفظ المهمة، لكن الإشعارات غير مسموح بها.',
    'reminderUnavailable':
        'تم حفظ المهمة، لكن التذكيرات غير متاحة على هذا الجهاز.',
    'reminderNotScheduled': 'تم حفظ المهمة، لكن تعذر جدولة التذكير.',
    'reminderTimePassed': 'تم حفظ المهمة. وقت التذكير أصبح في الماضي.',
    'createTask': '\u0625\u0646\u0634\u0627\u0621 \u0645\u0647\u0645\u0629',
    'editTask':
        '\u062a\u0639\u062f\u064a\u0644 \u0627\u0644\u0645\u0647\u0645\u0629',
    'taskDetail': '\u062a\u0641\u0627\u0635\u064a\u0644 \u0627\u0644\u0645\u0647\u0645\u0629',
    'taskStatus': '\u0627\u0644\u062d\u0627\u0644\u0629',
    'taskOpen': '\u0645\u0641\u062a\u0648\u062d\u0629',
    'taskUnavailable': '\u0627\u0644\u0645\u0647\u0645\u0629 \u063a\u064a\u0631 \u0645\u062a\u0627\u062d\u0629',
    'taskNoLongerAvailable': '\u0647\u0630\u0647 \u0627\u0644\u0645\u0647\u0645\u0629 \u0644\u0645 \u062a\u0639\u062f \u0645\u062a\u0627\u062d\u0629. \u0631\u0628\u0645\u0627 \u062a\u0645 \u062d\u0630\u0641\u0647\u0627.',
    'ok': '\u062d\u0633\u0646\u064b\u0627',
    'notSpecified': '\u063a\u064a\u0631 \u0645\u062d\u062f\u062f',
    'taskTitle':
        '\u0639\u0646\u0648\u0627\u0646 \u0627\u0644\u0645\u0647\u0645\u0629',
    'taskTitleRequired': '\u064a\u0631\u062c\u0649 \u0625\u062f\u062e\u0627\u0644 \u0639\u0646\u0648\u0627\u0646 \u0627\u0644\u0645\u0647\u0645\u0629.',
    'date': '\u0627\u0644\u062a\u0627\u0631\u064a\u062e',
    'chooseDate':
        '\u0627\u062e\u062a\u0631 \u0627\u0644\u062a\u0627\u0631\u064a\u062e',
    'time': '\u0627\u0644\u0648\u0642\u062a',
    'chooseTime': '\u0627\u062e\u062a\u0631 \u0627\u0644\u0648\u0642\u062a',
    'allDay': '\u0637\u0648\u0627\u0644 \u0627\u0644\u064a\u0648\u0645',
    'reminder': '\u0627\u0644\u062a\u0630\u0643\u064a\u0631',
    'noReminder': '\u0628\u062f\u0648\u0646 \u062a\u0630\u0643\u064a\u0631',
    'reminderAtTime': '\u0639\u0646\u062f \u0627\u0644\u0648\u0642\u062a',
    'reminderFiveMinutesBefore':
        '\u0642\u0628\u0644 5 \u062f\u0642\u0627\u0626\u0642',
    'reminderTenMinutesBefore':
        '\u0642\u0628\u0644 10 \u062f\u0642\u0627\u0626\u0642',
    'reminderThirtyMinutesBefore':
        '\u0642\u0628\u0644 30 \u062f\u0642\u064a\u0642\u0629',
    'reminderOneHourBefore': '\u0642\u0628\u0644 \u0633\u0627\u0639\u0629',
    'reminderOneDayBefore': '\u0642\u0628\u0644 \u064a\u0648\u0645',
    'linkedDocument': '\u0627\u0644\u0645\u0633\u062a\u0646\u062f \u0627\u0644\u0645\u0631\u062a\u0628\u0637',
    'linkedCase': '\u0627\u0644\u0645\u0639\u0627\u0645\u0644\u0629 \u0627\u0644\u0645\u0631\u062a\u0628\u0637\u0629',
    'noLinkedDocument':
        '\u0628\u062f\u0648\u0646 \u0645\u0633\u062a\u0646\u062f',
    'noLinkedCase':
        '\u0628\u062f\u0648\u0646 \u0645\u0639\u0627\u0645\u0644\u0629',
    'note': '\u0645\u0644\u0627\u062d\u0638\u0629',
    'optional': '\u0627\u062e\u062a\u064a\u0627\u0631\u064a',
    'markCompleted': '\u062a\u062d\u062f\u064a\u062f \u0643\u0645\u0643\u062a\u0645\u0644\u0629',
    'deleteTask': '\u062d\u0630\u0641 \u0627\u0644\u0645\u0647\u0645\u0629',
    'deleteTaskTitle':
        '\u062d\u0630\u0641 \u0627\u0644\u0645\u0647\u0645\u0629\u061f',
    'deleteTaskMessage': '\u0633\u062a\u064f\u062d\u0630\u0641 \u0647\u0630\u0647 \u0627\u0644\u0645\u0647\u0645\u0629 \u0646\u0647\u0627\u0626\u064a\u064b\u0627.',
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
    'addDocumentForAnalysis': 'Dokument zur Analyse hinzufügen',
    'captureDocument': 'Dokument aufnehmen',
    'chooseFileOrImage': 'Datei oder Bild auswählen',
    'supportedFormats': 'Unterstützte Formate: JPG, PNG, PDF',
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
    'overdue': 'Überfällig',
    'taskOverdue': 'Überfällig',
    'completed': 'Erledigt',
    'noTasks': 'Noch keine Aufgaben',
    'createTask': 'Aufgabe erstellen',
    'editTask': 'Aufgabe bearbeiten',
    'taskDetail': 'Aufgabe',
    'taskStatus': 'Status',
    'taskOpen': 'Offen',
    'taskUnavailable': 'Aufgabe nicht verf\u00fcgbar',
    'taskNoLongerAvailable': 'Diese Aufgabe ist nicht mehr verf\u00fcgbar. M\u00f6glicherweise wurde sie gel\u00f6scht.',
    'ok': 'OK',
    'notSpecified': 'Nicht angegeben',
    'taskTitle': 'Aufgabentitel',
    'taskTitleRequired': 'Bitte gib einen Aufgabentitel ein.',
    'date': 'Datum',
    'chooseDate': 'Datum auswählen',
    'dateRequired': 'Bitte wähle ein Fälligkeitsdatum aus.',
    'time': 'Uhrzeit',
    'chooseTime': 'Uhrzeit auswählen',
    'timeRequired': 'Bitte wähle eine Uhrzeit oder „Ganztägig“ aus.',
    'allDay': 'Ganztägig',
    'reminder': 'Erinnerung',
    'noReminder': 'Keine Erinnerung',
    'reminderAtTime': 'Zum Zeitpunkt',
    'reminderFiveMinutesBefore': '5 Minuten vorher',
    'reminderTenMinutesBefore': '10 Minuten vorher',
    'reminderThirtyMinutesBefore': '30 Minuten vorher',
    'reminderOneHourBefore': 'Eine Stunde vorher',
    'reminderOneDayBefore': 'Einen Tag vorher',
    'linkedDocument': 'Verknüpftes Dokument',
    'linkedCase': 'Verknüpfter Vorgang',
    'noLinkedDocument': 'Kein Dokument',
    'noLinkedCase': 'Kein Vorgang',
    'note': 'Notiz',
    'optional': 'Optional',
    'markCompleted': 'Als erledigt markieren',
    'reopenTask': 'Aufgabe wieder öffnen',
    'deleteTask': 'Aufgabe löschen',
    'deleteTaskTitle': 'Aufgabe löschen?',
    'deleteTaskMessage': 'Diese Aufgabe wird dauerhaft gelöscht.',
    'camera': 'Kamera',
    'image': 'Bild',
    'pdf': 'PDF',
    'importUnavailable':
        'Der Dokumentimport ist auf diesem Gerät noch nicht eingerichtet.',
    'language': 'Sprache',
    'applicationLanguage': 'App-Sprache',
    'account': 'Konto',
    'planAccount': 'Plan und Konto',
    'notifications': 'Benachrichtigungen',
    'analysisNotifications': 'Analyse abgeschlossen',
    'taskNotifications': 'Aufgaben und Termine',
    'appearance': 'Erscheinungsbild',
    'darkAppearance': 'Dunkles Erscheinungsbild',
    'appearanceSystem': 'System',
    'appearanceLight': 'Hell',
    'appearanceDark': 'Dunkel',
    'privacyAndData': 'Datenschutz und Daten',
    'localDocuments': 'Lokale Dokumente',
    'dataManagement': 'Daten verwalten',
    'legal': 'Rechtliches',
    'privacyPolicy': 'Datenschutzerklärung',
    'terms': 'Nutzungsbedingungen',
    'about': 'Über die App',
    'rateApp': 'App bewerten',
    'shareApp': 'App teilen',
    'shareAppMessage': 'Eine einfache App, um Dokumente zu organisieren.',
    'shareUnavailable': 'Teilen ist derzeit nicht verfügbar.',
    'appVersion': 'Version',
    'versionLoading': 'Version wird geladen …',
    'versionUnavailable': 'Version nicht verfügbar',
    'rateAppUnavailable': 'Noch kein Store-Eintrag',
    'notAvailableYet': 'Noch nicht verfügbar',
    'german': 'Deutsch',
    'arabic': 'Arabisch',
    'foundationMessage':
        'Die Grundlage für den lokalen Dokumentimport ist bereit.',
    'emptyDocumentsDescription':
        'Importiere ein Dokument, um hier den Überblick zu behalten.',
    'selectedDocument': 'Ausgewähltes Dokument',
    'remove': 'Entfernen',
    'startAnalysis': 'Analyse starten',
    'analysisUploading': 'Dokument wird hochgeladen …',
    'analysisStarted': 'Analyse gestartet',
    'processingTitle': 'Analyse läuft',
    'processingDescription':
        'Das kann einen Moment dauern. Du kannst Doxary weiter nutzen.',
    'processingAccepted': 'Dokument hochgeladen',
    'processingWaiting': 'Warten auf die Analyse',
    'continueInBackground': 'Im Hintergrund fortfahren',
    'cancelAnalysis': 'Analyse abbrechen',
    'cancellationUnavailable': 'Abbrechen ist noch nicht verfügbar.',
    'analysisComplete': 'Analyse abgeschlossen',
    'analysisFailed': 'Analyse konnte nicht abgeschlossen werden.',
    'images': 'Bilder',
    'cameraDeferred': 'Kamera wird später unterstützt.',
    'cameraFlash': 'Blitz',
    'cameraPreparing': 'Kamera wird vorbereitet …',
    'cameraPermissionDenied': 'Der Kamerazugriff wurde nicht erlaubt. Du kannst ihn später erneut erlauben.',
    'cameraPermissionSettingsRequired': 'Der Kamerazugriff ist deaktiviert. Aktiviere ihn in den Geräteeinstellungen.',
    'cameraPermissionRestricted':
        'Der Kamerazugriff ist auf diesem Gerät eingeschränkt.',
    'cameraUnavailable': 'Auf diesem Gerät ist keine Kamera verfügbar.',
    'cameraInitializationFailed':
        'Die Kamera konnte nicht gestartet werden. Bitte versuche es erneut.',
    'cameraCaptureStored': 'Aufnahme erstellt',
    'cameraRetake': 'Neu aufnehmen',
    'cameraUsePhoto': 'Foto verwenden',
    'cameraRotate': 'Drehen',
    'cameraRotateFailed': 'Das Foto konnte nicht gedreht werden.',
    'cameraCrop': 'Zuschneiden',
    'cameraCropFailed': 'Das Foto konnte nicht zugeschnitten werden.',
    'cameraAddAnotherPage': 'Weitere Seite',
    'cameraContinue': 'Weiter',
    'cameraPagesForAnalysis': 'Bilder zur Analyse',
    'cameraMaximumPages': 'Maximal 10 Seiten',
    'cameraDiscardPagesTitle': 'Aufnahmen verwerfen?',
    'cameraDiscardPagesMessage':
        'Die aufgenommenen Seiten werden verworfen und nicht analysiert.',
    'cameraKeepEditing': 'Weiter bearbeiten',
    'cameraDiscardPages': 'Verwerfen',
    'cameraCapturedDocument': 'Aufgenommenes Dokument',
    'cameraPage': 'Seite',
    'cameraPages': 'Seiten',
    'cameraManagePages': 'Seiten bearbeiten',
    'cameraReadyForAnalysis': 'Bereit zur Analyse',
    'operationRetryableError': 'Der Dienst ist vorübergehend nicht verfügbar.',
    'operationFailedError': 'Die Analyse konnte nicht abgeschlossen werden.',
    'importError': 'Der Dokumentimport ist fehlgeschlagen.',
  },
  'ar': {
    'appTitle': 'المستندات',
    'home': 'الرئيسية',
    'documents': 'المستندات',
    'importDocument': 'إضافة',
    'addDocumentForAnalysis': 'إضافة مستند للتحليل',
    'captureDocument': 'تصوير مستند',
    'chooseFileOrImage': 'اختيار ملف أو صورة',
    'supportedFormats': 'الصيغ المدعومة: JPG، PNG، PDF',
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
    'overdue': '\u0645\u062a\u0623\u062e\u0631\u0629',
    'taskOverdue': '\u0645\u062a\u0623\u062e\u0631\u0629',
    'completed': 'مكتملة',
    'noTasks': 'لا توجد مهام بعد',
    'taskTitle':
        '\u0639\u0646\u0648\u0627\u0646 \u0627\u0644\u0645\u0647\u0645\u0629',
    'taskTitleRequired': '\u064a\u0631\u062c\u0649 \u0625\u062f\u062e\u0627\u0644 \u0639\u0646\u0648\u0627\u0646 \u0627\u0644\u0645\u0647\u0645\u0629.',
    'date': '\u0627\u0644\u062a\u0627\u0631\u064a\u062e',
    'chooseDate':
        '\u0627\u062e\u062a\u0631 \u0627\u0644\u062a\u0627\u0631\u064a\u062e',
    'dateRequired': '\u064a\u0631\u062c\u0649 \u062a\u062d\u062f\u064a\u062f \u062a\u0627\u0631\u064a\u062e \u0627\u0644\u0627\u0633\u062a\u062d\u0642\u0627\u0642.',
    'time': '\u0627\u0644\u0648\u0642\u062a',
    'chooseTime': '\u0627\u062e\u062a\u0631 \u0627\u0644\u0648\u0642\u062a',
    'timeRequired': '\u062d\u062f\u062f \u0648\u0642\u062a \u0627\u0644\u0645\u0647\u0645\u0629 \u0623\u0648 \u0627\u062e\u062a\u0631 \u0637\u0648\u0627\u0644 \u0627\u0644\u064a\u0648\u0645.',
    'reopenTask': '\u0625\u0639\u0627\u062f\u0629 \u0641\u062a\u062d \u0627\u0644\u0645\u0647\u0645\u0629',
    'camera': 'الكاميرا',
    'image': 'صورة',
    'pdf': 'PDF',
    'importUnavailable': 'لم يتم إعداد استيراد المستندات على هذا الجهاز بعد.',
    'language': 'اللغة',
    'applicationLanguage': 'لغة التطبيق',
    'account': 'الحساب',
    'planAccount': 'الخطة والحساب',
    'notifications': 'الإشعارات',
    'analysisNotifications': 'اكتمال التحليل',
    'taskNotifications': 'المهام والمواعيد',
    'appearance': 'المظهر',
    'darkAppearance': 'المظهر الداكن',
    'appearanceSystem': 'النظام',
    'appearanceLight': 'فاتح',
    'appearanceDark': 'داكن',
    'privacyAndData': 'الخصوصية والبيانات',
    'localDocuments': 'المستندات المحلية',
    'dataManagement': 'إدارة البيانات',
    'legal': 'قانوني',
    'privacyPolicy': 'سياسة الخصوصية',
    'terms': 'شروط الاستخدام',
    'about': 'حول التطبيق',
    'rateApp': 'تقييم التطبيق',
    'shareApp': 'مشاركة التطبيق',
    'shareAppMessage': 'تطبيق بسيط لتنظيم المستندات.',
    'shareUnavailable': 'المشاركة غير متاحة حاليًا.',
    'appVersion': 'الإصدار',
    'versionLoading': 'جارٍ تحميل الإصدار…',
    'versionUnavailable': 'الإصدار غير متاح',
    'rateAppUnavailable': 'لا توجد صفحة متجر بعد',
    'notAvailableYet': 'غير متاح بعد',
    'german': 'الألمانية',
    'arabic': 'العربية',
    'foundationMessage': 'أساس الاستيراد المحلي للمستندات جاهز.',
    'emptyDocumentsDescription': 'استورد مستندًا للاحتفاظ بنظرة عامة هنا.',
    'selectedDocument': 'المستند المحدد',
    'remove': 'إزالة',
    'startAnalysis': 'بدء التحليل',
    'analysisUploading': 'جارٍ رفع المستند …',
    'analysisStarted': 'بدأ التحليل',
    'processingTitle': 'جارٍ تحليل المستند',
    'processingDescription':
        'قد يستغرق ذلك بعض الوقت. يمكنك متابعة استخدام دوكساري.',
    'processingAccepted': 'تم رفع المستند',
    'processingWaiting': 'بانتظار التحليل',
    'continueInBackground': 'المتابعة في الخلفية',
    'cancelAnalysis': 'إلغاء التحليل',
    'cancellationUnavailable': 'الإلغاء غير متاح بعد.',
    'analysisComplete': 'اكتمل التحليل',
    'analysisFailed': 'تعذر إكمال التحليل.',
    'images': 'الصور',
    'cameraDeferred': 'سيتم دعم الكاميرا لاحقًا.',
    'cameraFlash': 'الفلاش',
    'cameraPreparing': 'جارٍ تجهيز الكاميرا …',
    'cameraPermissionDenied':
        'لم يتم السماح بالوصول إلى الكاميرا. يمكنك السماح به لاحقًا.',
    'cameraPermissionSettingsRequired':
        'تم تعطيل الوصول إلى الكاميرا. فعّله من إعدادات الجهاز.',
    'cameraPermissionRestricted': 'الوصول إلى الكاميرا مقيّد على هذا الجهاز.',
    'cameraUnavailable': 'لا تتوفر كاميرا على هذا الجهاز.',
    'cameraInitializationFailed':
        'تعذّر تشغيل الكاميرا. يُرجى المحاولة مرة أخرى.',
    'cameraCaptureStored': 'تم التقاط الصورة',
    'cameraRetake': 'إعادة التصوير',
    'cameraUsePhoto': 'استخدام الصورة',
    'cameraRotate': 'تدوير',
    'cameraRotateFailed': 'تعذّر تدوير الصورة.',
    'cameraCrop': 'اقتصاص',
    'cameraCropFailed': 'تعذّر اقتصاص الصورة.',
    'cameraAddAnotherPage': 'إضافة صفحة أخرى',
    'cameraContinue': 'متابعة',
    'cameraPagesForAnalysis': 'الصور التي سيتم تحليلها',
    'cameraMaximumPages': 'الحد الأقصى 10 صفحات',
    'cameraDiscardPagesTitle': 'حذف الصور الملتقطة؟',
    'cameraDiscardPagesMessage': 'سيتم حذف الصفحات الملتقطة ولن تُرسل للتحليل.',
    'cameraKeepEditing': 'متابعة التعديل',
    'cameraDiscardPages': 'حذف',
    'cameraCapturedDocument': 'مستند ملتقط',
    'cameraPage': 'صفحة',
    'cameraPages': 'صفحات',
    'cameraManagePages': 'تعديل الصفحات',
    'cameraReadyForAnalysis': 'جاهز للتحليل',
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
