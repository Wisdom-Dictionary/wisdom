import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/presentation/components/w_button.dart';

class OpponentWasFoundDialog extends StatelessWidget {
  const OpponentWasFoundDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ClampingScrollPhysics(),
      padding: const EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 24),
      shrinkWrap: true,
      children: [
        Text(
          "opponent_has_found".tr(),
          textAlign: TextAlign.center,
          style: AppTextStyle.font17W600Normal.copyWith(fontSize: 18, color: AppColors.blue),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SvgPicture.asset(Assets.icons.userAvatar),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "you".tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyle.font15W600Normal
                        .copyWith(fontSize: 14, color: AppColors.black),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
                child: Text(
                  "vs".tr(),
                  style:
                      AppTextStyle.font28W600Normal.copyWith(color: AppColors.blue, fontSize: 24),
                ),
              ),
              SizedBox(
                width: 80,
                child: Column(
                  children: [
                    SvgPicture.asset(Assets.icons.userAvatar),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Sevara Fozilova",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.font15W600Normal
                          .copyWith(fontSize: 14, color: AppColors.black),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Center(
          child: DottedBorder(
            borderType: BorderType.RRect,
            dashPattern: [
              8,
              8,
            ],
            radius: Radius.circular(1000),
            color: AppColors.blue.withValues(alpha: 0.15),
            strokeWidth: 2,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: Text(
              "3",
              style: AppTextStyle.font28W600Normal.copyWith(fontSize: 42, color: AppColors.blue),
            ),
          ),
        ),
        SizedBox(
          height: 32,
        ),
        WButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.icons.battle),
              SizedBox(
                width: 10,
              ),
              Text(
                "start".tr(),
                style: AppTextStyle.font13W500Normal.copyWith(color: AppColors.white, fontSize: 14),
              )
            ],
          ),
          onTap: () {},
        )
      ],
    );
  }
}
