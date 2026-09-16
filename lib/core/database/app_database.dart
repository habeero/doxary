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
  TextColumn get explanationStyle =>
      text().withDefault(const Constant('standard'))();
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
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
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
    },
  );
}

LazyDatabase _openConnection() => LazyDatabase(() async {
  final directory = await getApplicationSupportDirectory();
  final file = File(path.join(directory.path, 'document_assistant.sqlite'));
  return NativeDatabase.createInBackground(file);
});
