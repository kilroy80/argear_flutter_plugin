import 'package:argear_flutter_plugin/argear_flutter_plugin.dart';

class ARGearPlugUtil {

  final _valueList = <double>[];

  void setBeautyValue(List<double> list) {
    _valueList.addAll(list);
  }

  List<double> getBeautyValue() {
    return _valueList;
  }

  List<BeautyData> getBeautyDataValue() {
    List<BeautyData> list = <BeautyData>[];
    list.add(BeautyData(type: ARGBeauty.VLINE, min: 0, max: 100));                //VLINE
    list.add(BeautyData(type: ARGBeauty.FACE_SLIM, min: 0, max: 100));            //FACE_SLIM
    list.add(BeautyData(type: ARGBeauty.JAW, min: 0, max: 100));                  //JAW
    list.add(BeautyData(type: ARGBeauty.CHIN, min: -100, max: 100));              //CHIN
    list.add(BeautyData(type: ARGBeauty.EYE, min: 0, max: 100));                  //EYE
    list.add(BeautyData(type: ARGBeauty.EYE_GAP, min: -100, max: 100));           //EYE_GAP
    list.add(BeautyData(type: ARGBeauty.NOSE_LINE, min: 0, max: 100));            //NOSE_LINE
    list.add(BeautyData(type: ARGBeauty.NOSE_SIDE, min: 0, max: 100));            //NOSE_SIDE
    list.add(BeautyData(type: ARGBeauty.NOSE_LENGTH, min: -100, max: 100));       //NOSE_LENGTH
    list.add(BeautyData(type: ARGBeauty.MOUTH_SIZE, min: -100, max: 100));        //MOUTH_SIZE
    list.add(BeautyData(type: ARGBeauty.EYE_BACK, min: 0, max: 100));             //EYE_BACK
    list.add(BeautyData(type: ARGBeauty.EYE_CORNER, min: 0, max: 100));           //EYE_CORNER
    list.add(BeautyData(type: ARGBeauty.LIP_SIZE, min: -100, max: 100));          //LIP_SIZE
    list.add(BeautyData(type: ARGBeauty.SKIN_FACE, min: 0, max: 100));            //SKIN
    list.add(BeautyData(type: ARGBeauty.SKIN_DARK_CIRCLE, min: 0, max: 100));     //DARK_CIRCLE
    list.add(BeautyData(type: ARGBeauty.SKIN_MOUTH_WRINKLE, min: 0, max: 100));   //MOUTH_WRINKLE
    return list;
  }
}

class BeautyData {
  ARGBeauty type;
  double? min;
  double? max;
  double value;

  BeautyData({
    this.type = ARGBeauty.VLINE,
    this.min,
    this.max,
    this.value = 0.0,
  });

  dynamic toJson() => {
    'type': type,
    'min': min,
    'max': max,
    'value': value,
  };

  @override
  String toString() {
    return toJson().toString();
  }
}
