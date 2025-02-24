package com.plugins.app_badger

import android.content.Context
import com.modules.shortcut_badger.ShortcutBadger
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** AppBadgerPlugin */
class AppBadgerPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private lateinit var applicationContext: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "app_badger")
        channel.setMethodCallHandler(this)

        applicationContext = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            "updateBadgeCount" -> {
                try {
                    val count: Int = call.argument<Int>("count") ?: 0
                    ShortcutBadger.applyCount(applicationContext, count)
                    result.success(null)
                } catch (e: Exception) {
                    result.error("102", "${e.message}", "${e.stackTrace}")
                }
            }

            "removeBadge" -> {
                try {
                    ShortcutBadger.removeCount(applicationContext)
                    result.success(null)
                } catch (e: Exception) {
                    result.error("101", "${e.message}", "${e.stackTrace}")
                }
            }

            "isAppBadgeSupported" -> {
                try {
                    val isSupported = ShortcutBadger.isBadgeCounterSupported(applicationContext)
                    result.success(isSupported)
                } catch (e: Exception) {
                    result.error("103", "${e.message}", "${e.stackTrace}")
                }
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
