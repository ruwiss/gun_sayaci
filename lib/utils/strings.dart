import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

@immutable
abstract class KStrings {
  static const String dbFile = 'sayac.db';

  static const String appLink =
      "https://play.google.com/store/apps/details?id=com.rw.gunsayaci";

  static const String insertstitialAdId =
      "ca-app-pub-1923752572867502/3678023303";
  static const String appOpenAdId = "ca-app-pub-1923752572867502/6342896851";
  static const String homeBannerAdId = "ca-app-pub-1923752572867502/5842707820";

  static final List<String> dumpTimerHintTextList = [
    "dump-item-0".tr(),
    "dump-item-1".tr(),
    "dump-item-2".tr(),
    "dump-item-3".tr(),
    "dump-item-4".tr(),
    "dump-item-5".tr(),
    "dump-item-6".tr(),
  ];

  static String getRandomTimerHint() =>
      dumpTimerHintTextList[Random().nextInt(dumpTimerHintTextList.length)];

  static final List<String> supportedLocales = [
    'en',
    'tr',
    'ar',
    'az',
    'es',
    'fr',
    'hi',
    'ja',
    'ur',
    'pt',
    'ru'
  ];
}