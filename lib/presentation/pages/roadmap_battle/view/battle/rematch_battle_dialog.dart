import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/data/model/roadmap/rank_model.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/searching_opponent_page.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/battle_result_viewmodel.dart';

class RematchBattleDialog extends StatelessWidget {
  const RematchBattleDialog({super.key, required this.viewmodel});

  final BattleResultViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                borderRadius: BorderRadius.circular(28),
                color: AppColors.blue,
                child: ListView(
                  padding: EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          height: 24,
                          width: 24,
                          Assets.icons.battle,
                        ),
                        Text(
                          "friendly_match".tr(),
                          style: AppTextStyle.font13W500Normal
                              .copyWith(fontSize: 14, color: AppColors.white),
                        ),
                        ValueListenableBuilder(
                          valueListenable: viewmodel.seconds,
                          builder: (context, value, child) => Text(
                            "${value ~/ 60}:${(value % 60).toString().padLeft(2, '0')}",
                            style: AppTextStyle.font13W500Normal
                                .copyWith(fontSize: 14, color: AppColors.white),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      decoration: AppDecoration.resultDecor.copyWith(color: AppColors.white),
                      child: Row(
                        children: [
                          UserDetails(
                            isPremium: viewmodel.rematchOpponentUser!.isPremuimStatus,
                            rank: viewmodel.rematchOpponentUser!.rank,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  viewmodel.rematchOpponentUser?.name ?? "",
                                  style: AppTextStyle.font17W600Normal
                                      .copyWith(fontSize: 18, color: AppColors.blue),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "opponent".tr(),
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
                                  (viewmodel.rematchOpponentUser?.level ?? 0).toString(),
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
                    Row(
                      children: [
                        Expanded(
                            child: ValueListenableBuilder(
                          valueListenable: viewmodel.rematchInProgress,
                          builder: (context, value, child) => WButton(
                            isLoading: value && viewmodel.statusTag == viewmodel.rejectedTag,
                            color: AppColors.white.withValues(alpha: 0.1),
                            height: 45,
                            title: "rejection".tr(),
                            onTap: () {
                              viewmodel.postRematchUpdateStatus(viewmodel.rejectedTag);
                            },
                          ),
                        )),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: viewmodel.rematchInProgress,
                            builder: (context, value, child) => WButton(
                              isLoading: value && viewmodel.statusTag == viewmodel.acceptedTag,
                              color: AppColors.lavender,
                              height: 45,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    Assets.icons.battle,
                                    colorFilter: ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "accept".tr(),
                                    style: AppTextStyle.font13W500Normal
                                        .copyWith(color: AppColors.blue, fontSize: 14),
                                  )
                                ],
                              ),
                              onTap: () {
                                viewmodel.postRematchUpdateStatus(viewmodel.acceptedTag);
                              },
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
