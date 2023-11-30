import 'package:gunsayaci/core/core.dart';
import 'package:gunsayaci/core/services/database/database_service.dart';
import 'package:gunsayaci/models/data_model.dart';
import 'package:gunsayaci/ui/views/home/home_provider.dart';
import 'package:sqflite/sqflite.dart';

class CountdownService extends DatabaseService{
  final String dataTable = 'sayac';

  Future<void> insertData(
      {required DataModel model, bool schedule = true}) async {
    locator<AdmobService>().callInterstitialAd();

    await db
        .insert(dataTable, model.toMap())
        .then((value) => model.id = value);
    if (schedule) await NotificationHelper.addSchedule(model);
    locator<HomeProvider>().addToDataModelList(model);
  }

  Future<void> removeData(DataModel model) async {
    locator<AdmobService>().callInterstitialAd();
    await db.delete(dataTable, where: 'id = ?', whereArgs: [model.id]);
    await NotificationHelper.removeSchedule(model);
    locator<HomeProvider>().removeFromDataModelList(model.id!);
  }

  Future<void> updateData(
      {required int id, required DataModel model, bool schedule = true}) async {
    locator<AdmobService>().callInterstitialAd();

    await db.update(dataTable, model.toMap(),
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.ignore);

    if (schedule) await NotificationHelper.updateSchedule(id, model..id = id);
    locator<HomeProvider>().updateDataModel(id: id, dataModel: model..id = id);
    model.id = id;
  }

  Future<List<DataModel>> getAllDatas() async {
    final results = await db.query(dataTable);
    return results.map((e) => DataModel.fromJson(e)).toList();
  }
}
