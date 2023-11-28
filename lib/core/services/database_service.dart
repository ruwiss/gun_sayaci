import 'package:easy_localization/easy_localization.dart';
import 'package:gunsayaci/common/utils/utils.dart';
import 'package:gunsayaci/core/core.dart';
import 'package:gunsayaci/core/services/ads/admob_service.dart';
import 'package:gunsayaci/core/services/notification_helper.dart';
import 'package:gunsayaci/common/models/data_model.dart';
import 'package:gunsayaci/ui/views/home/home_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  final String dataTable = 'sayac';

  Future<Database> _openDatabase() async {
    final String path = await getDatabasesPath();
    String databasePath = join(path, KStrings.dbFile);
    return await openDatabase(databasePath, version: 1);
  }

  Future<void> init() async {
    final db = await _openDatabase();
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $dataTable (id INTEGER PRIMARY KEY, title TEXT, color INTEGER, dateTime TEXT)');
    await db.close();
  }

  Future<void> insertData(DataModel dataModel) async {
    locator<AdmobService>().callInterstitialAd();
    final db = await _openDatabase();
    await db
        .insert(dataTable, dataModel.toMap())
        .then((value) => dataModel.id = value);
    locator<HomeProvider>().addToDataModelList(dataModel);
    _updateScheduleTimer();
    await db.close();
  }

  Future<void> removeData(int id) async {
    locator<AdmobService>().callInterstitialAd();
    final db = await _openDatabase();
    await db.rawDelete('DELETE FROM $dataTable WHERE id = ?', [id]);
    locator<HomeProvider>().removeFromDataModelList(id);
    _updateScheduleTimer();
    await db.close();
  }

  Future<void> updateData(
      {required int id, required DataModel dataModel}) async {
    locator<AdmobService>().callInterstitialAd();
    final db = await _openDatabase();
    await db
        .update(dataTable, dataModel.toMap(), where: 'id = ?', whereArgs: [id]);
    dataModel.id = id;
    locator<HomeProvider>().updateDataModel(id: id, dataModel: dataModel);
    _updateScheduleTimer();
    await db.close();
  }

  Future<List<DataModel>> getAllDatas() async {
    final db = await _openDatabase();
    final results = await db.query(dataTable);
    _updateScheduleTimer();
    await db.close();
    return results.map((e) => DataModel.fromJson(e)).toList();
  }

  Future<void> _updateScheduleTimer() async {
    final List<DataModel> dataModelList = locator<HomeProvider>().dataModelList;

    NotificationHelper.unScheduleAllNotifications();
    for (var i = 0; i < dataModelList.length; i++) {
      final DataModel dataModel = dataModelList[i];
      if (dataModel.dateTime.isAfter(DateTime.now())) {
        NotificationHelper.scheduleNotification(
            id: i,
            title: "reminder-title".tr(),
            body: "reminder-body".tr(args: [dataModel.title]),
            scheduledDateTime: dataModel.dateTime);

        final Duration difference =
            dataModel.dateTime.difference(DateTime.now());
        if (difference.inHours > 5) {
          NotificationHelper.scheduleNotification(
              id: i * 100,
              title: "reminder-title".tr(),
              body: "reminder-hour-body".tr(args: [dataModel.title]),
              scheduledDateTime:
                  dataModel.dateTime.subtract(const Duration(hours: 6)));
        }
        if (difference.inDays > 0) {
          NotificationHelper.scheduleNotification(
              id: i * 200,
              title: "reminder-title".tr(),
              body: "reminder-day-body".tr(args: [dataModel.title]),
              scheduledDateTime:
                  dataModel.dateTime.subtract(const Duration(days: 1)));
        }
      }
    }
  }
}
