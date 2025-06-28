import 'package:flutter/material.dart';
import 'package:wisdom/core/services/ad/ad_service.dart';

class FakeAdService extends AdService {
  @override
  Widget getBannerAdWidget() {
    return const SizedBox.shrink();
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<void> refreshAds() async {}

  @override
  Future<void> showBannerAd() async {}

  @override
  Future<void> showInterstitialAd() async {}
}
