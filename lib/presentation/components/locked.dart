import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/presentation/pages/setting/viewmodel/setting_page_viewmodel.dart';

class Locked extends ViewModelWidget<SettingPageViewModel> {
  const Locked({super.key});

  @override
  Widget build(BuildContext context, SettingPageViewModel viewModel) {
    return Positioned(
      bottom: 0,
      top: 0,
      right: 0,
      left: 0,
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        margin: EdgeInsets.only(top: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          color: (isDarkTheme ? AppColors.darkDivider : AppColors.borderWhite).withOpacity(0.8),
        ),
        child: TextButton.icon(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r))),
          ),
          icon: Icon(
            Icons.lock_outline_rounded,
            color: isDarkTheme ? AppColors.white : AppColors.blue,
          ),
          onPressed: () {
            viewModel.goToByPro();
          },
          label: Text(
            "subscribe_plan".tr(),
            style: AppTextStyle.font15W500Normal.copyWith(
              color: isDarkTheme ? AppColors.white : AppColors.blue,
            ),
          ),
        ),
      ),
    );
  }
}

//
