import 'package:flutter/foundation.dart';

/// Development diagnostics only. Never pass document content or identifiers
/// from document data to this logger.
void analysisDebugLog(String stage, String message) {
  if (kDebugMode) {
    debugPrint('[DoxaryAnalysis][$stage] $message');
  }
}

/// Development diagnostics for local reminder scheduling. Callers must not
/// include Task titles, identifiers, or linked record data.
void reminderDebugLog(String stage, String message) {
  if (kDebugMode) {
    debugPrint('[DoxaryReminder][$stage] $message');
  }
}

/// Logs only structural reminder state while debugging the save-to-scheduler
/// path. This deliberately excludes all user-entered or linked-record text.
void reminderTaskStateDebugLog(
  String stage, {
  required String event,
  required int? reminderMinutesBefore,
  required bool allDay,
  required bool timePresent,
  required String status,
}) {
  reminderDebugLog(
    stage,
    '$event reminderPresent=${reminderMinutesBefore != null} '
    'reminderMinutesBefore=$reminderMinutesBefore allDay=$allDay '
    'timePresent=$timePresent status=$status',
  );
}
