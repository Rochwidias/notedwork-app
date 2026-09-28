// Port dari web `tests/repro.mjs` (blok dates/uid/badge),
// `tests/repro-fix.mjs` (V3 timezone), dan `tests/repro-cepat.mjs` (#20 urgency).
// Asumsi i18n dites di file lain — di sini hanya logika murni lib/core.

import 'package:flutter_test/flutter_test.dart';
import 'package:notedwork/core/dates.dart';
import 'package:notedwork/core/models.dart';

String isoOf(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String hmOf(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

Task makeTask({
  String date = '2026-09-16',
  String time = '',
  bool done = false,
  Prio prio = Prio.medium,
}) => Task(
  id: 'task-1',
  matkul: 'Basis Data',
  title: 'Laporan modul',
  date: date,
  time: time,
  prio: prio,
  note: '',
  done: done,
);

Sched makeSched({
  String date = '2026-09-16',
  String time = '00:00',
  String? endTime,
  bool allDay = false,
  bool overnight = false,
}) => Sched(
  id: 'x',
  title: 't',
  date: date,
  time: time,
  endTime: endTime,
  allDay: allDay,
  overnight: overnight,
  note: '',
  color: '',
);

void main() {
  final today = todayStr();

  group('isOverdue / taskBadge (repro.mjs)', () {
    test('isOverdue: tugas hari ini tanpa jam TIDAK telat', () {
      expect(isOverdue(makeTask(date: today, time: '')), isFalse);
    });

    test('isOverdue konsisten dengan taskBadge (bukan Telat*)', () {
      // Guard sama dgn web: 1 menit terakhir hari ini deadline 23:59 sudah lewat.
      if (nowHM().compareTo('23:59') < 0) {
        final badge = taskBadge(makeTask(date: today, time: ''));
        expect(badge.txt.startsWith('Telat'), isFalse);
        expect(badge.txt.startsWith('Late'), isFalse);
      }
    });

    test('isOverdue: tugas kemarin tanpa jam tetap TELAT', () {
      final y = DateTime.now().subtract(const Duration(days: 1));
      expect(isOverdue(makeTask(date: isoOf(y), time: '')), isTrue);
    });

    test('isOverdue: done=true tidak telat', () {
      expect(
        isOverdue(makeTask(date: '2000-01-01', time: '', done: true)),
        isFalse,
      );
    });

    test('isOverdue: hari ini 23:59 tidak telat bila sekarang < 23:59', () {
      // Web: `nowHM() < "23:59" ? isOverdue({... 23:59}) === false : true`.
      if (nowHM().compareTo('23:59') < 0) {
        expect(isOverdue(makeTask(date: today, time: '23:59')), isFalse);
      }
    });

    test('isOverdue: jam lewat hari ini sudah telat (injeksi waktu)', () {
      final ref = DateTime(2026, 9, 16, 10, 0);
      expect(
        isOverdue(makeTask(date: '2026-09-16', time: '09:00'), now: ref),
        isTrue,
      );
      expect(
        isOverdue(makeTask(date: '2026-09-16', time: '10:00'), now: ref),
        isFalse,
      );
      expect(
        isOverdue(makeTask(date: '2026-09-17', time: '00:01'), now: ref),
        isFalse,
      );
    });

    test('taskBadge: klasifikasi done/telat/hari ini/besok/sisa', () {
      final ref = DateTime(2026, 9, 16, 10, 0);

      final done = taskBadge(makeTask(done: true), Lang.id, ref);
      expect(done.txt, 'Selesai');
      expect(done.cls, BadgeKind.lo);
      expect(done.css, 'lo');
      expect(taskBadge(makeTask(done: true), Lang.en, ref).txt, 'Done');

      final now = taskBadge(makeTask(date: '2026-09-16', time: '14:30'), Lang.id, ref);
      expect(now.txt, 'Hari ini • 14:30');
      expect(now.cls, BadgeKind.hi);

      final tomorrow = taskBadge(makeTask(date: '2026-09-17', time: '10:00'), Lang.id, ref);
      expect(tomorrow.txt, 'Besok • 10:00');
      expect(tomorrow.cls, BadgeKind.md);
      expect(
        taskBadge(makeTask(date: '2026-09-17', time: '10:00'), Lang.en, ref).txt,
        'Tomorrow • 10:00',
      );

      final far = taskBadge(makeTask(date: '2026-09-21', time: '10:00'), Lang.id, ref);
      expect(far.txt, 'Sisa 5 hari');
      expect(far.cls, BadgeKind.due);
      expect(
        taskBadge(makeTask(date: '2026-09-21', time: '10:00'), Lang.en, ref).txt,
        '5 days left',
      );

      final late = taskBadge(makeTask(date: '2026-09-16', time: '10:00'), Lang.id, DateTime(2026, 9, 17, 10, 0));
      expect(late.txt, 'Telat!');
      expect(late.cls, BadgeKind.over);

      final late3 = taskBadge(makeTask(date: '2026-09-13', time: '10:00'), Lang.id, ref);
      expect(late3.txt, 'Telat 3 hari');
      expect(late3.cls, BadgeKind.over);
      expect(
        taskBadge(makeTask(date: '2026-09-13', time: '10:00'), Lang.en, ref).txt,
        'Late 3 days',
      );
    });

    test('taskBadge: time kosong memakai default 23:59', () {
      final ref = DateTime(2026, 9, 16, 23, 58);
      expect(taskBadge(makeTask(date: '2026-09-16', time: ''), Lang.id, ref).cls, BadgeKind.hi);
      expect(taskBadge(makeTask(date: '2026-09-16', time: ''), Lang.id, DateTime(2026, 9, 16, 23, 59, 30)).cls, BadgeKind.over);
    });
  });

  group('fmtSchedRange (repro.mjs)', () {
    test('allDay = Seharian', () {
      expect(fmtSchedRange(makeSched(allDay: true)), 'Seharian');
      expect(fmtSchedRange(makeSched(allDay: true), Lang.en), 'All day');
    });

    test('overnight 23:00-01:00 + besok', () {
      final s = makeSched(time: '23:00', endTime: '01:00', overnight: true);
      // "23:00–01:00 · besok" (en dash U+2013 + middot U+00B7).
      expect(fmtSchedRange(s), '23:00\u201301:00 \u00B7 besok');
    });

    test('rentang normal & sekilas', () {
      expect(fmtSchedRange(makeSched(time: '10:00', endTime: '11:30')), '10:00\u201311:30');
      expect(fmtSchedRange(makeSched(time: '10:00', endTime: '10:00')), '10:00');
      expect(fmtSchedRange(makeSched(time: '10:00', endTime: 'x')), '10:00');
    });
  });

  group('monthWindow (repro.mjs)', () {
    test('anti-overflow: 31 Mar, back=1 → dari Feb (bukan Maret!)', () {
      final w = monthWindow(1, 2, DateTime(2026, 3, 31));
      expect(w.from, '2026-02-01');
      expect(w.to, '2026-05-31');
    });

    test('default back=1 fwd=2 dari tengah bulan', () {
      // Web `new Date(y, m + fwd + 1, 0)` 0-based = akhir bulan +2.
      final w = monthWindow(1, 2, DateTime(2026, 9, 16));
      expect(w.from, '2026-08-01');
      expect(w.to, '2026-11-30');
    });
  });

  group('uid (repro.mjs)', () {
    test('1000x unik', () {
      final ids = <String>{for (var i = 0; i < 1000; i++) uid()};
      expect(ids.length, 1000);
    });

    test('prefix default id & prefix kustom', () {
      expect(uid().startsWith('id'), isTrue);
      expect(uid('tsk').startsWith('tsk'), isTrue);
    });
  });

  group('resolveTimeZone (repro-fix.mjs V3)', () {
    test('zona valid dipertahankan', () {
      expect(resolveTimeZone('Asia/Makassar'), 'Asia/Makassar');
      expect(resolveTimeZone('Asia/Jakarta'), 'Asia/Jakarta');
    });

    test('zona aneh fallback Asia/Jakarta', () {
      expect(resolveTimeZone('Bukan/Zona'), 'Asia/Jakarta');
    });

    test('kosong/null/tanpa argumen fallback Asia/Jakarta', () {
      expect(resolveTimeZone(''), 'Asia/Jakarta');
      expect(resolveTimeZone(null), 'Asia/Jakarta');
      expect(resolveTimeZone(), 'Asia/Jakarta');
      expect(defaultTz, 'Asia/Jakarta');
    });
  });

  group('tzOffsetString (repro-fix.mjs V3)', () {
    test('offset WIB +07:00', () {
      expect(tzOffsetString('Asia/Jakarta', '2026-09-16', '10:00'), '+07:00');
    });

    test('offset WITA +08:00', () {
      expect(tzOffsetString('Asia/Makassar', '2026-09-16', '10:00'), '+08:00');
    });

    test('offset New York Januari -05:00', () {
      expect(tzOffsetString('America/New_York', '2026-01-16', '10:00'), '-05:00');
    });

    test('offset New York Juli -04:00 (DST)', () {
      expect(tzOffsetString('America/New_York', '2026-07-16', '10:00'), '-04:00');
    });

    test('zona tak dikenal dipakai fallback WIB', () {
      expect(tzOffsetString('Bukan/Zona', '2026-09-16', '10:00'), '+07:00');
    });

    test('tanggal rusak → +07:00 (web: Date.parse NaN)', () {
      expect(tzOffsetString('Asia/Jakarta', 'bukan', '10:00'), '+07:00');
    });
  });

  group('urgencyLevel (repro-cepat.mjs #20)', () {
    test('H-1 (hari ini) + telat merah', () {
      expect(urgencyLevel('2026-09-22', '2026-09-22'), Urgency.red);
      expect(urgencyLevel('2026-09-20', '2026-09-22'), Urgency.red);
    });

    test('H-2 (besok) kuning (amber)', () {
      expect(urgencyLevel('2026-09-23', '2026-09-22'), Urgency.amber);
    });

    test('H-3 (lusa) dan jauh hijau', () {
      expect(urgencyLevel('2026-09-24', '2026-09-22'), Urgency.green);
      expect(urgencyLevel('2026-10-05', '2026-09-22'), Urgency.green);
    });

    test('tanggal rusak → hijau (web: Number.isFinite)', () {
      expect(urgencyLevel('bukan-tanggal', '2026-09-22'), Urgency.green);
      expect(urgencyLevel('2026-09-24', 'bukan-tanggal'), Urgency.green);
    });
  });

  group('helper tanggal & label', () {
    test('weekdayOf: Senin=1 … Minggu=7', () {
      expect(weekdayOf('2026-09-14'), 1); // Senin
      expect(weekdayOf('2026-09-16'), 3); // Rabu
      expect(weekdayOf('2026-09-20'), 7); // Minggu
      expect(weekdayOf('bukan'), 0); // tak terbaca → 0 (web: NaN)
    });

    test('todayStr/nowHM format', () {
      expect(RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(todayStr()), isTrue);
      expect(RegExp(r'^\d{2}:\d{2}$').hasMatch(nowHM()), isTrue);
      expect(todayStr(), isoOf(DateTime.now()));
    });

    test('fmtDateID id + en', () {
      expect(fmtDateID('2026-09-16'), 'Rabu, 16 September 2026');
      expect(fmtDateID('2026-09-16', Lang.en), 'Wednesday, September 16, 2026');
      expect(fmtDateID('bukan'), 'bukan'); // rusak → input apa adanya
    });

    test('dayNames/monthNames/dow3/dowInitials', () {
      expect(dayNames(Lang.id).first, 'Senin');
      expect(dayNames(Lang.en).last, 'Sunday');
      expect(monthNames(Lang.id)[8], 'September');
      expect(monthNames(Lang.en)[0], 'January');
      expect(dow3(Lang.id), ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']);
      expect(dow3(Lang.en), ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']);
      expect(dowInitials(Lang.id), ['S', 'S', 'R', 'K', 'J', 'S', 'M']);
      expect(dowInitials(Lang.en), ['M', 'T', 'W', 'T', 'F', 'S', 'S']);
    });

    test('prioLabel + prioShort (PRIO)', () {
      expect(prioLabel(Prio.high), 'Tinggi');
      expect(prioLabel(Prio.medium), 'Sedang');
      expect(prioLabel(Prio.low), 'Rendah');
      expect(prioLabel(Prio.high, Lang.en), 'High');
      expect(prioLabel(Prio.medium, Lang.en), 'Medium');
      expect(prioLabel(Prio.low, Lang.en), 'Low');
      expect(prioShort(Prio.high), 'hi');
      expect(prioShort(Prio.medium), 'md');
      expect(prioShort(Prio.low), 'lo');
    });

    test('esc', () {
      expect(esc('<a href="x">&\''), '&lt;a href=&quot;x&quot;&gt;&amp;&#39;');
      expect(esc('biasa saja'), 'biasa saja');
    });

    test('palet warna', () {
      expect(routineColors, [
        '#D97706',
        '#16a34a',
        '#b45309',
        '#7c5cff',
        '#ec4899',
        '#dc2626',
      ]);
      expect(schedColors, [
        '#16a34a',
        '#D97706',
        '#b45309',
        '#7c5cff',
        '#ec4899',
        '#dc2626',
      ]);
    });
  });

  group('models (lib/types.ts)', () {
    test('Prio key tetap wire Indonesia + fallback sedang', () {
      expect(Prio.high.key, 'tinggi');
      expect(Prio.medium.key, 'sedang');
      expect(Prio.low.key, 'rendah');
      expect(Prio.fromKey('tinggi'), Prio.high);
      expect(Prio.fromKey('aneh'), Prio.medium);
      expect(Prio.fromKey(null), Prio.medium);
    });

    test('Task toJson/fromJson round-trip', () {
      final t = makeTask(date: '2026-09-16', time: '23:59', prio: Prio.high)
          .copyWith(reminderMin: 30);
      final json = t.toJson();
      expect(json['prio'], 'tinggi');
      expect(json['reminderMin'], 30);
      expect(Task.fromJson(json), t);

      final empty = Task.fromJson(const {});
      expect(empty.id, '');
      expect(empty.done, isFalse);
      expect(empty.prio, Prio.medium); // fallback web: ?? "sedang"
      expect(empty.reminderMin, isNull);
    });

    test('Sched/Note/Routine optional ter-encode bersih', () {
      const s = Sched(
        id: 's1',
        title: 'Kuliah',
        date: '2026-09-16',
        time: '10:00',
        note: '',
        color: '#16a34a',
      );
      expect(s.toJson().containsKey('endTime'), isFalse);
      expect(s.toJson().containsKey('reminderMin'), isFalse);
      expect(Sched.fromJson(s.toJson()), s);
      expect(s.copyWith(endTime: null).endTime, isNull);
      expect(s.copyWith(endTime: '11:00').endTime, '11:00');

      const n = Note(id: 'n1', title: 'Judul', body: 'Isi', updatedAt: 123);
      expect(n.toJson().containsKey('driveFileId'), isFalse);
      expect(Note.fromJson(n.toJson()), n);

      const r = Routine(
        id: 'r1',
        course: 'PBO',
        day: 7,
        start: '08:00',
        end: '09:30',
        room: '2A',
        lect: 'Pak Andi',
        color: '#7c5cff',
      );
      expect(Routine.fromJson(r.toJson()), r);
      expect(r.day, 7); // Minggu
    });

    test('NavTarget/ViewName', () {
      expect(NavTarget.fromView(ViewName.kalender), NavTarget.kalender);
      expect(NavTarget.tambah.view, isNull);
      expect(NavTarget.email.view, ViewName.email);
      expect(AppTheme.auto.name, 'auto');
    });
  });
}
