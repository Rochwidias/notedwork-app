// lib/core/widget/agenda_widget.dart
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:notedwork/core/models.dart';
import 'agenda_payload.dart';

class AgendaWidgetBridge {
  static const receiver = 'AgendaWidgetProvider';
  static const qualifiedReceiver =
      'app.notedwork.notedwork.AgendaWidgetProvider';
  static const payloadKey = 'agenda_payload';

  static Future<void> update({
    required List<Sched> scheds,
    required List<Routine> routines,
    required List<Task> tasks,
    required DateTime now,
    required String header,
    required String emptyText,
  }) async {
    try {
      final payload = buildAgendaPayload(
        scheds: scheds,
        routines: routines,
        tasks: tasks,
        now: now,
        header: header,
        emptyText: emptyText,
      );
      await HomeWidget.saveWidgetData(payloadKey, payload);
      await HomeWidget.updateWidget(
        androidName: receiver,
        qualifiedAndroidName: qualifiedReceiver,
      );
    } catch (e) {
      debugPrint('AgendaWidget update gagal: $e');
    }
  }
}
