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
  String? emoji;
  final titleController = TextEditingController();

  void _loadBannerAd() {
    AdmobService.loadBannerAd(
      adUnitId: Strings.createBannerAdId,
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
      emoji = model.emoji;
      appBarTitle = "edit".tr();
    }
  }

  Future<bool> submitData() async {
    if (emoji == null || emoji!.trim().isEmpty) emoji = null;
    final model = DataModel(
      selectedDate!,
      titleController.text,
      selectedColorIndex,
      emoji,
    );

    // Zamanlayıcıyı aktif et (Eğer şimdiki tarihten ileriyse)
    final bool schedule = NotificationHelper.checkDateIsAfter(model);

    if (dataModel != null) {
      await locator<CountdownService>()
          .updateData(id: dataModel!.id!, model: model, schedule: schedule);
    } else {
      await locator<CountdownService>()
          .insertData(model: model, schedule: schedule);
    }
    return true;
  }

  void setSelectedColor(int index) {
    selectedColorIndex = index;
    notifyListeners();
  }

  void selectEmoji(String emoji) async {
    this.emoji = emoji.trim().isEmpty ? null : emoji;
    notifyListeners();
  }
}
