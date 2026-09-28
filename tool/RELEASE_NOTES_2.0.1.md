## Notedwork 2.0.1 — Ikon launcher diperbaiki

### Perubahan
- **Ikon aplikasi tidak lagi kotak.** Sudut putih bawaan file icon lama dibersihkan dan seluruh latar diseragamkan menjadi satu warna gelap (`#101319`), sehingga bentuk ikon mengikuti mask launcher masing-masing perangkat (adaptive icon — bulat, squircle, dan bentuk lain ikut tema HP kamu).
- Gradient/two-tone yang tadinya membuat ikon terlihat seperti kotak terpisah ikut disatukan.
- Sumber icon kini ikut di repo (`tool/icon_src.png`) sehingga build selalu reproduktif tanpa file eksternal.
- `versionCode` naik dari 3 ke 4 supaya bisa di-install sebagai upgrade dari v2.0.0.

### Catatan teknis
- Adaptive icon: background `#101319`, foreground di-inset 16% agar amat masuk safe zone semua bentuk mask.
- Gradle daemon heap diturunkan ke 4G untuk kestabilan build di mesin dengan RAM terbatas.
- Verifikasi: `flutter test` 59/59 lolos, `flutter analyze` bersih, icon di dalam APK dicek ulang (sudut `rgb(16,19,25)`).

Unduh: `notedwork-2.0.1.apk` di aset rilis ini.
