package com.kino.argear.argear_flutter_plugin

import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry.Registrar

/** ARGearFlutterPlugin */
class ARGearFlutterPlugin: FlutterPlugin, ActivityAware {

  private val TAG = ARGearFlutterPlugin::class.java.simpleName

  private var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.

//  companion object {
//    @JvmStatic
//    fun registerWith(registrar: Registrar) {
//      registrar.platformViewRegistry()
//               .registerViewFactory("argear_flutter_plugin", ARGearViewFactory(registrar.activity(), registrar.messenger()))
//    }
//  }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    Log.i(TAG, "onAttachedToEngine")
    this.flutterPluginBinding = flutterPluginBinding
  }

  override fun onDetachedFromEngine(p0: FlutterPlugin.FlutterPluginBinding) {
    Log.i(TAG, "onDetachedFromEngine")
    this.flutterPluginBinding = null
  }

  override fun onDetachedFromActivity() {
    Log.i(TAG,"onDetachedFromActivity")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    Log.i(TAG, "onReattachedToActivityForConfigChanges")
    onAttachedToActivity(binding)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    Log.i(TAG, "onAttachedToActivity")
    flutterPluginBinding?.let {
      it.platformViewRegistry.registerViewFactory("argear_flutter_plugin",
              ARGearViewFactory(binding.activity, it.binaryMessenger))
    }
  }

  override fun onDetachedFromActivityForConfigChanges() {
    Log.i(TAG, "onDetachedFromActivityForConfigChanges")
    onDetachedFromActivity()
  }
}
