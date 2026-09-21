import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/routing/app_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/design_system/app_widgets.dart';
import '../../documents/domain/entities/domain_entities.dart';
import '../../tasks/presentation/task_draft_prefill.dart';

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
    final document = ref
        .watch(documentProvider(clientDocumentId))
        .asData
        ?.value;
    final body = ref
        .watch(latestAnalysisProvider(clientDocumentId))
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(context.l10n.analysisReadError)),
          data: (analysis) {
            if (analysis == null) {
              return Center(child: Text(context.l10n.noSavedAnalysis));
            }
            final prefill = TaskDraftPrefill.fromAnalysis(
              analysis: analysis,
              clientDocumentId: clientDocumentId,
              caseId:
                  document?.classificationState == ClassificationState.confirmed
                  ? document?.caseId
                  : null,
              l10n: context.l10n,
            );
            final sourceAnalysisId = prefill?.sourceAnalysisId;
            final sourceActionKey = prefill?.sourceActionKey;
            final existingTask =
                sourceAnalysisId == null || sourceActionKey == null
                ? null
                : ref
                      .watch(
                        taskForSourceActionProvider((
                          analysisId: sourceAnalysisId,
                          actionKey: sourceActionKey,
                        )),
                      )
                      .asData
                      ?.value;
            return DocumentResultView(
              title: context.l10n.analysisTitle,
              analysis: analysis,
              onAddTask: prefill == null
                  ? null
                  : () async {
                      final task = await ref
                          .read(taskRepositoryProvider)
                          .findBySourceAction(
                            prefill.sourceAnalysisId!,
                            prefill.sourceActionKey!,
                          );
                      if (!context.mounted) return;
                      GoRouter.of(context).go(
                        task == null
                            ? '${AppRoutes.tasks}/create'
                            : '${AppRoutes.tasks}/edit/${task.id}',
                        extra: task == null ? prefill : null,
                      );
                    },
              taskActionLabel: existingTask == null
                  ? null
                  : context.l10n.viewTask,
            );
          },
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
    this.analysisHistorySection,
    this.originalDocumentSection,
    this.onRetry,
    this.onReplaceDocument,
    this.onAddTask,
    this.taskActionLabel,
    this.actionInProgress = false,
    this.actionMessage,
  }) : assert(analysis != null || technicalFailure);

  final String title;
  final DocumentAnalysis? analysis;
  final bool technicalFailure;
  final Widget? classificationSection;
  final Widget? analysisHistorySection;
  final Widget? originalDocumentSection;
  final VoidCallback? onRetry;
  final VoidCallback? onReplaceDocument;
  final VoidCallback? onAddTask;
  final String? taskActionLabel;
  final bool actionInProgress;
  final String? actionMessage;

  @override
  Widget build(BuildContext context) {
    final state = analysis == null ? null : _resultStateFor(analysis!);
    final recovery =
        technicalFailure ||
        state == _ResultState.unreadable ||
        state == _ResultState.inputProblem;
    final primaryAction =
        !recovery && analysis!.actionRequired == ActionRequirement.yes
        ? _primaryAction(analysis!, context.l10n)
        : null;
    final factSelection = !recovery
        ? _selectFacts(analysis!, context.l10n, primaryAction)
        : const _FactSelection.empty();
    final content = <Widget>[
      _ResultHeader(title: title, showDocumentTitle: !recovery),
      const SizedBox(height: AppSpacing.lg),
    ];
    if (recovery) {
      content.add(
        _RecoveryResult(
          technicalFailure: technicalFailure,
          state: state,
          onRetry: onRetry,
          onReplaceDocument: onReplaceDocument,
          actionInProgress: actionInProgress,
        ),
      );
    } else {
      content.addAll(
        _analysisSections(
          context,
          analysis!,
          primaryAction: primaryAction,
          primaryFacts: factSelection.primary,
          onAddTask: onAddTask,
          taskActionLabel: taskActionLabel,
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
    if (!recovery && classificationSection != null) {
      content.add(const SizedBox(height: AppSpacing.lg));
      content.add(classificationSection!);
    }
    if (analysisHistorySection != null) {
      content.add(const SizedBox(height: AppSpacing.lg));
      content.add(analysisHistorySection!);
    }
    if (!recovery &&
        analysis != null &&
        (_hasExpandableDetails(analysis!, primaryAction) ||
            factSelection.overflow.isNotEmpty)) {
      content.add(const SizedBox(height: AppSpacing.md));
      content.add(
        _AnalysisDetails(
          analysis: analysis!,
          overflowFacts: factSelection.overflow,
          primaryAction: primaryAction,
        ),
      );
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
  required _PrimaryAction? primaryAction,
  required List<_ResultFact> primaryFacts,
  required VoidCallback? onAddTask,
  required String? taskActionLabel,
  required bool actionInProgress,
}) {
  final l = context.l10n;
  final sections = <Widget>[];
  final summary = _meaningful(analysis.summary);
  if (summary != null) {
    sections.add(_TextSection(title: l.summary, body: summary));
  }
  if (summary != null) sections.add(const SizedBox(height: AppSpacing.lg));
  sections.add(
    _ActionSection(
      analysis: analysis,
      primaryAction: primaryAction,
      onAddTask: onAddTask,
      taskActionLabel: taskActionLabel,
      actionInProgress: actionInProgress,
    ),
  );

  if (primaryFacts.isNotEmpty) {
    sections.add(const SizedBox(height: AppSpacing.lg));
    sections.add(_FactsSection(facts: primaryFacts));
  }
  return sections;
}

enum _ResultState {
  actionRequired,
  noAction,
  actionUncertain,
  partial,
  unreadable,
  inputProblem,
}

_ResultState _resultStateFor(DocumentAnalysis analysis) {
  switch (analysis.analysisStatus) {
    case AnalysisStatus.partial:
      return _ResultState.partial;
    case AnalysisStatus.unavailable:
      return _hasCorrectableInputQuality(analysis.qualityReasons)
          ? _ResultState.unreadable
          : _ResultState.inputProblem;
    case AnalysisStatus.complete:
      return switch (analysis.actionRequired) {
        ActionRequirement.yes => _ResultState.actionRequired,
        ActionRequirement.no => _ResultState.noAction,
        ActionRequirement.uncertain || null => _ResultState.actionUncertain,
      };
  }
}

bool _hasCorrectableInputQuality(List<DocumentQualityReason> reasons) =>
    reasons.any(
      (reason) => switch (reason) {
        DocumentQualityReason.blurryImage ||
        DocumentQualityReason.pageCutOff ||
        DocumentQualityReason.unreadableText ||
        DocumentQualityReason.missingPages ||
        DocumentQualityReason.insufficientContent => true,
        DocumentQualityReason.unsupportedFile ||
        DocumentQualityReason.corruptFile => false,
      },
    );

class _ResultHeader extends StatelessWidget {
  const _ResultHeader({required this.title, this.showDocumentTitle = true});
  final String title;
  final bool showDocumentTitle;

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
      if (showDocumentTitle) ...[
        const SizedBox(height: AppSpacing.xs),
        Text(
          title,
          key: const Key('document-result-title'),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 22,
            height: 1.25,
            fontWeight: FontWeight.w600,
          ),
          textDirection: _contentTextDirection(title),
        ),
      ],
    ],
  );
}

class _ActionSection extends StatelessWidget {
  const _ActionSection({
    required this.analysis,
    required this.primaryAction,
    required this.onAddTask,
    required this.taskActionLabel,
    required this.actionInProgress,
  });

  final DocumentAnalysis analysis;
  final _PrimaryAction? primaryAction;
  final VoidCallback? onAddTask;
  final String? taskActionLabel;
  final bool actionInProgress;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = _resultStateFor(analysis);
    final partial = state == _ResultState.partial;
    final panel = switch (state) {
      _ResultState.actionRequired => _StatePanel(
        key: const Key('action-required-state'),
        icon: Icons.priority_high_rounded,
        color: AppColors.errorFor(Theme.of(context).brightness),
        title: l.actionRequired,
        description: primaryAction!.text,
        actionLabel: onAddTask == null
            ? null
            : (taskActionLabel ?? l.createTask),
        onAction: onAddTask,
        actionInProgress: actionInProgress,
        supportingFacts: primaryAction!.facts,
        prominent: true,
      ),
      _ResultState.noAction => _StatePanel(
        key: const Key('no-action-state'),
        icon: Icons.check_circle_outline,
        color: AppColors.successFor(Theme.of(context).brightness),
        title: l.noActionRequiredTitle,
        description: l.noActionRequiredBody,
        compact: true,
      ),
      _ResultState.actionUncertain || _ResultState.partial => _StatePanel(
        key: Key(partial ? 'partial-state' : 'action-uncertain-state'),
        icon: Icons.fact_check_outlined,
        color: AppColors.warningFor(Theme.of(context).brightness),
        title: l.actionUncertainTitle,
        description:
            _firstMeaningful(analysis.uncertainties) ?? l.reviewRequiredBody,
        compact: true,
      ),
      _ResultState.unreadable || _ResultState.inputProblem => const SizedBox(),
    };
    return _Section(title: l.actionQuestion, child: panel);
  }
}

class _RecoveryResult extends StatelessWidget {
  const _RecoveryResult({
    required this.technicalFailure,
    required this.state,
    required this.onRetry,
    required this.onReplaceDocument,
    required this.actionInProgress,
  });

  final bool technicalFailure;
  final _ResultState? state;
  final VoidCallback? onRetry;
  final VoidCallback? onReplaceDocument;
  final bool actionInProgress;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final panel = technicalFailure
        ? _StatePanel(
            key: const Key('technical-failure-state'),
            icon: Icons.sync_problem_outlined,
            color: AppColors.errorFor(Theme.of(context).brightness),
            title: l.technicalFailureTitle,
            description: l.technicalFailureBody,
            actionLabel: onRetry == null ? null : l.retryAnalysis,
            onAction: onRetry,
            actionInProgress: actionInProgress,
            prominent: true,
          )
        : state == _ResultState.inputProblem
        ? _StatePanel(
            key: const Key('input-problem-state'),
            icon: Icons.insert_drive_file_outlined,
            color: AppColors.warningFor(Theme.of(context).brightness),
            title: l.unavailableInputTitle,
            description: l.unavailableInputBody,
            actionLabel: onReplaceDocument == null
                ? null
                : l.chooseAnotherDocument,
            onAction: onReplaceDocument,
            actionInProgress: actionInProgress,
            prominent: true,
          )
        : _StatePanel(
            key: const Key('unreadable-state'),
            icon: Icons.document_scanner_outlined,
            color: AppColors.warningFor(Theme.of(context).brightness),
            title: l.unreadableResultTitle,
            description: l.unreadableResultBody,
            actionLabel: onReplaceDocument == null
                ? null
                : l.chooseClearerDocument,
            onAction: onReplaceDocument,
            actionInProgress: actionInProgress,
            prominent: true,
          );
    return Column(
      key: const Key('result-recovery-composition'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        panel,
        const SizedBox(height: AppSpacing.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                l.documentRetainedMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
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
    this.prominent = false,
    this.supportingFacts = const [],
  });

  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool actionInProgress;
  final bool compact;
  final bool prominent;
  final List<({String label, String value})> supportingFacts;

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
                Icon(icon, color: color, size: prominent ? 24 : 22),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: prominent ? 18 : null,
                    ),
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
            if (supportingFacts.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Column(
                key: const Key('action-required-context'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final fact in supportingFacts)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: Text(
                        '${fact.label}: ${fact.value}',
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                ],
              ),
            ],
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
      key: const Key('document-result-summary'),
      textDirection: _contentTextDirection(body),
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        height: 1.5,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ),
  );
}

class _FactsSection extends StatelessWidget {
  const _FactsSection({required this.facts});
  final List<_ResultFact> facts;

  @override
  Widget build(BuildContext context) => _Section(
    title: context.l10n.importantFacts,
    child: DecoratedBox(
      key: const Key('important-facts-group'),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.75),
        ),
      ),
      child: Column(
        children: [
          for (var index = 0; index < facts.length; index++) ...[
            if (index > 0) const Divider(height: 1),
            Padding(
              key: Key('important-fact-$index'),
              padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    facts[index].icon,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      facts[index].label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      facts[index].value,
                      textAlign: TextAlign.end,
                      textDirection: _contentTextDirection(facts[index].value),
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
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
  const _AnalysisDetails({
    required this.analysis,
    required this.overflowFacts,
    required this.primaryAction,
  });
  final DocumentAnalysis analysis;
  final List<_ResultFact> overflowFacts;
  final _PrimaryAction? primaryAction;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final sections = <Widget>[];
    void addGroup(
      String label,
      Iterable<String?> values, {
      bool paragraph = false,
    }) {
      final meaningful = values.map(_meaningful).whereType<String>().toList();
      if (meaningful.isEmpty) return;
      if (sections.isNotEmpty) {
        sections.add(const SizedBox(height: AppSpacing.xs));
      }
      sections.add(
        AppAccordion(
          key: ValueKey('analysis-detail-$label'),
          title: label,
          child: _DetailGroup(values: meaningful, paragraph: paragraph),
        ),
      );
    }

    addGroup(
      l.analysisDetails,
      overflowFacts.map((fact) => '${fact.label}: ${fact.value}'),
    );
    addGroup(l.explanation, [analysis.explanation], paragraph: true);
    addGroup(
      l.nextActions,
      analysis.nextActions.where((value) => value != primaryAction?.text),
    );
    addGroup(
      l.requiredDocuments,
      analysis.requiredDocuments
          .map((item) => item.description)
          .where((value) => value != primaryAction?.rawText),
    );
    addGroup(
      l.appointments,
      analysis.appointments.map(
        (item) => _detailValue(item.label, item.startOrDate),
      ),
    );
    addGroup(l.pleaseVerify, analysis.uncertainties);
    addGroup(
      l.documentQuality,
      analysis.qualityReasons.map((reason) => _quality(l, reason)),
    );
    addGroup(
      l.suggestedTasks,
      analysis.suggestedTasks
          .map((task) => task.title)
          .where((value) => value != primaryAction?.rawText),
    );
    return Column(
      key: const Key('analysis-details-accordion'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: sections,
    );
  }
}

class _DetailGroup extends StatelessWidget {
  const _DetailGroup({required this.values, required this.paragraph});

  final List<String> values;
  final bool paragraph;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (paragraph)
        for (var index = 0; index < values.length; index++) ...[
          if (index > 0) const SizedBox(height: AppSpacing.md),
          Text(
            values[index],
            key: index == 0 ? const Key('analysis-explanation-text') : null,
            textDirection: _contentTextDirection(values[index]),
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
                    textDirection: _contentTextDirection(value),
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

enum _FactKind { deadline, amount, documentDate, appointment }

class _ResultFact {
  const _ResultFact({
    required this.kind,
    required this.label,
    required this.value,
    required this.icon,
  });

  final _FactKind kind;
  final String label;
  final String value;
  final IconData icon;
}

class _FactSelection {
  const _FactSelection({required this.primary, required this.overflow});
  const _FactSelection.empty() : primary = const [], overflow = const [];

  final List<_ResultFact> primary;
  final List<_ResultFact> overflow;
}

class _PrimaryAction {
  const _PrimaryAction({
    required this.text,
    required this.rawText,
    this.facts = const [],
  });

  final String text;
  final String rawText;
  final List<({String label, String value})> facts;
}

_FactSelection _selectFacts(
  DocumentAnalysis analysis,
  AppLocalizations l,
  _PrimaryAction? primaryAction,
) {
  final facts = <_ResultFact>[];
  for (final deadline in analysis.deadlines) {
    final date = _meaningful(deadline.dateOrRange);
    final label = _meaningful(deadline.label);
    if (date != null) {
      facts.add(
        _ResultFact(
          kind: _FactKind.deadline,
          label: label ?? l.deadline,
          value: date,
          icon: Icons.event_outlined,
        ),
      );
    }
  }
  for (final amount in analysis.amounts) {
    final value = _meaningful(amount.value);
    final currency = _meaningful(amount.currency);
    if (value != null && currency != null) {
      facts.add(
        _ResultFact(
          kind: _FactKind.amount,
          label: _meaningful(amount.purpose) ?? l.amount,
          value: '$value $currency',
          icon: Icons.payments_outlined,
        ),
      );
    }
  }
  final documentDate = _meaningful(analysis.documentDate);
  if (documentDate != null) {
    facts.add(
      _ResultFact(
        kind: _FactKind.documentDate,
        label: l.documentDate,
        value: documentDate,
        icon: Icons.description_outlined,
      ),
    );
  }
  for (final appointment in analysis.appointments) {
    final date = _meaningful(appointment.startOrDate);
    final label = _meaningful(appointment.label);
    if (date != null) {
      facts.add(
        _ResultFact(
          kind: _FactKind.appointment,
          label: label ?? l.appointment,
          value: date,
          icon: Icons.calendar_month_outlined,
        ),
      );
    }
  }

  final actionValues =
      primaryAction?.facts.map((fact) => fact.value).toSet() ??
      const <String>{};
  final complementary = facts
      .where(
        (fact) =>
            (fact.kind != _FactKind.deadline &&
                fact.kind != _FactKind.amount) ||
            !actionValues.contains(fact.value),
      )
      .toList(growable: false);
  return _FactSelection(
    primary: complementary.take(5).toList(growable: false),
    overflow: complementary.skip(5).toList(growable: false),
  );
}

_PrimaryAction _primaryAction(DocumentAnalysis analysis, AppLocalizations l) {
  final nextAction = _firstMeaningful(analysis.nextActions);
  if (nextAction != null) {
    return _PrimaryAction(text: nextAction, rawText: nextAction);
  }
  for (final task in analysis.suggestedTasks) {
    final taskTitle = _meaningful(task.title);
    if (taskTitle != null) {
      return _PrimaryAction(
        text: '${l.suggestedTasks}: $taskTitle',
        rawText: taskTitle,
        facts: _directActionFacts(
          analysis,
          l,
          dueDate: task.dueDate,
          sourceReference: task.sourceReference,
        ),
      );
    }
  }
  for (final document in analysis.requiredDocuments) {
    final description = _meaningful(document.description);
    if (description != null) {
      return _PrimaryAction(
        text: description,
        rawText: description,
        facts: _directActionFacts(
          analysis,
          l,
          dueDate: document.dueDate,
          sourceReference: document.sourceReference,
        ),
      );
    }
  }
  return _PrimaryAction(
    text: l.actionRequiredBody,
    rawText: l.actionRequiredBody,
  );
}

List<({String label, String value})> _directActionFacts(
  DocumentAnalysis analysis,
  AppLocalizations l, {
  String? dueDate,
  String? sourceReference,
}) {
  final facts = <({String label, String value})>[];
  String? matchingDeadline;
  if (sourceReference != null) {
    for (final deadline in analysis.deadlines) {
      if (deadline.sourceReference == sourceReference) {
        matchingDeadline = _meaningful(deadline.dateOrRange);
        if (matchingDeadline != null) break;
      }
    }
  }
  final directDueDate = matchingDeadline ?? _meaningful(dueDate);
  if (directDueDate != null) {
    facts.add((label: l.deadline, value: directDueDate));
  }
  for (final amount in analysis.amounts) {
    if (sourceReference == null || amount.sourceReference != sourceReference) {
      continue;
    }
    final value = _meaningful(amount.value);
    final currency = _meaningful(amount.currency);
    if (value != null && currency != null) {
      facts.add((
        label: _meaningful(amount.purpose) ?? l.amount,
        value: '$value $currency',
      ));
      break;
    }
  }
  return facts;
}

bool _hasExpandableDetails(
  DocumentAnalysis analysis,
  _PrimaryAction? primaryAction,
) =>
    _meaningful(analysis.explanation) != null ||
    analysis.nextActions.any(
      (value) => _meaningful(value) != null && value != primaryAction?.text,
    ) ||
    analysis.requiredDocuments.any(
      (value) =>
          _meaningful(value.description) != null &&
          value.description != primaryAction?.rawText,
    ) ||
    analysis.appointments.any(
      (value) => _meaningful(value.startOrDate) != null,
    ) ||
    analysis.uncertainties.any((value) => _meaningful(value) != null) ||
    analysis.qualityReasons.isNotEmpty ||
    analysis.suggestedTasks.any(
      (value) =>
          _meaningful(value.title) != null &&
          value.title != primaryAction?.rawText,
    );

String? _detailValue(String? label, String? value) {
  final meaningfulValue = _meaningful(value);
  if (meaningfulValue == null) return null;
  final meaningfulLabel = _meaningful(label);
  return meaningfulLabel == null
      ? meaningfulValue
      : '$meaningfulLabel: $meaningfulValue';
}

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

TextDirection? _contentTextDirection(String value) =>
    RegExp(r'[\u0600-\u06ff]').hasMatch(value) ? null : TextDirection.ltr;

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
