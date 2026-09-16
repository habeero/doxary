// The compact conditional section construction is intentional for this
// presentation-only view.
// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_underscores
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/design_system/app_widgets.dart';
import '../../documents/domain/entities/domain_entities.dart';

class AnalysisResultPage extends ConsumerWidget {
  const AnalysisResultPage({required this.clientDocumentId, super.key});
  final String clientDocumentId;
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.analysisTitle)),
    body: ref
        .watch(latestAnalysisProvider(clientDocumentId))
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => Center(child: Text(context.l10n.analysisReadError)),
          data: (analysis) => analysis == null
              ? Center(child: Text(context.l10n.noSavedAnalysis))
              : _ResultBody(analysis: analysis),
        ),
  );
}

class _ResultBody extends StatelessWidget {
  const _ResultBody({required this.analysis});
  final DocumentAnalysis analysis;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget section(String title, List<Widget> children) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            ...children,
          ],
        ),
      ),
    );
    final children = <Widget>[_StatusCard(analysis: analysis)];
    if (analysis.classification != null)
      children.add(
        section(l.suggestion, [
          if (analysis.classification!.organizationName != null)
            Text(analysis.classification!.organizationName!),
          if (analysis.classification!.documentType != null)
            Text(analysis.classification!.documentType!),
        ]),
      );
    if (analysis.summary != null || analysis.explanation != null)
      children.add(
        section(l.explanation, [
          Text('${l.outputStyle}: ${_style(l, analysis.explanationStyle)}'),
          if (analysis.summary != null)
            Text(
              analysis.summary!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          if (analysis.explanation != null) Text(analysis.explanation!),
        ]),
      );
    if (analysis.actionRequired != ActionRequirement.uncertain ||
        analysis.urgency != AnalysisUrgency.uncertain)
      children.add(
        section(l.whatToDo, [
          Text('${l.actionRequired}: ${_action(l, analysis.actionRequired)}'),
          Text('${l.urgency}: ${_urgency(l, analysis.urgency)}'),
        ]),
      );
    if (analysis.deadlines.isNotEmpty)
      children.add(
        section(
          l.deadlines,
          analysis.deadlines
              .map((v) => Text('${v.label}: ${v.dateOrRange}'))
              .toList(),
        ),
      );
    if (analysis.appointments.isNotEmpty)
      children.add(
        section(
          l.appointments,
          analysis.appointments
              .map((v) => Text('${v.label}: ${v.startOrDate}'))
              .toList(),
        ),
      );
    if (analysis.amounts.isNotEmpty)
      children.add(
        section(
          l.amounts,
          analysis.amounts
              .map((v) => Text('${v.value} ${v.currency}'))
              .toList(),
        ),
      );
    if (analysis.requiredDocuments.isNotEmpty)
      children.add(
        section(
          l.requiredDocuments,
          analysis.requiredDocuments.map((v) => Text(v.description)).toList(),
        ),
      );
    if (analysis.nextActions.isNotEmpty)
      children.add(
        section(l.nextActions, analysis.nextActions.map(Text.new).toList()),
      );
    if (analysis.qualityReasons.isNotEmpty)
      children.add(
        section(
          l.documentQuality,
          analysis.qualityReasons.map((v) => Text(_quality(l, v))).toList(),
        ),
      );
    if (analysis.uncertainties.isNotEmpty)
      children.add(
        section(l.pleaseVerify, analysis.uncertainties.map(Text.new).toList()),
      );
    if (analysis.sourceReferences.isNotEmpty)
      children.add(
        section(l.evidence, [
          Text('${analysis.sourceReferences.length} ${l.sourceReferences}'),
        ]),
      );
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: children,
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.analysis});
  final DocumentAnalysis analysis;
  @override
  Widget build(BuildContext context) => AppSectionCard(
    child: Text(
      _status(context.l10n, analysis.analysisStatus),
      style: Theme.of(context).textTheme.titleLarge,
    ),
  );
}

String _style(AppLocalizations l, ExplanationStyle v) =>
    v == ExplanationStyle.simple ? l.simple : l.standard;
String _status(AppLocalizations l, AnalysisStatus v) => switch (v) {
  AnalysisStatus.complete => l.complete,
  AnalysisStatus.partial => l.partial,
  AnalysisStatus.unavailable => l.analysisUnavailable,
};
String _action(AppLocalizations l, ActionRequirement v) => switch (v) {
  ActionRequirement.yes => l.yes,
  ActionRequirement.no => l.no,
  ActionRequirement.uncertain => l.uncertain,
};
String _urgency(AppLocalizations l, AnalysisUrgency v) => switch (v) {
  AnalysisUrgency.low => l.low,
  AnalysisUrgency.normal => l.normal,
  AnalysisUrgency.high => l.high,
  AnalysisUrgency.critical => l.critical,
  AnalysisUrgency.uncertain => l.uncertain,
};
String _quality(AppLocalizations l, DocumentQualityReason v) => switch (v) {
  DocumentQualityReason.blurryImage => l.qualityBlurry,
  DocumentQualityReason.pageCutOff => l.qualityCutOff,
  DocumentQualityReason.unreadableText => l.qualityUnreadable,
  DocumentQualityReason.missingPages => l.qualityMissing,
  DocumentQualityReason.unsupportedFile => l.qualityUnsupported,
  DocumentQualityReason.corruptFile => l.qualityCorrupt,
  DocumentQualityReason.insufficientContent => l.qualityInsufficient,
};
