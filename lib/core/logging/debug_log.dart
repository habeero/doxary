import 'package:flutter/foundation.dart';

/// Development diagnostics only. Never pass document content or identifiers
/// from document data to this logger.
void analysisDebugLog(String stage, String message) {
  if (kDebugMode) {
    debugPrint('[DoxaryAnalysis][$stage] $message');
  }
}
