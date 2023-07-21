import 'package:flutter/cupertino.dart';
import 'package:gunsayaci/services/models/data_model.dart';

class HomeProvider with ChangeNotifier {
  List<DataModel> dataModelList = [];

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
