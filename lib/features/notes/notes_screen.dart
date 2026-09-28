import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notedwork/core/dates.dart';
import 'package:notedwork/core/models.dart';
import 'package:notedwork/core/state/state.dart';
import 'package:notedwork/core/theme/app_theme.dart';
import 'package:notedwork/core/theme/palette.dart';
import 'package:notedwork/l10n/app_localizations.dart';

import 'note_sheet.dart';

/// Isi tab Catatan — port dari web `NotesView.tsx`.
/// Body content saja: tanpa Scaffold/AppBar/FAB/bottom-nav (milik shell).
class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ext = theme.extension<NwThemeExt>()!;
    final lang = ref.watch(settingsProvider).lang;
    final notes = [...ref.watch(notesProvider)]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
      children: [
        // view-head: h1 sudah di AppBar shell, yang dibawa hanya tombol +.
        Row(
          children: [
            const Spacer(),
            FilledButton.icon(
              onPressed: () => showNoteSheet(context),
              icon: const Icon(Icons.add, size: 18),
              label: Text(l10n.notes_add),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (notes.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 22, 10, 22),
            child: Column(
              children: [
                Text(
                  l10n.notes_empty,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13.5,
                    height: 1.7,
                    color: ext.muted,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.notes_emptyHint,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12.5,
                    height: 1.7,
                    color: ext.muted,
                  ),
                ),
              ],
            ),
          )
        else
          for (final note in notes)
            _NoteCard(key: ValueKey(note.id), note: note, lang: lang),
      ],
    );
  }
}

/// Kartu catatan: judul + isi + baris "diedit" + aksi edit/hapus.
/// Ketuk kartu = ubah (web: tombol pensil di `row-actions`).
class _NoteCard extends ConsumerWidget {
  const _NoteCard({super.key, required this.note, required this.lang});

  final Note note;
  final Lang lang;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ext = theme.extension<NwThemeExt>()!;
    final semantic = NwSemantic.of(
      dark: theme.brightness == Brightness.dark,
    );
    final edited = note.updatedAt > 0
        ? fmtDateID(
            DateTime.fromMillisecondsSinceEpoch(
              note.updatedAt,
            ).toIso8601String(),
            lang,
          )
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => showNoteSheet(context, initial: note),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                    color: ext.ink,
                  ),
                ),
                if (note.body.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    note.body,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      height: 1.5,
                      color: ext.muted,
                    ),
                  ),
                ],
                if (edited != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    edited,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 11.5,
                      height: 1.3,
                      color: ext.muted,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Row(
                  children: [
                    IconButton(
                      tooltip: '${l10n.notes_edit}: ${note.title}',
                      onPressed: () => showNoteSheet(context, initial: note),
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: ext.accent,
                      ),
                    ),
                    IconButton(
                      tooltip: '${l10n.notes_delete}: ${note.title}',
                      onPressed: () => confirmDeleteNote(context, ref, note),
                      icon: Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: semantic.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
