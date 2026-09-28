import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notedwork/core/dates.dart';
import 'package:notedwork/core/models.dart';
import 'package:notedwork/core/state/state.dart';
import 'package:notedwork/core/theme/palette.dart';
import 'package:notedwork/features/quick_add/quick_add_sheet.dart';
import 'package:notedwork/features/tasks/task_widgets.dart';
import 'package:notedwork/features/today/widgets/detail_sheet.dart';
import 'package:notedwork/features/today/widgets/section_card.dart';
import 'package:notedwork/l10n/app_localizations.dart';

/// Agenda tanggal terpilih (`selectedDateProvider`) — jadwal yang `date`-nya
/// cocok, diurut jam. Aksi kosong = tambah jadwal via quick-add.
class AgendaCard extends ConsumerWidget {
  const AgendaCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lang = ref.watch(settingsProvider).lang;
    final selected = ref.watch(selectedDateProvider);
    final scheds =
        [
          for (final s in ref.watch(schedsProvider))
            if (s.date == selected) s,
        ]..sort((a, b) => a.time.compareTo(b.time));

    return SectionCard(
      title: l10n.cal_agenda,
      icon: Icons.event_outlined,
      subtitle: fmtDateID(selected, lang),
      child: scheds.isEmpty
          ? EmptyState(
              message: l10n.cal_emptyDate,
              actionLabel: l10n.cal_addSched,
              onAction: () => showQuickAdd(context, kind: 'jadwal'),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (i, s) in scheds.indexed) ...[
                  if (i > 0) const Divider(height: 1),
                  _AgendaRow(
                    sched: s,
                    lang: lang,
                    onTap: () => showNwDetailSheet(
                      context,
                      title: s.title,
                      subtitle: fmtDateID(s.date, lang),
                      rows: [
                        (l10n.quick_timeLabel, fmtSchedRange(s, lang)),
                        if (s.note.isNotEmpty) (l10n.sched_fieldNote, s.note),
                      ],
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

class _AgendaRow extends StatelessWidget {
  const _AgendaRow({
    required this.sched,
    required this.lang,
    required this.onTap,
  });

  final Sched sched;
  final Lang lang;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = nwExt(context);
    final dotColor = nwParseHex(sched.color) ?? ext.accent;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: Row(
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sched.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ext.ink,
                      height: 1.4,
                    ),
                  ),
                  Text(
                    fmtSchedRange(sched, lang),
                    style: TextStyle(fontSize: 10.5, color: ext.muted),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: ext.muted),
          ],
        ),
      ),
    );
  }
}
