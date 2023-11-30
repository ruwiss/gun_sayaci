import 'package:easy_localization/easy_localization.dart';
import 'package:gunsayaci/core/core.dart';
import 'package:gunsayaci/models/data_model.dart';
import 'package:gunsayaci/ui/views/home/home_provider.dart';
import 'package:gunsayaci/utils/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  late Database _db;
  final String dataTable = 'sayac';

  Future<void> _openDatabase() async {
    final String path = await getDatabasesPath();
    String databasePath = join(path, KStrings.dbFile);
    _db = await openDatabase(databasePath, version: 1);
  }

  Future<void> init() async {
    await _openDatabase();
    await _db.execute('''CREATE TABLE IF NOT EXISTS $dataTable 
        (id INTEGER PRIMARY KEY, title TEXT, color INTEGER, dateTime TEXT)''');
  }

  Future<void> insertData(DataModel dataModel) async {
    locator<AdmobService>().callInterstitialAd();
    await _db
        .insert(dataTable, dataModel.toMap())
        .then((value) => dataModel.id = value);
    locator<HomeProvider>().addToDataModelList(dataModel);
    _updateScheduleTimer();
  }

  Future<void> removeData(int id) async {
    locator<AdmobService>().callInterstitialAd();
    await _db.delete(dataTable, where: 'id = ?', whereArgs: [id]);
    locator<HomeProvider>().removeFromDataModelList(id);
    _updateScheduleTimer();
  }

  Future<void> updateData(
      {required int id, required DataModel dataModel}) async {
    locator<AdmobService>().callInterstitialAd();
    await _db
        .update(dataTable, dataModel.toMap(), where: 'id = ?', whereArgs: [id]);
    dataModel.id = id;
    locator<HomeProvider>().updateDataModel(id: id, dataModel: dataModel);
    _updateScheduleTimer();
  }

  Future<List<DataModel>> getAllDatas() async {
    final results = await _db.query(dataTable);
    _updateScheduleTimer();
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
