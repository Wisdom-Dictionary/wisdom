import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/domain/entities/def_enum.dart';
import 'package:wisdom/data/model/roadmap/level_word_model.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/level_words_page_viewmodel.dart';
import 'package:wisdom/presentation/routes/routes.dart';
import 'package:wisdom/presentation/widgets/custom_app_bar.dart';
import 'package:wisdom/presentation/widgets/loading_widget.dart';

class LevelWordsPage extends ViewModelBuilderWidget<LevelWordsPageViewModel> {
  LevelWordsPage({super.key});

  @override
  void onViewModelReady(LevelWordsPageViewModel viewModel) {
    viewModel.getLevelWords();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, LevelWordsPageViewModel viewModel, Widget? child) {
    return WillPopScope(
        onWillPop: () => viewModel.goMain(),
        child: Scaffold(
          backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
          drawerEnableOpenDragGesture: false,
          appBar: CustomAppBar(
              title: "1-20", onTap: () => viewModel.goMain(), leadingIcon: Assets.icons.arrowLeft),
          body: !viewModel.isSuccess(tag: viewModel.getLevelWordsTag)
              ? ShimmerLevelWords()
              : viewModel.isError(tag: viewModel.getLevelWordsTag)
                  ? Center(
                      child: SingleChildScrollView(
                          child: Text(
                              viewModel.getVMError(tag: viewModel.getLevelWordsTag)!.toString())),
                    )
                  : Stack(
                      children: [
                        exercisesList(viewModel),
                        Positioned(
                            left: 21,
                            right: 21,
                            bottom: 70,
                            child: SafeArea(
                              bottom: true,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: WButton(
                                      margin: EdgeInsets.only(top: 40.h, bottom: 12.h),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 18),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(Assets.icons.medalStar),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'exercises'.tr(),
                                                style: AppTextStyle.font15W500Normal
                                                    .copyWith(color: AppColors.white, fontSize: 14),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        viewModel.levelTestRepository
                                            .setExerciseType(TestExerciseType.levelExercise);
                                        Navigator.pushNamed(context, Routes.wordExercisesPage);
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: WButton(
                                      margin: EdgeInsets.only(top: 40.h, bottom: 12.h),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 18),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(Assets.icons.battle),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: Text(
                                                "${'battle'.tr()} / ${'friend'.tr()}",
                                                style: AppTextStyle.font15W500Normal
                                                    .copyWith(color: AppColors.white, fontSize: 14),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
        ));
  }

  Scrollbar exercisesList(LevelWordsPageViewModel viewModel) {
    return Scrollbar(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 18, bottom: 100, left: 18, right: 18),
        itemCount: viewModel.roadmapRepository.levelWordsList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                viewModel.searchByWord(viewModel.roadmapRepository.levelWordsList[index]);
              },
              child: itemExercise(index, viewModel.roadmapRepository.levelWordsList[index]));
        },
      ),
    );
  }

  Container itemExercise(int index, LevelWordModel item) {
    final isLearnt = item.isLearnt ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 15.5, horizontal: 18),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: AppColors.bgLightBlue.withValues(alpha: 0.1)),
      child: Row(
        children: [
          Text(index < 99 ? "${index + 1}  " : "${index + 1}",
              style: AppTextStyle.font15W500Normal
                  .copyWith(color: isLearnt ? AppColors.green : AppColors.blue, fontSize: 14)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                item.word!,
                style: AppTextStyle.font15W500Normal
                    .copyWith(color: isLearnt ? AppColors.green : AppColors.blue, fontSize: 14),
              ),
            ),
          ),
          if (isLearnt) SvgPicture.asset(Assets.icons.doubleCheck),
        ],
      ),
    );
  }

  @override
  LevelWordsPageViewModel viewModelBuilder(BuildContext context) {
    return LevelWordsPageViewModel(
        context: context,
        preferenceHelper: locator.get(),
        levelTestRepository: locator.get(),
        roadmapRepository: locator.get(),
        localViewModel: locator.get(),
        searchRepository: locator.get(),
        homeRepository: locator.get());
  }
}

class ShimmerLevelWords extends StatelessWidget {
  const ShimmerLevelWords({super.key});

  Container itemExercise(int index, LevelWordModel item) {
    final isLearnt = item.isLearnt ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 15.5, horizontal: 18),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: AppColors.bgLightBlue.withValues(alpha: 0.1)),
      child: Row(
        children: [
          Text(index < 99 ? "${index + 1}  " : "${index + 1}",
              style: AppTextStyle.font15W500Normal
                  .copyWith(color: isLearnt ? AppColors.green : AppColors.blue, fontSize: 14)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                item.word!,
                style: AppTextStyle.font15W500Normal
                    .copyWith(color: isLearnt ? AppColors.green : AppColors.blue, fontSize: 14),
              ),
            ),
          ),
          if (isLearnt) SvgPicture.asset(Assets.icons.doubleCheck),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade600,
      highlightColor: Colors.grey.shade400,
      enabled: true,
      period: const Duration(seconds: 2),
      child: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.only(left: 18, right: 18, top: 16, bottom: 170),
            itemCount: 8,
            itemBuilder: (context, index) => itemExercise(index, LevelWordModel.defaultValues()),
          ),
          Positioned(
              left: 21,
              right: 21,
              bottom: 92,
              child: Row(
                children: [
                  Expanded(
                    child: WButton(
                      margin: EdgeInsets.only(top: 40.h, bottom: 12.h),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: WButton(
                      margin: EdgeInsets.only(top: 40.h, bottom: 12.h),
                      onTap: () {},
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
