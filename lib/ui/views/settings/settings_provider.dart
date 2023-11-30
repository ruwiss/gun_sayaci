import 'package:flutter/material.dart';
import 'package:gunsayaci/utils/utils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/settings_model.dart';

class SettingsProvider with ChangeNotifier {
  late Database _db;
  final String _dataTable = 'settings';

  late List<SettingsModel> _settings;
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  Future<void> init() async {
    await _initTable();
    await _getAllSettings();
    _getAppThemeMode();
  }

  Future<Database> _openDatabase() async {
    final String path = await getDatabasesPath();
    String databasePath = join(path, KStrings.dbFile);
    return await openDatabase(databasePath, version: 1);
  }

  Future<void> _initTable() async {
    _db = await _openDatabase();
    await _db.execute(
        'CREATE TABLE IF NOT EXISTS $_dataTable (key TEXT, value TEXT)');
  }

  Future<void> _getAllSettings() async {
    final values = await _db.query(_dataTable);
    _settings = values.map((e) => SettingsModel.fromJson(e)).toList();
  }

  String? _getSettingValue(String key) {
    for (SettingsModel setting in _settings) {
      if (setting.key == key) return setting.value;
    }
    return null;
  }

  bool? _getDarkThemeSettingValue() =>
      _getSettingValue(SettingsTypes.darkMode)?.parseBool();

  void _getAppThemeMode() {
    final bool darkMode = _getDarkThemeSettingValue() ?? false;
    themeMode = darkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleTheme() async {
    themeMode =
        (themeMode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;

    if (_getDarkThemeSettingValue() == null) {
      await _db.insert(_dataTable, SettingsModel.theme(themeMode).toJson());
    } else {
      await _db.update(_dataTable, SettingsModel.theme(themeMode).toJson(),
          where: 'key = ?', whereArgs: [SettingsTypes.darkMode]);
    }
    notifyListeners();
  }
}
