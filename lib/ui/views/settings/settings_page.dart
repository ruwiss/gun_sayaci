import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gunsayaci/ui/views/settings/settings_provider.dart';
import 'package:gunsayaci/ui/views/settings/widgets/settings_item.dart';
import 'package:gunsayaci/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("settings").tr(),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, model, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            SettingsItem(
              title: "dark-mode".tr(),
              onTap: () => model.toggleTheme(),
              widget: Text(model.isDarkMode ? "on".tr() : "off".tr()),
            ),
            SettingsItem(
              title: "support-app".tr(),
              onTap: () => launchUrl(Uri.parse(Strings.appLink),
                  mode: LaunchMode.externalApplication),
              widget: Icon(
                Icons.star,
                color: model.isDarkMode ? Colors.yellow : Colors.black87,
              ),
            )
          ],
        ),
      ),
    );
  }
}
