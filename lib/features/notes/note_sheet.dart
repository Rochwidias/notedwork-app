import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notedwork/core/dates.dart';
import 'package:notedwork/core/models.dart';
import 'package:notedwork/core/state/state.dart';
import 'package:notedwork/core/theme/app_theme.dart';
import 'package:notedwork/core/theme/palette.dart';
import 'package:notedwork/l10n/app_localizations.dart';

/// Konfirmasi hapus catatan — port `ConfirmSheet` (Sheets.tsx).
///
/// true = sudah dihapus (notifier + toast `toast.noteDeleted`), false = batal.
Future<bool> confirmDeleteNote(
  BuildContext context,
  WidgetRef ref,
  Note note,
) async {
  final l10n = AppLocalizations.of(context);
  final semantic = NwSemantic.of(
    dark: Theme.of(context).brightness == Brightness.dark,
  );
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.confirm_title),
      content: Text(
        l10n.confirm_desc(note.title.trim().isEmpty ? note.id : note.title),
      ),
      actions: [
        TextButton(
          autofocus: true,
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l10n.common_cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: semantic.redSoft,
            foregroundColor: semantic.red,
          ),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(l10n.common_delete),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return false;
  ref.read(notesProvider.notifier).remove(note.id);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(l10n.toast_noteDeleted)));
  return true;
}

/// Buka NoteSheet — [initial] null = tambah, terisi = ubah.
/// Port dari `NoteSheet` (`components/Sheets.tsx`).
Future<void> showNoteSheet(BuildContext context, {Note? initial}) {
  final maxHeight = MediaQuery.of(context).size.height * 0.92;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(maxHeight: maxHeight),
    builder: (context) => _NoteSheet(initial: initial),
  );
}

class _NoteSheet extends ConsumerStatefulWidget {
  const _NoteSheet({this.initial});

  /// null = mode tambah; terisi = mode ubah.
  final Note? initial;

  @override
  ConsumerState<_NoteSheet> createState() => _NoteSheetState();
}

class _NoteSheetState extends ConsumerState<_NoteSheet> {
  late final TextEditingController _title;
  late final TextEditingController _body;

  /// Error inline judul (web: `titleErr`).
  String? _titleErr;

  /// Kunci anti spam Simpan (web: `savingRef` sinkron + state `saving`).
  bool _saving = false;

  bool get _editing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.initial?.title ?? '');
    _body = TextEditingController(text: widget.initial?.body ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  void _submit() {
    if (_saving) return;
    final l10n = AppLocalizations.of(context);
    final title = _title.text.trim();
    // Judul wajib (web: `notes.titleRequired`), error inline bukan diam.
    if (title.isEmpty) {
      setState(() => _titleErr = l10n.notes_titleRequired);
      return;
    }
    setState(() {
      _titleErr = null;
      _saving = true;
    });
    final body = _body.text.trim();
    final now = DateTime.now().millisecondsSinceEpoch;
    final current = widget.initial;
    final note = current == null
        ? Note(id: uid('n'), title: title, body: body, updatedAt: now)
        : current.copyWith(title: title, body: body, updatedAt: now);
    ref.read(notesProvider.notifier).upsert(note);
    Navigator.of(context).pop();
  }

  Future<void> _askDelete() async {
    final note = widget.initial;
    if (note == null) return;
    final removed = await confirmDeleteNote(context, ref, note);
    if (removed && mounted) Navigator.of(context).pop();
  }

  String _saveLabel(AppLocalizations l10n) {
    if (_saving) return l10n.notes_saving;
    return _editing ? l10n.notes_saveChanges : l10n.common_save;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ext = theme.extension<NwThemeExt>()!;
    final textTheme = theme.textTheme;
    final semantic = NwSemantic.of(
      dark: theme.brightness == Brightness.dark,
    );
    final labelStyle = textTheme.bodyMedium?.copyWith(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      height: 1.4,
      color: ext.ink,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.edit_note_outlined, size: 18, color: ext.muted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _editing ? l10n.notes_sheetEdit : l10n.notes_sheetAdd,
                    style: textTheme.titleMedium?.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(l10n.notes_fieldTitle, style: labelStyle),
            const SizedBox(height: 6),
            TextField(
              controller: _title,
              textInputAction: TextInputAction.next,
              inputFormatters: [LengthLimitingTextInputFormatter(100)],
              onChanged: (_) {
                if (_titleErr != null) setState(() => _titleErr = null);
              },
              decoration: InputDecoration(
                hintText: l10n.notes_titlePh,
                errorText: _titleErr,
                errorMaxLines: 2,
              ),
            ),
            const SizedBox(height: 12),
            Text(l10n.notes_fieldBody, style: labelStyle),
            const SizedBox(height: 6),
            TextField(
              controller: _body,
              minLines: 6,
              maxLines: 12,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(hintText: l10n.notes_bodyPh),
            ),
            if (_editing) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: _saving ? null : _askDelete,
                style: TextButton.styleFrom(
                  backgroundColor: semantic.redSoft,
                  foregroundColor: semantic.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
                child: Text(l10n.notes_delete),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saving
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text(l10n.common_close),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: _saving ? null : _submit,
                    child: Text(_saveLabel(l10n)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
