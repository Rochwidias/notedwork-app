import { existsSync, readFileSync } from "node:fs";

let code = 0;
const check = (name, ok) => {
  console.log(`${ok ? "PASS" : "FAIL"} ${name}`);
  if (!ok) code = 1;
};

check("android/ ada", existsSync("android"));
check("android/app/build.gradle ada", existsSync("android/app/build.gradle"));
check("AndroidManifest ada", existsSync("android/app/src/main/AndroidManifest.xml"));

const manifest = existsSync("android/app/src/main/AndroidManifest.xml")
  ? readFileSync("android/app/src/main/AndroidManifest.xml", "utf8")
  : "";
check("permission INTERNET", manifest.includes("android.permission.INTERNET"));

const gradle = existsSync("android/app/build.gradle")
  ? readFileSync("android/app/build.gradle", "utf8")
  : "";
check('applicationId "app.notedwork"', gradle.includes('"app.notedwork"'));

process.exit(code);
