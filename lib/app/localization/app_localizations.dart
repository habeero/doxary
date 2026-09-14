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
  String _value(String key) =>
      (_strings[locale.languageCode] ?? _strings['de']!)[key]!;
}

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
