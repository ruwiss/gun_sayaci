import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gunsayaci/common/utils/strings.dart';
import 'package:gunsayaci/core/router.dart';

class AdmobService {
  final int interstitialShowLimit = 2;
  int interstitialCount = 0;

  static void _showLoadingWidget() {
    showDialog(
      context: router.routerDelegate.navigatorKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
                width: 25, height: 25, child: CircularProgressIndicator()),
            Text('ad-waiting'.tr(), style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }

  void callInterstitialAd() {
    if (interstitialShowLimit <= interstitialCount) return;
    _showLoadingWidget();
    InterstitialAd.load(
      adUnitId: KStrings.insertstitialAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialCount++;
          ad.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          log("Interstitial Ad Load Error : ${error.message}");
        },
      ),
    );
  }

  static void callAppOpenAd({Function()? onAction}) {
    _showLoadingWidget();
    AppOpenAd.load(
      adUnitId: KStrings.appOpenAdId,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          onAction?.call();
          ad.show();
        },
        onAdFailedToLoad: (error) {
          onAction?.call();
          log("appOpenAd Load Error : ${error.message}");
        },
      ),
    );
  }
}
