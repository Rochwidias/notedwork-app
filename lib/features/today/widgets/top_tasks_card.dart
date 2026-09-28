import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notedwork/core/dates.dart';
import 'package:notedwork/core/models.dart';
import 'package:notedwork/core/state/state.dart';
import 'package:notedwork/features/tasks/task_widgets.dart';
import 'package:notedwork/features/quick_add/quick_add_sheet.dart';
import 'package:notedwork/features/today/widgets/section_card.dart';
import 'package:notedwork/l10n/app_localizations.dart';

/// Urutan "3 Terpenting": prioritas Tinggi dulu, lalu tanggal, lalu jam —
/// konvensi jam kosong = akhir hari (23:59) sama seperti `lib/dates`.
int _byPriorityThenDate(Task a, Task b) {
  final p = a.prio.index.compareTo(b.prio.index);
  if (p != 0) return p;
  final d = a.date.compareTo(b.date);
  if (d != 0) return d;
  final ta = a.time.isEmpty ? '23:59' : a.time;
  final tb = b.time.isEmpty ? '23:59' : b.time;
  return ta.compareTo(tb);
}

/// Kartu "3 Terpenting" — 3 tugas teratas bernomor dengan checkbox yang
/// bisa langsung ditoggle in-place dan badge dari `taskBadge`.
class TopTasksCard extends ConsumerWidget {
  const TopTasksCard({super.key, required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lang = ref.watch(settingsProvider).lang;
    final tasks = ref.watch(tasksProvider);
    final top3 = ([...tasks]..sort(_byPriorityThenDate)).take(3).toList();

    return SectionCard(
      title: l10n.home_top3,
      icon: Icons.task_alt,
      child: tasks.isEmpty
          ? EmptyState(
              message: l10n.home_nearTasksEmpty,
              actionLabel: l10n.tasks_addTask,
              onAction: () => showQuickAdd(context, kind: 'tugas'),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (i, task) in top3.indexed) ...[
                  if (i > 0) const Divider(height: 1),
                  _TopTaskRow(
                    number: i + 1,
                    task: task,
                    lang: lang,
                    now: now,
                    onToggle: () =>
                        ref.read(tasksProvider.notifier).toggleDone(task.id),
                  ),
                ],
              ],
            ),
    );
  }
}

class _TopTaskRow extends StatelessWidget {
  const _TopTaskRow({
    required this.number,
    required this.task,
    required this.lang,
    required this.now,
    required this.onToggle,
  });

  final int number;
  final Task task;
  final Lang lang;
  final DateTime now;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final nw = nwExt(context);
    final badge = taskBadge(task, lang, now);
    final hm = task.time.isEmpty ? '23:59' : task.time;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 22,
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: nw.accent,
                  height: 1.4,
                ),
              ),
            ),
          ),
          Checkbox(
            value: task.done,
            onChanged: (_) => onToggle(),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Expanded(
            child: InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: task.done ? nw.muted : nw.ink,
                        height: 1.4,
                        decoration: task.done
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${task.matkul} • ${fmtDateID(task.date, lang)} • $hm',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10.5, color: nw.muted),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          BadgePill(text: badge.txt, kind: badge.cls),
        ],
      ),
    );
  }
}
