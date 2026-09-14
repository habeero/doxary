import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/database/app_database.dart';
import '../core/notifications/reminder_scheduler.dart';
import '../core/utils/id_generator.dart';
import '../features/cases/data/repositories/local_case_repository.dart';
import '../features/cases/domain/repositories/case_repository.dart';
import '../features/document_import/domain/document_import.dart';
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
  (ref) => UnavailableDocumentImportGateway(),
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

class LanguageController extends Notifier<Locale?> {
  @override
  Locale? build() {
    _restore();
    return null;
  }

  Future<void> _restore() async {
    final code = await ref.read(settingsRepositoryProvider).read('ui_language');
    if (code == 'de' || code == 'ar') {
      state = Locale(code!);
    }
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    if (locale != null) {
      await ref
          .read(settingsRepositoryProvider)
          .write('ui_language', locale.languageCode);
    }
  }
}

final languageProvider = NotifierProvider<LanguageController, Locale?>(
  LanguageController.new,
);
