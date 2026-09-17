import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/design_system/app_widgets.dart';
import '../../documents/domain/entities/domain_entities.dart';
import '../../documents/presentation/documents_page.dart';

class CasePage extends ConsumerWidget {
  const CasePage({required this.caseId, super.key});
  final String caseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cases = _data(ref.watch(casesProvider)) ?? const <Case>[];
    final item = _firstWhere(cases, (value) => value.id == caseId);
    final documents =
        (_data(ref.watch(allDocumentsProvider)) ?? const <LocalDocument>[])
            .where((value) => value.caseId == caseId)
            .toList();
    return Scaffold(
      appBar: AppBar(title: Text(item?.title ?? l10n.caseLabel)),
      body: documents.isEmpty
          ? AppEmptyState(
              icon: Icons.description_outlined,
              title: l10n.noDocuments,
              description: l10n.emptyDocumentsDescription,
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
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
