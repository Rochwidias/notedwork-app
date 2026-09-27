import { existsSync, readFileSync } from "node:fs";

let code = 0;
const check = (name, ok) => {
  console.log(`${ok ? "PASS" : "FAIL"} ${name}`);
  if (!ok) code = 1;
};

const pkg = JSON.parse(readFileSync("package.json", "utf8"));
const cfg = readFileSync("capacitor.config.ts", "utf8");
// deps = runtime + dev (cli/typescript wajarnya devDependencies).
const deps = { ...pkg.dependencies, ...pkg.devDependencies };

check("dep @capacitor/core ada", !!deps["@capacitor/core"]);
check("dep @capacitor/cli ada", !!deps["@capacitor/cli"]);
check("dep @capacitor/android ada", !!deps["@capacitor/android"]);
check("dep @capacitor/local-notifications ada", !!deps["@capacitor/local-notifications"]);
check('appId "app.notedwork"', cfg.includes('"app.notedwork"'));
check('appName "notedwork"', cfg.includes('"notedwork"'));
check("server.url live Vercel", cfg.includes("https://notedwork.vercel.app"));
check("cleartext false", /cleartext:\s*false/.test(cfg));
check('webDir "www"', cfg.includes('"www"'));
check("www/index.html ada", existsSync("www/index.html"));

process.exit(code);
