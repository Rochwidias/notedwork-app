// Port dari web `tests/repro.mjs` (blok reminders) + cek DEFAULT_REMINDER_MIN
// dari `tests/repro-cepat.mjs` (#17).

import 'package:flutter_test/flutter_test.dart';
import 'package:notedwork/core/reminders.dart';

String isoOf(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String hmOf(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

ReminderItem mk(DateTime at, String id, {int reminderMin = 15}) =>
    ReminderItem(
      id: id,
      title: id,
      date: isoOf(at),
      time: hmOf(at),
      kind: ReminderKind.sched,
      reminderMin: reminderMin,
    );

void main() {
  test('DEFAULT_REMINDER_MIN = 180 (repro-cepat #17)', () {
    expect(defaultReminderMin, 180);
  });

  group('nextReminder (repro.mjs)', () {
    test('pilih terdekat, abaikan yang lewat', () {
      final now = DateTime(2026, 9, 16, 10, 0);
      final past = DateTime(2026, 9, 16, 9, 0);
      final near = DateTime(2026, 9, 16, 10, 30);
      final far = DateTime(2026, 9, 16, 12, 0);
      final r = nextReminder(
        [mk(far, 'jauh'), mk(past, 'lewat'), mk(near, 'dekat')],
        now,
      );
      expect(r, isNotNull);
      expect(r!.item.id, 'dekat');
      expect(r.at, near);
      expect(r.minsLeft, 30);
    });

    test('batas atas = tengah malam lusa (besok masih ikut)', () {
      final now = DateTime(2026, 9, 16, 10, 0);
      final tomorrow = DateTime(2026, 9, 17, 23, 59);
      final dayAfterMidnight = DateTime(2026, 9, 18, 0, 0);
      final r = nextReminder(
        [mk(dayAfterMidnight, 'lusa'), mk(tomorrow, 'besok')],
        now,
      );
      expect(r!.item.id, 'besok');
      expect(
        nextReminder([mk(dayAfterMidnight, 'lusa')], now),
        isNull,
        reason: 'lusa 00:00 sudah di luar jendela',
      );
    });

    test('semua lewat / kosong → null', () {
      final now = DateTime(2026, 9, 16, 10, 0);
      expect(nextReminder([], now), isNull);
      expect(nextReminder([mk(DateTime(2026, 9, 16, 9, 0), 'x')], now), isNull);
    });

    test('tanggal/time rusak diabaikan', () {
      final now = DateTime(2026, 9, 16, 10, 0);
      const bad = ReminderItem(
        id: 'rusak',
        title: 'rusak',
        date: 'bukan-tanggal',
        time: '',
        kind: ReminderKind.task,
        reminderMin: 15,
      );
      expect(nextReminder([bad], now), isNull);
    });
  });

  group('formatCountdown (repro.mjs)', () {
    test('0 / 45 / 130', () {
      expect(formatCountdown(0), 'sekarang');
      expect(formatCountdown(45), '45 mnt lagi');
      expect(formatCountdown(130), '2 jam lagi');
    });

    test('batas menit/jam/hari', () {
      expect(formatCountdown(-5), 'sekarang');
      expect(formatCountdown(59), '59 mnt lagi');
      expect(formatCountdown(60), '1 jam lagi');
      expect(formatCountdown(1439), '23 jam lagi');
      expect(formatCountdown(1440), 'besok');
    });
  });

  group('dueReminders (repro.mjs)', () {
    final at = DateTime(2026, 9, 16, 10, 0);
    final item = mk(at, 'e1', reminderMin: 15);
    final fire = at.subtract(const Duration(minutes: 15));

    test('now = fire+30dt kena', () {
      expect(
        dueReminders([item], fire.add(const Duration(seconds: 30))).length,
        1,
      );
    });

    test('now = fire-30dt kena', () {
      expect(
        dueReminders([item], fire.subtract(const Duration(seconds: 30))).length,
        1,
      );
    });

    test('now jauh → kosong', () {
      expect(
        dueReminders([item], at.subtract(const Duration(hours: 1))).length,
        0,
      );
    });

    test('di luar toleransi ±60dt → kosong', () {
      expect(
        dueReminders([item], fire.add(const Duration(seconds: 61))).length,
        0,
      );
      expect(
        dueReminders([item], fire.subtract(const Duration(seconds: 61))).length,
        0,
      );
    });

    test('reminderMin 0 → kosong', () {
      expect(
        dueReminders([mk(at, 'e1', reminderMin: 0)], fire).length,
        0,
      );
    });

    test('tanggal rusak → kosong', () {
      const bad = ReminderItem(
        id: 'rusak',
        title: 'rusak',
        date: 'bukan-tanggal',
        time: '10:00',
        kind: ReminderKind.task,
        reminderMin: 15,
      );
      expect(dueReminders([bad], fire).length, 0);
    });
  });

  group('ReminderItem', () {
    test('toJson/fromJson round-trip', () {
      final item = mk(DateTime(2026, 9, 16, 10, 0), 'e1', reminderMin: 30);
      final json = item.toJson();
      expect(json['kind'], 'sched');
      expect(ReminderItem.fromJson(json), item);
      expect(
        ReminderItem.fromJson(const {'kind': 'task', 'reminderMin': 0}).kind,
        ReminderKind.task,
      );
    });

    test('copyWith + equality', () {
      final item = mk(DateTime(2026, 9, 16, 10, 0), 'e1');
      expect(item.copyWith(reminderMin: 0).reminderMin, 0);
      expect(item.copyWith(id: 'e2').id, 'e2');
      expect(item, mk(DateTime(2026, 9, 16, 10, 0), 'e1'));
      expect(
        item == mk(DateTime(2026, 9, 16, 10, 0), 'e2'),
        isFalse,
      );
    });
  });
}
