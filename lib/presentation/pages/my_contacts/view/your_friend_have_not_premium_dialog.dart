import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/presentation/components/w_button.dart';

class YourFriendHaveNotPremiumDialog extends StatelessWidget {
  const YourFriendHaveNotPremiumDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 18, top: 32),
          child: Material(
            borderRadius: BorderRadius.circular(18),
            color: isDarkTheme ? AppColors.darkGray : AppColors.white,
            child: ListView(
              physics: ClampingScrollPhysics(),
              padding: const EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 24),
              shrinkWrap: true,
              children: [
                Text(
                  "Oops...",
                  textAlign: TextAlign.center,
                  style:
                      AppTextStyle.font17W600Normal.copyWith(fontSize: 18, color: AppColors.orange),
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  "your_friend_have_to_buy_pro".tr(),
                  textAlign: TextAlign.center,
                  style:
                      AppTextStyle.font13W500Normal.copyWith(fontSize: 14, color: AppColors.black),
                ),
                const SizedBox(
                  height: 32,
                ),
                WButton(
                  height: 45,
                  title: "got_it".tr(),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
