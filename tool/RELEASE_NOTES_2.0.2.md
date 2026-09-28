# Notedwork 2.0.2 (versionCode 5)

Rilis perbaikan visual setelah QA di emulator.

## Perubahan

- **Splash screen gelap** — latar splash kini `#101319` (mengikuti latar ikon), termasuk `windowSplashScreenBackground` untuk Android 12+. Sebelumnya putih menyilaukan.
- **Ikon notifikasi kustom** — notifikasi pengingat kini memakai ikon kalender monokrom (stat icon), bukan ikon launcher. Ikut terpasang di level kanal `Pengingat Jadwal`.
- **Salinan subtitle Kalender** — "Gmail & Kalender asli…" diganti "Ketuk tanggal untuk melihat agenda hari itu" karena versi ini offline-only (tidak ada Gmail). Bar Inggris disesuaikan.
- **Ketahanan start-up** — inisialisasi notifikasi dijaga try/catch dan resource ikon masuk `keep.xml`, supaya kegagalan notifikasi tidak pernah menggagalkan pembukaan aplikasi.

## Verifikasi

- `flutter analyze` — No issues found
- `flutter test` — 59/59 (dates, reminders, paritas i18n id/en, widget)
- Uji emulator: splash gelap, aplikasi boot normal, subtitle Kalender benar, notifikasi Tes terpasang dengan ikon baru (resource `ic_notification`)
