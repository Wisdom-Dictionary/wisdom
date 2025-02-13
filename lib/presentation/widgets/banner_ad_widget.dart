import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/services/purchase_observer.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';

import '../../config/constants/app_decoration.dart';
import '../../config/constants/constants.dart';

class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: locator<LocalViewModel>().isNetworkAvailable,
      builder: (BuildContext context, value, Widget? child) {
        if (PurchasesObserver().isPro()) {
          return const SizedBox.shrink();
        }
        if (value) {
          locator<LocalViewModel>().adService.showBannerAd();
        }
        return value
            ? Container(
                margin: EdgeInsets.only(top: 16.h),
                padding: const EdgeInsets.all(8),
                // decoration: isDarkTheme ? AppDecoration.bannerDarkDecor : AppDecoration.bannerDecor,
                child: locator<LocalViewModel>().bannerAdWidget,
              )
            : const SizedBox.shrink();
      },
    );
  }
}
