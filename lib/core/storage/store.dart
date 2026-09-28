import 'dart:convert';

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:notedwork/core/models.dart';
import 'package:notedwork/core/theme/theme_config.dart';

class Store {
  Store._(this._data, this._settings);

  final Box<dynamic> _data;
  final Box<dynamic> _settings;

  static Future<Store> open() async {
    await Hive.initFlutter();
    final data = await Hive.openBox<dynamic>('data');
    final settings = await Hive.openBox<dynamic>('settings');
    return Store._(data, settings);
  }

  List<Task> get tasks => _readList('tasks', Task.fromJson);
  set tasks(List<Task> v) => _writeList('tasks', v);

  List<Sched> get scheds => _readList('scheds', Sched.fromJson);
  set scheds(List<Sched> v) => _writeList('scheds', v);

  List<Routine> get routines => _readList('routines', Routine.fromJson);
  set routines(List<Routine> v) => _writeList('routines', v);

  List<Note> get notes => _readList('notes', Note.fromJson);
  set notes(List<Note> v) => _writeList('notes', v);

  List<T> _readList<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    final raw = _data.get(key);
    if (raw is! String || raw.isEmpty) return <T>[];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    } catch (_) {
      return <T>[];
    }
  }

  void _writeList<T>(String key, List<T> value) {
    _data.put(key, jsonEncode(value.map((e) => (e as dynamic).toJson()).toList()));
  }

  Object? getSetting(String key) => _settings.get(key);

  void putSetting(String key, Object? value) => _settings.put(key, value);

  ThemeConfig get themeConfig {
    final raw = _settings.get('theme');
    if (raw is! String || raw.isEmpty) return ThemeConfig.defaults;
    try {
      return ThemeConfig.fromMap(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return ThemeConfig.defaults;
    }
  }

  set themeConfig(ThemeConfig v) => _settings.put('theme', jsonEncode(v.toMap()));

  Lang get lang {
    final raw = _settings.get('lang');
    return raw == 'en' ? Lang.en : Lang.id;
  }

  set lang(Lang v) => _settings.put('lang', v.name);

  bool get remindersOn => _settings.get('remindersOn', defaultValue: true) as bool;

  set remindersOn(bool v) => _settings.put('remindersOn', v);

  String get selectedDate {
    final raw = _settings.get('selectedDate');
    return raw is String && raw.isNotEmpty ? raw : '';
  }

  set selectedDate(String v) => _settings.put('selectedDate', v);
}
