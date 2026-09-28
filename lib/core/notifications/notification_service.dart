import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notedwork/core/models.dart';
import 'package:notedwork/core/reminders.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'package:notedwork/core/dates.dart' show defaultTz;

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
    for (final item in items) {
      if (item.reminderMin <= 0) continue;
      final at = _eventDateTime(item);
      if (at == null) continue;
      final fireAt = at.subtract(Duration(minutes: item.reminderMin));
      if (!fireAt.isAfter(now)) continue;
      final daysAhead = fireAt.difference(now).inDays;
      if (daysAhead > 7) continue;

      await _plugin.zonedSchedule(
        id: _idFor(item.id),
        title: item.title,
        body: _bodyFor(item, fireAt),
        scheduledDate: tz.TZDateTime.from(fireAt, tz.local),
        notificationDetails: NotificationDetails(android: _details),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: '${item.kind == ReminderKind.task ? 'task' : 'sched'}:${item.id}',
      );
    }
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
