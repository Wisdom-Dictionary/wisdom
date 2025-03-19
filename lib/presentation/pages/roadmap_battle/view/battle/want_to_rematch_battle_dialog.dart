import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/data/model/roadmap/rank_model.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/searching_opponent_page.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/battle_result_viewmodel.dart';

class WantRematchBattleDialog extends StatelessWidget {
  const WantRematchBattleDialog({super.key, required this.viewmodel});

  final BattleResultViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: SafeArea(
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                borderRadius: BorderRadius.circular(18),
                color: isDarkTheme ? AppColors.darkGray : AppColors.white,
                child: ListView(
                  padding: EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 24),
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Center(
                        child: Text(
                      "do_you_want_to_rematch".tr(),
                      style: AppTextStyle.font13W500Normal
                          .copyWith(color: isDarkTheme ? AppColors.white : AppColors.black),
                    )),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 32),
                      decoration: AppDecoration.resultDecor
                          .copyWith(color: AppColors.pink.withValues(alpha: 0.1)),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                            child: Row(
                              children: [
                                UserDetails(
                                  isPremium: viewmodel.opponentUser!.isPremuimStatus,
                                  rank: viewmodel.opponentUser!.rank,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        viewmodel.opponentUser?.name ?? "",
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
                                        (viewmodel.opponentUser?.level ?? 0).toString(),
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
                          ValueListenableBuilder(
                            valueListenable: viewmodel.waitingRematch,
                            builder: (context, value, child) {
                              if (value) {
                                return Positioned.fill(
                                  child: Material(
                                    color: AppColors.white.withValues(alpha: 0.9),
                                    child: Center(
                                      child: Text(
                                        "${"waiting_for_your_opponent".tr()}...",
                                        style: AppTextStyle.font15W700Normal
                                            .copyWith(fontSize: 14, color: AppColors.blue),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Center();
                            },
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ValueListenableBuilder(
                              valueListenable: viewmodel.waitingRematch,
                              builder: (context, value, child) => WButton(
                                    color: AppColors.lavender,
                                    height: 45,
                                    titleColor: AppColors.blue,
                                    title: "cancel".tr(),
                                    onTap: () {
                                      Navigator.pop(context);
                                      viewmodel.cancelRematch();
                                    },
                                  )),
                        ),
                        ValueListenableBuilder(
                          valueListenable: viewmodel.waitingRematch,
                          builder: (context, value, child) {
                            if (!value) {
                              return Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                        child: ValueListenableBuilder(
                                      valueListenable: viewmodel.rematchInProgress,
                                      builder: (context, value, child) => WButton(
                                        isLoading: value,
                                        height: 45,
                                        title: "continue".tr(),
                                        onTap: () {
                                          viewmodel.postRematchRequest();
                                        },
                                      ),
                                    ))
                                  ],
                                ),
                              );
                            }
                            return Center();
                          },
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
