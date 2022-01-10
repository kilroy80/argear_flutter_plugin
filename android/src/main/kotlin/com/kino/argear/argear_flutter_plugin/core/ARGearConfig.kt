package com.kino.argear.argear_flutter_plugin.core

import com.seerslab.argear.session.ARGContents
import com.seerslab.argear.session.ARGFrame

object ARGearConfig {

    // preference
    @JvmField
    val USER_PREF_NAME = "com.kino.argear.argear_flutter_plugin" + ".Preference"
    @JvmField
    val USER_PREF_NAME_FILTER = "com.kino.argear.argear_flutter_plugin" + ".ARGearFilter.Preference"
    @JvmField
    val USER_PREF_NAME_STICKER = "com.kino.argear.argear_flutter_plugin" + ".ARGearItem.Preference"

    var screenRatio: ARGFrame.Ratio = ARGFrame.Ratio.RATIO_FULL

    // camera
    // 1: CAMERA_API_1, 2: CAMERA_API_2
    @JvmField
    val USE_CAMERA_API = 1

    @JvmField
    val BEAUTY_TYPE_NUM = ARGContents.BEAUTY_TYPE_NUM

    // region - beauty sample
    @JvmField
    val BEAUTY_TYPE_INIT_VALUE = floatArrayOf(
            10f,     //VLINE
            90f,     //FACE_SLIM
            55f,     //JAW
            -50f,    //CHIN
            5f,      //EYE
            -10f,    //EYE_GAP
            0f,      //NOSE_LINE
            35f,     //NOSE_SIDE
            30f,     //NOSE_LENGTH
            -35f,    //MOUTH_SIZE
            0f,      //EYE_BACK
            0f,      //EYE_CORNER
            0f,      //LIP_SIZE
            50f,     //SKIN
            0f,      //DARK_CIRCLE
            0f       //MOUTH_WRINKLE
    )

    @JvmField
    val BASIC_BEAUTY_1 = floatArrayOf(20f, 10f, 45f, 45f, 5f, -10f, 40f, 20f, 15f, 0f, 0f, 0f, 0f, 50f, 0f, 0f)

    @JvmField
    val BASIC_BEAUTY_2 = floatArrayOf(10f, 90f, 55f, -50f, 5f, -10f, 0f, 35f, 30f, -35f, 0f, 0f, 0f, 50f, 0f, 0f)

    @JvmField
    val BASIC_BEAUTY_3 = floatArrayOf(25f, 20f, 50f, -25f, 25f, -10f, 30f, 40f, 90f, 0f, 0f, 0f, 0f, 50f, 0f, 0f)
    // endregion
}
