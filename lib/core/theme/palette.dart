import 'dart:math' as math;

import 'package:flutter/material.dart';

class NwColors {
  const NwColors({
    required this.bg,
    required this.card,
    required this.card2,
    required this.input,
    required this.ink,
    required this.muted,
    required this.line,
  });

  final Color bg;
  final Color card;
  final Color card2;
  final Color input;
  final Color ink;
  final Color muted;
  final Color line;

  static const NwColors light = NwColors(
    bg: Color(0xFFF7F4EE),
    card: Color(0xFFFFFFFF),
    card2: Color(0xFFEDE6D6),
    input: Color(0xFFFFFFFF),
    ink: Color(0xFF292524),
    muted: Color(0xFFA8A29E),
    line: Color(0xFFE8E1D4),
  );

  static const NwColors dark = NwColors(
    bg: Color(0xFF1C1917),
    card: Color(0xFF292524),
    card2: Color(0xFF35302C),
    input: Color(0xFF292524),
    ink: Color(0xFFF7F4EE),
    muted: Color(0xFFA8A29E),
    line: Color(0x1FF7F4EE),
  );
}

class NwSemantic {
  const NwSemantic({
    required this.green,
    required this.greenSoft,
    required this.amber,
    required this.amberSoft,
    required this.red,
    required this.redSoft,
    required this.violet,
    required this.violetSoft,
  });

  final Color green;
  final Color greenSoft;
  final Color amber;
  final Color amberSoft;
  final Color red;
  final Color redSoft;
  final Color violet;
  final Color violetSoft;

  static const NwSemantic light = NwSemantic(
    green: Color(0xFF16A34A),
    greenSoft: Color(0xFFDCFCE7),
    amber: Color(0xFFD97706),
    amberSoft: Color(0xFFFEF3C7),
    red: Color(0xFFDC2626),
    redSoft: Color(0xFFFEE2E2),
    violet: Color(0xFF7C5CFF),
    violetSoft: Color(0xFFEDE9FE),
  );

  static const NwSemantic dark = NwSemantic(
    green: Color(0xFF4ADE80),
    greenSoft: Color(0x244ADE80),
    amber: Color(0xFFFBBF24),
    amberSoft: Color(0x24FBBF24),
    red: Color(0xFFF87171),
    redSoft: Color(0x24F87171),
    violet: Color(0xFFA78BFA),
    violetSoft: Color(0x297C5CFF),
  );

  static NwSemantic of({required bool dark}) =>
      dark ? NwSemantic.dark : NwSemantic.light;
}

class NwPalette {
  const NwPalette._();

  static const Color accentDefaultLight = Color(0xFFB45309);
  static const Color accentDefaultDark = Color(0xFFD97706);

  static const String accentHexAmber = '#D97706';
  static const String accentHexBlue = '#1D4ED8';
  static const String accentHexGreen = '#15803D';
  static const String accentHexViolet = '#7C3AED';
  static const String accentHexRed = '#B91C1C';

  static const List<String> accentPresetHexes = <String>[
    accentHexAmber,
    accentHexBlue,
    accentHexGreen,
    accentHexViolet,
    accentHexRed,
  ];

  static const List<Color> routineColors = <Color>[
    Color(0xFFD97706),
    Color(0xFF16A34A),
    Color(0xFFB45309),
    Color(0xFF7C5CFF),
    Color(0xFFEC4899),
    Color(0xFFDC2626),
  ];

  static const List<Color> scheduleColors = <Color>[
    Color(0xFF16A34A),
    Color(0xFFD97706),
    Color(0xFFB45309),
    Color(0xFF7C5CFF),
    Color(0xFFEC4899),
    Color(0xFFDC2626),
  ];

  static const double cardRadius = 16;
  static const double inputRadius = 12;
  static const double sheetRadius = 24;
  static const double dialogRadius = 20;
  static const double heroRadius = 20;
  static const double appMarkRadius = 10;

  static const String uiFontFamily = 'Poppins';
  static const String monoFontFamily = 'JetBrainsMono';

  static const double monoFontSize = 12.5;

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFB45309), Color(0xFFD97706)],
  );

  static const List<BoxShadow> shadowLight = <BoxShadow>[
    BoxShadow(color: Color(0x0F0D0D0D), offset: Offset(0, 1), blurRadius: 2),
    BoxShadow(
      color: Color(0x2E0D0D0D),
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: -12,
    ),
  ];

  static const List<BoxShadow> shadowDark = <BoxShadow>[
    BoxShadow(color: Color(0x80000000), offset: Offset(0, 1), blurRadius: 2),
    BoxShadow(
      color: Color(0x99000000),
      offset: Offset(0, 12),
      blurRadius: 32,
      spreadRadius: -12,
    ),
  ];

  static List<BoxShadow> cardShadow({required bool dark}) =>
      dark ? shadowDark : shadowLight;
}

Color? nwParseHex(String? raw) {
  if (raw == null) {
    return null;
  }
  final match = RegExp(r'^#?([0-9a-fA-F]{6})$')
      .firstMatch(raw.trim().replaceAll('"', ''));
  if (match == null) {
    return null;
  }
  return Color(int.parse('FF${match.group(1)!}', radix: 16));
}

String? nwSanitizeHex(String? raw) {
  final color = nwParseHex(raw);
  return color == null ? null : nwToHex(color);
}

String nwToHex(Color color) {
  final rgb = color.toARGB32() & 0xFFFFFF;
  return '#${rgb.toRadixString(16).toUpperCase().padLeft(6, '0')}';
}

double nwLuminance(Color color) {
  double channel(double value) => value <= 0.03928
      ? value / 12.92
      : math.pow((value + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * channel(color.r) +
      0.7152 * channel(color.g) +
      0.0722 * channel(color.b);
}

Color nwMix(Color base, Color other, double t) {
  final u = t.clamp(0.0, 1.0).toDouble();
  return base.withValues(
    alpha: base.a + (other.a - base.a) * u,
    red: base.r + (other.r - base.r) * u,
    green: base.g + (other.g - base.g) * u,
    blue: base.b + (other.b - base.b) * u,
  );
}

Color nwOnColorFor(Color background) => nwLuminance(background) < 0.45
    ? const Color(0xFFFFFFFF)
    : const Color(0xFF0D0D0D);

class NwAccent {
  const NwAccent({
    required this.brand,
    required this.brandDark,
    required this.onBrand,
    required this.soft,
    required this.glow,
    required this.muted,
    required this.border,
  });

  final Color brand;
  final Color brandDark;
  final Color onBrand;
  final Color soft;
  final Color glow;
  final Color muted;
  final Color border;

  static NwAccent resolve(Color accent, {required bool isDark}) {
    var base = accent;
    if (isDark) {
      for (var i = 0; i < 5 && nwLuminance(base) < 0.18; i++) {
        base = nwMix(base, const Color(0xFFFFFFFF), 0.2);
      }
    }
    var main = base;
    if (!isDark) {
      for (var i = 0; i < 6 && nwLuminance(main) >= 0.45; i++) {
        main = nwMix(main, const Color(0xFF000000), 0.15);
      }
    }
    final brandDark = isDark
        ? base
        : nwMix(main, const Color(0xFF000000), 0.12);
    return NwAccent(
      brand: main,
      brandDark: brandDark,
      onBrand: nwOnColorFor(main),
      soft: main.withValues(alpha: 0.12),
      glow: main.withValues(alpha: 0.28),
      muted: main.withValues(alpha: 0.08),
      border: main.withValues(alpha: 0.35),
    );
  }
}
