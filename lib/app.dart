import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notedwork/core/models.dart';
import 'package:notedwork/core/notifications/notification_service.dart';
import 'package:notedwork/core/state/state.dart';
import 'package:notedwork/core/theme/app_theme.dart' as nw_theme;
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
  }

  @override
  void dispose() {
    _tapSub?.cancel();
    super.dispose();
  }

  void _syncReminders() {
    final enabled = ref.read(settingsProvider).remindersOn;
    final items = ref.read(reminderItemsProvider);
    NotificationService.resync(items, enabled: enabled);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final media = MediaQuery.of(context);

    ref.listen(settingsProvider, (prev, next) {
      if (prev?.remindersOn != next.remindersOn) _syncReminders();
    });
    ref.listen(reminderItemsProvider, (prev, next) {
      if (prev != next) _syncReminders();
    });

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
        builder: (context) => _Shell(
          index: _index,
          media: media,
          onIndex: (i) => setState(() => _index = i),
        ),
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
    ];

    final body = Row(
      children: [
        if (wide)
          NavigationRail(
            selectedIndex: index,
            onDestinationSelected: onIndex,
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
              onDestinationSelected: onIndex,
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
