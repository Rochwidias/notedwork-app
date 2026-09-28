import 'package:flutter/material.dart';
import 'package:notedwork/features/tasks/task_widgets.dart';
import 'package:notedwork/l10n/app_localizations.dart';

/// Sheet detail sederhana untuk baris yang di web membuka tab/sheet lain —
/// di Flutter kita tidak bisa paham lintas tab, jadi tampilkan detailnya
/// di sini (radius 24 atas + drag handle dari tema bottom sheet).
Future<void> showNwDetailSheet(
  BuildContext context, {
  required String title,
  String? subtitle,
  List<(String, String)> rows = const [],
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      final nw = nwExt(context);
      final l10n = AppLocalizations.of(context);
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: nw.ink,
                height: 1.3,
              ),
            ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  subtitle,
                  style: TextStyle(fontSize: 12.5, color: nw.muted, height: 1.5),
                ),
              ),
            if (rows.isNotEmpty) const SizedBox(height: 12),
            for (final (i, row) in rows.indexed) ...[
              if (i > 0) const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 108,
                      child: Text(
                        row.$1,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: nw.muted,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        row.$2,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          color: nw.ink,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.common_close),
            ),
          ],
        ),
      );
    },
  );
}
