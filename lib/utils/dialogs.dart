import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gunsayaci/utils/utils.dart';

extension Dialogs on BuildContext {
  void showWelcomeDialog() {
    showDialog(
      context: this,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Image.asset(KImages.logo, height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 15),
                  child: Text('app-name'.tr(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                ),
                const Text('(${Strings.appVersion})',
                    style: TextStyle(fontSize: 12))
              ],
            ),
            const SizedBox(height: 15),
            Text('welcome-msg'.tr()),
          ],
        ),
      ),
    );
  }
}
