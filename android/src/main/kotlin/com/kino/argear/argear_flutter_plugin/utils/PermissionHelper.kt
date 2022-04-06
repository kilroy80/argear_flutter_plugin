package com.kino.argear.argear_flutter_plugin.utils

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat

object PermissionHelper {

    private const val PERMISSION_CODE = 0x123

    private val permissions = arrayOf(
            Manifest.permission.CAMERA,
            Manifest.permission.RECORD_AUDIO,
            Manifest.permission.WRITE_EXTERNAL_STORAGE
    )

    @JvmStatic
    fun hasPermission(activity: Activity): Boolean {
        for (permission in permissions) {
            if (ActivityCompat.checkSelfPermission(activity, permission)
                    != PackageManager.PERMISSION_GRANTED
            ) {
                return false
            }
        }
        return true
    }

    @JvmStatic
    fun requestPermission(activity: Activity) {
        ActivityCompat.requestPermissions(activity, permissions, PERMISSION_CODE)
    }

    @JvmStatic
    fun shouldShowRequestPermissionRationale(activity: Activity): Boolean {
        for (permission in permissions) {
            if (ActivityCompat.shouldShowRequestPermissionRationale(activity, permission)) {
                return true
            }
        }
        return false
    }
}
