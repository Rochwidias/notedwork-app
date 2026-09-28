import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notedwork/core/models.dart';
import 'package:notedwork/core/reminders.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'package:notedwork/core/dates.dart' show defaultTz;

/// Satu rencana penjadwalan pengingat — hasil murni dari
/// [NotificationService.planSchedule], diuji di test/core.
class SchedulePlan {
  const SchedulePlan(this.item, this.fireAt, {required this.soon});

  final ReminderItem item;

  /// Waktu notifikasi dijadwalkan.
  final DateTime fireAt;

  /// true = jam pengingat sudah lewat, agenda masih datang → beritahu segera.
  final bool soon;
}

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static final StreamController<NavTarget> _taps =
      StreamController<NavTarget>.broadcast();
  static const String _channelId = 'pengingat_jadwal';
  static const String _channelName = 'Pengingat Jadwal';

  static Stream<NavTarget> get taps => _taps.stream;
  static bool _inited = false;

  static Future<void> init() async {
    if (_inited) return;
    _inited = true;
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(defaultTz));

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_notification'),
    );
    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (resp) {
        final payload = resp.payload ?? '';
        if (payload.startsWith('task:')) {
          _taps.add(NavTarget.tugas);
        } else if (payload.startsWith('sched:')) {
          _taps.add(NavTarget.kalender);
        }
      },
    );
  }

  static AndroidNotificationDetails get _details => const AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Pengingat jadwal dan tugas Notedwork',
        icon: 'ic_notification',
        importance: Importance.max,
        priority: Priority.high,
      );

  static Future<void> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;
    await android.requestNotificationsPermission();
    final canExact = await android.canScheduleExactNotifications();
    if (canExact == false) {
      await android.requestExactAlarmsPermission();
    }
  }

  /// Dipanggil saat app dibuka: minta izin hanya jika memang belum diberikan.
  /// (Pengingat default ON, jadi tanpa langkah ini instalasi baru tidak pernah
  /// dimintai izin dan semua notifikasi diblokir sistem.)
  static Future<void> ensureReady() async {
    if (!_inited) return;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;
    final enabled = await android.areNotificationsEnabled();
    if (enabled != true) {
      await android.requestNotificationsPermission();
    }
    final canExact = await android.canScheduleExactNotifications();
    if (canExact == false) {
      await android.requestExactAlarmsPermission();
    }
  }

  static int _idFor(String raw) {
    var h = 0;
    for (final r in raw.runes) {
      h = (h * 31 + r) & 0x7fffffff;
    }
    return h;
  }

  /// Batalkan semua lalu jadwalkan ulang pengingat yang akan datang
  /// (resync penuh, sama seperti perilaku web).
  static Future<void> resync(
    List<ReminderItem> items, {
    required bool enabled,
  }) async {
    if (!_inited) return;
    await _plugin.cancelAll();
    if (!enabled) return;

    final now = DateTime.now();
    for (final p in planSchedule(items, now: now)) {
      await _plugin.zonedSchedule(
        id: _idFor(p.item.id),
        title: p.item.title,
        body: p.soon ? _soonBody(_eventDateTime(p.item)!) : _bodyFor(p.item, p.fireAt),
        scheduledDate: tz.TZDateTime.from(p.fireAt, tz.local),
        notificationDetails: NotificationDetails(android: _details),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: '${p.item.kind == ReminderKind.task ? 'task' : 'sched'}:${p.item.id}',
      );
    }
  }

  /// Logika murni penjadwalan (terpisah dari plugin → bisa diuji):
  /// - lewati pengingat mati (<=0), agenda yang sudah lewat, dan > [horizonDays];
  /// - jam pengingat sudah lewat tapi agenda masih datang → [SchedulePlan.soon]
  ///   (dijadwalkan [sefireAhead] dari sekarang, jangan di-skip senyap).
  static List<SchedulePlan> planSchedule(
    List<ReminderItem> items, {
    required DateTime now,
    int horizonDays = 30,
    Duration sefireAhead = const Duration(seconds: 2),
  }) {
    final out = <SchedulePlan>[];
    for (final item in items) {
      if (item.reminderMin <= 0) continue;
      final at = _eventDateTime(item);
      if (at == null) continue;
      if (!at.isAfter(now)) continue;
      var fireAt = at.subtract(Duration(minutes: item.reminderMin));
      if (fireAt.difference(now).inDays > horizonDays) continue;
      final soon = !fireAt.isAfter(now);
      if (soon) fireAt = now.add(sefireAhead);
      out.add(SchedulePlan(item, fireAt, soon: soon));
    }
    return out;
  }

  static DateTime? _eventDateTime(ReminderItem item) {
    final d = _parseDate(item.date);
    if (d == null) return null;
    final t = _parseHm(item.time);
    if (t == null) return d;
    return DateTime(d.year, d.month, d.day, t.$1, t.$2);
  }

  static DateTime? _parseDate(String iso) {
    final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(iso.trim());
    if (m == null) return null;
    return DateTime(
      int.parse(m.group(1)!),
      int.parse(m.group(2)!),
      int.parse(m.group(3)!),
    );
  }

  static (int, int)? _parseHm(String hm) {
    final m = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(hm.trim());
    if (m == null) return null;
    return (int.parse(m.group(1)!), int.parse(m.group(2)!));
  }

  static String _bodyFor(ReminderItem item, DateTime fireAt) {
    final mins = item.reminderMin;
    if (mins >= 60 && mins % 60 == 0) {
      final h = mins ~/ 60;
      return h == 1 ? '1 jam lagi' : '$h jam lagi';
    }
    return '$mins menit lagi';
  }

  static String _soonBody(DateTime eventAt) {
    final hm = '${eventAt.hour.toString().padLeft(2, '0')}:'
        '${eventAt.minute.toString().padLeft(2, '0')}';
    return 'Segera dimulai jam $hm';
  }

  static Future<void> test() async {
    if (!_inited) return;
    await _plugin.show(
      id: 999999,
      title: 'Pengingat Jadwal',
      body: 'Notifikasi pengingat sudah aktif.',
      notificationDetails: NotificationDetails(android: _details),
      payload: 'sched:test',
    );
  }
}
