import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/design_system/app_widgets.dart';
import '../../documents/domain/entities/domain_entities.dart';
import '../../documents/presentation/documents_page.dart';

class OrganizationPage extends ConsumerWidget {
  const OrganizationPage({required this.organizationId, super.key});
  final String organizationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final organizations =
        _data(ref.watch(organizationsProvider)) ?? const <Organization>[];
    final organization = _firstWhere(
      organizations,
      (item) => item.id == organizationId,
    );
    final cases = (_data(ref.watch(casesProvider)) ?? const <Case>[])
        .where((item) => item.organizationId == organizationId)
        .toList();
    final documents =
        (_data(ref.watch(allDocumentsProvider)) ?? const <LocalDocument>[])
            .where(
              (item) =>
                  item.organizationId == organizationId && item.caseId == null,
            )
            .toList();
    return Scaffold(
      appBar: AppBar(title: Text(organization?.name ?? l10n.organization)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          if (cases.isNotEmpty) ...[
            Text(l10n.cases, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            AppSectionCard(
              child: Column(
                children: [
                  for (final item in cases)
                    ListTile(
                      leading: const Icon(Icons.folder_outlined),
                      title: Text(item.title),
                      onTap: () => context.push(
                        '/documents/organization/$organizationId/case/${item.id}',
                      ),
                    ),
                ],
              ),
            ),
          ],
          if (documents.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.organizationDocuments,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppSectionCard(
              child: Column(
                children: [
                  for (final document in documents)
                    DocumentListTile(
                      document: document,
                      onTap: () => context.push(
                        '/documents/${document.clientDocumentId}',
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

T? _data<T>(AsyncValue<T> value) => value is AsyncData<T> ? value.value : null;

T? _firstWhere<T>(Iterable<T> values, bool Function(T) predicate) {
  for (final value in values) {
    if (predicate(value)) return value;
  }
  return null;
}
