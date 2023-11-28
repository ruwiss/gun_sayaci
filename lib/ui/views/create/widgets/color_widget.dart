import 'package:flutter/material.dart';
import 'package:gunsayaci/common/extensions/extensions.dart';
import 'package:gunsayaci/common/utils/utils.dart';
import 'package:gunsayaci/ui/views/create/create_provider.dart';
import 'package:provider/provider.dart';

class ColorWidget extends StatelessWidget {
  const ColorWidget({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateProvider>(
      builder: (context, model, child) {
        return InkWell(
          onTap: () => model.selectedColorIndex = index,
          child: Container(
            width: 25,
            height: 25,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: context.isDarkTheme
                  ? KColors.widgetColorsDark[index]
                  : KColors.widgetColorsLight[index],
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                  color: model.selectedColorIndex != index
                      ? Colors.grey
                      : Colors.white,
                  width: model.selectedColorIndex != index ? 1 : 1.5),
            ),
          ),
        );
      },
    );
  }
}
