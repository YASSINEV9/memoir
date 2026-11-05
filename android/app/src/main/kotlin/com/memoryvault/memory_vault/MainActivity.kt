package com.memoryvault.app

import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.provider.OpenableColumns
import androidx.core.content.IntentCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

// local_auth shows the system lock prompt, which needs a FragmentActivity.
class MainActivity : FlutterFragmentActivity() {
    private var shareChannel: MethodChannel? = null

    /** What another app shared and Dart has not taken yet. */
    private var pendingText: String? = null
    private var pendingUris: List<Uri> = emptyList()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "memoir/share")
        channel.setMethodCallHandler { call, result ->
            if (call.method == "takeShared") takeShared(result) else result.notImplemented()
        }
        shareChannel = channel
        remember(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        if (remember(intent)) shareChannel?.invokeMethod("shared", null)
    }

    /** Keeps a share intent's text and files; true if it was one. */
    private fun remember(intent: Intent?): Boolean {
        if (intent == null) return false
        val uris = when (intent.action) {
            Intent.ACTION_SEND ->
                listOfNotNull(IntentCompat.getParcelableExtra(intent, Intent.EXTRA_STREAM, Uri::class.java))
            Intent.ACTION_SEND_MULTIPLE ->
                IntentCompat.getParcelableArrayListExtra(intent, Intent.EXTRA_STREAM, Uri::class.java)
                    ?: emptyList()
            else -> return false
        }
        pendingUris = uris
        pendingText = if (uris.isEmpty()) intent.getStringExtra(Intent.EXTRA_TEXT) else null
        // Handled once; a later configuration change must not share again.
        intent.action = null
        return uris.isNotEmpty() || pendingText != null
    }

    /**
     * Copies shared files into the app cache (other apps' URIs are only
     * readable for a while) and hands Dart their paths, off the UI thread.
     */
    private fun takeShared(result: MethodChannel.Result) {
        val uris = pendingUris
        val text = pendingText
        pendingUris = emptyList()
        pendingText = null
        if (uris.isEmpty() && text == null) {
            result.success(null)
            return
        }
        val main = Handler(Looper.getMainLooper())
        Thread {
            val dir = File(cacheDir, "shared").apply { mkdirs() }
            val files = uris.mapIndexedNotNull { index, uri ->
                try {
                    val name = displayName(uri) ?: "shared_$index"
                    val target = File(dir, "${System.currentTimeMillis()}_${index}_$name")
                    contentResolver.openInputStream(uri)?.use { input ->
                        target.outputStream().use { input.copyTo(it) }
                    } ?: return@mapIndexedNotNull null
                    mapOf("path" to target.path, "name" to name)
                } catch (e: Exception) {
                    null
                }
            }
            main.post { result.success(mapOf("text" to text, "files" to files)) }
        }.start()
    }

    private fun displayName(uri: Uri): String? =
        contentResolver.query(uri, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null)
            ?.use { cursor ->
                if (cursor.moveToFirst()) cursor.getString(0)?.replace('/', '_') else null
            }
}
