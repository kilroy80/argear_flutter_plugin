package com.kino.argear.argear_flutter_plugin.utils

import android.app.Activity
import android.content.Context
import android.graphics.Color
import android.graphics.Point
import android.os.Build
import android.util.DisplayMetrics
import android.view.View
import android.view.WindowManager
import androidx.annotation.RequiresApi

object ScreenUtil {

    fun dpToPixel(context: Context, dp: Float): Int {
        return (dp * (context.resources.displayMetrics.densityDpi.toFloat() /
                DisplayMetrics.DENSITY_DEFAULT.toFloat())).toInt()
    }

    fun pixelToDp(context: Context, px: Int): Float {
        return px / (context.resources.displayMetrics.densityDpi.toFloat() /
                DisplayMetrics.DENSITY_DEFAULT.toFloat())
    }

    fun getScreenWidthDP(context: Context): Float {
        return pixelToDp(context, getDisplaySize(context).x)
    }

    fun getScreenHeightDP(context: Context): Float {
        return pixelToDp(context, getDisplaySize(context).y)
    }

    fun getWidthPixelByRatio(context: Context, designedDpSize1x: Float): Int {
        return dpToPixel(context, getScreenWidthDP(context) * (designedDpSize1x / 360.0f))
    }

    fun getHeightPixelByRatio(context: Context, designedDpSize1x: Float): Int {
        return dpToPixel(context, getScreenHeightDP(context) * (designedDpSize1x / 640.0f))
    }

    fun getDisplaySize(context: Context): Point {
        val screenWidth = context.resources.displayMetrics.widthPixels
        val screenHeight = context.resources.displayMetrics.heightPixels

        val result = Point()
        result.x = screenWidth
        result.y = screenHeight

        return result
    }

    fun setStatusBarColor(activity: Activity, color: Int) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val view: View = activity.window.decorView
            activity.window.statusBarColor = color

            if (color != Color.TRANSPARENT) {
                view.systemUiVisibility = view.systemUiVisibility or View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR
            } else {
                view.systemUiVisibility = view.systemUiVisibility and View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR.inv()
            }
        }
    }

    fun setStatusBarBlack(activity: Activity) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val view: View = activity.window.decorView

            val windows = activity.window
            windows.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
            windows.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
            windows.statusBarColor = Color.BLACK

            view.systemUiVisibility = view.systemUiVisibility and View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR
        }
    }

    fun getStatusBarHeight(context: Context): Int {
        var result = 0
        val resourceId: Int =
            context.resources.getIdentifier("status_bar_height", "dimen", "android")
        if (resourceId > 0) {
            result = context.resources.getDimensionPixelSize(resourceId)
        }
        return result
    }

    fun getNavigationBarHeight(context: Context): Int {
        var result = 0
        val resourceId: Int =
            context.resources.getIdentifier("navigation_bar_height", "dimen", "android")
        if (resourceId > 0) {
            result = context.resources.getDimensionPixelSize(resourceId)
        }
        return result
    }

    @RequiresApi(Build.VERSION_CODES.N)
    fun containsHanScript(s: String): Boolean {
        var i = 0
        while (i < s.length) {
            val codepoint = s.codePointAt(i)
            i += Character.charCount(codepoint)
            if (Character.UnicodeScript.of(codepoint) == Character.UnicodeScript.HAN) {
                return true
            }
        }
        return false
    }

    @JvmStatic
    fun isLongAspect(context: Context): Boolean {
        val heightDp =  pixelToDp(context, getDisplaySize(context).y)
        return heightDp >= 720.0f
    }
}
