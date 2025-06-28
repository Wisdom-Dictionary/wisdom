import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wisdom/core/services/ad/ad_service.dart';
import 'package:wisdom/core/utils/common.dart';

import '../purchase_observer.dart';

class GoogleAdService implements AdService {
  InitializationStatus? initialization;
  AdManagerBannerAdListener? _adListener;
  InterstitialAd? interstitialAd;
  BannerAd? banner;
  bool isPro = false;
  static const String bannerIdAndroid = 'ca-app-pub-6651367008928070/5744793533';
  static const String bannerIdIos = 'ca-app-pub-6651367008928070/3264676560';
  static const String interstitialIdAndroid = 'ca-app-pub-6651367008928070/9544986489';
  static const String interstitialIdIos = 'ca-app-pub-6651367008928070/2683354223';

  @override
  Future<void> initialize() async {
    try {
      isPro = PurchasesObserver().isPro();
      initialization = await MobileAds.instance.initialize();
      if (initialization != null) {
        _adListener ??= AdManagerBannerAdListener(
          onAdLoaded: (Ad ad) => log.i('Ad loaded.'),
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            log.e("Ad failed to load: $error");
          },
          onAdOpened: (Ad ad) => log.i("Ad opened"),
          onAdClosed: (Ad ad) => log.i("Ad closed"),
        );
        _createBannerAd();
      }
      log.i('log: GoogleAdService.init()');
    } catch (_) {}
  }

  @override
  Future<void> showBannerAd() async {
    if (isPro) return;
    try {
      if (banner != null) {
        banner?.dispose();
        _createBannerAd();
      }
    } catch (_) {}
  }

  @override
  Future<void> showInterstitialAd() async {
    if (isPro) return;
    if (interstitialAd == null) {
      await _createInterstitialAdLoader();
    }
    interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _createInterstitialAdLoader();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _createInterstitialAdLoader();
      },
    );
    interstitialAd?.show();
    interstitialAd = null;
  }

  @override
  Widget getBannerAdWidget() {
    return banner == null
        ? const SizedBox.shrink()
        : SizedBox(
            height: banner!.size.height.toDouble(),
            child: AdWidget(
              ad: banner!..load(),
            ),
          );
  }

  @override
  Future<void> refreshAds() async {
    await banner?.load();
  }

  AdManagerBannerAdListener? get adListener => _adListener;

  Future<void> _createInterstitialAdLoader() async {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid ? interstitialIdAndroid : interstitialIdIos,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
          interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          interstitialAd = null;
          _createInterstitialAdLoader();
        },
      ),
    );
  }

  void _createBannerAd() {
    banner = BannerAd(
      adUnitId: Platform.isAndroid ? bannerIdAndroid : bannerIdIos,
      size: AdSize.mediumRectangle,
      request: const AdRequest(),
      listener: adListener!,
    );
  }
}
