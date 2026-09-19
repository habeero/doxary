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
import 'app_shell.dart';

abstract final class AppRoutes {
  static const home = '/home';
  static const documents = '/documents';
  static const importDocument = '/import';
  static const tasks = '/tasks';
  static const profile = '/profile';
}

final appRouterProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell, location: state.uri),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.documents,
                builder: (context, state) => const DocumentsPage(),
                routes: [
                  GoRoute(
                    path: 'organization/:organizationId',
                    builder: (context, state) => OrganizationPage(
                      organizationId: state.pathParameters['organizationId']!,
                    ),
                    routes: [
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
            routes: [
              GoRoute(
                path: AppRoutes.tasks,
                builder: (context, state) => const TasksPage(),
                routes: [
                  GoRoute(
                    path: ':taskId',
                    builder: (context, state) => const TasksPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
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
  ),
);
