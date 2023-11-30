import 'package:flutter/material.dart';
import 'package:gunsayaci/core/core.dart';
import 'package:gunsayaci/core/services/database/database_service.dart';
import 'package:gunsayaci/ui/views/settings/models/models.dart';
import 'package:gunsayaci/ui/views/settings/settings_provider.dart';

class SettingsService extends DatabaseService {
  Future<void> getSettings() async {
    await init();
    await _getAllSettings();
    locator<SettingsProvider>().getAppThemeMode();
  }

  Future<void> _getAllSettings() async {
    final values = await db.query(settingsTable);
    locator<SettingsProvider>()
        .setSettings(values.map((e) => SettingsModel.fromJson(e)).toList());
  }

  void setWelcomeMessageShown() async {
    await db.insert(settingsTable,
        SettingsModel(SettingsTypes.welcomeMessage, 'true').toJson());
  }

  Future<void> setThemeMode(
      {bool update = false, required ThemeMode themeMode}) async {
    if (!update) {
      await db.insert(settingsTable, SettingsModel.theme(themeMode).toJson());
    } else {
      await db.update(settingsTable, SettingsModel.theme(themeMode).toJson(),
          where: 'key = ?', whereArgs: [SettingsTypes.darkMode]);
    }
  }
}
