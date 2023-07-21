import 'package:flutter/material.dart';
import 'package:gunsayaci/services/providers/settings_provider.dart';
import 'package:gunsayaci/utils/strings.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  Widget _settingsItem(
      {Function()? onTap,
      required String title,
      required Widget widget,
      required bool isDarkMode}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border(
            bottom:
                BorderSide(color: isDarkMode ? Colors.white10 : Colors.black12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            widget
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context);
    final bool isDarkMode = settingsProvider.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Ayarlar"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30),
          _settingsItem(
            title: "Karanlık Mod",
            onTap: () =>
                settingsProvider.setAppThemeMode(darkMode: !isDarkMode),
            isDarkMode: isDarkMode,
            widget: Text(isDarkMode ? "Açık" : "Kapalı"),
          ),
          _settingsItem(
            title: "Destek İçin Yıldız Ver",
            onTap: () => launchUrl(Uri.parse(KStrings.appLink),
                mode: LaunchMode.externalApplication),
            isDarkMode: isDarkMode,
            widget: Icon(
              Icons.star,
              color: isDarkMode ? Colors.yellow : Colors.black87,
            ),
          )
        ],
      ),
    );
  }
}
