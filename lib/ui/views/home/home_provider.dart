import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gunsayaci/common/models/models.dart';
import 'package:gunsayaci/core/core.dart';
import 'package:gunsayaci/core/services/admob_service.dart';
import 'package:gunsayaci/core/services/database_service.dart';

class HomeProvider with ChangeNotifier {
  BannerAd? bannerAd;
  List<DataModel> dataModelList = [];

  Future<List<DataModel>> getAllDatas() async {
    await locator<DatabaseService>().init();
    dataModelList = await locator<DatabaseService>().getAllDatas();
    notifyListeners();
    loadBannerAd();
    return dataModelList;
  }

  void loadBannerAd() {
    locator<AdmobService>().loadBannerAd(onLoaded: (ad) {
      bannerAd = ad;
      notifyListeners();
    });
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
