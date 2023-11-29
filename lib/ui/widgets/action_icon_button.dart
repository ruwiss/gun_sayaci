import 'package:flutter/material.dart';
import 'package:gunsayaci/ui/theme.dart';

class ActionIconButton extends StatelessWidget {
  final IconData iconData;
  final Function()? onTap;
  const ActionIconButton({super.key, required this.iconData, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: CircleAvatar(
        backgroundColor: Colors.black.withOpacity(.08),
        radius: 18,
        child: IconButton(
          onPressed: onTap,
          icon: Icon(
            iconData,
            size: 20,
            color: context.isDarkTheme ? null : Colors.black87,
          ),
        ),
      ),
    );
  }
}
