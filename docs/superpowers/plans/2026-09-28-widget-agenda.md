# Widget Agenda Notedwork — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Widget layar utama Android 4×2 yang menampilkan agenda hari ini (rutin + Sched + deadline tugas) + tombol pintasan **+** yang langsung membuka QuickAdd Jadwal.

**Architecture:** Flutter membangun payload JSON agenda (horizon 7 hari + rutin mingguan) lewat fungsi murni, menyimpannya ke SharedPreferences via paket `home_widget`, lalu mem-broadcast update ke `AgendaWidgetProvider` (Kotlin, extends `HomeWidgetProvider`) yang menyaring "hari ini" dan merender RemoteViews. Klik tombol + memakai `HomeWidgetLaunchIntent` → URI `notedwork://widget/add` → didengar Flutter via stream `widgetClicked`/`initiallyLaunchedFromHomeWidget` (pola sama seperti `NotificationService.taps`).

**Tech Stack:** Flutter 3.47.5 / Dart 3.13.4 · `home_widget` (satu-satunya dependency baru) · Kotlin AppWidgetProvider + RemoteViews · Riverpod 3 · flutter_test.

**Spec:** `docs/superpowers/specs/2026-09-28-widget-agenda-design.md`

## Global Constraints

- Gaya widget: kertas gelap `#101319`, radius 16dp, teks krem — TIDAK ikut tema aplikasi (spec §1).
- Maks 5 baris agenda; urutan grup: rutin → Sched → tugas (spec §1).
- Cakupan agenda = sama seperti kartu Agenda tab Kalender: rutin hari ini + Sched (tanggal hari ini, jam lewat tetap tampil/"Telat") + tugas belum selesai berdeadline hari ini (spec §2).
- Horizon payload = hari ini s/d +7 hari (string ISO `yyyy-MM-dd`, perbandingan leksikografis).
- Semua panggilan `home_widget` dibungkus try/catch — widget gagal tidak boleh menjatuhkan aplikasi (spec §5).
- Tanpa emoji di chrome; teks widget Bahasa Indonesia mengikuti l10n aplikasi (key `nav_home`, `home_empty` dsb. bila cocok; kalau tidak ada key persis, pakai teks Indonesia/en dari pola yang ada — daftarkan di catatan).
- `flutter analyze` No issues + `flutter test` semua lulus sebelum commit tiap task.
- Repo: `D:\project-app\notedwork.app`, branch `main`. Commit message Bahasa Indonesia tanpa emoji. Rilis mengikuti pipeline yang sudah terbukti (`--notes-file`, salin APK ke nama final, tanpa `#label`).

## File Structure

| File | Tanggung jawab |
|---|---|
| Create: `lib/core/widget/agenda_payload.dart` | Fungsi murni `buildAgendaPayload` — filtering, urutan, JSON |
| Create: `test/core/agenda_payload_test.dart` | Tes TDD payload |
| Create: `lib/core/widget/agenda_widget.dart` | `AgendaWidgetBridge.update(...)` — saveWidgetData + updateWidget, try/catch |
| Modify: `lib/app.dart` | initState: refresh awal + dengar klik widget; `ref.listen` 3 provider data → bridge |
| Modify: `pubspec.yaml` | Tambah `home_widget` |
| Create: `android/app/src/main/kotlin/app/notedwork/notedwork/AgendaWidgetProvider.kt` | Renderer RemoteViews + filter hari ini + PendingIntent |
| Create: `android/app/src/main/res/layout/widget_agenda.xml` | Layout widget (header + 5 baris + empty + tombol +) |
| Create: `android/app/src/main/res/drawable/widget_bg.xml`, `widget_dot.xml`, `widget_plus_bg.xml` | Bentuk latar/bullet/tombol |
| Create: `android/app/src/main/res/xml/notedwork_widget_info.xml` | Metadata appwidget-provider |
| Modify: `android/app/src/main/res/values/strings.xml` | `widget_description` |
| Modify: `android/app/src/main/AndroidManifest.xml` | Deklarasi receiver |
| Create: `test/core/agenda_payload_test.dart` lengkap | (lihat Task 1) |

---

### Task 1: Fungsi murni `buildAgendaPayload` (TDD)

**Files:**
- Create: `lib/core/widget/agenda_payload.dart`
- Test: `test/core/agenda_payload_test.dart`

**Interfaces:**
- Consumes: `Sched`, `Routine`, `Task` dari `lib/core/models.dart` — SEMUA field wajib diverifikasi di models.dart: `Sched(id,title,date,time,note,color,reminderMin?,endTime?,allDay?,overnight?)` — **`note` required dan `color` bertipe `String` (`'#RRGGBB'`)**; `Routine(id,course,day,start,end,room,lect,color)` — `color` String, `day` 1=Senin..7=Minggu; `Task(id,matkul,title,date,time,prio,note,done,reminderMin?)` — **`note` required, TIDAK ada field `color`** (pakai `'#DC2626'` untuk deadline).
- Produces (dipakai Task 2): `String buildAgendaPayload({required List<Sched> scheds, required List<Routine> routines, required List<Task> tasks, required DateTime now, required String header, required String emptyText})` — mengembalikan JSON string. `todayStr()` TIDAK menerima argumen — pakai helper `iso()` lokal dengan parameter `now` (lihat implementasi).

- [ ] **Step 1: Tulis tes yang gagal dahulu**

```dart
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
          header: 'Hari Ini · Sen, 28 Sep 2026', emptyText: 'Belum ada agenda hari ini');

  test('payload JSON valid, berisi header + empty + items', () {
    final map = jsonDecode(run()) as Map<String, dynamic>;
    expect(map['header'], 'Hari Ini · Sen, 28 Sep 2026');
    expect(map['empty'], 'Belum ada agenda hari ini');
    expect(map['items'], isA<List<dynamic>>());
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

  test('rutin selalu ikut dengan field day ISO (Senin=1)', () {
    final map = jsonDecode(run(routines: [routine(day: 1)])) as Map<String, dynamic>;
    final items = (map['items'] as List);
    expect(items.length, 1);
    expect(items.first['kind'], 'routine');
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
    expect(items.first['kind'], 'task');
    expect(items.first['color'], '#DC2626');
  });

  test('urutan grup: routine -> sched -> task', () {
    final map = jsonDecode(run(
      tasks: [task(title: 'Tugas', date: '2026-09-28', time: '01:00')],
      scheds: [sched(title: 'Agenda', date: '2026-09-28', time: '02:00')],
      routines: [routine(day: 1, start: '23:00', end: '23:59')],
    )) as Map<String, dynamic>;
    final kinds = (map['items'] as List).map((e) => e['kind']).toList();
    expect(kinds, ['routine', 'sched', 'task']);
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
```

- [ ] **Step 2: Jalankan tes, pastikan GAGAL (file belum ada)**

Run: `flutter test test/core/agenda_payload_test.dart`
Expected: FAIL — `Error: Couldn't resolve the package 'package:notedwork/core/widget/agenda_payload.dart'` (atau compile error).

- [ ] **Step 3: Implementasi minimal**

```dart
// lib/core/widget/agenda_payload.dart
import 'dart:convert';
import 'package:notedwork/core/models.dart';

/// Payload agenda untuk widget layar utama.
/// Semua pemformatan bahasa (header/emptyText) dilakukan pemanggil.
String buildAgendaPayload({
  required List<Sched> scheds,
  required List<Routine> routines,
  required List<Task> tasks,
  required DateTime now,
  required String header,
  required String emptyText,
}) {
  // yyyy-MM-dd lokal; todayStr() di dates.dart tanpa argumen, jadi helper sendiri.
  String iso(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  final today = iso(now);
  final horizon = iso(now.add(const Duration(days: 7)));
  const taskColor = '#DC2626'; // BadgeKind.over / deadline merah (globals.css)

  final items = <Map<String, Object?>>[];

  // 1) Rutin mingguan (selalu ikut; provider mencocokkan hari)
  for (final r in routines) {
    items.add({'kind': 'routine', 'day': r.day, 'time': r.start, 'end': r.end,
      'title': r.course, 'color': r.color.isEmpty ? '#D97706' : r.color});
  }
  // 2) Sched: hari ini s/d +7 (kemarin terbuang oleh perbandingan)
  final schedsSorted = [...scheds]..sort((a, b) => a.date.compareTo(b.date));
  for (final s in schedsSorted) {
    if (s.date.compareTo(today) < 0) continue;
    if (s.date.compareTo(horizon) > 0) continue;
    items.add({'kind': 'sched', 'date': s.date,
      'time': (s.allDay ?? false) ? '' : s.time, 'title': s.title,
      'color': s.color.isEmpty ? '#D97706' : s.color});
  }
  // 3) Tugas belum selesai, deadline hari ini s/d +7
  final tasksSorted = [...tasks]..sort((a, b) => a.date.compareTo(b.date));
  for (final t in tasksSorted) {
    if (t.done) continue;
    if (t.date.compareTo(today) < 0) continue;
    if (t.date.compareTo(horizon) > 0) continue;
    items.add({'kind': 'task', 'date': t.date,
      'time': (t.time.isEmpty ? '23:59' : t.time), 'title': t.title,
      'color': taskColor});
  }

  return jsonEncode({'header': header, 'empty': emptyText, 'items': items});
}
```

Catatan: `Sched.color`/`Routine.color` sudah `String` `'#RRGGBB'` → langsung diteruskan (fallback `#D97706` kalau kosong). `Task` tidak punya `color` → selalu `#DC2626`. Sort di dalam grup dilakukan sekali; grup sudah dalam urutan rutin→sched→task.

- [ ] **Step 4: Jalankan tes, pastikan LULUS**

Run: `flutter test test/core/agenda_payload_test.dart`
Expected: PASS (8 test).

- [ ] **Step 5: Analyze + commit**

Run: `flutter analyze lib/core/widget test/core` → No issues.
`git add lib/core/widget/agenda_payload.dart test/core/agenda_payload_test.dart && git commit -m "fungsi murni buildAgendaPayload untuk widget agenda + 8 tes"`

---

### Task 2: Dependensi `home_widget` + bridge + wiring aplikasi

**Files:**
- Modify: `pubspec.yaml` (tambah dependency)
- Create: `lib/core/widget/agenda_widget.dart`
- Modify: `lib/app.dart` (initState + dispose + 1 blok ref.listen baru)

**Interfaces:**
- Consumes: `buildAgendaPayload` (Task 1); `schedsProvider/routinesProvider/tasksProvider` dari `lib/core/state/state.dart`; `showQuickAdd(context, kind: ...)` dari `lib/features/quick_add/quick_add_sheet.dart` (baca signature-nya — kind 'sched'); `fmtDateID`, `todayStr` dari `lib/core/dates.dart`; l10n `AppLocalizations`.
- Produces: `class AgendaWidgetBridge { static Future<void> update({required String header, required String emptyText}) }` — bridge MEMBACA data dari Riverpod via parameter data? **Tidak**: supaya tidak bocor ke provider global, signature final: `static Future<void> update({required List<Sched> scheds, required List<Routine> routines, required List<Task> tasks, required DateTime now, required String header, required String emptyText})`. URI konstan: `notedwork://widget/add`.

- [ ] **Step 1: Tambah dependency**

Run: `flutter pub add home_widget`
Expected: `+ home_widget <versi>` tercatat di pubspec.yaml.

- [ ] **Step 2: Tulis bridge (try/catch penuh)**

```dart
// lib/core/widget/agenda_widget.dart
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:notedwork/core/models.dart';
import 'agenda_payload.dart';

class AgendaWidgetBridge {
  static const receiver = 'AgendaWidgetProvider';
  static const qualifiedReceiver = 'app.notedwork.notedwork.AgendaWidgetProvider';
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
        scheds: scheds, routines: routines, tasks: tasks, now: now,
        header: header, emptyText: emptyText,
      );
      await HomeWidget.saveWidgetData(payloadKey, payload);
      await HomeWidget.updateWidget(
        androidName: receiver, qualifiedAndroidName: qualifiedReceiver);
    } catch (e) {
      debugPrint('AgendaWidget update gagal: $e');
    }
  }
}
```

- [ ] **Step 3: Wiring `lib/app.dart`**

Baca dulu `lib/app.dart` (struktur `initState`/`dispose`/`ref.listen`). Tambahkan:

```dart
// di imports
import 'package:home_widget/home_widget.dart' as hw;
import 'package:notedwork/core/widget/agenda_widget.dart';

// field state: StreamSubscription? _widgetClicks;

// di initState, SETELAH listener notifikasi yang ada:
WidgetsBinding.instance.addPostFrameCallback((_) {
  if (settings.remindersOn) { /* blok lama tetap */ }
  _syncAgendaWidget();
  _handleWidgetUri(hw.HomeWidget.initiallyLaunchedFromHomeWidget());
  _widgetClicks = hw.HomeWidget.widgetClicked.listen((uri) => _handleWidgetUri(Future.value(uri)));
});

Future<void> _handleWidgetUri(Future<Uri?> future) async {
  final uri = await future;
  if (uri == null) return;
  if (uri.host == 'widget' && uri.path == '/add') {
    if (!mounted) return;
    showQuickAdd(context, kind: 'jadwal'); // kind QuickAdd: 'tugas' | 'jadwal' | 'catatan' (lihat pemakaian existing)
  }
}

void _syncAgendaWidget() {
  final l10n = AppLocalizations.of(context)!;
  final lang = ref.read(settingsProvider).lang;
  final now = DateTime.now();
  AgendaWidgetBridge.update(
    scheds: ref.read(schedsProvider),
    routines: ref.read(routinesProvider),
    tasks: ref.read(tasksProvider),
    now: now,
    header: '${l10n.nav_home} · ${fmtDateID(todayStr(), lang)}',
    emptyText: lang == Lang.id ? 'Belum ada agenda hari ini' : 'No agenda for today yet',
  );
}
```

- Tambahkan `ref.listen` (di method build yang sudah memakai `ref.listen` settings/reminder) untuk `schedsProvider`, `routinesProvider`, `tasksProvider` — callback: `(_, __) => _syncAgendaWidget();`.
- `dispose`: `_widgetClicks?.cancel();`
- Teks empty: cek dulu apakah ada key l10n yang cocok (mis. `home_empty`/`cal_empty…`) — kalau ada yang persis artinya "belum ada agenda", pakai itu; kalau tidak, string literal sesuai pola di atas (catat di commit).

- [ ] **Step 4: Verify**

Run: `flutter analyze` → No issues. `flutter test` → semua lulus (66+8=74).
Expected: PASS.

- [ ] **Step 5: Commit**

`git add pubspec.yaml pubspec.lock lib/core/widget/agenda_widget.dart lib/app.dart && git commit -m "bridge home_widget + refresh agenda saat data berubah + tangani klik widget"`

---

### Task 3: Provider Kotlin + layout XML + manifest

**Files:**
- Create: `android/app/src/main/kotlin/app/notedwork/notedwork/AgendaWidgetProvider.kt`
- Create: `android/app/src/main/res/layout/widget_agenda.xml`
- Create: `android/app/src/main/res/drawable/widget_bg.xml`, `widget_dot.xml`, `widget_plus_bg.xml`
- Create: `android/app/src/main/res/xml/notedwork_widget_info.xml`
- Modify: `android/app/src/main/res/values/strings.xml` (tambah `widget_description`)
- Modify: `android/app/src/main/AndroidManifest.xml` (receiver di dalam `<application>`)

**Interfaces:**
- Consumes: payload JSON `{'header','empty','items'}` dari Task 1/2; `HomeWidgetProvider` + `HomeWidgetLaunchIntent` dari paket `home_widget` (package Kotlin `es.antonborri.home_widget`); `app.notedwork.notedwork.MainActivity` (verifikasi path/kelas MainActivity sebelum menulis, bisa `.kt` atau `.java`).
- Produces: receiver `AgendaWidgetProvider` (ditemukan home_widget via `qualifiedAndroidName`); struktur view id `w_header`, `w_empty`, `w_add`, `w_row{0..4}` dengan anak `w_row{n}_color` (ImageView), `w_row{n}_time`, `w_row{n}_title`.

- [ ] **Step 1: drawable shapes**

`widget_bg.xml`:
```xml
<shape xmlns:android="http://schemas.android.com/apk/res/android" android:shape="rectangle">
  <solid android:color="#101319"/>
  <corners android:radius="16dp"/>
</shape>
```
`widget_dot.xml`:
```xml
<shape xmlns:android="http://schemas.android.com/apk/res/android" android:shape="oval">
  <solid android:color="#D97706"/>
</shape>
```
`widget_plus_bg.xml`:
```xml
<shape xmlns:android="http://schemas.android.com/apk/res/android" android:shape="oval">
  <solid android:color="#D97706"/>
</shape>
```

- [ ] **Step 2: layout `widget_agenda.xml`**

Root `LinearLayout` vertikal: `background=@drawable/widget_bg`, padding 12dp, minWidth 250dp/minHeight 110dp.
- Baris header: horizontal; `TextView @+id/w_header` (textSize 13sp, textColor #F7F4EE, textStyle bold, layout_weight 1, maxLines 1, ellipsize end); `TextView @+id/w_add` (text "+", textSize 20sp, textColor #FFFFFF, gravity center, layout_width/height 32dp, background @drawable/widget_plus_bg).
- `TextView @+id/w_empty` (textSize 13sp, textColor #A8A29E, padding top 8dp, visibility gone).
- **5 blok baris identik** `LinearLayout` horizontal id `w_row{0..4}` (paddingVertical 3dp, visibility gone): `ImageView @+id/w_row{n}_color` 8dp×8dp, `src=@drawable/widget_dot`, marginEnd 8dp; `TextView @+id/w_row{n}_time` (textSize 12sp, textColor #A8A29E, width wrap, marginEnd 8dp); `TextView @+id/w_row{n}_title` (textSize 13sp, textColor #F7F4EE, layout_weight 1, maxLines 1, ellipsize end).
- Semua teks default kosong; baris GONE sampai provider mengisi (aman saat initialLayout).

- [ ] **Step 3: `xml/notedwork_widget_info.xml`**

```xml
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
  android:minWidth="250dp" android:minHeight="110dp"
  android:updatePeriodMillis="1800000"
  android:resizeMode="horizontal|vertical"
  android:widgetCategory="home_screen"
  android:initialLayout="@layout/widget_agenda"
  android:previewLayout="@layout/widget_agenda"
  android:description="@string/widget_description"/>
```

- [ ] **Step 4: string + manifest**

`values/strings.xml`: `<string name="widget_description">Agenda hari ini dan pintasan tambah jadwal</string>` (di dalam resources yang sudah ada).

Manifest — tambahkan SEBELUM `</application>` (setelah activity):
```xml
<receiver android:name=".notedwork.AgendaWidgetProvider"
    android:permission="android.permission.BIND_APPWIDGET"
    android:exported="true">
  <intent-filter>
    <action android:name="android.appwidget.action.APPWIDGET_UPDATE"/>
  </intent-filter>
  <meta-data android:name="android.appwidget.provider" android:resource="@xml/notedwork_widget_info"/>
</receiver>
```
(Versi aplikasi pakai `namespace app.notedwork` → `.notedwork.AgendaWidgetProvider` = `app.notedwork.notedwork.AgendaWidgetProvider`. Verifikasi namespace di `android/app/build.gradle.kts` dan lokasi MainActivity sebelum menulis.)

- [ ] **Step 5: `AgendaWidgetProvider.kt`**

```kotlin
package app.notedwork.notedwork

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Color
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class AgendaWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val payloadRaw = widgetData.getString("agenda_payload", null)
        val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.US)
        val today = sdf.format(Date())
        // ISO weekday: Senin=1..Minggu=7
        val cal = java.util.Calendar.getInstance()
        val todayIso = if (cal.get(java.util.Calendar.DAY_OF_WEEK) == java.util.Calendar.SUNDAY) 7
                       else cal.get(java.util.Calendar.DAY_OF_WEEK) - 1

        val rows = ArrayList<Triple<String, String, String>>() // color, time, title
        var header = context.getString(android.R.string.unknownName) // fallback diganti di bawah
        var emptyText = ""
        try {
            if (payloadRaw != null) {
                val json = JSONObject(payloadRaw)
                header = json.optString("header", "Hari Ini")
                emptyText = json.optString("empty", "")
                val items = json.getJSONArray("items")
                for (i in 0 until items.length()) {
                    val it = items.getJSONObject(i)
                    val kind = it.optString("kind")
                    val matches = when (kind) {
                        "routine" -> it.optInt("day", -1) == todayIso
                        else -> it.optString("date") == today
                    }
                    if (!matches) continue
                    val time = it.optString("time", "")
                    val title = it.optString("title", "")
                    if (title.isEmpty()) continue
                    rows.add(Triple(it.optString("color", "#D97706"), time, title))
                    if (rows.size == 5) break
                }
            }
        } catch (_: Exception) {
            // payload korup -> tampil empty state
            rows.clear()
            if (emptyText.isEmpty()) emptyText = "Belum ada agenda hari ini"
        }
        if (emptyText.isEmpty() && rows.isEmpty()) emptyText = "Belum ada agenda hari ini"

        val addIntent = HomeWidgetLaunchIntent.getActivity(
            context, MainActivity::class.java, Uri.parse("notedwork://widget/add"))
        val openIntent = HomeWidgetLaunchIntent.getActivity(
            context, MainActivity::class.java, Uri.parse("notedwork://widget/open"))

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_agenda).apply {
                setTextViewText(R.id.w_header, header)
                setOnClickPendingIntent(R.id.w_add, addIntent)
                setOnClickPendingIntent(R.id.w_header, openIntent)
                if (rows.isEmpty()) {
                    setViewVisibility(R.id.w_empty, View.VISIBLE)
                    setTextViewText(R.id.w_empty, emptyText)
                } else {
                    setViewVisibility(R.id.w_empty, View.GONE)
                }
                for (n in 0 until 4) { // indeks 0..4 (loop di bawah pakai n sampai 5)
                }
                for (n in 0 until 5) {
                    val rowId = context.resources.getIdentifier(
                        "w_row$n", "id", context.packageName)
                    if (rowId == 0) continue
                    if (n < rows.size) {
                        val (color, time, title) = rows[n]
                        setViewVisibility(rowId, View.VISIBLE)
                        val colorId = context.resources.getIdentifier("w_row${n}_color", "id", context.packageName)
                        val timeId = context.resources.getIdentifier("w_row${n}_time", "id", context.packageName)
                        val titleId = context.resources.getIdentifier("w_row${n}_title", "id", context.packageName)
                        try { setImageViewColor(colorId, Color.parseColor(color)) } catch (_: Exception) {}
                        setTextViewText(timeId, time)
                        setTextViewText(titleId, title)
                        setViewVisibility(timeId, if (time.isEmpty()) View.GONE else View.VISIBLE)
                        setOnClickPendingIntent(titleId, openIntent)
                    } else {
                        setViewVisibility(rowId, View.GONE)
                    }
                }
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
```
(Bersihkan blok `for (n in 0 until 4) {}` yang kosong — itu penanda; tulis langsung loop `0 until 5` saja. `R.id.*` muncul otomatis karena layout ada; getIdentifier dipakai hanya kalau id tidak ditemukan compile-time — sebenarnya `R.id.w_row0` dll. resmi ada, boleh pakai R.id langsung untuk kejelasan.)

- [ ] **Step 6: Build untuk verifikasi kompilasi native**

Run: `flutter build apk --release`
Expected: BUILD SUCCESSFUL (kompilasi Kotlin + resources OK).

- [ ] **Step 7: Commit**

`git add android/app/src/main && git commit -m "provider widget agenda: RemoteViews 5 baris, filter hari ini, pintasan tambah"`

---

### Task 4: QA emulator + rilis 2.1.0

**Files:**
- Modify: `pubspec.yaml` (version `2.1.0+7`)
- Modify: `README.md` (seksi widget singkat, opsional)
- Create: `tool/RELEASE_NOTES_2.1.0.md`

**Interfaces:**
- Consumes: seluruh Task 1–3; pipeline rilis yang sudah terbukti (v2.0.0–v2.0.3).

- [ ] **Step 1: Verify akhir lokal**

Run: `flutter analyze` → No issues; `flutter test` → semua lulus.
Expected: hijau.

- [ ] **Step 2: Build + install di emulator**

Run: `flutter build apk --release`; `adb -s emulator-5554 install -r build\app\outputs\flutter-apk\app-release.apk`.
Expected: Success.

- [ ] **Step 3: QA widget di emulator (manual, sabar dengan ghost-tap)**

1. Buka aplikasi sekali (refresh payload berjalan), beri data contoh kalau kosong (tambah 1 jadwal hari ini via aplikasi).
2. Kembali ke launcher → long-press area kosong (`adb shell input swipe 540 1400 540 1400 800`) → pilih **Widgets** → cari **Notedwork** → tap widget.
3. Verifikasi: header "Hari Ini · …", baris agenda tampil (maks 5), tombol + oranye; screenshot via `cmd /c "adb exec-out screencap -p > file"` → konversi JPEG → Read + probe piksel (komponen warna krem `#F7F4EE` judul, dot `#D97706`/warna kategori, latar `#101319`).
4. Ketuk **+** → aplikasi terbuka langsung di QuickAdd Jadwal → `dumpsys window | grep mCurrentFocus` harus MainActivity + sheet terbuka.
5. Tambah agenda baru dari QuickAdd → pulang ke launcher → widget ikut menampilkan baris baru (update via broadcast; kalau belum, tunggu ≤5 detik / re-pancing dengan membangun ulang payload lewat ganti tab).
6. Hapus semua agenda hari ini → widget menampilkan empty state.

- [ ] **Step 4: Bump versi + commit + tag**

`pubspec.yaml`: `version: 2.1.0+7`.
Run: `flutter analyze && flutter test`.
`git add -A; git commit -m "widget agenda layar utama, versi 2.1.0 (versionCode 7)"`; `git tag v2.1.0`; `git push origin main v2.1.0`.

- [ ] **Step 5: Rilis GitHub**

1. `Copy-Item build\app\outputs\flutter-apk\app-release.apk $env:TEMP\notedwork-2.1.0.apk`
2. Tulis `tool/RELEASE_NOTES_2.1.0.md` (Bahasa Indonesia: widget agenda + pintasan, cara memasang: long-press layar utama → Widgets → Notedwork) → commit + push.
3. `gh release create v2.1.0 $env:TEMP\notedwork-2.1.0.apk --repo Rochwidias/notedwork-app --title "v2.1.0" --notes-file tool/RELEASE_NOTES_2.1.0.md`
4. Verifikasi: `gh release view v2.1.0` asset terunggah; `git status` bersih.

- [ ] **Step 6: Laporan ke user (Bahasa Indonesia)**

Ringkas: apa yang dibuat, cara pakai widget, hasil QA, tautan rilis.

---

## Self-Review (penulis plan)

1. **Spec coverage:** tampilan §1 → Task 3 (layout+shapes+info xml, max 5 baris, #101319, empty state); arsitektur §2 → Task 1–3 (payload 7 hari, rutin day, provider filter, updatePeriodMillis 1800000); interaksi §3 → Task 2 (stream/initial) + Task 3 (HomeWidgetLaunchIntent URI); refresh §4 → Task 2 (initState + ref.listen) + info xml; error §5 → try/catch di bridge + provider; testing §6 → Task 1 (8 tes) + Task 4 (emulator). ✓
2. **Placeholder:** tidak ada TBD/TODO; langkah berisi kode penuh. Loop kosong `0 until 4` di Task 3 sengaja ditandai untuk DIBERSIHKAN saat menulis (bukan placeholder kode orang lain). ✓
3. **Konsistensi tipe:** `buildAgendaPayload` identik di Task 1/2 (named params sama); `AgendaWidgetBridge.update` = 6 param sesuai pemakaian di app.dart; key `agenda_payload` konsisten Kotlin↔Dart; URI `notedwork://widget/add` konsisten; `qualifiedAndroidName` = `app.notedwork.notedwork.AgendaWidgetProvider` = package+class Kotlin. ✓
