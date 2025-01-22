import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';

import '../../../config/constants/app_decoration.dart';
import '../../../config/constants/assets.dart';
import '../../../config/constants/constants.dart';
import '../../widgets/custom_app_bar.dart';

class GivingAdPage extends StatelessWidget {
  const GivingAdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CustomAppBar(
        title: 'place_ad'.tr(),
        onTap: () => Navigator.of(context).pop(),
        leadingIcon: Assets.icons.arrowLeft,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 30.h, left: 18.w, right: 18.w),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                isDarkTheme ? Assets.icons.logoWhiteText : Assets.icons.logoBlueText,
                height: 52.h,
                fit: BoxFit.scaleDown,
              ),
              Container(
                margin: EdgeInsets.only(top: 30.h),
                padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 20.w),
                decoration: isDarkTheme ? AppDecoration.bannerDarkDecor : AppDecoration.bannerDecor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'disc_local_ad'.tr(),
                      style:
                          AppTextStyle.font17W500Normal.copyWith(color: isDarkTheme ? AppColors.white : AppColors.blue),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      child: TextButton.icon(
                        icon: Icon(
                          Icons.call_rounded,
                          color: isDarkTheme ? AppColors.white : AppColors.blue,
                        ),
                        onPressed: () {
                          launchUrl(Uri.parse('tel://+998 91 160 55 56'));
                        },
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'telefon'.tr(),
                              style: AppTextStyle.font15W500Normal.copyWith(
                                color: isDarkTheme ? AppColors.white : AppColors.blue,
                              ),
                            ),
                            Text(
                              ' +998 91 160 55 56',
                              style: AppTextStyle.font15W500Normal.copyWith(
                                  color: isDarkTheme ? AppColors.white : AppColors.blue,
                                  decoration: TextDecoration.underline),
                            )
                          ],
                        ),
                      ),
                    ),
                    TextButton.icon(
                      icon: Icon(
                        Icons.telegram,
                        color: isDarkTheme ? AppColors.white : AppColors.blue,
                      ),
                      onPressed: () {
                        launchUrl(Uri.parse('https://t.me/wisdom_reklama'));
                      },
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Telegram: ',
                            style: AppTextStyle.font15W500Normal.copyWith(
                              color: isDarkTheme ? AppColors.white : AppColors.blue,
                            ),
                          ),
                          Text(
                            '@Wisdom_reklama',
                            style: AppTextStyle.font15W500Normal.copyWith(
                                color: isDarkTheme ? AppColors.white : AppColors.blue,
                                decoration: TextDecoration.underline),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
