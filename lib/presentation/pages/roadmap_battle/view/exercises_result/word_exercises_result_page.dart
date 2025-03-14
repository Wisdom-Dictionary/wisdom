import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/data/model/roadmap/test_question_model.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/word_exercises_page.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/word_exercises_result_viewmodel.dart';
import 'package:wisdom/presentation/widgets/custom_app_bar.dart';

class WordExercisesResultPage extends ViewModelBuilderWidget<WordExercisesResultViewModel> {
  WordExercisesResultPage({super.key});
  @override
  void onViewModelReady(WordExercisesResultViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.postTestQuestionsResult();
  }

  @override
  Widget builder(BuildContext context, WordExercisesResultViewModel viewModel, Widget? child) {
    return WillPopScope(
        onWillPop: () => viewModel.goBack(),
        child: Scaffold(
          backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
          drawerEnableOpenDragGesture: false,
          appBar: CustomAppBar(
            isSearch: false,
            title: "correct_answers".tr(),
            onTap: () => viewModel.goBack(),
            leadingIcon: Assets.icons.arrowLeft,
          ),
          body: viewModel.isBusy(tag: viewModel.postWordExercisesResultTag)
              ? const ShimmerExercisesPage()
              : viewModel.isSuccess(tag: viewModel.postWordExercisesResultTag)
                  ? ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      physics: ClampingScrollPhysics(),
                      itemCount: viewModel.levelTestRepository.testQuestionsList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 18),
                                padding: const EdgeInsets.all(16),
                                decoration: isDarkTheme
                                    ? AppDecoration.bannerDarkDecor
                                    : AppDecoration.bannerDecor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                                      child: Text(
                                        "${index + 1}. ${viewModel.levelTestRepository.testQuestionsList[index].body!}",
                                        style: AppTextStyle.font15W500Normal
                                            .copyWith(fontSize: 14, color: AppColors.darkGray),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    ListView.separated(
                                      padding: EdgeInsets.zero,
                                      separatorBuilder: (context, index) => const SizedBox(
                                        height: 8,
                                      ),
                                      itemCount: viewModel.levelTestRepository
                                          .testQuestionsResultList[index].answers.length,
                                      primary: false,
                                      shrinkWrap: true,
                                      itemBuilder: (context, i) => questionItem(
                                          i,
                                          viewModel
                                              .levelTestRepository.testQuestionsResultList[index]),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(),
        ));
  }

  String letter(int index) => switch (index) {
        0 => "A",
        1 => "B",
        2 => "C",
        3 => "D",
        4 => "E",
        5 => "F",
        6 => "G",
        7 => "H",
        _ => "",
      };

  Widget questionItem(
    int index,
    TestQuestionModel item,
  ) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15.5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: item.answers![index].correct
                ? AppColors.green
                : item.answers![index].selected
                    ? AppColors.red.withValues(alpha: 0.4)
                    : AppColors.bgLightBlue.withValues(alpha: 0.1)),
        child: Row(
          children: [
            Text(
              letter(index),
              style: AppTextStyle.font15W500Normal.copyWith(
                  fontSize: 14,
                  color: item.answers![index].correct || item.answers![index].selected
                      ? AppColors.white.withValues(alpha: 0.3)
                      : AppColors.vibrantBlue.withValues(alpha: 0.4)),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(item.answers![index].body ?? "",
                style: AppTextStyle.font15W500Normal.copyWith(
                    fontSize: 14,
                    color: item.answers![index].correct || item.answers![index].selected
                        ? AppColors.white
                        : AppColors.blue)),
          ],
        ),
      );

  @override
  WordExercisesResultViewModel viewModelBuilder(BuildContext context) {
    return WordExercisesResultViewModel(
      context: context,
    );
  }
}
