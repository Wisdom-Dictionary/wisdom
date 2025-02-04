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
          "You are out of lives!",
          textAlign: TextAlign.center,
          style: AppTextStyle.font17W600Normal.copyWith(fontSize: 18, color: AppColors.orange),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: SvgPicture.asset(Assets.icons.outOfLives),
        ),
        Text(
          "You use all your lives, you don't have enough lives to complete the exercises",
          textAlign: TextAlign.center,
          style: AppTextStyle.font13W500Normal.copyWith(fontSize: 14, color: AppColors.black),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          "Please wait a bit and don't forget to collect your lives when the time is right! You will get your next lives after 10:59 minutes",
          textAlign: TextAlign.center,
          style: AppTextStyle.font13W500Normal.copyWith(fontSize: 12, color: AppColors.gray),
        ),
        SizedBox(
          height: 32,
        ),
        WButton(
          title: "Got it",
          onTap: () {},
        )
      ],
    );
  }
}
