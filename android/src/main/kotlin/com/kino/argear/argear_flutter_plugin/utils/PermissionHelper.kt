package com.kino.argear.argear_flutter_plugin.utils

import android.Manifest
import android.app.Activity
import android.content.Context
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
    fun hasPermission(context: Context): Boolean {
        for (permission in permissions) {
            if (ActivityCompat.checkSelfPermission(context, permission)
                    != PackageManager.PERMISSION_GRANTED
            ) {
                return false
            }
        }
        return true
    }

    @JvmStatic
    fun requestPermission(context: Context) {
        if (context is Activity) {
            ActivityCompat.requestPermissions(context, permissions, PERMISSION_CODE)
        } else {
            throw ClassCastException("Current Context not casting Activity")
        }
    }

    @JvmStatic
    fun shouldShowRequestPermissionRationale(context: Context): Boolean {
        if (context is Activity) {
            for (permission in permissions) {
                if (ActivityCompat.shouldShowRequestPermissionRationale(context, permission)) {
                    return true
                }
            }
        }
        return false
    }
}
