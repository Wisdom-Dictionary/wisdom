import 'package:flutter/material.dart';
import 'package:wisdom/core/services/ad/ad_service.dart';
import 'package:wisdom/presentation/widgets/social_button.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import '../../core/di/app_locator.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final adService = locator<AdService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 200,
              child: adService.getBannerAdWidget(),
            ),
            AppButtonWidget(
              onTap: () {},
              title: 'ShowBanner',
            ),
            AppButtonWidget(
              onTap: () async {
                await adService.showInterstitialAd();
              },
              title: 'ShowInterstitial',
            ),
            AppButtonWidget(
              onTap: () async {
                await MobileAds.showDebugPanel();
              },
              title: 'Initialize',
            ),
          ],
        ),
      ),
    );
  }
}
