import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notedwork/core/dates.dart';
import 'package:notedwork/core/models.dart';
import 'package:notedwork/core/reminders.dart';
import 'package:notedwork/core/state/state.dart';
import 'package:notedwork/core/theme/app_theme.dart';
import 'package:notedwork/core/theme/palette.dart';
import 'package:notedwork/features/calendar/confirm.dart';
import 'package:notedwork/l10n/app_localizations.dart';

const List<int> reminderValues = <int>[0, 180, 300, 600, 1440];

String reminderChipLabel(int mins, AppLocalizations l10n) {
  if (mins <= 0) return l10n.reminder_off;
  if (mins < 60 || mins % 60 != 0) return '$mins${l10n.reminder_min}';
  final h = mins ~/ 60;
  if (h < 24) return '$h${h == 1 ? l10n.reminder_hour : l10n.reminder_hours}';
  return '${h ~/ 24}${l10n.reminder_day}';
}

Future<void> showSchedSheet(
  BuildContext context, {
  required String selDate,
  required String defaultColor,
  Sched? initial,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _SchedSheet(
      selDate: selDate,
      defaultColor: defaultColor,
      initial: initial,
    ),
  );
}

class _SchedSheet extends ConsumerStatefulWidget {
  const _SchedSheet({
    required this.selDate,
    required this.defaultColor,
    this.initial,
  });

  final String selDate;
  final String defaultColor;
  final Sched? initial;

  @override
  ConsumerState<_SchedSheet> createState() => _SchedSheetState();
}

class _SchedSheetState extends ConsumerState<_SchedSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _noteCtrl;
  late final TextEditingController _dateCtrl;
  late final TextEditingController _timeCtrl;
  late final TextEditingController _endCtrl;

  late String _date;
  late String _time;
  late String _endTime;
  late String _color;
  late int _reminderMin;
  bool _allDay = false;
  String? _titleErr;
  bool _saving = false;

  bool get _editing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final init = widget.initial;
    _titleCtrl = TextEditingController(text: init?.title ?? '');
    _noteCtrl = TextEditingController(text: init?.note ?? '');
    _date = init?.date.isNotEmpty == true ? init!.date : widget.selDate;
    _time = init?.time ?? '';
    _endTime = init?.endTime ?? '';
    _allDay = init?.allDay == true;
    _reminderMin = init?.reminderMin ?? defaultReminderMin;
    final initColor = init?.color ?? '';
    _color = schedColors.contains(initColor) ? initColor : widget.defaultColor;
    if (!schedColors.contains(_color)) _color = schedColors.first;
    _dateCtrl = TextEditingController(
      text: fmtDateID(_date, ref.read(settingsProvider).lang),
    );
    _timeCtrl = TextEditingController(text: _time);
    _endCtrl = TextEditingController(text: _endTime);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  String _dateLabel(Lang lang) => fmtDateID(_date, lang);

  Future<void> _pickDate(Lang lang) async {
    final initial = DateTime.tryParse(_date) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    final iso =
        '${picked.year.toString().padLeft(4, '0')}-'
        '${picked.month.toString().padLeft(2, '0')}-'
        '${picked.day.toString().padLeft(2, '0')}';
    setState(() {
      _date = iso;
      _dateCtrl.text = _dateLabel(lang);
    });
  }

  Future<void> _pickTime({required bool isEnd}) async {
    final raw = isEnd ? _endTime : _time;
    final parts = raw.split(':');
    final initial = TimeOfDay(
      hour: int.tryParse(parts.first) ?? (isEnd ? 10 : 9),
      minute: parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0,
    );
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null || !mounted) return;
    final hm =
        '${picked.hour.toString().padLeft(2, '0')}:'
        '${picked.minute.toString().padLeft(2, '0')}';
    setState(() {
      if (isEnd) {
        _endTime = hm;
        _endCtrl.text = hm;
      } else {
        _time = hm;
        _timeCtrl.text = hm;
      }
    });
  }

  Future<void> _save() async {
    if (_saving) return;
    final l10n = AppLocalizations.of(context);
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      setState(() => _titleErr = l10n.sched_titleRequired);
      return;
    }
    setState(() {
      _titleErr = null;
      _saving = true;
    });
    final time = _allDay ? '00:00' : (_time.isNotEmpty ? _time : '09:00');
    String? end;
    var overnight = false;
    if (!_allDay && _endTime.isNotEmpty && _endTime != time) {
      end = _endTime;
      overnight = _endTime.compareTo(time) < 0;
    }
    final sched = Sched(
      id: widget.initial?.id ?? uid('s'),
      title: title,
      date: _date,
      time: time,
      endTime: end,
      allDay: _allDay ? true : null,
      overnight: overnight ? true : null,
      note: _noteCtrl.text.trim(),
      color: _color,
      reminderMin: _reminderMin,
    );
    ref.read(schedsProvider.notifier).upsert(sched);
    ref.read(selectedDateProvider.notifier).set(_date);
    if (!mounted) return;
    showNwSnack(
      context,
      _editing ? l10n.toast_schedUpdated : l10n.toast_schedSaved,
    );
    Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final init = widget.initial;
    if (init == null) return;
    final l10n = AppLocalizations.of(context);
    if (!await confirmDelete(context, init.title)) return;
    if (!mounted) return;
    ref.read(schedsProvider.notifier).remove(init.id);
    showNwSnack(context, l10n.toast_schedDeleted);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = Theme.of(context).extension<NwThemeExt>()!;
    final lang = ref.watch(settingsProvider).lang;
    final base = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.9,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      _editing ? Icons.edit_calendar_outlined : Icons.add,
                      size: 16,
                      color: t.ink,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _editing ? l10n.sched_editTitle : l10n.sched_addTitle,
                        style: (base.titleMedium ?? const TextStyle()).copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: t.ink,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(l10n.sched_hint, style: nwHintStyle(context)),
                const SizedBox(height: 8),
                Text(l10n.sched_fieldTitle, style: nwLabelStyle(context)),
                TextField(
                  controller: _titleCtrl,
                  maxLength: 80,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: l10n.sched_titlePh,
                    errorText: _titleErr,
                    counterText: '',
                  ),
                  onChanged: (_) {
                    if (_titleErr != null) setState(() => _titleErr = null);
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.sched_fieldDate,
                            style: nwLabelStyle(context),
                          ),
                          TextField(
                            controller: _dateCtrl,
                            readOnly: true,
                            onTap: () => _pickDate(lang),
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.calendar_today_outlined),
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
                          Text(
                            '${l10n.sched_startLabel}${l10n.common_optional}',
                            style: nwLabelStyle(context),
                          ),
                          TextField(
                            controller: _timeCtrl,
                            readOnly: true,
                            onTap: () => _pickTime(isEnd: false),
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.schedule_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: t.card2,
                    borderRadius: BorderRadius.circular(t.inputRadius),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _allDay
                              ? (lang == Lang.en ? 'All day' : 'Seharian')
                              : '${l10n.sched_endLabel}${l10n.common_optional}',
                          style: (base.labelMedium ?? const TextStyle())
                              .copyWith(
                                color: t.ink,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                        ),
                      ),
                      Switch(
                        value: _allDay,
                        onChanged: (v) => setState(() => _allDay = v),
                      ),
                    ],
                  ),
                ),
                if (!_allDay) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _endCtrl,
                    readOnly: true,
                    onTap: () => _pickTime(isEnd: true),
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.schedule_outlined),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(l10n.sched_endHint, style: nwHintStyle(context)),
                ],
                const SizedBox(height: 12),
                Text(l10n.reminder_title, style: nwLabelStyle(context)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final v in reminderValues)
                      ChoiceChip(
                        label: Text(reminderChipLabel(v, l10n)),
                        selected: _reminderMin == v,
                        onSelected: (_) => setState(() => _reminderMin = v),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(l10n.sched_fieldNote, style: nwLabelStyle(context)),
                TextField(
                  controller: _noteCtrl,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(hintText: l10n.sched_notePh),
                ),
                const SizedBox(height: 12),
                Text(l10n.settings_colorOf, style: nwLabelStyle(context)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    for (final hex in schedColors)
                      NwSwatch(
                        color: nwParseHex(hex)!,
                        selected: _color == hex,
                        onTap: () => setState(() => _color = hex),
                      ),
                  ],
                ),
                if (_editing) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: t.ink),
                      onPressed: _delete,
                      icon: Icon(
                        Icons.delete_outline,
                        size: 17,
                        color: t.muted,
                      ),
                      label: Text(
                        l10n.common_delete,
                        style: TextStyle(color: t.muted),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
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
                              ? l10n.sched_saving
                              : _editing
                              ? l10n.sched_saveChanges
                              : l10n.common_save,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
