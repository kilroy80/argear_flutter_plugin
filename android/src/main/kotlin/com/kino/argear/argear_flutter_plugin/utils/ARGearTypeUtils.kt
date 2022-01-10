package com.kino.argear.argear_flutter_plugin.utils

import com.seerslab.argear.session.ARGContents
import com.seerslab.argear.session.ARGFrame
import com.seerslab.argear.session.config.ARGInferenceConfig.Feature

object ARGearTypeUtils {

    fun arrayToSet(intArray: IntArray?): Set<Feature>? {
        if (intArray == null) return null
        val result: MutableSet<Feature> = HashSet()
        for (value in intArray) {
            result.add(convertFeatureEnum(value))
        }
        return result
    }

    fun convertRatioEnum(type: Int): ARGFrame.Ratio {
        return when (type) {
            0 -> ARGFrame.Ratio.RATIO_1_1
            1 -> ARGFrame.Ratio.RATIO_4_3
            2 -> ARGFrame.Ratio.RATIO_FULL
            else -> ARGFrame.Ratio.RATIO_4_3
        }
    }

    fun convertFeatureEnum(type: Int): Feature {
        return when (type) {
            1 -> Feature.FACE_LOW_TRACKING
            2 -> Feature.FACE_HIGH_TRACKING
            3 -> Feature.FACE_MESH_TRACKING
            else -> Feature.SEGMENTATION_HALF
        }
    }

    fun convertType(type: Int): ARGContents.Type {
        return when (type) {
            1 -> ARGContents.Type.FilterItem
            2 -> ARGContents.Type.Beauty
            3 -> ARGContents.Type.Bulge
            else -> ARGContents.Type.ARGItem
        }
    }

    fun convertBeauty(type: Int): ARGContents.BeautyType {
        return when (type) {
            0 -> ARGContents.BeautyType.VLINE
            1 -> ARGContents.BeautyType.FACE_SLIM
            2 -> ARGContents.BeautyType.JAW
            3 -> ARGContents.BeautyType.CHIN
            4 -> ARGContents.BeautyType.EYE
            5 -> ARGContents.BeautyType.EYE_GAP
            6 -> ARGContents.BeautyType.NOSE_LINE
            7 -> ARGContents.BeautyType.NOSE_SIDE
            8 -> ARGContents.BeautyType.NOSE_LENGTH
            9 -> ARGContents.BeautyType.MOUTH_SIZE
            10 -> ARGContents.BeautyType.EYE_BACK
            11 -> ARGContents.BeautyType.EYE_CORNER
            12 -> ARGContents.BeautyType.LIP_SIZE
            13 -> ARGContents.BeautyType.SKIN_FACE
            14 -> ARGContents.BeautyType.SKIN_DARK_CIRCLE
            15 -> ARGContents.BeautyType.SKIN_MOUTH_WRINKLE
            else -> ARGContents.BeautyType.VLINE
        }
    }

    fun convertBulge(type: Int): ARGContents.BulgeType {
        return when (type) {
            0 -> ARGContents.BulgeType.FUN1
            1 -> ARGContents.BulgeType.FUN2
            2 -> ARGContents.BulgeType.FUN3
            3 -> ARGContents.BulgeType.FUN4
            4 -> ARGContents.BulgeType.FUN5
            5 -> ARGContents.BulgeType.FUN6
            else -> ARGContents.BulgeType.NONE
        }
    }
}
