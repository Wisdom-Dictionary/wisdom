import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/presentation/widgets/custom_app_bar.dart';

import '../../../../config/constants/constants.dart';
import '../viewmodel/input_number_page_viewmodel.dart';

class InputNumberPage extends ViewModelBuilderWidget<InputNumberPageViewModel> {
  InputNumberPage({super.key});

  var maskFormatter = MaskTextInputFormatter(
    mask: '(##) ### ## ##',
    // filter: {"#": RegExp(r'[0-9]')},
    // type: MaskAutoCompletionType.lazy,
  );

  TextEditingController editingController = TextEditingController();

  final inputKey = GlobalKey();

  @override
  void onDestroy(InputNumberPageViewModel model) {
    editingController.dispose();
    super.onDestroy(model);
  }

  @override
  // TODO: implement reactive
  bool get reactive => false;

  @override
  Widget builder(
    BuildContext context,
    InputNumberPageViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor:
          isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CustomAppBar(
        title: 'getAccount'.tr(),
        onTap: () => viewModel.pop(),
        leadingIcon: Assets.icons.arrowLeft,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 57.h, left: 18.w, right: 18.w),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  isDarkTheme
                      ? Assets.icons.logoWhiteText
                      : Assets.icons.logoBlueText,
                  height: 52.h,
                  fit: BoxFit.scaleDown,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.h, bottom: 36.h),
                  child: Text(
                    'enter_phone'.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyle.font13W400Normal.copyWith(
                        color: isDarkTheme
                            ? AppColors.lightGray
                            : AppColors.darkGray),
                  ),
                ),
                Container(
                  decoration: isDarkTheme
                      ? AppDecoration.bannerDarkDecor
                      : AppDecoration.bannerDecor,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.r),
                            color: isDarkTheme
                                ? AppColors.darkBackground
                                : AppColors.lightBackground),
                        height: 45.h,
                        margin: EdgeInsets.only(top: 24.h, bottom: 12.h),
                        padding: EdgeInsets.only(left: 22.w),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            // key: inputKey,
                            autofocus: true,
                            showCursor: true,
                            controller: editingController,
                            keyboardType: TextInputType.number,
                            style: AppTextStyle.font17W400Normal
                                .copyWith(color: AppColors.blue),
                            inputFormatters: [maskFormatter],
                            decoration: InputDecoration(
                              hintText: '(--) --- -- --',
                              hintStyle: AppTextStyle.font17W400Normal
                                  .copyWith(color: AppColors.blue),
                              border: InputBorder.none,
                              prefixText: "+998",
                            ),
                            onSubmitted: (value) {
                              if (editingController.text.length == 14) {
                                viewModel.onNextPressed(
                                    "+998${editingController.text}");
                              } else {
                                viewModel
                                    .callBackError('invalid_phone_nuber'.tr());
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.r),
                            color: AppColors.blue),
                        height: 45.h,
                        margin: EdgeInsets.only(top: 20.h, bottom: 12.h),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: (() {
                              if (editingController.text.length == 14) {
                                viewModel.onNextPressed(
                                    "+998${editingController.text}");
                              } else {
                                viewModel
                                    .callBackError('invalid_phone_nuber'.tr());
                              }
                            }),
                            borderRadius: BorderRadius.circular(40.r),
                            child: Center(
                              child: Text(
                                'next'.tr(),
                                style: AppTextStyle.font15W500Normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  InputNumberPageViewModel viewModelBuilder(BuildContext context) {
    log('InputNumberPageViewModel viewModelBuilder');
    return InputNumberPageViewModel(
        context: context,
        profileRepository: locator.get(),
        localViewModel: locator.get(),
        sharedPreferenceHelper: locator.get());
  }
}
