import 'package:easy_localization/easy_localization.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/presentation/components/custom_oval_button.dart';
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
class ExerciseCrossWordPage extends ViewModelBuilderWidget<ExercisePageViewModel> {
  ExerciseCrossWordPage({super.key});

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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Flex(direction: Axis.horizontal, children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "exercise_title3".tr(),
                            style: AppTextStyle.font17W700Normal
                                .copyWith(color: isDarkTheme ? AppColors.white : AppColors.darkGray),
                            children: [
                              TextSpan(
                                text:
                                    ("\n${"${viewModel.tryNumber} ${"inCorrect".tr().toLowerCase()} ${viewModel.tryNumber != 1 ? "tries".tr() : "try".tr()}"} ${"left".tr()}"),
                                style: AppTextStyle.font17W700Normal
                                    .copyWith(color: viewModel.tryNumber < 3 ? AppColors.accentLight : Colors.green),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ]),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15.h),
                        child: Text(
                          viewModel.englishList.first.translation,
                          style: AppTextStyle.font17W700Normal.copyWith(color: AppColors.blue),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      direction: Axis.horizontal,
                      children: [
                        for (int i = 0; i < viewModel.englishList.first.word.length; i++)
                          AbsorbPointer(
                            absorbing: viewModel.isCorrect.contains('t'),
                            child: InkWell(
                              onTap: () {
                                viewModel.removeShuffle(i);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 5, top: 5),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  border: Border.fromBorderSide(
                                    BorderSide(
                                      width: 2,
                                      color: viewModel.isCorrect.contains('t')
                                          ? AppColors.success
                                          : viewModel.isCorrect.contains('f')
                                              ? AppColors.accentLight
                                              : AppColors.blue,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    viewModel.emptyList.length > i ? viewModel.emptyList[i] : '',
                                    style: AppTextStyle.font17W700Normal
                                        .copyWith(color: isDarkTheme ? AppColors.white : AppColors.darkGray),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Wrap(
                      alignment: WrapAlignment.center,
                      direction: Axis.horizontal,
                      children: [
                        for (int i = 0; i < viewModel.englishList.first.word.length; i++)
                          InkWell(
                            onTap: () {
                              viewModel.fillCross(i);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 5, top: 5),
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                border: Border.fromBorderSide(
                                  BorderSide(
                                    width: 2,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  viewModel.shuffledList.length > i ? viewModel.shuffledList[i] : '',
                                  style: AppTextStyle.font17W700Normal
                                      .copyWith(color: isDarkTheme ? AppColors.white : AppColors.darkGray),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    CustomOvalButton(
                      label: 'exercise_check'.tr(),
                      onTap: () {
                        viewModel.checkCross();
                      },
                      textStyle: AppTextStyle.font15W400Normal,
                    )
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

extension Shuffle on String {
  String get shuffled => (characters.toList()..shuffle()).join();
}
