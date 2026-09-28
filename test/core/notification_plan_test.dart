import 'package:flutter_test/flutter_test.dart';
import 'package:notedwork/core/notifications/notification_service.dart';
import 'package:notedwork/core/reminders.dart';

ReminderItem _item({
  required String date,
  required String time,
  required int reminderMin,
  ReminderKind kind = ReminderKind.sched,
}) =>
    ReminderItem(
      id: 'x1',
      title: 'Agenda Tes',
      date: date,
      time: time,
      kind: kind,
      reminderMin: reminderMin,
    );

void main() {
  // Sabtu 2026-09-28 15:00 — semua kasus memakai now ini agar deterministik.
  final now = DateTime(2026, 9, 28, 15, 0);

  group('NotificationService.planSchedule', () {
    test('jam pengingat lewat tapi agenda masih datang → segera (now+2s)', () {
      // Agenda besok 09:00, pengingat 1 hari → seharusnya bunyi hari ini 09:00
      // (sudah lewat 6 jam) → jangan di-skip senyap.
      final plans = NotificationService.planSchedule(
        [_item(date: '2026-09-29', time: '09:00', reminderMin: 1440)],
        now: now,
      );
      expect(plans, hasLength(1));
      final p = plans.single;
      expect(p.soon, isTrue);
      expect(p.fireAt, now.add(const Duration(seconds: 2)));
      expect(p.fireAt.isAfter(now), isTrue);
    });

    test('pengingat masih di masa depan → jadwal normal, soon=false', () {
      // Agenda besok 09:00, pengingat 3 jam → bunyi besok 06:00.
      final plans = NotificationService.planSchedule(
        [_item(date: '2026-09-29', time: '09:00', reminderMin: 180)],
        now: now,
      );
      expect(plans, hasLength(1));
      final p = plans.single;
      expect(p.soon, isFalse);
      expect(p.fireAt, DateTime(2026, 9, 29, 6, 0));
    });

    test('agenda sudah lewat → dilewati', () {
      final plans = NotificationService.planSchedule(
        [_item(date: '2026-09-28', time: '14:00', reminderMin: 180)],
        now: now,
      );
      expect(plans, isEmpty);
    });

    test('pengingat mati (reminderMin 0) → dilewati', () {
      final plans = NotificationService.planSchedule(
        [_item(date: '2026-09-29', time: '09:00', reminderMin: 0)],
        now: now,
      );
      expect(plans, isEmpty);
    });

    test('lewat horizon 30 hari → dilewati', () {
      final plans = NotificationService.planSchedule(
        [_item(date: '2026-11-15', time: '09:00', reminderMin: 180)],
        now: now,
      );
      expect(plans, isEmpty);
    });

    test('tanggal rusak → dilewati', () {
      final plans = NotificationService.planSchedule(
        [_item(date: 'bukan-tanggal', time: '09:00', reminderMin: 180)],
        now: now,
      );
      expect(plans, isEmpty);
    });

    test('agenda jauh dengan pengingat 1 hari tapi masih dalam horizon → segera', () {
      // 10 hari lagi, pengingat 1 hari → fireAt 9 hari lagi (masih horizon),
      // soon=false. Kontras dengan kasus lewat-horizon di atas.
      final plans = NotificationService.planSchedule(
        [_item(date: '2026-10-08', time: '09:00', reminderMin: 1440)],
        now: now,
      );
      expect(plans, hasLength(1));
      expect(plans.single.soon, isFalse);
      expect(plans.single.fireAt, DateTime(2026, 10, 7, 9, 0));
    });
  });
}
