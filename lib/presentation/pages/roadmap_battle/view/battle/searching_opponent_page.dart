import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/data/model/roadmap/rank_model.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/searching_opponent_viewmodel.dart';
import 'package:wisdom/presentation/widgets/new_custom_app_bar.dart';

class SearchingOpponentPage extends ViewModelBuilderWidget<SearchingOpponentViewmodel> {
  SearchingOpponentPage({super.key});

  @override
  void onViewModelReady(SearchingOpponentViewmodel viewModel) {
    viewModel.getUser();
    viewModel.connectBattle();
    viewModel.startSearchOpponentTimer();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, SearchingOpponentViewmodel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: NewCustomAppBar(
        title: "battle".tr(),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.5, horizontal: 16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: AppDecoration.resultDecor
                    .copyWith(color: AppColors.bgLightBlue.withValues(alpha: 0.1)),
                child: Row(
                  children: [
                    UserDetails(
                      isPremium: viewModel.userDetailsModel.isPremuimStatus,
                      rank: viewModel.userDetailsModel.rank,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            viewModel.userDetailsModel.user?.name ?? "",
                            style: AppTextStyle.font17W600Normal
                                .copyWith(fontSize: 18, color: AppColors.blue),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            "you".tr(),
                            style: AppTextStyle.font13W500Normal
                                .copyWith(fontSize: 12, color: AppColors.blue),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: AppDecoration.battleComponentDecor,
                      child: Row(
                        children: [
                          Text(
                            (viewModel.userDetailsModel.userCurrentLevel ?? 0).toString(),
                            style: AppTextStyle.font13W500Normal
                                .copyWith(fontSize: 14, color: AppColors.yellow),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          SvgPicture.asset(Assets.icons.verify)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: AppDecoration.resultDecor
                    .copyWith(borderRadius: BorderRadius.circular(1000.r), color: AppColors.blue),
                margin: const EdgeInsets.symmetric(vertical: 24),
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Text(
                  "vs".tr(),
                  style:
                      AppTextStyle.font28W600Normal.copyWith(fontSize: 24, color: AppColors.white),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: AppDecoration.resultDecor.copyWith(
                    gradient: const LinearGradient(colors: [
                  Color(0xFFEB9898),
                  Color(0xFFCD0000),
                ])),
                child: Row(
                  children: [
                    SvgPicture.asset(Assets.icons.searchingOpponentAvatar),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text(
                        "searching_opponent".tr().replaceFirst(" ", "\n"),
                        style: AppTextStyle.font17W600Normal
                            .copyWith(fontSize: 18, color: AppColors.blue),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: AppDecoration.battleComponentDecor,
                      child: CounterUpTimer(
                        viewmodel: viewModel,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: Center(
                child: SvgPicture.asset(
                  Assets.icons.searchText,
                  height: 96.h,
                  width: 96.w,
                  colorFilter:
                      ColorFilter.mode(AppColors.blue.withValues(alpha: 0.15), BlendMode.srcIn),
                ),
              )),
              if (kDebugMode)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(viewModel.statusMessage),
                ),
              WButton(
                isLoading: viewModel.isBusy(tag: viewModel.stopSearchingOpponentTag),
                titleStyle:
                    AppTextStyle.font15W500Normal.copyWith(color: AppColors.blue, fontSize: 14),
                color: AppColors.blue.withValues(alpha: 0.15),
                title: "stop".tr(),
                onTap: () {
                  viewModel.stopSearchOpponent();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  SearchingOpponentViewmodel viewModelBuilder(BuildContext context) {
    return SearchingOpponentViewmodel(context: context);
  }
}

class UserDetailsWithName extends StatelessWidget {
  const UserDetailsWithName({super.key, this.rank, this.name, this.isPremium = false});

  final RankModel? rank;
  final bool? isPremium;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          UserDetails(
            isPremium: isPremium ?? false,
            rank: rank,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            name ?? "",
            textAlign: TextAlign.center,
            style: AppTextStyle.font15W600Normal.copyWith(fontSize: 14, color: AppColors.black),
          )
        ],
      ),
    );
  }
}

class UserDetails extends StatelessWidget {
  const UserDetails({super.key, this.rank, this.isPremium = false});

  final RankModel? rank;
  final bool isPremium;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            padding: const EdgeInsets.only(top: 11, left: 11, right: 11, bottom: 0),
            height: 72,
            decoration: ShapeDecoration(
                color:
                    (isPremium ? AppColors.yellow : AppColors.vibrantBlue).withValues(alpha: 0.15),
                shape: CircleBorder(
                    side: BorderSide(
                        color: isPremium ? AppColors.yellow : AppColors.lightBackground,
                        width: 2))),
            child: SvgPicture.asset(Assets.icons.profileAvatar)),
        if (rank != null)
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Transform.translate(
                offset: const Offset(0, 12),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: ShapeDecoration(
                        color: AppColors.blue,
                        shape: StadiumBorder(
                            side: BorderSide(
                                color: isPremium ? AppColors.yellow : AppColors.white, width: 2))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          rank!.name ?? "",
                          style: AppTextStyle.font13W500Normal
                              .copyWith(color: AppColors.white, fontSize: 8),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Image.network(
                          height: 16,
                          width: 16,
                          rank!.icon ?? "",
                          errorBuilder: (context, error, stackTrace) => const Center(),
                        )
                      ],
                    ),
                  ),
                ),
              )),
        if (isPremium)
          Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                decoration: const ShapeDecoration(color: AppColors.yellow, shape: CircleBorder()),
                child: SvgPicture.asset(
                  Assets.icons.union,
                ),
              ))
      ],
    );
  }
}

class CounterUpTimer extends StatelessWidget {
  const CounterUpTimer({super.key, required this.viewmodel});

  final SearchingOpponentViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: viewmodel.seconds,
      builder: (context, value, child) => Text(
        "${value ~/ 60}:${(value % 60).toString().padLeft(2, '0')}",
        style: AppTextStyle.font13W500Normal.copyWith(color: AppColors.white, fontSize: 14),
      ),
    );
  }
}
