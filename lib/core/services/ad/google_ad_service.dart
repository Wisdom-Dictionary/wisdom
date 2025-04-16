import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wisdom/core/services/ad/ad_service.dart';

class GoogleAdService implements AdService {
  @override
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  @override
  Future<void> showBannerAd() async {
    // TODO: implement showBannerAd
  }

  @override
  Future<void> showInterstitialAd() async {
    // TODO: implement showInterstitialAd
  }

  @override
  Widget getBannerAdWidget() {
    // TODO: implement getBannerAdWidget
    // throw UnimplementedError();
    return Center();
  }

  @override
  Future<void> refreshAds() async {
    // TODO: implement refreshAds
    // throw UnimplementedError();
  }
}
