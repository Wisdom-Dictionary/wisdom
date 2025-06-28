import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wisdom/core/services/purchase_observer.dart';
import 'package:wisdom/core/utils/common.dart';

class AdState extends ChangeNotifier {
  AdState();

  InitializationStatus? initialization;

  Future init() async {
    try {
      if (Platform.isWindows || Platform.isMacOS) return;
      if (!PurchasesObserver().isPro()) {
        initialization = await MobileAds.instance.initialize();
        log.i('log: AdState.init()');
      }
    } catch (e) {
      log.e(e);
    }
  }

  Future<InitializationStatus?> getInitialization() async {
    if (initialization == null) {
      await init();
    }
    return initialization;
  }

  String get bannerId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6651367008928070/5744793533';
    } else {
      return 'ca-app-pub-6651367008928070/3264676560';
    }
  }

  AdManagerBannerAdListener get adListener => _adListener;

  final AdManagerBannerAdListener _adListener = AdManagerBannerAdListener(
    onAdLoaded: (Ad ad) => log.i('Ad loaded.'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      log.e("Ad failed to load: $error");
    },
    onAdOpened: (Ad ad) => log.i("Ad opened"),
    onAdClosed: (Ad ad) => log.i("Ad closed"),
  );
}
