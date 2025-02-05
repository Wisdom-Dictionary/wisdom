import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/widgets/custom_app_bar.dart';

class BattleResultPage extends StatelessWidget {
  BattleResultPage({super.key});

  String formatText(String text, int chunkSize) {
    final pattern = RegExp('.{1,$chunkSize}');
    return pattern.allMatches(text).map((e) => e.group(0)).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // onWillPop: () => viewModel.goBack(),
        onWillPop: null,
        child: Scaffold(
          backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
          drawerEnableOpenDragGesture: false,
          appBar: CustomAppBar(
            isSearch: false,
            title: "exercise_result".tr(),
            onTap: () {},
            // onTap: () => viewModel.goBack(),
            leadingIcon: Assets.icons.arrowLeft,
          ),
          body: ListView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 18),
            children: [
              statusIndicatorBar(true, 2),
              const SizedBox(
                height: 8,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: AppDecoration.resultDecor,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SvgPicture.asset(Assets.icons.userAvatar),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "you".tr(),
                              textAlign: TextAlign.center,
                              style: AppTextStyle.font15W700Normal
                                  .copyWith(fontSize: 14, color: AppColors.black),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
                          child: Text(
                            "5:5",
                            style: AppTextStyle.font28W600Normal
                                .copyWith(color: AppColors.blue, fontSize: 24),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Column(
                            children: [
                              SvgPicture.asset(Assets.icons.userAvatar),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Sevara Fozilova",
                                textAlign: TextAlign.center,
                                style: AppTextStyle.font15W700Normal
                                    .copyWith(fontSize: 14, color: AppColors.black),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'You:',
                              style: AppTextStyle.font15W600Normal
                                  .copyWith(color: AppColors.black, fontSize: 10),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            statusResultBar(5, 8, spendTime: 286, givenTime: 420),
                          ],
                        )),
                        divider(),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Opponent:',
                              style: AppTextStyle.font15W600Normal
                                  .copyWith(color: AppColors.black, fontSize: 10),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            statusResultBar(1, 20, spendTime: 254, givenTime: 420),
                          ],
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: isDarkTheme ? AppColors.darkBackground : AppColors.white),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          QuestionsResultList(items: [
                            "enough",
                            "very",
                            "many",
                            "too",
                            "enough",
                            "many",
                            "too",
                            "enough",
                            "many",
                            "too",
                            "enough",
                            "many",
                            "too",
                            "very",
                            "many",
                            "too",
                            "enough",
                          ]),
                        ],
                      ),
                    ),
                    GestureDetector(
                        onTap: () {},
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
                      title: "retry".tr(),
                      onTap: () {},
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  SizedBox divider() {
    return const SizedBox(
        height: 57,
        child: VerticalDivider(
          thickness: 1,
          width: 26,
          color: AppColors.blue,
        ));
  }

  Widget statusResultBar(int correctAnswers, int totalQuestions, {int? spendTime, int? givenTime}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                "words_found_correctly".tr(),
                textAlign: TextAlign.center,
                style: AppTextStyle.font13W500Normal.copyWith(fontSize: 10, color: AppColors.blue),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        if (spendTime != null && givenTime != null)
          CircularPercentIndicator(
            startAngle: 90,
            radius: 28.0,
            lineWidth: 5.0,
            animation: true,
            backgroundColor: AppColors.vibrantBlue.withValues(alpha: 0.15),
            percent: spendTime / givenTime,
            center: Text(
              "$spendTime",
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    pass
                        ? Text(
                            "You Won",
                            style: AppTextStyle.font17W700Normal
                                .copyWith(fontSize: 18, color: AppColors.blue),
                          )
                        : Text(
                            "Failure",
                            style: AppTextStyle.font17W700Normal
                                .copyWith(fontSize: 18, color: AppColors.red),
                          ),
                    statusIndicatorLivesBar(livesStatusIndicator),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget statusIndicatorLivesBar(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          color: index.isNegative ? AppColors.white : AppColors.blue),
      child: Row(
        children: [
          Text(
            index.isNegative ? "$index" : "+$index",
            style: AppTextStyle.font17W600Normal
                .copyWith(color: index.isNegative ? AppColors.red : AppColors.yellow, fontSize: 18),
          ),
          const SizedBox(
            width: 4,
          ),
          index.isNegative
              ? SvgPicture.asset(
                  Assets.icons.heart,
                  colorFilter: const ColorFilter.mode(AppColors.red, BlendMode.srcIn),
                )
              : SvgPicture.asset(
                  Assets.icons.starFull,
                  colorFilter: const ColorFilter.mode(AppColors.yellow, BlendMode.srcIn),
                )
        ],
      ),
    );
  }
}

class QuestionsResultList extends StatefulWidget {
  const QuestionsResultList({super.key, required this.items});
  final List<String> items;
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
        const SizedBox(
          height: 8,
        ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(Assets.icons.doubleCheck),
                      Text(widget.items[index],
                          style: AppTextStyle.font15W600Normal
                              .copyWith(fontSize: 14, color: AppColors.blue)),
                      SvgPicture.asset(Assets.icons.incorrectAnswer)
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
