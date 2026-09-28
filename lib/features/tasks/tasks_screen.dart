import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notedwork/core/dates.dart';
import 'package:notedwork/core/models.dart';
import 'package:notedwork/core/state/state.dart';
import 'package:notedwork/core/theme/palette.dart';
import 'package:notedwork/features/tasks/task_sheet.dart';
import 'package:notedwork/features/tasks/task_widgets.dart';
import 'package:notedwork/l10n/app_localizations.dart';

enum _Filter { all, active, late, done }

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  _Filter _filter = _Filter.all;

  void _toggle(Task task) {
    ref.read(tasksProvider.notifier).toggleDone(task.id);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    nwToast(context, task.done ? l10n.toast_taskReopened : l10n.toast_taskDone);
  }

  Future<void> _delete(Task task) async {
    final ok = await confirmTaskDelete(context, task);
    if (!ok || !mounted) return;
    ref.read(tasksProvider.notifier).remove(task.id);
    if (!mounted) return;
    nwToast(context, AppLocalizations.of(context).toast_taskDeleted);
  }

  void _edit(Task task) => showTaskSheet(context, initial: task);

  void _add() => showTaskSheet(context);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = nwExt(context);
    final tasks = ref.watch(tasksProvider);
    final lang = ref.watch(settingsProvider).lang;
    final now = DateTime.now();

    var active = 0;
    var late = 0;
    var done = 0;
    for (final t in tasks) {
      if (t.done) {
        done++;
      } else {
        active++;
        if (isOverdue(t, now: now)) late++;
      }
    }

    final list =
        tasks.where((t) {
          return switch (_filter) {
            _Filter.all => true,
            _Filter.active => !t.done,
            _Filter.late => isOverdue(t, now: now),
            _Filter.done => t.done,
          };
        }).toList()..sort((a, b) {
          final d = (a.done ? 1 : 0) - (b.done ? 1 : 0);
          if (d != 0) return d;
          return '${a.date}${a.time}'.compareTo('${b.date}${b.time}');
        });

    final filters = <(_Filter, String, int)>[
      (_Filter.all, l10n.common_all, tasks.length),
      (_Filter.active, l10n.tasks_filterActive, active),
      (_Filter.late, l10n.tasks_filterOverdue, late),
      (_Filter.done, l10n.tasks_filterDone, done),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final (value, label, count) in filters) ...[
                  nwChip(
                    context,
                    label: '$label ($count)',
                    selected: _filter == value,
                    onTap: () => setState(() => _filter = value),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            children: [
              for (final task in list)
                _TaskRow(
                  task: task,
                  lang: lang,
                  now: now,
                  onToggle: () => _toggle(task),
                  onEdit: () => _edit(task),
                  onDelete: () => _delete(task),
                ),
              if (list.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 24,
                  ),
                  child: Text(
                    l10n.tasks_emptyHere,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.7,
                      color: ext.muted,
                    ),
                  ),
                ),
              const SizedBox(height: 6),
              FilledButton.icon(
                onPressed: _add,
                icon: const Icon(Icons.add, size: 16),
                label: Text(l10n.tasks_addTask),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.task,
    required this.lang,
    required this.now,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Task task;
  final Lang lang;
  final DateTime now;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ext = nwExt(context);
    final semantic = nwSemantic(context);
    final badge = taskBadge(task, lang, now);
    final meta = <String>[
      task.matkul,
      fmtDateID(task.date, lang),
      if (task.time.isNotEmpty) task.time,
      if (task.note.isNotEmpty) task.note,
    ].join(' • ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ext.line),
          boxShadow: NwPalette.cardShadow(
            dark: theme.brightness == Brightness.dark,
          ),
        ),
        child: Material(
          color: ext.card,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: Semantics(
            container: true,
            button: true,
            label:
                '${task.title} — ${task.done ? l10n.tasks_stateDone : l10n.tasks_stateActive}',
            child: InkWell(
              onTap: onEdit,
              child: Opacity(
                opacity: task.done ? 0.65 : 1,
                child: Padding(
                  padding: const EdgeInsets.all(13),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        button: true,
                        checked: task.done,
                        label:
                            '${task.title} — ${task.done ? l10n.tasks_stateDone : l10n.tasks_stateActive}',
                        child: Tooltip(
                          message: task.done
                              ? l10n.tasks_reopen
                              : l10n.common_markDone,
                          child: InkWell(
                            onTap: onToggle,
                            customBorder: const CircleBorder(),
                            child: Container(
                              width: 32,
                              height: 32,
                              margin: const EdgeInsets.only(top: 1),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: task.done
                                    ? semantic.green
                                    : Colors.transparent,
                                border: Border.all(
                                  color: task.done ? semantic.green : ext.muted,
                                  width: 2,
                                ),
                              ),
                              child: task.done
                                  ? const Icon(
                                      Icons.check,
                                      size: 15,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                decoration: task.done
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              meta,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 12,
                                color: ext.muted,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                nwTag(
                                  context,
                                  label: prioLabel(task.prio, lang),
                                  css: prioShort(task.prio),
                                ),
                                nwTag(
                                  context,
                                  label: badge.txt,
                                  css: badge.css,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.common_edit,
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_outlined, size: 17),
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 44,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      IconButton(
                        tooltip: l10n.common_delete,
                        onPressed: onDelete,
                        icon: const Icon(Icons.close, size: 17),
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 44,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 13),
                        child: Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: ext.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
