import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/data/model/battle/battle_user_model.dart';
import 'package:wisdom/data/model/roadmap/rank_model.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/searching_opponent_page.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/battle_result_viewmodel.dart';

class WaitingOpponentBattleDialog extends StatelessWidget {
  const WaitingOpponentBattleDialog({super.key, required this.opponentUser});

  final BattleUserModel opponentUser;

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
                      "waiting_for_your_opponent".tr(),
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
                                  isPremium: opponentUser.isPremuimStatus,
                                  rank: opponentUser.rank,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        opponentUser.name ?? "",
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
                                        (opponentUser.rank?.rangeTo ?? 0).toString(),
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
                          Positioned.fill(
                            child: Material(
                              color: AppColors.white.withValues(alpha: 0.9),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 11),
                                  child: Text(
                                    "waiting_for_your_opponent_content".tr(),
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.font15W700Normal
                                        .copyWith(fontSize: 14, color: AppColors.blue),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    WButton(
                      height: 45,
                      title: "got_it".tr(),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
