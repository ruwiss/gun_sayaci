import 'package:flutter/material.dart';

class KColors {
  static late Color baseColor;
  static late Color softText;
  static const Color createPageBackground = Color(0xFFb4cef9);
  static const Color createPagePrimary = Color(0xFF6a87b7);

  static late List<Color> widgetColors;

  static List<Color> customBoxTitleGradient = [
    Colors.grey.shade200,
    Colors.white60,
    Colors.grey.shade200,
  ];

  static void setDarkColors() {
    baseColor = const Color(0xFF282c34);
    softText = Colors.white60;
    widgetColors = const [
      Color(0xFF466ca8),
      Color(0xFF7194cd),
      Color(0xFF528c99),
      Color(0xFF282c34)
    ];
  }

  static void setLightColors() {
    baseColor = const Color(0xFFFFFFFF);
    softText = Colors.black.withOpacity(.6);
    widgetColors = const [
      Color(0xFFcccafc),
      Color(0xFFc3d7fa),
      Color(0xFFb7eae3),
      Color(0xFFFFFFFF)
    ];
  }
}
