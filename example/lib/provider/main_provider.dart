import 'package:argear_flutter_plugin/argear_flutter_plugin.dart';
import 'package:argear_flutter_plugin_example/api/api_service.dart';
import 'package:argear_flutter_plugin_example/model/fliter_list_model.dart';
import 'package:argear_flutter_plugin_example/model/normal_list_model.dart';
import 'package:argear_flutter_plugin_example/model/sticker_list_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum CameraButtonStauts {
  CaptureIdle, RecordIdle, RecordFadeOut, RecordFadeIn
}

class MainProvider extends GetxController {

  final apiService = ApiService();

  var selectTab = 0.obs;

  var contents = ContentsModel(null).obs;
  getContents() async {
    try {
      contents.value = await apiService.fetchMain();
      return contents;
    } catch(e) {
      print(e);
    }
  }

  var cameraButtonStatus = CameraButtonStauts.CaptureIdle.obs;

  var screenRatio = 0.obs;
  var videoBitrate = 0.obs;

  getVideoBitrate() {
    GetStorage box = GetStorage();
    videoBitrate.value = box.read("videoBitrate") != null ? box.read("videoBitrate") : 0;
    return videoBitrate;
  }

  List<StickerListModel> stickers = <StickerListModel>[].obs;
  setStickersData() {
    var content = contents.value;
    if (content.categories.length > 0 && stickers.isEmpty) {
      content.categories.forEach((element) {
        if (element.title != 'filter') {
          StickerListModel item = StickerListModel(
            uuid: element.uuid,
            title: element.title,
            description: element.description,
            isBundle: element.isBundle,
            status: element.status,
            updatedAt: element.updatedAt,
            items: element.items,
            selects: List.filled(element.items.length, false),
          );
          stickers.add(item);
        }
      });
    }
  }

  setSelectStickers(int pageIndex, int itemIndex) {
    List<StickerListModel> temp = [];
    temp.assignAll(stickers);

    temp.forEach((elements) {
      elements.selects = List.filled(elements.items.length, false);
    });

    if (pageIndex >= 0 && itemIndex >= 0) {
      temp[pageIndex].selects[itemIndex] = true;
    }

    stickers.assignAll(temp);
  }

  var selectFilterIndex = -1.0.obs;

  List<FilterListModel> filters = <FilterListModel>[].obs;
  initFiltersData() {
    var content = contents.value;
    if (content.categories.length > 0 && filters.isEmpty) {
      content.categories.forEach((elements) {
        if (elements.title == 'filter') {
          elements.items.forEach((element) {
            FilterListModel item = FilterListModel(
              itemModel: element,
              isSelect: false,
              filterValue: 100.0
            );
            filters.add(item);
          });
        }
      });
    }
  }

  setSelectFilters(int index) {
    var list = filters.asMap();
    list.forEach((key, value) {
      value.isSelect = false;
      value.filterValue = 100.0;

      if (key == index) {
        value.isSelect = true;
      }
    });
    filters.assignAll(list.values.toList());
  }

  var selectBeautyIndex = 0.obs;
  List<BeautyData> defaultDeautyData = <BeautyData>[];
  List<BeautyData> beautyData = <BeautyData>[].obs;

  initBeautyValue(Future<dynamic> list) async {
    if (list != null && beautyData != null && beautyData.isEmpty) {
      var data = await list;

      List<BeautyData> temp = [];
      temp.addAll(ARGearPlugUtil().getBeautyDataValue());

      List<BeautyData> defalutTemp = [];
      defalutTemp.addAll(ARGearPlugUtil().getBeautyDataValue());

      for (int i = 0; i < data.length; i++) {
        temp[i].value = data[i].toDouble();
        defalutTemp[i].value = data[i].toDouble();
      }

      beautyData.assignAll(temp);
      defaultDeautyData.assignAll(defalutTemp);
    }
  }

  resetBeautyValue() {
    List<BeautyData> temp = ARGearPlugUtil().getBeautyDataValue();
    temp.asMap().forEach((key, value) { value.value = defaultDeautyData[key].value; });
    beautyData.assignAll(temp.toList());
  }

  List<NormalListModel> beautyList = <NormalListModel>[].obs;
  initBeautyList() {
    if (beautyList != null && beautyList.isEmpty) {
      beautyList.add(NormalListModel(
          title: 'V Line',
          assetUrl: 'assets/images/ic_beauty_vline_normal.png',
          beutyType: ARGBeauty.VLINE,
          isSelect: false
      ));
      beautyList.add(NormalListModel(
          title: 'Slim',
          assetUrl: 'assets/images/ic_beauty_face_slim_normal.png',
          beutyType: ARGBeauty.FACE_SLIM,
          isSelect: false
      ));
      beautyList.add(NormalListModel(
          title: 'Length',
          assetUrl: 'assets/images/ic_beauty_jaw_nomral.png',
          beutyType: ARGBeauty.JAW,
          isSelect: false
      ));
      beautyList.add(NormalListModel(
          title: 'Chin',
          assetUrl: 'assets/images/ic_beauty_chin_normal.png',
          beutyType: ARGBeauty.CHIN,
          isSelect: false
      ));
      beautyList.add(NormalListModel(
          title: 'Size',
          assetUrl: 'assets/images/ic_beauty_eye_normal.png',
          beutyType: ARGBeauty.EYE,
          isSelect: false
      ));
      beautyList.add(NormalListModel(
          title: 'Distance',
          assetUrl: 'assets/images/ic_beauty_eye_gap_normal.png',
          beutyType: ARGBeauty.EYE_GAP,
          isSelect: false
      ));
      beautyList.add(NormalListModel(
          title: 'Narrow',
          assetUrl: 'assets/images/ic_beauty_nose_line_normal.png',
          beutyType: ARGBeauty.NOSE_LINE,
          isSelect: false
      ));
      beautyList.add(NormalListModel(
          title: 'Alas',
          assetUrl: 'assets/images/ic_beauty_nose_side_normal.png',
          beutyType: ARGBeauty.NOSE_SIDE,
          isSelect: false
      ));
      beautyList.add(NormalListModel(
          title: 'Length',
          assetUrl: 'assets/images/ic_beauty_nose_length_normal.png',
          beutyType: ARGBeauty.NOSE_LENGTH,
          isSelect: false
      ));
      beautyList.add(NormalListModel(
          title: 'Size',
          assetUrl: 'assets/images/ic_beauty_mouth_size_normal.png',
          beutyType: ARGBeauty.MOUTH_SIZE,
          isSelect: false
      ));
      beautyList.add(NormalListModel(
          title: 'Lateral',
          assetUrl: 'assets/images/ic_beauty_eye_back_normal.png',
          beutyType: ARGBeauty.EYE_BACK,
          isSelect: false
      ));
      beautyList.add(NormalListModel(
          title: 'Angle',
          assetUrl: 'assets/images/ic_beauty_eye_corner_normal.png',
          beutyType: ARGBeauty.EYE_CORNER,
          isSelect: false
      ));
      beautyList.add(NormalListModel(
          title: 'Lips',
          assetUrl: 'assets/images/ic_beauty_lip_size_normal.png',
          beutyType: ARGBeauty.LIP_SIZE,
          isSelect: false
      ));
      beautyList.add(NormalListModel(
          title: 'Skin',
          assetUrl: 'assets/images/ic_beauty_skin_face_normal.png',
          beutyType: ARGBeauty.SKIN_FACE,
          isSelect: false
      ));
      beautyList.add(NormalListModel(
          title: 'Circles',
          assetUrl: 'assets/images/ic_beauty_skin_dark_circle_normal.png',
          beutyType: ARGBeauty.SKIN_DARK_CIRCLE,
          isSelect: false
      ));
      beautyList.add(NormalListModel(
          title: 'Wrinkle',
          assetUrl: 'assets/images/ic_beauty_skin_mouth_wrinkle_normal.png',
          beutyType: ARGBeauty.SKIN_MOUTH_WRINKLE,
          isSelect: false
      ));
    }
  }

  selectBeautyList(int index) {
    beautyList.forEach((element) {
      element.isSelect = false;
    });
    if (index >= 0) {
      beautyList[index].isSelect = true;
    }
  }

  var selectBeulgeIndex = -1.0.obs;

  List<NormalListModel> bulgeList = <NormalListModel>[].obs;
  initBulgeList() {
    if (bulgeList != null && bulgeList.isEmpty) {
      bulgeList.add(NormalListModel(
          title: 'Pear',
          assetUrl: 'assets/images/ic_bulge_fun1.png',
          bulgeType: ARGBulge.FUN1,
          isSelect: false
      ));
      bulgeList.add(NormalListModel(
          title: 'Grinch',
          assetUrl: 'assets/images/ic_bulge_fun2.png',
          bulgeType: ARGBulge.FUN2,
          isSelect: false
      ));
      bulgeList.add(NormalListModel(
          title: 'Hamster',
          assetUrl: 'assets/images/ic_bulge_fun3.png',
          bulgeType: ARGBulge.FUN3,
          isSelect: false
      ));
      bulgeList.add(NormalListModel(
          title: 'Square',
          assetUrl: 'assets/images/ic_bulge_fun4.png',
          bulgeType: ARGBulge.FUN4,
          isSelect: false
      ));
      bulgeList.add(NormalListModel(
          title: 'Short',
          assetUrl: 'assets/images/ic_bulge_fun5.png',
          bulgeType: ARGBulge.FUN5,
          isSelect: false
      ));
      bulgeList.add(NormalListModel(
          title: 'Long',
          assetUrl: 'assets/images/ic_bulge_fun6.png',
          bulgeType: ARGBulge.FUN6,
          isSelect: false
      ));
    }
  }

  selectBulgeList(int index) {
    var list = bulgeList.asMap();
    list.forEach((key, value) {
      value.isSelect = false;

      if (key == index) {
        value.isSelect = true;
      }
    });
    bulgeList.assignAll(list.values.toList());
  }
}
