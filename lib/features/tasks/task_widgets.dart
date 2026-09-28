import 'package:flutter/material.dart';
import 'package:notedwork/core/theme/app_theme.dart';
import 'package:notedwork/core/theme/palette.dart';

NwThemeExt nwExt(BuildContext context) {
  final ext = Theme.of(context).extension<NwThemeExt>();
  if (ext != null) return ext;
  return NwThemeExt.defaults(brightness: Theme.of(context).brightness);
}

NwSemantic nwSemantic(BuildContext context) =>
    NwSemantic.of(dark: Theme.of(context).brightness == Brightness.dark);

Widget nwChip(
  BuildContext context, {
  required String label,
  required bool selected,
  VoidCallback? onTap,
}) {
  final ext = nwExt(context);
  final fg = selected ? ext.onAccent : ext.muted;
  final bg = selected ? ext.accent : ext.card;
  final border = selected ? ext.accent : ext.line;
  return Material(
    color: bg,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(999),
      side: BorderSide(color: border),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 38,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium
                  ?.copyWith(color: fg, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    ),
  );
}

({Color bg, Color fg}) nwTagColors(BuildContext context, String css) {
  final semantic = nwSemantic(context);
  final ext = nwExt(context);
  return switch (css) {
    'over' => (bg: semantic.red, fg: const Color(0xFFFFFFFF)),
    'hi' => (bg: semantic.redSoft, fg: semantic.red),
    'md' => (bg: semantic.amberSoft, fg: semantic.amber),
    'lo' => (bg: semantic.greenSoft, fg: semantic.green),
    _ => (bg: ext.accentSoft, fg: ext.accentDark),
  };
}

Widget nwTag(
  BuildContext context, {
  required String label,
  required String css,
}) {
  final colors = nwTagColors(context, css);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
    decoration: BoxDecoration(
      color: colors.bg,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: colors.fg,
      ),
    ),
  );
}

void nwToast(BuildContext context, String msg) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger
    ..clearSnackBars()
    ..showSnackBar(SnackBar(content: Text(msg)));
}
