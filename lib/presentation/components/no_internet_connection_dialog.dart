import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/presentation/components/w_button.dart';

class NoInternetConnectionDialog extends StatelessWidget {
  const NoInternetConnectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 18, top: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "no_internet".tr(),
              style: AppTextStyle.font17W600Normal.copyWith(fontSize: 18, color: AppColors.orange),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: SvgPicture.asset(Assets.icons.wifiOff),
            ),
            Text(
              "no_internet_content".tr(),
              textAlign: TextAlign.center,
              style: AppTextStyle.font13W500Normal.copyWith(fontSize: 14, color: AppColors.black),
            ),
            const SizedBox(
              height: 32,
            ),
            WButton(
              title: "got_it".tr(),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
