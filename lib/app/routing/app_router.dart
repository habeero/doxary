import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/document_import/presentation/import_page.dart';
import '../../features/document_analysis/presentation/document_detail_page.dart';
import '../../features/organizations/presentation/organization_page.dart';
import '../../features/cases/presentation/case_page.dart';
import '../../features/documents/presentation/documents_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/settings/presentation/profile_page.dart';
import '../../features/tasks/presentation/tasks_page.dart';
import '../../features/tasks/presentation/task_draft_prefill.dart';
import '../../features/tasks/presentation/task_editor_page.dart';
import '../../features/tasks/presentation/task_detail_page.dart';
import 'app_shell.dart';

abstract final class AppRoutes {
  static const home = '/home';
  static const documents = '/documents';
  static const documentsNeedsAttention = '/documents/needs-attention';
  static const importDocument = '/import';
  static const tasks = '/tasks';
  static const profile = '/profile';

  static const primaryRootLocations = <String>{
    home,
    documents,
    importDocument,
    tasks,
    profile,
  };

  static bool isPrimaryRootLocation(Uri location) =>
      primaryRootLocations.contains(location.path);
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final focusedBranchRoutes = List.generate(
    AppRoutes.primaryRootLocations.length,
    (_) => ValueNotifier<bool>(false),
  );
  ref.onDispose(() {
    for (final focusedBranchRoute in focusedBranchRoutes) {
      focusedBranchRoute.dispose();
    }
  });
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(
          navigationShell: navigationShell,
          showBottomNavigation: AppRoutes.isPrimaryRootLocation(state.uri),
          focusedBranchRoutes: focusedBranchRoutes,
        ),
        branches: [
          StatefulShellBranch(
            observers: [_FocusedBranchRouteObserver(focusedBranchRoutes[0])],
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            observers: [_FocusedBranchRouteObserver(focusedBranchRoutes[1])],
            routes: [
              GoRoute(
                path: AppRoutes.documents,
                builder: (context, state) => const DocumentsPage(),
                routes: [
                  GoRoute(
                    path: 'needs-attention',
                    builder: (context, state) =>
                        const NeedsAttentionDocumentsPage(),
                  ),
                  GoRoute(
                    path: 'unclassified',
                    builder: (context, state) =>
                        const UnclassifiedDocumentsPage(),
                  ),
                  GoRoute(
                    path: 'organization/:organizationId',
                    builder: (context, state) => OrganizationPage(
                      organizationId: state.pathParameters['organizationId']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'without-case',
                        builder: (context, state) =>
                            OrganizationWithoutCasePage(
                              organizationId:
                                  state.pathParameters['organizationId']!,
                            ),
                      ),
                      GoRoute(
                        path: 'case/:caseId',
                        builder: (context, state) =>
                            CasePage(caseId: state.pathParameters['caseId']!),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: ':clientDocumentId',
                    builder: (context, state) => DocumentDetailPage(
                      clientDocumentId:
                          state.pathParameters['clientDocumentId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            observers: [_FocusedBranchRouteObserver(focusedBranchRoutes[2])],
            routes: [
              GoRoute(
                path: AppRoutes.importDocument,
                builder: (context, state) => const ImportPage(),
                routes: [
                  GoRoute(
                    path: 'review',
                    builder: (context, state) => const ImportPage(),
                  ),
                  GoRoute(
                    path: 'analysis',
                    builder: (context, state) => const ImportPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            observers: [_FocusedBranchRouteObserver(focusedBranchRoutes[3])],
            routes: [
              GoRoute(
                path: AppRoutes.tasks,
                builder: (context, state) => const TasksPage(),
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (context, state) => TaskEditorPage.create(
                      prefill: state.extra as TaskDraftPrefill?,
                    ),
                  ),
                  GoRoute(
                    path: 'edit/:taskId',
                    builder: (context, state) => TaskEditorPage.edit(
                      taskId: state.pathParameters['taskId']!,
                    ),
                  ),
                  GoRoute(
                    path: ':taskId',
                    builder: (context, state) =>
                        TaskDetailPage(taskId: state.pathParameters['taskId']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            observers: [_FocusedBranchRouteObserver(focusedBranchRoutes[4])],
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class _FocusedBranchRouteObserver extends NavigatorObserver {
  _FocusedBranchRouteObserver(this.hasFocusedRoute);

  final ValueNotifier<bool> hasFocusedRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _updateFocus();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _updateFocus();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _updateFocus();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _updateFocus();
  }

  void _updateFocus() {
    hasFocusedRoute.value = navigator?.canPop() ?? false;
  }
}
