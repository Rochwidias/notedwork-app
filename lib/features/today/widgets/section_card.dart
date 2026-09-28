import 'package:flutter/material.dart';
import 'package:notedwork/core/dates.dart';
import 'package:notedwork/core/theme/palette.dart';
import 'package:notedwork/features/tasks/task_widgets.dart';

/// Warna badge per [BadgeKind] — padanan CSS `.pill.red/.amber/.green/.dim`
/// di web: telat/ hari ini = merah, besok = amber, nanti = hijau, selesai = dim.
({Color bg, Color fg, Color? border}) badgeStyleFor(
  BuildContext context,
  BadgeKind kind,
) {
  final nw = nwExt(context);
  final semantic = nwSemantic(context);
  return switch (kind) {
    BadgeKind.over || BadgeKind.hi => (
      bg: semantic.redSoft,
      fg: semantic.red,
      border: null,
    ),
    BadgeKind.md => (bg: semantic.amberSoft, fg: semantic.amber, border: null),
    BadgeKind.due => (
      bg: semantic.greenSoft,
      fg: semantic.green,
      border: null,
    ),
    BadgeKind.lo => (bg: nw.card2, fg: nw.muted, border: nw.line),
  };
}

/// Badge teks kecil berbentuk pil — padanan `.pill` di web.
class BadgePill extends StatelessWidget {
  const BadgePill({super.key, required this.text, required this.kind});

  final String text;
  final BadgeKind kind;

  @override
  Widget build(BuildContext context) {
    final style = badgeStyleFor(context, kind);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(999),
        border: style.border == null
            ? null
            : Border.all(color: style.border!),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: style.fg,
          height: 1.2,
        ),
      ),
    );
  }
}

/// Kartu mini "Hari Ini" — padanan `.card.mini` + `.card-head` di web
/// (radius 16, border tipis, judul 13px w800 + ikon kecil beraksen).
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.subtitle,
  });

  final String title;
  final IconData? icon;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final nw = nwExt(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: nw.card,
        border: Border.all(color: nw.line),
        borderRadius: BorderRadius.circular(nw.cardRadius),
        boxShadow: NwPalette.cardShadow(dark: dark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 15, color: nw.accent),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: nw.ink,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: nw.muted,
                  height: 1.4,
                ),
              ),
            ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

/// Status kosong — selalu membawa satu tombol aksi (aturan desain web).
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final nw = nwExt(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.5, color: nw.muted, height: 1.7),
          ),
        ),
        FilledButton(onPressed: onAction, child: Text(actionLabel)),
      ],
    );
  }
}
