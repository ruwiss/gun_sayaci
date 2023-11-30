import 'package:flutter/material.dart';
import 'package:gunsayaci/ui/theme.dart';

enum CustomActionButtonTypes { icon, emoji }

class CustomActionButton extends StatelessWidget {
  final CustomActionButtonTypes type;
  final IconData? iconData;
  final String? emoji;
  final Function()? onTap;

  const CustomActionButton({super.key, required this.iconData, this.onTap})
      : type = CustomActionButtonTypes.icon,
        emoji = null;

  const CustomActionButton.emoji({super.key, required this.emoji, this.onTap})
      : type = CustomActionButtonTypes.emoji,
        iconData = null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: CircleAvatar(
        backgroundColor: Colors.black.withOpacity(.08),
        radius: 18,
        child: IconButton(
            onPressed: onTap,
            icon: switch (type) {
              CustomActionButtonTypes.icon => Icon(
                  iconData,
                  size: 20,
                  color: context.isDarkTheme ? null : Colors.black87,
                ),
              CustomActionButtonTypes.emoji =>
                Text(emoji!, style: const TextStyle(fontSize: 16))
            }),
      ),
    );
  }
}
