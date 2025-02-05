import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/presentation/components/w_button.dart';

class OutOfLivesDialog extends StatelessWidget {
  const OutOfLivesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ClampingScrollPhysics(),
      padding: const EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 24),
      shrinkWrap: true,
      children: [
        Text(
          "you_are_out_of_lives".tr(),
          textAlign: TextAlign.center,
          style: AppTextStyle.font17W600Normal.copyWith(fontSize: 18, color: AppColors.orange),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: SvgPicture.asset(Assets.icons.outOfLives),
        ),
        Text(
          "you_do_not_have_enough_lives".tr(),
          textAlign: TextAlign.center,
          style: AppTextStyle.font13W500Normal.copyWith(fontSize: 14, color: AppColors.black),
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
        ),
        SizedBox(
          height: 32,
        ),
        WButton(
          title: "got_it".tr(),
          onTap: () {},
        )
      ],
    );
  }
}
