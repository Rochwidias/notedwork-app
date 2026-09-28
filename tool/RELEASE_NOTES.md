Rilis besar: aplikasi ditulis ulang dari wrapper web (Capacitor) menjadi aplikasi Flutter asli.

## Yang baru
- **Offline-first** — tugas, jadwal, rutinitas, catatan, dan pengingat tersimpan lokal (Hive); tanpa akun, tanpa internet
- **4 tab**: Hari Ini, Kalender, Tugas, Catatan + Quick Add (tombol +)
- **Tema**: Terang / Gelap / Otomatis, 5 preset aksen + kustom warna font & latar
- **Bahasa**: Indonesia + English lengkap (369 key per bahasa)
- **Notifikasi lokal**: pengingat jadwal & tugas (izin, resync otomatis, ketuk -> tab terkait), tombol Tes di Pengaturan
- **Desain baru** "Kertas Netral" / Material You Hangat
- Halaman Privasi & Syarat

## Catatan
- applicationId sama: `app.notedwork` (update langsung menimpa APK lama)
- Email/Gmail & Google Calendar disembunyikan di rilis ini (strategi offline-first)
- Izin notifikasi diminta saat pertama mengaktifkan Pengingat

## Verifikasi
- flutter analyze bersih, flutter test 59/59 lolos
- APK release signed (v2.0.0, versionCode 3)
