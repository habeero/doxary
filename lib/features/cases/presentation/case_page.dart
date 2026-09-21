import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../shared/design_system/app_widgets.dart';
import '../../documents/domain/entities/domain_entities.dart';
import '../../documents/presentation/documents_page.dart';

class CasePage extends ConsumerStatefulWidget {
  const CasePage({required this.caseId, super.key});
  final String caseId;

  @override
  ConsumerState<CasePage> createState() => _CasePageState();
}

class _CasePageState extends ConsumerState<CasePage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cases = _data(ref.watch(casesProvider)) ?? const <Case>[];
    final item = _firstWhere(cases, (value) => value.id == widget.caseId);
    final documents = (_data(ref.watch(allDocumentsProvider)) ?? const <LocalDocument>[])
        .where((value) => value.caseId == widget.caseId)
        .toList();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const BackButtonIcon(),
        ),
        title: Text(
          item?.title ?? l10n.caseLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: documents.isEmpty
          ? AppEmptyState(
              icon: Icons.description_outlined,
              title: l10n.noDocuments,
              description: l10n.emptyDocumentsDescription,
            )
          : DocumentCollection(
              documents: documents,
              query: _query,
              onQueryChanged: (value) => setState(() => _query = value),
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
