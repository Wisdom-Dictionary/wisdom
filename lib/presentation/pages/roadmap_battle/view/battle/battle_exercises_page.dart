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
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/battle_exercises_viewmodel.dart';
import 'package:wisdom/presentation/widgets/custom_app_bar.dart';

class BattleExercisesPage extends ViewModelBuilderWidget<BattleExercisesViewModel> {
  BattleExercisesPage({super.key});
  @override
  void onViewModelReady(BattleExercisesViewModel viewModel) {
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, BattleExercisesViewModel viewModel, Widget? child) {
    return WillPopScope(
        onWillPop: () => viewModel.goBack(),
        child: Scaffold(
          backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
          drawerEnableOpenDragGesture: false,
          appBar: CustomAppBar(
            isSearch: false,
            title: "battle_exercises".tr(),
            onTap: () => viewModel.goBack(),
            leadingIcon: Assets.icons.arrowLeft,
            actions: const [
              LifeStatusBarPadding(
                child: LifeStatusBar(),
              )
            ],
          ),
          body: ValueListenableBuilder(
            valueListenable: viewModel.battleRepository.battleQuestionsList,
            builder: (context, value, child) {
              if (value.isEmpty) {
                return ShimmerExercisesPage();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    if (viewModel.hasTimer)
                      Padding(
                        padding: const EdgeInsets.only(left: 18, right: 18, bottom: 16),
                        child: CountDownTimer(
                          secondsRemaining: viewModel.givenTimeForExercise,
                          whenTimeExpires: () {
                            viewModel.postTestQuestionsResult();
                          },
                          countDownTimerStyle: AppTextStyle.font13W500Normal
                              .copyWith(color: AppColors.blue, fontSize: 12),
                        ),
                      ),
                    Expanded(
                      child: BattleExerciseContent(
                        viewModel: viewModel,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  @override
  BattleExercisesViewModel viewModelBuilder(BuildContext context) {
    return BattleExercisesViewModel(
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

class BattleExerciseContent extends StatefulWidget {
  const BattleExerciseContent({super.key, required this.viewModel});
  final BattleExercisesViewModel viewModel;
  @override
  State<BattleExerciseContent> createState() => _BattleExerciseContentState();
}

class _BattleExerciseContentState extends State<BattleExerciseContent>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
        length: widget.viewModel.battleRepository.battleQuestionsList.value.length,
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

// User tanlagan javobni topish funksiyasi
  int? getSelectedAnswerId(List<AnswerEntity> selectedAnswers, int? questionId) {
    if (questionId == null) {
      return -1;
    }
    return selectedAnswers
        .firstWhere(
          (selected) => selected.questionId == questionId,
          orElse: () => AnswerEntity(questionId: -1, answerId: -1),
        )
        .answerId;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
              controller: _tabController,
              children: mapIndexed(
                widget.viewModel.battleRepository.battleQuestionsList.value,
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
                              "${index + 1}. ${widget.viewModel.battleRepository.battleQuestionsList.value[index].body!}",
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
                            itemCount: widget.viewModel.battleRepository.battleQuestionsList
                                .value[index].answers.length,
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              bool itemSelected = false;
                              final questionItemModel = widget
                                  .viewModel.battleRepository.battleQuestionsList.value[index];

                              int? selectedAnswerId = getSelectedAnswerId(
                                  widget.viewModel.answers, questionItemModel.id);

                              if (selectedAnswerId != null) {
                                itemSelected = questionItemModel.answers[i].id == selectedAnswerId;
                              }
                              return questionItem(i, questionItemModel, itemSelected);
                            },
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
          isLoading: widget.viewModel.isBusy(tag: widget.viewModel.postExercisesCheckTag),
          onTap: () {
            int? validateAnswers = widget.viewModel.validateAnswers;
            if (validateAnswers != null) {
              _tabController.animateTo(validateAnswers);
            } else {
              widget.viewModel.postTestQuestionsResult();
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

  Widget questionItem(int index, TestQuestionModel item, bool itemSelected) => WButton(
        borderRadius: 32,
        splashColor: AppColors.bgLightBlue.withValues(alpha: 0.6),
        highlightColor: AppColors.bgLightBlue.withValues(alpha: 0.6),
        color: itemSelected ? AppColors.blue : AppColors.bgLightBlue.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          child: Row(
            children: [
              Text(
                letter(index),
                style: AppTextStyle.font15W500Normal.copyWith(
                    fontSize: 14,
                    color: itemSelected
                        ? AppColors.white
                        : AppColors.vibrantBlue.withValues(alpha: 0.4)),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(item.answers[index].body ?? "",
                  style: AppTextStyle.font15W500Normal.copyWith(
                      fontSize: 14, color: itemSelected ? AppColors.white : AppColors.blue)),
            ],
          ),
        ),
        onTap: () async {
          final String? result = widget.viewModel
              .setAnswer(AnswerEntity(answerId: item.answers[index].id!, questionId: item.id!));
          setState(() {});
          if (result != null && result == widget.viewModel.answerAddedTag) {
            int? nextQuestion = widget.viewModel.validateAnswers;
            if (nextQuestion != null) {
              await Future.delayed(Duration(milliseconds: 600));
              _tabController.animateTo(nextQuestion);
            }
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
