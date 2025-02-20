import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';

import '../../core/di/app_locator.dart';
import 'package:wisdom/config/constants/constants.dart';

class AbbreviationWordItem extends StatelessWidget {
  const AbbreviationWordItem({super.key, required this.firstText, required this.secondText});

  final String firstText;
  final String secondText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52.h,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                style: AppTextStyle.font15W500Normal.copyWith(
                    color: isDarkTheme ? AppColors.white : AppColors.darkGray,
                    fontSize: locator<LocalViewModel>().fontSize - 2),
                text: firstText,
                children: [
                  TextSpan(
                    text: ' - $secondText',
                    style: AppTextStyle.font15W400Normal.copyWith(
                        color: AppColors.paleGray,
                        fontSize: locator<LocalViewModel>().fontSize - 2),
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Divider(
                color: isDarkTheme ? AppColors.darkDivider : AppColors.borderWhite,
                height: 1,
                thickness: 0.75,
              ),
            ),
          )
        ],
      ),
    );
  }
}
