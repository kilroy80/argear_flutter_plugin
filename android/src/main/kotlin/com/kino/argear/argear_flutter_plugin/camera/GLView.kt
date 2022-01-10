package com.kino.argear.argear_flutter_plugin.camera

import android.content.Context
import android.graphics.PixelFormat
import android.opengl.GLSurfaceView
import android.view.View
import com.kino.argear.argear_flutter_plugin.core.ARGearConfig
import com.kino.argear.argear_flutter_plugin.utils.ScreenUtil
import com.seerslab.argear.session.ARGFrame
import javax.microedition.khronos.egl.EGLConfig
import javax.microedition.khronos.opengles.GL10

class GLView: GLSurfaceView, GLSurfaceView.Renderer {

    private val TAG = GLView::class.java.simpleName

    interface GLViewListener {
        fun onSurfaceCreated(gl: GL10?, config: EGLConfig?)
        fun onDrawFrame(gl: GL10?, width: Int?, height: Int?)
    }

    constructor(context: Context) : super(context) {
        init()
    }

    constructor(context: Context, listener: GLViewListener) : super(context) {
        init()
        this.listener = listener
    }

    var viewWidth = 0
    var viewHeight = 0
    private var listener: GLViewListener? = null

    private fun init() {
        setEGLContextClientVersion(2)
        setEGLConfigChooser(8, 8, 8, 8, 16, 8)
        holder.setFormat(PixelFormat.RGBA_8888)

        setRenderer(this)
        setZOrderOnTop(true)

        renderMode = RENDERMODE_CONTINUOUSLY
        preserveEGLContextOnPause = false
    }

    // region - GLSurfaceView
    override fun onResume() {
        super.onResume()
        renderMode = RENDERMODE_CONTINUOUSLY
    }

    override fun onPause() {
        super.onPause()
        renderMode = RENDERMODE_CONTINUOUSLY
    }

    fun onQueueEvent(r: Runnable) {
        queueEvent(r)
    }

    fun dispose(r: Runnable) {
        queueEvent(r)
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        val width = View.resolveSize(suggestedMinimumWidth, widthMeasureSpec)
        val height = View.resolveSize(suggestedMinimumHeight, heightMeasureSpec)

        if (viewWidth > 0 && viewHeight > 0) {
            super.onMeasure(widthMeasureSpec, heightMeasureSpec)
            setMeasuredDimension(viewWidth, viewHeight)
            setMeasureSurfaceView()
        } else {
            setMeasuredDimension(width, height)
        }
    }

    private fun setMeasureSurfaceView() {
        if (ARGearConfig.screenRatio == ARGFrame.Ratio.RATIO_FULL && viewWidth > ScreenUtil.getDisplaySize(context).x) {
            x = (ScreenUtil.getDisplaySize(context).x - viewWidth) / 2.toFloat()
        } else {
            x = 0.0f
        }
    }

    // region - Renderer
    override fun onSurfaceCreated(gl: GL10?, config: EGLConfig?) {
        listener?.onSurfaceCreated(gl, config)
    }

    override fun onSurfaceChanged(gl: GL10?, width: Int, height: Int) {
        viewWidth = width
        viewHeight = height
    }

    override fun onDrawFrame(gl: GL10?) {
        listener?.onDrawFrame(gl, viewWidth, viewHeight)
    }
    // endregion
}
