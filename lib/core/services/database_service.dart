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

  Future<void> insertData(DataModel model) async {
    locator<AdmobService>().callInterstitialAd();

    await _db
        .insert(dataTable, model.toMap())
        .then((value) => model.id = value);
    await NotificationHelper.addSchedule(model);
    locator<HomeProvider>().addToDataModelList(model);
  }

  Future<void> removeData(DataModel model) async {
    locator<AdmobService>().callInterstitialAd();
    await _db.delete(dataTable, where: 'id = ?', whereArgs: [model.id]);
    await NotificationHelper.removeSchedule(model);
    locator<HomeProvider>().removeFromDataModelList(model.id!);
  }

  Future<void> updateData({required int id, required DataModel model}) async {
    locator<AdmobService>().callInterstitialAd();

    await _db
        .update(dataTable, model.toMap(), where: 'id = ?', whereArgs: [id]);

    await NotificationHelper.updateSchedule(id, model..id = id);
    model.id = id;

    locator<HomeProvider>().updateDataModel(id: id, dataModel: model);
  }

  Future<List<DataModel>> getAllDatas() async {
    final results = await _db.query(dataTable);
    return results.map((e) => DataModel.fromJson(e)).toList();
  }
}
