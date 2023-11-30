import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gunsayaci/models/models.dart';
import 'package:gunsayaci/core/core.dart';
import 'package:gunsayaci/utils/strings.dart';

class HomeProvider with ChangeNotifier {
  BannerAd? bannerAd;
  List<DataModel> dataModelList = [];

  Future<List<DataModel>> getAllDatas() async {
    await locator<CountdownService>().init();
    dataModelList = await locator<CountdownService>().getAllDatas();
    notifyListeners();
    loadBannerAd();
    return dataModelList;
  }

  void loadBannerAd() {
    AdmobService.loadBannerAd(
      adUnitId: Strings.homeBannerAdId,
      adSize: AdSize.fullBanner,
      onLoaded: (ad) {
        bannerAd = ad;
        notifyListeners();
      },
    );
  }

  void setDataModelList(List<DataModel> dataModelList) {
    this.dataModelList = dataModelList;
    notifyListeners();
  }

  void addToDataModelList(DataModel dataModel) {
    dataModelList.add(dataModel);
    notifyListeners();
  }

  void updateDataModel({required int id, required DataModel dataModel}) {
    dataModelList[dataModelList.indexWhere((element) => element.id == id)] =
        dataModel;
    notifyListeners();
  }

  void removeFromDataModelList(int id) {
    dataModelList.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
