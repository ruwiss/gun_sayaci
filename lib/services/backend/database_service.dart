import 'package:easy_localization/easy_localization.dart';
import 'package:gunsayaci/locator.dart';
import 'package:gunsayaci/services/functions/admob_service.dart';
import 'package:gunsayaci/services/functions/notification_helper.dart';
import 'package:gunsayaci/services/models/data_model.dart';
import 'package:gunsayaci/services/providers/home_provider.dart';
import 'package:gunsayaci/utils/strings.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  final String _dataTable = "sayac";
  final String _dbFile = "sayac.db";
  int _adShowCount = 0;

  void _callInterstitialAd() {
    if (_adShowCount < AdmobService.interstitalShowCount) {
      _adShowCount++;
      AdmobService.callInterstitialAd();
    }
  }

  Future<Database> _openDatabase() async {
    final String path = await getDatabasesPath();
    String databasePath = join(path, _dbFile);
    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE $_dataTable (id INTEGER PRIMARY KEY, title TEXT, color INTEGER, dateTime TEXT)');
      },
    );
  }

  Future<void> insertData(DataModel dataModel) async {
    _callInterstitialAd();
    final db = await _openDatabase();
    await db
        .insert(_dataTable, dataModel.toMap())
        .then((value) => dataModel.id = value);
    final HomeProvider homeProvider = locator.get<HomeProvider>();
    homeProvider.addToDataModelList(dataModel);
    _addDatasToSchedule();
    await db.close();
  }

  Future<void> removeData(int id) async {
    _callInterstitialAd();
    final db = await _openDatabase();
    await db.rawDelete('DELETE FROM $_dataTable WHERE id = ?', [id]);
    final HomeProvider homeProvider = locator.get<HomeProvider>();
    homeProvider.removeFromDataModelList(id);
    _addDatasToSchedule();
    await db.close();
  }

  Future<void> updateData(
      {required int id, required DataModel dataModel}) async {
    _callInterstitialAd();
    final db = await _openDatabase();
    await db.update(_dataTable, dataModel.toMap(),
        where: 'id = ?', whereArgs: [id]);
    final HomeProvider homeProvider = locator.get<HomeProvider>();
    dataModel.id = id;
    homeProvider.updateDataModel(id: id, dataModel: dataModel);
    _addDatasToSchedule();
    await db.close();
  }

  Future<void> getAllDatas() async {
    final db = await _openDatabase();
    final HomeProvider homeProvider = locator.get<HomeProvider>();
    final results = await db.query(_dataTable);
    homeProvider
        .setDataModelList(results.map((e) => DataModel.fromJson(e)).toList());
    _addDatasToSchedule();
    await db.close();
  }

  Future<void> _addDatasToSchedule() async {
    final HomeProvider homeProvider = locator.get<HomeProvider>();
    final List<DataModel> dataModelList = homeProvider.dataModelList;
    NotificationHelper.unScheduleAllNotifications();
    for (var i = 0; i < dataModelList.length; i++) {
      final DataModel dataModel = dataModelList[i];
      if (dataModel.dateTime.isAfter(DateTime.now())) {
        NotificationHelper.scheduleNotification(
            id: i,
            title: "reminder-title".tr(),
            body: "reminder-body".tr(args: [dataModel.title]),
            scheduledDateTime: dataModel.dateTime);
      }
    }
  }
}
