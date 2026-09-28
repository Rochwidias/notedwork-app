import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notedwork/core/dates.dart';
import 'package:notedwork/core/models.dart';
import 'package:notedwork/core/state/state.dart';
import 'package:notedwork/core/theme/app_theme.dart';
import 'package:notedwork/core/theme/palette.dart';
import 'package:notedwork/features/calendar/confirm.dart';
import 'package:notedwork/l10n/app_localizations.dart';

Future<void> showRoutineSheet(BuildContext context, {Routine? initial}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _RoutineSheet(initial: initial),
  );
}

class _RoutineSheet extends ConsumerStatefulWidget {
  const _RoutineSheet({this.initial});

  final Routine? initial;

  @override
  ConsumerState<_RoutineSheet> createState() => _RoutineSheetState();
}

class _RoutineSheetState extends ConsumerState<_RoutineSheet> {
  late final TextEditingController _courseCtrl;
  late final TextEditingController _roomCtrl;
  late final TextEditingController _lectCtrl;
  late final TextEditingController _startCtrl;
  late final TextEditingController _endCtrl;
  late String _start;
  late String _end;
  late String _color;
  late int _day;
  bool _adding = false;
  Routine? _editTarget;

  @override
  void initState() {
    super.initState();
    final init = widget.initial;
    _courseCtrl = TextEditingController(text: init?.course ?? '');
    _roomCtrl = TextEditingController(text: init?.room ?? '');
    _lectCtrl = TextEditingController(text: init?.lect ?? '');
    _day = init?.day ?? 1;
    if (_day < 1 || _day > 7) _day = 1;
    _start = init?.start.isNotEmpty == true ? init!.start : '09:00';
    _end = init?.end.isNotEmpty == true ? init!.end : '10:40';
    _startCtrl = TextEditingController(text: _start);
    _endCtrl = TextEditingController(text: _end);
    _editTarget = init;
    final initColor = init?.color ?? '';
    _color = routineColors.contains(initColor)
        ? initColor
        : routineColors[ref.read(routinesProvider).length %
              routineColors.length];
  }

  @override
  void dispose() {
    _courseCtrl.dispose();
    _roomCtrl.dispose();
    _lectCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime({required bool isEnd}) async {
    final raw = isEnd ? _end : _start;
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
        _end = hm;
        _endCtrl.text = hm;
      } else {
        _start = hm;
        _startCtrl.text = hm;
      }
    });
  }

  void _fill(Routine r) {
    setState(() {
      _editTarget = r;
      _courseCtrl.text = r.course;
      _roomCtrl.text = r.room;
      _lectCtrl.text = r.lect;
      _day = r.day;
      _start = r.start;
      _end = r.end;
      _startCtrl.text = r.start;
      _endCtrl.text = r.end;
      _color = r.color;
    });
  }

  void _resetForm() {
    setState(() {
      _editTarget = null;
      _courseCtrl.clear();
      _roomCtrl.clear();
      _lectCtrl.clear();
    });
  }

  Future<void> _save() async {
    if (_adding) return;
    final course = _courseCtrl.text.trim();
    if (course.isEmpty) return;
    final l10n = AppLocalizations.of(context);
    final editing = _editTarget;
    setState(() => _adding = true);
    final routine = Routine(
      id: editing?.id ?? uid('r'),
      course: course,
      day: _day,
      start: _start.isEmpty ? '09:00' : _start,
      end: _end.isEmpty ? '10:40' : _end,
      room: _roomCtrl.text.trim(),
      lect: _lectCtrl.text.trim(),
      color: _color,
    );
    ref.read(routinesProvider.notifier).upsert(routine);
    if (!mounted) return;
    showNwSnack(context, l10n.toast_routineSaved);
    if (editing != null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _courseCtrl.clear();
      _roomCtrl.clear();
      _lectCtrl.clear();
    });
    Future<void>.delayed(Duration.zero, () {
      if (mounted) setState(() => _adding = false);
    });
  }

  Future<void> _delete(Routine r) async {
    final l10n = AppLocalizations.of(context);
    if (!await confirmDelete(context, r.course)) return;
    if (!mounted) return;
    ref.read(routinesProvider.notifier).remove(r.id);
    showNwSnack(context, l10n.toast_routineDeleted);
    if (_editTarget?.id == r.id) _resetForm();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = Theme.of(context).extension<NwThemeExt>()!;
    final lang = ref.watch(settingsProvider).lang;
    final base = Theme.of(context).textTheme;
    final routines = [...ref.watch(routinesProvider)]
      ..sort((a, b) {
        final d = a.day.compareTo(b.day);
        return d != 0 ? d : a.start.compareTo(b.start);
      });
    final editing = _editTarget != null;

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
                    Icon(Icons.menu_book_outlined, size: 16, color: t.ink),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.routine_title,
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
                Text(l10n.routine_hint, style: nwHintStyle(context)),
                const SizedBox(height: 8),
                Text(l10n.routine_fieldCourse, style: nwLabelStyle(context)),
                TextField(
                  controller: _courseCtrl,
                  maxLength: 60,
                  decoration: InputDecoration(
                    hintText: l10n.routine_coursePh,
                    counterText: '',
                  ),
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
                            l10n.routine_fieldDay,
                            style: nwLabelStyle(context),
                          ),
                          Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: t.input,
                              border: Border.all(color: t.line),
                              borderRadius: BorderRadius.circular(
                                t.inputRadius,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: _day,
                                isExpanded: true,
                                dropdownColor: t.card,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: t.ink,
                                  height: 1.4,
                                ),
                                items: [
                                  for (var i = 1; i <= 7; i++)
                                    DropdownMenuItem<int>(
                                      value: i,
                                      child: Text(dayNames(lang)[i - 1]),
                                    ),
                                ],
                                onChanged: (v) =>
                                    setState(() => _day = v ?? _day),
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
                          Text(
                            l10n.routine_fieldRoom,
                            style: nwLabelStyle(context),
                          ),
                          TextField(
                            controller: _roomCtrl,
                            maxLength: 30,
                            decoration: InputDecoration(
                              hintText: l10n.routine_roomPh,
                              counterText: '',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                            l10n.routine_fieldStart,
                            style: nwLabelStyle(context),
                          ),
                          TextField(
                            controller: _startCtrl,
                            readOnly: true,
                            onTap: () => _pickTime(isEnd: false),
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.schedule_outlined),
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
                            l10n.routine_fieldEnd,
                            style: nwLabelStyle(context),
                          ),
                          TextField(
                            controller: _endCtrl,
                            readOnly: true,
                            onTap: () => _pickTime(isEnd: true),
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
                Text(l10n.routine_fieldLect, style: nwLabelStyle(context)),
                TextField(
                  controller: _lectCtrl,
                  maxLength: 60,
                  decoration: InputDecoration(
                    hintText: l10n.routine_lectPh,
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 12),
                Text(l10n.settings_colorOf, style: nwLabelStyle(context)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    for (final hex in routineColors)
                      NwSwatch(
                        color: nwParseHex(hex)!,
                        selected: _color == hex,
                        onTap: () => setState(() => _color = hex),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (editing)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _adding ? null : _resetForm,
                          child: Text(l10n.common_cancel),
                        ),
                      )
                    else
                      const Expanded(child: SizedBox()),
                    if (editing) const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: _adding ? null : _save,
                        child: Text(
                          _adding
                              ? l10n.routine_adding
                              : editing
                              ? l10n.common_save
                              : l10n.routine_add,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '${l10n.routine_mineTitle}${routines.length})',
                  style: (base.labelLarge ?? const TextStyle()).copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: t.ink,
                  ),
                ),
                const SizedBox(height: 4),
                if (routines.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Center(
                      child: Text(
                        l10n.routine_emptyMine,
                        style: nwHintStyle(context),
                      ),
                    ),
                  )
                else
                  for (final r in routines)
                    _RoutineRow(
                      routine: r,
                      dayLabel: r.day >= 1 && r.day <= 7
                          ? dayNames(lang)[r.day - 1]
                          : '',
                      selected: _editTarget?.id == r.id,
                      onTap: () => _fill(r),
                      onDelete: () => _delete(r),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoutineRow extends StatelessWidget {
  const _RoutineRow({
    required this.routine,
    required this.dayLabel,
    required this.selected,
    required this.onTap,
    required this.onDelete,
  });

  final Routine routine;
  final String dayLabel;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NwThemeExt>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        color: selected ? t.accentMuted : null,
        borderRadius: BorderRadius.circular(10),
        border: Border(top: BorderSide(color: t.line)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  color: nwParseHex(routine.color) ?? t.accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routine.course,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: t.ink,
                        height: 1.35,
                      ),
                    ),
                    Text(
                      '$dayLabel • ${routine.start}–${routine.end}',
                      style: TextStyle(
                        fontSize: 12,
                        color: t.muted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                tooltip: l10n.common_delete,
                icon: Icon(Icons.delete_outline, size: 18, color: t.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
