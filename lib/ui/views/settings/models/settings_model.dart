import 'package:flutter/material.dart';

@immutable
abstract class SettingsTypes {
  static const String darkMode = 'darkMode';
}

class SettingsModel {
  SettingsModel(this.key, this.value);
  final String key;
  final String value;

  SettingsModel.fromJson(Map<String, Object?> json)
      : key = json['key'] as String,
        value = json['value'] as String;

  Map<String, String> toJson() => {'key': key, 'value': value};

  factory SettingsModel.theme(ThemeMode mode) =>
      SettingsModel(SettingsTypes.darkMode, '${mode == ThemeMode.dark}');
}
