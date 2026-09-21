import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Organizations extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Cases extends Table {
  TextColumn get id => text()();
  TextColumn get organizationId => text().references(Organizations, #id)();
  TextColumn get title => text()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Documents extends Table {
  TextColumn get clientDocumentId => text()();
  TextColumn get organizationId =>
      text().nullable().references(Organizations, #id)();
  TextColumn get caseId => text().nullable().references(Cases, #id)();
  TextColumn get classificationState => text()();
  TextColumn get status => text()();
  DateTimeColumn get documentDate => dateTime().nullable()();
  TextColumn get sourceLanguage => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {clientDocumentId};
}

class DocumentFiles extends Table {
  TextColumn get id => text()();
  TextColumn get clientDocumentId =>
      text().references(Documents, #clientDocumentId)();
  TextColumn get localUri => text()();
  TextColumn get mediaType => text()();
  TextColumn get originalFilename => text().nullable()();
  IntColumn get byteSize => integer().nullable()();
  DateTimeColumn get importedAt => dateTime()();
  IntColumn get pageOrder => integer().withDefault(const Constant(0))();
  TextColumn get importSource =>
      text().withDefault(const Constant('filePicker'))();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Analyses extends Table {
  TextColumn get id => text()();
  TextColumn get clientDocumentId =>
      text().references(Documents, #clientDocumentId)();
  TextColumn get schemaVersion => text()();
  TextColumn get targetLanguage => text()();
  TextColumn get summary => text().nullable()();
  TextColumn get explanation => text().nullable()();
  TextColumn get state => text()();
  TextColumn get analysisStatus =>
      text().withDefault(const Constant('complete'))();
  TextColumn get actionRequired => text().nullable()();
  TextColumn get documentDate => text().nullable()();
  TextColumn get detectedLanguage =>
      text().withDefault(const Constant('undetermined'))();
  TextColumn get urgency => text().withDefault(const Constant('uncertain'))();
  RealColumn get confidence => real().nullable()();
  TextColumn get explanationStyle =>
      text().withDefault(const Constant('standard'))();
  // Classification is analysis provenance, not a confirmed document relation.
  TextColumn get suggestedOrganizationName => text().nullable()();
  TextColumn get suggestedDocumentType => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AnalysisQualityReasons extends Table {
  TextColumn get id => text()();
  TextColumn get analysisId => text().references(Analyses, #id)();
  TextColumn get reason => text()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AnalysisNextActions extends Table {
  TextColumn get id => text()();
  TextColumn get analysisId => text().references(Analyses, #id)();
  IntColumn get position => integer()();
  TextColumn get value => text()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AnalysisUncertainties extends Table {
  TextColumn get id => text()();
  TextColumn get analysisId => text().references(Analyses, #id)();
  IntColumn get position => integer()();
  TextColumn get message => text()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AnalysisPracticalStates extends Table {
  TextColumn get id => text()();
  TextColumn get analysisId => text().references(Analyses, #id)();
  IntColumn get position => integer()();
  TextColumn get state => text()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AnalysisDeadlines extends Table {
  TextColumn get id => text()();
  TextColumn get analysisId => text().references(Analyses, #id)();
  IntColumn get position => integer()();
  TextColumn get label => text()();
  TextColumn get dateOrRange => text().nullable()();
  RealColumn get confidence => real().nullable()();
  TextColumn get time => text().nullable()();
  TextColumn get timezone => text().nullable()();
  TextColumn get consequence => text().nullable()();
  TextColumn get sourceReference => text().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AnalysisAppointments extends Table {
  TextColumn get id => text()();
  TextColumn get analysisId => text().references(Analyses, #id)();
  IntColumn get position => integer()();
  TextColumn get label => text()();
  TextColumn get startOrDate => text().nullable()();
  RealColumn get confidence => real().nullable()();
  TextColumn get end => text().nullable()();
  TextColumn get location => text().nullable()();
  TextColumn get preparation => text().nullable()();
  TextColumn get sourceReference => text().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AnalysisAmounts extends Table {
  TextColumn get id => text()();
  TextColumn get analysisId => text().references(Analyses, #id)();
  IntColumn get position => integer()();
  TextColumn get value => text()();
  TextColumn get currency => text()();
  TextColumn get direction => text()();
  RealColumn get confidence => real().nullable()();
  TextColumn get dueDate => text().nullable()();
  TextColumn get purpose => text().nullable()();
  TextColumn get sourceReference => text().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AnalysisRequiredDocuments extends Table {
  TextColumn get id => text()();
  TextColumn get analysisId => text().references(Analyses, #id)();
  IntColumn get position => integer()();
  TextColumn get description => text()();
  RealColumn get confidence => real().nullable()();
  TextColumn get dueDate => text().nullable()();
  TextColumn get submissionMethod => text().nullable()();
  TextColumn get sourceReference => text().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AnalysisSuggestedTasks extends Table {
  TextColumn get id => text()();
  TextColumn get analysisId => text().references(Analyses, #id)();
  IntColumn get position => integer()();
  TextColumn get title => text()();
  RealColumn get confidence => real().nullable()();
  TextColumn get dueDate => text().nullable()();
  TextColumn get instructions => text().nullable()();
  TextColumn get sourceReference => text().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SourceReferences extends Table {
  TextColumn get id => text()();
  TextColumn get analysisId => text().references(Analyses, #id)();
  TextColumn get clientDocumentId =>
      text().references(Documents, #clientDocumentId)();
  TextColumn get fileId => text().nullable().references(DocumentFiles, #id)();
  IntColumn get pageNumber => integer().nullable()();
  TextColumn get excerptLabel => text().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get clientDocumentId =>
      text().nullable().references(Documents, #clientDocumentId)();
  TextColumn get caseId => text().nullable().references(Cases, #id)();
  TextColumn get title => text()();
  DateTimeColumn get dueAt => dateTime().nullable()();
  BoolColumn get allDay => boolean().withDefault(const Constant(false))();
  IntColumn get dueTimeMinutes => integer().nullable()();
  IntColumn get reminderMinutesBefore => integer().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get status => text()();
  TextColumn get provenance => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Deadlines extends Table {
  TextColumn get id => text()();
  TextColumn get clientDocumentId =>
      text().references(Documents, #clientDocumentId)();
  TextColumn get label => text()();
  DateTimeColumn get dueAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Appointments extends Table {
  TextColumn get id => text()();
  TextColumn get clientDocumentId =>
      text().references(Documents, #clientDocumentId)();
  TextColumn get label => text()();
  DateTimeColumn get startsAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Amounts extends Table {
  TextColumn get id => text()();
  TextColumn get clientDocumentId =>
      text().references(Documents, #clientDocumentId)();
  IntColumn get valueInCents => integer()();
  TextColumn get currency => text()();
  TextColumn get direction => text()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class RequiredDocuments extends Table {
  TextColumn get id => text()();
  TextColumn get clientDocumentId =>
      text().references(Documents, #clientDocumentId)();
  TextColumn get description => text()();
  TextColumn get status => text().withDefault(const Constant('requested'))();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Durable client-owned metadata for a pending backend operation. It is not a
/// server document identity and permits polling to resume after app restart.
class AnalysisOperations extends Table {
  TextColumn get operationId => text()();
  TextColumn get clientDocumentId =>
      text().references(Documents, #clientDocumentId)();
  TextColumn get state => text()();
  TextColumn get lastFailureCode => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {operationId};
}

class UserSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    Organizations,
    Cases,
    Documents,
    DocumentFiles,
    Analyses,
    AnalysisQualityReasons,
    AnalysisNextActions,
    AnalysisUncertainties,
    AnalysisPracticalStates,
    AnalysisDeadlines,
    AnalysisAppointments,
    AnalysisAmounts,
    AnalysisRequiredDocuments,
    AnalysisSuggestedTasks,
    SourceReferences,
    Tasks,
    Deadlines,
    Appointments,
    Amounts,
    RequiredDocuments,
    AnalysisOperations,
    UserSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // The generated table definition remains compatible with earlier
      // clients; create the v7 task metadata columns explicitly as well.
      await _addTaskFormColumns();
      await _addTaskProvenanceColumns();
      await _createTaskSourceActionIndex();
      await _createTaskNotificationIds();
      await _createAnalysisAttemptHistory();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(documentFiles, documentFiles.pageOrder);
        await m.addColumn(documentFiles, documentFiles.importSource);
        await m.addColumn(analyses, analyses.analysisStatus);
        await m.addColumn(analyses, analyses.explanationStyle);
        await m.createTable(analysisQualityReasons);
        await m.createTable(sourceReferences);
      }
      if (from < 3) {
        await m.createTable(analysisOperations);
      }
      if (from < 4) {
        await m.addColumn(analyses, analyses.suggestedOrganizationName);
        await m.addColumn(analyses, analyses.suggestedDocumentType);
      }
      if (from < 5) {
        await m.addColumn(analyses, analyses.actionRequired);
      }
      if (from < 6) {
        await m.addColumn(analyses, analyses.documentDate);
        await m.addColumn(analyses, analyses.detectedLanguage);
        await m.addColumn(analyses, analyses.urgency);
        await m.addColumn(analyses, analyses.confidence);
        await m.createTable(analysisNextActions);
        await m.createTable(analysisUncertainties);
        await m.createTable(analysisPracticalStates);
        await m.createTable(analysisDeadlines);
        await m.createTable(analysisAppointments);
        await m.createTable(analysisAmounts);
        await m.createTable(analysisRequiredDocuments);
        await m.createTable(analysisSuggestedTasks);
      }
      if (from < 7) {
        await _addTaskFormColumns();
      }
      if (from < 8) {
        await _addTaskProvenanceColumns();
        await _createTaskSourceActionIndex();
        await _createAnalysisAttemptHistory();
        await _backfillAnalysisAttemptHistory();
      }
      if (from < 9) {
        await _createTaskNotificationIds();
      }
    },
  );

  Future<void> _addTaskFormColumns() async {
    await customStatement(
      'ALTER TABLE tasks ADD COLUMN all_day INTEGER NOT NULL DEFAULT 0',
    );
    await customStatement(
      'ALTER TABLE tasks ADD COLUMN due_time_minutes INTEGER',
    );
    await customStatement(
      'ALTER TABLE tasks ADD COLUMN reminder_minutes_before INTEGER',
    );
    await customStatement('ALTER TABLE tasks ADD COLUMN note TEXT');
  }

  Future<void> _addTaskProvenanceColumns() async {
    await customStatement(
      'ALTER TABLE tasks ADD COLUMN source_analysis_id TEXT',
    );
    await customStatement(
      'ALTER TABLE tasks ADD COLUMN source_action_key TEXT',
    );
  }

  Future<void> _createTaskSourceActionIndex() => customStatement('''
    CREATE UNIQUE INDEX IF NOT EXISTS task_source_action_unique
    ON tasks (source_analysis_id, source_action_key)
    WHERE source_analysis_id IS NOT NULL AND source_action_key IS NOT NULL
  ''');

  Future<void> _createTaskNotificationIds() => customStatement('''
    CREATE TABLE IF NOT EXISTS task_notification_ids (
      task_id TEXT PRIMARY KEY NOT NULL,
      notification_id INTEGER NOT NULL UNIQUE
    )
  ''');

  Future<void> _createAnalysisAttemptHistory() => customStatement('''
    CREATE TABLE IF NOT EXISTS analysis_attempt_history (
      attempt_id TEXT PRIMARY KEY NOT NULL,
      client_document_id TEXT NOT NULL,
      started_at INTEGER NOT NULL,
      terminal_at INTEGER,
      status TEXT NOT NULL,
      result_analysis_id TEXT,
      failure_code TEXT,
      retryable INTEGER
    )
  ''');

  Future<void> _backfillAnalysisAttemptHistory() async {
    await customStatement('''
      INSERT OR IGNORE INTO analysis_attempt_history (
        attempt_id, client_document_id, started_at, terminal_at, status,
        result_analysis_id, failure_code, retryable
      )
      SELECT 'analysis:' || id, client_document_id,
        created_at, created_at,
        'succeeded', id, NULL, NULL
      FROM analyses
    ''');
    await customStatement('''
      INSERT OR IGNORE INTO analysis_attempt_history (
        attempt_id, client_document_id, started_at, terminal_at, status,
        result_analysis_id, failure_code, retryable
      )
      SELECT 'operation:' || operation_id, client_document_id,
        created_at, updated_at,
        CASE WHEN state IN ('failed', 'expired') THEN 'failed' ELSE 'pending' END,
        NULL, last_failure_code, NULL
      FROM analysis_operations
    ''');
  }
}

LazyDatabase _openConnection() => LazyDatabase(() async {
  final directory = await getApplicationSupportDirectory();
  final file = File(path.join(directory.path, 'document_assistant.sqlite'));
  return NativeDatabase.createInBackground(file);
});
