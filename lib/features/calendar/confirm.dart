import 'package:flutter/material.dart';
import 'package:notedwork/core/theme/app_theme.dart';
import 'package:notedwork/core/theme/palette.dart';
import 'package:notedwork/l10n/app_localizations.dart';

Future<bool> confirmDelete(BuildContext context, String title) async {
  final l10n = AppLocalizations.of(context);
  final semantic = NwSemantic.of(
    dark: Theme.of(context).brightness == Brightness.dark,
  );
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.confirm_title),
      content: Text(l10n.confirm_desc(title)),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l10n.common_cancel),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: semantic.red,
            backgroundColor: semantic.redSoft,
          ),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(l10n.common_delete),
        ),
      ],
    ),
  );
  return ok ?? false;
}

void showNwSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(content: Text(message)));
}

TextStyle nwLabelStyle(BuildContext context) {
  final t = Theme.of(context).extension<NwThemeExt>()!;
  final base = Theme.of(context).textTheme;
  return (base.labelMedium ?? const TextStyle()).copyWith(
    color: t.ink,
    fontWeight: FontWeight.w700,
    fontSize: 13,
    height: 1.3,
  );
}

TextStyle nwHintStyle(BuildContext context) {
  final t = Theme.of(context).extension<NwThemeExt>()!;
  return TextStyle(color: t.muted, fontSize: 12.5, height: 1.5);
}

class NwSwatch extends StatelessWidget {
  const NwSwatch({
    super.key,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NwThemeExt>()!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? t.ink : t.line,
            width: selected ? 2 : 1,
          ),
        ),
        child: selected
            ? Icon(Icons.check, size: 16, color: nwOnColorFor(color))
            : null,
      ),
    );
  }
}
