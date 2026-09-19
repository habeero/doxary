import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/design_system/app_widgets.dart';
import '../../documents/domain/entities/domain_entities.dart';

class AnalysisResultPage extends ConsumerWidget {
  const AnalysisResultPage({
    required this.clientDocumentId,
    this.embedded = false,
    super.key,
  });

  final String clientDocumentId;
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final body = ref
        .watch(latestAnalysisProvider(clientDocumentId))
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(context.l10n.analysisReadError)),
          data: (analysis) => analysis == null
              ? Center(child: Text(context.l10n.noSavedAnalysis))
              : DocumentResultView(
                  title: context.l10n.analysisTitle,
                  analysis: analysis,
                ),
        );
    if (embedded) return body;
    return Scaffold(body: SafeArea(child: body));
  }
}

/// State-driven result surface used by the stable Document Detail route.
/// Optional actions are shown only when the caller supplies real behavior.
class DocumentResultView extends StatelessWidget {
  const DocumentResultView({
    super.key,
    required this.title,
    this.analysis,
    this.technicalFailure = false,
    this.classificationSection,
    this.originalDocumentSection,
    this.onRetry,
    this.onReplaceDocument,
    this.onAddTask,
    this.actionInProgress = false,
    this.actionMessage,
  }) : assert(analysis != null || technicalFailure);

  final String title;
  final DocumentAnalysis? analysis;
  final bool technicalFailure;
  final Widget? classificationSection;
  final Widget? originalDocumentSection;
  final VoidCallback? onRetry;
  final VoidCallback? onReplaceDocument;
  final VoidCallback? onAddTask;
  final bool actionInProgress;
  final String? actionMessage;

  @override
  Widget build(BuildContext context) {
    final content = <Widget>[
      _ResultHeader(title: title),
      const SizedBox(height: AppSpacing.lg),
    ];
    if (technicalFailure) {
      content.add(
        _TechnicalFailure(onRetry: onRetry, actionInProgress: actionInProgress),
      );
    } else {
      content.addAll(
        _analysisSections(
          context,
          analysis!,
          onAddTask: onAddTask,
          onReplaceDocument: onReplaceDocument,
          actionInProgress: actionInProgress,
        ),
      );
    }
    if (actionMessage != null) {
      content.add(const SizedBox(height: AppSpacing.sm));
      content.add(
        Text(actionMessage!, key: const Key('result-action-message')),
      );
    }
    if (classificationSection != null) {
      content.add(const SizedBox(height: AppSpacing.lg));
      content.add(classificationSection!);
    }
    if (analysis != null && _hasExpandableDetails(analysis!)) {
      content.add(const SizedBox(height: AppSpacing.sm));
      content.add(_AnalysisDetails(analysis: analysis!));
    }
    if (originalDocumentSection != null) {
      content.add(const Divider(height: AppSpacing.xl));
      content.add(originalDocumentSection!);
    }
    final brightness = Theme.of(context).brightness;
    return ColoredBox(
      key: const Key('document-result-background'),
      color: AppColors.backgroundFor(brightness),
      child: SingleChildScrollView(
        key: const Key('document-result-scroll'),
        padding: const EdgeInsetsDirectional.fromSTEB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: content,
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> _analysisSections(
  BuildContext context,
  DocumentAnalysis analysis, {
  required VoidCallback? onAddTask,
  required VoidCallback? onReplaceDocument,
  required bool actionInProgress,
}) {
  final l = context.l10n;
  final unavailable = analysis.analysisStatus == AnalysisStatus.unavailable;
  final needsReview =
      analysis.analysisStatus == AnalysisStatus.partial ||
      analysis.actionRequired == ActionRequirement.uncertain;
  final actionRequired = analysis.actionRequired == ActionRequirement.yes;
  final sections = <Widget>[];
  late final Widget statePanel;

  if (unavailable) {
    statePanel = _StatePanel(
      key: const Key('unreadable-state'),
      icon: Icons.document_scanner_outlined,
      color: AppColors.warningFor(Theme.of(context).brightness),
      title: l.unreadableResultTitle,
      description: l.unreadableResultBody,
      actionLabel: onReplaceDocument == null ? null : l.chooseClearerDocument,
      onAction: onReplaceDocument,
      actionInProgress: actionInProgress,
    );
  } else if (needsReview) {
    statePanel = _StatePanel(
      key: const Key('partial-state'),
      icon: Icons.fact_check_outlined,
      color: AppColors.warningFor(Theme.of(context).brightness),
      title: l.reviewRequiredTitle,
      description: l.reviewRequiredBody,
      compact: true,
    );
  } else if (actionRequired) {
    statePanel = _StatePanel(
      key: const Key('action-required-state'),
      icon: Icons.priority_high_rounded,
      color: AppColors.errorFor(Theme.of(context).brightness),
      title: l.actionRequired,
      description:
          _firstMeaningful(analysis.nextActions) ?? l.actionRequiredBody,
      actionLabel: onAddTask == null ? null : l.addTaskReminder,
      onAction: onAddTask,
      actionInProgress: actionInProgress,
    );
  } else {
    statePanel = _StatePanel(
      key: const Key('no-action-state'),
      icon: Icons.check_circle_outline,
      color: AppColors.successFor(Theme.of(context).brightness),
      title: l.noActionRequiredTitle,
      description: l.noActionRequiredBody,
    );
  }

  final summary = _meaningful(analysis.summary);
  if (unavailable) sections.add(statePanel);
  if (summary != null) {
    if (unavailable) sections.add(const SizedBox(height: AppSpacing.lg));
    sections.add(_TextSection(title: l.summary, body: summary));
  }
  if (!unavailable) {
    if (summary != null) sections.add(const SizedBox(height: AppSpacing.lg));
    sections.add(statePanel);
  }

  final facts = _facts(analysis, l);
  if (facts.isNotEmpty) {
    sections.add(const SizedBox(height: AppSpacing.lg));
    sections.add(_FactsSection(facts: facts));
  }
  return sections;
}

class _ResultHeader extends StatelessWidget {
  const _ResultHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        context.l10n.productName,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        title,
        key: const Key('document-result-title'),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        style: Theme.of(context).textTheme.titleLarge
            ?.copyWith(fontSize: 22, height: 1.25, fontWeight: FontWeight.w600),
      ),
    ],
  );
}

class _TechnicalFailure extends StatelessWidget {
  const _TechnicalFailure({
    required this.onRetry,
    required this.actionInProgress,
  });
  final VoidCallback? onRetry;
  final bool actionInProgress;

  @override
  Widget build(BuildContext context) => _StatePanel(
    key: const Key('technical-failure-state'),
    icon: Icons.sync_problem_outlined,
    color: AppColors.errorFor(Theme.of(context).brightness),
    title: context.l10n.technicalFailureTitle,
    description: context.l10n.technicalFailureBody,
    actionLabel: onRetry == null ? null : context.l10n.retryAnalysis,
    onAction: onRetry,
    actionInProgress: actionInProgress,
  );
}

class _StatePanel extends StatelessWidget {
  const _StatePanel({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
    this.actionInProgress = false,
    this.compact = false,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool actionInProgress;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final decoration = BoxDecoration(
      color: color.withValues(alpha: dark ? 0.13 : 0.065),
      border: BorderDirectional(
        start: BorderSide(color: color, width: compact ? 3 : 4),
      ),
      borderRadius: BorderRadius.circular(compact ? 8 : 10),
    );
    if (compact) {
      return Semantics(
        liveRegion: true,
        child: Container(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
          decoration: decoration,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: decoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(height: 1.45),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.md),
              FilledButton.icon(
                onPressed: actionInProgress ? null : onAction,
                icon: actionInProgress
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.arrow_forward),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TextSection extends StatelessWidget {
  const _TextSection({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => _Section(
    title: title,
    child: Text(
      body,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
    ),
  );
}

class _FactsSection extends StatelessWidget {
  const _FactsSection({required this.facts});
  final List<({String label, String value, IconData icon})> facts;

  @override
  Widget build(BuildContext context) => _Section(
    title: context.l10n.importantFacts,
    child: Column(
      children: [
        for (var index = 0; index < facts.length; index++) ...[
          if (index > 0) const Divider(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                facts[index].icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      facts[index].label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(facts[index].value),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.titleMedium
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: AppSpacing.sm),
      child,
    ],
  );
}

class _AnalysisDetails extends StatelessWidget {
  const _AnalysisDetails({required this.analysis});
  final DocumentAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final groups = <Widget>[];
    void addGroup(
      String label,
      Iterable<String?> values, {
      bool paragraph = false,
    }) {
      final meaningful = values.map(_meaningful).whereType<String>().toList();
      if (meaningful.isEmpty) return;
      if (groups.isNotEmpty) groups.add(const SizedBox(height: AppSpacing.lg));
      groups.add(
        _DetailGroup(label: label, values: meaningful, paragraph: paragraph),
      );
    }

    addGroup(l.explanation, [analysis.explanation], paragraph: true);
    addGroup(l.nextActions, analysis.nextActions);
    addGroup(
      l.requiredDocuments,
      analysis.requiredDocuments.map((item) => item.description),
    );
    addGroup(l.pleaseVerify, analysis.uncertainties);
    addGroup(
      l.documentQuality,
      analysis.qualityReasons.map((reason) => _quality(l, reason)),
    );
    addGroup(
      l.suggestedTasks,
      analysis.suggestedTasks.map((task) => task.title),
    );
    return AppAccordion(
      key: const Key('analysis-details-accordion'),
      title: l.analysisDetails,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: groups,
      ),
    );
  }
}

class _DetailGroup extends StatelessWidget {
  const _DetailGroup({
    required this.label,
    required this.values,
    required this.paragraph,
  });

  final String label;
  final List<String> values;
  final bool paragraph;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: Theme.of(context).textTheme.titleSmall
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: AppSpacing.sm),
      if (paragraph)
        for (var index = 0; index < values.length; index++) ...[
          if (index > 0) const SizedBox(height: AppSpacing.md),
          Text(
            values[index],
            key: index == 0 ? const Key('analysis-explanation-text') : null,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.55,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ]
      else
        for (final value in values)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 8),
                  child: Icon(
                    Icons.circle,
                    size: 5,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.45,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
    ],
  );
}

List<({String label, String value, IconData icon})> _facts(
  DocumentAnalysis analysis,
  AppLocalizations l,
) {
  final facts = <({String label, String value, IconData icon})>[];
  for (final deadline in analysis.deadlines) {
    final date = _meaningful(deadline.dateOrRange);
    final label = _meaningful(deadline.label);
    if (date != null) {
      facts.add((
        label: label ?? l.deadline,
        value: date,
        icon: Icons.event_outlined,
      ));
    }
  }
  for (final appointment in analysis.appointments) {
    final date = _meaningful(appointment.startOrDate);
    final label = _meaningful(appointment.label);
    if (date != null) {
      facts.add((
        label: label ?? l.appointment,
        value: date,
        icon: Icons.calendar_month_outlined,
      ));
    }
  }
  for (final amount in analysis.amounts) {
    final value = _meaningful(amount.value);
    final currency = _meaningful(amount.currency);
    if (value != null && currency != null) {
      facts.add((
        label: _meaningful(amount.purpose) ?? l.amount,
        value: '$value $currency',
        icon: Icons.payments_outlined,
      ));
    }
  }
  final documentDate = _meaningful(analysis.documentDate);
  if (documentDate != null) {
    facts.add((
      label: l.documentDate,
      value: documentDate,
      icon: Icons.description_outlined,
    ));
  }
  return facts;
}

bool _hasExpandableDetails(DocumentAnalysis analysis) =>
    _meaningful(analysis.explanation) != null ||
    analysis.nextActions.any((value) => _meaningful(value) != null) ||
    analysis.requiredDocuments.any(
      (value) => _meaningful(value.description) != null,
    ) ||
    analysis.uncertainties.any((value) => _meaningful(value) != null) ||
    analysis.qualityReasons.isNotEmpty ||
    analysis.suggestedTasks.any((value) => _meaningful(value.title) != null);

String? _meaningful(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}

String? _firstMeaningful(Iterable<String> values) {
  for (final value in values) {
    final meaningful = _meaningful(value);
    if (meaningful != null) return meaningful;
  }
  return null;
}

String _quality(AppLocalizations l, DocumentQualityReason value) =>
    switch (value) {
      DocumentQualityReason.blurryImage => l.qualityBlurry,
      DocumentQualityReason.pageCutOff => l.qualityCutOff,
      DocumentQualityReason.unreadableText => l.qualityUnreadable,
      DocumentQualityReason.missingPages => l.qualityMissing,
      DocumentQualityReason.unsupportedFile => l.qualityUnsupported,
      DocumentQualityReason.corruptFile => l.qualityCorrupt,
      DocumentQualityReason.insufficientContent => l.qualityInsufficient,
    };
