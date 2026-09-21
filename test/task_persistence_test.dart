import 'package:drift/native.dart';
import 'package:doxary/core/database/app_database.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:doxary/features/tasks/data/repositories/local_task_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Task persistence keeps form metadata, completion, and deletion',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await database.customStatement('PRAGMA foreign_keys = OFF');
      final repository = LocalTaskRepository(database);
      final createdAt = DateTime(2026, 9, 21, 9);
      const id = 'task-1';

      await repository.save(
        LocalTask(
          id: id,
          title: 'Reply',
          status: TaskStatus.open,
          provenance: TaskProvenance.user,
          createdAt: createdAt,
          updatedAt: createdAt,
          dueAt: DateTime(2026, 9, 25),
          allDay: false,
          dueTimeMinutes: 9 * 60,
          reminderMinutesBefore: 1440,
          note: 'Bring documents',
          clientDocumentId: 'document-1',
          caseId: 'case-1',
          sourceAnalysisId: 'analysis-1',
          sourceActionKey: 'suggested-task:0',
        ),
      );

      final saved = await repository.getById(id);
      expect(saved?.id, id);
      expect(saved?.dueTimeMinutes, 540);
      expect(saved?.reminderMinutesBefore, 1440);
      expect(saved?.note, 'Bring documents');
      expect(saved?.clientDocumentId, 'document-1');
      expect(saved?.caseId, 'case-1');
      expect(saved?.sourceAnalysisId, 'analysis-1');
      expect(saved?.sourceActionKey, 'suggested-task:0');
      expect(
        (await repository.findBySourceAction(
          'analysis-1',
          'suggested-task:0',
        ))?.id,
        id,
      );

      await repository.save(
        LocalTask(
          id: id,
          title: 'Reply',
          status: TaskStatus.open,
          provenance: TaskProvenance.user,
          createdAt: createdAt,
          updatedAt: createdAt,
          dueAt: DateTime(2026, 9, 25),
          allDay: true,
          dueTimeMinutes: null,
          reminderMinutesBefore: 1440,
          note: 'Bring documents',
          clientDocumentId: 'document-1',
          caseId: 'case-1',
          sourceAnalysisId: 'analysis-1',
          sourceActionKey: 'suggested-task:0',
        ),
      );
      final allDay = await repository.getById(id);
      expect(allDay?.allDay, isTrue);
      expect(allDay?.dueTimeMinutes, isNull);

      await repository.updateStatus(id, TaskStatus.completed, createdAt);
      expect((await repository.getById(id))?.status, TaskStatus.completed);
      await repository.updateStatus(id, TaskStatus.open, createdAt);
      final reopened = await repository.getById(id);
      expect(reopened?.status, TaskStatus.open);
      expect(reopened?.id, id);
      expect(reopened?.dueAt, DateTime(2026, 9, 25));
      expect(reopened?.allDay, isTrue);
      expect(reopened?.dueTimeMinutes, isNull);
      expect(reopened?.reminderMinutesBefore, 1440);
      expect(reopened?.note, 'Bring documents');
      expect(reopened?.clientDocumentId, 'document-1');
      expect(reopened?.caseId, 'case-1');
      await repository.delete(id);
      expect(await repository.getById(id), isNull);
    },
  );
}
