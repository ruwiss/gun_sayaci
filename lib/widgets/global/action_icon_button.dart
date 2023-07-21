import 'package:flutter/material.dart';

class ActionIconButton extends StatelessWidget {
  final IconData iconData;
  final Function()? onTap;
  const ActionIconButton({Key? key, required this.iconData, this.onTap})
      : super(key: key);

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
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
      ),
    );
  }
}
