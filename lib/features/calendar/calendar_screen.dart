import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notedwork/core/dates.dart';
import 'package:notedwork/core/models.dart';
import 'package:notedwork/core/state/state.dart';
import 'package:notedwork/core/theme/app_theme.dart';
import 'package:notedwork/core/theme/palette.dart';
import 'package:notedwork/features/calendar/confirm.dart';
import 'package:notedwork/features/calendar/routine_sheet.dart';
import 'package:notedwork/features/calendar/sched_sheet.dart';
import 'package:notedwork/l10n/app_localizations.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late int _year;
  late int _month;

  @override
  void initState() {
    super.initState();
    final d =
        DateTime.tryParse(ref.read(selectedDateProvider)) ?? DateTime.now();
    _year = d.year;
    _month = d.month;
  }

  void _shiftMonth(int delta) {
    final d = DateTime(_year, _month + delta, 1);
    setState(() {
      _year = d.year;
      _month = d.month;
    });
  }

  Future<void> _openSched({Sched? initial}) async {
    final selDate = ref.read(selectedDateProvider);
    final count = ref.read(schedsProvider).length;
    final color = routineColors[count % routineColors.length];
    await showSchedSheet(
      context,
      selDate: selDate,
      defaultColor: color,
      initial: initial,
    );
  }

  Future<void> _deleteSched(Sched s) async {
    final l10n = AppLocalizations.of(context);
    if (!await confirmDelete(context, s.title)) return;
    if (!mounted) return;
    ref.read(schedsProvider.notifier).remove(s.id);
    showNwSnack(context, l10n.toast_schedDeleted);
  }

  Future<void> _deleteRoutine(Routine r) async {
    final l10n = AppLocalizations.of(context);
    if (!await confirmDelete(context, r.course)) return;
    if (!mounted) return;
    ref.read(routinesProvider.notifier).remove(r.id);
    showNwSnack(context, l10n.toast_routineDeleted);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = Theme.of(context).extension<NwThemeExt>()!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final semantic = NwSemantic.of(dark: dark);
    final base = Theme.of(context).textTheme;
    final lang = ref.watch(settingsProvider).lang;
    final selDate = ref.watch(selectedDateProvider);
    final scheds = ref.watch(schedsProvider);
    final routines = ref.watch(routinesProvider);
    final tasks = ref.watch(tasksProvider);

    ref.listen<String>(selectedDateProvider, (prev, next) {
      if (prev == next) return;
      final d = DateTime.tryParse(next);
      if (d == null) return;
      if (d.year != _year || d.month != _month) {
        setState(() {
          _year = d.year;
          _month = d.month;
        });
      }
    });

    final schedByDate = <String, List<Sched>>{};
    for (final s in scheds) {
      (schedByDate[s.date] ??= <Sched>[]).add(s);
    }
    final taskDates = <String>{
      for (final x in tasks)
        if (!x.done) x.date,
    };
    final routineDays = <int>{for (final r in routines) r.day};

    final daySched = [...(schedByDate[selDate] ?? const <Sched>[])]
      ..sort((a, b) => a.time.compareTo(b.time));
    final dayRoutines = [
      for (final r in routines)
        if (r.day == weekdayOf(selDate)) r,
    ]..sort((a, b) => a.start.compareTo(b.start));
    final dayTasks = [
      for (final x in tasks)
        if (x.date == selDate) x,
    ];
    final dayEmpty =
        dayRoutines.isEmpty && daySched.isEmpty && dayTasks.isEmpty;

    final now = DateTime.now();
    final selBase = DateTime.tryParse(selDate) ?? now;
    final upEnd = DateTime(selBase.year, selBase.month, selBase.day + 7);
    final upEndIso = _iso(upEnd);
    final upcoming =
        [
          for (final s in scheds)
            if (s.date.compareTo(selDate) > 0 &&
                s.date.compareTo(upEndIso) <= 0)
              s,
        ]..sort((a, b) {
          final c = a.date.compareTo(b.date);
          return c != 0 ? c : a.time.compareTo(b.time);
        });

    final today = todayStr();
    final offToday = selDate != today;

    final cardBox = BoxDecoration(
      color: t.card,
      borderRadius: BorderRadius.circular(t.cardRadius),
      border: Border.all(color: t.line),
      boxShadow: NwPalette.cardShadow(dark: dark),
    );

    TextStyle headStyle = (base.titleSmall ?? const TextStyle()).copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w800,
      color: t.ink,
      height: 1.3,
    );

    Widget sectionHead(IconData icon, String text, {Widget? trailing}) => Row(
      children: [
        Icon(icon, size: 15, color: t.ink),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: headStyle)),
        ?trailing,
      ],
    );

    Widget navBtn(IconData icon, String tooltip, VoidCallback onPressed) {
      return Tooltip(
        message: tooltip,
        child: Material(
          color: t.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: t.line),
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 36,
              height: 36,
              child: Icon(icon, size: 18, color: t.ink),
            ),
          ),
        ),
      );
    }

    Widget dot(Color color, {double top = 5}) => Container(
      width: 10,
      height: 10,
      margin: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );

    Widget pill(String text, Color bg, Color fg) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: fg),
      ),
    );

    Widget rowWrap({
      required Widget child,
      Color? dotColor,
      Widget? trailing,
      VoidCallback? onTap,
      bool first = false,
    }) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: first
            ? null
            : BoxDecoration(
                border: Border(top: BorderSide(color: t.line)),
              ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (dotColor != null) ...[
                dot(dotColor),
                const SizedBox(width: 12),
              ],
              Expanded(child: child),
              if (trailing != null) ...[const SizedBox(width: 4), trailing],
            ],
          ),
        ),
      );
    }

    Widget actionIcons(List<(IconData, Color, VoidCallback)> items) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (icon, color, cb) in items)
          IconButton(
            onPressed: cb,
            icon: Icon(icon, size: 17, color: color),
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            padding: EdgeInsets.zero,
          ),
      ],
    );

    Widget rowTitle(String text, {List<Widget> children = const []}) => Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: t.ink,
              height: 1.35,
            ),
          ),
        ),
        ...children,
      ],
    );

    Widget rowSub(String text) => Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: t.muted, height: 1.4),
      ),
    );

    final cells = _monthCells(_year, _month);
    final dayDots = <String, List<Color>>{};
    for (final c in cells) {
      final iso = c.iso;
      if (iso == null) continue;
      final colors = <Color>[];
      void add(Color? color) {
        if (color == null || colors.length >= 3 || colors.contains(color)) {
          return;
        }
        colors.add(color);
      }

      if (routineDays.contains(weekdayOf(iso))) add(t.accent);
      for (final s in schedByDate[iso] ?? const <Sched>[]) {
        add(nwParseHex(s.color));
      }
      if (taskDates.contains(iso)) add(semantic.red);
      dayDots[iso] = colors;
    }

    Widget badgePill(TaskBadge b) {
      final (bg, fg) = switch (b.cls) {
        BadgeKind.over => (semantic.red, const Color(0xFFFFFFFF)),
        BadgeKind.hi => (semantic.redSoft, semantic.red),
        BadgeKind.md => (semantic.amberSoft, semantic.amber),
        BadgeKind.lo => (semantic.greenSoft, semantic.green),
        BadgeKind.due => (t.accentSoft, dark ? t.accent : t.accentDark),
      };
      return pill(b.txt, bg, fg);
    }

    final groupRoutines = <int, List<Routine>>{
      for (var d = 1; d <= 7; d++) d: <Routine>[],
    };
    for (final r in routines) {
      if (r.day >= 1 && r.day <= 7) groupRoutines[r.day]!.add(r);
    }
    for (final list in groupRoutines.values) {
      list.sort((a, b) => a.start.compareTo(b.start));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.cal_liveSub,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: t.muted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: cardBox,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${monthNames(lang)[_month - 1]} $_year',
                        style: headStyle,
                      ),
                    ),
                    navBtn(
                      Icons.chevron_left,
                      l10n.cal_prevMonth,
                      () => _shiftMonth(-1),
                    ),
                    const SizedBox(width: 8),
                    navBtn(
                      Icons.chevron_right,
                      l10n.cal_nextMonth,
                      () => _shiftMonth(1),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            for (final d in dowInitials(lang))
                              Expanded(
                                child: Center(
                                  child: Text(
                                    d,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: t.muted,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        for (var r = 0; r < cells.length; r += 7)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                for (
                                  var i = r;
                                  i < r + 7 && i < cells.length;
                                  i++
                                )
                                  Expanded(
                                    child: _DayCell(
                                      cell: cells[i],
                                      selDate: selDate,
                                      today: today,
                                      dots: cells[i].iso == null
                                          ? const <Color>[]
                                          : (dayDots[cells[i].iso] ??
                                                const <Color>[]),
                                      t: t,
                                      onTap: cells[i].iso == null
                                          ? null
                                          : () => ref
                                                .read(
                                                  selectedDateProvider.notifier,
                                                )
                                                .set(cells[i].iso!),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 12,
                          runSpacing: 6,
                          children: [
                            _legendItem(t.accent, l10n.cal_routine, t),
                            _legendItem(semantic.green, l10n.cal_agenda, t),
                            _legendItem(semantic.red, l10n.cal_deadline, t),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: cardBox,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                sectionHead(
                  Icons.calendar_month_outlined,
                  '${l10n.cal_agenda} • ${fmtDateID(selDate, lang)}',
                  trailing: offToday
                      ? TextButton(
                          onPressed: () =>
                              ref.read(selectedDateProvider.notifier).goToday(),
                          style: TextButton.styleFrom(
                            foregroundColor: t.accent,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: const Size(0, 36),
                            textStyle: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(l10n.cal_today),
                              const Icon(Icons.chevron_right, size: 16),
                            ],
                          ),
                        )
                      : null,
                ),
                for (var i = 0; i < dayRoutines.length; i++)
                  rowWrap(
                    first: i == 0,
                    dotColor: nwParseHex(dayRoutines[i].color) ?? t.accent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                dayRoutines[i].course,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: t.ink,
                                  height: 1.35,
                                ),
                              ),
                            ),
                            pill(
                              l10n.cal_routine,
                              t.accentSoft,
                              dark ? t.accent : t.accentDark,
                            ),
                          ],
                        ),
                        rowSub(_routineSub(dayRoutines[i], l10n)),
                      ],
                    ),
                  ),
                for (var i = 0; i < daySched.length; i++)
                  rowWrap(
                    first: dayRoutines.isEmpty && i == 0,
                    dotColor: nwParseHex(daySched[i].color) ?? semantic.green,
                    onTap: () => _openSched(initial: daySched[i]),
                    trailing: actionIcons([
                      (
                        Icons.edit_outlined,
                        t.accent,
                        () => _openSched(initial: daySched[i]),
                      ),
                      (
                        Icons.delete_outline,
                        semantic.red,
                        () => _deleteSched(daySched[i]),
                      ),
                    ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        rowTitle(
                          daySched[i].title,
                          children: [
                            Text(
                              '• ${fmtSchedRange(daySched[i], lang)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: t.muted,
                              ),
                            ),
                          ],
                        ),
                        if (daySched[i].note.isNotEmpty)
                          rowSub(daySched[i].note),
                      ],
                    ),
                  ),
                for (var i = 0; i < dayTasks.length; i++)
                  rowWrap(
                    first: dayRoutines.isEmpty && daySched.isEmpty && i == 0,
                    dotColor: semantic.red,
                    onTap: () => ref
                        .read(tasksProvider.notifier)
                        .toggleDone(dayTasks[i].id),
                    trailing: Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: t.muted,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.alarm, size: 14, color: t.muted),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                dayTasks[i].title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: t.ink,
                                  height: 1.35,
                                  decoration: dayTasks[i].done
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                            if (dayTasks[i].done)
                              Icon(Icons.check, size: 14, color: t.muted),
                            const SizedBox(width: 6),
                            badgePill(taskBadge(dayTasks[i], lang)),
                          ],
                        ),
                        rowSub(
                          '${dayTasks[i].matkul}'
                          '${l10n.cal_deadlineAt}'
                          '${dayTasks[i].time}',
                        ),
                      ],
                    ),
                  ),
                if (dayEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 22,
                      horizontal: 10,
                    ),
                    child: Column(
                      children: [
                        Text(
                          l10n.cal_emptyDate,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: t.muted,
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          upcoming.isNotEmpty
                              ? l10n.cal_upcoming7
                              : l10n.cal_enjoyDay,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: t.muted,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                  for (var i = 0; i < upcoming.length; i++)
                    rowWrap(
                      first: i == 0,
                      dotColor: nwParseHex(upcoming[i].color) ?? semantic.green,
                      onTap: () => ref
                          .read(selectedDateProvider.notifier)
                          .set(upcoming[i].date),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: t.muted,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          rowTitle(
                            upcoming[i].title,
                            children: [
                              Text(
                                '• ${fmtSchedRange(upcoming[i], lang)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: t.muted,
                                ),
                              ),
                            ],
                          ),
                          rowSub(fmtDateID(upcoming[i].date, lang)),
                        ],
                      ),
                    ),
                ],
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: () => _openSched(),
                  icon: const Icon(Icons.add, size: 16),
                  label: Text(l10n.cal_addSched),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: cardBox,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                sectionHead(Icons.menu_book_outlined, l10n.cal_weeklyRoutine),
                if (routines.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 22,
                      horizontal: 10,
                    ),
                    child: Text(
                      l10n.cal_noRoutine,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: t.muted,
                        height: 1.7,
                      ),
                    ),
                  )
                else
                  for (var d = 1; d <= 7; d++) ...[
                    if (groupRoutines[d]!.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 2),
                        child: Text(
                          dayNames(lang)[d - 1],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: t.muted,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      for (var i = 0; i < groupRoutines[d]!.length; i++)
                        rowWrap(
                          first: i == 0,
                          dotColor:
                              nwParseHex(groupRoutines[d]![i].color) ??
                              t.accent,
                          onTap: () => showRoutineSheet(
                            context,
                            initial: groupRoutines[d]![i],
                          ),
                          trailing: actionIcons([
                            (
                              Icons.edit_outlined,
                              t.accent,
                              () => showRoutineSheet(
                                context,
                                initial: groupRoutines[d]![i],
                              ),
                            ),
                            (
                              Icons.delete_outline,
                              semantic.red,
                              () => _deleteRoutine(groupRoutines[d]![i]),
                            ),
                          ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              rowTitle(groupRoutines[d]![i].course),
                              rowSub(_routineSub(groupRoutines[d]![i], l10n)),
                            ],
                          ),
                        ),
                    ],
                  ],
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => showRoutineSheet(context),
                  icon: const Icon(Icons.settings_outlined, size: 16),
                  label: Text(l10n.cal_manageRoutine),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCellData {
  const _DayCellData(this.label, this.iso);

  final int label;
  final String? iso;
}

List<_DayCellData> _monthCells(int y, int m) {
  final first = DateTime(y, m, 1).weekday - 1;
  final days = DateTime(y, m + 1, 0).day;
  final prevDays = DateTime(y, m, 0).day;
  final cells = <_DayCellData>[];
  for (var i = first - 1; i >= 0; i--) {
    cells.add(_DayCellData(prevDays - i, null));
  }
  for (var d = 1; d <= days; d++) {
    cells.add(_DayCellData(d, '$y-${_pad(m)}-${_pad(d)}'));
  }
  final tail = (7 - ((first + days) % 7)) % 7;
  for (var d = 1; d <= tail; d++) {
    cells.add(_DayCellData(d, null));
  }
  return cells;
}

String _pad(int v) => v.toString().padLeft(2, '0');

String _iso(DateTime d) => '${d.year}-${_pad(d.month)}-${_pad(d.day)}';

String _routineSub(Routine r, AppLocalizations l10n) {
  final parts = <String>['${r.start}–${r.end}'];
  if (r.room.isNotEmpty) parts.add('${l10n.cal_room} ${r.room}');
  if (r.lect.isNotEmpty) parts.add(r.lect);
  return parts.join(' • ');
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.cell,
    required this.selDate,
    required this.today,
    required this.dots,
    required this.t,
    this.onTap,
  });

  final _DayCellData cell;
  final String selDate;
  final String today;
  final List<Color> dots;
  final NwThemeExt t;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final iso = cell.iso;
    final dim = iso == null;
    final selected = iso != null && iso == selDate;
    final isToday = iso != null && iso == today;

    return Opacity(
      opacity: dim ? 0.45 : 1,
      child: Material(
        color: selected ? t.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 38,
            alignment: Alignment.center,
            decoration: !selected && isToday
                ? BoxDecoration(
                    border: Border.all(color: t.accent, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  )
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${cell.label}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                    color: selected ? t.onAccent : (dim ? t.muted : t.ink),
                    height: 1.1,
                  ),
                ),
                if (dots.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final c in dots)
                          Container(
                            width: 5,
                            height: 5,
                            margin: const EdgeInsets.symmetric(horizontal: 1.5),
                            decoration: BoxDecoration(
                              color: selected ? t.onAccent : c,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _legendItem(Color color, String label, NwThemeExt t) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 5),
      Text(label, style: TextStyle(fontSize: 12, color: t.muted, height: 1.4)),
    ],
  );
}
