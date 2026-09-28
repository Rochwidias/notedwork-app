import 'package:flutter_test/flutter_test.dart';
import 'package:notedwork/core/dates.dart';
import 'package:notedwork/core/models.dart';

void main() {
  test('uid is unique', () {
    final a = uid('t');
    final b = uid('t');
    expect(a, isNot(b));
    expect(a, startsWith('t'));
  });

  test('taskBadge basic states', () {
    final now = DateTime(2026, 9, 28);
    final overdue = Task(
      id: 'a',
      matkul: 'M',
      title: 'T',
      date: '2026-09-27',
      time: '10:00',
      prio: Prio.low,
      note: '',
      done: false,
    );
    expect(taskBadge(overdue, Lang.id, now).cls, BadgeKind.over);
    expect(
      taskBadge(overdue.copyWith(done: true), Lang.id, now).cls,
      BadgeKind.lo,
    );
  });
}
