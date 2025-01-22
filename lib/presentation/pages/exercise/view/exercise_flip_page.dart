import 'package:easy_localization/easy_localization.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/presentation/pages/exercise/viewmodel/exercise_page_viewmodel.dart';
import 'package:wisdom/presentation/widgets/flip_back.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_text_style.dart';
import '../../../../config/constants/assets.dart';
import '../../../../config/constants/constants.dart';
import '../../../../core/di/app_locator.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/flip_front.dart';
import '../../../widgets/loading_widget.dart';

// ignore: must_be_immutable
class ExerciseFlipPage extends ViewModelBuilderWidget<ExercisePageViewModel> {
  ExerciseFlipPage({super.key});

  @override
  void onViewModelReady(ExercisePageViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.init();
  }

  @override
  Widget builder(BuildContext context, ExercisePageViewModel viewModel, Widget? child) {
    return WillPopScope(
      onWillPop: () => viewModel.goBack(),
      child: Scaffold(
        backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
        appBar: CustomAppBar(
          title: 'navigation_exercise'.tr(),
          onTap: () => viewModel.goBack(),
          leadingIcon: Assets.icons.arrowLeft,
        ),
        body: viewModel.isSuccess(tag: viewModel.gettingReadyTag)
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 15.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flex(direction: Axis.horizontal, children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "exercise_title2".tr(),
                            style: AppTextStyle.font17W700Normal
                                .copyWith(color: isDarkTheme ? AppColors.white : AppColors.darkGray),
                            children: [
                              // TextSpan(
                              //   text:
                              //       ("\n${"${viewModel.tryNumber} ${"inCorrect".tr().toLowerCase()} ${viewModel.tryNumber != 1 ? "tries".tr() : "try".tr()}"} ${"left".tr()}"),
                              //   style: AppTextStyle.font17W700Normal
                              //       .copyWith(color: viewModel.tryNumber < 3 ? AppColors.accentLight : Colors.green),
                              // ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ]),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      child: FlipCard(
                        controller: viewModel.flipCardController,
                        direction: FlipDirection.HORIZONTAL,
                        side: CardSide.FRONT,
                        front: FlipFrontWidget(
                          model: viewModel.englishList.first,
                          onTap: () {
                            viewModel.flipCardController.toggleCard();
                          },
                        ),
                        back: FlipBackWidget(
                          model: viewModel.englishList.first,
                          onErrorClicked: () => viewModel.onErrorClicked(),
                          onRightClicked: () => viewModel.onRightClicked(),
                        ),
                      ),
                    ),
                    Text(
                      "${viewModel.flipIndex + 1}/${viewModel.minLength}",
                      style: AppTextStyle.font17W400Normal
                          .copyWith(color: isDarkTheme ? AppColors.white : AppColors.darkGray),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : const LoadingWidget(),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 65),
          decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(25.r)),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => viewModel.goToFinish(),
              borderRadius: BorderRadius.circular(25.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                height: 40.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(Assets.icons.exercise, height: 20.h, fit: BoxFit.scaleDown),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'end_exercise'.tr(),
                        style: AppTextStyle.font15W500Normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  ExercisePageViewModel viewModelBuilder(BuildContext context) {
    return ExercisePageViewModel(context: context, localViewModel: locator.get(), wordEntityRepository: locator.get());
  }
}
