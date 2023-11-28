import 'package:flutter/cupertino.dart';
import 'package:gunsayaci/common/models/models.dart';
import 'package:gunsayaci/core/core.dart';
import 'package:gunsayaci/core/services/database_service.dart';

class HomeProvider with ChangeNotifier {
  List<DataModel> dataModelList = [];

  Future<List<DataModel>> getAllDatas() async {
    dataModelList = await locator<DatabaseService>().getAllDatas();
    notifyListeners();
    return dataModelList;
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
