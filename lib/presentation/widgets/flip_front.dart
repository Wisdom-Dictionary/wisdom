import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/data/model/exercise_model.dart';
import 'package:wisdom/presentation/components/custom_oval_button.dart';
import 'package:wisdom/presentation/pages/exercise/viewmodel/exercise_page_viewmodel.dart';

import '../../config/constants/app_colors.dart';
import '../../config/constants/app_decoration.dart';
import '../../config/constants/app_text_style.dart';
import '../../config/constants/assets.dart';
import '../../config/constants/constants.dart';

class FlipFrontWidget extends ViewModelWidget<ExercisePageViewModel> {
  const FlipFrontWidget({
    super.key,
    required this.model,
    required this.onTap,
  });

  final ExerciseModel model;
  final Function() onTap;

  @override
  Widget build(BuildContext context, ExercisePageViewModel viewModel) {
    return Container(
      decoration: isDarkTheme ? AppDecoration.bannerDarkDecor : AppDecoration.bannerDecor,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      width: double.infinity,
      height: 350.h,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Text(
                viewModel.localViewModel.exerciseLangOption == "en"
                    ? model.word
                    : model.translation,
                style: AppTextStyle.font17W700Normal
                    .copyWith(color: isDarkTheme ? AppColors.white : AppColors.darkGray),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                model.wordClassBody != null && viewModel.localViewModel.exerciseLangOption == "en"
                    ? Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                "[${model.wordClassBody ?? ""}]",
                                style: AppTextStyle.font15W400NormalHtml
                                    .copyWith(color: AppColors.gray),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            InkWell(
                                onTap: () => viewModel.textToSpeech(model.word),
                                child: SvgPicture.asset(Assets.icons.sound, color: AppColors.blue)),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                model.wordClass != null && viewModel.localViewModel.exerciseLangOption == "en"
                    ? Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: Text(
                          model.wordClass ?? "",
                          style: AppTextStyle.font15W500Normal.copyWith(color: Colors.green),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox.shrink(),
                model.example != null && viewModel.localViewModel.exerciseLangOption == "en"
                    ? Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: Text(
                          model.example ?? "",
                          style: AppTextStyle.font15W500Normal.copyWith(color: AppColors.paleGray),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomOvalButton(
                label: "Tarjimani ko'rish uchun bosing ->",
                onTap: onTap,
                textStyle: AppTextStyle.font17W600Normal.copyWith(color: AppColors.darkGray)),
          )
        ],
      ),
    );
  }
}
