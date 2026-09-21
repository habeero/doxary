import '../../../app/localization/app_localizations.dart';
import '../../documents/domain/entities/domain_entities.dart';

/// In-memory values supplied when a Result starts the existing Task editor.
///
/// This is deliberately not persisted: the editor remains the confirmation
/// boundary where the user can change or abandon every suggested value.
class TaskDraftPrefill {
  const TaskDraftPrefill({
    required this.title,
    required this.allDay,
    this.dueDate,
    this.dueTimeMinutes,
    this.note,
    this.clientDocumentId,
    this.caseId,
    this.sourceAnalysisId,
    this.sourceActionKey,
  });

  final String title;
  final DateTime? dueDate;
  final int? dueTimeMinutes;
  final bool allDay;
  final String? note;
  final String? clientDocumentId;
  final String? caseId;
  final String? sourceAnalysisId;
  final String? sourceActionKey;

  static TaskDraftPrefill? fromAnalysis({
    required DocumentAnalysis analysis,
    required String clientDocumentId,
    required String? caseId,
    required AppLocalizations l10n,
  }) {
    if (analysis.actionRequired != ActionRequirement.yes) {
      return null;
    }

    final suggestedTask = _firstSuggestedTask(analysis.suggestedTasks);
    final nextAction = _firstMeaningful(analysis.nextActions);
    final requiredDocument = _firstRequiredDocument(analysis.requiredDocuments);
    final title =
        suggestedTask?.title.trim() ??
        nextAction ??
        _meaningful(l10n.actionRequiredBody) ??
        l10n.followUpDocument;

    final dateTime =
        _parseDateTime(suggestedTask?.dueDate) ??
        _firstDeadlineDateTime(analysis.deadlines) ??
        _firstAppointmentDateTime(analysis.appointments);
    final note = _note(
      suggestedTask: suggestedTask,
      requiredDocument: requiredDocument,
    );
    return TaskDraftPrefill(
      title: title,
      dueDate: dateTime?.date,
      dueTimeMinutes: dateTime?.timeMinutes,
      allDay: dateTime != null && dateTime.timeMinutes == null,
      note: note,
      clientDocumentId: clientDocumentId,
      caseId: caseId,
      sourceAnalysisId: analysis.id,
      sourceActionKey: _sourceActionKey(
        analysis: analysis,
        suggestedTask: suggestedTask,
        nextAction: nextAction,
        requiredDocument: requiredDocument,
      ),
    );
  }
}

String _sourceActionKey({
  required DocumentAnalysis analysis,
  required AnalysisSuggestedTask? suggestedTask,
  required String? nextAction,
  required AnalysisRequiredDocument? requiredDocument,
}) {
  if (suggestedTask != null) {
    return 'suggested-task:${analysis.suggestedTasks.indexOf(suggestedTask)}';
  }
  if (nextAction != null) {
    return 'next-action:${analysis.nextActions.indexOf(nextAction)}';
  }
  if (requiredDocument != null) {
    return 'required-document:${analysis.requiredDocuments.indexOf(requiredDocument)}';
  }
  return 'action-required';
}

class _TaskDateTime {
  const _TaskDateTime(this.date, this.timeMinutes);

  final DateTime date;
  final int? timeMinutes;
}

AnalysisSuggestedTask? _firstSuggestedTask(
  Iterable<AnalysisSuggestedTask> tasks,
) {
  for (final task in tasks) {
    if (_meaningful(task.title) != null) {
      return task;
    }
  }
  return null;
}

AnalysisRequiredDocument? _firstRequiredDocument(
  Iterable<AnalysisRequiredDocument> documents,
) {
  for (final document in documents) {
    if (_meaningful(document.description) != null) {
      return document;
    }
  }
  return null;
}

_TaskDateTime? _firstDeadlineDateTime(Iterable<AnalysisDeadline> deadlines) {
  for (final deadline in deadlines) {
    final dateTime = _parseDateTime(deadline.dateOrRange, time: deadline.time);
    if (dateTime != null) {
      return dateTime;
    }
  }
  return null;
}

_TaskDateTime? _firstAppointmentDateTime(
  Iterable<AnalysisAppointment> appointments,
) {
  for (final appointment in appointments) {
    final dateTime = _parseDateTime(appointment.startOrDate);
    if (dateTime != null) {
      return dateTime;
    }
  }
  return null;
}

String? _note({
  required AnalysisSuggestedTask? suggestedTask,
  required AnalysisRequiredDocument? requiredDocument,
}) {
  final values = <String>[];
  final instructions = _meaningful(suggestedTask?.instructions);
  if (instructions != null) {
    values.add(instructions);
  }
  final requiredValue = _meaningful(requiredDocument?.description);
  if (requiredValue != null) {
    values.add(requiredValue);
  }
  return values.isEmpty ? null : values.join('\n');
}

_TaskDateTime? _parseDateTime(String? value, {String? time}) {
  final source = _meaningful(value);
  if (source == null) {
    return null;
  }
  final parsed = DateTime.tryParse(source) ?? _parseDmyDate(source);
  if (parsed == null) {
    return null;
  }
  final explicitTime = _timeMinutes(time) ??
      (_containsTime(source) ? parsed.hour * 60 + parsed.minute : null);
  return _TaskDateTime(
    DateTime(parsed.year, parsed.month, parsed.day),
    explicitTime,
  );
}

DateTime? _parseDmyDate(String source) {
  final match = RegExp(r'^(\d{1,2})\.(\d{1,2})\.(\d{4})').firstMatch(source);
  if (match == null) {
    return null;
  }
  final day = int.parse(match.group(1)!);
  final month = int.parse(match.group(2)!);
  final year = int.parse(match.group(3)!);
  final date = DateTime(year, month, day);
  return date.year == year && date.month == month && date.day == day ? date : null;
}

int? _timeMinutes(String? value) {
  final match = RegExp(r'\b([01]?\d|2[0-3]):([0-5]\d)\b').firstMatch(value ?? '');
  if (match == null) {
    return null;
  }
  return int.parse(match.group(1)!) * 60 + int.parse(match.group(2)!);
}

bool _containsTime(String value) =>
    RegExp(r'(?:T|\s)\d{1,2}:\d{2}').hasMatch(value);

String? _firstMeaningful(Iterable<String> values) {
  for (final value in values) {
    final meaningful = _meaningful(value);
    if (meaningful != null) {
      return meaningful;
    }
  }
  return null;
}

String? _meaningful(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}
