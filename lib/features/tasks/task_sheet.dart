import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notedwork/core/dates.dart';
import 'package:notedwork/core/models.dart';
import 'package:notedwork/core/reminders.dart';
import 'package:notedwork/core/state/state.dart';
import 'package:notedwork/features/tasks/task_widgets.dart';
import 'package:notedwork/l10n/app_localizations.dart';

const List<int> reminderValues = <int>[0, 180, 300, 600, 1440];

String reminderChipLabel(int mins, AppLocalizations l10n) {
  if (mins <= 0) return l10n.reminder_off;
  if (mins % 60 != 0) return '$mins${l10n.reminder_min}';
  final h = mins ~/ 60;
  if (h < 24) return '$h${h == 1 ? l10n.reminder_hour : l10n.reminder_hours}';
  return '${h ~/ 24}${l10n.reminder_day}';
}

Future<void> showTaskSheet(BuildContext context, {Task? initial}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) =>
        SafeArea(top: false, child: TaskSheet(initial: initial)),
  );
}

Future<bool> confirmTaskDelete(BuildContext context, Task task) async {
  final l10n = AppLocalizations.of(context);
  final title = task.title.trim();
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.confirm_title),
      content: Text(l10n.confirm_desc(title.isEmpty ? task.id : title)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.common_cancel),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: nwSemantic(context).red),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.common_delete),
        ),
      ],
    ),
  );
  return ok ?? false;
}

class TaskSheet extends ConsumerStatefulWidget {
  const TaskSheet({super.key, this.initial});

  final Task? initial;

  @override
  ConsumerState<TaskSheet> createState() => _TaskSheetState();
}

class _TaskSheetState extends ConsumerState<TaskSheet> {
  late final TextEditingController _matkulCtrl;
  late final FocusNode _matkulFocus;
  late final TextEditingController _titleCtrl;
  late final TextEditingController _noteCtrl;
  late final TextEditingController _dateCtrl;
  late final TextEditingController _timeCtrl;

  late String _date;
  late String _time;
  late Prio _prio;
  late int _reminderMin;

  String? _matkulErr;
  String? _titleErr;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final t = widget.initial;
    _matkulCtrl = TextEditingController(text: t?.matkul ?? '');
    _matkulFocus = FocusNode();
    _titleCtrl = TextEditingController(text: t?.title ?? '');
    _noteCtrl = TextEditingController(text: t?.note ?? '');
    _date = t?.date ?? ref.read(selectedDateProvider);
    _time = t?.time ?? '';
    _prio = t?.prio ?? Prio.medium;
    _reminderMin = t?.reminderMin ?? defaultReminderMin;
    _dateCtrl = TextEditingController(text: _date);
    _timeCtrl = TextEditingController(text: _time);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dateCtrl.text = _dateLabel();
  }

  String _dateLabel() {
    final parsed = DateTime.tryParse(_date);
    if (parsed == null) return _date;
    return MaterialLocalizations.of(context).formatCompactDate(parsed);
  }

  @override
  void dispose() {
    _matkulCtrl.dispose();
    _matkulFocus.dispose();
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    super.dispose();
  }

  bool get _editing => widget.initial != null;

  Future<void> _pickDate() async {
    final initial = DateTime.tryParse(_date);
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: (initial == null || initial.isBefore(DateTime(2020)))
          ? now
          : initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _date =
          '${picked.year.toString().padLeft(4, '0')}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.day.toString().padLeft(2, '0')}';
      _dateCtrl.text = _dateLabel();
    });
  }

  Future<void> _pickTime() async {
    final match = RegExp(r'^(\d{2}):(\d{2})$').firstMatch(_time);
    final initial = match == null
        ? const TimeOfDay(hour: 23, minute: 59)
        : TimeOfDay(
            hour: int.parse(match.group(1)!),
            minute: int.parse(match.group(2)!),
          );
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null || !mounted) return;
    setState(() {
      _time =
          '${picked.hour.toString().padLeft(2, '0')}:'
          '${picked.minute.toString().padLeft(2, '0')}';
      _timeCtrl.text = _time;
    });
  }

  void _clearTime() {
    setState(() {
      _time = '';
      _timeCtrl.text = '';
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    final l10n = AppLocalizations.of(context);
    final matkul = _matkulCtrl.text.trim();
    final title = _titleCtrl.text.trim();
    final matkulErr = matkul.isEmpty ? l10n.task_coursePh : null;
    final titleErr = title.isEmpty ? l10n.task_titleRequired : null;
    if (matkulErr != null || titleErr != null) {
      setState(() {
        _matkulErr = matkulErr;
        _titleErr = titleErr;
      });
      return;
    }
    setState(() => _saving = true);
    final task = Task(
      id: widget.initial?.id ?? uid('t'),
      matkul: matkul,
      title: title,
      date: _date,
      time: _time.isEmpty ? '23:59' : _time,
      prio: _prio,
      note: _noteCtrl.text.trim(),
      done: widget.initial?.done ?? false,
      reminderMin: _reminderMin,
    );
    ref.read(tasksProvider.notifier).upsert(task);
    if (!mounted) return;
    nwToast(context, _editing ? l10n.toast_taskUpdated : l10n.toast_taskSaved);
    Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final task = widget.initial;
    if (task == null) return;
    final ok = await confirmTaskDelete(context, task);
    if (!ok || !mounted) return;
    ref.read(tasksProvider.notifier).remove(task.id);
    if (!mounted) return;
    nwToast(context, AppLocalizations.of(context).toast_taskDeleted);
    Navigator.of(context).pop();
  }

  Widget _label(String text, {String? suffix}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text.rich(
        TextSpan(
          text: text,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
          children: [
            if (suffix != null)
              TextSpan(
                text: ' $suffix',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: nwExt(context).muted,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = nwExt(context);
    final theme = Theme.of(context);
    final lang = ref.watch(settingsProvider).lang;
    final semantic = nwSemantic(context);
    final courses = <String>{
      for (final r in ref.watch(routinesProvider))
        if (r.course.trim().isNotEmpty) r.course.trim(),
    };

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  _editing ? Icons.edit_outlined : Icons.add_task_outlined,
                  size: 18,
                  color: ext.accent,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _editing ? l10n.task_editTitle : l10n.task_addTitle,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 17),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              l10n.task_hint,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12.5,
                color: ext.muted,
              ),
            ),
            _label(l10n.task_fieldCourse),
            Autocomplete<String>(
              textEditingController: _matkulCtrl,
              focusNode: _matkulFocus,
              optionsBuilder: (value) {
                final query = value.text.trim().toLowerCase();
                if (query.isEmpty) return const <String>[];
                return courses
                    .where((c) => c.toLowerCase().contains(query))
                    .toList();
              },
              fieldViewBuilder: (context, controller, focusNode, _) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  maxLength: 60,
                  onChanged: (_) {
                    if (_matkulErr != null) {
                      setState(() => _matkulErr = null);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: l10n.task_coursePh,
                    errorText: _matkulErr,
                    errorMaxLines: 2,
                    counterText: '',
                  ),
                );
              },
            ),
            _label(l10n.task_fieldTitle),
            TextField(
              controller: _titleCtrl,
              maxLength: 100,
              onChanged: (_) {
                if (_titleErr != null) setState(() => _titleErr = null);
              },
              decoration: InputDecoration(
                hintText: l10n.task_titlePh,
                errorText: _titleErr,
                errorMaxLines: 2,
                counterText: '',
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(l10n.task_fieldDate),
                      TextField(
                        controller: _dateCtrl,
                        readOnly: true,
                        onTap: _pickDate,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(l10n.task_fieldTime, suffix: l10n.common_optional),
                      TextField(
                        controller: _timeCtrl,
                        readOnly: true,
                        onTap: _pickTime,
                        decoration: InputDecoration(
                          hintText: '--:--',
                          suffixIcon: _time.isEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.schedule, size: 18),
                                  onPressed: _pickTime,
                                )
                              : IconButton(
                                  icon: const Icon(Icons.clear, size: 18),
                                  onPressed: _clearTime,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                l10n.task_timeHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 12.5,
                  color: ext.muted,
                ),
              ),
            ),
            _label(l10n.task_fieldPrio),
            DropdownButtonFormField<Prio>(
              initialValue: _prio,
              items: [
                for (final p in Prio.values)
                  DropdownMenuItem<Prio>(
                    value: p,
                    child: Text(prioLabel(p, lang)),
                  ),
              ],
              onChanged: (v) => setState(() => _prio = v ?? Prio.medium),
            ),
            _label(l10n.task_fieldNote),
            TextField(
              controller: _noteCtrl,
              maxLength: 140,
              decoration: InputDecoration(
                hintText: l10n.task_notePh,
                counterText: '',
              ),
            ),
            _label(l10n.reminder_title),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final v in reminderValues)
                  nwChip(
                    context,
                    label: reminderChipLabel(v, l10n),
                    selected: _reminderMin == v,
                    onTap: () => setState(() => _reminderMin = v),
                  ),
              ],
            ),
            if (_editing) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: semantic.red),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: Text(l10n.common_delete),
                  onPressed: _saving ? null : _delete,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saving
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text(l10n.common_close),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: _saving ? null : _save,
                    child: Text(
                      _saving
                          ? l10n.task_saving
                          : _editing
                          ? l10n.task_saveChanges
                          : l10n.common_save,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
