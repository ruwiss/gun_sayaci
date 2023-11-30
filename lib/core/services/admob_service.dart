import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gunsayaci/core/router.dart';
import 'package:gunsayaci/utils/utils.dart';

class AdmobService {
  final int interstitialShowLimit = 2;
  int interstitialCount = 0;

  void callInterstitialAd() {
    if (interstitialShowLimit <= interstitialCount) return;
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

  static void loadBannerAd(
      {AdSize? adSize,
      required String adUnitId,
      Function(BannerAd ad)? onLoaded}) {
    BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: adSize ?? AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          log('$ad loaded.');
          onLoaded?.call(ad as BannerAd);
        },
        onAdFailedToLoad: (ad, err) {
          log('BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    ).load();
  }
}
