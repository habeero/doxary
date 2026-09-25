import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/app_database.dart'
    hide Case, DocumentFile, Organization;
import '../core/config/doxary_api_config.dart';
import '../core/network/doxary_api_client.dart';
import '../core/notifications/reminder_scheduler.dart';
import '../core/notifications/local_reminder_scheduler.dart';
import '../core/notifications/local_task_notification_identity_store.dart';
import '../core/notifications/task_notification_identity_store.dart';
import '../core/utils/id_generator.dart';
import '../features/cases/data/repositories/local_case_repository.dart';
import '../features/cases/domain/repositories/case_repository.dart';
import '../features/document_import/domain/document_import.dart';
import '../features/document_import/data/file_picker_document_import_gateway.dart';
import '../features/document_import/data/camera_capture_gateway.dart';
import '../features/document_analysis/application/analysis_workflow.dart';
import '../features/document_analysis/application/document_attention.dart';
import '../features/document_analysis/data/doxary_document_analysis_remote_data_source.dart';
import '../features/document_analysis/data/local_analysis_repository.dart';
import '../features/document_analysis/domain/analysis_repository.dart';
import '../features/document_analysis/domain/analysis_output_language.dart';
import '../features/document_analysis/domain/analysis_submission.dart';
import '../features/documents/data/repositories/local_document_repository.dart';
import '../features/documents/data/source_document_opener.dart';
import '../features/documents/domain/entities/domain_entities.dart';
import '../features/documents/domain/repositories/document_repository.dart';
import '../features/documents/domain/source_document_opener.dart';
import '../features/monetization/domain/entitlement_service.dart';
import '../features/organizations/data/repositories/local_organization_repository.dart';
import '../features/organizations/domain/repositories/organization_repository.dart';
import '../features/settings/data/repositories/local_settings_repository.dart';
import '../features/settings/domain/settings_repository.dart';
import '../features/tasks/data/repositories/local_task_repository.dart';
import '../features/tasks/domain/repositories/task_repository.dart';
import '../features/tasks/application/task_reminder_reconciler.dart';
import '../features/tasks/application/task_lifecycle.dart';

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
final sourceDocumentOpenerProvider = Provider<SourceDocumentOpener>(
  (ref) => LocalSourceDocumentOpener(),
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
final currentTimeProvider = Provider<DateTime>((ref) => DateTime.now());
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
final analysisByIdProvider = FutureProvider.family<DocumentAnalysis?, String>(
  (ref, analysisId) =>
      ref.watch(analysisRepositoryProvider).getById(analysisId),
);
final analysisHistoryProvider =
    FutureProvider.family<List<AnalysisAttempt>, String>(
      (ref, clientDocumentId) =>
          ref.watch(analysisRepositoryProvider).getHistory(clientDocumentId),
    );
final analysisWorkflowProvider = Provider<AnalysisWorkflow>(
  (ref) => AnalysisWorkflow(
    ref.watch(analysisRemoteDataSourceProvider),
    ref.watch(analysisRepositoryProvider),
  ),
);
final activeAnalysisOperationsProvider =
    StreamProvider<List<PendingAnalysisOperation>>(
      (ref) => ref.watch(analysisRepositoryProvider).watchPending(),
    );
final resumePendingAnalysesProvider = FutureProvider<void>(
  (ref) => ref.read(analysisWorkflowProvider).resumePending(),
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
final cameraCaptureGatewayProvider = Provider<CameraCaptureGateway>(
  (ref) => DeviceCameraCaptureGateway(),
);
final reminderSchedulerProvider = Provider<ReminderScheduler>(
  (ref) =>
      LocalReminderScheduler(ref.watch(taskNotificationIdentityStoreProvider)),
);
final taskNotificationIdentityStoreProvider =
    Provider<TaskNotificationIdentityStore>(
      (ref) => LocalTaskNotificationIdentityStore(ref.watch(databaseProvider)),
    );
final taskReminderReconcilerProvider = Provider<TaskReminderReconciler>(
  (ref) => TaskReminderReconciler(ref.watch(reminderSchedulerProvider)),
);
final taskLifecycleProvider = Provider<TaskLifecycle>(
  (ref) => TaskLifecycle(
    ref.watch(taskRepositoryProvider),
    ref.watch(taskReminderReconcilerProvider),
  ),
);
final entitlementServiceProvider = Provider<EntitlementService>(
  (ref) => DevelopmentEntitlementService(),
);
final recentDocumentsProvider = StreamProvider<List<LocalDocument>>(
  (ref) => ref.watch(documentRepositoryProvider).watchRecent(),
);
final homeDocumentsProvider = StreamProvider<List<LocalDocument>>(
  (ref) => ref.watch(documentRepositoryProvider).watchAll(),
);
final allDocumentsProvider = StreamProvider<List<LocalDocument>>(
  (ref) => ref.watch(documentRepositoryProvider).watchAll(),
);
final documentAnalysisBrowseStatesProvider =
    StreamProvider<Map<String, DocumentAnalysisBrowseState>>((ref) {
      final database = ref.watch(databaseProvider);
      final query = database.customSelect(
        '''SELECT document.client_document_id AS client_document_id,
                  GROUP_CONCAT(DISTINCT analysis.analysis_status) AS analysis_statuses,
                  MAX(CASE WHEN attempt.status = 'failed'
                    THEN COALESCE(attempt.terminal_at, attempt.started_at)
                    ELSE NULL END) AS latest_failure_at,
                  MAX(CASE WHEN attempt.deleted_at IS NOT NULL
                    THEN attempt.deleted_at ELSE NULL END) AS latest_deletion_at,
                  CASE WHEN document.status = 'processing' OR EXISTS (
                    SELECT 1 FROM analysis_operations AS operation
                    WHERE operation.client_document_id = document.client_document_id
                      AND operation.state IN ('accepted', 'processing')
                  ) THEN 1 ELSE 0 END AS is_processing
           FROM documents AS document
           LEFT JOIN analyses AS analysis
             ON analysis.client_document_id = document.client_document_id
           LEFT JOIN analysis_attempt_history AS attempt
             ON attempt.client_document_id = document.client_document_id
           WHERE document.status != 'deleted'
           GROUP BY document.client_document_id, document.status''',
        readsFrom: {
          database.documents,
          database.analyses,
          database.analysisOperations,
        },
      );
      return query.watch().map((rows) {
        return {
          for (final row in rows)
            row.read<String>(
              'client_document_id',
            ): resolveDocumentAnalysisBrowseState(
              currentAnalysisStatuses:
                  (row.readNullable<String>('analysis_statuses') ?? '')
                      .split(',')
                      .where((status) => status.isNotEmpty)
                      .map(AnalysisStatus.values.byName),
              isProcessing: row.read<int>('is_processing') == 1,
              latestFailureAt: _browseTimeOrNull(
                row.readNullable<int>('latest_failure_at'),
              ),
              latestDeletionAt: _browseTimeOrNull(
                row.readNullable<int>('latest_deletion_at'),
              ),
            ),
        };
      });
    });
final documentProvider = FutureProvider.family<LocalDocument?, String>(
  (ref, clientDocumentId) =>
      ref.watch(documentRepositoryProvider).getById(clientDocumentId),
);
final documentFilesProvider = FutureProvider.family<List<DocumentFile>, String>(
  (ref, clientDocumentId) =>
      ref.watch(documentRepositoryProvider).getFiles(clientDocumentId),
);
final organizationsProvider = StreamProvider<List<Organization>>(
  (ref) => ref.watch(organizationRepositoryProvider).watchAll(),
);
final casesProvider = StreamProvider<List<Case>>(
  (ref) => ref.watch(caseRepositoryProvider).watchAll(),
);
final openTasksProvider = StreamProvider<List<LocalTask>>(
  (ref) => ref.watch(taskRepositoryProvider).watchOpen(),
);
final completedTasksProvider = StreamProvider<List<LocalTask>>(
  (ref) => ref.watch(taskRepositoryProvider).watchCompleted(),
);
final taskProvider = FutureProvider.family<LocalTask?, String>(
  (ref, taskId) => ref.watch(taskRepositoryProvider).getById(taskId),
);
final taskForSourceActionProvider =
    FutureProvider.family<LocalTask?, ({String analysisId, String actionKey})>(
      (ref, source) => ref
          .watch(taskRepositoryProvider)
          .findBySourceAction(source.analysisId, source.actionKey),
    );

DateTime? _browseTimeOrNull(int? milliseconds) => milliseconds == null
    ? null
    : DateTime.fromMillisecondsSinceEpoch(milliseconds);

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
