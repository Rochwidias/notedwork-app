// Pengingat jadwal & tugas — port of the web app's `lib/reminders.ts`.
// Fungsi murni, tanpa widget: dipakai kartu hitung mundur + banner/bunyi.
//
// Konvensi waktu sama dgn repo web: tanggal `yyyy-mm-dd`, jam `hh:mm`, dan
// jam kosong = akhir hari (23:59) — konsisten dgn `isOverdue`/`taskBadge`.

/// Jenis acara pengingat — web: `ReminderItem.kind` (`"sched" | "task"`).
enum ReminderKind { sched, task }

/// Satu baris yang dipantau pengingat — web: `ReminderItem`.
class ReminderItem {
  const ReminderItem({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.kind,
    required this.reminderMin,
  });

  factory ReminderItem.fromJson(Map<String, dynamic> json) => ReminderItem(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    date: json['date'] as String? ?? '',
    time: json['time'] as String? ?? '',
    kind: switch (json['kind'] as String?) {
      'task' => ReminderKind.task,
      _ => ReminderKind.sched,
    },
    reminderMin: (json['reminderMin'] as num?)?.toInt() ?? 0,
  );

  final String id;
  final String title;

  /// yyyy-mm-dd.
  final String date;

  /// hh:mm (kosong = akhir hari 23:59).
  final String time;
  final ReminderKind kind;

  /// Menit sebelum acara; 0 = mati.
  final int reminderMin;

  ReminderItem copyWith({
    String? id,
    String? title,
    String? date,
    String? time,
    ReminderKind? kind,
    int? reminderMin,
  }) => ReminderItem(
    id: id ?? this.id,
    title: title ?? this.title,
    date: date ?? this.date,
    time: time ?? this.time,
    kind: kind ?? this.kind,
    reminderMin: reminderMin ?? this.reminderMin,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'date': date,
    'time': time,
    'kind': kind.name,
    'reminderMin': reminderMin,
  };

  @override
  bool operator ==(Object other) =>
      other is ReminderItem &&
      other.id == id &&
      other.title == title &&
      other.date == date &&
      other.time == time &&
      other.kind == kind &&
      other.reminderMin == reminderMin;

  @override
  int get hashCode =>
      Object.hash(id, title, date, time, kind, reminderMin);
}

/// Default bila `Sched`/`Task.reminderMin` tak diisi: 3 jam
/// (0 = mati disengaja) — web: `DEFAULT_REMINDER_MIN`.
const int defaultReminderMin = 180;

/// Toleransi kecocokan pengingat: ±60 detik — web: `DUE_TOLERANCE_MS`.
const int _dueToleranceMs = 60000;

/// Hasil [nextReminder].
class NextReminder {
  const NextReminder({
    required this.item,
    required this.at,
    required this.minsLeft,
  });

  final ReminderItem item;

  /// Waktu acara (lokal).
  final DateTime at;
  final int minsLeft;
}

/// Kejadian hari ini/besok terdekat yang belum lewat; `null` bila tak ada —
/// web: `nextReminder(items, now)`.
NextReminder? nextReminder(List<ReminderItem> items, DateTime now) {
  // Batas atas: tengah malam lusa (besok masih ikut).
  // `DateTime(y, m, d + 2)` = normalisasi kalender, sama dgn setDate() web.
  final end = DateTime(now.year, now.month, now.day + 2);
  final nowMs = now.millisecondsSinceEpoch;
  final endMs = end.millisecondsSinceEpoch;
  ReminderItem? bestItem;
  DateTime? bestAt;
  for (final item in items) {
    final at = _eventAt(item.date, item.time);
    if (at == null) continue;
    final atMs = at.millisecondsSinceEpoch;
    if (atMs < nowMs) continue; // sudah lewat
    if (atMs >= endMs) continue; // lusa ke atas
    if (bestAt == null || atMs < bestAt.millisecondsSinceEpoch) {
      bestItem = item;
      bestAt = at;
    }
  }
  if (bestItem == null || bestAt == null) return null;
  // at >= now selalu → floor sama dgn Math.floor() web (nilai >= 0).
  final minsLeft =
      (bestAt.millisecondsSinceEpoch - nowMs) ~/ 60000;
  return NextReminder(item: bestItem, at: bestAt, minsLeft: minsLeft);
}

/// Label hitung mundur: "sekarang" | "45 mnt lagi" | "2 jam lagi" | "besok"
/// — web: `formatCountdown(minsLeft)`.
String formatCountdown(int minsLeft) {
  if (minsLeft <= 0) return 'sekarang';
  if (minsLeft < 60) return '$minsLeft mnt lagi';
  if (minsLeft < 24 * 60) return '${minsLeft ~/ 60} jam lagi';
  return 'besok';
}

/// Pengingat yang tiba (momen acara − reminderMin, toleransi ±60 detik)
/// — web: `dueReminders(items, now)`.
List<ReminderItem> dueReminders(List<ReminderItem> items, DateTime now) {
  final t = now.millisecondsSinceEpoch;
  return items.where((it) {
    if (it.reminderMin <= 0) return false; // 0 = mati
    final at = _eventAt(it.date, it.time);
    if (at == null) return false;
    final fire = at.millisecondsSinceEpoch - it.reminderMin * 60000;
    return (t - fire).abs() <= _dueToleranceMs;
  }).toList();
}

/// Jam acara sebagai DateTime lokal; `null` bila tanggal/time rusak —
/// web: `eventAt(date, time)`.
DateTime? _eventAt(String date, String time) {
  if (!_dateRegex.hasMatch(date)) return null;
  // Time kosong ikut konvensi repo (isOverdue/taskBadge): akhir hari.
  final hm = _hmRegex.hasMatch(time) ? time : '23:59';
  return DateTime.tryParse('${date}T$hm:00');
}

final RegExp _dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
final RegExp _hmRegex = RegExp(r'^\d{2}:\d{2}$');
