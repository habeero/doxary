import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'localization/app_localizations.dart';
import 'providers.dart';
import 'routing/app_router.dart';
import 'theme/app_theme.dart';

class ProjectApp extends ConsumerWidget {
  const ProjectApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Startup recovery is deliberately independent from any screen. It only
    // resumes locally known, non-terminal accepted operations.
    ref.watch(resumePendingAnalysesProvider);
    return MaterialApp.router(
      title: 'Doxary',
      debugShowCheckedModeBanner: false,
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
      themeMode: ThemeMode.light,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
