import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/presentation/components/w_button.dart';

class OutOfLivesWithTimerDialog extends StatelessWidget {
  const OutOfLivesWithTimerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(18.0)),
        child: ListView(
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 24),
          shrinkWrap: true,
          children: [
            Text(
              "you_did_not_start_the_battle".tr(),
              textAlign: TextAlign.center,
              style: AppTextStyle.font17W600Normal.copyWith(fontSize: 18, color: AppColors.orange),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Text(
                    "we_could_not_find_you_an_opponent".tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyle.font13W500Normal
                        .copyWith(color: AppColors.black, fontSize: 14),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text.rich(
                    textAlign: TextAlign.center,
                    style: AppTextStyle.font13W500Normal.copyWith(color: AppColors.gray),
                    TextSpan(
                      children: [
                        TextSpan(text: "lives_timer_leading_text".tr()),
                        TextSpan(
                          text: '10:59',
                          style: AppTextStyle.font13W500Normal.copyWith(color: AppColors.blue),
                        ),
                        TextSpan(text: 'lives_timer_trailing_text'.tr()),
                      ],
                    ),
                  )
                ],
              ),
            ),
            WButton(
              title: "got_it".tr(),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
