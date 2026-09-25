import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../localization/app_localizations.dart';
import 'task_notification_intent_handler.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
    required this.showBottomNavigation,
    required this.focusedBranchRoutes,
  });
  final StatefulNavigationShell navigationShell;
  final bool showBottomNavigation;
  final List<ValueListenable<bool>> focusedBranchRoutes;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge(focusedBranchRoutes),
    builder: (context, child) {
      final l10n = context.l10n;
      final hasFocusedBranchRoute =
          focusedBranchRoutes[navigationShell.currentIndex].value;
      return Scaffold(
        body: TaskNotificationIntentHandler(child: navigationShell),
        bottomNavigationBar: showBottomNavigation && !hasFocusedBranchRoute
            ? NavigationBar(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: (index) => navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                ),
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.home_outlined),
                    selectedIcon: const Icon(Icons.home),
                    label: l10n.bottomNavigationHome,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.folder_outlined),
                    selectedIcon: const Icon(Icons.folder),
                    label: l10n.bottomNavigationDocuments,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.document_scanner_outlined),
                    selectedIcon: const Icon(Icons.document_scanner),
                    label: l10n.bottomNavigationAnalyze,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.checklist_outlined),
                    selectedIcon: const Icon(Icons.checklist),
                    label: l10n.bottomNavigationTasks,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.settings_outlined),
                    selectedIcon: const Icon(Icons.settings),
                    label: l10n.bottomNavigationSettings,
                  ),
                ],
              )
            : null,
      );
    },
  );
}
