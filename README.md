# notedwork-app

Wrapper Android (Capacitor) untuk [notedwork](https://notedwork.vercel.app) — aplikasi catatan, tugas, agenda, dan email.
Aplikasi web-nya dibungkus jadi APK native supaya bisa jalan fullscreen di HP + dapat **notifikasi native Android**.

> Source code web-nya ada di repo terpisah: [Rochwidias/notedwork](https://github.com/Rochwidias/notedwork)

## Download (user Android)

Langsung download APK terbaru di halaman release:

**[⬇ Download notedwork-v1.0.0.apk](https://github.com/Rochwidias/notedwork-app/releases/latest)**

1. Download file `.apk` di HP
2. Buka file-nya → izinkan "install dari sumber tak dikenal" kalau diminta
3. Install → buka → login pakai akun Google

## Struktur folder

```
notedwork.app/
├── apk/                          # Project Capacitor (yg ini yg di-build)
│   ├── capacitor.config.ts       # Config: url prod Vercel, appId app.notedwork
│   ├── package.json              # Deps: @capacitor/{android,core,cli,browser,local-notifications}
│   ├── www/index.html            # Halaman offline fallback
│   ├── check-config.mjs          # Cek config Capacitor bener/prod
│   ├── check-android.mjs         # Cek project android/ valid
│   ├── check-browser.mjs         # Cek plugin browser terpasang
│   ├── make-icons.py             # Generate icon + splash dari icon-512.png web
│   └── android/                  # Project Android native (hasil npx cap add android)
│       └── app/src/main/java/app/notedwork/MainActivity.java  # Patch User-Agent (biar Google OAuth ga 403)
├── Main.kt + jalan.bat           # Prototipe CLI catatan (terpisah, bukan bagian APK)
└── README.md
```

## Cara install & build APK

### Syarat

- Node.js 18+ (`node -v`)
- Java 17+ (`java -version`)
- Android SDK (atau install Android Studio biar otomatis)
- `ANDROID_HOME` / `local.properties` (`sdk.dir=...`) terisi — file ini **tidak di-commit**, bikin sendiri

### Langkah

```bash
# 1. Clone
git clone https://github.com/Rochwidias/notedwork-app.git
cd notedwork-app/apk

# 2. Install dependencies
npm install

# 3. Sync Capacitor ke project Android
npx cap sync

# 4. (Opsional) Verifikasi
node check-config.mjs
node check-android.mjs
node check-browser.mjs

# 5. Build APK debug
cd android
./gradlew assembleDebug        # Windows: gradlew.bat assembleDebug

# 6. Install ke HP/emulator
adb install -r app/build/outputs/apk/debug/app-debug.apk
```

APK hasil build ada di `apk/android/app/build/outputs/apk/debug/app-debug.apk` (sengaja **tidak di-commit**, build sendiri aja).

### Update isi WebView

APK ini me-load `https://notedwork.vercel.app` langsung (lihat `capacitor.config.ts`), jadi update fitur web otomatis kebawa tanpa rebuild APK — kecuali ganti icon, config, atau versi plugin.

## Catatan penting

- **Login Google tetap di dalam app** (tidak kepental ke Chrome) berkat `allowNavigation` + patch User-Agent di `MainActivity.java`. Jangan hapus dua itu.
- **Notifikasi ada 2 lapis**: pengingat in-app (web) + notifikasi native via `@capacitor/local-notifications`. Tidak pakai FCM/push server.
- File yang tidak di-commit (lihat `.gitignore`): `node_modules/`, folder `build/`, `*.apk`, `local.properties`, screenshot/dump debug.
