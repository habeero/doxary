import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/logging/debug_log.dart';
import '../../documents/domain/entities/domain_entities.dart';
import '../../documents/presentation/document_display.dart';
import '../application/task_reminder_reconciler.dart';
import 'task_draft_prefill.dart';

class TaskEditorPage extends ConsumerStatefulWidget {
  const TaskEditorPage.create({super.key, this.prefill}) : taskId = null;
  const TaskEditorPage.edit({super.key, required this.taskId}) : prefill = null;

  final String? taskId;
  final TaskDraftPrefill? prefill;

  @override
  ConsumerState<TaskEditorPage> createState() => _TaskEditorPageState();
}

class _TaskEditorPageState extends ConsumerState<TaskEditorPage> {
  static const _pairedControlsMinWidth = 320.0;
  static const _pairedControlsMaxTextSize = 19.0;

  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _note = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;
  bool _allDay = false;
  // New Tasks default to an explicit at-time reminder. Edit loads the
  // persisted nullable value and therefore preserves existing intent.
  int? _reminderMinutesBefore = 0;
  String? _documentId;
  String? _caseId;
  LocalTask? _existing;
  var _loading = false;
  var _saving = false;
  var _validationAttempted = false;

  bool get _editing => widget.taskId != null;

  @override
  void initState() {
    super.initState();
    if (_editing) {
      _load();
    } else {
      _applyPrefill(widget.prefill);
      reminderDebugLog(
        'task_editor_init',
        'mode=create prefill=${widget.prefill != null} allDay=$_allDay '
            'timeEnabled=${!_allDay} timePresent=${_time != null} '
            'reminder=$_reminderMinutesBefore',
      );
    }
  }

  void _applyPrefill(TaskDraftPrefill? prefill) {
    if (prefill == null) return;
    _title.text = prefill.title;
    _note.text = prefill.note ?? '';
    _date = prefill.dueDate;
    // Result drafts can suggest a date/time, but do not carry All Day intent.
    // Every new Task starts timed; All Day requires an explicit editor action.
    _allDay = false;
    _time = prefill.dueTimeMinutes == null
        ? null
        : TimeOfDay(
            hour: prefill.dueTimeMinutes! ~/ 60,
            minute: prefill.dueTimeMinutes! % 60,
          );
    _documentId = prefill.clientDocumentId;
    _caseId = prefill.caseId;
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final task = await ref.read(taskRepositoryProvider).getById(widget.taskId!);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _existing = task;
      if (task == null) return;
      _title.text = task.title;
      _note.text = task.note ?? '';
      _date = task.dueAt;
      _allDay = task.allDay;
      _time = task.dueTimeMinutes == null
          ? null
          : TimeOfDay(
              hour: task.dueTimeMinutes! ~/ 60,
              minute: task.dueTimeMinutes! % 60,
            );
      _reminderMinutesBefore = task.reminderMinutesBefore;
      _documentId = task.clientDocumentId;
      _caseId = task.caseId;
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = ref.read(currentTimeProvider);
    final value = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 20),
    );
    if (value != null && mounted) setState(() => _date = value);
  }

  Future<void> _pickTime() async {
    final value = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (value != null && mounted) setState(() => _time = value);
  }

  Future<void> _save() async {
    setState(() => _validationAttempted = true);
    final valid = _formKey.currentState!.validate();
    if (!valid || _date == null || (!_allDay && _time == null)) {
      return;
    }
    setState(() => _saving = true);
    final now = DateTime.now();
    final existing = _existing;
    reminderTaskStateDebugLog(
      'task_editor',
      event: 'save state',
      reminderMinutesBefore: _reminderMinutesBefore,
      allDay: _allDay,
      timePresent: _time != null,
      status: (existing?.status ?? TaskStatus.open).name,
    );
    final task = LocalTask(
      id: existing?.id ?? ref.read(idGeneratorProvider).newId(),
      title: _title.text.trim(),
      status: existing?.status ?? TaskStatus.open,
      provenance: existing?.provenance ?? TaskProvenance.user,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
      dueAt: DateTime(_date!.year, _date!.month, _date!.day),
      allDay: _allDay,
      dueTimeMinutes: _allDay || _time == null
          ? null
          : _time!.hour * 60 + _time!.minute,
      reminderMinutesBefore: _reminderMinutesBefore,
      note: _note.text.trim().isEmpty ? null : _note.text.trim(),
      clientDocumentId: _documentId,
      caseId: _caseId,
      sourceAnalysisId:
          existing?.sourceAnalysisId ?? widget.prefill?.sourceAnalysisId,
      sourceActionKey:
          existing?.sourceActionKey ?? widget.prefill?.sourceActionKey,
    );
    reminderTaskStateDebugLog(
      'task_editor',
      event: 'save payload',
      reminderMinutesBefore: task.reminderMinutesBefore,
      allDay: task.allDay,
      timePresent: task.dueTimeMinutes != null,
      status: task.status.name,
    );
    await ref.read(taskRepositoryProvider).save(task);
    reminderDebugLog('task_save', 'persistence returned');
    reminderDebugLog('task_save', 'reconciliation started');
    final reminderOutcome = await ref
        .read(taskReminderReconcilerProvider)
        .reconcile(task);
    reminderDebugLog(
      'task_save',
      'reconciliation outcome=${reminderOutcome.name}',
    );
    if (task.sourceAnalysisId != null && task.sourceActionKey != null) {
      await ref
          .read(settingsRepositoryProvider)
          .write(
            'home_attention_handled::${task.sourceAnalysisId}::${task.sourceActionKey}',
            'handled',
          );
    }
    if (!mounted) return;
    _showReminderFeedback(reminderOutcome);
    Navigator.of(context).pop();
  }

  Future<void> _complete() async {
    await ref
        .read(taskLifecycleProvider)
        .complete(_existing!, ref.read(currentTimeProvider));
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _reopen() async {
    await ref
        .read(taskLifecycleProvider)
        .reopen(_existing!, ref.read(currentTimeProvider));
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteTaskTitle),
        content: Text(l10n.deleteTaskMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.deleteTask),
          ),
        ],
      ),
    );
    if (confirmed != true || _existing == null) return;
    await ref.read(taskLifecycleProvider).delete(_existing!);
    if (mounted) Navigator.of(context).pop();
  }

  void _showReminderFeedback(TaskReminderOutcome outcome) {
    final l10n = context.l10n;
    final message = switch (outcome) {
      TaskReminderOutcome.permissionDenied => l10n.reminderPermissionDenied,
      TaskReminderOutcome.unavailable => l10n.reminderUnavailable,
      TaskReminderOutcome.platformFailure => l10n.reminderNotScheduled,
      TaskReminderOutcome.reminderTimePassed => l10n.reminderTimePassed,
      TaskReminderOutcome.globallyDisabled => null,
      _ => null,
    };
    if (message != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Widget _buildDateTimeControls(BuildContext context, AppLocalizations l10n) =>
      LayoutBuilder(
        builder: (context, constraints) {
          final useRow = _usesHorizontalControls(context, constraints.maxWidth);
          final date = _SelectionButton(
            key: const Key('task-date'),
            icon: Icons.calendar_today_outlined,
            label: l10n.date,
            value: _date == null
                ? l10n.chooseDate
                : MaterialLocalizations.of(context).formatMediumDate(_date!),
            onPressed: _pickDate,
          );
          final time = _SelectionButton(
            key: const Key('task-time'),
            icon: Icons.schedule_outlined,
            label: l10n.time,
            value: _time == null ? l10n.chooseTime : _time!.format(context),
            onPressed: _allDay ? null : _pickTime,
          );
          final dateControl = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              date,
              if (_validationAttempted && _date == null)
                _ValidationHint(text: l10n.dateRequired),
            ],
          );
          final timeControl = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              time,
              if (_validationAttempted && !_allDay && _time == null)
                _ValidationHint(text: l10n.timeRequired),
            ],
          );
          final controls = useRow
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 11, child: dateControl),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(flex: 9, child: timeControl),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    dateControl,
                    const SizedBox(height: AppSpacing.sm),
                    timeControl,
                  ],
                );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [controls],
          );
        },
      );

  Widget _buildAllDayReminderControls(
    BuildContext context,
    AppLocalizations l10n,
  ) => LayoutBuilder(
    builder: (context, constraints) {
      final useRow = _usesHorizontalControls(context, constraints.maxWidth);
      final allDay = SwitchListTile.adaptive(
        key: const Key('task-all-day'),
        contentPadding: EdgeInsets.zero,
        dense: true,
        title: Text(l10n.allDay),
        value: _allDay,
        onChanged: (value) => setState(() {
          _allDay = value;
          if (value) _time = null;
        }),
      );
      final reminder = DropdownButtonFormField<_ReminderOption>(
        key: const Key('task-reminder'),
        initialValue: _ReminderOption.fromMinutes(_reminderMinutesBefore),
        isExpanded: true,
        decoration: InputDecoration(labelText: l10n.reminder),
        items: _ReminderOption.values
            .map(
              (option) => DropdownMenuItem<_ReminderOption>(
                key: Key('task-reminder-option-${option.name}'),
                value: option,
                child: _DropdownLabel(option.label(l10n)),
              ),
            )
            .toList(),
        selectedItemBuilder: (context) => _ReminderOption.values
            .map((option) => _DropdownLabel(option.label(l10n)))
            .toList(),
        onChanged: (option) {
          if (option == null) return;
          final reminderMinutesBefore = option.reminderMinutesBefore;
          reminderDebugLog(
            'task_editor',
            'reminder selection changed '
                'reminderPresent=${reminderMinutesBefore != null} '
                'reminderMinutesBefore=$reminderMinutesBefore',
          );
          setState(() => _reminderMinutesBefore = reminderMinutesBefore);
        },
      );
      return useRow
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Keep enough width for the compact switch and its label.
                // The reminder field remains slightly wider for localized
                // option labels and the dropdown affordance.
                Expanded(flex: 9, child: allDay),
                const SizedBox(width: AppSpacing.sm),
                Expanded(flex: 11, child: reminder),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                allDay,
                const SizedBox(height: AppSpacing.sm),
                reminder,
              ],
            );
    },
  );

  bool _usesHorizontalControls(BuildContext context, double width) {
    final textScaler = MediaQuery.textScalerOf(context);
    return width >= _pairedControlsMinWidth &&
        textScaler.scale(16) <= _pairedControlsMaxTextSize;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final documents =
        ref.watch(allDocumentsProvider).asData?.value ??
        const <LocalDocument>[];
    final cases = ref.watch(casesProvider).asData?.value ?? const <Case>[];
    final documentLabels = <String, String>{
      for (final document in documents)
        document.clientDocumentId: documentDisplayTitle(
          document,
          l10n,
          analysis: ref
              .watch(latestAnalysisProvider(document.clientDocumentId))
              .asData
              ?.value,
          file: _firstOrNull(
            ref
                    .watch(documentFilesProvider(document.clientDocumentId))
                    .asData
                    ?.value ??
                const <DocumentFile>[],
          ),
        ),
    };
    final documentItems = <DropdownMenuItem<String?>>[
      DropdownMenuItem(
        value: null,
        child: _DropdownLabel(l10n.noLinkedDocument),
      ),
      ...documents.map(
        (document) => DropdownMenuItem<String?>(
          value: document.clientDocumentId,
          child: _DropdownLabel(documentLabels[document.clientDocumentId]!),
        ),
      ),
      if (_documentId != null && !documentLabels.containsKey(_documentId))
        DropdownMenuItem<String?>(
          value: _documentId,
          child: _DropdownLabel(l10n.documentFallback),
        ),
    ];
    final caseItems = <DropdownMenuItem<String?>>[
      DropdownMenuItem(value: null, child: _DropdownLabel(l10n.noLinkedCase)),
      ...cases.map(
        (item) => DropdownMenuItem<String?>(
          value: item.id,
          child: _DropdownLabel(
            item.title.trim().isEmpty ? l10n.caseNotAssigned : item.title,
          ),
        ),
      ),
      if (_caseId != null && !cases.any((item) => item.id == _caseId))
        DropdownMenuItem<String?>(
          value: _caseId,
          child: _DropdownLabel(l10n.caseNotAssigned),
        ),
    ];
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: Text(_editing ? l10n.editTask : l10n.createTask)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              TextFormField(
                key: const Key('task-title'),
                controller: _title,
                decoration: InputDecoration(labelText: '${l10n.taskTitle} *'),
                textInputAction: TextInputAction.next,
                validator: (value) => value == null || value.trim().isEmpty
                    ? l10n.taskTitleRequired
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildDateTimeControls(context, l10n),
              const SizedBox(height: AppSpacing.md),
              _buildAllDayReminderControls(context, l10n),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String?>(
                key: ValueKey('task-document-$_documentId'),
                initialValue: _documentId,
                isExpanded: true,
                decoration: InputDecoration(labelText: l10n.linkedDocument),
                items: documentItems,
                selectedItemBuilder: (context) => documentItems
                    .map((item) => _DropdownLabel(_dropdownItemLabel(item)))
                    .toList(),
                onChanged: (value) => setState(() => _documentId = value),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String?>(
                key: ValueKey('task-case-$_caseId'),
                initialValue: _caseId,
                isExpanded: true,
                decoration: InputDecoration(labelText: l10n.linkedCase),
                items: caseItems,
                selectedItemBuilder: (context) => caseItems
                    .map((item) => _DropdownLabel(_dropdownItemLabel(item)))
                    .toList(),
                onChanged: (value) => setState(() => _caseId = value),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                key: const Key('task-note'),
                controller: _note,
                minLines: 3,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: '${l10n.note} (${l10n.optional})',
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                key: const Key('task-save'),
                onPressed: _saving ? null : _save,
                child: Text(l10n.save),
              ),
              if (_editing && _existing != null) ...[
                const SizedBox(height: AppSpacing.md),
                OutlinedButton(
                  key: Key(
                    _existing!.status == TaskStatus.completed
                        ? 'task-reopen'
                        : 'task-complete',
                  ),
                  onPressed: _existing!.status == TaskStatus.completed
                      ? _reopen
                      : _complete,
                  child: Text(
                    _existing!.status == TaskStatus.completed
                        ? l10n.reopenTask
                        : l10n.markCompleted,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  key: const Key('task-delete'),
                  onPressed: _delete,
                  child: Text(
                    l10n.deleteTask,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

T? _firstOrNull<T>(List<T> values) => values.isEmpty ? null : values.first;

/// Presentation-only option mapping. The editor's only reminder state remains
/// [_TaskEditorPageState._reminderMinutesBefore].
enum _ReminderOption {
  none(null),
  atTime(0),
  fiveMinutes(5),
  tenMinutes(10),
  thirtyMinutes(30),
  oneHour(60),
  oneDay(1440);

  const _ReminderOption(this.reminderMinutesBefore);

  final int? reminderMinutesBefore;

  static _ReminderOption fromMinutes(int? value) =>
      _ReminderOption.values.firstWhere(
        (option) => option.reminderMinutesBefore == value,
        orElse: () => _ReminderOption.none,
      );

  String label(AppLocalizations l10n) => switch (this) {
    _ReminderOption.none => l10n.noReminder,
    _ReminderOption.atTime => l10n.reminderAtTime,
    _ReminderOption.fiveMinutes => l10n.reminderFiveMinutesBefore,
    _ReminderOption.tenMinutes => l10n.reminderTenMinutesBefore,
    _ReminderOption.thirtyMinutes => l10n.reminderThirtyMinutesBefore,
    _ReminderOption.oneHour => l10n.reminderOneHourBefore,
    _ReminderOption.oneDay => l10n.reminderOneDayBefore,
  };
}

String _dropdownItemLabel(DropdownMenuItem<String?> item) =>
    (item.child as _DropdownLabel).label;

class _DropdownLabel extends StatelessWidget {
  const _DropdownLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    softWrap: false,
  );
}

class _ValidationHint extends StatelessWidget {
  const _ValidationHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(top: AppSpacing.xs),
    child: Text(
      text,
      style: TextStyle(color: Theme.of(context).colorScheme.error),
    ),
  );
}

class _SelectionButton extends StatelessWidget {
  const _SelectionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onPressed,
  });
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(56),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      alignment: AlignmentDirectional.centerStart,
    ),
    child: Row(
      children: [
        Icon(icon),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(value, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    ),
  );
}
