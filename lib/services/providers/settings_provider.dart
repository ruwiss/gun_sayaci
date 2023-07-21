import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gunsayaci/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool settingsFetch = false;
  late SharedPreferences _prefs;
  final String _appThemeKey = "darkTheme";
  bool isDarkMode = true;
  SettingsProvider() {
    getAppThemeMode();
  }

  void changeColors() =>
      isDarkMode ? KColors.setDarkColors() : KColors.setLightColors();

  void getAppThemeMode() async {
    _prefs = await SharedPreferences.getInstance();
    final bool? darkMode = _prefs.getBool(_appThemeKey);
    isDarkMode = darkMode ?? true;
    changeColors();
    settingsFetch = true;
    notifyListeners();
  }

  void setAppThemeMode({required bool darkMode}) async {
    await _prefs.setBool(_appThemeKey, darkMode);
    isDarkMode = darkMode;
    changeColors();
    notifyListeners();
  }
}
