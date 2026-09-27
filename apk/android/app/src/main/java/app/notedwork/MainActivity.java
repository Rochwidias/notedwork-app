package app.notedwork;

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
    }
}
