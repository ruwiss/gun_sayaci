import 'package:flutter/material.dart';
import 'package:gunsayaci/core/core.dart';
import 'package:gunsayaci/core/services/database/settings_service.dart';
import 'package:gunsayaci/utils/utils.dart';

import 'models/settings_model.dart';

class SettingsProvider with ChangeNotifier {
  late List<SettingsModel> _settings;
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void setSettings(List<SettingsModel> settings) {
    _settings = settings;
    notifyListeners();
  }

  String? _getSettingValue(String key) {
    for (SettingsModel setting in _settings) {
      if (setting.key == key) return setting.value;
    }
    return null;
  }

  bool welcomeMessageShown() =>
      _getSettingValue(SettingsTypes.welcomeMessage) != null;

  bool? _getDarkThemeSettingValue() =>
      _getSettingValue(SettingsTypes.darkMode)?.parseBool();

  void getAppThemeMode() {
    final bool darkMode = _getDarkThemeSettingValue() ?? false;
    themeMode = darkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleTheme() async {
    themeMode =
        (themeMode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    locator<SettingsService>().setThemeMode(
        themeMode: themeMode, update: _getDarkThemeSettingValue() != null);
    notifyListeners();
  }
}
