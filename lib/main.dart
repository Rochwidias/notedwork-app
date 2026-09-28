import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notedwork/app.dart';
import 'package:notedwork/core/notifications/notification_service.dart';
import 'package:notedwork/core/state/state.dart';
import 'package:notedwork/core/storage/store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await Store.open();
  try {
    await NotificationService.init();
  } catch (_) {
    // Notifikasi gagal (mis. resource icon) — app tetap jalan tanpa pengingat native.
  }
  runApp(
    ProviderScope(
      overrides: [storeProvider.overrideWithValue(store)],
      child: const NotedworkApp(),
    ),
  );
}
