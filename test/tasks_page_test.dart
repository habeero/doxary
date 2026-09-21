import 'package:doxary/app/localization/app_localizations.dart';
import 'package:doxary/app/providers.dart';
import 'package:doxary/app/theme/app_theme.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:doxary/features/tasks/presentation/tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Today is the first Tasks tab and classification stays intact', (tester) async {
    final now = DateTime(2026, 9, 21, 9);
    LocalTask task(String id, DateTime dueAt) => LocalTask(
      id: id,
      title: id,
      status: TaskStatus.open,
      provenance: TaskProvenance.user,
      createdAt: now,
      updatedAt: now,
      dueAt: dueAt,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentTimeProvider.overrideWithValue(now),
          openTasksProvider.overrideWithValue(
            AsyncValue.data([
              task('Overdue reply', DateTime(2026, 9, 20, 23)),
              task('Today reply', DateTime(2026, 9, 21, 8)),
              task('Future reply', DateTime(2026, 9, 22)),
            ]),
          ),
          completedTasksProvider.overrideWithValue(
            const AsyncValue.data(<LocalTask>[]),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('de'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light(),
          home: const TasksPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Überfällig'), findsWidgets);
    expect(find.text('Today reply'), findsOneWidget);
    expect(find.text('Overdue reply'), findsNothing);
    expect(find.text('Future reply'), findsNothing);
  });
}
