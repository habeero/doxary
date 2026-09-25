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
    expect(find.text('Sprache der Erklärung'), findsOneWidget);
    expect(find.text('Einfaches Deutsch'), findsOneWidget);
    expect(
      find.byKey(const Key('settings-explanation-language')),
      findsOneWidget,
    );
    expect(find.text('Konto'), findsOneWidget);
    expect(find.text('Benachrichtigungen'), findsOneWidget);
    expect(find.text('Noch nicht verfügbar'), findsWidgets);
    final appearanceRow = find.byKey(const Key('settings-appearance'));
    await tester.scrollUntilVisible(appearanceRow, 200);
    expect(appearanceRow, findsOneWidget);
    expect(
      find.descendant(
        of: appearanceRow,
        matching: find.text('Noch nicht verfügbar'),
      ),
      findsNothing,
    );
    expect(find.byType(Switch), findsNothing);
    await tester.scrollUntilVisible(find.text('Datenschutz und Daten'), 200);
    expect(find.text('Datenschutz und Daten'), findsOneWidget);
  });

  testWidgets('Explanation language row is enabled and opens its selector', (
    tester,
  ) async {
    await _pump(tester, const Locale('de'));

    final row = find.byKey(const Key('settings-explanation-language'));
    final rowSemantics = find
        .ancestor(of: row, matching: find.byType(Semantics))
        .first;
    expect(tester.widget<Semantics>(rowSemantics).properties.enabled, isTrue);

    await tester.tap(row);
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('settings-explanation-language-modal')),
      findsOneWidget,
    );
    expect(
      tester
          .widget<ListTile>(
            find.byKey(const Key('settings-explanation-language-de')),
          )
          .selected,
      isTrue,
    );
  });

  testWidgets('Appearance defaults to System and marks its option accessibly', (
    tester,
  ) async {
    await _pump(tester, const Locale('de'));
    final row = find.byKey(const Key('settings-appearance'));
    await tester.scrollUntilVisible(row, 200);

    expect(
      find.descendant(of: row, matching: find.text('System')),
      findsOneWidget,
    );
    final rowSemantics = tester.widget<Semantics>(
      find.ancestor(of: row, matching: find.byType(Semantics)).first,
    );
    expect(rowSemantics.properties.enabled, isTrue);
    expect(rowSemantics.properties.label, 'Erscheinungsbild: System');

    await tester.tap(row);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('settings-appearance-modal')), findsOneWidget);
    final systemOption = find.byKey(const Key('settings-theme-system'));
    expect(tester.widget<ListTile>(systemOption).selected, isTrue);
    final optionSemantics = tester.widget<Semantics>(
      find.ancestor(of: systemOption, matching: find.byType(Semantics)).first,
    );
    expect(optionSemantics.properties.selected, isTrue);
  });

  testWidgets('Appearance restores valid values and defaults invalid values', (
    tester,
  ) async {
    final cases = <({Map<String, String> values, String label})>[
      (values: <String, String>{}, label: 'System'),
      (values: {'theme_mode': 'system'}, label: 'System'),
      (values: {'theme_mode': 'light'}, label: 'Hell'),
      (values: {'theme_mode': 'dark'}, label: 'Dunkel'),
      (values: {'theme_mode': 'sepia'}, label: 'System'),
    ];

    for (final scenario in cases) {
      final settings = _MemorySettings(scenario.values);
      await _pump(
        tester,
        const Locale('de'),
        settings: settings,
        scopeKey: ObjectKey(settings),
      );
      final row = find.byKey(const Key('settings-appearance'));
      await tester.scrollUntilVisible(row, 200);
      expect(
        find.descendant(of: row, matching: find.text(scenario.label)),
        findsOneWidget,
      );
    }
  });

  testWidgets('Dismissing Appearance selector does not write a preference', (
    tester,
  ) async {
    final settings = _MemorySettings();
    await _pump(tester, const Locale('de'), settings: settings);
    await _openAppearance(tester);

    await tester.tap(find.byKey(const Key('settings-appearance-close')));
    await tester.pumpAndSettle();

    expect(settings.values.containsKey('theme_mode'), isFalse);
    expect(find.byKey(const Key('settings-appearance-modal')), findsNothing);
  });

  testWidgets(
    'Selecting each Appearance option updates and persists ThemeMode',
    (tester) async {
      final cases =
          <({ThemeMode mode, String value, String label, Key optionKey})>[
            (
              mode: ThemeMode.light,
              value: 'light',
              label: 'Hell',
              optionKey: const Key('settings-theme-light'),
            ),
            (
              mode: ThemeMode.dark,
              value: 'dark',
              label: 'Dunkel',
              optionKey: const Key('settings-theme-dark'),
            ),
            (
              mode: ThemeMode.system,
              value: 'system',
              label: 'System',
              optionKey: const Key('settings-theme-system'),
            ),
          ];

      for (final scenario in cases) {
        final initialMode = scenario.mode == ThemeMode.system
            ? 'dark'
            : 'system';
        final settings = _MemorySettings({'theme_mode': initialMode});
        await _pump(
          tester,
          const Locale('de'),
          settings: settings,
          scopeKey: ObjectKey(settings),
        );
        await _openAppearance(tester);
        await tester.tap(find.byKey(scenario.optionKey));
        await tester.pumpAndSettle();

        expect(settings.values['theme_mode'], scenario.value);
        expect(
          tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
          scenario.mode,
        );
        expect(
          find.byKey(const Key('settings-appearance-modal')),
          findsNothing,
        );
        final row = find.byKey(const Key('settings-appearance'));
        expect(
          find.descendant(of: row, matching: find.text(scenario.label)),
          findsOneWidget,
        );
        if (scenario.mode == ThemeMode.dark) {
          final activeTheme = Theme.of(
            tester.element(find.byType(ProfilePage)),
          );
          expect(activeTheme.brightness, Brightness.dark);
          expect(
            activeTheme.scaffoldBackgroundColor,
            AppTheme.dark().scaffoldBackgroundColor,
          );
          final settingsSurface = tester.widget<Material>(
            find
                .descendant(
                  of: find.byType(ProfilePage),
                  matching: find.byType(Material),
                )
                .first,
          );
          expect(
            settingsSurface.color,
            AppTheme.dark().scaffoldBackgroundColor,
          );
        }
      }
    },
  );

  testWidgets('Appearance leaves both language preferences unchanged', (
    tester,
  ) async {
    final settings = _MemorySettings({
      'ui_language': 'ar',
      'analysis_language': 'de',
    });
    await _pump(tester, const Locale('ar'), settings: settings);
    await _openAppearance(tester);
    await tester.tap(find.byKey(const Key('settings-theme-dark')));
    await tester.pumpAndSettle();

    expect(settings.values['theme_mode'], 'dark');
    expect(settings.values['ui_language'], 'ar');
    expect(settings.values['analysis_language'], 'de');
    expect(
      Directionality.of(tester.element(find.byType(ProfilePage))),
      TextDirection.rtl,
    );
  });

  testWidgets('Arabic Appearance labels and layout remain RTL', (tester) async {
    await _pump(tester, const Locale('ar'));
    final row = find.byKey(const Key('settings-appearance'));
    await tester.scrollUntilVisible(row, 200);
    expect(
      find.descendant(of: row, matching: find.text('النظام')),
      findsOneWidget,
    );
    expect(Directionality.of(tester.element(row)), TextDirection.rtl);

    await tester.tap(row);
    await tester.pumpAndSettle();
    final sheet = find.byKey(const Key('settings-appearance-modal'));
    expect(
      find.descendant(of: sheet, matching: find.text('النظام')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: sheet, matching: find.text('فاتح')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: sheet, matching: find.text('داكن')),
      findsOneWidget,
    );
    expect(Directionality.of(tester.element(sheet)), TextDirection.rtl);
  });

  testWidgets('Appearance fits normal and constrained widths', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final width in [390.0, 280.0]) {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;
      await _pump(tester, const Locale('ar'));
      await _openAppearance(tester);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byKey(const Key('settings-appearance-close')));
      await tester.pumpAndSettle();
    }
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

  testWidgets(
    'Explanation language selection dismisses without changing the value',
    (tester) async {
      final settings = _MemorySettings({'analysis_language': 'ar'});
      await _pump(tester, const Locale('de'), settings: settings);
      await tester.tap(find.byKey(const Key('settings-explanation-language')));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<ListTile>(
              find.byKey(const Key('settings-explanation-language-ar')),
            )
            .selected,
        isTrue,
      );
      await tester.tap(
        find.byKey(const Key('settings-explanation-language-close')),
      );
      await tester.pumpAndSettle();

      expect(settings.values['analysis_language'], 'ar');
      expect(
        find.descendant(
          of: find.byKey(const Key('settings-explanation-language')),
          matching: find.text('Arabisch'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('Selecting Arabic updates the explanation language provider', (
    tester,
  ) async {
    final settings = _MemorySettings();
    await _pump(tester, const Locale('de'), settings: settings);
    await tester.tap(find.byKey(const Key('settings-explanation-language')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('settings-explanation-language-ar')));
    await tester.pumpAndSettle();

    expect(settings.values['analysis_language'], 'ar');
    expect(
      find.descendant(
        of: find.byKey(const Key('settings-explanation-language')),
        matching: find.text('Arabisch'),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'Selecting Simple German updates the explanation language provider',
    (tester) async {
      final settings = _MemorySettings({'analysis_language': 'ar'});
      await _pump(tester, const Locale('de'), settings: settings);
      await tester.tap(find.byKey(const Key('settings-explanation-language')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('settings-explanation-language-de')),
      );
      await tester.pumpAndSettle();

      expect(settings.values['analysis_language'], 'de');
      expect(
        find.descendant(
          of: find.byKey(const Key('settings-explanation-language')),
          matching: find.text('Einfaches Deutsch'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('Explanation language does not change the app locale', (
    tester,
  ) async {
    final settings = _MemorySettings();
    await _pump(tester, const Locale('de'), settings: settings);
    await tester.tap(find.byKey(const Key('settings-explanation-language')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('settings-explanation-language-ar')));
    await tester.pumpAndSettle();

    expect(settings.values['ui_language'], isNull);
    expect(
      Directionality.of(tester.element(find.byType(ProfilePage))),
      TextDirection.ltr,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('settings-app-language')),
        matching: find.text('Deutsch'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Changing UI language does not overwrite explanation language', (
    tester,
  ) async {
    final settings = _MemorySettings({'analysis_language': 'de'});
    await _pump(tester, const Locale('de'), settings: settings);
    await tester.tap(find.byKey(const Key('settings-app-language')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('settings-language-ar')));
    await tester.pumpAndSettle();

    expect(settings.values['analysis_language'], 'de');
    expect(
      Directionality.of(tester.element(find.byType(ProfilePage))),
      TextDirection.rtl,
    );
    final arabic = AppLocalizations(const Locale('ar'));
    expect(
      find.descendant(
        of: find.byKey(const Key('settings-explanation-language')),
        matching: find.text(arabic.analysisLanguageSimpleGerman),
      ),
      findsOneWidget,
    );
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

  testWidgets('Settings follows German LTR', (tester) async {
    await _pump(tester, const Locale('de'));

    expect(
      Directionality.of(tester.element(find.byType(ProfilePage))),
      TextDirection.ltr,
    );
  });

  testWidgets('Explanation language labels do not overflow', (tester) async {
    await _pump(tester, const Locale('de'));

    final row = find.byKey(const Key('settings-explanation-language'));
    final value = find.descendant(
      of: row,
      matching: find.text('Einfaches Deutsch'),
    );
    expect(value, findsOneWidget);
    expect(tester.widget<Text>(value).overflow, TextOverflow.ellipsis);

    await tester.tap(row);
    await tester.pumpAndSettle();
    final option = find.byKey(const Key('settings-explanation-language-de'));
    final optionTitle = find.descendant(
      of: option,
      matching: find.text('Einfaches Deutsch'),
    );
    expect(optionTitle, findsOneWidget);
    expect(tester.widget<Text>(optionTitle).overflow, TextOverflow.ellipsis);
  });
}

Future<void> _pump(
  WidgetTester tester,
  Locale locale, {
  _MemorySettings? settings,
  Key? scopeKey,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      key: scopeKey,
      overrides: [
        deviceLocaleProvider.overrideWithValue(locale),
        settingsRepositoryProvider.overrideWithValue(
          settings ?? _MemorySettings(),
        ),
      ],
      child: const _SettingsTestApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _openAppearance(WidgetTester tester) async {
  final row = find.byKey(const Key('settings-appearance'));
  await tester.scrollUntilVisible(row, 200);
  await tester.tap(row);
  await tester.pumpAndSettle();
}

class _SettingsTestApp extends ConsumerWidget {
  const _SettingsTestApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
    locale: ref.watch(languageProvider),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    themeMode: ref.watch(themeModeProvider),
    home: const ProfilePage(),
  );
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
