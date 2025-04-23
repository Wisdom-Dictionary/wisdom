import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/data/model/roadmap/test_answer_model.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/word_exercises_viewmodel.dart';
import 'package:wisdom/presentation/routes/routes.dart';
import 'package:wisdom/presentation/widgets/custom_app_bar.dart';

class WordExercisesCheckPage extends ViewModelBuilderWidget<WordExercisesViewModel> {
  WordExercisesCheckPage({super.key});
  @override
  void onViewModelReady(WordExercisesViewModel viewModel) {
    super.onViewModelReady(viewModel);
  }

  String formatText(String text, int chunkSize) {
    final pattern = RegExp('.{1,$chunkSize}');
    return pattern.allMatches(text).map((e) => e.group(0)).join('\n');
  }

  @override
  Widget builder(BuildContext context, WordExercisesViewModel viewModel, Widget? child) {
    return WillPopScope(
        onWillPop: () => viewModel.goBackFromExercisesResultPage(),
        child: Scaffold(
          backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
          drawerEnableOpenDragGesture: false,
          appBar: CustomAppBar(
            isSearch: false,
            title: "exercise_result".tr(),
            onTap: () => viewModel.goBackFromExercisesResultPage(),
            leadingIcon: Assets.icons.arrowLeft,
          ),
          body: ListView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 18),
            children: [
              statusIndicatorBar(viewModel.levelTestRepository.resultModel!.pass ?? false),
              const SizedBox(
                height: 8,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: AppDecoration.resultDecor,
                child: Column(
                  children: [
                    statusResultBar(viewModel.levelTestRepository.resultModel!.correctAnswers ?? 0,
                        viewModel.levelTestRepository.resultModel!.totalQuestions ?? 0,
                        spendTime: viewModel.levelTestRepository.resultModel!.timeTaken,
                        testDuration: viewModel.levelTestRepository.resultModel!.testDuration),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: isDarkTheme ? AppColors.darkBackground : AppColors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "right_answers".tr(),
                            style: AppTextStyle.font15W600Normal
                                .copyWith(fontSize: 14, color: AppColors.charcoal),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          QuestionsResultList(
                            items: viewModel.levelTestRepository.resultModel!.answers,
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.wordExercisesResultPage);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            "view_correct_answers".tr(),
                            style: AppTextStyle.font15W600Normal.copyWith(
                                color: AppColors.blue,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.blue),
                          ),
                        )),
                    WButton(
                      title: viewModel.hasUserLives ? "retry".tr() : "main_page".tr(),
                      onTap: () {
                        if (viewModel.hasUserLives) {
                          viewModel.retryWordQuestions();
                        } else {
                          viewModel.goBackFromExercisesResultPage();
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  String formatMilliseconds(int milliseconds) {
    int totalSeconds = (milliseconds / 1000).floor();
    int minutes = (totalSeconds / 60).floor();
    int seconds = totalSeconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }

  Widget statusResultBar(
    int correctAnswers,
    int totalQuestions, {
    int? spendTime = 0,
    int? testDuration = 0,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircularPercentIndicator(
          startAngle: 90,
          radius: 28.0,
          lineWidth: 5.0,
          animation: true,
          backgroundColor: AppColors.vibrantBlue.withValues(alpha: 0.15),
          percent: correctAnswers / totalQuestions,
          center: Text(
            "$correctAnswers/$totalQuestions",
            style: AppTextStyle.font15W600Normal.copyWith(fontSize: 10, color: AppColors.blue),
          ),
          progressColor: AppColors.blue,
          circularStrokeCap: CircularStrokeCap.round,
          footer: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: SizedBox(
              width: 70,
              child: Text(
                "right_answers".tr(),
                textAlign: TextAlign.center,
                style: AppTextStyle.font13W500Normal.copyWith(fontSize: 10, color: AppColors.blue),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        if (spendTime != null)
          CircularPercentIndicator(
            startAngle: 90,
            radius: 28.0,
            lineWidth: 5.0,
            animation: true,
            backgroundColor: AppColors.vibrantBlue.withValues(alpha: 0.15),
            percent:
                testDuration == null || testDuration < spendTime ? 0 : spendTime / testDuration,
            center: Text(
              formatMilliseconds(spendTime),
              style: AppTextStyle.font15W600Normal.copyWith(fontSize: 10, color: AppColors.blue),
            ),
            progressColor: AppColors.blue,
            circularStrokeCap: CircularStrokeCap.round,
            footer: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: SizedBox(
                width: 70,
                child: Text(
                  "time_taken".tr(),
                  textAlign: TextAlign.center,
                  style:
                      AppTextStyle.font13W500Normal.copyWith(fontSize: 10, color: AppColors.blue),
                ),
              ),
            ),
          ),
        // if (spendTime != null)
        //   CircularPercentIndicator(
        //     startAngle: 90,
        //     radius: 28.0,
        //     lineWidth: 5.0,
        //     animation: true,
        //     backgroundColor: AppColors.vibrantBlue.withValues(alpha: 0.15),
        //     percent:
        //         testDuration == null || testDuration < spendTime ? 0 : spendTime / testDuration,
        //     center: Text(
        //       "$spendTime",
        //       style: AppTextStyle.font15W600Normal.copyWith(fontSize: 10, color: AppColors.blue),
        //     ),
        //     progressColor: AppColors.blue,
        //     circularStrokeCap: CircularStrokeCap.round,
        //     footer: Padding(
        //       padding: const EdgeInsets.only(top: 4),
        //       child: SizedBox(
        //         width: 70,
        //         child: Text(
        //           "time_taken".tr(),
        //           style:
        //               AppTextStyle.font13W500Normal.copyWith(fontSize: 10, color: AppColors.blue),
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  SizedBox statusIndicatorBar(bool pass) {
    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              flex: 2,
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: pass
                      ? AppDecoration.resultDecor
                      : AppDecoration.resultDecor
                          .copyWith(color: AppColors.pink.withValues(alpha: 0.1)),
                  child: SvgPicture.asset(
                    pass ? Assets.icons.flag : Assets.icons.failureIcon,
                    height: 56,
                    width: 56,
                  ))),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: pass
                    ? AppDecoration.resultDecor
                    : AppDecoration.resultDecor
                        .copyWith(color: AppColors.pink.withValues(alpha: 0.1)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: pass
                      ? Text(
                          "success".tr(),
                          style: AppTextStyle.font17W700Normal
                              .copyWith(fontSize: 18, color: AppColors.blue),
                        )
                      : Text(
                          "dont_give_up".tr(),
                          style: AppTextStyle.font17W700Normal
                              .copyWith(fontSize: 18, color: AppColors.red),
                        ),
                ),
              ))
        ],
      ),
    );
  }

  @override
  WordExercisesViewModel viewModelBuilder(BuildContext context) {
    return WordExercisesViewModel(
      context: context,
    );
  }
}

class QuestionsResultList extends StatefulWidget {
  const QuestionsResultList({super.key, required this.items});
  final List<TestAnswerModel> items;
  @override
  State<QuestionsResultList> createState() => _QuestionsResultListState();
}

class _QuestionsResultListState extends State<QuestionsResultList> {
  final ScrollController _scrollController = ScrollController();
  bool _showGradientTop = false, _showGradientBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateGradientVisibility();
    });
  }

  void _scrollListener() {
    _updateGradientVisibility();
  }

  void _updateGradientVisibility() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    bool shouldShowBottom = currentScroll < maxScroll;
    if (shouldShowBottom != _showGradientBottom) {
      setState(() {
        _showGradientBottom = shouldShowBottom;
        _showGradientTop = !shouldShowBottom;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(maxHeight: 385),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 1,
                color: AppColors.vibrantBlue.withValues(alpha: 0.15),
              )),
          child: Stack(
            children: [
              ListView.separated(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: widget.items.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: AppColors.vibrantBlue.withValues(alpha: 0.15),
                ),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${index + 1}",
                          style: AppTextStyle.font15W600Normal
                              .copyWith(fontSize: 14, color: AppColors.blue)),
                      SvgPicture.asset(widget.items[index].isCorrect
                          ? Assets.icons.doubleCheck
                          : Assets.icons.incorrectAnswer)
                    ],
                  ),
                ),
              ),
              if (_showGradientTop)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    ignoring: true, // ListView bilan ishlashga halaqit bermaydi
                    child: Container(
                      height: 86,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (_showGradientBottom)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    ignoring: true, // ListView bilan ishlashga halaqit bermaydi
                    child: Container(
                      height: 86,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.0),
                            Colors.white.withOpacity(0.8),
                            Colors.white,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
