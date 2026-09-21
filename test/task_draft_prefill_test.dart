import 'package:doxary/app/localization/app_localizations.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:doxary/features/tasks/presentation/task_draft_prefill.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = AppLocalizations(const Locale('de'));

  test('suggested task is the deterministic primary task prefill', () {
    final prefill = TaskDraftPrefill.fromAnalysis(
      analysis: _analysis(
        suggestedTasks: const [
          AnalysisSuggestedTask(
            title: 'Pay the invoice',
            confidence: 0.9,
            dueDate: '2026-10-14',
            instructions: 'Use the reference on the invoice.',
          ),
        ],
        nextActions: const ['Reply to the letter'],
      ),
      clientDocumentId: 'document-id',
      caseId: 'case-id',
      l10n: l10n,
    );

    expect(prefill?.title, 'Pay the invoice');
    expect(prefill?.dueDate, DateTime(2026, 10, 14));
    expect(prefill?.allDay, isTrue);
    expect(prefill?.dueTimeMinutes, isNull);
    expect(prefill?.clientDocumentId, 'document-id');
    expect(prefill?.caseId, 'case-id');
    expect(prefill?.note, contains('Use the reference'));
  });

  test('deadline and appointment prefill dates without inventing time', () {
    final deadlinePrefill = TaskDraftPrefill.fromAnalysis(
      analysis: _analysis(
        deadlines: const [
          AnalysisDeadline(
            label: 'Reply by',
            dateOrRange: '2026-11-01',
            confidence: 0.9,
          ),
        ],
      ),
      clientDocumentId: 'document-id',
      caseId: null,
      l10n: l10n,
    );
    final appointmentPrefill = TaskDraftPrefill.fromAnalysis(
      analysis: _analysis(
        appointments: const [
          AnalysisAppointment(
            label: 'Appointment',
            startOrDate: '2026-12-02T13:45:00',
            confidence: 0.9,
          ),
        ],
      ),
      clientDocumentId: 'document-id',
      caseId: null,
      l10n: l10n,
    );

    expect(deadlinePrefill?.dueDate, DateTime(2026, 11, 1));
    expect(deadlinePrefill?.allDay, isTrue);
    expect(deadlinePrefill?.dueTimeMinutes, isNull);
    expect(appointmentPrefill?.dueDate, DateTime(2026, 12, 2));
    expect(appointmentPrefill?.allDay, isFalse);
    expect(appointmentPrefill?.dueTimeMinutes, 13 * 60 + 45);
  });

  test('no-action and uncertain results do not offer a fabricated task', () {
    for (final action in [ActionRequirement.no, ActionRequirement.uncertain]) {
      expect(
        TaskDraftPrefill.fromAnalysis(
          analysis: _analysis(
            actionRequired: action,
            suggestedTasks: const [
              AnalysisSuggestedTask(title: 'Pay the invoice', confidence: 0.9),
            ],
          ),
          clientDocumentId: 'document-id',
          caseId: null,
          l10n: l10n,
        ),
        isNull,
      );
    }
  });
}

DocumentAnalysis _analysis({
  ActionRequirement actionRequired = ActionRequirement.yes,
  List<AnalysisSuggestedTask> suggestedTasks = const [],
  List<String> nextActions = const [],
  List<AnalysisDeadline> deadlines = const [],
  List<AnalysisAppointment> appointments = const [],
}) => DocumentAnalysis(
  id: 'analysis',
  clientDocumentId: 'document-id',
  schemaVersion: 'analysis_result.v1',
  targetLanguage: 'de',
  createdAt: DateTime(2026),
  actionRequired: actionRequired,
  suggestedTasks: suggestedTasks,
  nextActions: nextActions,
  deadlines: deadlines,
  appointments: appointments,
);
