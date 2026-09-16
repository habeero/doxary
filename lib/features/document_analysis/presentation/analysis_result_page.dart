import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/design_system/app_widgets.dart';
import '../../documents/domain/entities/domain_entities.dart';

class AnalysisResultPage extends ConsumerWidget {
  const AnalysisResultPage({required this.clientDocumentId, super.key});
  final String clientDocumentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(_t(context, 'Analysis', 'التحليل'))),
      body: ref
          .watch(latestAnalysisProvider(clientDocumentId))
          .when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Text(
                _t(
                  context,
                  'The saved analysis could not be read.',
                  'تعذر قراءة التحليل المحفوظ.',
                ),
              ),
            ),
            data: (analysis) => analysis == null
                ? Center(
                    child: Text(
                      _t(
                        context,
                        'No saved analysis yet.',
                        'لا يوجد تحليل محفوظ بعد.',
                      ),
                    ),
                  )
                : _ResultBody(analysis: analysis),
          ),
    );
  }
}

class _ResultBody extends StatelessWidget {
  const _ResultBody({required this.analysis});
  final DocumentAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      _StatusCard(analysis: analysis),
      if (analysis.classification != null)
        _Section(
          title: _t(context, 'Suggestion', 'اقتراح'),
          children: [
            Text(analysis.classification!.organizationName ?? ''),
            if (analysis.classification!.documentType != null)
              Text(analysis.classification!.documentType!),
          ],
        ),
      if (analysis.summary != null || analysis.explanation != null)
        _Section(
          title: _t(context, 'Explanation', 'الشرح'),
          children: [
            Text(
              '${_t(context, 'Output style', 'أسلوب الإخراج')}: ${_style(context, analysis.explanationStyle)}',
            ),
            if (analysis.summary != null)
              Text(
                analysis.summary!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            if (analysis.explanation != null) Text(analysis.explanation!),
          ],
        ),
      if (analysis.actionRequired != ActionRequirement.uncertain ||
          analysis.urgency != AnalysisUrgency.uncertain)
        _Section(
          title: _t(context, 'What to do', 'ما الذي يجب فعله'),
          children: [
            Text(
              '${_t(context, 'Action required', 'الإجراء مطلوب')}: ${_action(context, analysis.actionRequired)}',
            ),
            Text(
              '${_t(context, 'Urgency', 'الأولوية')}: ${_urgency(context, analysis.urgency)}',
            ),
          ],
        ),
      if (analysis.deadlines.isNotEmpty)
        _Section(
          title: _t(context, 'Deadlines', 'المواعيد النهائية'),
          children: analysis.deadlines
              .map((value) => Text('${value.label}: ${value.dateOrRange}'))
              .toList(),
        ),
      if (analysis.appointments.isNotEmpty)
        _Section(
          title: _t(context, 'Appointments', 'المواعيد'),
          children: analysis.appointments
              .map((value) => Text('${value.label}: ${value.startOrDate}'))
              .toList(),
        ),
      if (analysis.amounts.isNotEmpty)
        _Section(
          title: _t(context, 'Amounts', 'المبالغ'),
          children: analysis.amounts
              .map((value) => Text('${value.value} ${value.currency}'))
              .toList(),
        ),
      if (analysis.requiredDocuments.isNotEmpty)
        _Section(
          title: _t(context, 'Required documents', 'المستندات المطلوبة'),
          children: analysis.requiredDocuments
              .map((value) => Text(value.description))
              .toList(),
        ),
      if (analysis.nextActions.isNotEmpty)
        _Section(
          title: _t(context, 'Next actions', 'الخطوات التالية'),
          children: analysis.nextActions.map(Text.new).toList(),
        ),
      if (analysis.qualityReasons.isNotEmpty)
        _Section(
          title: _t(context, 'Document quality', 'جودة المستند'),
          children: analysis.qualityReasons
              .map((value) => Text(_quality(context, value)))
              .toList(),
        ),
      if (analysis.uncertainties.isNotEmpty)
        _Section(
          title: _t(context, 'Please verify', 'يرجى التحقق'),
          children: analysis.uncertainties.map(Text.new).toList(),
        ),
      if (analysis.sourceReferences.isNotEmpty)
        _Section(
          title: _t(context, 'Evidence', 'المصادر'),
          children: [
            Text(
              '${analysis.sourceReferences.length} ${_t(context, 'source reference(s)', 'مرجع')}',
            ),
          ],
        ),
    ];
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
      _status(context, analysis.analysisStatus),
      style: Theme.of(context).textTheme.titleLarge,
    ),
  );
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Padding(
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
}

String _t(BuildContext context, String de, String ar) =>
    Localizations.localeOf(context).languageCode == 'ar' ? ar : de;
String _style(BuildContext context, ExplanationStyle value) => switch (value) {
  ExplanationStyle.standard => _t(context, 'Standard', 'قياسي'),
  ExplanationStyle.simple => _t(context, 'Simple', 'بسيط'),
};
String _status(BuildContext context, AnalysisStatus value) => switch (value) {
  AnalysisStatus.complete => _t(context, 'Complete', 'مكتمل'),
  AnalysisStatus.partial => _t(
    context,
    'Partial — please verify the details.',
    'جزئي — يرجى التحقق من التفاصيل.',
  ),
  AnalysisStatus.unavailable => _t(
    context,
    'Analysis unavailable.',
    'التحليل غير متاح.',
  ),
};
String _action(BuildContext context, ActionRequirement value) =>
    switch (value) {
      ActionRequirement.yes => _t(context, 'Yes', 'نعم'),
      ActionRequirement.no => _t(context, 'No', 'لا'),
      ActionRequirement.uncertain => _t(context, 'Uncertain', 'غير مؤكد'),
    };
String _urgency(BuildContext context, AnalysisUrgency value) => switch (value) {
  AnalysisUrgency.low => _t(context, 'Low', 'منخفض'),
  AnalysisUrgency.normal => _t(context, 'Normal', 'عادي'),
  AnalysisUrgency.high => _t(context, 'High', 'مرتفع'),
  AnalysisUrgency.critical => _t(context, 'Critical', 'حرج'),
  AnalysisUrgency.uncertain => _t(context, 'Uncertain', 'غير مؤكد'),
};
String _quality(BuildContext context, DocumentQualityReason value) =>
    switch (value) {
      DocumentQualityReason.blurryImage => _t(
        context,
        'The image may be blurry.',
        'قد تكون الصورة غير واضحة.',
      ),
      DocumentQualityReason.pageCutOff => _t(
        context,
        'A page may be cut off.',
        'قد تكون الصفحة مقصوصة.',
      ),
      DocumentQualityReason.unreadableText => _t(
        context,
        'Some text is unreadable.',
        'بعض النص غير مقروء.',
      ),
      DocumentQualityReason.missingPages => _t(
        context,
        'Pages may be missing.',
        'قد تكون هناك صفحات مفقودة.',
      ),
      DocumentQualityReason.unsupportedFile => _t(
        context,
        'The file format is unsupported.',
        'صيغة الملف غير مدعومة.',
      ),
      DocumentQualityReason.corruptFile => _t(
        context,
        'The file may be damaged.',
        'قد يكون الملف تالفاً.',
      ),
      DocumentQualityReason.insufficientContent => _t(
        context,
        'There may not be enough content.',
        'قد لا يكون المحتوى كافياً.',
      ),
    };
