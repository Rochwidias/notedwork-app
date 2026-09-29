// lib/core/widget/agenda_payload.dart
import 'dart:convert';
import 'package:notedwork/core/models.dart';

/// Payload agenda untuk widget layar utama.
/// Semua pemformatan bahasa (header/emptyText) dilakukan pemanggil.
String buildAgendaPayload({
  required List<Sched> scheds,
  required List<Routine> routines,
  required List<Task> tasks,
  required DateTime now,
  required String header,
  required String emptyText,
  required String dateNum,
  required String dateDow,
  required String sub,
  required String count,
  required String routineLabel,
  required String schedLabel,
  required String taskLabel,
}) {
  // yyyy-MM-dd lokal; todayStr() di dates.dart tanpa argumen, jadi helper sendiri.
  String iso(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  final today = iso(now);
  final horizon = iso(now.add(const Duration(days: 7)));
  const taskColor = '#DC2626'; // BadgeKind.over / deadline merah (globals.css)

  final items = <Map<String, Object?>>[];

  // 1) Rutin mingguan (selalu ikut; provider mencocokkan hari)
  for (final r in routines) {
    items.add({'kind': 'rutin', 'day': r.day, 'time': r.start, 'end': r.end,
      'title': r.course, 'color': r.color.isEmpty ? '#D97706' : r.color});
  }
  // 2) Sched: hari ini s/d +7 (kemarin terbuang oleh perbandingan)
  final schedsSorted = [...scheds]..sort((a, b) => a.date.compareTo(b.date));
  for (final s in schedsSorted) {
    if (s.date.compareTo(today) < 0) continue;
    if (s.date.compareTo(horizon) > 0) continue;
    items.add({'kind': 'jadwal', 'date': s.date,
      'time': (s.allDay ?? false) ? '' : s.time, 'title': s.title,
      'color': s.color.isEmpty ? '#D97706' : s.color});
  }
  // 3) Tugas belum selesai, deadline hari ini s/d +7
  final tasksSorted = [...tasks]..sort((a, b) => a.date.compareTo(b.date));
  for (final t in tasksSorted) {
    if (t.done) continue;
    if (t.date.compareTo(today) < 0) continue;
    if (t.date.compareTo(horizon) > 0) continue;
    items.add({'kind': 'tugas', 'date': t.date,
      'time': (t.time.isEmpty ? '23:59' : t.time), 'title': t.title,
      'color': taskColor});
  }

  return jsonEncode({
    'header': header,
    'empty': emptyText,
    'dateNum': dateNum,
    'dateDow': dateDow,
    'sub': sub,
    'count': count,
    'labels': {'rutin': routineLabel, 'jadwal': schedLabel, 'tugas': taskLabel},
    'items': items,
  });
}
