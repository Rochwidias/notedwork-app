import type { CapacitorConfig } from "@capacitor/cli";

const config: CapacitorConfig = {
  appId: "app.notedwork",
  appName: "notedwork",
  webDir: "www",
  server: {
    // PROD: muat web langsung dari Vercel (HTTPS, tanpa cleartext).
    url: "https://notedwork.vercel.app",
    cleartext: false,
    // Login Google ikut redirect 302 ke accounts.google.com. Tanpa ini,
    // Capacitor membuka host di luar server.url di browser eksternal
    // (kepental ke Chrome + cookie sesi tak terbaca WebView app).
    // allowNavigation menahan seluruh alur OAuth di dalam WebView.
    allowNavigation: [
      "accounts.google.com",
      "*.google.com",
      "oauth2.googleapis.com",
      "www.googleapis.com",
      "*.googleusercontent.com",
    ],
  },
};

export default config;
