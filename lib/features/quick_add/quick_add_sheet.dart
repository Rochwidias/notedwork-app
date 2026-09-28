import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notedwork/core/dates.dart';
import 'package:notedwork/core/models.dart';
import 'package:notedwork/core/reminders.dart';
import 'package:notedwork/core/state/state.dart';
import 'package:notedwork/core/theme/palette.dart';
import 'package:notedwork/features/tasks/task_widgets.dart';
import 'package:notedwork/l10n/app_localizations.dart';

/// Nilai pengingat chip — web: `REMINDER_VALUES` [Mati, 3/5/10 jam, 1 hari].
const List<int> _reminderValues = <int>[0, 180, 300, 600, 1440];

/// Label chip pengingat — web: `reminderChipLabel`.
String _reminderChipLabel(int mins, AppLocalizations l10n) {
  if (mins <= 0) return l10n.reminder_off;
  if (mins % 60 != 0) return '$mins${l10n.reminder_min}';
  final h = mins ~/ 60;
  if (h < 24) return '$h${h == 1 ? l10n.reminder_hour : l10n.reminder_hours}';
  return '${h ~/ 24}${l10n.reminder_day}';
}

String _minutesToHHMM(int mins) =>
    '${(mins ~/ 60).toString().padLeft(2, '0')}:'
    '${(mins % 60).toString().padLeft(2, '0')}';

/// Wizard Tambah Cepat (web: `QuickAddSheet`) — entry kontekstual memakai
/// [kind] ('tugas' | 'jadwal' | 'catatan'; selain itu default tugas).
Future<void> showQuickAdd(BuildContext context, {String? kind}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) =>
        SafeArea(top: false, child: QuickAddSheet(initialKind: kind)),
  );
}

enum _Kind { task, sched, note }

class QuickAddSheet extends ConsumerStatefulWidget {
  const QuickAddSheet({super.key, this.initialKind});

  final String? initialKind;

  @override
  ConsumerState<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends ConsumerState<QuickAddSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _detailCtrl;
  late final TextEditingController _matkulCtrl;
  late final TextEditingController _dateCtrl;
  late final TextEditingController _endCtrl;

  int _step = 1;
  late _Kind _kind;
  late String _date;
  int _timeMins = 540;
  String _endTime = '';
  Prio _prio = Prio.medium;
  int _reminderMin = defaultReminderMin;
  int _colorIndex = 0;

  String? _titleErr;
  String? _detailErr;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _kind = switch (widget.initialKind) {
      'jadwal' || 'sched' => _Kind.sched,
      'catatan' || 'note' => _Kind.note,
      _ => _Kind.task,
    };
    _date = ref.read(selectedDateProvider);
    _titleCtrl = TextEditingController();
    _detailCtrl = TextEditingController();
    _matkulCtrl = TextEditingController();
    _dateCtrl = TextEditingController(text: _date);
    _endCtrl = TextEditingController();
    // Warna default baru = RCOL[n] persis web (`NotedworkApp.saveSched`).
    final scheds = ref.read(schedsProvider);
    _colorIndex = NwPalette.scheduleColors.indexOf(
      NwPalette.routineColors[scheds.length % NwPalette.routineColors.length],
    );
    if (_colorIndex < 0) _colorIndex = 0;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _detailCtrl.dispose();
    _matkulCtrl.dispose();
    _dateCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncDateLabel();
  }

  void _syncDateLabel() {
    final parsed = DateTime.tryParse(_date);
    _dateCtrl.text = parsed == null
        ? _date
        : MaterialLocalizations.of(context).formatCompactDate(parsed);
  }

  bool get _titleOk => _titleCtrl.text.trim().isNotEmpty;

  bool get _atFinal => _kind == _Kind.note || _step == 2;

  String get _hint => _step == 1
      ? AppLocalizations.of(context).quick_step1
      : AppLocalizations.of(context).quick_step2;

  void _next() {
    final l10n = AppLocalizations.of(context);
    if (_titleCtrl.text.trim().isEmpty) {
      setState(() => _titleErr = l10n.quick_titleRequired);
      return;
    }
    setState(() => _titleErr = null);
    if (_kind == _Kind.note) {
      if (_detailCtrl.text.trim().isEmpty) {
        setState(() => _detailErr = l10n.quick_noteBodyRequired);
        return;
      }
      setState(() => _detailErr = null);
      _save();
      return;
    }
    setState(() => _step = 2);
  }

  void _back() {
    if (_step > 1) {
      setState(() {
        _step = 1;
        _detailErr = null;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  void _save() {
    if (_saving) return;
    final l10n = AppLocalizations.of(context);
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      setState(() {
        _titleErr = l10n.quick_titleRequired;
        _step = 1;
      });
      return;
    }
    final body = _detailCtrl.text.trim();
    if (_kind == _Kind.note && body.isEmpty) {
      setState(() {
        _detailErr = l10n.quick_noteBodyRequired;
        _step = 1;
      });
      return;
    }
    setState(() => _saving = true);
    final hm = _minutesToHHMM(_timeMins);
    final end = _endTime.trim();
    final endOk = RegExp(r'^\d{2}:\d{2}$').hasMatch(end);
    switch (_kind) {
      case _Kind.task:
        final matkul = _matkulCtrl.text.trim();
        ref.read(tasksProvider.notifier).upsert(
          Task(
            id: uid('t'),
            matkul: matkul.isEmpty ? 'Umum' : matkul,
            title: title,
            date: _date,
            time: hm.isEmpty ? '23:59' : hm,
            prio: _prio,
            note: body,
            done: false,
            reminderMin: _reminderMin,
          ),
        );
        nwToast(context, l10n.toast_taskSaved);
      case _Kind.sched:
        final hasEnd = endOk && end != hm;
        ref.read(schedsProvider.notifier).upsert(
          Sched(
            id: uid('s'),
            title: title,
            date: _date,
            time: hm.isEmpty ? '09:00' : hm,
            endTime: hasEnd ? end : null,
            overnight: hasEnd && end.compareTo(hm) <= 0 ? true : null,
            note: body,
            color: nwToHex(NwPalette.scheduleColors[_colorIndex]),
            reminderMin: _reminderMin,
          ),
        );
        nwToast(context, l10n.toast_schedSaved);
      case _Kind.note:
        ref.read(notesProvider.notifier).upsert(
          Note(
            id: uid('n'),
            title: title,
            body: body,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
        nwToast(context, l10n.notes_saveChanges);
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _primary() {
    // Langkah terakhir (atau catatan, yang langsung simpan dari langkah 1).
    if (_atFinal) {
      _save();
    } else {
      _next();
    }
  }

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
      _date = '${picked.year.toString().padLeft(4, '0')}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.day.toString().padLeft(2, '0')}';
      _syncDateLabel();
    });
  }

  Future<void> _pickTime({required void Function(String hm) onPick}) async {
    final fallback = _endTime.isNotEmpty
        ? _endTime
        : _minutesToHHMM((_timeMins + 60).clamp(0, 1425));
    final match = RegExp(r'^(\d{2}):(\d{2})$').firstMatch(fallback);
    final picked = await showTimePicker(
      context: context,
      initialTime: match == null
          ? const TimeOfDay(hour: 10, minute: 0)
          : TimeOfDay(
              hour: int.parse(match.group(1)!),
              minute: int.parse(match.group(2)!),
            ),
    );
    if (picked == null || !mounted) return;
    onPick(
      '${picked.hour.toString().padLeft(2, '0')}:'
      '${picked.minute.toString().padLeft(2, '0')}',
    );
  }

  void _shiftDate(int days) {
    final d = DateTime.tryParse(_date);
    if (d == null) return;
    final n = d.add(Duration(days: days));
    setState(() {
      _date = '${n.year.toString().padLeft(4, '0')}-'
          '${n.month.toString().padLeft(2, '0')}-'
          '${n.day.toString().padLeft(2, '0')}';
      _syncDateLabel();
    });
  }

  Widget _label(String text, {String? suffix}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text.rich(
        TextSpan(
          text: text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
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
    final ext = nwExt(context);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = ref.watch(settingsProvider).lang;
    final courses = {
      for (final r in ref.watch(routinesProvider))
        if (r.course.trim().isNotEmpty) r.course.trim(),
    };

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.add, size: 18, color: ext.accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.quick_title,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 17),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '$_hint — ${l10n.quick_hint}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12.5,
                color: ext.muted,
              ),
            ),
            if (_step == 1) ...[
              _label(l10n.quick_summaryKind),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  nwChip(
                    context,
                    label: l10n.tambah_task,
                    selected: _kind == _Kind.task,
                    onTap: () => setState(() {
                      _kind = _Kind.task;
                      _titleErr = null;
                      _detailErr = null;
                    }),
                  ),
                  nwChip(
                    context,
                    label: l10n.tambah_sched,
                    selected: _kind == _Kind.sched,
                    onTap: () => setState(() {
                      _kind = _Kind.sched;
                      _titleErr = null;
                      _detailErr = null;
                    }),
                  ),
                  nwChip(
                    context,
                    label: l10n.tambah_note,
                    selected: _kind == _Kind.note,
                    onTap: () => setState(() {
                      _kind = _Kind.note;
                      _titleErr = null;
                      _detailErr = null;
                    }),
                  ),
                ],
              ),
              _label(l10n.quick_step1),
              TextField(
                controller: _titleCtrl,
                autofocus: true,
                maxLength: 100,
                decoration: InputDecoration(
                  hintText: switch (_kind) {
                    _Kind.sched => l10n.quick_whatSchedPh,
                    _Kind.note => l10n.quick_whatNotePh,
                    _Kind.task => l10n.quick_whatPh,
                  },
                  errorText: _titleErr,
                  errorMaxLines: 2,
                  counterText: '',
                ),
                onChanged: (_) {
                  if (_titleErr != null) setState(() => _titleErr = null);
                },
                onSubmitted: (_) => _next(),
              ),
              if (_kind == _Kind.task) ...[
                _label(l10n.task_fieldCourse),
                Autocomplete<String>(
                  textEditingController: _matkulCtrl,
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
                      decoration: InputDecoration(
                        hintText: l10n.task_coursePh,
                        counterText: '',
                      ),
                    );
                  },
                ),
              ],
              _label(
                l10n.notes_fieldBody,
                suffix: _kind == _Kind.note
                    ? null
                    : l10n.common_optional,
              ),
              TextField(
                controller: _detailCtrl,
                minLines: _kind == _Kind.note ? 4 : 3,
                maxLines: _kind == _Kind.note ? 6 : 5,
                decoration: InputDecoration(
                  hintText: l10n.quick_detailPh,
                  errorText: _detailErr,
                  errorMaxLines: 2,
                ),
                onChanged: (_) {
                  if (_detailErr != null) setState(() => _detailErr = null);
                },
              ),
            ],
            if (_step == 2 && _kind != _Kind.note) ...[
              _label(l10n.quick_dateLabel),
              TextField(
                controller: _dateCtrl,
                readOnly: true,
                onTap: _pickDate,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    tooltip: l10n.quick_dateLabel,
                    icon: const Icon(Icons.calendar_month_outlined, size: 20),
                    onPressed: _pickDate,
                  ),
                ),
              ),
              _label('${l10n.quick_timeLabel} — ${_minutesToHHMM(_timeMins)}'),
              Slider(
                value: _timeMins.toDouble(),
                min: 0,
                max: 1425,
                divisions: 95,
                label: _minutesToHHMM(_timeMins),
                onChanged: (v) => setState(() => _timeMins = v.round()),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  nwChip(
                    context,
                    label: '${l10n.quick_presetMorning} 07:00',
                    selected: _timeMins == 420,
                    onTap: () => setState(() => _timeMins = 420),
                  ),
                  nwChip(
                    context,
                    label: '${l10n.quick_presetNoon} 13:00',
                    selected: _timeMins == 780,
                    onTap: () => setState(() => _timeMins = 780),
                  ),
                  nwChip(
                    context,
                    label: '${l10n.quick_presetNight} 19:00',
                    selected: _timeMins == 1140,
                    onTap: () => setState(() => _timeMins = 1140),
                  ),
                  nwChip(
                    context,
                    label: l10n.quick_presetTomorrow,
                    selected: false,
                    onTap: () => _shiftDate(1),
                  ),
                ],
              ),
              if (_kind == _Kind.task) ...[
                _label(l10n.task_fieldPrio),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final p in Prio.values)
                      nwChip(
                        context,
                        label: prioLabel(p, lang),
                        selected: _prio == p,
                        onTap: () => setState(() => _prio = p),
                      ),
                  ],
                ),
              ],
              if (_kind == _Kind.sched) ...[
                _label(l10n.quick_endLabel),
                TextField(
                  controller: _endCtrl,
                  readOnly: true,
                  onTap: () => _pickTime(
                    onPick: (hm) => setState(() {
                      _endTime = hm;
                      _endCtrl.text = hm;
                    }),
                  ),
                  decoration: InputDecoration(
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: l10n.quick_timeLabel,
                          icon: const Icon(Icons.schedule, size: 20),
                          onPressed: () => _pickTime(
                            onPick: (hm) => setState(() {
                              _endTime = hm;
                              _endCtrl.text = hm;
                            }),
                          ),
                        ),
                        if (_endTime.isNotEmpty)
                          IconButton(
                            tooltip: l10n.common_cancel,
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () => setState(() {
                              _endTime = '';
                              _endCtrl.clear();
                            }),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
              _label(l10n.reminder_title),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final v in _reminderValues)
                    nwChip(
                      context,
                      label: _reminderChipLabel(v, l10n),
                      selected: _reminderMin == v,
                      onTap: () => setState(() => _reminderMin = v),
                    ),
                ],
              ),
              if (_kind == _Kind.sched) ...[
                _label(l10n.settings_colorOf),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final (i, color) in
                        NwPalette.scheduleColors.indexed)
                      Semantics(
                        button: true,
                        selected: _colorIndex == i,
                        label: nwToHex(color),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => setState(() => _colorIndex = i),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _colorIndex == i
                                    ? ext.ink
                                    : ext.line,
                                width: _colorIndex == i ? 2.5 : 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saving ? null : _back,
                    child: Text(
                      _step > 1 ? l10n.quick_back : l10n.common_close,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: (_saving || !_titleOk) ? null : _primary,
                    child: Text(
                      _atFinal
                          ? (_saving ? l10n.task_saving : l10n.common_save)
                          : l10n.quick_next,
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
