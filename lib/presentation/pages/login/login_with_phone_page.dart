import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/presentation/pages/login/view/login_page.dart';
import 'package:wisdom/presentation/pages/login/viewmodel/login_viewmodel.dart';

import '../../../config/constants/app_colors.dart';
import '../../../config/constants/assets.dart';
import '../../../config/constants/constants.dart';
import '../../../core/extensions/app_extension.dart';
import '../../../presentation/widgets/app_button_widget.dart';
import '../../../presentation/widgets/social_button.dart';

// ignore: must_be_immutable
class LoginWithPhonePage extends ViewModelBuilderWidget<LoginViewModel> {
  LoginWithPhonePage({super.key});

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.blue,
                    size: 20,
                  ),
                ).paddingOnly(top: 50, left: 20),
              ),
              SvgPicture.asset(
                isDarkTheme ? Assets.icons.logoWhiteText : Assets.icons.logoBlueText,
                height: 52.h,
                fit: BoxFit.scaleDown,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.h, bottom: 36.h),
                child: Text(
                  LocaleKeys.enter_phone.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyle.font12W400Normal.copyWith(
                    color: isDarkTheme ? AppColors.lightGray : AppColors.darkGray,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              CardContentWidget(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  AppInputTextField(
                    onChanged: viewModel.setPhone,
                    prefix: Text(
                      "+998",
                      style: AppTextStyle.font17W400Normal.copyWith(
                        color: AppColors.blue,
                        fontSize: 17.sp,
                      ),
                    ).paddingOnly(right: 10),
                    hint: '(--) --- -- --',
                    inputFormatter: viewModel.inputFormatter,
                    borderRadius: 40,
                    autoFocus: true,
                    textInputType: TextInputType.number,
                  ).paddingOnly(top: 12),
                  AppButtonWidget(
                    onTap: () async {
                      await viewModel.login();
                    },
                    title: LocaleKeys.continue_w.tr(),
                    margin: EdgeInsets.symmetric(vertical: 10.w),
                  ),
                  // if (!Platform.isWindows)
                  //   SocialButtonWidget(
                  //     onTap: () async {
                  //       await viewModel.loginWithGoogle();
                  //     },
                  //     title: "Google",
                  //     color: AppColors.lightBackground,
                  //     textStyle: AppTextStyle.font12W600Normal.copyWith(
                  //       color: AppColors.darkForm,
                  //       fontSize: 12.sp,
                  //     ),
                  //     leftIcon: SvgPicture.asset(
                  //       Assets.icons.googleIc,
                  //       height: 32,
                  //       width: 32,
                  //       fit: BoxFit.scaleDown,
                  //     ),
                  //     margin: EdgeInsets.symmetric(vertical: 3.w),
                  //   ),
                  // if (Platform.isIOS)
                  //   SocialButtonWidget(
                  //     onTap: () async {
                  //       await viewModel.loginWithApple();
                  //     },
                  //     title: "Apple",
                  //     color: AppColors.lightBackground,
                  //     textStyle: AppTextStyle.font12W600Normal.copyWith(
                  //       color: AppColors.darkForm,
                  //       fontSize: 12.sp,
                  //     ),
                  //     leftIcon: SvgPicture.asset(
                  //       Assets.icons.appleIc,
                  //       height: 32,
                  //       width: 32,
                  //       fit: BoxFit.scaleDown,
                  //     ),
                  //     margin: EdgeInsets.symmetric(vertical: 3.w),
                  //   ),
                  // SocialButtonWidget(
                  //   onTap: () {},
                  //   title: "Facebook",
                  //   color: AppColors.lightBackground,
                  //   textStyle: AppTextStyle.font12W600Normal.copyWith(color: AppColors.darkForm),
                  //   leftIcon: SvgPicture.asset(
                  //     Assets.icons.facebookIc,
                  //     height: 32,
                  //     width: 32,
                  //     fit: BoxFit.cover,
                  //   ),
                  //   margin: EdgeInsets.symmetric(vertical: 3.w),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) {
    return LoginViewModel(
      context: context,
      authRepository: locator.get(),
      preference: locator.get(),
      profileRepository: locator.get(),
      homeRepository: locator.get(),
      wordEntityRepository: locator.get(),
    );
  }
}
