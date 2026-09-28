// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get nav_home => 'Hari Ini';

  @override
  String get nav_email => 'Email';

  @override
  String get nav_tasks => 'Tugas';

  @override
  String get nav_calendar => 'Kalender';

  @override
  String get nav_notes => 'Catatan';

  @override
  String get nav_settings => 'Pengaturan';

  @override
  String get nav_menu => 'MENU';

  @override
  String get nav_addSection => 'TAMBAH';

  @override
  String get nav_addNew => 'Tambah Baru';

  @override
  String get nav_main => 'Navigasi utama';

  @override
  String get tambah_title => 'Tambah Baru';

  @override
  String get tambah_hint => 'Pilih yang mau dibuat.';

  @override
  String get tambah_mail => 'Tulis Email';

  @override
  String get tambah_mailSub => 'Terkirim via Gmail';

  @override
  String get tambah_task => 'Tambah Tugas';

  @override
  String get tambah_taskSub => 'Deadline muncul di Kalender';

  @override
  String get tambah_sched => 'Tambah Jadwal';

  @override
  String get tambah_schedSub => 'Agenda sekali saja';

  @override
  String get tambah_note => 'Tambah Catatan';

  @override
  String get tambah_noteSub => 'Ide cepat tersimpan lokal';

  @override
  String get tambah_mailNew => 'Tulis email baru';

  @override
  String get tambah_taskNew => 'Tambah tugas baru';

  @override
  String get tambah_schedNew => 'Tambah jadwal baru';

  @override
  String get tambah_noteNew => 'Tambah catatan baru';

  @override
  String get notes_title => 'Catatan';

  @override
  String get notes_add => 'Tambah';

  @override
  String get notes_empty => 'Belum ada catatan.';

  @override
  String get notes_emptyHint => 'Ketuk tombol + untuk menambah satu.';

  @override
  String get notes_edit => 'Ubah';

  @override
  String get notes_delete => 'Hapus';

  @override
  String get notes_settings => 'Pengaturan';

  @override
  String get notes_sheetAdd => 'Tambah Catatan';

  @override
  String get notes_sheetEdit => 'Ubah Catatan';

  @override
  String get notes_fieldTitle => 'Judul';

  @override
  String get notes_fieldBody => 'Isi';

  @override
  String get notes_titlePh => 'cth: Ide cepat';

  @override
  String get notes_bodyPh => 'Tulis catatan…';

  @override
  String get notes_titleRequired => 'Judul wajib diisi';

  @override
  String get notes_saving => 'Menyimpan…';

  @override
  String get notes_onDrive => 'di Drive';

  @override
  String get notes_saveChanges => 'Simpan perubahan';

  @override
  String get topbar_langToEn => 'Switch to English';

  @override
  String get topbar_langToId => 'Ganti ke Bahasa Indonesia';

  @override
  String get topbar_theme => 'Ganti tema';

  @override
  String get topbar_themeToLight => 'Mode terang';

  @override
  String get topbar_themeToDark => 'Mode gelap';

  @override
  String get topbar_settings => 'Pengaturan';

  @override
  String get topbar_connect => 'Koneksi Google';

  @override
  String get topbar_tagline => 'Email & Jadwal mahasiswa';

  @override
  String get common_save => 'Simpan';

  @override
  String get common_close => 'Tutup';

  @override
  String get common_delete => 'Hapus';

  @override
  String get common_cancel => 'Batal';

  @override
  String get common_edit => 'Ubah';

  @override
  String get common_all => 'Semua';

  @override
  String get common_markDone => 'Tandai selesai';

  @override
  String get common_tapToComplete => '. Ketuk untuk tandai selesai.';

  @override
  String get confirm_title => 'Yakin hapus?';

  @override
  String confirm_desc(String title) {
    return '“$title” akan dihapus permanen dan tidak bisa dikembalikan.';
  }

  @override
  String get home_title => 'Hari Ini';

  @override
  String get home_hello => 'Halo';

  @override
  String get home_previewSuffix => ' — Mode pratinjau (data contoh)';

  @override
  String get home_guestName => 'di sana';

  @override
  String get home_dueSoon => 'Sebentar lagi';

  @override
  String home_inMin(String n) {
    return '$n mnt lagi';
  }

  @override
  String home_inHours(String h, String m) {
    return '$h jam $m mnt lagi';
  }

  @override
  String home_inHoursEven(String h) {
    return '$h jam lagi';
  }

  @override
  String get home_tomorrow => 'Besok';

  @override
  String home_inDays(String d) {
    return '$d hari lagi';
  }

  @override
  String get home_room => 'Ruang';

  @override
  String get home_reminderPrefix => 'Pengingat';

  @override
  String get home_openCalendar => 'Buka kalender';

  @override
  String get home_reminderAriaNone => 'Tidak ada pengingat. Buka kalender.';

  @override
  String get home_viewCalendar => 'Lihat kalender';

  @override
  String get home_noReminder => 'Tidak ada pengingat berikutnya';

  @override
  String get home_noReminderSub =>
      'Belum ada agenda atau deadline. Nikmati harimu!';

  @override
  String get home_top3 => '3 Terpenting';

  @override
  String get home_next7 => 'Agenda 7 hari ke depan';

  @override
  String get home_next7empty => 'Tidak ada agenda 7 hari ke depan.';

  @override
  String get home_nearTasks => 'Tugas terdekat';

  @override
  String get home_nearTasksEmpty => 'Belum ada tugas. Nikmati harimu!';

  @override
  String get home_allDone => 'Semua tugas selesai. Nikmati harimu!';

  @override
  String get home_thisWeek => 'Minggu ini';

  @override
  String get home_emailImportant => 'Email penting';

  @override
  String get home_openMail => 'Buka email: ';

  @override
  String get home_inboxClear => 'Kotak masuk beres. Tidak ada email penting.';

  @override
  String get email_title => 'Email';

  @override
  String get email_previewSub =>
      'Mode pratinjau — data contoh. Bukan data aslimu.';

  @override
  String get email_liveBase => 'Gmail & Kalender asli';

  @override
  String get email_updatedFrag => ' • update ';

  @override
  String get email_countSep => ' • ';

  @override
  String get email_countUnit => ' email';

  @override
  String get email_filterUnread => 'Belum dibaca';

  @override
  String get email_filterStar => 'Bintang';

  @override
  String get email_showEmails => 'Tampilkan email';

  @override
  String get email_searchPh => 'Cari email…';

  @override
  String get email_searchLabel => 'Cari email';

  @override
  String get email_clearSearch => 'Bersihkan pencarian';

  @override
  String get email_typing => 'Mengetik…';

  @override
  String get email_searching => 'Mencari…';

  @override
  String get email_results => ' hasil';

  @override
  String get email_resultsFor => ' untuk “';

  @override
  String get email_loading => 'Memuat email';

  @override
  String get email_unreadSuffix => ', belum dibaca';

  @override
  String get email_starTitle => 'Bintang';

  @override
  String get email_unstar => 'Hapus bintang';

  @override
  String get email_giveStar => 'Beri bintang';

  @override
  String get email_noTag => 'Tanpa label';

  @override
  String get email_noResults =>
      'Tidak ada hasil. Coba kata kunci atau filter lain.';

  @override
  String get email_emptyHere => 'Tidak ada email di sini.';

  @override
  String get email_loadingMore => 'Memuat…';

  @override
  String get email_loadMore => 'Muat lagi (50 berikutnya)';

  @override
  String get email_backToList => 'Kembali ke daftar';

  @override
  String get email_backToListAria => 'Kembali ke daftar email';

  @override
  String get email_badgeNew => 'Baru';

  @override
  String get email_attach => 'LAMPIRAN (';

  @override
  String get email_reply => 'Balas';

  @override
  String get email_forward => 'Teruskan';

  @override
  String get email_moreActions => 'Aksi email lainnya';

  @override
  String get email_more => 'Lainnya';

  @override
  String get email_archive => 'Arsipkan';

  @override
  String get email_markUnread => 'Tandai belum dibaca';

  @override
  String get tasks_title => 'Tugas';

  @override
  String get tasks_previewSub =>
      'Mode pratinjau — data contoh, tersimpan lokal di perangkatmu';

  @override
  String get tasks_liveSub =>
      'Gmail & Kalender asli — deadline ikut muncul di Kalender & Dashboard';

  @override
  String get tasks_filterActive => 'Aktif';

  @override
  String get tasks_filterOverdue => 'Telat';

  @override
  String get tasks_filterDone => 'Selesai';

  @override
  String get tasks_stateDone => 'selesai';

  @override
  String get tasks_stateActive => 'aktif';

  @override
  String get tasks_tapToToggle => '. Ketuk untuk ubah status.';

  @override
  String get tasks_reopen => 'Buka lagi';

  @override
  String get tasks_emptyHere => 'Tidak ada tugas di sini.';

  @override
  String get tasks_addTask => 'Tambah tugas';

  @override
  String get cal_previewSub =>
      'Mode pratinjau — data contoh. Bukan data aslimu.';

  @override
  String get cal_liveSub =>
      'Gmail & Kalender asli — ketuk tanggal untuk melihat agenda';

  @override
  String get cal_prevMonth => 'Bulan sebelumnya';

  @override
  String get cal_nextMonth => 'Bulan berikutnya';

  @override
  String get cal_routine => 'Rutin';

  @override
  String get cal_agenda => 'Agenda';

  @override
  String get cal_deadline => 'Deadline';

  @override
  String get cal_today => 'Hari ini';

  @override
  String get cal_backToday => 'Kembali ke hari ini';

  @override
  String get cal_room => 'Ruang';

  @override
  String get cal_deadlineAt => ' • deadline ';

  @override
  String get cal_emptyDate => 'Tidak ada agenda di tanggal ini.';

  @override
  String get cal_upcoming7 => 'Agenda terdekat 7 hari ke depan:';

  @override
  String get cal_enjoyDay => 'Nikmati harimu!';

  @override
  String get cal_addSched => 'Tambah Jadwal';

  @override
  String get cal_weeklyRoutine => 'Jadwal rutin mingguan';

  @override
  String get cal_noRoutine => 'Belum ada jadwal rutin.';

  @override
  String get cal_manageRoutine => 'Kelola jadwal rutin';

  @override
  String get common_optional => '(opsional)';

  @override
  String get reminder_title => 'Pengingat';

  @override
  String get reminder_off => 'Mati';

  @override
  String get reminder_min => ' mnt';

  @override
  String get reminder_hour => ' jam';

  @override
  String get reminder_hours => ' jam';

  @override
  String get reminder_day => ' hari';

  @override
  String get sched_editTitle => 'Ubah Jadwal';

  @override
  String get sched_addTitle => 'Tambah Jadwal';

  @override
  String get sched_hint =>
      'Agenda sekali saja. Untuk matkul tiap minggu, pakai jadwal rutin.';

  @override
  String get sched_titleRequired => 'Isi judul dulu — cth: Seminar proposal';

  @override
  String get sched_endInvalid =>
      'Format jam selesai tidak valid — kosongkan bila sekilas';

  @override
  String get sched_fieldTitle => 'Judul';

  @override
  String get sched_titlePh => 'cth: Seminar proposal';

  @override
  String get sched_fieldDate => 'Tanggal';

  @override
  String get sched_startLabel => 'Jam mulai ';

  @override
  String get sched_endLabel => 'Jam selesai ';

  @override
  String get sched_endHint =>
      'Dikosongkan = sekilas (pakai jam mulai saja). Diisi = tampil rentang 09.00–10.40. Jam selesai lebih kecil = lewat tengah malam (besok).';

  @override
  String get sched_fieldNote => 'Keterangan';

  @override
  String get sched_notePh => 'Ruang, dosen, link meeting…';

  @override
  String get sched_saving => 'Menyimpan…';

  @override
  String get sched_saveChanges => 'Simpan perubahan';

  @override
  String get task_editTitle => 'Ubah Tugas';

  @override
  String get task_addTitle => 'Tambah Tugas';

  @override
  String get task_hint => 'Deadline otomatis muncul di Kalender & Dashboard.';

  @override
  String get task_titleRequired =>
      'Isi judul tugas dulu — cth: Laporan modul 6';

  @override
  String get task_fieldCourse => 'Mata kuliah';

  @override
  String get task_coursePh => 'cth: Basis Data';

  @override
  String get task_fieldTitle => 'Judul tugas';

  @override
  String get task_titlePh => 'cth: Laporan modul 6';

  @override
  String get task_fieldDate => 'Deadline tanggal';

  @override
  String get task_fieldTime => 'Jam ';

  @override
  String get task_timeHint => 'Dikosongkan = akhir hari 23.59.';

  @override
  String get task_fieldPrio => 'Prioritas';

  @override
  String get task_fieldNote => 'Catatan';

  @override
  String get task_notePh => 'Cara kumpul, link, dsb…';

  @override
  String get task_saving => 'Menyimpan…';

  @override
  String get task_saveChanges => 'Simpan perubahan';

  @override
  String get mail_replyTitle => 'Balas Email';

  @override
  String get mail_fwdTitle => 'Teruskan Email';

  @override
  String get mail_composeTitle => 'Tulis Email';

  @override
  String get mail_hint => 'Terkirim langsung via Gmail.';

  @override
  String get mail_toInvalid => 'Format email tujuan tidak valid';

  @override
  String get mail_fieldTo => 'Kepada';

  @override
  String get mail_toPh => 'dosen@univ.ac.id';

  @override
  String get mail_fieldSubj => 'Subjek ';

  @override
  String get mail_subjPh => 'Izin / konsultasi / tugas…';

  @override
  String get mail_fieldBody => 'Isi';

  @override
  String get mail_bodyPh => 'Tulis pesan…';

  @override
  String get mail_sending => 'Mengirim…';

  @override
  String get mail_send => 'Kirim';

  @override
  String get routine_title => 'Kelola Jadwal Rutin';

  @override
  String get routine_hint =>
      'Matkul tetap tiap minggu — otomatis muncul di Kalender.';

  @override
  String get routine_fieldCourse => 'Mata kuliah';

  @override
  String get routine_coursePh => 'cth: Sistem Operasi';

  @override
  String get routine_fieldDay => 'Hari';

  @override
  String get routine_fieldRoom => 'Ruang';

  @override
  String get routine_roomPh => 'cth: 2A';

  @override
  String get routine_fieldStart => 'Mulai';

  @override
  String get routine_fieldEnd => 'Selesai';

  @override
  String get routine_fieldLect => 'Dosen';

  @override
  String get routine_lectPh => 'cth: Pak Andi';

  @override
  String get routine_adding => 'Menambah…';

  @override
  String get routine_add => 'Tambah';

  @override
  String get routine_mineTitle => 'Jadwal buatanmu (';

  @override
  String get routine_emptyMine => 'Belum ada — tambah lewat form di atas.';

  @override
  String get settings_title => 'Pengaturan';

  @override
  String get settings_accountOn => 'Akun Google yang tersambung';

  @override
  String get settings_previewMode => 'Mode pratinjau — data contoh';

  @override
  String get settings_account => 'Akun';

  @override
  String get settings_loggedSub => 'Login via Google';

  @override
  String get settings_guestMode => 'Mode tamu';

  @override
  String get settings_guestSub => 'Pratinjau dengan data contoh';

  @override
  String get settings_displayName => 'Nama tampilan';

  @override
  String get settings_namePh => 'cth: Budi';

  @override
  String get settings_logout => 'Keluar';

  @override
  String get settings_connectGoogle => 'Hubungkan Google';

  @override
  String get settings_exitPreview => 'Keluar dari pratinjau (hapus data tamu)';

  @override
  String get settings_themeGallery => 'Galeri Tema';

  @override
  String get settings_appearance => 'Tampilan';

  @override
  String get settings_appearanceSub => 'Terang, gelap, atau ikut sistem';

  @override
  String get settings_light => 'Terang';

  @override
  String get settings_dark => 'Gelap';

  @override
  String get settings_auto => 'Otomatis';

  @override
  String get settings_modeGroup => 'Mode tampilan';

  @override
  String get settings_accentColor => 'Warna tampilan';

  @override
  String get settings_accentSub =>
      'Aksen tombol, badge & logo — pilihanmu, tersimpan di perangkat';

  @override
  String get settings_colorOf => 'Warna ';

  @override
  String get settings_customColor => 'Warna custom';

  @override
  String get settings_reset => 'Reset';

  @override
  String get settings_fontColor => 'Warna font';

  @override
  String get settings_fontColorSub =>
      'Warna teks aplikasi — pilihanmu, tersimpan di perangkat';

  @override
  String get settings_bgColor => 'Warna latar';

  @override
  String get settings_bgColorSub =>
      'Warna latar aplikasi — pilihanmu, tersimpan di perangkat';

  @override
  String settings_forMode(String mode) {
    return 'mode $mode';
  }

  @override
  String get settings_testNotif => 'Tes';

  @override
  String get settings_testNotifSample => 'Presentasi PBO — 10 menit lagi';

  @override
  String get settings_reminderTitle => 'Pengingat jadwal';

  @override
  String get settings_reminderSub => 'Notifikasi pengingat dari aplikasi';

  @override
  String get settings_connTitle => 'Koneksi Google';

  @override
  String settings_connLive(String email) {
    return 'Tersambung sebagai $email';
  }

  @override
  String get settings_connNone => 'Belum tersambung';

  @override
  String get settings_loginGoogle => 'Login dengan Google';

  @override
  String get settings_info => 'Info';

  @override
  String get settings_credit => 'Kredit';

  @override
  String get settings_creditSub => 'Pembuat & teknologi notedwork';

  @override
  String get settings_privacy => 'Privasi';

  @override
  String get settings_privacySub => 'Data apa yang disimpan & di mana';

  @override
  String get settings_terms => 'Syarat';

  @override
  String get settings_termsSub => 'Aturan pakai aplikasi ini';

  @override
  String get settings_installApp => 'Pasang aplikasi';

  @override
  String get settings_installAppSub => 'Buka notedwork dari layar utama HP';

  @override
  String get settings_open => 'Buka';

  @override
  String get settings_about => 'Tentang';

  @override
  String get settings_aboutBody1 =>
      'notedwork — email, tugas & kalender untuk mahasiswa.';

  @override
  String get settings_aboutBody2 => 'Bisa dipasang ke layar utama HP.';

  @override
  String get settings_copyright => '© 2026 Rochwidias. Hak cipta dilindungi.';

  @override
  String get toast_syncFail => 'Gagal sync Google';

  @override
  String get toast_loginTokenFail =>
      'Login Google gagal saat simpan token — coba lagi';

  @override
  String get toast_loginSessionFail =>
      'Login Google gagal saat buat sesi — coba lagi';

  @override
  String get toast_loginExpired => 'Login Google kedaluwarsa — coba lagi';

  @override
  String get toast_loginCancelled => 'Login Google dibatalkan';

  @override
  String get toast_loginFail => 'Login Google gagal, coba lagi';

  @override
  String get toast_connected => 'Terhubung ke Google';

  @override
  String get toast_mailBodyFail => 'Gagal memuat isi email';

  @override
  String get toast_starFail => 'Gagal ubah bintang';

  @override
  String get toast_archived => 'Diarsipkan';

  @override
  String get toast_markedUnread => 'Ditandai belum dibaca';

  @override
  String get toast_gmailFail => 'Aksi Gmail gagal';

  @override
  String get toast_taskReopened => 'Dibuka lagi';

  @override
  String get toast_taskDone => 'Tugas selesai!';

  @override
  String get toast_taskDeleted => 'Tugas dihapus';

  @override
  String get toast_taskMissing => 'Tugas tidak ditemukan';

  @override
  String get toast_schedDeleted => 'Jadwal dihapus';

  @override
  String get toast_gcalDeleted => 'Event Google dihapus';

  @override
  String get toast_schedDeleteFail => 'Gagal hapus event';

  @override
  String get toast_schedSaved => 'Jadwal tersimpan';

  @override
  String get toast_schedSavedGcal => 'Jadwal tersimpan ke Google Calendar';

  @override
  String get toast_schedSaveFail => 'Gagal simpan ke Google';

  @override
  String get toast_schedMissing => 'Jadwal tidak ditemukan';

  @override
  String get toast_schedUpdated => 'Jadwal diperbarui';

  @override
  String get toast_schedUpdatedGcal => 'Jadwal diperbarui di Google Calendar';

  @override
  String get toast_updateFailPrefix => 'Gagal ubah: ';

  @override
  String get toast_previewLoginHint =>
      'Login dengan Google untuk memakai data aslimu';

  @override
  String get toast_mailSent => 'Email terkirim via Gmail';

  @override
  String get toast_sendFailPrefix => 'Gagal kirim: ';

  @override
  String get toast_loggedOut => 'Keluar dari Google';

  @override
  String get toast_loggedOutLocal =>
      'Keluar lokal; sesi server mungkin masih aktif — coba lagi';

  @override
  String get toast_exitPreview => 'Keluar dari mode pratinjau';

  @override
  String get toast_exitPreviewConfirm =>
      'Keluar dari pratinjau? Data tamu (tugas, rutin, jadwal contoh) akan dihapus dan dikembalikan ke contoh awal.';

  @override
  String get toast_routineDeleted => 'Jadwal rutin dihapus';

  @override
  String get toast_noteDeleted => 'Catatan dihapus';

  @override
  String get toast_driveSyncFail => 'Gagal sync ke Drive, tersimpan lokal';

  @override
  String get toast_reminderPrefix => 'Pengingat: ';

  @override
  String get toast_notifOff => 'Pengingat dimatikan';

  @override
  String get toast_notifOn => 'Pengingat dinyalakan';

  @override
  String get toast_taskUpdated => 'Tugas diperbarui';

  @override
  String get toast_taskSaved => 'Tugas tersimpan';

  @override
  String get toast_routineSaved => 'Jadwal rutin tersimpan';

  @override
  String get banner_previewTitle => 'Mode pratinjau — data contoh';

  @override
  String get banner_previewSub =>
      'Bukan data aslimu. Login untuk Gmail & Kalender asli.';

  @override
  String get banner_login => 'Login dengan Google';

  @override
  String get install_entryTitle => 'Pasang notedwork di HP';

  @override
  String get install_entrySub => 'Buka sekali ketuk, tanpa cari di browser.';

  @override
  String get install_entryBtn => 'Pasang';

  @override
  String get install_title => 'Pasang notedwork';

  @override
  String get install_sub =>
      'Buka sekali ketuk dari layar utama — tanpa buka browser & login ulang.';

  @override
  String get install_tabAndroid => 'Android';

  @override
  String get install_tabIphone => 'iPhone';

  @override
  String get install_tabLaptop => 'Laptop';

  @override
  String get install_nativeBtn => 'Pasang Sekarang';

  @override
  String get install_never => 'Jangan tampilkan lagi';

  @override
  String get install_dismissedToast =>
      'Siap — kartu install tidak akan ditampilkan lagi';

  @override
  String get install_installedToast => 'notedwork terpasang — selamat!';

  @override
  String get install_android1 =>
      'Ketuk tombol Pasang Sekarang di bawah (Chrome).';

  @override
  String get install_android2 => 'Konfirmasi “Pasang” pada dialog yang muncul.';

  @override
  String get install_android3 =>
      'Ikon notedwork muncul di layar utama & laci aplikasi.';

  @override
  String get install_iphone1 => 'Ketuk tombol Bagikan di Safari.';

  @override
  String get install_iphone2 => 'Pilih “Tambahkan ke Layar Utama”.';

  @override
  String get install_iphone3 =>
      'Ketuk “Tambah” — ikon notedwork muncul di layar utama.';

  @override
  String get install_laptop1 => 'Klik ikon Pasang di address bar Chrome/Edge.';

  @override
  String get install_laptop2 => 'Atau menu ⋮ → “Pasang notedwork…”.';

  @override
  String get install_laptop3 =>
      'Klik “Pasang” — app terbuka di jendela sendiri.';

  @override
  String mail_quoteWrote(String time, String from) {
    return 'Pada $time, $from menulis:';
  }

  @override
  String mail_quoteFwd(String from, String email) {
    return '— Diteruskan dari $from <$email> —';
  }

  @override
  String get quick_title => 'Tambah Cepat';

  @override
  String get quick_hint => 'Ketik sekali, geser jam, simpan.';

  @override
  String get quick_step1 => 'Langkah 1 — Apa?';

  @override
  String get quick_step2 => 'Langkah 2 — Kapan?';

  @override
  String get quick_step3 => 'Langkah 3 — Cek';

  @override
  String get quick_whatPh => 'Hari ini tugasnya apa?';

  @override
  String get quick_detailPh => 'Detail opsional…';

  @override
  String get quick_titleRequired => 'Judul wajib diisi';

  @override
  String get quick_next => 'Lanjut';

  @override
  String get quick_back => 'Kembali';

  @override
  String get quick_timeLabel => 'Jam';

  @override
  String get quick_dateLabel => 'Tanggal';

  @override
  String get quick_toLabel => 'Ke';

  @override
  String get quick_toPh => 'nama@email.com';

  @override
  String get quick_presetMorning => 'Pagi';

  @override
  String get quick_presetNoon => 'Siang';

  @override
  String get quick_presetNight => 'Malam';

  @override
  String get quick_presetTomorrow => 'Besok';

  @override
  String get quick_detailLink => 'Lengkapi detail';

  @override
  String get quick_summaryKind => 'Jenis';

  @override
  String get quick_titleTask => 'Tambah Cepat Tugas';

  @override
  String get quick_titleSched => 'Tambah Cepat Jadwal';

  @override
  String get quick_titleMail => 'Tulis Cepat';

  @override
  String get quick_titleNote => 'Catat Cepat';

  @override
  String get quick_whatSchedPh => 'Mau nambah jadwal apa?';

  @override
  String get quick_whatNotePh => 'Mau catat apa hari ini?';

  @override
  String get quick_subjLabel => 'Subjek';

  @override
  String get quick_subjPh => 'cth: Tugas Basis Data';

  @override
  String get quick_bodyPhMail => 'Tulis pesan…';

  @override
  String get quick_bodyRequired => 'Isi pesan wajib diisi';

  @override
  String get quick_endLabel => 'Selesai (opsional)';

  @override
  String get quick_noteBodyRequired =>
      'Isi wajib diisi agar tersimpan ke Drive';
}
