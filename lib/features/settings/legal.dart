import 'package:notedwork/core/models.dart';

/// Jenis dokumen hukum — porting dari `lib/legal.ts` (`LegalId`).
enum LegalId { credit, privacy, terms }

/// Struktur dokumen hukum — porting dari `LegalDoc` di `lib/legal.ts`.
class LegalDoc {
  const LegalDoc({
    required this.title,
    required this.updated,
    required this.body,
  });

  final String title;
  final String updated;
  final List<String> body;
}

const Map<LegalId, LegalDoc> _legalId = <LegalId, LegalDoc>{
  LegalId.credit: LegalDoc(
    title: 'Kredit',
    updated: 'notedwork • 2026',
    body: <String>[
      'notedwork adalah dashboard email, tugas & kalender untuk mahasiswa — dibuat sebagai proyek pribadi oleh @Rochwidias.',
      'Dibangun dengan Next.js, React, TypeScript, dan Tailwind CSS, di-deploy di Vercel. Font Poppins & JetBrains Mono (Google Fonts).',
      'Data email & kalender berasal dari Gmail API dan Google Calendar API milik akun Googlemu sendiri. Gmail dan Google Calendar adalah merek milik Google LLC.',
      'Ikon & antarmuka dibuat khusus untuk notedwork. Warna aksen default coklat (#B45309) — bisa kamu ganti di Pengaturan.',
    ],
  ),
  LegalId.privacy: LegalDoc(
    title: 'Privasi',
    updated: 'Diperbarui September 2026',
    body: <String>[
      'Local-first: tugas, jadwal rutin, tema, warna, nama tamu & preferensi notifikasi tersimpan HANYA di browser perangkatmu (localStorage). notedwork tidak punya database untuk data tersebut dan tidak menjual data apa pun.',
      'Login Google memakai OAuth2 resmi. Izin yang diminta: gmail.readonly (membaca email), gmail.send (mengirim email), gmail.modify (bintang/arsip/tandai baca), calendar.readonly (membaca event), calendar.events (tambah/hapus event). Tanpa izin ini fitur terkait tidak jalan — mode pratinjau tetap bisa dipakai tanpa login.',
      'Token OAuth disimpan terenkripsi (AES-GCM 256-bit) di server notedwork (Supabase, akses terbatas server-only). Browser-mu tidak pernah memegang token; yang ada hanya cookie sesi httpOnly 30 hari (notedwork_session).',
      'Putus koneksi kapan saja via Pengaturan → Keluar: token server dicabut & sesi dihapus. Untuk mencabut total, hapus juga akses notedwork di akun Google (Keamanan → Akses pihak ketiga). Tugas lokal tetap ada sampai kamu hapus data situs di browser.',
      'Tidak ada iklan, tidak ada pelacakan lintas situs, tidak ada analitik pihak ketiga di aplikasi ini.',
    ],
  ),
  LegalId.terms: LegalDoc(
    title: 'Syarat Penggunaan',
    updated: 'Diperbarui September 2026',
    body: <String>[
      'notedwork disediakan apa adanya (as-is) untuk pemakaian studi pribadi. Tidak ada jaminan uptime, dan fitur Google mengikuti kuota & kebijakan Google.',
      'Akun Google & isinya tetap milikmu. Kamu bertanggung jawab atas email yang kamu kirim dan event yang kamu buat lewat aplikasi ini.',
      'Gunakan secara wajar: dilarang spam, penyalahgunaan, atau otomasi berlebih yang melanggar kebijakan Google — akses API bisa dibatasi Google bila disalahgunakan.',
      'Keluar dari Google akan mencabut token server & menghapus sesi di perangkat itu; tugas & rutin lokal tidak ikut terhapus. Mode pratinjau memakai data contoh fiktif — bukan data asli siapa pun.',
      'Syarat ini dapat berubah; versi terbaru selalu tersedia di aplikasi (Pengaturan → Syarat). Pemakaian berkelanjutan berarti kamu setuju dengan versi terbaru.',
    ],
  ),
};

const Map<LegalId, LegalDoc> _legalEn = <LegalId, LegalDoc>{
  LegalId.credit: LegalDoc(
    title: 'Credits',
    updated: 'notedwork • 2026',
    body: <String>[
      'notedwork is a student email, task & calendar dashboard — built as a personal project by @Rochwidias.',
      'Built with Next.js, React, TypeScript, and Tailwind CSS, deployed on Vercel. Poppins & JetBrains Mono fonts (Google Fonts).',
      'Email & calendar data comes from the Gmail API and Google Calendar API of your own Google account. Gmail and Google Calendar are trademarks of Google LLC.',
      'Icons & interface made exclusively for notedwork. Default accent brown (#B45309) — you can change it in Settings.',
    ],
  ),
  LegalId.privacy: LegalDoc(
    title: 'Privacy',
    updated: 'Updated September 2026',
    body: <String>[
      'Local-first: tasks, routines, theme, color, guest name & notification preferences are stored ONLY in your device\'s browser (localStorage). notedwork has no database for that data and sells no data whatsoever.',
      'Google login uses official OAuth2. Requested scopes: gmail.readonly (reading email), gmail.send (sending email), gmail.modify (star/archive/mark read), calendar.readonly (reading events), calendar.events (adding/removing events). Without these permissions the related features won\'t work — preview mode remains usable without login.',
      'OAuth tokens are stored encrypted (AES-GCM 256-bit) on the notedwork server (Supabase, server-only access). Your browser never holds tokens; all it has is a 30-day httpOnly session cookie (notedwork_session).',
      'Disconnect anytime via Settings → Log out: the server token is revoked & the session deleted. To fully revoke, also remove notedwork access in your Google account (Security → Third-party access). Local tasks stay until you clear site data in the browser.',
      'No ads, no cross-site tracking, no third-party analytics in this app.',
    ],
  ),
  LegalId.terms: LegalDoc(
    title: 'Terms of Use',
    updated: 'Updated September 2026',
    body: <String>[
      'notedwork is provided as-is for personal study use. No uptime guarantees, and Google features follow Google\'s quotas & policies.',
      'Your Google account & its contents remain yours. You are responsible for emails you send and events you create through this app.',
      'Use fairly: no spam, abuse, or excessive automation violating Google\'s policies — Google may throttle API access if abused.',
      'Logging out of Google revokes the server token & deletes the session on that device; local tasks & routines are kept. Preview mode uses fictional sample data — not anyone\'s real data.',
      'These terms may change; the latest version is always available in the app (Settings → Terms). Continued use means you agree to the latest version.',
    ],
  ),
};

/// Ambil dokumen hukum sesuai bahasa aktif (porting `LEGAL[lang][id]`).
LegalDoc legalDoc(LegalId id, Lang lang) =>
    (lang == Lang.en ? _legalEn : _legalId)[id]!;
