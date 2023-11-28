import 'package:flutter/material.dart';
import 'package:gunsayaci/ui/views/settings/settings_provider.dart';
import 'package:provider/provider.dart';

class SettingsItem extends StatelessWidget {
  const SettingsItem(
      {super.key, this.onTap, required this.title, required this.widget});
  final VoidCallback? onTap;
  final String title;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Consumer<SettingsProvider>(
        builder: (context, model, child) {
          return Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: model.themeMode == ThemeMode.dark
                      ? Colors.white10
                      : Colors.black12,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w500),
                ),
                widget
              ],
            ),
          );
        },
      ),
    );
  }
}
