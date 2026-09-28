# Spec: Widget Agenda Notedwork (Android Home Screen)

Tanggal: 2026-09-28 · Status: disetujui user ("gaskun esekusi sampai jadi")
Jalur: arsitektural (subsistem baru) · Pendekatan: **A — paket `home_widget` + renderer Kotlin RemoteViews**

## Tujuan

User bisa melihat agenda hari ini langsung dari layar utama Android tanpa membuka aplikasi, dan punya pintasan satu ketuk untuk menambah jadwal. Menjawab keluhan: "biar user bisa inget hari ini jadwalnya apa".

## Cakupan (dikonfirmasi user)

- **Isi widget**: agenda hari ini **lengkap seperti kartu Agenda di tab Kalender** — jadwal rutin hari ini + Sched (agenda) + deadline tugas yang belum selesai.
- **Pintasan**: tombol **+** membuka QuickAdd Jadwal.
- **Varian**: satu widget 4×2 (medium). iOS, varian ukuran lain, widget catatan/tugas = di luar scope (YAGNI).

## 1. Tampilan

- Ukuran 4×2, minWidth 250dp × minHeight 110dp; layout `res/layout/widget_agenda.xml` (RemoteViews, LinearLayout vertikal).
- Gaya **kertas gelap konsisten `#101319`** + sudut 16dp + teks krem — sama dengan ikon aplikasi; TIDAK ikut tema terang/gelap aplikasi (widget harus stabil di wallpaper apa pun).
- Header: `Hari Ini · <Sen, 28 Sep 2026>` (sudah diformat di Flutter sesuai bahasa) + tombol **+** di kanan.
- Daftar: maks **5 baris** — titik warna kategori · jam (mono) · judul. Baris ke-6+ disembunyikan (visibility GONE).
- Empty state: `<Belum ada agenda hari ini>` + tombol + tetap tampil.
- `res/xml/notedwork_widget_info.xml`: updatePeriodMillis 1800000 (30 menit), resizeMode horizontal|vertical, previewImage opsional.

## 2. Arsitektur & data flow

- **Dependency pub**: `home_widget` (satu-satunya tambahan; bridge resmi Flutter↔SharedPreferences↔AppWidgetProvider).
- **Flutter** — `lib/core/widget/agenda_widget.dart`:
  - Fungsi murni `buildAgendaPayload({required List<Sched> scheds, required List<Routine> routines, required List<Task> tasks, required DateTime now, required String header, required String emptyText}) → String` (JSON):
    - Sched: tanggal `now` s/d +7 hari, belum lewat; field `date, time, endTime, title, color`.
    - Task: `!done`, deadline `date` dalam horizon 7 hari; field `date, time (default 23:59), title, prio`.
    - Rutin: mingguan, field `day (1..7), start, end, title, color` (tanpa tanggal — provider mencocokkan hari).
    - `header` (mis. `Hari Ini · Sen, 28 Sep 2026`) dan `emptyText` sudah diformat per bahasa oleh pemanggil (fmtDateID + l10n) — provider hanya menampilkan.
    - Item urut: rutin (jam mulai) → sched → tugas, sama seperti agenda Kalender.
  - `AgendaWidgetBridge.update()` — try/catch: `HomeWidget.saveWidgetData('agenda_payload', json)` + `HomeWidget.updateWidget()`.
- **Kotlin** — `android/app/src/main/kotlin/app/notedwork/notedwork/AgendaWidgetProvider` extends `es.antonborri.home_widget.HomeWidgetProvider`:
  - `onUpdate` baca `widgetData.getString("agenda_payload")` → parse JSONArray → **filter item hari ini** (sched/task cocok `date == todayStr`; rutin cocok `day == weekdayISO`) → render RemoteViews → `updateAppWidget`.
  - Payload berisi 7 hari ke depan ⇒ **rollover tanggal benar walau aplikasi tidak dibuka**; updatePeriodMillis 30 menit menutup sisa kasus.
  - Payload korup/kosong → render empty state (tanpa crash).
- **Manifest**: receiver `AgendaWidgetProvider` (exported, permission `BIND_APPWIDGET`, intent-filter `android.appwidget.action.APPWIDGET_UPDATE`).

## 3. Interaksi

- Tombol **+** → `HomeWidgetLaunchIntent.getActivity(context, MainActivity, Uri.parse("notedwork://widget/add"))`.
- Ketuk baris/header → launch intent URI `notedwork://widget/open` (buka aplikasi normal).
- Flutter (NotedworkApp.initState): dengar `HomeWidget.initialWidgetClicked` + `HomeWidget.widgetClicked` → parse URI → `add` → `showQuickAdd(context, kind: sched)`; `open` → tidak perlu handling khusus (app terbuka di tab terakhir). Pola sama seperti `NotificationService.taps`.

## 4. Kebijakan refresh

1. Saat aplikasi dibuka (post-frame di initState).
2. Setiap data berubah (`ref.listen` tasks/scheds/routines di app shell → `AgendaWidgetBridge.update()`).
3. Mandiri tiap 30 menit dari sistem (provider membaca payload tersimpan).

## 5. Error handling

- Semua panggilan home_widget dibungkus try/catch + log — widget gagal ≠ aplikasi gagal (pola v2.0.3).
- JSON korup → empty state.

## 6. Testing

- Unit Dart (`test/core/agenda_payload_test.dart`): horizon 7 hari, rutin cocok hari, tugas done dibuang, jam default tugas, urutan, format id/en, payload JSON valid & round-trip.
- `flutter analyze` + `flutter test` hijau.
- Emulator: pasang widget via picker → baris benar; ketuk + → QuickAdd Jadwal; tambah agenda di app → widget ter-update; empty state setelah data dihapus.

## Di luar scope

iOS, ukuran widget lain, widget catatan/tugas, sinkronisasi langkah dengan tema aplikasi.
