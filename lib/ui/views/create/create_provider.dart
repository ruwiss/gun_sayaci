import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gunsayaci/common/models/data_model.dart';
import 'package:gunsayaci/core/core.dart';
import 'package:gunsayaci/core/services/database_service.dart';

class CreateProvider with ChangeNotifier {
  DataModel? dataModel;
  String appBarTitle = 'create'.tr();
  DateTime? selectedDate;
  int selectedColorIndex = -1;
  final titleController = TextEditingController();

  Future<void> init(DataModel? model) async {
    if (model != null) {
      dataModel = model;
      titleController.text = model.title;
      selectedDate = model.dateTime;
      selectedColorIndex = model.color;
      appBarTitle = "edit".tr();
    }
  }

  Future<void> submitData() async {
    final model =
        DataModel(selectedDate!, titleController.text, selectedColorIndex);

    if (dataModel != null) {
      await locator<DatabaseService>()
          .updateData(id: dataModel!.id!, dataModel: model);
    } else {
      await locator<DatabaseService>().insertData(model);
    }
  }

 
}
