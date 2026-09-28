import 'package:flutter/material.dart';

import 'palette.dart';

enum ThemeModeOption {
  light,
  dark,
  auto;

  ThemeMode get themeMode => switch (this) {
    ThemeModeOption.light => ThemeMode.light,
    ThemeModeOption.dark => ThemeMode.dark,
    ThemeModeOption.auto => ThemeMode.system,
  };

  Brightness resolveBrightness(Brightness systemBrightness) => switch (this) {
    ThemeModeOption.light => Brightness.light,
    ThemeModeOption.dark => Brightness.dark,
    ThemeModeOption.auto => systemBrightness,
  };

  Map<String, dynamic> toMap() => <String, dynamic>{'name': name};

  static ThemeModeOption fromName(
    Object? value, {
    ThemeModeOption fallback = ThemeModeOption.auto,
  }) => ThemeModeOption.values.asNameMap()[value?.toString()] ?? fallback;

  static ThemeModeOption fromMap(
    Object? map, {
    ThemeModeOption fallback = ThemeModeOption.auto,
  }) {
    if (map is Map) {
      return fromName(
        map['name'] ?? map['mode'] ?? map['value'],
        fallback: fallback,
      );
    }
    return fromName(map, fallback: fallback);
  }
}

enum AccentPreset {
  amber(NwPalette.accentHexAmber),
  blue(NwPalette.accentHexBlue),
  green(NwPalette.accentHexGreen),
  violet(NwPalette.accentHexViolet),
  red(NwPalette.accentHexRed);

  const AccentPreset(this.hex);

  final String hex;

  Color get color => nwParseHex(hex)!;

  Map<String, dynamic> toMap() => <String, dynamic>{'name': name, 'hex': hex};

  static AccentPreset? fromName(Object? value) =>
      AccentPreset.values.asNameMap()[value?.toString()];

  static AccentPreset? fromHex(String? hex) {
    final normalized = nwSanitizeHex(hex);
    if (normalized == null) {
      return null;
    }
    for (final preset in AccentPreset.values) {
      if (preset.hex.toUpperCase() == normalized) {
        return preset;
      }
    }
    return null;
  }

  static AccentPreset? fromMap(Object? map) {
    if (map is Map) {
      return fromName(map['name'] ?? map['preset']) ??
          fromHex(map['hex']?.toString());
    }
    if (map is String) {
      return fromName(map) ?? fromHex(map);
    }
    return null;
  }
}

class ThemeConfig {
  const ThemeConfig({
    this.mode = ThemeModeOption.auto,
    this.accentPreset,
    this.customAccentHex,
    this.customTextHex,
    this.customBgHex,
  });

  static const Object _keep = Object();

  static const ThemeConfig defaults = ThemeConfig();

  final ThemeModeOption mode;
  final AccentPreset? accentPreset;
  final String? customAccentHex;
  final String? customTextHex;
  final String? customBgHex;

  String? get resolvedAccentHex {
    final custom = nwSanitizeHex(customAccentHex);
    if (custom != null) {
      return custom;
    }
    return accentPreset?.hex;
  }

  Color? get customAccentColor => nwParseHex(customAccentHex);
  Color? get customTextColor => nwParseHex(customTextHex);
  Color? get customBgColor => nwParseHex(customBgHex);

  Brightness resolveBrightness(Brightness systemBrightness) =>
      mode.resolveBrightness(systemBrightness);

  ThemeConfig copyWith({
    Object? mode = _keep,
    Object? accentPreset = _keep,
    Object? customAccentHex = _keep,
    Object? customTextHex = _keep,
    Object? customBgHex = _keep,
  }) {
    return ThemeConfig(
      mode: identical(mode, _keep) ? this.mode : mode as ThemeModeOption,
      accentPreset: identical(accentPreset, _keep)
          ? this.accentPreset
          : accentPreset as AccentPreset?,
      customAccentHex: identical(customAccentHex, _keep)
          ? this.customAccentHex
          : customAccentHex as String?,
      customTextHex: identical(customTextHex, _keep)
          ? this.customTextHex
          : customTextHex as String?,
      customBgHex: identical(customBgHex, _keep)
          ? this.customBgHex
          : customBgHex as String?,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    'mode': mode.name,
    'accentPreset': accentPreset?.name,
    'customAccentHex': customAccentHex,
    'customTextHex': customTextHex,
    'customBgHex': customBgHex,
  };

  static ThemeConfig fromMap(Map<Object?, Object?>? map) {
    if (map == null) {
      return defaults;
    }
    return ThemeConfig(
      mode: ThemeModeOption.fromName(map['mode']),
      accentPreset: AccentPreset.fromName(map['accentPreset']),
      customAccentHex: nwSanitizeHex(map['customAccentHex']?.toString()),
      customTextHex: nwSanitizeHex(map['customTextHex']?.toString()),
      customBgHex: nwSanitizeHex(map['customBgHex']?.toString()),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ThemeConfig &&
          other.mode == mode &&
          other.accentPreset == accentPreset &&
          other.customAccentHex == customAccentHex &&
          other.customTextHex == customTextHex &&
          other.customBgHex == customBgHex);

  @override
  int get hashCode => Object.hash(
    mode,
    accentPreset,
    customAccentHex,
    customTextHex,
    customBgHex,
  );
}
