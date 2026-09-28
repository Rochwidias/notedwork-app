import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notedwork/core/models.dart';
import 'package:notedwork/core/notifications/notification_service.dart';
import 'package:notedwork/core/state/state.dart';
import 'package:notedwork/core/theme/app_theme.dart';
import 'package:notedwork/core/theme/palette.dart';
import 'package:notedwork/core/theme/theme_config.dart';
import 'package:notedwork/features/settings/color_picker_dialog.dart';
import 'package:notedwork/features/settings/legal.dart';
import 'package:notedwork/features/settings/legal_screen.dart';
import 'package:notedwork/features/settings/swatch.dart';
import 'package:notedwork/l10n/app_localizations.dart';

/// Preset warna font selaras logo (porting `FONT_PRESETS` dari ThemeProvider).
const List<String> _fontPresets = <String>[
  '#F8FAFC',
  '#FBBF24',
  '#94A3B8',
  '#0D0D0D',
];

/// Preset warna latar selaras logo (porting `BG_PRESETS` dari ThemeProvider).
const List<String> _bgPresets = <String>[
  '#0A0C10',
  '#161922',
  '#F7F4EE',
  '#FFFFFF',
];

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _askedNotifPermission = false;

  void _openLegal(BuildContext context, WidgetRef ref, LegalId id) {
    final doc = legalDoc(id, ref.read(settingsProvider).lang);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LegalScreen(title: doc.title, doc: doc),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final cfg = settings.theme;
    final ext = Theme.of(context).extension<NwThemeExt>()!;
    final notifier = ref.read(settingsProvider.notifier);
    final dark =
        cfg.mode.resolveBrightness(
              MediaQuery.platformBrightnessOf(context),
            ) ==
            Brightness.dark;
    final modeLabel = l10n.settings_forMode(
      (dark ? l10n.settings_dark : l10n.settings_light).toLowerCase(),
    );
    final accentHex = cfg.resolvedAccentHex ?? AccentPreset.amber.hex;
    final accentIsCustom =
        cfg.customAccentHex != null &&
        AccentPreset.fromHex(cfg.customAccentHex) == null;

    void pickAccent(String? hex) {
      if (hex == null) {
        notifier.setTheme(
          cfg.copyWith(accentPreset: null, customAccentHex: null),
        );
        return;
      }
      final preset = AccentPreset.fromHex(hex);
      notifier.setTheme(
        cfg.copyWith(
          accentPreset: preset,
          customAccentHex: preset == null ? hex : null,
        ),
      );
    }

    Widget setRow({
      required IconData icon,
      required String title,
      String? sub,
      Widget? trailing,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(icon, size: 15, color: ext.muted),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ext.ink,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (sub != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 23, top: 2),
                      child: Text(
                        sub,
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          color: ext.muted,
                          height: 1.45,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) ...<Widget>[const SizedBox(width: 8), trailing],
          ],
        ),
      );
    }

    Widget sectionCard({
      required IconData icon,
      required String title,
      required List<Widget> children,
    }) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: ext.accentSoft,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(icon, size: 16, color: ext.accent),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: ext.ink,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      );
    }

    Widget swatchRow({
      required List<String> presets,
      required String? value,
      required String dialogTitle,
      required ValueChanged<String?> onPick,
      String? label,
    }) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          for (final hex in presets)
            NwSwatch(
              tooltip: hex,
              color: nwParseHex(hex),
              selected: value == hex,
              onTap: () => onPick(hex),
            ),
          NwSwatch(
            tooltip: l10n.settings_customColor,
            gradient: nwRainbowGradient,
            selected: value != null && !presets.contains(value),
            child: const Icon(Icons.palette, size: 16, color: Colors.white),
            onTap: () async {
              final picked = await showNwColorPicker(
                context,
                title: dialogTitle,
                initialHex: value ?? presets.first,
                presets: presets,
              );
              if (picked != null) {
                onPick(picked);
              }
            },
          ),
          if (label != null)
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 12.5, color: ext.muted),
            ),
          if (value != null)
            TextButton(
              onPressed: () => onPick(null),
              child: Text(l10n.settings_reset),
            ),
        ],
      );
    }

    Widget languageRow(Lang target, String label) {
      final selected = settings.lang == target;
      return InkWell(
        onTap: () => notifier.setLang(target),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ext.ink,
                    height: 1.4,
                  ),
                ),
              ),
              if (selected)
                Icon(Icons.check, size: 18, color: ext.accent),
            ],
          ),
        ),
      );
    }

    Widget infoRow({
      required IconData icon,
      required String title,
      required String sub,
      required LegalId legalId,
    }) {
      return InkWell(
        onTap: () => _openLegal(context, ref, legalId),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: setRow(
            icon: icon,
            title: title,
            sub: sub,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  l10n.settings_open,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: ext.accent,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(Icons.chevron_right, size: 18, color: ext.muted),
              ],
            ),
          ),
        ),
      );
    }

    final bodyStyle = GoogleFonts.poppins(
      fontSize: 13.5,
      color: ext.muted,
      height: 1.7,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings_title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: <Widget>[
          // ── Galeri Tema ─────────────────────────────────────────────
          sectionCard(
            icon: Icons.settings_outlined,
            title: l10n.settings_themeGallery,
            children: <Widget>[
              setRow(
                icon: Icons.dark_mode_outlined,
                title: l10n.settings_appearance,
                sub: l10n.settings_appearanceSub,
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  for (final mode in ThemeModeOption.values)
                    ChoiceChip(
                      label: Text(switch (mode) {
                        ThemeModeOption.light => l10n.settings_light,
                        ThemeModeOption.dark => l10n.settings_dark,
                        ThemeModeOption.auto => l10n.settings_auto,
                      }),
                      selected: cfg.mode == mode,
                      onSelected: (_) =>
                          notifier.setTheme(cfg.copyWith(mode: mode)),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              setRow(
                icon: Icons.palette_outlined,
                title: l10n.settings_accentColor,
                sub: l10n.settings_accentSub,
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  for (final preset in AccentPreset.values)
                    NwSwatch(
                      tooltip: preset.hex,
                      color: preset.color,
                      selected: accentHex == preset.hex,
                      onTap: () => pickAccent(preset.hex),
                    ),
                  NwSwatch(
                    tooltip: l10n.settings_customColor,
                    gradient: nwRainbowGradient,
                    selected: accentIsCustom,
                    child:
                        const Icon(Icons.palette, size: 16, color: Colors.white),
                    onTap: () async {
                      final picked = await showNwColorPicker(
                        context,
                        title: l10n.settings_accentColor,
                        initialHex: accentHex,
                        presets: <String>[
                          for (final preset in AccentPreset.values)
                            preset.hex,
                        ],
                      );
                      if (picked != null) {
                        pickAccent(picked);
                      }
                    },
                  ),
                  if (accentHex != AccentPreset.amber.hex)
                    TextButton(
                      onPressed: () => pickAccent(null),
                      child: Text(l10n.settings_reset),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              setRow(
                icon: Icons.format_color_text_outlined,
                title: l10n.settings_fontColor,
                sub: l10n.settings_fontColorSub,
              ),
              const SizedBox(height: 4),
              swatchRow(
                presets: _fontPresets,
                value: cfg.customTextHex,
                dialogTitle: l10n.settings_fontColor,
                label: modeLabel,
                onPick: (hex) => notifier.setTheme(
                  cfg.copyWith(customTextHex: hex),
                ),
              ),
              const SizedBox(height: 14),
              setRow(
                icon: Icons.wallpaper_outlined,
                title: l10n.settings_bgColor,
                sub: l10n.settings_bgColorSub,
              ),
              const SizedBox(height: 4),
              swatchRow(
                presets: _bgPresets,
                value: cfg.customBgHex,
                dialogTitle: l10n.settings_bgColor,
                label: modeLabel,
                onPick: (hex) => notifier.setTheme(
                  cfg.copyWith(customBgHex: hex),
                ),
              ),
              const SizedBox(height: 10),
              languageRow(Lang.id, l10n.topbar_langToId),
              languageRow(Lang.en, l10n.topbar_langToEn),
            ],
          ),
          const SizedBox(height: 14),

          // ── Pengingat ───────────────────────────────────────────────
          sectionCard(
            icon: Icons.notifications_outlined,
            title: l10n.settings_reminderTitle,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      l10n.settings_reminderSub,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: ext.muted,
                        height: 1.5,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => NotificationService.test(),
                    child: Text(l10n.settings_testNotif),
                  ),
                  Switch(
                    value: settings.remindersOn,
                    onChanged: (v) {
                      if (v && !_askedNotifPermission) {
                        _askedNotifPermission = true;
                        NotificationService.requestPermissions();
                      }
                      notifier.setRemindersOn(v);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Info ────────────────────────────────────────────────────
          sectionCard(
            icon: Icons.info_outline,
            title: l10n.settings_info,
            children: <Widget>[
              infoRow(
                icon: Icons.star_outline,
                title: l10n.settings_credit,
                sub: l10n.settings_creditSub,
                legalId: LegalId.credit,
              ),
              infoRow(
                icon: Icons.shield_outlined,
                title: l10n.settings_privacy,
                sub: l10n.settings_privacySub,
                legalId: LegalId.privacy,
              ),
              infoRow(
                icon: Icons.description_outlined,
                title: l10n.settings_terms,
                sub: l10n.settings_termsSub,
                legalId: LegalId.terms,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Tentang ─────────────────────────────────────────────────
          sectionCard(
            icon: Icons.info_outline,
            title: l10n.settings_about,
            children: <Widget>[
              Text(l10n.settings_aboutBody1, style: bodyStyle),
              Text(l10n.settings_aboutBody2, style: bodyStyle),
              Text(l10n.settings_copyright, style: bodyStyle),
            ],
          ),
        ],
      ),
    );
  }
}
