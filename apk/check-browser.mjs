import { existsSync, readFileSync } from "node:fs";

let code = 0;
const check = (name, ok) => {
  console.log(`${ok ? "PASS" : "FAIL"} ${name}`);
  if (!ok) code = 1;
};

const pkg = JSON.parse(readFileSync("package.json", "utf8"));

check("dep @capacitor/browser ada", !!pkg.dependencies?.["@capacitor/browser"]);
check(
  "versi browser selaras core",
  (pkg.dependencies?.["@capacitor/browser"] ?? "").replace(/^\^/, "").split(".")[0] ===
    (pkg.dependencies?.["@capacitor/core"] ?? "").replace(/^\^/, "").split(".")[0]
);
check("plugin ter-copy ke android", existsSync("android/capacitor-cordova-android-plugins"));

process.exit(code);
