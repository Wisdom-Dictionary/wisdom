import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisdom/core/services/ad/ad_service.dart';
import 'package:wisdom/core/utils/common.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import '../purchase_observer.dart';

class YandexAdService implements AdService {
  Future<InterstitialAdLoader>? _adLoader;
  BannerAd? banner;
  InterstitialAd? _ad;
  var isBannerAlreadyCreated = false;
  bool isPro = false;
  static const String id1 = 'R-M-13355816-3'; //native ad
  static const String id2 = 'R-M-13355816-1'; //banner ad
  static const String interstitialId = 'R-M-13355816-2'; //interstitial ad

  Random random = Random();

  @override
  Future<void> initialize() async {
    isPro = PurchasesObserver().isPro();
    await MobileAds.setLogging(true);
    await MobileAds.initialize();
    await MobileAds.setAgeRestrictedUser(true);
    _adLoader = _createInterstitialAdLoader();
    await _loadInterstitialAd();
    _createBanner();
  }

  @override
  Future<void> showBannerAd() async {
    if (isPro) return;
    log.w('showBannerAd ==========');

    try {
      if (banner == null) {
        _createBanner();
      } else {
        await banner?.loadAd(adRequest: const AdRequest());
      }
    } catch (e) {
      log.e('showBannerAd error: $e');
    }
  }

  @override
  Future<void> showInterstitialAd() async {
    if (isPro) return;
    _ad?.setAdEventListener(
        eventListener: InterstitialAdEventListener(
      onAdShown: () {
        // Called when an ad is shown.
      },
      onAdFailedToShow: (error) {
        // Called when an InterstitialAd failed to show.
        // Destroy the ad so you don't show the ad a second time.
        _ad?.destroy();
        _ad = null;

        // Now you can preload the next interstitial ad.
        _loadInterstitialAd();
      },
      onAdClicked: () {
        // Called when a click is recorded for an ad.
      },
      onAdDismissed: () {
        // Called when ad is dismissed.
        // Destroy the ad so you don't show the ad a second time.
        _ad?.destroy();
        _ad = null;

        // Now you can preload the next interstitial ad.
        _loadInterstitialAd();
      },
      onAdImpression: (impressionData) {
        // Called when an impression is recorded for an ad.
      },
    ));
    await _ad?.show();
    await _ad?.waitForDismiss();
  }

  @override
  Widget getBannerAdWidget() {
    if (banner == null) return const SizedBox.shrink();
    return SizedBox(
      // height: 250,
      // width: 300,
      child: AdWidget(
        bannerAd: banner!..loadAd(adRequest: AdRequest()),
      ),
    );
  }

  Future<InterstitialAdLoader> _createInterstitialAdLoader() {
    return InterstitialAdLoader.create(
      onAdLoaded: (InterstitialAd interstitialAd) {
        // The ad was loaded successfully. Now you can show loaded ad
        _ad = interstitialAd;
        log.w('Interstitial ad loaded');
      },
      onAdFailedToLoad: (error) {
        // The ad failed to load
        log.e('Interstitial ad failed to load: $error');
      },
    );
  }

  Future<void> _loadInterstitialAd() async {
    final adLoader = await _adLoader;
    await adLoader?.loadAd(
      adRequestConfiguration: const AdRequestConfiguration(adUnitId: interstitialId),
    );
  }

  _createBanner() {
    banner = BannerAd(
      adUnitId: random.nextBool() ? id1 : id2,
      adSize: _getAdSize(),
      adRequest: const AdRequest(),
      onAdLoaded: () {

      },
      onAdFailedToLoad: (error) {
        print('Banner ad failed to load: $error');
        banner == null;
        // Ad failed to load with AdRequestError.
        // Attempting to load a new ad from the onAdFailedToLoad() method is strongly discouraged.
      },
      onAdClicked: () {
        print('Banner ad clicked');
        // Called when a click is recorded for an ad.
      },
      onLeftApplication: () {
        // Called when user is about to leave application (e.g., to go to the browser), as a result of clicking on the ad.
      },
      onReturnedToApplication: () {
        // Called when user returned to application after click.
      },
      onImpression: (impressionData) {
        // Called when an impression is recorded for an ad.
      },
    );
    banner?.loadAd();
  }

  BannerAdSize _getAdSize() {
    final screenWidth = 1.sw.round() - 50;
    return BannerAdSize.inline(width: screenWidth, maxHeight: 400);
  }

  @override
  Future<void> refreshAds() async {
    banner?.loadAd(adRequest: const AdRequest());
  }
}
