import 'package:doxary/app/routing/app_shell.dart';
import 'package:doxary/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dark theme maps the documented Result semantic tokens', () {
    final theme = AppTheme.dark();

    expect(theme.scaffoldBackgroundColor, AppColors.darkBackground);
    expect(theme.colorScheme.primary, AppColors.darkPrimary);
    expect(theme.colorScheme.surface, AppColors.darkSurface);
    expect(theme.colorScheme.surfaceContainer, AppColors.darkSurfaceAlt);
    expect(theme.colorScheme.onSurface, AppColors.darkTextPrimary);
    expect(theme.colorScheme.onSurfaceVariant, AppColors.darkTextSecondary);
    expect(theme.appBarTheme.backgroundColor, AppColors.darkBackground);
    expect(theme.navigationBarTheme.backgroundColor, AppColors.darkSurface);
    expect(
      (theme.cardTheme.shape! as RoundedRectangleBorder).borderRadius,
      BorderRadius.circular(10),
    );
    expect(
      theme.filledButtonTheme.style?.backgroundColor?.resolve({}),
      AppColors.darkPrimary,
    );
  });

  test('light theme uses the documented primary token', () {
    final theme = AppTheme.light();

    expect(theme.scaffoldBackgroundColor, AppColors.background);
    expect(theme.colorScheme.primary, AppColors.primary);
    expect(theme.colorScheme.surface, AppColors.surface);
  });

  test('only the Document detail location is focused in this batch', () {
    expect(
      isFocusedDocumentLocation(Uri.parse('/documents/document-1')),
      isTrue,
    );
    expect(isFocusedDocumentLocation(Uri.parse('/documents')), isFalse);
    expect(
      isFocusedDocumentLocation(Uri.parse('/documents/organization/org-1')),
      isFalse,
    );
  });
}
