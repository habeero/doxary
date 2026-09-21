import 'package:doxary/app/localization/app_localizations.dart';
import 'package:doxary/app/providers.dart';
import 'package:doxary/app/theme/app_theme.dart';
import 'package:doxary/features/settings/domain/settings_repository.dart';
import 'package:doxary/features/settings/presentation/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Settings shows the implemented language section and value', (
    tester,
  ) async {
    await _pump(tester, const Locale('de'));

    expect(find.text('Einstellungen'), findsOneWidget);
    expect(find.text('Sprache'), findsOneWidget);
    expect(find.text('App-Sprache'), findsOneWidget);
    expect(find.text('Deutsch'), findsOneWidget);
    expect(find.byKey(const Key('settings-app-language')), findsOneWidget);
    expect(find.text('Konto'), findsOneWidget);
    expect(find.text('Benachrichtigungen'), findsOneWidget);
    expect(find.text('Noch nicht verfügbar'), findsWidgets);
    expect(find.byType(Switch), findsNothing);
    await tester.scrollUntilVisible(find.text('Datenschutz und Daten'), 200);
    expect(find.text('Datenschutz und Daten'), findsOneWidget);
  });

  testWidgets('Settings language selection closes without changing the value', (
    tester,
  ) async {
    final settings = _MemorySettings();
    await _pump(tester, const Locale('de'), settings: settings);
    await tester.tap(find.byKey(const Key('settings-app-language')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('settings-language-modal')), findsOneWidget);
    await tester.tap(find.byKey(const Key('settings-language-close')));
    await tester.pumpAndSettle();

    expect(settings.values['ui_language'], isNull);
    expect(find.text('Deutsch'), findsOneWidget);
  });

  testWidgets('Settings language selection uses the existing persisted state', (
    tester,
  ) async {
    final settings = _MemorySettings();
    await _pump(tester, const Locale('de'), settings: settings);
    await tester.tap(find.byKey(const Key('settings-app-language')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('settings-language-ar')));
    await tester.pumpAndSettle();

    expect(settings.values['ui_language'], 'ar');
  });

  testWidgets('Settings follows Arabic RTL and bounds the selected value', (
    tester,
  ) async {
    await _pump(tester, const Locale('ar'));

    final row = find.byKey(const Key('settings-app-language'));
    final value = find.descendant(of: row, matching: find.text('العربية'));
    expect(value, findsOneWidget);
    expect(tester.widget<Text>(value).overflow, TextOverflow.ellipsis);
    expect(Directionality.of(tester.element(row)), TextDirection.rtl);
  });
}

Future<void> _pump(
  WidgetTester tester,
  Locale locale, {
  _MemorySettings? settings,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        deviceLocaleProvider.overrideWithValue(locale),
        settingsRepositoryProvider.overrideWithValue(
          settings ?? _MemorySettings(),
        ),
      ],
      child: MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppTheme.light(),
        home: const ProfilePage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _MemorySettings implements SettingsRepository {
  _MemorySettings([Map<String, String>? values]) : values = {...?values};

  final Map<String, String> values;

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }
}
