import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notedwork/core/dates.dart';
import 'package:notedwork/core/state/state.dart';
import 'package:notedwork/features/tasks/task_widgets.dart';
import 'package:notedwork/features/today/widgets/section_card.dart';
import 'package:notedwork/l10n/app_localizations.dart';

String _isoOf(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

/// Strip 7 hari mulai hari ini (`.wstrip` di web): inisial hari terlokalisasi
/// + tanggal; hari terpilih diisi aksen. Ketuk = `selectedDateProvider.set`.
class WeekStripCard extends ConsumerWidget {
  const WeekStripCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nw = nwExt(context);
    final l10n = AppLocalizations.of(context);
    final lang = ref.watch(settingsProvider).lang;
    final selected = ref.watch(selectedDateProvider);
    final today = todayStr();
    final base = DateTime.tryParse(today) ?? DateTime.now();
    final initials = dowInitials(lang);
    final days = [for (var i = 0; i < 7; i++) _isoOf(base.add(Duration(days: i)))];

    return SectionCard(
      title: l10n.home_thisWeek,
      icon: Icons.calendar_month_outlined,
      child: Row(
        children: [
          for (var i = 0; i < days.length; i++)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i == days.length - 1 ? 0 : 6),
                child: _DayChip(
                  iso: days[i],
                  initial: switch (weekdayOf(days[i])) {
                    final w when w >= 1 && w <= 7 => initials[w - 1],
                    _ => '',
                  },
                  isToday: days[i] == today,
                  isSelected: days[i] == selected,
                  semanticsLabel: fmtDateID(days[i], lang),
                  accent: nw.accent,
                  onTap: () =>
                      ref.read(selectedDateProvider.notifier).set(days[i]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.iso,
    required this.initial,
    required this.isToday,
    required this.isSelected,
    required this.semanticsLabel,
    required this.accent,
    required this.onTap,
  });

  final String iso;
  final String initial;
  final bool isToday;
  final bool isSelected;
  final String semanticsLabel;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final nw = nwExt(context);
    final day = int.tryParse(iso.substring(8, 10)) ?? 0;
    final border = isSelected
        ? accent
        : (isToday ? accent.withValues(alpha: 0.55) : nw.line);

    return Semantics(
      button: true,
      selected: isSelected,
      label: semanticsLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? accent : nw.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                initial.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: isSelected ? nw.onAccent : nw.muted,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                '$day',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? nw.onAccent : nw.ink,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
