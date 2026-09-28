import 'package:flutter/material.dart';
import 'package:notedwork/core/theme/app_theme.dart';
import 'package:notedwork/core/theme/palette.dart';

/// Gradien lingkaran "warna custom" — mirip `conic-gradient` di web.
const SweepGradient nwRainbowGradient = SweepGradient(
  colors: <Color>[
    Color(0xFFFF0000),
    Color(0xFFFFFF00),
    Color(0xFF00FF00),
    Color(0xFF00FFFF),
    Color(0xFF0000FF),
    Color(0xFFFF00FF),
    Color(0xFFFF0000),
  ],
);

/// Swatch warna bundar (36px) seperti tombol preset di `SettingsView.tsx`:
/// border tebal "ink" + centang bila terpilih, 1px "line" bila tidak.
class NwSwatch extends StatelessWidget {
  const NwSwatch({
    super.key,
    this.color,
    this.gradient,
    this.selected = false,
    this.tooltip,
    this.size = 36,
    this.onTap,
    this.child,
  });

  final Color? color;
  final Gradient? gradient;
  final bool selected;
  final String? tooltip;
  final double size;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<NwThemeExt>()!;

    Widget swatch = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? ext.ink : ext.line,
          width: selected ? 3 : 1,
        ),
      ),
      child:
          child ??
          (selected && color != null
              ? Icon(
                  Icons.check,
                  size: size * 0.45,
                  color: nwOnColorFor(color!),
                )
              : null),
    );

    swatch = Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: swatch,
      ),
    );

    if (tooltip != null) {
      swatch = Tooltip(message: tooltip!, child: swatch);
    }
    return swatch;
  }
}
