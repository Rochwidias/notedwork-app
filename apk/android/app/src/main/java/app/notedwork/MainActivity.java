package app.notedwork;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.webkit.WebView;
import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Google menolak OAuth dari WebView yang ketahuan embedded
        // (UA mengandung "; wv" -> 403 disallowed_useragent). Buang penanda
        // itu agar alur login Google tetap jalan di dalam aplikasi.
        // Versi Chrome asli dipertahankan, hanya penanda WebView yang dibuang.
        try {
            WebView wv = getBridge().getWebView();
            String ua = wv.getSettings().getUserAgentString();
            if (ua != null && ua.contains("; wv")) {
                wv.getSettings().setUserAgentString(ua.replace("; wv", ""));
            }
        } catch (Exception e) {
            android.util.Log.w("notedwork", "patch UA gagal: " + e.getMessage());
        }
        handleAuthDeepLink(getIntent());
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        handleAuthDeepLink(intent);
    }

    /** Terima app.notedwork://auth?code=... dari Custom Tabs, teruskan ke WebView.
     *  Web di https://notedwork.vercel.app/native-auth-callback yang menukar
     *  one-time code jadi sesi (native tidak pegang token panjang). */
    private void handleAuthDeepLink(Intent intent) {
        if (intent == null || intent.getData() == null) return;
        Uri data = intent.getData();
        if (!"app.notedwork".equals(data.getScheme())) return;
        String code = data.getQueryParameter("code");
        if (code == null || code.isEmpty()) return;
        try {
            WebView wv = getBridge().getWebView();
            // Muat callback web agar sesi dibuat di dalam WebView (satu cookie-store).
            wv.loadUrl("https://notedwork.vercel.app/native-auth-callback?code=" + Uri.encode(code));
        } catch (Exception e) {
            android.util.Log.w("notedwork", "auth deep-link gagal: " + e.getMessage());
        }
    }
}
