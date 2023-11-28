import 'package:flutter/material.dart';
import 'package:gunsayaci/common/extensions/string_extensions.dart';
import 'package:gunsayaci/common/utils/utils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SettingsProvider with ChangeNotifier {
  final String _dataTable = 'settings';
  final String _darkModeKey = 'darkMode';

  late List<Map<String, Object?>> _settings;
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
    final db = await _openDatabase();
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $_dataTable (key TEXT, value TEXT)');
    await db.close();
  }

  Future<void> _getAllSettings() async {
    final db = await _openDatabase();
    _settings = await db.query(_dataTable);
    await db.close();
  }

  Object? _getSettingValue(String key) {
    for (var setting in _settings) {
      if (setting['key'] == key) {
        return setting['value'];
      }
    }
    return null;
  }

  void _getAppThemeMode() {
    final bool darkMode =
        (_getSettingValue(_darkModeKey) as String?)?.parseBool() ?? false;
    themeMode = darkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleTheme() async {
    final db = await _openDatabase();
    if (themeMode == ThemeMode.dark) {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.dark;
    }

    if (_getSettingValue(_darkModeKey) == null) {
      await db.insert(_dataTable, {
        'key': _darkModeKey,
        'value': (themeMode == ThemeMode.dark).toString()
      });
    } else {
      await db.update(
          _dataTable,
          {
            'key': _darkModeKey,
            'value': (themeMode == ThemeMode.dark).toString()
          },
          where: 'key=?',
          whereArgs: [_darkModeKey]);
    }

    await db.close();
    notifyListeners();
  }
}
