// test/core/agenda_payload_test.dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:notedwork/core/models.dart';
import 'package:notedwork/core/widget/agenda_payload.dart';

void main() {
  final now = DateTime(2026, 9, 28); // Senin

  Sched sched({String id = 's1', required String title, required String date,
          String time = '10:00', String color = '#D97706'}) =>
      Sched(id: id, title: title, date: date, time: time, note: '', color: color);
  Routine routine({String id = 'r1', required int day, String start = '07:00',
          String end = '08:30', String course = 'Kalkulus', String color = '#16A34A'}) =>
      Routine(id: id, course: course, day: day, start: start, end: end,
          room: 'A1', lect: 'Dosen', color: color);
  Task task({String id = 't1', required String title, required String date,
          String time = '', bool done = false, Prio prio = Prio.low}) =>
      Task(id: id, matkul: 'MTK', title: title, date: date, time: time,
          prio: prio, note: '', done: done);

  String run({List<Sched> scheds = const [], List<Routine> routines = const [],
          List<Task> tasks = const []}) =>
      buildAgendaPayload(scheds: scheds, routines: routines, tasks: tasks, now: now,
          header: 'Hari Ini · Sen, 28 Sep 2026', emptyText: 'Belum ada agenda hari ini',
          dateNum: '28', dateDow: 'SEN', sub: 'Senin, 28 September',
          count: '3', routineLabel: 'RUTIN', schedLabel: 'AGENDA',
          taskLabel: 'TUGAS');

  test('payload JSON valid, berisi header + empty + items', () {
    final map = jsonDecode(run()) as Map<String, dynamic>;
    expect(map['header'], 'Hari Ini · Sen, 28 Sep 2026');
    expect(map['empty'], 'Belum ada agenda hari ini');
    expect(map['items'], isA<List<dynamic>>());
  });

  test('payload varian A membawa dateNum/dateDow/sub/count/labels', () {
    final map = jsonDecode(run()) as Map<String, dynamic>;
    expect(map['dateNum'], '28');
    expect(map['dateDow'], 'SEN');
    expect(map['sub'], 'Senin, 28 September');
    expect(map['count'], '3');
    final labels = map['labels'] as Map<String, dynamic>;
    expect(labels['rutin'], 'RUTIN');
    expect(labels['jadwal'], 'AGENDA');
    expect(labels['tugas'], 'TUGAS');
  });

  test('sched hari ini ikut; lewat horizon 7 hari tidak; kemarin tidak', () {
    final map = jsonDecode(run(scheds: [
      sched(title: 'Hari ini', date: '2026-09-28'),
      sched(id: 's2', title: 'Batas', date: '2026-10-05'), // now + 7 hari
      sched(id: 's3', title: 'Lewat', date: '2026-10-06'),
      sched(id: 's4', title: 'Kemarin', date: '2026-09-27'),
    ])) as Map<String, dynamic>;
    final titles = (map['items'] as List).map((e) => e['title']).toList();
    expect(titles, containsAll(['Hari ini', 'Batas']));
    expect(titles, isNot(contains('Lewat')));
    expect(titles, isNot(contains('Kemarin')));
  });

  test('sched jam lewat TETAP tampil (perilaku agenda Kalender)', () {
    final map = jsonDecode(run(scheds: [sched(title: 'Pagi lewat', date: '2026-09-28', time: '06:00')]))
        as Map<String, dynamic>;
    expect((map['items'] as List).length, 1);
  });

  test('rutin memakai kind jadwal/rutin/tugas lokal (Senin=1)', () {
    final map = jsonDecode(run(routines: [routine(day: 1)])) as Map<String, dynamic>;
    final items = (map['items'] as List);
    expect(items.length, 1);
    expect(items.first['kind'], 'rutin');
    expect(items.first['day'], 1);
    expect(items.first['date'], isNull);
  });

  test('tugas done DIBUANG, aktif dalam horizon ikut, jam default 23:59', () {
    final map = jsonDecode(run(tasks: [
      task(title: 'Selesai', date: '2026-09-28', done: true),
      task(id: 't2', title: 'Aktif', date: '2026-09-28'),
      task(id: 't3', title: 'Jauh', date: '2026-10-20', time: '10:00'),
    ])) as Map<String, dynamic>;
    final items = (map['items'] as List);
    expect(items.length, 1);
    expect(items.first['title'], 'Aktif');
    expect(items.first['time'], '23:59');
    expect(items.first['kind'], 'tugas');
    expect(items.first['color'], '#DC2626');
  });

  test('sched memakai kind jadwal (bukan sched)', () {
    final map = jsonDecode(run(scheds: [sched(title: 'X', date: '2026-09-28')]))
        as Map<String, dynamic>;
    expect((map['items'] as List).first['kind'], 'jadwal');
  });

  test('urutan grup: rutin -> jadwal -> tugas', () {
    final map = jsonDecode(run(
      tasks: [task(title: 'Tugas', date: '2026-09-28', time: '01:00')],
      scheds: [sched(title: 'Agenda', date: '2026-09-28', time: '02:00')],
      routines: [routine(day: 1, start: '23:00', end: '23:59')],
    )) as Map<String, dynamic>;
    final kinds = (map['items'] as List).map((e) => e['kind']).toList();
    expect(kinds, ['rutin', 'jadwal', 'tugas']);
  });

  test('data kosong -> items [] (provider tampilkan emptyText)', () {
    final map = jsonDecode(run()) as Map<String, dynamic>;
    expect((map['items'] as List), isEmpty);
  });

  test('item sched membawa date/time/color string apa adanya', () {
    final map = jsonDecode(run(scheds: [sched(title: 'X', date: '2026-09-28', time: '14:50', color: '#DC2626')]))
        as Map<String, dynamic>;
    final item = (map['items'] as List).first as Map<String, dynamic>;
    expect(item['date'], '2026-09-28');
    expect(item['time'], '14:50');
    expect(item['color'], '#DC2626');
  });
}
