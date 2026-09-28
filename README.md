# Notedwork — Aplikasi Flutter

Aplikasi Android (Flutter) untuk **catatan, tugas, jadwal, dan pengingat** — 100% offline-first. Menulis ulang versi web [notedwork](https://notedwork.vercel.app) ke Flutter dengan desain **"Kertas Netral" / Material You Hangat**.

## Fitur

- **Hari Ini** — kartu pengingat dengan hitung mundur, 3 Terpenting, strip minggu, agenda hari terpilih
- **Kalender** — grid bulan (auto-ikut tanggal terpilih), agenda jadwal + tugas, rutinitas mingguan (CRUD), warna kategori
- **Tugas** — filter Semua/Aktif/Telat/Selesai, badge (telat/hari ini/selesai), prioritas tinggi/sedang/rendah, pengingat
- **Catatan** — daftar + editor bottom-sheet, lokal saja (tanpa Google Drive)
- **Quick Add** — wizard 2 langkah (Tugas/Jadwal/Catatan) dari tombol ＋
- **Pengaturan** — tema Terang/Gelap/Otomatis, 5 preset aksen + kustom (warna font & latar), bahasa **Indonesia/English** lengkap (369 key × 2), toggle pengingat + tombol **Tes** notifikasi, halaman Privasi & Syarat
- **Notifikasi lokal** — `flutter_local_notifications`, channel "Pengingat Jadwal", jadwal ulang (resync) otomatis saat data/izin berubah, ketuk notifikasi → lalu tab terkait

Email/Gmail dan Google Analytics sengaja **disembunyikan** di versi ini (strategi offline-first).

## Struktur

```
lib/
├── main.dart                 # bootstrap: Hive + notifikasi + ProviderScope
├── app.dart                  # shell: NavigationBar/Rail, tab, FAB, locale/theme
├── core/
│   ├── models.dart           # Task, Sched, Routine, Note, Prio, NavTarget, ...
│   ├── dates.dart            # tanggal/badge/prioritas/uid (port lib/dates.ts)
│   ├── reminders.dart        # nextReminder, formatCountdown (port lib/reminders.ts)
│   ├── storage/store.dart    # Hive (box 'data' + 'settings')
│   ├── state/state.dart      # Riverpod notifiers + provider
│   ├── theme/                # palette, theme_config, app_theme (NwThemeExt)
│   └── notifications/        # NotificationService (izin, resync, tes, tap)
├── features/                 # today, calendar, tasks, notes, settings, quick_add
└── l10n/                     # app_id.arb + app_en.arb (369 key, paritas dijaga tes)
test/                         # dates, reminders, l10n parity, widget (59+ tes)
```

## Menjalankan

Prasyarat: Flutter 3.47+, Android SDK.

```bash
flutter pub get
flutter gen-l10n        # otomatis saat build, tapi aman dijalankan manual
flutter analyze
flutter test
flutter run
```

## Build APK release

```bash
flutter build apk --release
# hasil: build/app/outputs/flutter-apk/app-release.apk
```

Signing release memakai `android/key.properties` + `android/notedwork.keystore` (keduanya **gitignored** — salin dari tim/CI, atau hapus file agar fallback ke debug keys):

```properties
# android/key.properties
storePassword=...
keyPassword=...
keyAlias=notedwork
storeFile=notedwork.keystore
```

Generate keystore baru (sekali saja):

```bash
keytool -genkeypair -v -keystore android/notedwork.keystore -alias notedwork \
  -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=notedwork, O=notedwork, C=ID"
```

## Icon

`tool/icon_fg.png` adalah varian padding untuk adaptive icon. Regenerasi semua icon (sumber: `C:/Project/notedwork/public/icon-512.png` — path di `pubspec.yaml` bagian `flutter_launcher_icons`):

```bash
dart run flutter_launcher_icons
```

## Catatan teknis

- **applicationId** `app.notedwork` (sama dengan APK Capacitor lama).
- Izin Android: `POST_NOTIFICATIONS`, `SCHEDULE_EXACT_ALARM`, `USE_EXACT_ALARM`, `VIBRATE`, `RECEIVE_BOOT_COMPLETED`.
- Data disimpan lokal via **Hive** (`hive_ce`) — tidak ada jaringan, tidak ada akun.
- I18n: 369 key per bahasa; paritas id/en dijaga `test/l10n/parity_test.dart`. Peta rename web→ARB: `lib/l10n/KEY_RENAMES.md`.
- Font: Poppins (UI) + JetBrains Mono (jam/kode) via `google_fonts` (diambil runtime; offline pertama kali → fallback sistem).
- Desain mengikuti `docs/superpowers/specs/2026-09-16-notedwork-redesign-design.md` di repo web: radius 16, tanpa emoji di chrome, satu tombol utama per layar, empty state selalu punya aksi.
