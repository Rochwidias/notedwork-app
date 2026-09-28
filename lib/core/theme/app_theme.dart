import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'palette.dart';
import 'theme_config.dart';

class NwThemeExt extends ThemeExtension<NwThemeExt> {
  const NwThemeExt({
    required this.accent,
    required this.accentDark,
    required this.onAccent,
    required this.accentSoft,
    required this.accentGlow,
    required this.accentMuted,
    required this.borderAccent,
    required this.bg,
    required this.card,
    required this.card2,
    required this.input,
    required this.ink,
    required this.muted,
    required this.line,
    this.customTextColor,
    this.customBgColor,
    this.cardRadius = NwPalette.cardRadius,
    this.inputRadius = NwPalette.inputRadius,
    this.sheetRadius = NwPalette.sheetRadius,
    this.dialogRadius = NwPalette.dialogRadius,
    this.heroRadius = NwPalette.heroRadius,
    this.appMarkRadius = NwPalette.appMarkRadius,
    this.uiFont = NwPalette.uiFontFamily,
    this.monoFont = NwPalette.monoFontFamily,
    this.heroGradient = NwPalette.heroGradient,
  });

  static const Object _keep = Object();

  final Color accent;
  final Color accentDark;
  final Color onAccent;
  final Color accentSoft;
  final Color accentGlow;
  final Color accentMuted;
  final Color borderAccent;

  final Color bg;
  final Color card;
  final Color card2;
  final Color input;
  final Color ink;
  final Color muted;
  final Color line;

  final Color? customTextColor;
  final Color? customBgColor;

  final double cardRadius;
  final double inputRadius;
  final double sheetRadius;
  final double dialogRadius;
  final double heroRadius;
  final double appMarkRadius;

  final String uiFont;
  final String monoFont;

  final LinearGradient heroGradient;

  factory NwThemeExt.defaults({
    required Brightness brightness,
    Color? accent,
    Color? customTextColor,
    Color? customBgColor,
  }) {
    final dark = brightness == Brightness.dark;
    final base = dark ? NwColors.dark : NwColors.light;
    final accentColor =
        accent ??
        (dark ? NwPalette.accentDefaultDark : NwPalette.accentDefaultLight);
    final resolved = NwAccent.resolve(accentColor, isDark: dark);

    final ink = customTextColor ?? base.ink;
    final bg = customBgColor ?? base.bg;

    final Color card;
    final Color card2;
    final Color input;
    final Color line;
    if (customBgColor != null) {
      card = nwMix(bg, ink, 0.08);
      card2 = nwMix(bg, ink, 0.14);
      input = nwMix(bg, ink, 0.08);
      line = nwMix(bg, ink, 0.20);
    } else {
      card = base.card;
      card2 = base.card2;
      input = base.input;
      line = base.line;
    }
    final muted = customTextColor != null ? nwMix(ink, bg, 0.38) : base.muted;

    return NwThemeExt(
      accent: resolved.brand,
      accentDark: resolved.brandDark,
      onAccent: resolved.onBrand,
      accentSoft: resolved.soft,
      accentGlow: resolved.glow,
      accentMuted: resolved.muted,
      borderAccent: resolved.border,
      bg: bg,
      card: card,
      card2: card2,
      input: input,
      ink: ink,
      muted: muted,
      line: line,
      customTextColor: customTextColor,
      customBgColor: customBgColor,
    );
  }

  factory NwThemeExt.fromConfig(
    ThemeConfig config, {
    required Brightness systemBrightness,
  }) {
    final accentHex = config.resolvedAccentHex;
    return NwThemeExt.defaults(
      brightness: config.resolveBrightness(systemBrightness),
      accent: accentHex == null ? null : nwParseHex(accentHex),
      customTextColor: config.customTextColor,
      customBgColor: config.customBgColor,
    );
  }

  @override
  NwThemeExt copyWith({
    Color? accent,
    Color? accentDark,
    Color? onAccent,
    Color? accentSoft,
    Color? accentGlow,
    Color? accentMuted,
    Color? borderAccent,
    Color? bg,
    Color? card,
    Color? card2,
    Color? input,
    Color? ink,
    Color? muted,
    Color? line,
    Object? customTextColor = _keep,
    Object? customBgColor = _keep,
    double? cardRadius,
    double? inputRadius,
    double? sheetRadius,
    double? dialogRadius,
    double? heroRadius,
    double? appMarkRadius,
    String? uiFont,
    String? monoFont,
    LinearGradient? heroGradient,
  }) {
    return NwThemeExt(
      accent: accent ?? this.accent,
      accentDark: accentDark ?? this.accentDark,
      onAccent: onAccent ?? this.onAccent,
      accentSoft: accentSoft ?? this.accentSoft,
      accentGlow: accentGlow ?? this.accentGlow,
      accentMuted: accentMuted ?? this.accentMuted,
      borderAccent: borderAccent ?? this.borderAccent,
      bg: bg ?? this.bg,
      card: card ?? this.card,
      card2: card2 ?? this.card2,
      input: input ?? this.input,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      line: line ?? this.line,
      customTextColor: identical(customTextColor, _keep)
          ? this.customTextColor
          : customTextColor as Color?,
      customBgColor: identical(customBgColor, _keep)
          ? this.customBgColor
          : customBgColor as Color?,
      cardRadius: cardRadius ?? this.cardRadius,
      inputRadius: inputRadius ?? this.inputRadius,
      sheetRadius: sheetRadius ?? this.sheetRadius,
      dialogRadius: dialogRadius ?? this.dialogRadius,
      heroRadius: heroRadius ?? this.heroRadius,
      appMarkRadius: appMarkRadius ?? this.appMarkRadius,
      uiFont: uiFont ?? this.uiFont,
      monoFont: monoFont ?? this.monoFont,
      heroGradient: heroGradient ?? this.heroGradient,
    );
  }

  @override
  NwThemeExt lerp(ThemeExtension<NwThemeExt>? other, double t) {
    if (other is! NwThemeExt) {
      return this;
    }
    final gradient = Gradient.lerp(heroGradient, other.heroGradient, t);
    return NwThemeExt(
      accent: Color.lerp(accent, other.accent, t)!,
      accentDark: Color.lerp(accentDark, other.accentDark, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      accentGlow: Color.lerp(accentGlow, other.accentGlow, t)!,
      accentMuted: Color.lerp(accentMuted, other.accentMuted, t)!,
      borderAccent: Color.lerp(borderAccent, other.borderAccent, t)!,
      bg: Color.lerp(bg, other.bg, t)!,
      card: Color.lerp(card, other.card, t)!,
      card2: Color.lerp(card2, other.card2, t)!,
      input: Color.lerp(input, other.input, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      line: Color.lerp(line, other.line, t)!,
      customTextColor: Color.lerp(customTextColor, other.customTextColor, t),
      customBgColor: Color.lerp(customBgColor, other.customBgColor, t),
      cardRadius: _lerpDouble(cardRadius, other.cardRadius, t),
      inputRadius: _lerpDouble(inputRadius, other.inputRadius, t),
      sheetRadius: _lerpDouble(sheetRadius, other.sheetRadius, t),
      dialogRadius: _lerpDouble(dialogRadius, other.dialogRadius, t),
      heroRadius: _lerpDouble(heroRadius, other.heroRadius, t),
      appMarkRadius: _lerpDouble(appMarkRadius, other.appMarkRadius, t),
      uiFont: t < 0.5 ? uiFont : other.uiFont,
      monoFont: t < 0.5 ? monoFont : other.monoFont,
      heroGradient: gradient is LinearGradient
          ? gradient
          : (t < 0.5 ? heroGradient : other.heroGradient),
    );
  }

  TextStyle monoStyle({
    double fontSize = NwPalette.monoFontSize,
    FontWeight fontWeight = FontWeight.w500,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? ink,
      height: height ?? 1.6,
      letterSpacing: letterSpacing,
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NwThemeExt &&
          other.accent == accent &&
          other.accentDark == accentDark &&
          other.onAccent == onAccent &&
          other.accentSoft == accentSoft &&
          other.accentGlow == accentGlow &&
          other.accentMuted == accentMuted &&
          other.borderAccent == borderAccent &&
          other.bg == bg &&
          other.card == card &&
          other.card2 == card2 &&
          other.input == input &&
          other.ink == ink &&
          other.muted == muted &&
          other.line == line &&
          other.customTextColor == customTextColor &&
          other.customBgColor == customBgColor &&
          other.cardRadius == cardRadius &&
          other.inputRadius == inputRadius &&
          other.sheetRadius == sheetRadius &&
          other.dialogRadius == dialogRadius &&
          other.heroRadius == heroRadius &&
          other.appMarkRadius == appMarkRadius &&
          other.uiFont == uiFont &&
          other.monoFont == monoFont &&
          other.heroGradient == heroGradient);

  @override
  int get hashCode => Object.hashAll(<Object?>[
    accent,
    accentDark,
    onAccent,
    accentSoft,
    accentGlow,
    accentMuted,
    borderAccent,
    bg,
    card,
    card2,
    input,
    ink,
    muted,
    line,
    customTextColor,
    customBgColor,
    cardRadius,
    inputRadius,
    sheetRadius,
    dialogRadius,
    heroRadius,
    appMarkRadius,
    uiFont,
    monoFont,
    heroGradient,
  ]);
}

class AppTheme {
  const AppTheme._();

  static ThemeData light({NwThemeExt? ext}) => _build(
    ext ?? NwThemeExt.defaults(brightness: Brightness.light),
    Brightness.light,
  );

  static ThemeData dark({NwThemeExt? ext}) => _build(
    ext ?? NwThemeExt.defaults(brightness: Brightness.dark),
    Brightness.dark,
  );

  static ThemeData forConfig(
    ThemeConfig config, {
    required Brightness systemBrightness,
  }) {
    final brightness = config.resolveBrightness(systemBrightness);
    return _build(
      NwThemeExt.fromConfig(config, systemBrightness: systemBrightness),
      brightness,
    );
  }

  static ThemeData _build(NwThemeExt ext, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final semantic = NwSemantic.of(dark: dark);
    final shadow = dark ? const Color(0x99000000) : const Color(0x2E0D0D0D);
    final textTheme = _textTheme(ext);
    final onAccentTextTheme = _textTheme(
      ext,
      color: ext.onAccent,
      mutedColor: ext.onAccent,
    );

    final scheme = ColorScheme.fromSeed(
      seedColor: dark
          ? NwPalette.accentDefaultDark
          : NwPalette.accentDefaultLight,
      brightness: brightness,
      primary: ext.accent,
      onPrimary: ext.onAccent,
      primaryContainer: ext.accentSoft,
      onPrimaryContainer: ext.accentDark,
      secondary: ext.accent,
      onSecondary: ext.onAccent,
      secondaryContainer: ext.accentSoft,
      onSecondaryContainer: ext.accentDark,
      tertiary: ext.accent,
      onTertiary: ext.onAccent,
      tertiaryContainer: ext.accentSoft,
      onTertiaryContainer: ext.accentDark,
      error: semantic.red,
      onError: nwOnColorFor(semantic.red),
      errorContainer: semantic.redSoft,
      onErrorContainer: semantic.red,
      surface: ext.bg,
      onSurface: ext.ink,
      surfaceDim: ext.bg,
      surfaceBright: ext.card,
      surfaceContainerLowest: ext.bg,
      surfaceContainerLow: ext.card,
      surfaceContainer: ext.card,
      surfaceContainerHigh: ext.card2,
      surfaceContainerHighest: ext.card2,
      onSurfaceVariant: ext.muted,
      outline: ext.line,
      outlineVariant: ext.line,
      inverseSurface: ext.ink,
      onInverseSurface: ext.bg,
      inversePrimary: ext.accent,
      shadow: const Color(0xFF000000),
      scrim: const Color(0x99000000),
      surfaceTint: Colors.transparent,
    );

    OutlineInputBorder inputBorder(Color color, {double width = 1}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(ext.inputRadius),
        borderSide: BorderSide(color: color, width: width),
        gapPadding: 4,
      );
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: ext.uiFont,
      extensions: <ThemeExtension<dynamic>>[ext],
      scaffoldBackgroundColor: ext.bg,
      canvasColor: ext.card,
      cardColor: ext.card,
      dividerColor: ext.line,
      disabledColor: ext.ink.withValues(alpha: 0.38),
      hintColor: ext.muted,
      hoverColor: ext.accentGlow,
      focusColor: ext.accentMuted,
      highlightColor: ext.accentMuted,
      splashColor: ext.accentMuted,
      shadowColor: shadow,
      primaryColor: ext.accent,
      iconTheme: IconThemeData(color: ext.muted, size: 24),
      primaryIconTheme: IconThemeData(color: ext.onAccent, size: 24),
      textTheme: textTheme,
      primaryTextTheme: onAccentTextTheme,
      fontFamilyFallback: const <String>['Segoe UI', 'Roboto', 'sans-serif'],
      appBarTheme: AppBarThemeData(
        backgroundColor: ext.bg,
        foregroundColor: ext.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: ext.ink, size: 22),
        actionsIconTheme: IconThemeData(color: ext.ink, size: 22),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: ext.ink,
          height: 1.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: ext.card,
        surfaceTintColor: Colors.transparent,
        elevation: dark ? 0 : 1,
        shadowColor: shadow,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ext.cardRadius),
          side: BorderSide(color: ext.line),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: ext.card,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shadowColor: shadow,
        barrierColor: Colors.black.withValues(alpha: 0.32),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ext.dialogRadius),
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: ext.ink,
          height: 1.3,
        ),
        contentTextStyle: textTheme.bodyMedium,
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        iconColor: ext.muted,
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: ext.input,
        isDense: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ext.muted,
          height: 1.5,
        ),
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ext.muted,
          height: 1.5,
        ),
        floatingLabelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: ext.accent,
          height: 1.5,
        ),
        errorStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: semantic.red,
          height: 1.4,
        ),
        iconColor: ext.muted,
        prefixIconColor: ext.muted,
        suffixIconColor: ext.muted,
        border: inputBorder(ext.line),
        enabledBorder: inputBorder(ext.line),
        focusedBorder: inputBorder(ext.accent, width: 1.5),
        errorBorder: inputBorder(semantic.red),
        focusedErrorBorder: inputBorder(semantic.red, width: 1.5),
        disabledBorder: inputBorder(ext.line),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ext.accent,
          foregroundColor: ext.onAccent,
          disabledBackgroundColor: ext.accent.withValues(alpha: 0.38),
          disabledForegroundColor: ext.onAccent.withValues(alpha: 0.38),
          elevation: 0,
          minimumSize: const Size(72, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          shape: const StadiumBorder(),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ext.accentSoft,
          foregroundColor: ext.accentDark,
          disabledBackgroundColor: ext.accentSoft.withValues(alpha: 0.5),
          disabledForegroundColor: ext.accentDark.withValues(alpha: 0.4),
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: const Size(72, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          shape: const StadiumBorder(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: ext.card,
          foregroundColor: ext.ink,
          disabledForegroundColor: ext.muted,
          elevation: 0,
          minimumSize: const Size(72, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: BorderSide(color: ext.line),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          shape: const StadiumBorder(),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ext.accent,
          disabledForegroundColor: ext.muted,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          shape: const StadiumBorder(),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: ext.card,
        selectedColor: ext.accent,
        disabledColor: ext.card2,
        labelStyle: GoogleFonts.poppins(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: ext.muted,
          height: 1.2,
        ),
        secondaryLabelStyle: GoogleFonts.poppins(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: ext.onAccent,
          height: 1.2,
        ),
        side: BorderSide(color: ext.line),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        labelPadding: EdgeInsets.zero,
        iconTheme: IconThemeData(color: ext.muted, size: 16),
        showCheckmark: false,
        checkmarkColor: ext.onAccent,
        deleteIconColor: ext.muted,
        elevation: 0,
        pressElevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        backgroundColor: ext.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: ext.accentSoft,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((
          Set<WidgetState> states,
        ) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.poppins(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: selected ? ext.accent : ext.muted,
            height: 1.2,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
          Set<WidgetState> states,
        ) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? ext.accent : ext.muted,
            size: 24,
          );
        }),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: ext.card,
        modalBackgroundColor: ext.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: dark ? 0 : 6,
        shadowColor: shadow,
        modalBarrierColor: Colors.black.withValues(alpha: 0.32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ext.sheetRadius),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        showDragHandle: true,
        dragHandleColor: ext.muted,
        dragHandleSize: const Size(32, 4),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ext.ink,
        contentTextStyle: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: ext.bg,
          height: 1.4,
        ),
        actionTextColor: ext.onAccent,
        closeIconColor: ext.onAccent.withValues(alpha: 0.7),
        behavior: SnackBarBehavior.floating,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      dividerTheme: DividerThemeData(color: ext.line, thickness: 1, space: 1),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        iconColor: ext.muted,
        textColor: ext.ink,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: ext.ink,
          height: 1.4,
        ),
        subtitleTextStyle: GoogleFonts.poppins(
          fontSize: 12.5,
          fontWeight: FontWeight.w400,
          color: ext.muted,
          height: 1.4,
        ),
        leadingAndTrailingTextStyle: GoogleFonts.poppins(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: ext.muted,
          height: 1.4,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minVerticalPadding: 8,
        horizontalTitleGap: 12,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return ext.accent;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all<Color?>(ext.onAccent),
        side: BorderSide(color: ext.line, width: 1.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return ext.onAccent;
          }
          return ext.muted;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return ext.accent;
          }
          return ext.card2;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return ext.accent;
          }
          return ext.line;
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ext.accent,
        foregroundColor: ext.onAccent,
        elevation: 3,
        focusElevation: 4,
        hoverElevation: 4,
        highlightElevation: 4,
        iconSize: 26,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: ext.accent,
        linearTrackColor: ext.accentMuted,
        circularTrackColor: ext.accentMuted,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: ext.card,
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        shadowColor: shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: ext.line),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ext.ink,
          height: 1.4,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: ext.accent,
        selectionColor: ext.accentGlow,
        selectionHandleColor: ext.accent,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: ext.ink,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: ext.bg,
          height: 1.3,
        ),
        waitDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  static TextTheme _textTheme(
    NwThemeExt ext, {
    Color? color,
    Color? mutedColor,
  }) {
    final ink = color ?? ext.ink;
    final muted = mutedColor ?? ext.muted;

    TextStyle ui(
      double fontSize, {
      FontWeight fontWeight = FontWeight.w400,
      Color? textColor,
      double? height,
      double? letterSpacing,
    }) {
      return GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: textColor ?? ink,
        height: height,
        letterSpacing: letterSpacing,
      );
    }

    return TextTheme(
      displaySmall: ui(
        34,
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -0.5,
      ),
      headlineMedium: ui(
        26,
        fontWeight: FontWeight.w800,
        height: 1.15,
        letterSpacing: -0.4,
      ),
      headlineSmall: ui(
        24,
        fontWeight: FontWeight.w800,
        height: 1.2,
        letterSpacing: -0.3,
      ),
      titleLarge: ui(
        22,
        fontWeight: FontWeight.w800,
        height: 1.25,
        letterSpacing: -0.2,
      ),
      titleMedium: ui(16, fontWeight: FontWeight.w700, height: 1.4),
      titleSmall: ui(15, fontWeight: FontWeight.w800, height: 1.35),
      bodyLarge: ui(16, height: 1.6),
      bodyMedium: ui(14, height: 1.6),
      bodySmall: ui(12.5, textColor: muted, height: 1.5),
      labelLarge: ui(14, fontWeight: FontWeight.w700, height: 1.2),
      labelMedium: ui(12.5, fontWeight: FontWeight.w700, height: 1.2),
      labelSmall: ui(
        11.5,
        fontWeight: FontWeight.w700,
        textColor: muted,
        height: 1.2,
      ),
    );
  }
}
