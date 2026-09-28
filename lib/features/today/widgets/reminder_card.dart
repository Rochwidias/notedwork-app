import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notedwork/core/dates.dart';
import 'package:notedwork/core/reminders.dart';
import 'package:notedwork/core/state/state.dart';
import 'package:notedwork/features/tasks/task_widgets.dart';
import 'package:notedwork/core/theme/palette.dart';
import 'package:notedwork/features/today/widgets/detail_sheet.dart';
import 'package:notedwork/l10n/app_localizations.dart';

/// Label hitung mundur — port `fmtCountdown` di HariIni.tsx memakai key
/// `home_dueSoon` / `home_inMin{n}` / `home_inHours{h,m}` /
/// `home_inHoursEven{h}` / `home_tomorrow` / `home_inDays{d}`.
String countdownLabel(int minsLeft, AppLocalizations l10n) {
  if (minsLeft < 1) return l10n.home_dueSoon;
  if (minsLeft < 60) return l10n.home_inMin('$minsLeft');
  final h = minsLeft ~/ 60;
  final r = minsLeft % 60;
  if (h < 24) {
    return r != 0 ? l10n.home_inHours('$h', '$r') : l10n.home_inHoursEven('$h');
  }
  final d = h ~/ 24;
  return d <= 1 ? l10n.home_tomorrow : l10n.home_inDays('$d');
}

/// Kartu pengingat (`.hero.slim` di web): gradasi hero + pill CTA,
/// seluruh kartu bisa ditekan. [now] di-inject layar induk agar hitung
/// mundur ikut hidup tiap tick.
class ReminderCard extends ConsumerWidget {
  const ReminderCard({super.key, required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nw = nwExt(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final lang = ref.watch(settingsProvider).lang;
    final next = nextReminder(ref.watch(reminderItemsProvider), now);

    final String headline;
    final String subline;
    final String? label;
    if (next != null) {
      label = countdownLabel(next.minsLeft, l10n);
      final time = next.item.time.isEmpty ? '23:59' : next.item.time;
      headline = '$label: ${next.item.title}';
      subline = '${fmtDateID(next.item.date, lang)} • $time';
    } else {
      label = null;
      headline = l10n.home_noReminder;
      subline = l10n.home_noReminderSub;
    }

    final semanticsLabel = next != null
        ? '${l10n.home_reminderPrefix}: $label, ${next.item.title}. '
              '${l10n.home_openCalendar}'
        : l10n.home_reminderAriaNone;

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: nw.heroGradient,
          borderRadius: BorderRadius.circular(nw.heroRadius),
          boxShadow: NwPalette.cardShadow(dark: dark),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(nw.heroRadius),
            onTap: () => showNwDetailSheet(
              context,
              title: next == null
                  ? l10n.home_reminderPrefix
                  : next.item.title,
              subtitle: next == null ? l10n.home_noReminderSub : subline,
              rows: next == null
                  ? const []
                  : [
                      (l10n.quick_dateLabel, fmtDateID(next.item.date, lang)),
                      (
                        l10n.quick_timeLabel,
                        next.item.time.isEmpty ? '23:59' : next.item.time,
                      ),
                      (l10n.home_reminderPrefix, label!),
                    ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: nw.onAccent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.notifications_none,
                          size: 14,
                          color: nw.onAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          headline,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: nw.onAccent,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subline,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: nw.onAccent.withValues(alpha: 0.9),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: nw.onAccent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${l10n.home_viewCalendar}  ›',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: nw.onAccent,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
