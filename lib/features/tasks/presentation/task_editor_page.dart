import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../documents/domain/entities/domain_entities.dart';
import '../../documents/presentation/document_display.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _note = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;
  bool _allDay = false;
  int? _reminderMinutesBefore;
  String? _documentId;
  String? _caseId;
  LocalTask? _existing;
  var _loading = false;
  var _saving = false;

  bool get _editing => widget.taskId != null;

  @override
  void initState() {
    super.initState();
    if (_editing) {
      _load();
    } else {
      _applyPrefill(widget.prefill);
    }
  }

  void _applyPrefill(TaskDraftPrefill? prefill) {
    if (prefill == null) return;
    _title.text = prefill.title;
    _note.text = prefill.note ?? '';
    _date = prefill.dueDate;
    _allDay = prefill.allDay;
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
    final now = DateTime.now();
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
    final valid = _formKey.currentState!.validate();
    if (!valid || _date == null) {
      setState(() {});
      return;
    }
    setState(() => _saving = true);
    final now = DateTime.now();
    final existing = _existing;
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
    await ref.read(taskRepositoryProvider).save(task);
    if (task.sourceAnalysisId != null && task.sourceActionKey != null) {
      await ref
          .read(settingsRepositoryProvider)
          .write(
            'home_attention_handled::${task.sourceAnalysisId}::${task.sourceActionKey}',
            'handled',
          );
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _complete() async {
    await ref
        .read(taskRepositoryProvider)
        .updateStatus(_existing!.id, TaskStatus.completed, DateTime.now());
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _reopen() async {
    await ref
        .read(taskRepositoryProvider)
        .updateStatus(_existing!.id, TaskStatus.open, DateTime.now());
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
    await ref.read(taskRepositoryProvider).delete(_existing!.id);
    if (mounted) Navigator.of(context).pop();
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
      DropdownMenuItem(value: null, child: _DropdownLabel(l10n.noLinkedDocument)),
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
                decoration: InputDecoration(labelText: l10n.taskTitle),
                textInputAction: TextInputAction.next,
                validator: (value) => value == null || value.trim().isEmpty
                    ? l10n.taskTitleRequired
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              _SelectionButton(
                key: const Key('task-date'),
                icon: Icons.calendar_today_outlined,
                label: l10n.date,
                value: _date == null
                    ? l10n.chooseDate
                    : MaterialLocalizations.of(context)
                          .formatMediumDate(_date!),
                onPressed: _pickDate,
              ),
              if (_date == null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: AppSpacing.xs),
                  child: Text(
                    l10n.chooseDate,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              SwitchListTile.adaptive(
                key: const Key('task-all-day'),
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.allDay),
                value: _allDay,
                onChanged: (value) => setState(() {
                  _allDay = value;
                  if (value) _time = null;
                }),
              ),
              _SelectionButton(
                key: const Key('task-time'),
                icon: Icons.schedule_outlined,
                label: l10n.time,
                value: _time == null ? l10n.chooseTime : _time!.format(context),
                onPressed: _allDay ? null : _pickTime,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<int?>(
                key: ValueKey('task-reminder-$_reminderMinutesBefore'),
                initialValue: _reminderMinutesBefore,
                decoration: InputDecoration(labelText: l10n.reminder),
                items: [
                  DropdownMenuItem(value: null, child: Text(l10n.noReminder)),
                  DropdownMenuItem(value: 0, child: Text(l10n.reminderAtTime)),
                  DropdownMenuItem(
                    value: 1440,
                    child: Text(l10n.reminderOneDayBefore),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => _reminderMinutesBefore = value),
              ),
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
                selectedItemBuilder: (context) =>
                    caseItems.map((item) => _DropdownLabel(_dropdownItemLabel(item))).toList(),
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
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onPressed,
    icon: Icon(icon),
    label: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(label), Text(value)],
    ),
    style: OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(52),
      alignment: AlignmentDirectional.centerStart,
    ),
  );
}
