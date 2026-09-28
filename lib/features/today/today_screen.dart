import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notedwork/core/dates.dart';
import 'package:notedwork/core/state/state.dart';
import 'package:notedwork/features/tasks/task_widgets.dart';
import 'package:notedwork/features/today/widgets/agenda_card.dart';
import 'package:notedwork/features/today/widgets/reminder_card.dart';
import 'package:notedwork/features/today/widgets/top_tasks_card.dart';
import 'package:notedwork/features/today/widgets/week_strip_card.dart';
import 'package:notedwork/l10n/app_localizations.dart';

/// Konten tab Beranda (tanpa Scaffold/AppBar/FAB — shell yang menyediakan).
class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  /// Jam acuan kartu pengingat/tugas; di-refresh tiap 30 detik agar
  /// hitung mundur ikut bergerak walau layar tidak di-build ulang.
  DateTime _now = DateTime.now();
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
      final n = DateTime.now();
      if (n.minute != _now.minute && mounted) {
        setState(() => _now = n);
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ext = nwExt(context);
    final l10n = AppLocalizations.of(context);
    final lang = ref.watch(settingsProvider).lang;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.home_title,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: ext.ink,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${fmtDateID(todayStr(), lang)} • ${l10n.home_hello}, '
            '${l10n.home_guestName}',
            style: TextStyle(fontSize: 12.5, color: ext.muted, height: 1.5),
          ),
          const SizedBox(height: 12),
          ReminderCard(now: _now),
          const SizedBox(height: 8),
          TopTasksCard(now: _now),
          const SizedBox(height: 8),
          const WeekStripCard(),
          const SizedBox(height: 8),
          const AgendaCard(),
        ],
      ),
    );
  }
}
