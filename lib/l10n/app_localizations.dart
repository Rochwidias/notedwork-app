import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @nav_home.
  ///
  /// In id, this message translates to:
  /// **'Hari Ini'**
  String get nav_home;

  /// No description provided for @nav_email.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get nav_email;

  /// No description provided for @nav_tasks.
  ///
  /// In id, this message translates to:
  /// **'Tugas'**
  String get nav_tasks;

  /// No description provided for @nav_calendar.
  ///
  /// In id, this message translates to:
  /// **'Kalender'**
  String get nav_calendar;

  /// No description provided for @nav_notes.
  ///
  /// In id, this message translates to:
  /// **'Catatan'**
  String get nav_notes;

  /// No description provided for @nav_settings.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get nav_settings;

  /// No description provided for @nav_menu.
  ///
  /// In id, this message translates to:
  /// **'MENU'**
  String get nav_menu;

  /// No description provided for @nav_addSection.
  ///
  /// In id, this message translates to:
  /// **'TAMBAH'**
  String get nav_addSection;

  /// No description provided for @nav_addNew.
  ///
  /// In id, this message translates to:
  /// **'Tambah Baru'**
  String get nav_addNew;

  /// No description provided for @nav_main.
  ///
  /// In id, this message translates to:
  /// **'Navigasi utama'**
  String get nav_main;

  /// No description provided for @tambah_title.
  ///
  /// In id, this message translates to:
  /// **'Tambah Baru'**
  String get tambah_title;

  /// No description provided for @tambah_hint.
  ///
  /// In id, this message translates to:
  /// **'Pilih yang mau dibuat.'**
  String get tambah_hint;

  /// No description provided for @tambah_mail.
  ///
  /// In id, this message translates to:
  /// **'Tulis Email'**
  String get tambah_mail;

  /// No description provided for @tambah_mailSub.
  ///
  /// In id, this message translates to:
  /// **'Terkirim via Gmail'**
  String get tambah_mailSub;

  /// No description provided for @tambah_task.
  ///
  /// In id, this message translates to:
  /// **'Tambah Tugas'**
  String get tambah_task;

  /// No description provided for @tambah_taskSub.
  ///
  /// In id, this message translates to:
  /// **'Deadline muncul di Kalender'**
  String get tambah_taskSub;

  /// No description provided for @tambah_sched.
  ///
  /// In id, this message translates to:
  /// **'Tambah Jadwal'**
  String get tambah_sched;

  /// No description provided for @tambah_schedSub.
  ///
  /// In id, this message translates to:
  /// **'Agenda sekali saja'**
  String get tambah_schedSub;

  /// No description provided for @tambah_note.
  ///
  /// In id, this message translates to:
  /// **'Tambah Catatan'**
  String get tambah_note;

  /// No description provided for @tambah_noteSub.
  ///
  /// In id, this message translates to:
  /// **'Ide cepat tersimpan lokal'**
  String get tambah_noteSub;

  /// No description provided for @tambah_mailNew.
  ///
  /// In id, this message translates to:
  /// **'Tulis email baru'**
  String get tambah_mailNew;

  /// No description provided for @tambah_taskNew.
  ///
  /// In id, this message translates to:
  /// **'Tambah tugas baru'**
  String get tambah_taskNew;

  /// No description provided for @tambah_schedNew.
  ///
  /// In id, this message translates to:
  /// **'Tambah jadwal baru'**
  String get tambah_schedNew;

  /// No description provided for @tambah_noteNew.
  ///
  /// In id, this message translates to:
  /// **'Tambah catatan baru'**
  String get tambah_noteNew;

  /// No description provided for @notes_title.
  ///
  /// In id, this message translates to:
  /// **'Catatan'**
  String get notes_title;

  /// No description provided for @notes_add.
  ///
  /// In id, this message translates to:
  /// **'Tambah'**
  String get notes_add;

  /// No description provided for @notes_empty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada catatan.'**
  String get notes_empty;

  /// No description provided for @notes_emptyHint.
  ///
  /// In id, this message translates to:
  /// **'Ketuk tombol + untuk menambah satu.'**
  String get notes_emptyHint;

  /// No description provided for @notes_edit.
  ///
  /// In id, this message translates to:
  /// **'Ubah'**
  String get notes_edit;

  /// No description provided for @notes_delete.
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get notes_delete;

  /// No description provided for @notes_settings.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get notes_settings;

  /// No description provided for @notes_sheetAdd.
  ///
  /// In id, this message translates to:
  /// **'Tambah Catatan'**
  String get notes_sheetAdd;

  /// No description provided for @notes_sheetEdit.
  ///
  /// In id, this message translates to:
  /// **'Ubah Catatan'**
  String get notes_sheetEdit;

  /// No description provided for @notes_fieldTitle.
  ///
  /// In id, this message translates to:
  /// **'Judul'**
  String get notes_fieldTitle;

  /// No description provided for @notes_fieldBody.
  ///
  /// In id, this message translates to:
  /// **'Isi'**
  String get notes_fieldBody;

  /// No description provided for @notes_titlePh.
  ///
  /// In id, this message translates to:
  /// **'cth: Ide cepat'**
  String get notes_titlePh;

  /// No description provided for @notes_bodyPh.
  ///
  /// In id, this message translates to:
  /// **'Tulis catatan…'**
  String get notes_bodyPh;

  /// No description provided for @notes_titleRequired.
  ///
  /// In id, this message translates to:
  /// **'Judul wajib diisi'**
  String get notes_titleRequired;

  /// No description provided for @notes_saving.
  ///
  /// In id, this message translates to:
  /// **'Menyimpan…'**
  String get notes_saving;

  /// No description provided for @notes_onDrive.
  ///
  /// In id, this message translates to:
  /// **'di Drive'**
  String get notes_onDrive;

  /// No description provided for @notes_saveChanges.
  ///
  /// In id, this message translates to:
  /// **'Simpan perubahan'**
  String get notes_saveChanges;

  /// No description provided for @topbar_langToEn.
  ///
  /// In id, this message translates to:
  /// **'Switch to English'**
  String get topbar_langToEn;

  /// No description provided for @topbar_langToId.
  ///
  /// In id, this message translates to:
  /// **'Ganti ke Bahasa Indonesia'**
  String get topbar_langToId;

  /// No description provided for @topbar_theme.
  ///
  /// In id, this message translates to:
  /// **'Ganti tema'**
  String get topbar_theme;

  /// No description provided for @topbar_themeToLight.
  ///
  /// In id, this message translates to:
  /// **'Mode terang'**
  String get topbar_themeToLight;

  /// No description provided for @topbar_themeToDark.
  ///
  /// In id, this message translates to:
  /// **'Mode gelap'**
  String get topbar_themeToDark;

  /// No description provided for @topbar_settings.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get topbar_settings;

  /// No description provided for @topbar_connect.
  ///
  /// In id, this message translates to:
  /// **'Koneksi Google'**
  String get topbar_connect;

  /// No description provided for @topbar_tagline.
  ///
  /// In id, this message translates to:
  /// **'Email & Jadwal mahasiswa'**
  String get topbar_tagline;

  /// No description provided for @common_save.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get common_save;

  /// No description provided for @common_close.
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get common_close;

  /// No description provided for @common_delete.
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get common_delete;

  /// No description provided for @common_cancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get common_cancel;

  /// No description provided for @common_edit.
  ///
  /// In id, this message translates to:
  /// **'Ubah'**
  String get common_edit;

  /// No description provided for @common_all.
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get common_all;

  /// No description provided for @common_markDone.
  ///
  /// In id, this message translates to:
  /// **'Tandai selesai'**
  String get common_markDone;

  /// No description provided for @common_tapToComplete.
  ///
  /// In id, this message translates to:
  /// **'. Ketuk untuk tandai selesai.'**
  String get common_tapToComplete;

  /// No description provided for @confirm_title.
  ///
  /// In id, this message translates to:
  /// **'Yakin hapus?'**
  String get confirm_title;

  /// No description provided for @confirm_desc.
  ///
  /// In id, this message translates to:
  /// **'“{title}” akan dihapus permanen dan tidak bisa dikembalikan.'**
  String confirm_desc(String title);

  /// No description provided for @home_title.
  ///
  /// In id, this message translates to:
  /// **'Hari Ini'**
  String get home_title;

  /// No description provided for @home_hello.
  ///
  /// In id, this message translates to:
  /// **'Halo'**
  String get home_hello;

  /// No description provided for @home_previewSuffix.
  ///
  /// In id, this message translates to:
  /// **' — Mode pratinjau (data contoh)'**
  String get home_previewSuffix;

  /// No description provided for @home_guestName.
  ///
  /// In id, this message translates to:
  /// **'di sana'**
  String get home_guestName;

  /// No description provided for @home_dueSoon.
  ///
  /// In id, this message translates to:
  /// **'Sebentar lagi'**
  String get home_dueSoon;

  /// No description provided for @home_inMin.
  ///
  /// In id, this message translates to:
  /// **'{n} mnt lagi'**
  String home_inMin(String n);

  /// No description provided for @home_inHours.
  ///
  /// In id, this message translates to:
  /// **'{h} jam {m} mnt lagi'**
  String home_inHours(String h, String m);

  /// No description provided for @home_inHoursEven.
  ///
  /// In id, this message translates to:
  /// **'{h} jam lagi'**
  String home_inHoursEven(String h);

  /// No description provided for @home_tomorrow.
  ///
  /// In id, this message translates to:
  /// **'Besok'**
  String get home_tomorrow;

  /// No description provided for @home_inDays.
  ///
  /// In id, this message translates to:
  /// **'{d} hari lagi'**
  String home_inDays(String d);

  /// No description provided for @home_room.
  ///
  /// In id, this message translates to:
  /// **'Ruang'**
  String get home_room;

  /// No description provided for @home_reminderPrefix.
  ///
  /// In id, this message translates to:
  /// **'Pengingat'**
  String get home_reminderPrefix;

  /// No description provided for @home_openCalendar.
  ///
  /// In id, this message translates to:
  /// **'Buka kalender'**
  String get home_openCalendar;

  /// No description provided for @home_reminderAriaNone.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada pengingat. Buka kalender.'**
  String get home_reminderAriaNone;

  /// No description provided for @home_viewCalendar.
  ///
  /// In id, this message translates to:
  /// **'Lihat kalender'**
  String get home_viewCalendar;

  /// No description provided for @home_noReminder.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada pengingat berikutnya'**
  String get home_noReminder;

  /// No description provided for @home_noReminderSub.
  ///
  /// In id, this message translates to:
  /// **'Belum ada agenda atau deadline. Nikmati harimu!'**
  String get home_noReminderSub;

  /// No description provided for @home_top3.
  ///
  /// In id, this message translates to:
  /// **'3 Terpenting'**
  String get home_top3;

  /// No description provided for @home_next7.
  ///
  /// In id, this message translates to:
  /// **'Agenda 7 hari ke depan'**
  String get home_next7;

  /// No description provided for @home_next7empty.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada agenda 7 hari ke depan.'**
  String get home_next7empty;

  /// No description provided for @home_nearTasks.
  ///
  /// In id, this message translates to:
  /// **'Tugas terdekat'**
  String get home_nearTasks;

  /// No description provided for @home_nearTasksEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada tugas. Nikmati harimu!'**
  String get home_nearTasksEmpty;

  /// No description provided for @home_allDone.
  ///
  /// In id, this message translates to:
  /// **'Semua tugas selesai. Nikmati harimu!'**
  String get home_allDone;

  /// No description provided for @home_thisWeek.
  ///
  /// In id, this message translates to:
  /// **'Minggu ini'**
  String get home_thisWeek;

  /// No description provided for @home_emailImportant.
  ///
  /// In id, this message translates to:
  /// **'Email penting'**
  String get home_emailImportant;

  /// No description provided for @home_openMail.
  ///
  /// In id, this message translates to:
  /// **'Buka email: '**
  String get home_openMail;

  /// No description provided for @home_inboxClear.
  ///
  /// In id, this message translates to:
  /// **'Kotak masuk beres. Tidak ada email penting.'**
  String get home_inboxClear;

  /// No description provided for @email_title.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get email_title;

  /// No description provided for @email_previewSub.
  ///
  /// In id, this message translates to:
  /// **'Mode pratinjau — data contoh. Bukan data aslimu.'**
  String get email_previewSub;

  /// No description provided for @email_liveBase.
  ///
  /// In id, this message translates to:
  /// **'Gmail & Kalender asli'**
  String get email_liveBase;

  /// No description provided for @email_updatedFrag.
  ///
  /// In id, this message translates to:
  /// **' • update '**
  String get email_updatedFrag;

  /// No description provided for @email_countSep.
  ///
  /// In id, this message translates to:
  /// **' • '**
  String get email_countSep;

  /// No description provided for @email_countUnit.
  ///
  /// In id, this message translates to:
  /// **' email'**
  String get email_countUnit;

  /// No description provided for @email_filterUnread.
  ///
  /// In id, this message translates to:
  /// **'Belum dibaca'**
  String get email_filterUnread;

  /// No description provided for @email_filterStar.
  ///
  /// In id, this message translates to:
  /// **'Bintang'**
  String get email_filterStar;

  /// No description provided for @email_showEmails.
  ///
  /// In id, this message translates to:
  /// **'Tampilkan email'**
  String get email_showEmails;

  /// No description provided for @email_searchPh.
  ///
  /// In id, this message translates to:
  /// **'Cari email…'**
  String get email_searchPh;

  /// No description provided for @email_searchLabel.
  ///
  /// In id, this message translates to:
  /// **'Cari email'**
  String get email_searchLabel;

  /// No description provided for @email_clearSearch.
  ///
  /// In id, this message translates to:
  /// **'Bersihkan pencarian'**
  String get email_clearSearch;

  /// No description provided for @email_typing.
  ///
  /// In id, this message translates to:
  /// **'Mengetik…'**
  String get email_typing;

  /// No description provided for @email_searching.
  ///
  /// In id, this message translates to:
  /// **'Mencari…'**
  String get email_searching;

  /// No description provided for @email_results.
  ///
  /// In id, this message translates to:
  /// **' hasil'**
  String get email_results;

  /// No description provided for @email_resultsFor.
  ///
  /// In id, this message translates to:
  /// **' untuk “'**
  String get email_resultsFor;

  /// No description provided for @email_loading.
  ///
  /// In id, this message translates to:
  /// **'Memuat email'**
  String get email_loading;

  /// No description provided for @email_unreadSuffix.
  ///
  /// In id, this message translates to:
  /// **', belum dibaca'**
  String get email_unreadSuffix;

  /// No description provided for @email_starTitle.
  ///
  /// In id, this message translates to:
  /// **'Bintang'**
  String get email_starTitle;

  /// No description provided for @email_unstar.
  ///
  /// In id, this message translates to:
  /// **'Hapus bintang'**
  String get email_unstar;

  /// No description provided for @email_giveStar.
  ///
  /// In id, this message translates to:
  /// **'Beri bintang'**
  String get email_giveStar;

  /// No description provided for @email_noTag.
  ///
  /// In id, this message translates to:
  /// **'Tanpa label'**
  String get email_noTag;

  /// No description provided for @email_noResults.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada hasil. Coba kata kunci atau filter lain.'**
  String get email_noResults;

  /// No description provided for @email_emptyHere.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada email di sini.'**
  String get email_emptyHere;

  /// No description provided for @email_loadingMore.
  ///
  /// In id, this message translates to:
  /// **'Memuat…'**
  String get email_loadingMore;

  /// No description provided for @email_loadMore.
  ///
  /// In id, this message translates to:
  /// **'Muat lagi (50 berikutnya)'**
  String get email_loadMore;

  /// No description provided for @email_backToList.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke daftar'**
  String get email_backToList;

  /// No description provided for @email_backToListAria.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke daftar email'**
  String get email_backToListAria;

  /// No description provided for @email_badgeNew.
  ///
  /// In id, this message translates to:
  /// **'Baru'**
  String get email_badgeNew;

  /// No description provided for @email_attach.
  ///
  /// In id, this message translates to:
  /// **'LAMPIRAN ('**
  String get email_attach;

  /// No description provided for @email_reply.
  ///
  /// In id, this message translates to:
  /// **'Balas'**
  String get email_reply;

  /// No description provided for @email_forward.
  ///
  /// In id, this message translates to:
  /// **'Teruskan'**
  String get email_forward;

  /// No description provided for @email_moreActions.
  ///
  /// In id, this message translates to:
  /// **'Aksi email lainnya'**
  String get email_moreActions;

  /// No description provided for @email_more.
  ///
  /// In id, this message translates to:
  /// **'Lainnya'**
  String get email_more;

  /// No description provided for @email_archive.
  ///
  /// In id, this message translates to:
  /// **'Arsipkan'**
  String get email_archive;

  /// No description provided for @email_markUnread.
  ///
  /// In id, this message translates to:
  /// **'Tandai belum dibaca'**
  String get email_markUnread;

  /// No description provided for @tasks_title.
  ///
  /// In id, this message translates to:
  /// **'Tugas'**
  String get tasks_title;

  /// No description provided for @tasks_previewSub.
  ///
  /// In id, this message translates to:
  /// **'Mode pratinjau — data contoh, tersimpan lokal di perangkatmu'**
  String get tasks_previewSub;

  /// No description provided for @tasks_liveSub.
  ///
  /// In id, this message translates to:
  /// **'Gmail & Kalender asli — deadline ikut muncul di Kalender & Dashboard'**
  String get tasks_liveSub;

  /// No description provided for @tasks_filterActive.
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get tasks_filterActive;

  /// No description provided for @tasks_filterOverdue.
  ///
  /// In id, this message translates to:
  /// **'Telat'**
  String get tasks_filterOverdue;

  /// No description provided for @tasks_filterDone.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get tasks_filterDone;

  /// No description provided for @tasks_stateDone.
  ///
  /// In id, this message translates to:
  /// **'selesai'**
  String get tasks_stateDone;

  /// No description provided for @tasks_stateActive.
  ///
  /// In id, this message translates to:
  /// **'aktif'**
  String get tasks_stateActive;

  /// No description provided for @tasks_tapToToggle.
  ///
  /// In id, this message translates to:
  /// **'. Ketuk untuk ubah status.'**
  String get tasks_tapToToggle;

  /// No description provided for @tasks_reopen.
  ///
  /// In id, this message translates to:
  /// **'Buka lagi'**
  String get tasks_reopen;

  /// No description provided for @tasks_emptyHere.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada tugas di sini.'**
  String get tasks_emptyHere;

  /// No description provided for @tasks_addTask.
  ///
  /// In id, this message translates to:
  /// **'Tambah tugas'**
  String get tasks_addTask;

  /// No description provided for @cal_previewSub.
  ///
  /// In id, this message translates to:
  /// **'Mode pratinjau — data contoh. Bukan data aslimu.'**
  String get cal_previewSub;

  /// No description provided for @cal_liveSub.
  ///
  /// In id, this message translates to:
  /// **'Gmail & Kalender asli — ketuk tanggal untuk melihat agenda'**
  String get cal_liveSub;

  /// No description provided for @cal_prevMonth.
  ///
  /// In id, this message translates to:
  /// **'Bulan sebelumnya'**
  String get cal_prevMonth;

  /// No description provided for @cal_nextMonth.
  ///
  /// In id, this message translates to:
  /// **'Bulan berikutnya'**
  String get cal_nextMonth;

  /// No description provided for @cal_routine.
  ///
  /// In id, this message translates to:
  /// **'Rutin'**
  String get cal_routine;

  /// No description provided for @cal_agenda.
  ///
  /// In id, this message translates to:
  /// **'Agenda'**
  String get cal_agenda;

  /// No description provided for @cal_deadline.
  ///
  /// In id, this message translates to:
  /// **'Deadline'**
  String get cal_deadline;

  /// No description provided for @cal_today.
  ///
  /// In id, this message translates to:
  /// **'Hari ini'**
  String get cal_today;

  /// No description provided for @cal_backToday.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke hari ini'**
  String get cal_backToday;

  /// No description provided for @cal_room.
  ///
  /// In id, this message translates to:
  /// **'Ruang'**
  String get cal_room;

  /// No description provided for @cal_deadlineAt.
  ///
  /// In id, this message translates to:
  /// **' • deadline '**
  String get cal_deadlineAt;

  /// No description provided for @cal_emptyDate.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada agenda di tanggal ini.'**
  String get cal_emptyDate;

  /// No description provided for @cal_upcoming7.
  ///
  /// In id, this message translates to:
  /// **'Agenda terdekat 7 hari ke depan:'**
  String get cal_upcoming7;

  /// No description provided for @cal_enjoyDay.
  ///
  /// In id, this message translates to:
  /// **'Nikmati harimu!'**
  String get cal_enjoyDay;

  /// No description provided for @cal_addSched.
  ///
  /// In id, this message translates to:
  /// **'Tambah Jadwal'**
  String get cal_addSched;

  /// No description provided for @cal_weeklyRoutine.
  ///
  /// In id, this message translates to:
  /// **'Jadwal rutin mingguan'**
  String get cal_weeklyRoutine;

  /// No description provided for @cal_noRoutine.
  ///
  /// In id, this message translates to:
  /// **'Belum ada jadwal rutin.'**
  String get cal_noRoutine;

  /// No description provided for @cal_manageRoutine.
  ///
  /// In id, this message translates to:
  /// **'Kelola jadwal rutin'**
  String get cal_manageRoutine;

  /// No description provided for @common_optional.
  ///
  /// In id, this message translates to:
  /// **'(opsional)'**
  String get common_optional;

  /// No description provided for @reminder_title.
  ///
  /// In id, this message translates to:
  /// **'Pengingat'**
  String get reminder_title;

  /// No description provided for @reminder_off.
  ///
  /// In id, this message translates to:
  /// **'Mati'**
  String get reminder_off;

  /// No description provided for @reminder_min.
  ///
  /// In id, this message translates to:
  /// **' mnt'**
  String get reminder_min;

  /// No description provided for @reminder_hour.
  ///
  /// In id, this message translates to:
  /// **' jam'**
  String get reminder_hour;

  /// No description provided for @reminder_hours.
  ///
  /// In id, this message translates to:
  /// **' jam'**
  String get reminder_hours;

  /// No description provided for @reminder_day.
  ///
  /// In id, this message translates to:
  /// **' hari'**
  String get reminder_day;

  /// No description provided for @sched_editTitle.
  ///
  /// In id, this message translates to:
  /// **'Ubah Jadwal'**
  String get sched_editTitle;

  /// No description provided for @sched_addTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Jadwal'**
  String get sched_addTitle;

  /// No description provided for @sched_hint.
  ///
  /// In id, this message translates to:
  /// **'Agenda sekali saja. Untuk matkul tiap minggu, pakai jadwal rutin.'**
  String get sched_hint;

  /// No description provided for @sched_titleRequired.
  ///
  /// In id, this message translates to:
  /// **'Isi judul dulu — cth: Seminar proposal'**
  String get sched_titleRequired;

  /// No description provided for @sched_endInvalid.
  ///
  /// In id, this message translates to:
  /// **'Format jam selesai tidak valid — kosongkan bila sekilas'**
  String get sched_endInvalid;

  /// No description provided for @sched_fieldTitle.
  ///
  /// In id, this message translates to:
  /// **'Judul'**
  String get sched_fieldTitle;

  /// No description provided for @sched_titlePh.
  ///
  /// In id, this message translates to:
  /// **'cth: Seminar proposal'**
  String get sched_titlePh;

  /// No description provided for @sched_fieldDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal'**
  String get sched_fieldDate;

  /// No description provided for @sched_startLabel.
  ///
  /// In id, this message translates to:
  /// **'Jam mulai '**
  String get sched_startLabel;

  /// No description provided for @sched_endLabel.
  ///
  /// In id, this message translates to:
  /// **'Jam selesai '**
  String get sched_endLabel;

  /// No description provided for @sched_endHint.
  ///
  /// In id, this message translates to:
  /// **'Dikosongkan = sekilas (pakai jam mulai saja). Diisi = tampil rentang 09.00–10.40. Jam selesai lebih kecil = lewat tengah malam (besok).'**
  String get sched_endHint;

  /// No description provided for @sched_fieldNote.
  ///
  /// In id, this message translates to:
  /// **'Keterangan'**
  String get sched_fieldNote;

  /// No description provided for @sched_notePh.
  ///
  /// In id, this message translates to:
  /// **'Ruang, dosen, link meeting…'**
  String get sched_notePh;

  /// No description provided for @sched_saving.
  ///
  /// In id, this message translates to:
  /// **'Menyimpan…'**
  String get sched_saving;

  /// No description provided for @sched_saveChanges.
  ///
  /// In id, this message translates to:
  /// **'Simpan perubahan'**
  String get sched_saveChanges;

  /// No description provided for @task_editTitle.
  ///
  /// In id, this message translates to:
  /// **'Ubah Tugas'**
  String get task_editTitle;

  /// No description provided for @task_addTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Tugas'**
  String get task_addTitle;

  /// No description provided for @task_hint.
  ///
  /// In id, this message translates to:
  /// **'Deadline otomatis muncul di Kalender & Dashboard.'**
  String get task_hint;

  /// No description provided for @task_titleRequired.
  ///
  /// In id, this message translates to:
  /// **'Isi judul tugas dulu — cth: Laporan modul 6'**
  String get task_titleRequired;

  /// No description provided for @task_fieldCourse.
  ///
  /// In id, this message translates to:
  /// **'Mata kuliah'**
  String get task_fieldCourse;

  /// No description provided for @task_coursePh.
  ///
  /// In id, this message translates to:
  /// **'cth: Basis Data'**
  String get task_coursePh;

  /// No description provided for @task_fieldTitle.
  ///
  /// In id, this message translates to:
  /// **'Judul tugas'**
  String get task_fieldTitle;

  /// No description provided for @task_titlePh.
  ///
  /// In id, this message translates to:
  /// **'cth: Laporan modul 6'**
  String get task_titlePh;

  /// No description provided for @task_fieldDate.
  ///
  /// In id, this message translates to:
  /// **'Deadline tanggal'**
  String get task_fieldDate;

  /// No description provided for @task_fieldTime.
  ///
  /// In id, this message translates to:
  /// **'Jam '**
  String get task_fieldTime;

  /// No description provided for @task_timeHint.
  ///
  /// In id, this message translates to:
  /// **'Dikosongkan = akhir hari 23.59.'**
  String get task_timeHint;

  /// No description provided for @task_fieldPrio.
  ///
  /// In id, this message translates to:
  /// **'Prioritas'**
  String get task_fieldPrio;

  /// No description provided for @task_fieldNote.
  ///
  /// In id, this message translates to:
  /// **'Catatan'**
  String get task_fieldNote;

  /// No description provided for @task_notePh.
  ///
  /// In id, this message translates to:
  /// **'Cara kumpul, link, dsb…'**
  String get task_notePh;

  /// No description provided for @task_saving.
  ///
  /// In id, this message translates to:
  /// **'Menyimpan…'**
  String get task_saving;

  /// No description provided for @task_saveChanges.
  ///
  /// In id, this message translates to:
  /// **'Simpan perubahan'**
  String get task_saveChanges;

  /// No description provided for @mail_replyTitle.
  ///
  /// In id, this message translates to:
  /// **'Balas Email'**
  String get mail_replyTitle;

  /// No description provided for @mail_fwdTitle.
  ///
  /// In id, this message translates to:
  /// **'Teruskan Email'**
  String get mail_fwdTitle;

  /// No description provided for @mail_composeTitle.
  ///
  /// In id, this message translates to:
  /// **'Tulis Email'**
  String get mail_composeTitle;

  /// No description provided for @mail_hint.
  ///
  /// In id, this message translates to:
  /// **'Terkirim langsung via Gmail.'**
  String get mail_hint;

  /// No description provided for @mail_toInvalid.
  ///
  /// In id, this message translates to:
  /// **'Format email tujuan tidak valid'**
  String get mail_toInvalid;

  /// No description provided for @mail_fieldTo.
  ///
  /// In id, this message translates to:
  /// **'Kepada'**
  String get mail_fieldTo;

  /// No description provided for @mail_toPh.
  ///
  /// In id, this message translates to:
  /// **'dosen@univ.ac.id'**
  String get mail_toPh;

  /// No description provided for @mail_fieldSubj.
  ///
  /// In id, this message translates to:
  /// **'Subjek '**
  String get mail_fieldSubj;

  /// No description provided for @mail_subjPh.
  ///
  /// In id, this message translates to:
  /// **'Izin / konsultasi / tugas…'**
  String get mail_subjPh;

  /// No description provided for @mail_fieldBody.
  ///
  /// In id, this message translates to:
  /// **'Isi'**
  String get mail_fieldBody;

  /// No description provided for @mail_bodyPh.
  ///
  /// In id, this message translates to:
  /// **'Tulis pesan…'**
  String get mail_bodyPh;

  /// No description provided for @mail_sending.
  ///
  /// In id, this message translates to:
  /// **'Mengirim…'**
  String get mail_sending;

  /// No description provided for @mail_send.
  ///
  /// In id, this message translates to:
  /// **'Kirim'**
  String get mail_send;

  /// No description provided for @routine_title.
  ///
  /// In id, this message translates to:
  /// **'Kelola Jadwal Rutin'**
  String get routine_title;

  /// No description provided for @routine_hint.
  ///
  /// In id, this message translates to:
  /// **'Matkul tetap tiap minggu — otomatis muncul di Kalender.'**
  String get routine_hint;

  /// No description provided for @routine_fieldCourse.
  ///
  /// In id, this message translates to:
  /// **'Mata kuliah'**
  String get routine_fieldCourse;

  /// No description provided for @routine_coursePh.
  ///
  /// In id, this message translates to:
  /// **'cth: Sistem Operasi'**
  String get routine_coursePh;

  /// No description provided for @routine_fieldDay.
  ///
  /// In id, this message translates to:
  /// **'Hari'**
  String get routine_fieldDay;

  /// No description provided for @routine_fieldRoom.
  ///
  /// In id, this message translates to:
  /// **'Ruang'**
  String get routine_fieldRoom;

  /// No description provided for @routine_roomPh.
  ///
  /// In id, this message translates to:
  /// **'cth: 2A'**
  String get routine_roomPh;

  /// No description provided for @routine_fieldStart.
  ///
  /// In id, this message translates to:
  /// **'Mulai'**
  String get routine_fieldStart;

  /// No description provided for @routine_fieldEnd.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get routine_fieldEnd;

  /// No description provided for @routine_fieldLect.
  ///
  /// In id, this message translates to:
  /// **'Dosen'**
  String get routine_fieldLect;

  /// No description provided for @routine_lectPh.
  ///
  /// In id, this message translates to:
  /// **'cth: Pak Andi'**
  String get routine_lectPh;

  /// No description provided for @routine_adding.
  ///
  /// In id, this message translates to:
  /// **'Menambah…'**
  String get routine_adding;

  /// No description provided for @routine_add.
  ///
  /// In id, this message translates to:
  /// **'Tambah'**
  String get routine_add;

  /// No description provided for @routine_mineTitle.
  ///
  /// In id, this message translates to:
  /// **'Jadwal buatanmu ('**
  String get routine_mineTitle;

  /// No description provided for @routine_emptyMine.
  ///
  /// In id, this message translates to:
  /// **'Belum ada — tambah lewat form di atas.'**
  String get routine_emptyMine;

  /// No description provided for @settings_title.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settings_title;

  /// No description provided for @settings_accountOn.
  ///
  /// In id, this message translates to:
  /// **'Akun Google yang tersambung'**
  String get settings_accountOn;

  /// No description provided for @settings_previewMode.
  ///
  /// In id, this message translates to:
  /// **'Mode pratinjau — data contoh'**
  String get settings_previewMode;

  /// No description provided for @settings_account.
  ///
  /// In id, this message translates to:
  /// **'Akun'**
  String get settings_account;

  /// No description provided for @settings_loggedSub.
  ///
  /// In id, this message translates to:
  /// **'Login via Google'**
  String get settings_loggedSub;

  /// No description provided for @settings_guestMode.
  ///
  /// In id, this message translates to:
  /// **'Mode tamu'**
  String get settings_guestMode;

  /// No description provided for @settings_guestSub.
  ///
  /// In id, this message translates to:
  /// **'Pratinjau dengan data contoh'**
  String get settings_guestSub;

  /// No description provided for @settings_displayName.
  ///
  /// In id, this message translates to:
  /// **'Nama tampilan'**
  String get settings_displayName;

  /// No description provided for @settings_namePh.
  ///
  /// In id, this message translates to:
  /// **'cth: Budi'**
  String get settings_namePh;

  /// No description provided for @settings_logout.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get settings_logout;

  /// No description provided for @settings_connectGoogle.
  ///
  /// In id, this message translates to:
  /// **'Hubungkan Google'**
  String get settings_connectGoogle;

  /// No description provided for @settings_exitPreview.
  ///
  /// In id, this message translates to:
  /// **'Keluar dari pratinjau (hapus data tamu)'**
  String get settings_exitPreview;

  /// No description provided for @settings_themeGallery.
  ///
  /// In id, this message translates to:
  /// **'Galeri Tema'**
  String get settings_themeGallery;

  /// No description provided for @settings_appearance.
  ///
  /// In id, this message translates to:
  /// **'Tampilan'**
  String get settings_appearance;

  /// No description provided for @settings_appearanceSub.
  ///
  /// In id, this message translates to:
  /// **'Terang, gelap, atau ikut sistem'**
  String get settings_appearanceSub;

  /// No description provided for @settings_light.
  ///
  /// In id, this message translates to:
  /// **'Terang'**
  String get settings_light;

  /// No description provided for @settings_dark.
  ///
  /// In id, this message translates to:
  /// **'Gelap'**
  String get settings_dark;

  /// No description provided for @settings_auto.
  ///
  /// In id, this message translates to:
  /// **'Otomatis'**
  String get settings_auto;

  /// No description provided for @settings_modeGroup.
  ///
  /// In id, this message translates to:
  /// **'Mode tampilan'**
  String get settings_modeGroup;

  /// No description provided for @settings_accentColor.
  ///
  /// In id, this message translates to:
  /// **'Warna tampilan'**
  String get settings_accentColor;

  /// No description provided for @settings_accentSub.
  ///
  /// In id, this message translates to:
  /// **'Aksen tombol, badge & logo — pilihanmu, tersimpan di perangkat'**
  String get settings_accentSub;

  /// No description provided for @settings_colorOf.
  ///
  /// In id, this message translates to:
  /// **'Warna '**
  String get settings_colorOf;

  /// No description provided for @settings_customColor.
  ///
  /// In id, this message translates to:
  /// **'Warna custom'**
  String get settings_customColor;

  /// No description provided for @settings_reset.
  ///
  /// In id, this message translates to:
  /// **'Reset'**
  String get settings_reset;

  /// No description provided for @settings_fontColor.
  ///
  /// In id, this message translates to:
  /// **'Warna font'**
  String get settings_fontColor;

  /// No description provided for @settings_fontColorSub.
  ///
  /// In id, this message translates to:
  /// **'Warna teks aplikasi — pilihanmu, tersimpan di perangkat'**
  String get settings_fontColorSub;

  /// No description provided for @settings_bgColor.
  ///
  /// In id, this message translates to:
  /// **'Warna latar'**
  String get settings_bgColor;

  /// No description provided for @settings_bgColorSub.
  ///
  /// In id, this message translates to:
  /// **'Warna latar aplikasi — pilihanmu, tersimpan di perangkat'**
  String get settings_bgColorSub;

  /// No description provided for @settings_forMode.
  ///
  /// In id, this message translates to:
  /// **'mode {mode}'**
  String settings_forMode(String mode);

  /// No description provided for @settings_testNotif.
  ///
  /// In id, this message translates to:
  /// **'Tes'**
  String get settings_testNotif;

  /// No description provided for @settings_testNotifSample.
  ///
  /// In id, this message translates to:
  /// **'Presentasi PBO — 10 menit lagi'**
  String get settings_testNotifSample;

  /// No description provided for @settings_reminderTitle.
  ///
  /// In id, this message translates to:
  /// **'Pengingat jadwal'**
  String get settings_reminderTitle;

  /// No description provided for @settings_reminderSub.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi pengingat dari aplikasi'**
  String get settings_reminderSub;

  /// No description provided for @settings_connTitle.
  ///
  /// In id, this message translates to:
  /// **'Koneksi Google'**
  String get settings_connTitle;

  /// No description provided for @settings_connLive.
  ///
  /// In id, this message translates to:
  /// **'Tersambung sebagai {email}'**
  String settings_connLive(String email);

  /// No description provided for @settings_connNone.
  ///
  /// In id, this message translates to:
  /// **'Belum tersambung'**
  String get settings_connNone;

  /// No description provided for @settings_loginGoogle.
  ///
  /// In id, this message translates to:
  /// **'Login dengan Google'**
  String get settings_loginGoogle;

  /// No description provided for @settings_info.
  ///
  /// In id, this message translates to:
  /// **'Info'**
  String get settings_info;

  /// No description provided for @settings_credit.
  ///
  /// In id, this message translates to:
  /// **'Kredit'**
  String get settings_credit;

  /// No description provided for @settings_creditSub.
  ///
  /// In id, this message translates to:
  /// **'Pembuat & teknologi notedwork'**
  String get settings_creditSub;

  /// No description provided for @settings_privacy.
  ///
  /// In id, this message translates to:
  /// **'Privasi'**
  String get settings_privacy;

  /// No description provided for @settings_privacySub.
  ///
  /// In id, this message translates to:
  /// **'Data apa yang disimpan & di mana'**
  String get settings_privacySub;

  /// No description provided for @settings_terms.
  ///
  /// In id, this message translates to:
  /// **'Syarat'**
  String get settings_terms;

  /// No description provided for @settings_termsSub.
  ///
  /// In id, this message translates to:
  /// **'Aturan pakai aplikasi ini'**
  String get settings_termsSub;

  /// No description provided for @settings_installApp.
  ///
  /// In id, this message translates to:
  /// **'Pasang aplikasi'**
  String get settings_installApp;

  /// No description provided for @settings_installAppSub.
  ///
  /// In id, this message translates to:
  /// **'Buka notedwork dari layar utama HP'**
  String get settings_installAppSub;

  /// No description provided for @settings_open.
  ///
  /// In id, this message translates to:
  /// **'Buka'**
  String get settings_open;

  /// No description provided for @settings_about.
  ///
  /// In id, this message translates to:
  /// **'Tentang'**
  String get settings_about;

  /// No description provided for @settings_aboutBody1.
  ///
  /// In id, this message translates to:
  /// **'notedwork — email, tugas & kalender untuk mahasiswa.'**
  String get settings_aboutBody1;

  /// No description provided for @settings_aboutBody2.
  ///
  /// In id, this message translates to:
  /// **'Bisa dipasang ke layar utama HP.'**
  String get settings_aboutBody2;

  /// No description provided for @settings_copyright.
  ///
  /// In id, this message translates to:
  /// **'© 2026 Rochwidias. Hak cipta dilindungi.'**
  String get settings_copyright;

  /// No description provided for @toast_syncFail.
  ///
  /// In id, this message translates to:
  /// **'Gagal sync Google'**
  String get toast_syncFail;

  /// No description provided for @toast_loginTokenFail.
  ///
  /// In id, this message translates to:
  /// **'Login Google gagal saat simpan token — coba lagi'**
  String get toast_loginTokenFail;

  /// No description provided for @toast_loginSessionFail.
  ///
  /// In id, this message translates to:
  /// **'Login Google gagal saat buat sesi — coba lagi'**
  String get toast_loginSessionFail;

  /// No description provided for @toast_loginExpired.
  ///
  /// In id, this message translates to:
  /// **'Login Google kedaluwarsa — coba lagi'**
  String get toast_loginExpired;

  /// No description provided for @toast_loginCancelled.
  ///
  /// In id, this message translates to:
  /// **'Login Google dibatalkan'**
  String get toast_loginCancelled;

  /// No description provided for @toast_loginFail.
  ///
  /// In id, this message translates to:
  /// **'Login Google gagal, coba lagi'**
  String get toast_loginFail;

  /// No description provided for @toast_connected.
  ///
  /// In id, this message translates to:
  /// **'Terhubung ke Google'**
  String get toast_connected;

  /// No description provided for @toast_mailBodyFail.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat isi email'**
  String get toast_mailBodyFail;

  /// No description provided for @toast_starFail.
  ///
  /// In id, this message translates to:
  /// **'Gagal ubah bintang'**
  String get toast_starFail;

  /// No description provided for @toast_archived.
  ///
  /// In id, this message translates to:
  /// **'Diarsipkan'**
  String get toast_archived;

  /// No description provided for @toast_markedUnread.
  ///
  /// In id, this message translates to:
  /// **'Ditandai belum dibaca'**
  String get toast_markedUnread;

  /// No description provided for @toast_gmailFail.
  ///
  /// In id, this message translates to:
  /// **'Aksi Gmail gagal'**
  String get toast_gmailFail;

  /// No description provided for @toast_taskReopened.
  ///
  /// In id, this message translates to:
  /// **'Dibuka lagi'**
  String get toast_taskReopened;

  /// No description provided for @toast_taskDone.
  ///
  /// In id, this message translates to:
  /// **'Tugas selesai!'**
  String get toast_taskDone;

  /// No description provided for @toast_taskDeleted.
  ///
  /// In id, this message translates to:
  /// **'Tugas dihapus'**
  String get toast_taskDeleted;

  /// No description provided for @toast_taskMissing.
  ///
  /// In id, this message translates to:
  /// **'Tugas tidak ditemukan'**
  String get toast_taskMissing;

  /// No description provided for @toast_schedDeleted.
  ///
  /// In id, this message translates to:
  /// **'Jadwal dihapus'**
  String get toast_schedDeleted;

  /// No description provided for @toast_gcalDeleted.
  ///
  /// In id, this message translates to:
  /// **'Event Google dihapus'**
  String get toast_gcalDeleted;

  /// No description provided for @toast_schedDeleteFail.
  ///
  /// In id, this message translates to:
  /// **'Gagal hapus event'**
  String get toast_schedDeleteFail;

  /// No description provided for @toast_schedSaved.
  ///
  /// In id, this message translates to:
  /// **'Jadwal tersimpan'**
  String get toast_schedSaved;

  /// No description provided for @toast_schedSavedGcal.
  ///
  /// In id, this message translates to:
  /// **'Jadwal tersimpan ke Google Calendar'**
  String get toast_schedSavedGcal;

  /// No description provided for @toast_schedSaveFail.
  ///
  /// In id, this message translates to:
  /// **'Gagal simpan ke Google'**
  String get toast_schedSaveFail;

  /// No description provided for @toast_schedMissing.
  ///
  /// In id, this message translates to:
  /// **'Jadwal tidak ditemukan'**
  String get toast_schedMissing;

  /// No description provided for @toast_schedUpdated.
  ///
  /// In id, this message translates to:
  /// **'Jadwal diperbarui'**
  String get toast_schedUpdated;

  /// No description provided for @toast_schedUpdatedGcal.
  ///
  /// In id, this message translates to:
  /// **'Jadwal diperbarui di Google Calendar'**
  String get toast_schedUpdatedGcal;

  /// No description provided for @toast_updateFailPrefix.
  ///
  /// In id, this message translates to:
  /// **'Gagal ubah: '**
  String get toast_updateFailPrefix;

  /// No description provided for @toast_previewLoginHint.
  ///
  /// In id, this message translates to:
  /// **'Login dengan Google untuk memakai data aslimu'**
  String get toast_previewLoginHint;

  /// No description provided for @toast_mailSent.
  ///
  /// In id, this message translates to:
  /// **'Email terkirim via Gmail'**
  String get toast_mailSent;

  /// No description provided for @toast_sendFailPrefix.
  ///
  /// In id, this message translates to:
  /// **'Gagal kirim: '**
  String get toast_sendFailPrefix;

  /// No description provided for @toast_loggedOut.
  ///
  /// In id, this message translates to:
  /// **'Keluar dari Google'**
  String get toast_loggedOut;

  /// No description provided for @toast_loggedOutLocal.
  ///
  /// In id, this message translates to:
  /// **'Keluar lokal; sesi server mungkin masih aktif — coba lagi'**
  String get toast_loggedOutLocal;

  /// No description provided for @toast_exitPreview.
  ///
  /// In id, this message translates to:
  /// **'Keluar dari mode pratinjau'**
  String get toast_exitPreview;

  /// No description provided for @toast_exitPreviewConfirm.
  ///
  /// In id, this message translates to:
  /// **'Keluar dari pratinjau? Data tamu (tugas, rutin, jadwal contoh) akan dihapus dan dikembalikan ke contoh awal.'**
  String get toast_exitPreviewConfirm;

  /// No description provided for @toast_routineDeleted.
  ///
  /// In id, this message translates to:
  /// **'Jadwal rutin dihapus'**
  String get toast_routineDeleted;

  /// No description provided for @toast_noteDeleted.
  ///
  /// In id, this message translates to:
  /// **'Catatan dihapus'**
  String get toast_noteDeleted;

  /// No description provided for @toast_driveSyncFail.
  ///
  /// In id, this message translates to:
  /// **'Gagal sync ke Drive, tersimpan lokal'**
  String get toast_driveSyncFail;

  /// No description provided for @toast_reminderPrefix.
  ///
  /// In id, this message translates to:
  /// **'Pengingat: '**
  String get toast_reminderPrefix;

  /// No description provided for @toast_notifOff.
  ///
  /// In id, this message translates to:
  /// **'Pengingat dimatikan'**
  String get toast_notifOff;

  /// No description provided for @toast_notifOn.
  ///
  /// In id, this message translates to:
  /// **'Pengingat dinyalakan'**
  String get toast_notifOn;

  /// No description provided for @toast_taskUpdated.
  ///
  /// In id, this message translates to:
  /// **'Tugas diperbarui'**
  String get toast_taskUpdated;

  /// No description provided for @toast_taskSaved.
  ///
  /// In id, this message translates to:
  /// **'Tugas tersimpan'**
  String get toast_taskSaved;

  /// No description provided for @toast_routineSaved.
  ///
  /// In id, this message translates to:
  /// **'Jadwal rutin tersimpan'**
  String get toast_routineSaved;

  /// No description provided for @banner_previewTitle.
  ///
  /// In id, this message translates to:
  /// **'Mode pratinjau — data contoh'**
  String get banner_previewTitle;

  /// No description provided for @banner_previewSub.
  ///
  /// In id, this message translates to:
  /// **'Bukan data aslimu. Login untuk Gmail & Kalender asli.'**
  String get banner_previewSub;

  /// No description provided for @banner_login.
  ///
  /// In id, this message translates to:
  /// **'Login dengan Google'**
  String get banner_login;

  /// No description provided for @install_entryTitle.
  ///
  /// In id, this message translates to:
  /// **'Pasang notedwork di HP'**
  String get install_entryTitle;

  /// No description provided for @install_entrySub.
  ///
  /// In id, this message translates to:
  /// **'Buka sekali ketuk, tanpa cari di browser.'**
  String get install_entrySub;

  /// No description provided for @install_entryBtn.
  ///
  /// In id, this message translates to:
  /// **'Pasang'**
  String get install_entryBtn;

  /// No description provided for @install_title.
  ///
  /// In id, this message translates to:
  /// **'Pasang notedwork'**
  String get install_title;

  /// No description provided for @install_sub.
  ///
  /// In id, this message translates to:
  /// **'Buka sekali ketuk dari layar utama — tanpa buka browser & login ulang.'**
  String get install_sub;

  /// No description provided for @install_tabAndroid.
  ///
  /// In id, this message translates to:
  /// **'Android'**
  String get install_tabAndroid;

  /// No description provided for @install_tabIphone.
  ///
  /// In id, this message translates to:
  /// **'iPhone'**
  String get install_tabIphone;

  /// No description provided for @install_tabLaptop.
  ///
  /// In id, this message translates to:
  /// **'Laptop'**
  String get install_tabLaptop;

  /// No description provided for @install_nativeBtn.
  ///
  /// In id, this message translates to:
  /// **'Pasang Sekarang'**
  String get install_nativeBtn;

  /// No description provided for @install_never.
  ///
  /// In id, this message translates to:
  /// **'Jangan tampilkan lagi'**
  String get install_never;

  /// No description provided for @install_dismissedToast.
  ///
  /// In id, this message translates to:
  /// **'Siap — kartu install tidak akan ditampilkan lagi'**
  String get install_dismissedToast;

  /// No description provided for @install_installedToast.
  ///
  /// In id, this message translates to:
  /// **'notedwork terpasang — selamat!'**
  String get install_installedToast;

  /// No description provided for @install_android1.
  ///
  /// In id, this message translates to:
  /// **'Ketuk tombol Pasang Sekarang di bawah (Chrome).'**
  String get install_android1;

  /// No description provided for @install_android2.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi “Pasang” pada dialog yang muncul.'**
  String get install_android2;

  /// No description provided for @install_android3.
  ///
  /// In id, this message translates to:
  /// **'Ikon notedwork muncul di layar utama & laci aplikasi.'**
  String get install_android3;

  /// No description provided for @install_iphone1.
  ///
  /// In id, this message translates to:
  /// **'Ketuk tombol Bagikan di Safari.'**
  String get install_iphone1;

  /// No description provided for @install_iphone2.
  ///
  /// In id, this message translates to:
  /// **'Pilih “Tambahkan ke Layar Utama”.'**
  String get install_iphone2;

  /// No description provided for @install_iphone3.
  ///
  /// In id, this message translates to:
  /// **'Ketuk “Tambah” — ikon notedwork muncul di layar utama.'**
  String get install_iphone3;

  /// No description provided for @install_laptop1.
  ///
  /// In id, this message translates to:
  /// **'Klik ikon Pasang di address bar Chrome/Edge.'**
  String get install_laptop1;

  /// No description provided for @install_laptop2.
  ///
  /// In id, this message translates to:
  /// **'Atau menu ⋮ → “Pasang notedwork…”.'**
  String get install_laptop2;

  /// No description provided for @install_laptop3.
  ///
  /// In id, this message translates to:
  /// **'Klik “Pasang” — app terbuka di jendela sendiri.'**
  String get install_laptop3;

  /// No description provided for @mail_quoteWrote.
  ///
  /// In id, this message translates to:
  /// **'Pada {time}, {from} menulis:'**
  String mail_quoteWrote(String time, String from);

  /// No description provided for @mail_quoteFwd.
  ///
  /// In id, this message translates to:
  /// **'— Diteruskan dari {from} <{email}> —'**
  String mail_quoteFwd(String from, String email);

  /// No description provided for @quick_title.
  ///
  /// In id, this message translates to:
  /// **'Tambah Cepat'**
  String get quick_title;

  /// No description provided for @quick_hint.
  ///
  /// In id, this message translates to:
  /// **'Ketik sekali, geser jam, simpan.'**
  String get quick_hint;

  /// No description provided for @quick_step1.
  ///
  /// In id, this message translates to:
  /// **'Langkah 1 — Apa?'**
  String get quick_step1;

  /// No description provided for @quick_step2.
  ///
  /// In id, this message translates to:
  /// **'Langkah 2 — Kapan?'**
  String get quick_step2;

  /// No description provided for @quick_step3.
  ///
  /// In id, this message translates to:
  /// **'Langkah 3 — Cek'**
  String get quick_step3;

  /// No description provided for @quick_whatPh.
  ///
  /// In id, this message translates to:
  /// **'Hari ini tugasnya apa?'**
  String get quick_whatPh;

  /// No description provided for @quick_detailPh.
  ///
  /// In id, this message translates to:
  /// **'Detail opsional…'**
  String get quick_detailPh;

  /// No description provided for @quick_titleRequired.
  ///
  /// In id, this message translates to:
  /// **'Judul wajib diisi'**
  String get quick_titleRequired;

  /// No description provided for @quick_next.
  ///
  /// In id, this message translates to:
  /// **'Lanjut'**
  String get quick_next;

  /// No description provided for @quick_back.
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get quick_back;

  /// No description provided for @quick_timeLabel.
  ///
  /// In id, this message translates to:
  /// **'Jam'**
  String get quick_timeLabel;

  /// No description provided for @quick_dateLabel.
  ///
  /// In id, this message translates to:
  /// **'Tanggal'**
  String get quick_dateLabel;

  /// No description provided for @quick_toLabel.
  ///
  /// In id, this message translates to:
  /// **'Ke'**
  String get quick_toLabel;

  /// No description provided for @quick_toPh.
  ///
  /// In id, this message translates to:
  /// **'nama@email.com'**
  String get quick_toPh;

  /// No description provided for @quick_presetMorning.
  ///
  /// In id, this message translates to:
  /// **'Pagi'**
  String get quick_presetMorning;

  /// No description provided for @quick_presetNoon.
  ///
  /// In id, this message translates to:
  /// **'Siang'**
  String get quick_presetNoon;

  /// No description provided for @quick_presetNight.
  ///
  /// In id, this message translates to:
  /// **'Malam'**
  String get quick_presetNight;

  /// No description provided for @quick_presetTomorrow.
  ///
  /// In id, this message translates to:
  /// **'Besok'**
  String get quick_presetTomorrow;

  /// No description provided for @quick_detailLink.
  ///
  /// In id, this message translates to:
  /// **'Lengkapi detail'**
  String get quick_detailLink;

  /// No description provided for @quick_summaryKind.
  ///
  /// In id, this message translates to:
  /// **'Jenis'**
  String get quick_summaryKind;

  /// No description provided for @quick_titleTask.
  ///
  /// In id, this message translates to:
  /// **'Tambah Cepat Tugas'**
  String get quick_titleTask;

  /// No description provided for @quick_titleSched.
  ///
  /// In id, this message translates to:
  /// **'Tambah Cepat Jadwal'**
  String get quick_titleSched;

  /// No description provided for @quick_titleMail.
  ///
  /// In id, this message translates to:
  /// **'Tulis Cepat'**
  String get quick_titleMail;

  /// No description provided for @quick_titleNote.
  ///
  /// In id, this message translates to:
  /// **'Catat Cepat'**
  String get quick_titleNote;

  /// No description provided for @quick_whatSchedPh.
  ///
  /// In id, this message translates to:
  /// **'Mau nambah jadwal apa?'**
  String get quick_whatSchedPh;

  /// No description provided for @quick_whatNotePh.
  ///
  /// In id, this message translates to:
  /// **'Mau catat apa hari ini?'**
  String get quick_whatNotePh;

  /// No description provided for @quick_subjLabel.
  ///
  /// In id, this message translates to:
  /// **'Subjek'**
  String get quick_subjLabel;

  /// No description provided for @quick_subjPh.
  ///
  /// In id, this message translates to:
  /// **'cth: Tugas Basis Data'**
  String get quick_subjPh;

  /// No description provided for @quick_bodyPhMail.
  ///
  /// In id, this message translates to:
  /// **'Tulis pesan…'**
  String get quick_bodyPhMail;

  /// No description provided for @quick_bodyRequired.
  ///
  /// In id, this message translates to:
  /// **'Isi pesan wajib diisi'**
  String get quick_bodyRequired;

  /// No description provided for @quick_endLabel.
  ///
  /// In id, this message translates to:
  /// **'Selesai (opsional)'**
  String get quick_endLabel;

  /// No description provided for @quick_noteBodyRequired.
  ///
  /// In id, this message translates to:
  /// **'Isi wajib diisi agar tersimpan ke Drive'**
  String get quick_noteBodyRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
