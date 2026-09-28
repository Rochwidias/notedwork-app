package app.notedwork.notedwork

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Color
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

class AgendaWidgetProvider : HomeWidgetProvider() {
    private val rowIds =
        intArrayOf(R.id.w_row0, R.id.w_row1, R.id.w_row2, R.id.w_row3, R.id.w_row4)
    private val colorIds =
        intArrayOf(
            R.id.w_row0_color,
            R.id.w_row1_color,
            R.id.w_row2_color,
            R.id.w_row3_color,
            R.id.w_row4_color,
        )
    private val timeIds =
        intArrayOf(
            R.id.w_row0_time,
            R.id.w_row1_time,
            R.id.w_row2_time,
            R.id.w_row3_time,
            R.id.w_row4_time,
        )
    private val titleIds =
        intArrayOf(
            R.id.w_row0_title,
            R.id.w_row1_title,
            R.id.w_row2_title,
            R.id.w_row3_title,
            R.id.w_row4_title,
        )

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val today = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())
        // ISO 8601: Senin=1..Minggu=7 (Calendar.SUNDAY=1 -> 7, sisanya -1)
        val calendar = Calendar.getInstance()
        val todayIso =
            if (calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
                7
            } else {
                calendar.get(Calendar.DAY_OF_WEEK) - 1
            }

        var header = ""
        var emptyText = ""
        val rows = ArrayList<Triple<String, String, String>>() // color, time, title
        try {
            val payloadRaw = widgetData.getString(PAYLOAD_KEY, null)
            if (payloadRaw != null) {
                val json = JSONObject(payloadRaw)
                header = json.optString("header", "Hari Ini")
                emptyText = json.optString("empty", "")
                val items = json.getJSONArray("items")
                for (i in 0 until items.length()) {
                    val item = items.getJSONObject(i)
                    val matches =
                        when (item.optString("kind")) {
                            "routine" -> item.optInt("day", -1) == todayIso
                            else -> item.optString("date") == today
                        }
                    if (!matches) continue
                    val title = item.optString("title", "")
                    if (title.isEmpty()) continue
                    rows.add(
                        Triple(
                            item.optString("color", "#D97706"),
                            item.optString("time", ""),
                            title,
                        ),
                    )
                    if (rows.size == MAX_ROWS) break
                }
            }
        } catch (_: Exception) {
            // payload korup -> tampil empty state, jangan crash
            rows.clear()
        }
        if (header.isEmpty()) header = DEFAULT_HEADER
        if (rows.isEmpty() && emptyText.isEmpty()) emptyText = DEFAULT_EMPTY

        val addIntent =
            HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                Uri.parse(URI_ADD),
            )
        val openIntent =
            HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                Uri.parse(URI_OPEN),
            )

        appWidgetIds.forEach { widgetId ->
            val views =
                RemoteViews(context.packageName, R.layout.widget_agenda).apply {
                    setTextViewText(R.id.w_header, header)
                    setOnClickPendingIntent(R.id.w_header, openIntent)
                    setOnClickPendingIntent(R.id.w_add, addIntent)
                    if (rows.isEmpty()) {
                        setViewVisibility(R.id.w_empty, View.VISIBLE)
                        setTextViewText(R.id.w_empty, emptyText)
                    } else {
                        setViewVisibility(R.id.w_empty, View.GONE)
                    }
                    for (n in 0 until MAX_ROWS) {
                        if (n < rows.size) {
                            val (color, time, title) = rows[n]
                            setViewVisibility(rowIds[n], View.VISIBLE)
                            try {
                                setInt(colorIds[n], "setColorFilter", Color.parseColor(color))
                            } catch (_: IllegalArgumentException) {
                                // warna tidak valid -> pakai warna bawaan dot
                            }
                            setTextViewText(timeIds[n], time)
                            setViewVisibility(
                                timeIds[n],
                                if (time.isEmpty()) View.GONE else View.VISIBLE,
                            )
                            setTextViewText(titleIds[n], title)
                            setOnClickPendingIntent(titleIds[n], openIntent)
                        } else {
                            setViewVisibility(rowIds[n], View.GONE)
                        }
                    }
                }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private companion object {
        const val PAYLOAD_KEY = "agenda_payload"
        const val MAX_ROWS = 5
        const val DEFAULT_HEADER = "Hari Ini"
        const val DEFAULT_EMPTY = "Belum ada agenda hari ini"
        const val URI_ADD = "notedwork://widget/add"
        const val URI_OPEN = "notedwork://widget/open"
    }
}
