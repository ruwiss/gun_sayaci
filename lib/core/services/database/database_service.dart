import 'package:gunsayaci/ui/views/settings/models/models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  late Database db;
  final String _dbFile = 'sayac.db';
  final String countdownTable = 'sayac';
  final String settingsTable = 'settings';

  Future<void> _openDatabase() async {
    final String path = await getDatabasesPath();
    String databasePath = join(path, _dbFile);

    db = await openDatabase(databasePath, version: 3, singleInstance: true,
        onUpgrade: (db, oldVersion, newVersion) {
      db.delete(settingsTable,
          where: 'key = ?', whereArgs: [SettingsTypes.welcomeMessage]);
      if (oldVersion < 3) {
        db.execute('ALTER TABLE $countdownTable ADD COLUMN emoji TEXT');
      }
    });
  }

  Future<void> init() async {
    await _openDatabase();

    await db.execute(
        'CREATE TABLE IF NOT EXISTS $settingsTable (key TEXT, value TEXT)');

    await db.execute('''CREATE TABLE IF NOT EXISTS $countdownTable 
        (id INTEGER PRIMARY KEY, title TEXT, color INTEGER, emoji Text, dateTime TEXT)''');
  }
}
