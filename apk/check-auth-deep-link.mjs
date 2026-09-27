import { existsSync, readFileSync } from "node:fs";

let code = 0;
const check = (name, ok) => {
  console.log(`${ok ? "PASS" : "FAIL"} ${name}`);
  if (!ok) code = 1;
};

const manifestPath = "android/app/src/main/AndroidManifest.xml";
const activityPath = "android/app/src/main/java/app/notedwork/MainActivity.java";

const manifest = existsSync(manifestPath) ? readFileSync(manifestPath, "utf8") : "";
const activity = existsSync(activityPath) ? readFileSync(activityPath, "utf8") : "";

// 1. Deep-link intent-filter untuk custom scheme (Custom Tabs -> app)
check("manifest punya intent-filter VIEW", manifest.includes("android.intent.action.VIEW"));
check("manifest kategori BROWSABLE (deep-link)", manifest.includes("android.intent.category.BROWSABLE"));
check(
  "manifest scheme app.notedwork",
  manifest.includes('android:scheme="app.notedwork"') || manifest.includes("android:scheme='app.notedwork'")
);
// 2. Native handler teruskan code ke WebView (jangan cuma buka app kosong)
check("MainActivity handle onNewIntent", activity.includes("onNewIntent"));
check("MainActivity baca getIntent/data scheme", activity.includes("getIntent") && activity.includes("app.notedwork"));
check(
  "MainActivity teruskan code ke WebView",
  activity.includes("getWebView") && (activity.includes("loadUrl") || activity.includes("evaluateJavascript"))
);

process.exit(code);
