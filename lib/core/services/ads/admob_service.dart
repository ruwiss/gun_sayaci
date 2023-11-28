import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gunsayaci/common/utils/strings.dart';

class AdmobService {
  final int interstitialShowLimit = 2;
  int interstitialCount = 0;

  static void _showAdLoadingWidget() =>
      EasyLoading.show(status: 'ad-waiting'.tr(), dismissOnTap: false);

  void callInterstitialAd() {
    if (interstitialShowLimit <= interstitialCount) return;
    _showAdLoadingWidget();
    InterstitialAd.load(
      adUnitId: KStrings.insertstitialAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          EasyLoading.dismiss();
          interstitialCount++;
          ad.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          EasyLoading.dismiss();
          log("Interstitial Ad Load Error : ${error.message}");
        },
      ),
    );
  }

  static void callAppOpenAd({bool hideLoadingWidget = false}) {
    if (!hideLoadingWidget) _showAdLoadingWidget();
    AppOpenAd.load(
      adUnitId: KStrings.appOpenAdId,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          if (!hideLoadingWidget) EasyLoading.dismiss();
          ad.show();
        },
        onAdFailedToLoad: (error) {
          if (!hideLoadingWidget) EasyLoading.dismiss();
          log("appOpenAd Load Error : ${error.message}");
        },
      ),
    );
  }
}
