import 'package:flutter/material.dart';

abstract class AdService {
  Future<void> initialize();

  Future<void> showBannerAd();

  Future<void> refreshAds();

  Future<void> showInterstitialAd();

  Widget getBannerAdWidget();
}
