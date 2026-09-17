import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/app_database.dart';
import '../core/config/doxary_api_config.dart';
import '../core/network/doxary_api_client.dart';
import '../core/notifications/reminder_scheduler.dart';
import '../core/utils/id_generator.dart';
import '../features/cases/data/repositories/local_case_repository.dart';
import '../features/cases/domain/repositories/case_repository.dart';
import '../features/document_import/domain/document_import.dart';
import '../features/document_import/data/file_picker_document_import_gateway.dart';
import '../features/document_analysis/application/analysis_workflow.dart';
import '../features/document_analysis/data/doxary_document_analysis_remote_data_source.dart';
import '../features/document_analysis/data/local_analysis_repository.dart';
import '../features/document_analysis/domain/analysis_repository.dart';
import '../features/document_analysis/domain/analysis_output_language.dart';
import '../features/document_analysis/domain/analysis_submission.dart';
import '../features/documents/data/repositories/local_document_repository.dart';
import '../features/documents/domain/entities/domain_entities.dart';
import '../features/documents/domain/repositories/document_repository.dart';
import '../features/monetization/domain/entitlement_service.dart';
import '../features/organizations/data/repositories/local_organization_repository.dart';
import '../features/organizations/domain/repositories/organization_repository.dart';
import '../features/settings/data/repositories/local_settings_repository.dart';
import '../features/settings/domain/settings_repository.dart';
import '../features/tasks/data/repositories/local_task_repository.dart';
import '../features/tasks/domain/repositories/task_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});
final idGeneratorProvider = Provider<IdGenerator>(
  (ref) => const UuidIdGenerator(),
);
final documentRepositoryProvider = Provider<DocumentRepository>(
  (ref) => LocalDocumentRepository(ref.watch(databaseProvider)),
);
final apiConfigProvider = Provider<DoxaryApiConfig>(
  (ref) => DoxaryApiConfig.fromEnvironment(),
);
final apiClientProvider = Provider<DoxaryApiClient>((ref) {
  final client = DoxaryApiClient(ref.watch(apiConfigProvider));
  ref.onDispose(client.close);
  return client;
});
final deviceLocaleProvider = Provider<Locale>(
  (ref) => WidgetsBinding.instance.platformDispatcher.locale,
);
final analysisRemoteDataSourceProvider =
    Provider<DocumentAnalysisRemoteDataSource>(
      (ref) =>
          DoxaryDocumentAnalysisRemoteDataSource(ref.watch(apiClientProvider)),
    );
final analysisRepositoryProvider = Provider<AnalysisRepository>(
  (ref) => LocalAnalysisRepository(ref.watch(databaseProvider)),
);
final latestAnalysisProvider = FutureProvider.family<DocumentAnalysis?, String>(
  (ref, clientDocumentId) =>
      ref.watch(analysisRepositoryProvider).getLatest(clientDocumentId),
);
final analysisWorkflowProvider = Provider<AnalysisWorkflow>(
  (ref) => AnalysisWorkflow(
    ref.watch(analysisRemoteDataSourceProvider),
    ref.watch(analysisRepositoryProvider),
  ),
);
final organizationRepositoryProvider = Provider<OrganizationRepository>(
  (ref) => LocalOrganizationRepository(ref.watch(databaseProvider)),
);
final caseRepositoryProvider = Provider<CaseRepository>(
  (ref) => LocalCaseRepository(ref.watch(databaseProvider)),
);
final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => LocalTaskRepository(ref.watch(databaseProvider)),
);
final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => LocalSettingsRepository(ref.watch(databaseProvider)),
);
final importGatewayProvider = Provider<DocumentImportGateway>(
  (ref) => FilePickerDocumentImportGateway(),
);
final reminderSchedulerProvider = Provider<ReminderScheduler>(
  (ref) => UnavailableReminderScheduler(),
);
final entitlementServiceProvider = Provider<EntitlementService>(
  (ref) => DevelopmentEntitlementService(),
);
final recentDocumentsProvider = StreamProvider<List<LocalDocument>>(
  (ref) => ref.watch(documentRepositoryProvider).watchRecent(),
);
final openTasksProvider = StreamProvider<List<LocalTask>>(
  (ref) => ref.watch(taskRepositoryProvider).watchOpen(),
);
final completedTasksProvider = StreamProvider<List<LocalTask>>(
  (ref) => ref.watch(taskRepositoryProvider).watchCompleted(),
);

Locale defaultUiLocaleForDevice(Locale deviceLocale) =>
    deviceLocale.languageCode == 'ar' ? const Locale('ar') : const Locale('de');

class LanguageController extends Notifier<Locale> {
  bool _explicitlySelected = false;

  @override
  Locale build() {
    final deviceLocale = ref.watch(deviceLocaleProvider);
    _restore();
    return defaultUiLocaleForDevice(deviceLocale);
  }

  Future<void> _restore() async {
    final code = await ref.read(settingsRepositoryProvider).read('ui_language');
    if ((code == 'de' || code == 'ar') && !_explicitlySelected) {
      state = Locale(code!);
    }
  }

  Future<void> setLocale(Locale locale) async {
    _explicitlySelected = true;
    state = locale;
    await ref
        .read(settingsRepositoryProvider)
        .write('ui_language', locale.languageCode);
  }
}

final languageProvider = NotifierProvider<LanguageController, Locale>(
  LanguageController.new,
);

class AnalysisLanguageController extends Notifier<AnalysisOutputLanguage> {
  bool _explicitlySelected = false;
  bool _hasPersistedSelection = false;

  @override
  AnalysisOutputLanguage build() {
    final uiLocale = ref.read(languageProvider);
    ref.listen<Locale>(languageProvider, (_, next) {
      if (!_explicitlySelected && !_hasPersistedSelection) {
        state = next.languageCode == 'ar'
            ? AnalysisOutputLanguage.arabic
            : AnalysisOutputLanguage.simpleGerman;
      }
    });
    _restore();
    return uiLocale.languageCode == 'ar'
        ? AnalysisOutputLanguage.arabic
        : AnalysisOutputLanguage.simpleGerman;
  }

  Future<void> _restore() async {
    final value = analysisOutputLanguageFromSetting(
      await ref.read(settingsRepositoryProvider).read('analysis_language'),
    );
    if (value != null) {
      _hasPersistedSelection = true;
      if (!_explicitlySelected) state = value;
    }
  }

  Future<void> setLanguage(AnalysisOutputLanguage language) async {
    _explicitlySelected = true;
    state = language;
    await ref
        .read(settingsRepositoryProvider)
        .write('analysis_language', language.settingValue);
  }
}

final analysisLanguageProvider =
    NotifierProvider<AnalysisLanguageController, AnalysisOutputLanguage>(
      AnalysisLanguageController.new,
    );
