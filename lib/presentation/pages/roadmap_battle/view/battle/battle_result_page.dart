import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/data/model/battle/battle_result_model.dart';
import 'package:wisdom/presentation/components/shimmer.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/out_of_lives_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/searching_opponent_page.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/want_to_rematch_battle_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/battle_result_viewmodel.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/life_countdown_provider.dart';
import 'package:wisdom/presentation/routes/routes.dart';
import 'package:wisdom/presentation/widgets/custom_app_bar.dart';

class BattleResultPage extends ViewModelBuilderWidget<BattleResultViewmodel> {
  BattleResultPage({super.key});

  @override
  void onViewModelReady(BattleResultViewmodel viewModel) {
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, BattleResultViewmodel viewModel, Widget? child) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
        drawerEnableOpenDragGesture: false,
        appBar: CustomAppBar(
          isSearch: false,
          title: "exercise_result".tr(),
          onTap: () => viewModel.goBack(),
          leadingIcon: Assets.icons.arrowLeft,
        ),
        body: ListView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 18),
          children: [
            if (!viewModel.hasOpponentData)
              ShimmerWidget(child: statusIndicatorBar(true, 2))
            else
              statusIndicatorBar(viewModel.currentUserWon, viewModel.currentUserGainedStars ?? 0),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: AppDecoration.resultDecor,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UserDetailsWithName(
                        rank: viewModel.currentUser!.rank,
                        isPremium: viewModel.currentUser!.isPremium,
                        name: "you".tr(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
                        child: Text(
                          "${viewModel.currentUserCorrectAnswers ?? 0}:${viewModel.opponentUserCorrectAnswers ?? 0}",
                          style: AppTextStyle.font28W600Normal
                              .copyWith(color: AppColors.blue, fontSize: 24),
                        ),
                      ),
                      UserDetailsWithName(
                        rank: viewModel.opponentUser?.rank,
                        isPremium: viewModel.opponentUser?.isPremium,
                        name: viewModel.opponentUser?.name ?? "",
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "${"you".tr()}:",
                                style: AppTextStyle.font15W600Normal
                                    .copyWith(color: AppColors.black, fontSize: 10),
                              ),
                              const SizedBox(height: 8),
                              if (!viewModel.hasCurrentUserData)
                                ShimmerWidget(
                                  child: statusResultBar(
                                    0,
                                    0,
                                    spentTimeInMilliseconds: 0,
                                    givenTimeInMilliseconds: 0,
                                  ),
                                ),
                              if (viewModel.hasCurrentUserData)
                                statusResultBar(
                                  viewModel.currentUserCorrectAnswers ?? 1,
                                  viewModel.totalQuestions ?? 0,
                                  spentTimeInMilliseconds: viewModel.currentUserSpentTime,
                                  givenTimeInMilliseconds: viewModel.battleDuration,
                                ),
                            ],
                          ),
                        ),
                        divider(),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "${'opponent'.tr()}:",
                                style: AppTextStyle.font15W600Normal
                                    .copyWith(color: AppColors.black, fontSize: 10),
                              ),
                              const SizedBox(height: 8),
                              if (!viewModel.hasOpponentData)
                                ShimmerWidget(
                                  child: statusResultBar(
                                    0,
                                    0,
                                    spentTimeInMilliseconds: 0,
                                    givenTimeInMilliseconds: 0,
                                  ),
                                ),
                              if (viewModel.hasOpponentData)
                                statusResultBar(
                                  viewModel.opponentUserCorrectAnswers ?? 1,
                                  viewModel.totalQuestions ?? 0,
                                  spentTimeInMilliseconds: viewModel.opponentUserSpentTime,
                                  givenTimeInMilliseconds: viewModel.battleDuration,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: isDarkTheme ? AppColors.darkBackground : AppColors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        QuestionsResultList(
                          items: viewModel.result.result,
                          user1IsCurrentUser: viewModel.user1IsCurrentUser,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.battleExercisesResultPage);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        "view_correct_answers".tr(),
                        style: AppTextStyle.font15W600Normal.copyWith(
                          color: AppColors.blue,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.blue,
                        ),
                      ),
                    ),
                  ),
                  WButton(
                    isDisable: !viewModel.hasOpponentData,
                    isLoading: viewModel.isBusy(tag: viewModel.postRematchRequestTag),
                    title: "rematch".tr(),
                    onTap: () {
                      final hasUserLives = context.read<CountdownProvider>().hasUserLifes;
                      if (hasUserLives) {
                        viewModel.showRematchDialog();
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => OutOfLivesDialog(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget divider() {
    return const Center(
      child: SizedBox(
        height: 57,
        child: VerticalDivider(
          thickness: 1,
          color: AppColors.blue,
        ),
      ),
    );
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
    int? spentTimeInMilliseconds,
    int? givenTimeInMilliseconds,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircularPercentIndicator(
          startAngle: 90,
          radius: 28.0,
          lineWidth: 5.0,
          animation: true,
          backgroundColor: AppColors.vibrantBlue.withValues(alpha: 0.15),
          percent: totalQuestions == 0
              ? 0.0
              : double.parse((correctAnswers / totalQuestions).toStringAsFixed(2)),
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
                "words_found_correctly".tr(),
                textAlign: TextAlign.center,
                style: AppTextStyle.font13W500Normal.copyWith(fontSize: 10, color: AppColors.blue),
              ),
            ),
          ),
        ),
        if (spentTimeInMilliseconds != null && givenTimeInMilliseconds != null)
          CircularPercentIndicator(
            startAngle: 90,
            radius: 28.0,
            lineWidth: 5.0,
            animation: true,
            backgroundColor: AppColors.vibrantBlue.withValues(alpha: 0.15),
            percent: spentTimeInMilliseconds == 0 || givenTimeInMilliseconds == 0
                ? 0
                : spentTimeInMilliseconds / givenTimeInMilliseconds,
            center: Text(
              formatMilliseconds(spentTimeInMilliseconds),
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
      ],
    );
  }

  SizedBox statusIndicatorBar(bool pass, int livesStatusIndicator) {
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
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: pass
                  ? AppDecoration.resultDecor
                  : AppDecoration.resultDecor
                      .copyWith(color: AppColors.pink.withValues(alpha: 0.1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: pass
                          ? Text(
                              "you_won".tr(),
                              style: AppTextStyle.font17W700Normal
                                  .copyWith(fontSize: 18, color: AppColors.blue),
                            )
                          : Text(
                              "failure".tr(),
                              style: AppTextStyle.font17W700Normal
                                  .copyWith(fontSize: 18, color: AppColors.red),
                            )),
                  statusIndicatorLivesBar(livesStatusIndicator == 0 ? -1 : livesStatusIndicator),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget statusIndicatorLivesBar(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: index.isNegative ? AppColors.white : AppColors.blue,
      ),
      child: Row(
        children: [
          Text(
            index.isNegative ? "$index" : "+$index",
            style: AppTextStyle.font17W600Normal
                .copyWith(color: index.isNegative ? AppColors.red : AppColors.yellow, fontSize: 18),
          ),
          const SizedBox(width: 4),
          index.isNegative
              ? SvgPicture.asset(
                  Assets.icons.heart,
                  colorFilter: const ColorFilter.mode(AppColors.red, BlendMode.srcIn),
                )
              : SvgPicture.asset(
                  Assets.icons.starFull,
                  colorFilter: const ColorFilter.mode(AppColors.yellow, BlendMode.srcIn),
                ),
        ],
      ),
    );
  }

  @override
  BattleResultViewmodel viewModelBuilder(BuildContext context) {
    return BattleResultViewmodel(
      context: context,
    );
  }
}

class QuestionsResultList extends StatefulWidget {
  const QuestionsResultList({super.key, required this.items, required this.user1IsCurrentUser});
  final List<BattleExerciseResultModel> items;
  final bool user1IsCurrentUser;
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "you".tr(),
                style:
                    AppTextStyle.font15W600Normal.copyWith(fontSize: 14, color: AppColors.charcoal),
              ),
              Text(
                "opponent".tr(),
                style:
                    AppTextStyle.font15W600Normal.copyWith(fontSize: 14, color: AppColors.charcoal),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(maxHeight: 385),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 1,
              color: AppColors.vibrantBlue.withValues(alpha: 0.15),
            ),
          ),
          child: Stack(
            children: [
              ListView.separated(
                physics: const ClampingScrollPhysics(),
                controller: _scrollController,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: widget.items.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: AppColors.vibrantBlue.withValues(alpha: 0.15),
                ),
                itemBuilder: (context, index) {
                  bool? currentUserAnswer = widget.user1IsCurrentUser
                      ? widget.items[index].user1IsCorrect
                      : widget.items[index].user2IsCorrect;
                  bool? opponentAnswer = !widget.user1IsCurrentUser
                      ? widget.items[index].user1IsCorrect
                      : widget.items[index].user2IsCorrect;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        answerStatus(currentUserAnswer),
                        Text(
                          widget.items[index].word ?? "",
                          style: AppTextStyle.font15W600Normal
                              .copyWith(fontSize: 14, color: AppColors.blue),
                        ),
                        answerStatus(opponentAnswer),
                      ],
                    ),
                  );
                },
              ),
              if (_showGradientTop)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    ignoring: true,
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
                    ignoring: true,
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

  Widget answerStatus(bool? status) {
    if (status == null) {
      return ShimmerWidget(child: SvgPicture.asset(Assets.icons.doubleCheck));
    }
    if (status) {
      return SvgPicture.asset(Assets.icons.doubleCheck);
    }
    return SvgPicture.asset(Assets.icons.incorrectAnswer);
  }
}
