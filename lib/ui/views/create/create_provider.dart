import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gunsayaci/models/data_model.dart';
import 'package:gunsayaci/core/core.dart';
import 'package:gunsayaci/utils/utils.dart';

class CreateProvider with ChangeNotifier {
  BannerAd? bannerAd;
  DataModel? dataModel;
  String appBarTitle = 'create'.tr();
  DateTime? selectedDate;
  int selectedColorIndex = -1;
  final titleController = TextEditingController();

  void _loadBannerAd() {
    AdmobService.loadBannerAd(
      adUnitId: KStrings.createBannerAdId,
      onLoaded: (ad) {
        bannerAd = ad;
        notifyListeners();
      },
    );
  }

  Future<void> init(DataModel? model) async {
    _loadBannerAd();
    if (model != null) {
      dataModel = model;
      titleController.text = model.title;
      selectedDate = model.dateTime;
      selectedColorIndex = model.color;
      appBarTitle = "edit".tr();
    }
  }

  Future<bool> submitData() async {
    final model =
        DataModel(selectedDate!, titleController.text, selectedColorIndex);

    if (!NotificationHelper.checkDateIsAfter(model)) return false;

    if (dataModel != null) {
      await locator<DatabaseService>()
          .updateData(id: dataModel!.id!, model: model);
    } else {
      await locator<DatabaseService>().insertData(model);
    }
    return true;
  }

  void setSelectedColor(int index) {
    selectedColorIndex = index;
    notifyListeners();
  }
}
