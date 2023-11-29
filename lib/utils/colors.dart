import 'package:flutter/material.dart';

@immutable
abstract class KColors {
  static const Color createPageBackground = Color(0xFFb4cef9);
  static const Color createPagePrimary = Color(0xFF6a87b7);

  static const Color baseColorDark = Color(0xFF282c34);
  static const Color softTextDark = Colors.white60;
  static const List<Color> widgetColorsDark = [
    Color(0xFF466ca8),
    Color(0xFF7194cd),
    Color(0xFF528c99),
    Color(0xFF282c34)
  ];

  static const Color baseColorLight = Color(0xFFFFFFFF);
  static final Color softTextLight = Colors.black.withOpacity(.6);
  static const List<Color> widgetColorsLight = [
   Color(0xFFcccafc),
      Color(0xFFc3d7fa),
      Color(0xFFb7eae3),
      Color(0xFFFFFFFF)
  ];

  static List<Color> customBoxTitleGradient = [
    Colors.grey.shade200,
    Colors.white60,
    Colors.grey.shade200,
  ];
}
