## v2.0.3 — Perbaikan alarm pengingat, tombol profil, tombol Lanjut

### Perbaikan alarm / notifikasi (keluhan: "tidak ada alarm sama sekali")
Empat masalah berlapis diperbaiki sekaligus:

1. **Izin notifikasi diminta saat pertama buka aplikasi.** Sebelumnya izin hanya muncul saat tombol Pengingat di Pengaturan diaktifkan ulang, padahal pengingat sudah aktif secara bawaan — sehingga pengguna baru tidak pernah diminta izin dan notifikasi tidak pernah muncul.
2. **Pengingat dijadwalkan ulang setiap kali aplikasi dibuka.** Sebelumnya jadwal hanya diperbarui saat data berubah, sehingga alarm tidak pernah terdaftar di sistem.
3. **Receiver boot ditambahkan.** Setelah restart ponsel, alarm sekarang dipasang ulang otomatis (BOOT_COMPLETED / MY_PACKAGE_REPLACED).
4. **Pengingat yang waktunya sudah lewat tetap dibunyikan.** Jika waktu pengingat sudah terlewati tetapi acara masih akan datang, notifikasi "Segera dimulai jam HH:MM" dikirim segera, bukan dibuang diam-diam. Horizon penjadwalan juga diperluas dari 7 hari menjadi 30 hari.

### Perbaikan tombol
- **Tombol "Lanjut" di Tambah Cepat kadang tidak bisa ditekan.** Tombol kini selalu bisa ditekan; judul tervalidasi saat ditekan dengan pesan kesalahan inline.
- **Tombol Profil ditambahkan di bar navigasi bawah** (ikon orang, posisi ke-5) supaya Pengaturan mudah ditemukan. Berlaku juga untuk NavigationRail di layar lebar.

### Teknis
- Logika penjadwalan pengingat dipecah menjadi fungsi murni `planSchedule` dengan 7 tes unit baru (total 66 tes, semua lulus).
- Tombol Profil di bar navigasi tidak menggeser tab aktif — membuka layar Pengaturan sebagai rute terpisah.

Diuji di emulator Android 17 (API 37): dialog izin muncul saat buka pertama kali, 10 alarm RTC_WAKEUP terdaftar setelah aplikasi dibuka, dan tombol Lanjut selalu aktif.
