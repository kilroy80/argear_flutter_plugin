package com.kino.argear.argear_flutter_plugin.utils

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.Gravity
import android.widget.Toast

object ARGearUtils {

    private val TAG = ARGearUtils::class.java.name

    fun displayError(context: Context, errorMsg: String, throwable: Throwable?) {
        val tag = context.javaClass.simpleName
        val toastText = when {
            throwable?.message != null -> {
                Log.e(tag, errorMsg, throwable)
                errorMsg + ": " + throwable.message
            }
            throwable != null -> {
                Log.e(tag, errorMsg, throwable)
                errorMsg
            }
            else -> {
                Log.e(tag, errorMsg)
                errorMsg
            }
        }

        Handler(Looper.getMainLooper())
                .post {
                    val toast = Toast.makeText(context, toastText, Toast.LENGTH_LONG)
                    toast.setGravity(Gravity.CENTER, 0, 0)
                    toast.show()
                }
    }
}
