// Date/time helpers — port of the web app's `lib/dates.ts`.
// Pure Dart (no Flutter): semua aturan tanggal di sini bisa diuji headless.
//
// Catatan porting:
// * `Lang`/label Indonesia tetap dipertahankan (web men-hardcode label di
//   file ini, bukan di i18n) — label UI lain tetap milik file ARB.
// * `taskBadge`/`isOverdue` menerima `now` opsional untuk injeksi waktu
//   (default `DateTime.now()`, perilaku web tidak berubah).
//
// `intl` hanya terpasang sebagai dependensi transitif dan pubspec.yaml
// di luar cakupan porting ini, jadi lint-nya diabaikan di file ini.
// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'models.dart';

/// Nama hari panjang (Senin…Minggu) — web: `DAYS`.
const List<String> daysId = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

/// Nama hari panjang EN — web: `DAYS_EN`.
const List<String> daysEn = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

/// Nama bulan panjang (Januari…Desember) — web: `MONTHS`.
const List<String> monthsId = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

/// Nama bulan panjang EN — web: `MONTHS_EN`.
const List<String> monthsEn = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Singkatan hari 3 huruf ID — web: `DOW3_ID`.
const List<String> dow3Id = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

/// Singkatan hari 3 huruf EN — web: `DOW3_EN`.
const List<String> dow3En = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

/// Inisial hari ID — web: `DOW1_ID`.
const List<String> dow1Id = ['S', 'S', 'R', 'K', 'J', 'S', 'M'];

/// Inisial hari EN — web: `DOW1_EN`.
const List<String> dow1En = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

/// Warna acak untuk routine/tugas baru (urutan sama web) — web: `RCOL`.
const List<String> routineColors = [
  '#D97706',
  '#16a34a',
  '#b45309',
  '#7c5cff',
  '#ec4899',
  '#dc2626',
];

/// Palet warna jadwal — web: `SCHED_COLORS`.
const List<String> schedColors = [
  '#16a34a',
  '#D97706',
  '#b45309',
  '#7c5cff',
  '#ec4899',
  '#dc2626',
];

/// Zona default app (WIB) — web: `DEFAULT_TZ`.
const String defaultTz = 'Asia/Jakarta';

/// Nama hari panjang sesuai bahasa — web: `dayNames(lang)`.
List<String> dayNames(Lang lang) => lang == Lang.en ? daysEn : daysId;

/// Nama bulan panjang sesuai bahasa — web: `monthNames(lang)`.
List<String> monthNames(Lang lang) => lang == Lang.en ? monthsEn : monthsId;

/// Singkatan hari 3 huruf — web: `dow3(lang)`.
List<String> dow3(Lang lang) => lang == Lang.en ? dow3En : dow3Id;

/// Inisial hari (header kalender) — web: `dowInitials(lang)`.
List<String> dowInitials(Lang lang) => lang == Lang.en ? dow1En : dow1Id;

/// Label prioritas — web: `prioLabel(p, lang)`.
String prioLabel(Prio p, [Lang lang = Lang.id]) {
  if (lang == Lang.en) {
    return switch (p) {
      Prio.high => 'High',
      Prio.medium => 'Medium',
      Prio.low => 'Low',
    };
  }
  return switch (p) {
    Prio.high => 'Tinggi',
    Prio.medium => 'Sedang',
    Prio.low => 'Rendah',
  };
}

/// Kode pendek prioritas (chip) — web: `PRIO[p][1]`.
String prioShort(Prio p) => switch (p) {
  Prio.high => 'hi',
  Prio.medium => 'md',
  Prio.low => 'lo',
};

/// Hari ini sebagai `yyyy-mm-dd` (waktu lokal) — web: `todayStr()`.
String todayStr() => _isoDate(DateTime.now());

/// Jam sekarang `HH:MM` (waktu lokal) — web: `nowHM()`.
String nowHM() => _hmOf(DateTime.now());

/// Senin=1 … Minggu=7 — web: `weekdayOf(iso)`.
///
/// Input tak terbaca menghasilkan `0` (web menghasilkan `NaN`); pemanggil
/// wajib mem-bounds-check saat dipakai sebagai index.
int weekdayOf(String iso) => _parseWall(iso)?.weekday ?? 0;

/// Tanggal panjang: "Rabu, 16 September 2026" / "Wednesday, September 16, 2026"
/// — web: `fmtDateID(iso, lang)` (`toLocaleDateString` id-ID/en-US).
///
/// Input tak terbaca dikembalikan apa adanya (web: "Invalid Date").
String fmtDateID(String iso, [Lang lang = Lang.id]) {
  final d = _parseWall(iso);
  if (d == null) return iso;
  _ensureIntlDateData();
  final locale = lang == Lang.en ? 'en_US' : 'id';
  try {
    return DateFormat.yMMMMEEEEd(locale).format(d);
  } catch (_) {
    // Fallback bila data CLDR gagal dimuat: pola sama persis dgn locale di atas.
    return lang == Lang.en
        ? '${daysEn[d.weekday - 1]}, ${monthsEn[d.month - 1]} ${d.day}, ${d.year}'
        : '${daysId[d.weekday - 1]}, ${d.day} ${monthsId[d.month - 1]} ${d.year}';
  }
}

/// Rentang jam agenda: "Seharian" (all-day) · "10:00–11:30 · besok" (overnight)
/// · "10:00–11:30" · "10:00" — web: `fmtSchedRange(s, lang)`.
String fmtSchedRange(Sched s, [Lang lang = Lang.id]) {
  if (s.allDay == true) return lang == Lang.en ? 'All day' : 'Seharian';
  final end = s.endTime;
  if (s.overnight == true && end != null && _hmRegex.hasMatch(end)) {
    return '${s.time}–$end · ${lang == Lang.en ? 'tomorrow' : 'besok'}';
  }
  if (end != null && _hmRegex.hasMatch(end) && end != s.time) {
    return '${s.time}–$end';
  }
  return s.time;
}

/// Tugas sudah lewat deadline? — web: `isOverdue(t)`.
///
/// Perbandingan memakai string ISO (bukan DateTime) persis seperti web;
/// [now] hanya untuk injeksi waktu pada tes.
bool isOverdue(Task t, {DateTime? now}) {
  if (t.done) return false;
  // time kosong = akhir hari (konsisten dgn taskBadge yang default "23:59").
  // Tanpa ini, "2026-09-16" + "" < "2026-09-1614:30" selalu true → false-overdue.
  final hm = _hmRegex.hasMatch(t.time) ? t.time : '23:59';
  final ref = now ?? DateTime.now();
  // compareTo = urutan code-unit, sama dgn perbandingan string JS.
  return '${t.date}$hm'.compareTo('${_isoDate(ref)}${_hmOf(ref)}') < 0;
}

/// Level urgensi deadline berdasar selisih hari kalender (date - today):
/// H-1 (hari ini + telat) = red; H-2 (besok) = amber; H-3 (lusa) ke atas =
/// green — web: `urgencyLevel(dateIso, todayIso)`.
Urgency urgencyLevel(String dateIso, String todayIso) {
  final d = _parseWall(dateIso);
  final t = _parseWall(todayIso);
  if (d == null || t == null) return Urgency.green;
  final diff = ((d.millisecondsSinceEpoch - t.millisecondsSinceEpoch) /
          86400000)
      .round();
  if (diff <= 0) return Urgency.red;
  if (diff == 1) return Urgency.amber;
  return Urgency.green;
}

/// Badge deadline tugas — web: `taskBadge(t, lang)` → `{ txt, cls }`.
///
/// [now] opsional untuk injeksi waktu pada tes.
TaskBadge taskBadge(Task t, [Lang lang = Lang.id, DateTime? now]) {
  final en = lang == Lang.en;
  if (t.done) return TaskBadge(en ? 'Done' : 'Selesai', BadgeKind.lo);
  // Web: `t.time || "23:59"` — hanya string kosong yang dianggap tak ada jam.
  final hm = t.time.isEmpty ? '23:59' : t.time;
  final deadline = _parseWall('${t.date}T$hm:00');
  final ref = now ?? DateTime.now();
  if (deadline == null) {
    // Tanggal/time rusak: web jatuh ke "Sisa NaN hari". Tampilkan nilai
    // mentahnya supaya datanya korup langsung terlihat dan UI tidak crash.
    return TaskBadge(t.date, BadgeKind.due);
  }
  final diff = deadline.millisecondsSinceEpoch - ref.millisecondsSinceEpoch;
  if (diff < 0) {
    final d = (-diff / 86400000).ceil();
    if (d <= 1) return TaskBadge(en ? 'Late!' : 'Telat!', BadgeKind.over);
    return TaskBadge(
      en ? 'Late $d days' : 'Telat $d hari',
      BadgeKind.over,
    );
  }
  final daysLeft = (diff / 86400000).floor();
  if (daysLeft == 0) {
    return TaskBadge('${en ? 'Today' : 'Hari ini'} • ${t.time}', BadgeKind.hi);
  }
  if (daysLeft == 1) {
    return TaskBadge('${en ? 'Tomorrow' : 'Besok'} • ${t.time}', BadgeKind.md);
  }
  return TaskBadge(
    en ? '$daysLeft days left' : 'Sisa $daysLeft hari',
    BadgeKind.due,
  );
}

/// Escape karakter HTML — web: `esc(s)`.
String esc(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');

/// Jendela kalender anti-overflow: [from] = tanggal 1 (back bulan lalu),
/// [to] = hari terakhir (fwd bulan depan). Konstruktor `DateTime(y, m, 1)` /
/// `DateTime(y, m, 0)` tak pernah melompat bulan seperti setMonth dari
/// tanggal 29–31 — web: `monthWindow(back, fwd, now)`.
({String from, String to}) monthWindow([
  int back = 1,
  int fwd = 2,
  DateTime? now,
]) {
  final n = now ?? DateTime.now();
  final from = DateTime(n.year, n.month - back, 1);
  final to = DateTime(n.year, n.month + fwd + 1, 0);
  return (from: _isoDate(from), to: _isoDate(to));
}

/// ID unik lokal: prefix + base36 waktu + acak (anti-kembar `Date.now()`
/// murni) — web: `uid(prefix)`.
String uid([String prefix = 'id']) {
  final ts = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
  final rand = StringBuffer();
  for (var i = 0; i < 6; i++) {
    rand.write(_base36[_random.nextInt(_base36.length)]);
  }
  return '$prefix$ts$rand';
}

/// Validasi zona IANA; fallback [defaultTz] bila tak dikenal/kosong —
/// web: `resolveTimeZone(tz?)`.
String resolveTimeZone([String? zone]) {
  if (zone == null || zone.isEmpty) return defaultTz;
  try {
    _location(zone);
    return zone;
  } on tz.LocationNotFoundException {
    return defaultTz;
  }
}

/// Offset "+HH:MM" zona [zone] pada tanggal/waktu dinding tertentu
/// (DST-aware, dua iterasi agar tepat di sekitar transisi DST) —
/// web: `tzOffsetString(tz, date, time)`.
///
/// Input tidak valid → `"+07:00"` (web: `Date.parse` NaN → default).
String tzOffsetString(String zone, String date, String time) {
  final loc = _location(resolveTimeZone(zone));
  final guessMs = _parseWall('${date}T$time:00Z')?.millisecondsSinceEpoch;
  if (guessMs == null) return '+07:00';
  final off1 = _offsetMinutesAt(loc, guessMs);
  final off = _offsetMinutesAt(loc, guessMs - off1 * 60000);
  final sign = off < 0 ? '-' : '+';
  final abs = off.abs();
  final hh = (abs ~/ 60).toString().padLeft(2, '0');
  final mm = (abs % 60).toString().padLeft(2, '0');
  return '$sign$hh:$mm';
}

/// Level urgensi — web: `urgencyLevel(...)` → `"red" | "amber" | "green"`.
enum Urgency { red, amber, green }

/// Kelas badge CSS — web: `taskBadge(...).cls` (`"lo" | "over" | "hi" | "md" |
/// "due"`). Nama nilai = nilai CSS-nya.
enum BadgeKind {
  /// `lo` — tugas selesai.
  lo,

  /// `over` — telat.
  over,

  /// `hi` — jatuh tempo hari ini.
  hi,

  /// `md` — jatuh tempo besok.
  md,

  /// `due` — masih ada sisa hari.
  due;
}

/// Hasil `taskBadge`: [txt] label siap tampil, [cls] klasifikasi web.
class TaskBadge {
  const TaskBadge(this.txt, this.cls);

  final String txt;
  final BadgeKind cls;

  /// String kelas CSS persis milik web (`lo` | `over` | `hi` | `md` | `due`).
  String get css => cls.name;
}

final RegExp _hmRegex = RegExp(r'^\d{2}:\d{2}$');
final _random = Random();
const String _base36 = '0123456789abcdefghijklmnopqrstuvwxyz';

String _isoDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String _hmOf(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

DateTime? _parseWall(String s) => DateTime.tryParse(s);

/// Offset menit zona [loc] pada satu instant UTC (satu-pass, cukup untuk
/// boundary) — web: `offsetMinutesAt(zone, utcMs)`.
int _offsetMinutesAt(tz.Location loc, int utcMs) {
  final t = tz.TZDateTime.fromMillisecondsSinceEpoch(loc, utcMs);
  final asUtc = DateTime.utc(
    t.year,
    t.month,
    t.day,
    t.hour,
    t.minute,
    t.second,
  ).millisecondsSinceEpoch;
  return ((asUtc - utcMs) / 60000).round();
}

tz.Location _location(String name) {
  _ensureTzdb();
  return tz.getLocation(name);
}

bool _tzdbReady = false;

void _ensureTzdb() {
  if (_tzdbReady) return;
  tzdata.initializeTimeZones();
  _tzdbReady = true;
}

bool _intlReady = false;

/// Data CLDR untuk `DateFormat`; badan `initializeDateFormatting` berjalan
/// sinkron (mengembalikan `Future.value()`), jadi aman dipanggil dari sini.
void _ensureIntlDateData() {
  if (_intlReady) return;
  initializeDateFormatting();
  _intlReady = true;
}
