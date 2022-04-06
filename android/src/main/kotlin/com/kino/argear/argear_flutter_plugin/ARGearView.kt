package com.kino.argear.argear_flutter_plugin

import android.app.Activity
import android.app.Application
import android.content.Context
import android.os.Bundle
import android.os.Handler
import android.util.Log
import android.view.View
import com.google.gson.Gson
import com.kino.argear.argear_flutter_plugin.core.ARGearManager
import com.kino.argear.argear_flutter_plugin.core.ARGearConfig
import com.kino.argear.argear_flutter_plugin.core.ARGearSessionView
import com.kino.argear.argear_flutter_plugin.model.ItemModel
import com.kino.argear.argear_flutter_plugin.utils.ARGearTypeUtils
import com.kino.argear.argear_flutter_plugin.utils.ARGearUtils
import com.kino.argear.argear_flutter_plugin.utils.MediaStoreUtil
import com.kino.argear.argear_flutter_plugin.utils.PermissionHelper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class ARGearView(private val activity: Activity, context: Context, messenger: BinaryMessenger, id: Int)
    : PlatformView, MethodChannel.MethodCallHandler {

    private val TAG: String = ARGearView::class.java.simpleName

    private val methodChannel: MethodChannel = MethodChannel(messenger, "argear_flutter_plugin_$id")
    lateinit var activityLifecycleCallbacks: Application.ActivityLifecycleCallbacks

    private var arGearSessionView: ARGearSessionView? = null

    init {
        methodChannel.setMethodCallHandler(this)
        arGearSessionView = ARGearSessionView(context)

        setupLifeCycle(context)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "init" -> {
                arGearSessionViewInit(call, result, methodChannel, activity)
            }
            "dispose" -> {
                Log.i(TAG, "dispose")
                dispose()
            }
            "changeCameraFacing" -> {
                Log.i(TAG, "changeCameraFacing")
                arGearSessionView?.changeCameraFacing()
            }
            "changeCameraRatio" -> {
                val ratio: Int? = call.argument("ratio")
                ratio?.let {
                    arGearSessionView?.changeCameraRatio(it)
                }
            }
            "setVideoBitrate" -> {
                val bitrate: Int? = call.argument("bitrate")
                bitrate?.let {
                    ARGearManager.setVideoBitrate(it)
                }
            }
            "setSticker" -> {
                val data: String? = call.argument("itemModel")
                val itemModel = Gson().fromJson(data.toString(), ItemModel::class.java)
                ARGearManager.setSticker(activity, itemModel, object : ARGearManager.OnARGearManagerCallback {
                    override fun onSuccess(data: Any?) {
                        result.success(data)
                    }

                    override fun onError(errorCode: String, errorMessage: String, errorDetails: Any?) {
                        result.error(errorCode, errorMessage, errorDetails)
                    }
                })
            }
            "clearSticker" -> {
                ARGearManager.clearStickers()
            }
            "setFilter" -> {
                val data: String? = call.argument("itemModel")
                val itemModel = Gson().fromJson(data.toString(), ItemModel::class.java)
                ARGearManager.setFilter(activity, itemModel, object : ARGearManager.OnARGearManagerCallback {
                    override fun onSuccess(data: Any?) {
                        result.success(data)
                    }

                    override fun onError(errorCode: String, errorMessage: String, errorDetails: Any?) {
                        result.error(errorCode, errorMessage, errorDetails)
                    }
                })
            }
            "setFilterLevel" -> {
                val level: Double? = call.argument("level")
                level?.let {
                    ARGearManager.setFilterLevel(it.toInt())
                }
            }
            "clearFilter" -> {
                ARGearManager.clearFilter()
            }
            "setBeauty" -> {
                val type: Int? = call.argument("type")
                val value: Double? = call.argument("value")

                type?.let { t ->
                    value?.let { v ->
                        ARGearManager.setBeauty(t, v)
                    }
                }
            }
            "setDefaultBeauty" -> {
                ARGearManager.setDefaultBeauty()
            }
            "getDefaultBeauty" -> {
                val data = ARGearManager.getDefaultBeauty()
                result.success(data)
            }
            "setBulge" -> {
                val type: Int? = call.argument("type")
                type?.let {
                    ARGearManager.setBulgeFunType(it)
                }
            }
            "setBeautyValues" -> {
                val values: ArrayList<Double>? = call.argument("values")
                values?.let{
                    ARGearManager.setBeauty(it.toDoubleArray())
                }
            }
            "clearBulge" -> {
                ARGearManager.clearBulge()
            }
            "takePicture" -> {
                arGearSessionView?.takePicture()
            }
            "startRecording" -> {
                arGearSessionView?.startRecording()
            }
            "stopRecording" -> {
                arGearSessionView?.stopRecording(object : MediaStoreUtil.OnMediaStoreCallback {
                    override fun onComplete() {
                        methodChannel.invokeMethod("recordingCallback", "success")
                    }
                })
            }
            "toggleRecording" -> {
                val toggle: Int? = call.argument("toggle")
                toggle?.let {
                    if (it == 0) {
                        arGearSessionView?.startRecording()
                    } else {
                        arGearSessionView?.stopRecording(object : MediaStoreUtil.OnMediaStoreCallback {
                            override fun onComplete() {
                                methodChannel.invokeMethod("recordingCallback", "success")
                            }
                        })
                    }
                }
            }
            "exitApp" -> {
                android.os.Process.killProcess(android.os.Process.myPid())
            }
            else -> {
            }
        }
    }

    private fun setupLifeCycle(context: Context) {
        activityLifecycleCallbacks = object : Application.ActivityLifecycleCallbacks {
            override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
                Log.i(TAG, "onActivityCreated")
            }

            override fun onActivityStarted(activity: Activity) {
                Log.i(TAG, "onActivityStarted")
            }

            override fun onActivityResumed(activity: Activity) {
                Log.i(TAG, "onActivityResumed")
                onResume()
            }

            override fun onActivityPaused(activity: Activity) {
                Log.i(TAG, "onActivityPaused")
                onPause()
            }

            override fun onActivityStopped(activity: Activity) {
                Log.i(TAG, "onActivityStopped")
            }

            override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
            }

            override fun onActivityDestroyed(activity: Activity) {
                Log.i(TAG, "onActivityDestroyed")
                onDestroy()
            }
        }

        activity.application.registerActivityLifecycleCallbacks(this.activityLifecycleCallbacks)
    }

    private fun arGearSessionViewInit(call: MethodCall, result: MethodChannel.Result, channel: MethodChannel, activity: Activity) {
        Log.i(TAG, "arGearSessionViewInit")

        val apiUrl: String? = call.argument("apiUrl")
        val apiKey: String? = call.argument("apiKey")
        val secretKey: String? = call.argument("secretKey")
        val authKey: String? = call.argument("authKey")
        val ratio: Int? = call.argument("ratio")

        if (ratio != null) {
            ARGearConfig.screenRatio = ARGearTypeUtils.convertRatioEnum(ratio)
        }

        if (apiUrl != null && apiKey != null && secretKey != null && authKey != null) {
            arGearSessionView?.setUpSdk(apiUrl, apiKey, secretKey, authKey, channel, activity)
            onResume()
        }

        result.success(null)
    }

    override fun getView(): View {
        return arGearSessionView as View
    }

    override fun dispose() {
        Log.i(TAG, "dispose")
        if (arGearSessionView != null) {
            onDestroy()
        }
    }

    fun onResume() {
        Log.i(TAG, "onResume()")

        if (arGearSessionView == null) {
            return
        }

        if (hasPermission()) {
            try {
                arGearSessionView?.resume()
            } catch (e: Exception) {
                ARGearUtils.displayError(activity, "Unable to get camera", e)
                activity.finish()
                return
            }
        }
    }

    fun onPause() {
        Log.i(TAG, "onPause()")

        if (arGearSessionView != null) {
            arGearSessionView?.pause()
        }
    }

    fun onDestroy() {
        Log.i(TAG, "onDestroy()")
        if (arGearSessionView != null) {
            arGearSessionView?.destroy()
            arGearSessionView = null
        }
    }

    private fun hasPermission(): Boolean {
        if (!PermissionHelper.hasPermission(activity)) {
            if (PermissionHelper.shouldShowRequestPermissionRationale(activity)) {
                ARGearUtils.displayError(activity, "Please check your permissions!", null)
                return false
            }
            PermissionHelper.requestPermission(activity)
            return false
        }
        return true
    }
}
