package com.kino.argear.argear_flutter_plugin.core

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.Point
import android.media.Image
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.AttributeSet
import android.view.ViewGroup
import android.widget.FrameLayout
import com.kino.argear.argear_flutter_plugin.camera.*
import com.kino.argear.argear_flutter_plugin.rendering.CameraTexture
import com.kino.argear.argear_flutter_plugin.rendering.ScreenRenderer
import com.kino.argear.argear_flutter_plugin.utils.*
import com.seerslab.argear.session.ARGFrame
import com.seerslab.argear.session.ARGMedia
import com.seerslab.argear.session.ARGSession
import com.seerslab.argear.session.config.ARGCameraConfig
import com.seerslab.argear.session.config.ARGConfig
import com.seerslab.argear.session.config.ARGInferenceConfig
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.lang.Exception
import java.util.*
import javax.microedition.khronos.egl.EGLConfig
import javax.microedition.khronos.opengles.GL10

class ARGearSessionView : FrameLayout {

    private val TAG = ARGearSessionView::class.java.simpleName

    constructor(context: Context) : super(context) {
        init()
    }

    constructor(context: Context, attrs: AttributeSet) : super(context, attrs) {
        init()
    }

    constructor(context: Context, attrs: AttributeSet, defStyleAttr: Int) : super(context, attrs, defStyleAttr) {
        init()
    }

    private var viewActivity: Activity? = null

    private lateinit var camera: ReferenceCamera
    private lateinit var glView: GLView
    private lateinit var screenRenderer: ScreenRenderer
    private lateinit var cameraTexture: CameraTexture

    private lateinit var argSession: ARGSession
    private lateinit var argMedia: ARGMedia

    private var isResume: Boolean = false
    private var isDestroy: Boolean = false

    private var screenRatio: ARGFrame.Ratio = ARGFrame.Ratio.RATIO_FULL

    private var methodChannel: MethodChannel? = null

    private var isShooting = false
    private var isShootingComplete = false
    private var isVideoRecord = false

    private var videoFilePath: String = ""
    private var flutterFilePath: String = ""

    var gLViewWidth = 0
    var gLViewHeight = 0

    private lateinit var dimView: FrameLayout

    private fun init() {
        ARGearManager.setMediaPath(context, "/ARGEAR")
        clearTempMediaFiles()
    }

    fun setUpSdk(apiUrl: String, apiKey: String, secretKey: String, authKey: String, channel: MethodChannel, activity: Activity) {

        methodChannel = channel
        viewActivity = activity

        val config = ARGConfig(
                apiUrl,
                apiKey,
                secretKey,
                authKey
        )

        val inferenceConfig: Set<ARGInferenceConfig.Feature> = EnumSet.of(
            ARGInferenceConfig.Feature.FACE_LOW_TRACKING,
            ARGInferenceConfig.Feature.FACE_MESH_TRACKING
        )

        // Session Init
        argSession = ARGSession(context, config, inferenceConfig)
        argMedia = ARGMedia(argSession)

        initGLView()
        initCamera()
    }

    private fun initGLView() {
        val params = LayoutParams(
            ViewGroup.LayoutParams.WRAP_CONTENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
        )
//        params.gravity = Gravity.CENTER

        screenRenderer = ScreenRenderer()
        cameraTexture = CameraTexture()

        glView = GLView(context, glViewListener)
//        glView.setZOrderMediaOverlay(true)
        addView(glView, params)

        val dimParams = LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )

        dimView = FrameLayout(context)
        dimView.setBackgroundColor(Color.TRANSPARENT)
        addView(dimView, dimParams)
    }

    private fun initCamera() {
        camera = if (ARGearConfig.USE_CAMERA_API == 1) {
            ReferenceCamera1(context, cameraListener)
        } else {
            ReferenceCamera2(
                context,
                cameraListener,
//                windowManager.defaultDisplay.rotation
                resources.configuration.orientation
            )
        }
    }

    fun resume() {
        if (::camera.isInitialized && ::argSession.isInitialized) {
            camera.startCamera()
            argSession.resume()

            if (::camera.isInitialized && !isResume) {
                isResume = true
            }
            setGLViewSize(camera.previewSize)

            ARGearManager.setDownloadPath(context)
            ARGearManager.setARGSession(argSession)
        }
    }

    fun pause() {
        if (::camera.isInitialized && ::argSession.isInitialized) {
            camera.stopCamera()
            argSession.pause()
        }
    }

    fun destroy() {
        if (::camera.isInitialized && ::argSession.isInitialized) {
            try {
                camera.destroy()
                glView.dispose {
                    if (!isDestroy) {
                        argSession.destroy()
                        isDestroy = true
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    private fun getDisplaySize(): Point {
        val screenWidth = resources.displayMetrics.widthPixels
        val screenHeight = resources.displayMetrics.heightPixels

        val result = Point()
        result.x = screenWidth
        result.y = screenHeight

        return result
    }

    private fun setGLViewSize(cameraPreviewSize: IntArray?) {
        if (cameraPreviewSize == null) return

        val previewWidth = cameraPreviewSize[1]
        val previewHeight = cameraPreviewSize[0]

        val deviceWidth = ScreenUtil.getDisplaySize(context).x
        val deviceHeight = ScreenUtil.getDisplaySize(context).y

        if (ARGearConfig.screenRatio == ARGFrame.Ratio.RATIO_FULL) {
            glView.viewWidth =
                    (deviceHeight.toFloat() * previewWidth.toFloat() / previewHeight.toFloat()).toInt()
            glView.viewHeight = deviceHeight
        } else {
            glView.viewWidth = deviceWidth
            glView.viewHeight = (deviceWidth.toFloat() * previewHeight.toFloat() / previewWidth.toFloat()).toInt()
        }

        if ((gLViewWidth != glView.viewWidth || gLViewHeight != glView.height)
        ) {
//            glView.holder.setFixedSize(gLViewWidth, gLViewHeight)
        }

//        glView.holder?.setFixedSize(gLViewWidth, gLViewHeight)

        val params = LayoutParams(
            glView.viewWidth,
            glView.viewHeight
        )
        layoutParams = params
    }

    fun changeCameraRatio(ratio: Int) {
        if (::camera.isInitialized && ::argSession.isInitialized) {
            dimView.setBackgroundColor(Color.BLACK)

            argSession.pause()
            ARGearConfig.screenRatio = ARGearTypeUtils.convertRatioEnum(ratio)
//            setGLViewSize(camera.previewSize)

            Handler(Looper.getMainLooper()).postDelayed({
                setGLViewSize(camera.previewSize)
                argSession.resume()

                dimView.setBackgroundColor(Color.TRANSPARENT)
            }, 250)

        }
    }

    fun changeCameraFacing() {
        if (::camera.isInitialized && ::argSession.isInitialized) {
            argSession.pause()
            camera.changeCameraFacing()
            argSession.resume()
        }
    }

    private fun clearTempMediaFiles() {
        ARGearManager.innerMediaPath?.let {
//            FileDeleteAsyncTask(
//                File(it),
//                object : FileDeleteAsyncTask.OnAsyncFileDeleteListener {
//                    override fun processFinish(result: Any?) {
//                        val dir = File(it)
//                        if (!dir.exists()) {
//                            dir.mkdirs()
//                        }
//                    }
//                }).execute()

            FileAsyncUtil.deleteFile(
                File(it),
                object : OnAsyncFileDeleteListener {
                    override fun processFinish(result: Any?) {
                        val dir = File(it)
                        if (!dir.exists()) {
                            dir.mkdirs()
                        }
                    }
                })
        }
    }

    fun takePicture() {
        isShooting = true
        isShootingComplete = false
    }

    fun takePictureForFile(path: String) {
        flutterFilePath = path
        takePicture()
    }

    private fun takePictureOnGlThread(textureId: Int) {
//        runOnUiThread {
//            showShootProgress()
//        }

        isShooting = false
        val ratio: ARGMedia.Ratio = when (ARGearManager.screenRatio) {
            ARGFrame.Ratio.RATIO_FULL -> {
                ARGMedia.Ratio.RATIO_16_9
            }
            ARGFrame.Ratio.RATIO_4_3 -> {
                ARGMedia.Ratio.RATIO_4_3
            }
            else -> {
                ARGMedia.Ratio.RATIO_1_1
            }
        }

        val path = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            ARGearManager.innerMediaPath + "/" + System.currentTimeMillis() + ".jpg"
        } else {
            ARGearManager.mediaPath + "/" + System.currentTimeMillis() + ".jpg"
        }

        argMedia.takePicture(textureId, path, ratio)
        context.sendBroadcast(Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.parse("file://$path")))

        viewActivity?.runOnUiThread {
//            Toast.makeText(this, "The file has been saved to your Gallery.", Toast.LENGTH_SHORT).show()

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                MediaStoreUtil.writeImageToMediaStoreForQ(context,
                    path,
                    object : MediaStoreUtil.OnMediaStoreCallback {
                        override fun onComplete() {
                            isShootingComplete = true
                            methodChannel?.invokeMethod("takePictureCallback", "success")
                        }
                })
            } else {
                MediaStoreUtil.writeImageToMediaStore(context, path)
            }

        }
    }

    private fun takePictureOnGlThread(textureId: Int, fileNameJpg: String) {
        isShooting = false
        val ratio: ARGMedia.Ratio = when (ARGearManager.screenRatio) {
            ARGFrame.Ratio.RATIO_FULL -> {
                ARGMedia.Ratio.RATIO_16_9
            }
            ARGFrame.Ratio.RATIO_4_3 -> {
                ARGMedia.Ratio.RATIO_4_3
            }
            else -> {
                ARGMedia.Ratio.RATIO_1_1
            }
        }

        argMedia.takePicture(textureId, fileNameJpg, ratio)

        viewActivity?.runOnUiThread {
            methodChannel?.invokeMethod("takePictureCallback", "success")
            flutterFilePath = ""
        }
    }

    fun startRecording() {

        val bitrate = ARGearManager.getVideoBitrate()
        val ratio: ARGMedia.Ratio = when (ARGearManager.screenRatio) {
            ARGFrame.Ratio.RATIO_FULL -> {
                ARGMedia.Ratio.RATIO_16_9
            }
            ARGFrame.Ratio.RATIO_4_3 -> {
                ARGMedia.Ratio.RATIO_4_3
            }
            else -> {
                ARGMedia.Ratio.RATIO_1_1
            }
        }
        val previewSize: IntArray = camera.previewSize ?: return

        videoFilePath = ARGearManager.createVideoPath()
        argMedia.initRecorder(
                videoFilePath, previewSize[0], previewSize[1], bitrate,
            false, false, false, ratio
        )
        argMedia.startRecording()
    }

    fun stopRecording(callback: MediaStoreUtil.OnMediaStoreCallback) {

        glView.onQueueEvent(
            Runnable {
                isVideoRecord = false
                argMedia.stopRecording()
            }
        )

//        viewActivity?.runOnUiThread{
            Handler(Looper.getMainLooper()).postDelayed({
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    MediaStoreUtil.writeVideoToMediaStoreForQ(context, videoFilePath, callback)
                } else {
                    viewActivity?.sendBroadcast(
                        Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.parse("file://$videoFilePath"))
                    )
                    callback.onComplete()
                }
            }, 250)
//        }
    }
    
    // region - GLViewListener
    private var glViewListener: GLView.GLViewListener = object :
        GLView.GLViewListener {
        override fun onSurfaceCreated(
                gl: GL10?,
                config: EGLConfig?
        ) {
            screenRenderer.create(gl, config)
            cameraTexture.createCameraTexture()
        }

        override fun onDrawFrame(gl: GL10?, width: Int?, height: Int?) {
            camera.setCameraTexture(
                    cameraTexture.textureId,
                    cameraTexture.surfaceTexture
            )

            val localWidth = width ?: 0
            val localHeight = height ?: 0
            val frame = argSession.drawFrame(gl, screenRatio, localWidth, localHeight)
            frame?.let {
//                updateTriggerStatus(it.itemTriggerFlag)
                screenRenderer.draw(it, localWidth, localHeight)
                if (argMedia.isRecording) argMedia.updateFrame(it.textureId)
                if (isShooting && !isShootingComplete) {
//                    glView.onQueueEvent{
                        if (flutterFilePath.isNotEmpty()) {
                            takePictureOnGlThread(it.textureId, flutterFilePath)
                        } else {
                            takePictureOnGlThread(it.textureId)
                        }

//                    }
                }
            }
        }
    }
    // endregion

    // region - CameraListener
    private var cameraListener: ReferenceCamera.CameraListener = object : ReferenceCamera.CameraListener {
        override fun setConfig(
                previewWidth: Int,
                previewHeight: Int,
                verticalFov: Float,
                horizontalFov: Float,
                orientation: Int,
                isFrontFacing: Boolean,
                fps: Float
        ) {
            argSession.setCameraConfig(
                    ARGCameraConfig(
                            previewWidth,
                            previewHeight,
                            verticalFov,
                            horizontalFov,
                            orientation,
                            isFrontFacing,
                            fps
                    )
            )
        }

        // region - for camera api 1
        override fun feedRawData(data: ByteArray?) {
            argSession.feedRawData(data)
        }
        // endregion

        // region - for camera api 2
        override fun feedRawData(data: Image?) {
            argSession.feedRawData(data)
        } // endregion
    } // endregion
}
