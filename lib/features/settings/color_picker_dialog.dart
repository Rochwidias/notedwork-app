import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notedwork/core/theme/app_theme.dart';
import 'package:notedwork/core/theme/palette.dart';
import 'package:notedwork/features/settings/swatch.dart';
import 'package:notedwork/l10n/app_localizations.dart';

/// Dialog pemilih warna: preset + input hex + slider HSV.
/// Mengembalikan hex ter-sanitasi (`#RRGGBB`) atau null batal.
Future<String?> showNwColorPicker(
  BuildContext context, {
  required String title,
  required String initialHex,
  required List<String> presets,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => NwColorPickerDialog(
      title: title,
      initialHex: initialHex,
      presets: presets,
    ),
  );
}

class NwColorPickerDialog extends StatefulWidget {
  const NwColorPickerDialog({
    super.key,
    required this.title,
    required this.initialHex,
    required this.presets,
  });

  final String title;
  final String initialHex;
  final List<String> presets;

  @override
  State<NwColorPickerDialog> createState() => _NwColorPickerDialogState();
}

class _NwColorPickerDialogState extends State<NwColorPickerDialog> {
  late HSVColor _hsv;
  late final TextEditingController _hexCtrl;

  @override
  void initState() {
    super.initState();
    final start = nwParseHex(widget.initialHex) ?? const Color(0xFFD97706);
    _hsv = HSVColor.fromColor(start);
    _hexCtrl = TextEditingController(text: nwToHex(start));
  }

  @override
  void dispose() {
    _hexCtrl.dispose();
    super.dispose();
  }

  Color get _color => _hsv.toColor();

  String get _hex => nwToHex(_color);

  bool get _hexValid => nwParseHex(_hexCtrl.text) != null;

  void _applyHSV(HSVColor next) {
    setState(() {
      _hsv = next;
      _hexCtrl.text = nwToHex(next.toColor());
    });
  }

  void _applyHex(String raw) {
    final parsed = nwParseHex(raw);
    setState(() {
      if (parsed != null) {
        _hsv = HSVColor.fromColor(parsed);
      }
    });
  }

  Widget _slider({
    required String letter,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    final ext = Theme.of(context).extension<NwThemeExt>()!;
    return Row(
      children: <Widget>[
        SizedBox(
          width: 16,
          child: Text(
            letter,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              color: ext.muted,
              height: 1,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Slider(
            value: value,
            onChanged: onChanged,
            activeColor: _color,
            inactiveColor: ext.card2,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<NwThemeExt>()!;

    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _color,
                    shape: BoxShape.circle,
                    border: Border.all(color: ext.line),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _hexCtrl,
                    onChanged: _applyHex,
                    maxLength: 7,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 14,
                      color: ext.ink,
                      height: 1.4,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '#RRGGBB',
                      errorText: _hexValid ? null : '#RRGGBB',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (final hex in widget.presets)
                  NwSwatch(
                    size: 28,
                    tooltip: hex,
                    color: nwParseHex(hex),
                    selected: _hex == hex,
                    onTap: () {
                      final preset = nwParseHex(hex);
                      if (preset != null) {
                        _applyHSV(HSVColor.fromColor(preset));
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            _slider(
              letter: 'H',
              value: _hsv.hue,
              onChanged: (v) => _applyHSV(_hsv.withHue(v)),
            ),
            _slider(
              letter: 'S',
              value: _hsv.saturation,
              onChanged: (v) => _applyHSV(_hsv.withSaturation(v)),
            ),
            _slider(
              letter: 'V',
              value: _hsv.value,
              onChanged: (v) => _applyHSV(_hsv.withValue(v)),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.common_cancel),
        ),
        FilledButton(
          onPressed: _hexValid
              ? () => Navigator.of(context).pop(_hex)
              : null,
          child: Text(l10n.common_save),
        ),
      ],
    );
  }
}
