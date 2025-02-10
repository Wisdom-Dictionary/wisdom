import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jbaza/jbaza.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/data/model/roadmap/answer_entity.dart';
import 'package:wisdom/data/model/roadmap/test_question_model.dart';
import 'package:wisdom/presentation/components/count_down_timer.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/widgets/life_status_bar.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/word_exercises_viewmodel.dart';
import 'package:wisdom/presentation/widgets/custom_app_bar.dart';

class WordExercisesPage extends ViewModelBuilderWidget<WordExercisesViewModel> {
  WordExercisesPage({super.key});
  @override
  void onViewModelReady(WordExercisesViewModel viewModel) {
    viewModel.getTestQuestions();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, WordExercisesViewModel viewModel, Widget? child) {
    return WillPopScope(
        onWillPop: () => viewModel.goBack(),
        child: Scaffold(
          backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
          drawerEnableOpenDragGesture: false,
          appBar: CustomAppBar(
            isSearch: false,
            title: "word_exercises".tr(),
            onTap: () => viewModel.goBack(),
            leadingIcon: Assets.icons.arrowLeft,
            actions: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    LifeStatusBar(),
                  ],
                ),
              )
            ],
          ),
          body: viewModel.isBusy(tag: viewModel.getWordExercisesTag)
              ? const ShimmerExercisesPage()
              : viewModel.isSuccess(tag: viewModel.getWordExercisesTag)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          if (viewModel.hasTimer)
                            Padding(
                              padding: const EdgeInsets.only(left: 18, right: 18, bottom: 16),
                              child: CountDownTimer(
                                secondsRemaining: viewModel.givenTimeForExercise,
                                whenTimeExpires: () {},
                                countDownTimerStyle: AppTextStyle.font13W500Normal
                                    .copyWith(color: AppColors.blue, fontSize: 12),
                              ),
                            ),
                          Expanded(
                            child: WordExerciseContent(
                              viewModel: viewModel,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(),
        ));
  }

  @override
  WordExercisesViewModel viewModelBuilder(BuildContext context) {
    return WordExercisesViewModel(
      context: context,
    );
  }
}

class ShimmerExercisesPage extends StatelessWidget {
  const ShimmerExercisesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          padding: const EdgeInsets.all(16),
          decoration: AppDecoration.bannerDecor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade400,
                highlightColor: Colors.grey.shade200,
                enabled: true,
                period: const Duration(seconds: 2),
                child: Container(
                  width: double.infinity,
                  height: 58,
                  decoration: BoxDecoration(
                      color: AppColors.lavender, borderRadius: BorderRadius.circular(10)),
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
                itemCount: 4,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    enabled: true,
                    period: const Duration(seconds: 2),
                    child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                            color: AppColors.lavender, borderRadius: BorderRadius.circular(32)))),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class WordExerciseContent extends StatefulWidget {
  const WordExerciseContent({super.key, required this.viewModel});
  final WordExercisesViewModel viewModel;
  @override
  State<WordExerciseContent> createState() => _WordExerciseContentState();
}

class _WordExerciseContentState extends State<WordExerciseContent>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
        length: widget.viewModel.levelTestRepository.testQuestionsList.length,
        vsync: this,
        initialIndex: 0)
      ..addListener(
        () {
          setState(() {});
        },
      );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
              controller: _tabController,
              children: mapIndexed(
                widget.viewModel.levelTestRepository.testQuestionsList,
                (index, item) => Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      padding: const EdgeInsets.all(16),
                      decoration:
                          isDarkTheme ? AppDecoration.bannerDarkDecor : AppDecoration.bannerDecor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                            child: Text(
                              "${index + 1}. ${widget.viewModel.levelTestRepository.testQuestionsList[index].body!}",
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
                            itemCount: widget.viewModel.levelTestRepository.testQuestionsList[index]
                                .answers!.length,
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (context, i) => questionItem(
                                i, widget.viewModel.levelTestRepository.testQuestionsList[index]),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ).toList()),
        ),
        Text.rich(
          style: AppTextStyle.font15W500Normal
              .copyWith(color: AppColors.gray80.withValues(alpha: 0.55)),
          TextSpan(
            children: [
              TextSpan(
                text: "${_tabController.index + 1}",
                style: AppTextStyle.font15W500Normal.copyWith(color: AppColors.blue),
              ),
              TextSpan(
                text: " / ${_tabController.length}",
              ),
            ],
          ),
        ),
        WButton(
          isDisable: !widget.viewModel.submitButtonStatus(_tabController.index),
          margin: EdgeInsets.only(left: 16, right: 16, top: 24.h, bottom: 12.h),
          title: 'submit'.tr(),
          isLoading: widget.viewModel.isBusy(tag: widget.viewModel.postWordExercisesCheckTag),
          onTap: () {
            int? validateAnswers = widget.viewModel.validateAnswers;
            if (validateAnswers != null) {
              _tabController.animateTo(validateAnswers);
            } else {
              widget.viewModel.postTestQuestionsCheck();
            }
          },
        )
      ],
    );
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
      WButton(
        borderRadius: 32,
        splashColor: AppColors.bgLightBlue.withValues(alpha: 0.6),
        highlightColor: AppColors.bgLightBlue.withValues(alpha: 0.6),
        color: AppColors.bgLightBlue.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          child: Row(
            children: [
              Text(
                letter(index),
                style: AppTextStyle.font15W500Normal
                    .copyWith(fontSize: 14, color: AppColors.vibrantBlue.withValues(alpha: 0.4)),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(item.answers![index].body ?? "",
                  style:
                      AppTextStyle.font15W500Normal.copyWith(fontSize: 14, color: AppColors.blue)),
            ],
          ),
        ),
        onTap: () {
          widget.viewModel
              .setAnswer(AnswerEntity(answerId: item.answers![index].id!, questionId: item.id!));

          int? nextQuestion = widget.viewModel.validateAnswers;
          if (nextQuestion != null) {
            _tabController.animateTo(nextQuestion);
          } else {
            setState(() {});
          }
        },
      );
}

Iterable<E> mapIndexed<E, T>(Iterable<T> items, E Function(int index, T item) f) sync* {
  var index = 0;

  for (final item in items) {
    yield f(index, item);
    index = index + 1;
  }
}
