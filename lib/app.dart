import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart' as hw;
import 'package:notedwork/core/dates.dart';
import 'package:notedwork/core/models.dart';
import 'package:notedwork/core/notifications/notification_service.dart';
import 'package:notedwork/core/state/state.dart';
import 'package:notedwork/core/theme/app_theme.dart' as nw_theme;
import 'package:notedwork/core/widget/agenda_widget.dart';
import 'package:notedwork/features/calendar/calendar_screen.dart';
import 'package:notedwork/features/notes/notes_screen.dart';
import 'package:notedwork/features/quick_add/quick_add_sheet.dart';
import 'package:notedwork/features/settings/settings_screen.dart';
import 'package:notedwork/features/tasks/tasks_screen.dart';
import 'package:notedwork/features/today/today_screen.dart';
import 'package:notedwork/l10n/app_localizations.dart';

class NotedworkApp extends ConsumerStatefulWidget {
  const NotedworkApp({super.key});

  @override
  ConsumerState<NotedworkApp> createState() => _NotedworkAppState();
}

class _NotedworkAppState extends ConsumerState<NotedworkApp> {
  int _index = 0;
  StreamSubscription<NavTarget>? _tapSub;
  StreamSubscription<Uri?>? _widgetClicks;

  // Context dari `home:` (di bawah MaterialApp): context State ini berada di
  // atas MaterialApp sehingga tidak punya Navigator maupun Localizations.
  BuildContext? _homeCtx;

  static const List<ViewName> _tabs = [
    ViewName.beranda,
    ViewName.kalender,
    ViewName.tugas,
    ViewName.catatan,
  ];

  @override
  void initState() {
    super.initState();
    _tapSub = NotificationService.taps.listen((target) {
      final view = target.view;
      final i = view == null ? -1 : _tabs.indexOf(view);
      if (i >= 0 && mounted) setState(() => _index = i);
    });
    // Saat pertama buka: minta izin notifikasi (bila belum) + jadwalkan ulang
    // pengingat. Tanpa ini, instalasi baru tidak pernah dimintai izin dan
    // resync hanya terjadi kalau data berubah.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (ref.read(settingsProvider).remindersOn) {
        NotificationService.ensureReady();
      }
      _syncReminders();
      _syncAgendaWidget();
      _handleWidgetUri(hw.HomeWidget.initiallyLaunchedFromHomeWidget());
      _widgetClicks = hw.HomeWidget.widgetClicked
          .listen((uri) => _handleWidgetUri(Future.value(uri)));
    });
  }

  @override
  void dispose() {
    _tapSub?.cancel();
    _widgetClicks?.cancel();
    super.dispose();
  }

  void _syncReminders() {
    final enabled = ref.read(settingsProvider).remindersOn;
    final items = ref.read(reminderItemsProvider);
    NotificationService.resync(items, enabled: enabled);
  }

  void _syncAgendaWidget() {
    final ctx = _homeCtx;
    if (ctx == null || !mounted) return;
    final l10n = AppLocalizations.of(ctx);
    final lang = ref.read(settingsProvider).lang;
    AgendaWidgetBridge.update(
      scheds: ref.read(schedsProvider),
      routines: ref.read(routinesProvider),
      tasks: ref.read(tasksProvider),
      now: DateTime.now(),
      header: '${l10n.nav_home} · ${fmtDateID(todayStr(), lang)}',
      emptyText: lang == Lang.id
          ? 'Belum ada agenda hari ini'
          : 'No agenda for today yet',
    );
  }

  Future<void> _handleWidgetUri(Future<Uri?> future) async {
    final uri = await future;
    if (uri == null) return;
    if (uri.host != 'widget' || uri.path != '/add') return;
    final ctx = _homeCtx;
    if (ctx == null || !ctx.mounted) return;
    showQuickAdd(ctx, kind: 'jadwal');
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final media = MediaQuery.of(context);

    ref.listen(settingsProvider, (prev, next) {
      if (prev?.remindersOn != next.remindersOn) _syncReminders();
      if (prev?.lang != next.lang) _syncAgendaWidget();
    });
    ref.listen(reminderItemsProvider, (prev, next) {
      if (prev != next) _syncReminders();
    });
    ref.listen(schedsProvider, (_, _) => _syncAgendaWidget());
    ref.listen(routinesProvider, (_, _) => _syncAgendaWidget());
    ref.listen(tasksProvider, (_, _) => _syncAgendaWidget());

    return MaterialApp(
      title: 'Notedwork',
      debugShowCheckedModeBanner: false,
      themeMode: settings.theme.mode.themeMode,
      theme: nw_theme.AppTheme.forConfig(
        settings.theme,
        systemBrightness: Brightness.light,
      ),
      darkTheme: nw_theme.AppTheme.forConfig(
        settings.theme,
        systemBrightness: Brightness.dark,
      ),
      locale: Locale(settings.lang.name),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) {
          _homeCtx = context;
          return _Shell(
            index: _index,
            media: media,
            onIndex: (i) => setState(() => _index = i),
          );
        },
      ),
    );
  }
}

class _Shell extends ConsumerWidget {
  const _Shell({
    required this.index,
    required this.media,
    required this.onIndex,
  });

  final int index;
  final MediaQueryData media;
  final ValueChanged<int> onIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final wide = media.size.width >= 720;
    final screens = const [
      TodayScreen(),
      CalendarScreen(),
      TasksScreen(),
      NotesScreen(),
    ];

    final destinations = [
      (Icons.wb_sunny_outlined, Icons.wb_sunny, l10n.nav_home),
      (Icons.calendar_month_outlined, Icons.calendar_month, l10n.nav_calendar),
      (Icons.check_circle_outline, Icons.check_circle, l10n.nav_tasks),
      (Icons.notes_outlined, Icons.notes, l10n.nav_notes),
      (Icons.person_outline, Icons.person, l10n.nav_settings),
    ];

    // Indeks 4 = Profil (buka Pengaturan sebagai route, tab aktif tidak berubah).
    void onSelect(int i) {
      if (i >= 4) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
        );
        return;
      }
      onIndex(i);
    }

    final body = Row(
      children: [
        if (wide)
          NavigationRail(
            selectedIndex: index,
            onDestinationSelected: onSelect,
            labelType: NavigationRailLabelType.all,
            destinations: [
              for (final (icon, sel, label) in destinations)
                NavigationRailDestination(
                  icon: Icon(icon),
                  selectedIcon: Icon(sel),
                  label: Text(label),
                ),
            ],
          ),
        Expanded(
          child: IndexedStack(index: index, children: screens),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(destinations[index].$3),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              tooltip: l10n.nav_settings,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
              icon: CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(Icons.person, size: 18, color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ),
        ],
      ),
      body: body,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showQuickAdd(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.nav_addNew),
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: index,
              onDestinationSelected: onSelect,
              destinations: [
                for (final (icon, sel, label) in destinations)
                  NavigationDestination(
                    icon: Icon(icon),
                    selectedIcon: Icon(sel),
                    label: label,
                  ),
              ],
            ),
    );
  }
}
