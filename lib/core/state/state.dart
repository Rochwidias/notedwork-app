import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notedwork/core/models.dart';
import 'package:notedwork/core/reminders.dart';
import 'package:notedwork/core/storage/store.dart';
import 'package:notedwork/core/theme/theme_config.dart';

final storeProvider = Provider<Store>(
  (ref) => throw UnimplementedError('storeProvider must be overridden'),
);

class TasksNotifier extends Notifier<List<Task>> {
  Store get _store => ref.read(storeProvider);

  @override
  List<Task> build() => _store.tasks;

  void replace(List<Task> v) {
    state = v;
    _store.tasks = v;
  }

  void upsert(Task task) {
    final i = state.indexWhere((t) => t.id == task.id);
    final next = [...state];
    if (i >= 0) {
      next[i] = task;
    } else {
      next.add(task);
    }
    replace(next);
  }

  void remove(String id) => replace(state.where((t) => t.id != id).toList());

  void toggleDone(String id) {
    replace([
      for (final t in state) t.id == id ? t.copyWith(done: !t.done) : t,
    ]);
  }
}

final tasksProvider =
    NotifierProvider<TasksNotifier, List<Task>>(TasksNotifier.new);

class SchedsNotifier extends Notifier<List<Sched>> {
  Store get _store => ref.read(storeProvider);

  @override
  List<Sched> build() => _store.scheds;

  void replace(List<Sched> v) {
    state = v;
    _store.scheds = v;
  }

  void upsert(Sched s) {
    final i = state.indexWhere((x) => x.id == s.id);
    final next = [...state];
    if (i >= 0) {
      next[i] = s;
    } else {
      next.add(s);
    }
    replace(next);
  }

  void remove(String id) => replace(state.where((s) => s.id != id).toList());
}

final schedsProvider =
    NotifierProvider<SchedsNotifier, List<Sched>>(SchedsNotifier.new);

class RoutinesNotifier extends Notifier<List<Routine>> {
  Store get _store => ref.read(storeProvider);

  @override
  List<Routine> build() => _store.routines;

  void replace(List<Routine> v) {
    state = v;
    _store.routines = v;
  }

  void upsert(Routine r) {
    final i = state.indexWhere((x) => x.id == r.id);
    final next = [...state];
    if (i >= 0) {
      next[i] = r;
    } else {
      next.add(r);
    }
    replace(next);
  }

  void remove(String id) => replace(state.where((r) => r.id != id).toList());
}

final routinesProvider =
    NotifierProvider<RoutinesNotifier, List<Routine>>(RoutinesNotifier.new);

class NotesNotifier extends Notifier<List<Note>> {
  Store get _store => ref.read(storeProvider);

  @override
  List<Note> build() => _store.notes;

  void replace(List<Note> v) {
    state = v;
    _store.notes = v;
  }

  void upsert(Note n) {
    final i = state.indexWhere((x) => x.id == n.id);
    final next = [...state];
    if (i >= 0) {
      next[i] = n;
    } else {
      next.add(n);
    }
    replace(next);
  }

  void remove(String id) => replace(state.where((n) => n.id != id).toList());
}

final notesProvider =
    NotifierProvider<NotesNotifier, List<Note>>(NotesNotifier.new);

class SettingsState {
  const SettingsState({
    this.theme = ThemeConfig.defaults,
    this.lang = Lang.id,
    this.remindersOn = true,
  });

  final ThemeConfig theme;
  final Lang lang;
  final bool remindersOn;

  SettingsState copyWith({
    ThemeConfig? theme,
    Lang? lang,
    bool? remindersOn,
  }) =>
      SettingsState(
        theme: theme ?? this.theme,
        lang: lang ?? this.lang,
        remindersOn: remindersOn ?? this.remindersOn,
      );
}

class SettingsNotifier extends Notifier<SettingsState> {
  Store get _store => ref.read(storeProvider);

  @override
  SettingsState build() => SettingsState(
        theme: _store.themeConfig,
        lang: _store.lang,
        remindersOn: _store.remindersOn,
      );

  void setTheme(ThemeConfig v) {
    state = state.copyWith(theme: v);
    _store.themeConfig = v;
  }

  void setLang(Lang v) {
    state = state.copyWith(lang: v);
    _store.lang = v;
  }

  void setRemindersOn(bool v) {
    state = state.copyWith(remindersOn: v);
    _store.remindersOn = v;
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

class SelectedDateNotifier extends Notifier<String> {
  Store get _store => ref.read(storeProvider);

  @override
  String build() {
    final v = _store.selectedDate;
    if (v.isNotEmpty) return v;
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  void set(String iso) {
    state = iso;
    _store.selectedDate = iso;
  }

  void goToday() {
    final now = DateTime.now();
    set('${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}');
  }
}

final selectedDateProvider =
    NotifierProvider<SelectedDateNotifier, String>(SelectedDateNotifier.new);

final reminderItemsProvider = Provider<List<ReminderItem>>((ref) {
  final scheds = ref.watch(schedsProvider);
  final tasks = ref.watch(tasksProvider);
  return [
    for (final s in scheds)
      if (s.time.isNotEmpty)
        ReminderItem(
          id: s.id,
          title: s.title,
          date: s.date,
          time: s.time,
          kind: ReminderKind.sched,
          reminderMin: s.reminderMin ?? 0,
        ),
    for (final t in tasks)
      if (!t.done)
        ReminderItem(
          id: t.id,
          title: t.title,
          date: t.date,
          time: t.time,
          kind: ReminderKind.task,
          reminderMin: t.reminderMin ?? 0,
        ),
  ];
});
