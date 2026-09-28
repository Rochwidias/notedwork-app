import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notedwork/core/theme/app_theme.dart';
import 'package:notedwork/features/settings/legal.dart';

/// Halaman dokumen hukum (Kredit / Privasi / Syarat) — route yang di-push,
/// punya Scaffold + AppBar sendiri. Tipografi mengikuti `app/privasi/page.tsx`
/// dan `app/syarat/page.tsx` (label "notedwork", judul 26px w800, tanggal
/// update 13px, paragraf 15px line-height 1.8).
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.title, required this.doc});

  final String title;
  final LegalDoc doc;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<NwThemeExt>()!;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'notedwork',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: ext.muted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doc.title,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: ext.ink,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doc.updated,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: ext.muted,
                    height: 1.5,
                  ),
                ),
                for (final paragraph in doc.body)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      paragraph,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: ext.ink,
                        height: 1.8,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
