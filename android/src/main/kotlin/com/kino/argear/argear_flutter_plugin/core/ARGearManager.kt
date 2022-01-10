package com.kino.argear.argear_flutter_plugin.core

import android.content.Context
import android.os.Build
import android.os.Environment
import android.util.Log
import com.kino.argear.argear_flutter_plugin.enum.ARGBitrate
import com.kino.argear.argear_flutter_plugin.model.ItemModel
import com.kino.argear.argear_flutter_plugin.utils.DownloadAsyncResponse
import com.kino.argear.argear_flutter_plugin.utils.DownloadAsyncTask
import com.kino.argear.argear_flutter_plugin.utils.FileDeleteAsyncTask
import com.kino.argear.argear_flutter_plugin.utils.PreferenceUtil
import com.seerslab.argear.exceptions.InvalidContentsException
import com.seerslab.argear.exceptions.NetworkException
import com.seerslab.argear.exceptions.SignedUrlGenerationException
import com.seerslab.argear.session.ARGAuth
import com.seerslab.argear.session.ARGContents
import com.seerslab.argear.session.ARGFrame
import com.seerslab.argear.session.ARGSession
import java.io.File

object ARGearManager {

    private val TAG = ARGearManager::class.java.simpleName

    var screenRatio: ARGFrame.Ratio = ARGFrame.Ratio.RATIO_FULL
    var mediaBitrate: ARGBitrate = ARGBitrate.VIDEO_BITRATE_4M

    private var itemDownloadPath: String? = null
    private var videoFilePath: String? = null

    var mediaFolderName: String = ""
    var mediaPath: String? = null
    var innerMediaPath: String? = null

    private var argSession: ARGSession? = null

    private var beautyParams = ARGearConfig.BEAUTY_TYPE_INIT_VALUE

    interface OnARGearManagerCallback {
        fun onSuccess(data: Any?)
        fun onError(errorCode: String, errorMessage: String, errorDetails: Any?)
    }

    fun setMediaPath(context: Context, folderName: String) {
        mediaFolderName = folderName
        mediaPath = Environment.getExternalStorageDirectory().toString() +
                File.separator + Environment.DIRECTORY_DCIM + File.separator + folderName
        mediaPath?.let {
            val dir = File(it)
            if (!dir.exists()) {
                dir.mkdirs()
            }
        }
        innerMediaPath = context.getExternalFilesDir(null)?.absolutePath + "/ARGearMedia"
    }

    fun setDownloadPath(context: Context) {
        if (itemDownloadPath == null) {
            itemDownloadPath = context.filesDir.absolutePath
        }
    }

    fun createVideoPath(): String {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            innerMediaPath + "/" + System.currentTimeMillis() + ".mp4"
        } else {
            mediaPath + "/" + System.currentTimeMillis() + ".mp4"
        }
    }

    fun setARGSession(argSession: ARGSession?) {
        if (this.argSession == null) {
            this.argSession = argSession
        }
    }

    fun getVideoBitrate(): Int {
        return when (mediaBitrate) {
            ARGBitrate.VIDEO_BITRATE_4M -> {
                4 * 1000 * 1000
            }
            ARGBitrate.VIDEO_BITRATE_2M -> {
                2 * 1000 * 1000
            }
            ARGBitrate.VIDEO_BITRATE_1M -> {
                1 * 1000 * 1000
            }
        }
    }

    fun setVideoBitrate(bitrate: Int) {
        val bitrateType = when (bitrate) {
            0 -> ARGBitrate.VIDEO_BITRATE_4M
            1 -> ARGBitrate.VIDEO_BITRATE_2M
            2 -> ARGBitrate . VIDEO_BITRATE_1M
            else -> ARGBitrate.VIDEO_BITRATE_4M
        }
        this.mediaBitrate = bitrateType
    }

    fun setItem(type: ARGContents.Type?, path: String?, itemModel: ItemModel?, callback: OnARGearManagerCallback) {
        if (type == null || path == null || itemModel == null) return
        argSession?.contents()?.setItem(type, path, itemModel.uuid, object : ARGContents.Callback {
            override fun onSuccess() {
                callback.onSuccess("complete")
            }

            override fun onError(e: Throwable) {
                if (e is InvalidContentsException) {
                    Log.e(TAG, "InvalidContentsException")
                    callback.onError("10001", "InvalidContentsException", null)
                }
            }
        })
    }

    fun setSticker(context: Context, item: ItemModel?, callback: OnARGearManagerCallback) {
        val filePath = StringBuilder()
        filePath.append(itemDownloadPath)
        filePath.append("/")
        filePath.append(item?.uuid)

        val itemUpdateAt = item?.updatedAt ?: 0
        if (itemUpdateAt > 0 && itemUpdateAt > getStickerUpdateAt(context, item?.uuid ?: "")) {
            FileDeleteAsyncTask(File(filePath.toString()), object :
                    FileDeleteAsyncTask.OnAsyncFileDeleteListener {
                override fun processFinish(result: Any?) {
                    Log.d(TAG, "file delete success!")

                    setStickerUpdateAt(context, item?.uuid ?: "", itemUpdateAt)
                    requestSignedUrl(context, item, filePath.toString(), true, callback)
                }
            }).execute()
        } else {
            if (File(filePath.toString()).exists()) {
                setItem(ARGContents.Type.ARGItem, filePath.toString(), item, callback)
            } else {
                requestSignedUrl(context, item, filePath.toString(), true, callback)
            }
        }
    }

    fun setFilter(context: Context, item: ItemModel?, callback: OnARGearManagerCallback) {
        val filePath = StringBuilder()
        filePath.append(itemDownloadPath)
        filePath.append("/")
        filePath.append(item?.uuid)

        val itemUpdateAt = item?.updatedAt ?: 0
        if (itemUpdateAt > 0 && itemUpdateAt > getFilterUpdateAt(context, item?.uuid ?: "")) {
            FileDeleteAsyncTask(File(filePath.toString()), object : FileDeleteAsyncTask.OnAsyncFileDeleteListener {
                override fun processFinish(result: Any?) {
                    Log.d(TAG, "file delete success!")

                    setFilterUpdateAt(context, item?.uuid ?: "", itemUpdateAt)
                    requestSignedUrl(context, item, filePath.toString(), false, callback)
                }
            }).execute()
        } else {
            if (File(filePath.toString()).exists()) {
                setItem(ARGContents.Type.FilterItem, filePath.toString(), item, callback)
            } else {
                requestSignedUrl(context, item, filePath.toString(), false, callback)
            }
        }
    }

    fun setFilterLevel(filterLevel: Int) {
        argSession?.contents()?.setFilterLevel(filterLevel)
    }

    fun setVignette(isVignette: Boolean) {
        argSession?.contents()?.setFilterOption(ARGContents.FilterOption.VIGNETTING, isVignette)
    }

    fun setBlurVignette(isBlur: Boolean) {
        argSession?.contents()?.setFilterOption(ARGContents.FilterOption.BLUR, isBlur)
    }

    fun setBulgeFunType(type: Int) {
        var bulgeType = ARGContents.BulgeType.NONE
        when (type) {
            0 -> bulgeType = ARGContents.BulgeType.FUN1
            1 -> bulgeType = ARGContents.BulgeType.FUN2
            2 -> bulgeType = ARGContents.BulgeType.FUN3
            3 -> bulgeType = ARGContents.BulgeType.FUN4
            4 -> bulgeType = ARGContents.BulgeType.FUN5
            5 -> bulgeType = ARGContents.BulgeType.FUN6
        }
        argSession?.contents()?.setBulge(bulgeType)
    }

    fun setBeauty(params: DoubleArray?) {
        params?.let { param ->
            val floatArray = param.map { it.toFloat() }.toFloatArray()
            argSession?.contents()?.setBeauty(floatArray)
        }
    }

    fun setBeauty(type: Int, value: Double) {
        beautyParams[type] = value.toFloat()
        argSession?.contents()?.setBeauty(beautyParams)
    }

    fun setDefaultBeauty() {
        argSession?.contents()?.setBeauty(ARGearConfig.BEAUTY_TYPE_INIT_VALUE)
        beautyParams = ARGearConfig.BEAUTY_TYPE_INIT_VALUE
    }

    fun getDefaultBeauty(): ArrayList<Double>  {
        val list = ArrayList<Double>()
        for (element in ARGearConfig.BEAUTY_TYPE_INIT_VALUE) {
            list.add(element.toDouble())
        }
        return list
    }

    fun clearStickers() {
        argSession?.contents()?.clear(ARGContents.Type.ARGItem)
    }

    fun clearFilter() {
        argSession?.contents()?.clear(ARGContents.Type.FilterItem)
    }

    fun clearBulge() {
        argSession?.contents()?.clear(ARGContents.Type.Bulge)
    }

    private fun requestSignedUrl(
            context: Context,
            item: ItemModel?,
            path: String,
            isArItem: Boolean,
            callback: OnARGearManagerCallback
    ) {
        argSession?.auth()?.requestSignedUrl(item?.zipFileUrl, item?.title, item?.type, object : ARGAuth.Callback {
            override fun onSuccess(url: String) {
                requestDownload(context, path, url, item, isArItem, callback)
            }

            override fun onError(e: Throwable) {
                if (e is SignedUrlGenerationException) {
                    Log.e(TAG, "SignedUrlGenerationException !! ")
                    callback.onError("10002", "SignedUrlGenerationException", null)
                } else if (e is NetworkException) {
                    Log.e(TAG, "NetworkException !!")
                    callback.onError("10003", "NetworkException", null)
                }
            }
        })
    }

    private fun requestDownload(
            context: Context,
            targetPath: String,
            url: String,
            item: ItemModel?,
            isSticker: Boolean,
            callback: OnARGearManagerCallback
    ) {
        DownloadAsyncTask(targetPath, url, object : DownloadAsyncResponse {
            override fun processFinish(result: Boolean) {
                if (result) {
                    if (isSticker) {
                        setItem(ARGContents.Type.ARGItem, targetPath, item, callback)
                    } else {
                        setItem(ARGContents.Type.FilterItem, targetPath, item, callback)
                    }
                    Log.d(TAG, "download success!")
                } else {
                    Log.d(TAG, "download failed!")
                    callback.onError("10004", "failed", null)
                }
            }
        }).execute()
    }

    fun setFilterUpdateAt(context: Context, itemId: String, updateAt: Long) {
        PreferenceUtil.putLongValue(context, ARGearConfig.USER_PREF_NAME_FILTER, itemId, updateAt)
    }

    fun getFilterUpdateAt(context: Context, itemId: String): Long {
        return PreferenceUtil.getLongValue(context, ARGearConfig.USER_PREF_NAME_FILTER, itemId)
    }

    fun setStickerUpdateAt(context: Context, itemId: String, updateAt: Long) {
        PreferenceUtil.putLongValue(context, ARGearConfig.USER_PREF_NAME_STICKER, itemId, updateAt)
    }

    fun getStickerUpdateAt(context: Context, itemId: String): Long {
        return PreferenceUtil.getLongValue(context, ARGearConfig.USER_PREF_NAME_STICKER, itemId)
    }
}
