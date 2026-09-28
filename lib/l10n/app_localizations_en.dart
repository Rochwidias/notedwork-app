// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get nav_home => 'Today';

  @override
  String get nav_email => 'Email';

  @override
  String get nav_tasks => 'Tasks';

  @override
  String get nav_calendar => 'Calendar';

  @override
  String get nav_notes => 'Notes';

  @override
  String get nav_settings => 'Settings';

  @override
  String get nav_menu => 'MENU';

  @override
  String get nav_addSection => 'ADD';

  @override
  String get nav_addNew => 'Add New';

  @override
  String get nav_main => 'Main navigation';

  @override
  String get tambah_title => 'Add New';

  @override
  String get tambah_hint => 'Choose what to create.';

  @override
  String get tambah_mail => 'Compose Email';

  @override
  String get tambah_mailSub => 'Sent via Gmail';

  @override
  String get tambah_task => 'Add Task';

  @override
  String get tambah_taskSub => 'Deadline shows on Calendar';

  @override
  String get tambah_sched => 'Add Event';

  @override
  String get tambah_schedSub => 'One-time agenda';

  @override
  String get tambah_note => 'Add Note';

  @override
  String get tambah_noteSub => 'Quick ideas saved locally';

  @override
  String get tambah_mailNew => 'Compose new email';

  @override
  String get tambah_taskNew => 'Add new task';

  @override
  String get tambah_schedNew => 'Add new event';

  @override
  String get tambah_noteNew => 'Add new note';

  @override
  String get notes_title => 'Notes';

  @override
  String get notes_add => 'Add';

  @override
  String get notes_empty => 'No notes yet.';

  @override
  String get notes_emptyHint => 'Tap the + button to add one.';

  @override
  String get notes_edit => 'Edit';

  @override
  String get notes_delete => 'Delete';

  @override
  String get notes_settings => 'Settings';

  @override
  String get notes_sheetAdd => 'Add Note';

  @override
  String get notes_sheetEdit => 'Edit Note';

  @override
  String get notes_fieldTitle => 'Title';

  @override
  String get notes_fieldBody => 'Body';

  @override
  String get notes_titlePh => 'e.g. Quick idea';

  @override
  String get notes_bodyPh => 'Write a note…';

  @override
  String get notes_titleRequired => 'Title is required';

  @override
  String get notes_saving => 'Saving…';

  @override
  String get notes_onDrive => 'on Drive';

  @override
  String get notes_saveChanges => 'Save changes';

  @override
  String get topbar_langToEn => 'Switch to English';

  @override
  String get topbar_langToId => 'Ganti ke Bahasa Indonesia';

  @override
  String get topbar_theme => 'Change theme';

  @override
  String get topbar_themeToLight => 'Light mode';

  @override
  String get topbar_themeToDark => 'Dark mode';

  @override
  String get topbar_settings => 'Settings';

  @override
  String get topbar_connect => 'Google connection';

  @override
  String get topbar_tagline => 'Student email & schedule';

  @override
  String get common_save => 'Save';

  @override
  String get common_close => 'Close';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_edit => 'Edit';

  @override
  String get common_all => 'All';

  @override
  String get common_markDone => 'Mark done';

  @override
  String get common_tapToComplete => '. Tap to mark done.';

  @override
  String get confirm_title => 'Sure to delete?';

  @override
  String confirm_desc(String title) {
    return '“$title” will be permanently deleted.';
  }

  @override
  String get home_title => 'Today';

  @override
  String get home_hello => 'Hello';

  @override
  String get home_previewSuffix => ' — Preview mode (sample data)';

  @override
  String get home_guestName => 'there';

  @override
  String get home_dueSoon => 'Starting soon';

  @override
  String home_inMin(String n) {
    return '$n min to go';
  }

  @override
  String home_inHours(String h, String m) {
    return '${h}h ${m}m to go';
  }

  @override
  String home_inHoursEven(String h) {
    return '$h hours to go';
  }

  @override
  String get home_tomorrow => 'Tomorrow';

  @override
  String home_inDays(String d) {
    return '$d days to go';
  }

  @override
  String get home_room => 'Room';

  @override
  String get home_reminderPrefix => 'Reminder';

  @override
  String get home_openCalendar => 'Open calendar';

  @override
  String get home_reminderAriaNone => 'No reminders. Open calendar.';

  @override
  String get home_viewCalendar => 'View calendar';

  @override
  String get home_noReminder => 'No upcoming reminders';

  @override
  String get home_noReminderSub => 'No agenda or deadlines. Enjoy your day!';

  @override
  String get home_top3 => 'Top 3';

  @override
  String get home_next7 => 'Upcoming 7 days';

  @override
  String get home_next7empty => 'No agenda in the next 7 days.';

  @override
  String get home_nearTasks => 'Upcoming tasks';

  @override
  String get home_nearTasksEmpty => 'No upcoming tasks. Enjoy your day!';

  @override
  String get home_allDone => 'All tasks done. Enjoy your day!';

  @override
  String get home_thisWeek => 'This week';

  @override
  String get home_emailImportant => 'Important email';

  @override
  String get home_openMail => 'Open email: ';

  @override
  String get home_inboxClear => 'Inbox zero. No important email.';

  @override
  String get email_title => 'Email';

  @override
  String get email_previewSub =>
      'Preview mode — sample data. Not your real data.';

  @override
  String get email_liveBase => 'Real Gmail & Calendar';

  @override
  String get email_updatedFrag => ' • updated ';

  @override
  String get email_countSep => ' • ';

  @override
  String get email_countUnit => ' emails';

  @override
  String get email_filterUnread => 'Unread';

  @override
  String get email_filterStar => 'Starred';

  @override
  String get email_showEmails => 'Show';

  @override
  String get email_searchPh => 'Search email…';

  @override
  String get email_searchLabel => 'Search email';

  @override
  String get email_clearSearch => 'Clear search';

  @override
  String get email_typing => 'Typing…';

  @override
  String get email_searching => 'Searching…';

  @override
  String get email_results => ' results';

  @override
  String get email_resultsFor => ' for “';

  @override
  String get email_loading => 'Loading email';

  @override
  String get email_unreadSuffix => ', unread';

  @override
  String get email_starTitle => 'Star';

  @override
  String get email_unstar => 'Unstar';

  @override
  String get email_giveStar => 'Star';

  @override
  String get email_noTag => 'No label';

  @override
  String get email_noResults => 'No results. Try other keywords or filters.';

  @override
  String get email_emptyHere => 'No email here.';

  @override
  String get email_loadingMore => 'Loading…';

  @override
  String get email_loadMore => 'Load more (next 50)';

  @override
  String get email_backToList => 'Back to list';

  @override
  String get email_backToListAria => 'Back to email list';

  @override
  String get email_badgeNew => 'New';

  @override
  String get email_attach => 'ATTACHMENTS (';

  @override
  String get email_reply => 'Reply';

  @override
  String get email_forward => 'Forward';

  @override
  String get email_moreActions => 'More email actions';

  @override
  String get email_more => 'More';

  @override
  String get email_archive => 'Archive';

  @override
  String get email_markUnread => 'Mark as unread';

  @override
  String get tasks_title => 'Tasks';

  @override
  String get tasks_previewSub =>
      'Preview mode — sample data, stored locally on your device';

  @override
  String get tasks_liveSub => 'Task deadlines also appear on Calendar';

  @override
  String get tasks_filterActive => 'Active';

  @override
  String get tasks_filterOverdue => 'Overdue';

  @override
  String get tasks_filterDone => 'Done';

  @override
  String get tasks_stateDone => 'done';

  @override
  String get tasks_stateActive => 'active';

  @override
  String get tasks_tapToToggle => '. Tap to change status.';

  @override
  String get tasks_reopen => 'Reopen';

  @override
  String get tasks_emptyHere => 'No tasks here.';

  @override
  String get tasks_addTask => 'Add task';

  @override
  String get cal_previewSub =>
      'Preview mode — sample data. Not your real data.';

  @override
  String get cal_liveSub => 'Tap a date to see that day\'s agenda';

  @override
  String get cal_prevMonth => 'Previous month';

  @override
  String get cal_nextMonth => 'Next month';

  @override
  String get cal_routine => 'Routine';

  @override
  String get cal_agenda => 'Events';

  @override
  String get cal_deadline => 'Deadline';

  @override
  String get cal_today => 'Today';

  @override
  String get cal_backToday => 'Back to today';

  @override
  String get cal_room => 'Room';

  @override
  String get cal_deadlineAt => ' • due ';

  @override
  String get cal_emptyDate => 'No agenda on this date.';

  @override
  String get cal_upcoming7 => 'Upcoming in the next 7 days:';

  @override
  String get cal_enjoyDay => 'Enjoy your day!';

  @override
  String get cal_addSched => 'Add Event';

  @override
  String get cal_weeklyRoutine => 'Weekly routine';

  @override
  String get cal_noRoutine => 'No routine yet.';

  @override
  String get cal_manageRoutine => 'Manage routine';

  @override
  String get common_optional => '(optional)';

  @override
  String get reminder_title => 'Reminder';

  @override
  String get reminder_off => 'Off';

  @override
  String get reminder_min => ' min';

  @override
  String get reminder_hour => ' hr';

  @override
  String get reminder_hours => ' hrs';

  @override
  String get reminder_day => ' day';

  @override
  String get sched_editTitle => 'Edit Event';

  @override
  String get sched_addTitle => 'Add Event';

  @override
  String get sched_hint =>
      'One-time agenda. For weekly courses, use a routine schedule.';

  @override
  String get sched_titleRequired => 'Enter a title first — e.g. Thesis defense';

  @override
  String get sched_endInvalid =>
      'Invalid end time — leave empty for point-time events';

  @override
  String get sched_fieldTitle => 'Title';

  @override
  String get sched_titlePh => 'e.g. Thesis defense';

  @override
  String get sched_fieldDate => 'Date';

  @override
  String get sched_startLabel => 'Start time ';

  @override
  String get sched_endLabel => 'End time ';

  @override
  String get sched_endHint =>
      'Leave empty = point-time (start time only). Filled = shows a range like 09.00–10.40. An end earlier than the start means past midnight (tomorrow).';

  @override
  String get sched_fieldNote => 'Details';

  @override
  String get sched_notePh => 'Room, lecturer, meeting link…';

  @override
  String get sched_saving => 'Saving…';

  @override
  String get sched_saveChanges => 'Save changes';

  @override
  String get task_editTitle => 'Edit Task';

  @override
  String get task_addTitle => 'Add Task';

  @override
  String get task_hint =>
      'Deadlines automatically appear on Calendar & Dashboard.';

  @override
  String get task_titleRequired =>
      'Enter the task title first — e.g. Module 6 report';

  @override
  String get task_fieldCourse => 'Course';

  @override
  String get task_coursePh => 'e.g. Databases';

  @override
  String get task_fieldTitle => 'Task title';

  @override
  String get task_titlePh => 'e.g. Module 6 report';

  @override
  String get task_fieldDate => 'Deadline date';

  @override
  String get task_fieldTime => 'Time ';

  @override
  String get task_timeHint => 'Leave empty = end of day 23:59.';

  @override
  String get task_fieldPrio => 'Priority';

  @override
  String get task_fieldNote => 'Notes';

  @override
  String get task_notePh => 'How to submit, links, etc…';

  @override
  String get task_saving => 'Saving…';

  @override
  String get task_saveChanges => 'Save changes';

  @override
  String get mail_replyTitle => 'Reply Email';

  @override
  String get mail_fwdTitle => 'Forward Email';

  @override
  String get mail_composeTitle => 'Compose Email';

  @override
  String get mail_hint => 'Sent directly via Gmail.';

  @override
  String get mail_toInvalid => 'Invalid recipient email format';

  @override
  String get mail_fieldTo => 'To';

  @override
  String get mail_toPh => 'lecturer@univ.ac.id';

  @override
  String get mail_fieldSubj => 'Subject ';

  @override
  String get mail_subjPh => 'Permission / consultation / assignment…';

  @override
  String get mail_fieldBody => 'Body';

  @override
  String get mail_bodyPh => 'Write a message…';

  @override
  String get mail_sending => 'Sending…';

  @override
  String get mail_send => 'Send';

  @override
  String get routine_title => 'Manage Routine Schedule';

  @override
  String get routine_hint =>
      'Fixed weekly courses — automatically appear on Calendar.';

  @override
  String get routine_fieldCourse => 'Course';

  @override
  String get routine_coursePh => 'e.g. Operating Systems';

  @override
  String get routine_fieldDay => 'Day';

  @override
  String get routine_fieldRoom => 'Room';

  @override
  String get routine_roomPh => 'e.g. 2A';

  @override
  String get routine_fieldStart => 'Start';

  @override
  String get routine_fieldEnd => 'End';

  @override
  String get routine_fieldLect => 'Lecturer';

  @override
  String get routine_lectPh => 'e.g. Mr. Andi';

  @override
  String get routine_adding => 'Adding…';

  @override
  String get routine_add => 'Add';

  @override
  String get routine_mineTitle => 'Your schedules (';

  @override
  String get routine_emptyMine => 'None yet — add via the form above.';

  @override
  String get settings_title => 'Settings';

  @override
  String get settings_accountOn => 'Connected Google account';

  @override
  String get settings_previewMode => 'Preview mode — sample data';

  @override
  String get settings_account => 'Account';

  @override
  String get settings_loggedSub => 'Logged in via Google';

  @override
  String get settings_guestMode => 'Guest mode';

  @override
  String get settings_guestSub => 'Preview with sample data';

  @override
  String get settings_displayName => 'Display name';

  @override
  String get settings_namePh => 'e.g. Budi';

  @override
  String get settings_logout => 'Log out';

  @override
  String get settings_connectGoogle => 'Connect Google';

  @override
  String get settings_exitPreview => 'Exit preview (delete guest data)';

  @override
  String get settings_themeGallery => 'Theme Gallery';

  @override
  String get settings_appearance => 'Appearance';

  @override
  String get settings_appearanceSub => 'Light, dark, or follow system';

  @override
  String get settings_light => 'Light';

  @override
  String get settings_dark => 'Dark';

  @override
  String get settings_auto => 'Automatic';

  @override
  String get settings_modeGroup => 'Display mode';

  @override
  String get settings_accentColor => 'Accent color';

  @override
  String get settings_accentSub =>
      'Button, badge & logo accents — your choice, stored on this device';

  @override
  String get settings_colorOf => 'Color ';

  @override
  String get settings_customColor => 'Custom color';

  @override
  String get settings_reset => 'Reset';

  @override
  String get settings_fontColor => 'Font color';

  @override
  String get settings_fontColorSub =>
      'App text color — your choice, stored on this device';

  @override
  String get settings_bgColor => 'Background color';

  @override
  String get settings_bgColorSub =>
      'App background color — your choice, stored on this device';

  @override
  String settings_forMode(String mode) {
    return '$mode mode';
  }

  @override
  String get settings_testNotif => 'Test';

  @override
  String get settings_testNotifSample => 'PBO presentation — in 10 minutes';

  @override
  String get settings_reminderTitle => 'Schedule reminders';

  @override
  String get settings_reminderSub => 'Reminder notifications from the app';

  @override
  String get settings_connTitle => 'Google connection';

  @override
  String settings_connLive(String email) {
    return 'Connected as $email';
  }

  @override
  String get settings_connNone => 'Not connected';

  @override
  String get settings_loginGoogle => 'Log in with Google';

  @override
  String get settings_info => 'Info';

  @override
  String get settings_credit => 'Credits';

  @override
  String get settings_creditSub => 'notedwork makers & tech';

  @override
  String get settings_privacy => 'Privacy';

  @override
  String get settings_privacySub => 'What data is stored & where';

  @override
  String get settings_terms => 'Terms';

  @override
  String get settings_termsSub => 'Rules for using this app';

  @override
  String get settings_installApp => 'Install app';

  @override
  String get settings_installAppSub => 'Open notedwork from your home screen';

  @override
  String get settings_open => 'Open';

  @override
  String get settings_about => 'About';

  @override
  String get settings_aboutBody1 =>
      'notedwork — email, tasks & calendar for students.';

  @override
  String get settings_aboutBody2 =>
      'Can be installed to your phone\'s home screen.';

  @override
  String get settings_copyright => '© 2026 Rochwidias. All rights reserved.';

  @override
  String get toast_syncFail => 'Google sync failed';

  @override
  String get toast_loginTokenFail =>
      'Google login failed while saving token — try again';

  @override
  String get toast_loginSessionFail =>
      'Google login failed while creating session — try again';

  @override
  String get toast_loginExpired => 'Google login expired — try again';

  @override
  String get toast_loginCancelled => 'Google login cancelled';

  @override
  String get toast_loginFail => 'Google login failed, try again';

  @override
  String get toast_connected => 'Connected to Google';

  @override
  String get toast_mailBodyFail => 'Failed to load email body';

  @override
  String get toast_starFail => 'Failed to change star';

  @override
  String get toast_archived => 'Archived';

  @override
  String get toast_markedUnread => 'Marked as unread';

  @override
  String get toast_gmailFail => 'Gmail action failed';

  @override
  String get toast_taskReopened => 'Reopened';

  @override
  String get toast_taskDone => 'Task done!';

  @override
  String get toast_taskDeleted => 'Task deleted';

  @override
  String get toast_taskMissing => 'Task not found';

  @override
  String get toast_schedDeleted => 'Event deleted';

  @override
  String get toast_gcalDeleted => 'Google event deleted';

  @override
  String get toast_schedDeleteFail => 'Failed to delete event';

  @override
  String get toast_schedSaved => 'Event saved';

  @override
  String get toast_schedSavedGcal => 'Event saved to Google Calendar';

  @override
  String get toast_schedSaveFail => 'Failed to save to Google';

  @override
  String get toast_schedMissing => 'Event not found';

  @override
  String get toast_schedUpdated => 'Event updated';

  @override
  String get toast_schedUpdatedGcal => 'Event updated in Google Calendar';

  @override
  String get toast_updateFailPrefix => 'Failed to update: ';

  @override
  String get toast_previewLoginHint =>
      'Log in with Google to use your real data';

  @override
  String get toast_mailSent => 'Email sent via Gmail';

  @override
  String get toast_sendFailPrefix => 'Failed to send: ';

  @override
  String get toast_loggedOut => 'Logged out of Google';

  @override
  String get toast_loggedOutLocal =>
      'Logged out locally; the server session may still be active — try again';

  @override
  String get toast_exitPreview => 'Exited preview mode';

  @override
  String get toast_exitPreviewConfirm =>
      'Exit preview? Guest data (sample tasks, routines, events) will be deleted and reset to the original samples.';

  @override
  String get toast_routineDeleted => 'Routine deleted';

  @override
  String get toast_noteDeleted => 'Note deleted';

  @override
  String get toast_driveSyncFail => 'Drive sync failed, kept locally';

  @override
  String get toast_reminderPrefix => 'Reminder: ';

  @override
  String get toast_notifOff => 'Reminders off';

  @override
  String get toast_notifOn => 'Reminders on';

  @override
  String get toast_taskUpdated => 'Task updated';

  @override
  String get toast_taskSaved => 'Task saved';

  @override
  String get toast_routineSaved => 'Routine saved';

  @override
  String get banner_previewTitle => 'Preview mode — sample data';

  @override
  String get banner_previewSub =>
      'Not your real data. Log in for real Gmail & Calendar.';

  @override
  String get banner_login => 'Log in with Google';

  @override
  String get install_entryTitle => 'Install notedwork on your phone';

  @override
  String get install_entrySub => 'Open with one tap, no browser hunting.';

  @override
  String get install_entryBtn => 'Install';

  @override
  String get install_title => 'Install notedwork';

  @override
  String get install_sub =>
      'Open with one tap from your home screen — no browser, no repeated logins.';

  @override
  String get install_tabAndroid => 'Android';

  @override
  String get install_tabIphone => 'iPhone';

  @override
  String get install_tabLaptop => 'Laptop';

  @override
  String get install_nativeBtn => 'Install Now';

  @override
  String get install_never => 'Don\'t show again';

  @override
  String get install_dismissedToast =>
      'Got it — the install card won\'t show again';

  @override
  String get install_installedToast => 'notedwork installed — enjoy!';

  @override
  String get install_android1 => 'Tap the Install Now button below (Chrome).';

  @override
  String get install_android2 =>
      'Confirm “Install” on the dialog that appears.';

  @override
  String get install_android3 =>
      'The notedwork icon appears on your home screen & app drawer.';

  @override
  String get install_iphone1 => 'Tap the Share button in Safari.';

  @override
  String get install_iphone2 => 'Choose “Add to Home Screen”.';

  @override
  String get install_iphone3 =>
      'Tap “Add” — the notedwork icon appears on your home screen.';

  @override
  String get install_laptop1 =>
      'Click the Install icon in the Chrome/Edge address bar.';

  @override
  String get install_laptop2 => 'Or menu ⋮ → “Install notedwork…”.';

  @override
  String get install_laptop3 =>
      'Click “Install” — the app opens in its own window.';

  @override
  String mail_quoteWrote(String time, String from) {
    return 'On $time, $from wrote:';
  }

  @override
  String mail_quoteFwd(String from, String email) {
    return '— Forwarded from $from <$email> —';
  }

  @override
  String get quick_title => 'Quick Add';

  @override
  String get quick_hint => 'Type once, slide the time, save.';

  @override
  String get quick_step1 => 'Step 1 — What?';

  @override
  String get quick_step2 => 'Step 2 — When?';

  @override
  String get quick_step3 => 'Step 3 — Review';

  @override
  String get quick_whatPh => 'What is today\'s task?';

  @override
  String get quick_detailPh => 'Optional detail…';

  @override
  String get quick_titleRequired => 'Title is required';

  @override
  String get quick_next => 'Next';

  @override
  String get quick_back => 'Back';

  @override
  String get quick_timeLabel => 'Time';

  @override
  String get quick_dateLabel => 'Date';

  @override
  String get quick_toLabel => 'To';

  @override
  String get quick_toPh => 'name@email.com';

  @override
  String get quick_presetMorning => 'Morning';

  @override
  String get quick_presetNoon => 'Afternoon';

  @override
  String get quick_presetNight => 'Evening';

  @override
  String get quick_presetTomorrow => 'Tomorrow';

  @override
  String get quick_detailLink => 'Add details';

  @override
  String get quick_summaryKind => 'Type';

  @override
  String get quick_titleTask => 'Quick Add Task';

  @override
  String get quick_titleSched => 'Quick Add Event';

  @override
  String get quick_titleMail => 'Quick Compose';

  @override
  String get quick_titleNote => 'Quick Note';

  @override
  String get quick_whatSchedPh => 'What event to add?';

  @override
  String get quick_whatNotePh => 'What to note down today?';

  @override
  String get quick_subjLabel => 'Subject';

  @override
  String get quick_subjPh => 'e.g. Database assignment';

  @override
  String get quick_bodyPhMail => 'Write a message…';

  @override
  String get quick_bodyRequired => 'Message body is required';

  @override
  String get quick_endLabel => 'End (optional)';

  @override
  String get quick_noteBodyRequired => 'Body is required to sync to Drive';
}
