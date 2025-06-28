import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/searching_opponent_page.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/searching_opponent_viewmodel.dart';

class OpponentWasFoundDialog extends StatelessWidget {
  const OpponentWasFoundDialog({
    super.key,
    required this.viewmodel,
  });

  final SearchingOpponentViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18.0))),
        child: ValueListenableBuilder(
          valueListenable: viewmodel.matchCancelledTag,
          builder: (_, value, child) {
            if (value) {
              Navigator.pop(context);
            }
            return ListView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.only(top: 32, left: 24, right: 24, bottom: 24),
              shrinkWrap: true,
              children: [
                Text(
                  "opponent_has_found".tr(),
                  textAlign: TextAlign.center,
                  style:
                      AppTextStyle.font17W600Normal.copyWith(fontSize: 18, color: AppColors.blue),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      UserDetailsWithName(
                          isPremium: viewmodel.userDetailsModel.isPremuimStatus,
                          rank: viewmodel.userDetailsModel.rank,
                          name: "you".tr()),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                        ),
                        child: Text(
                          "vs".tr(),
                          style: AppTextStyle.font28W600Normal
                              .copyWith(color: AppColors.blue, fontSize: 24),
                        ),
                      ),
                      UserDetailsWithName(
                          isPremium: viewmodel.opponentUser!.isPremuimStatus,
                          rank: viewmodel.opponentUser!.rank,
                          name: viewmodel.opponentUser!.name),
                    ],
                  ),
                ),
                countDownTimer(),
                const SizedBox(
                  height: 32,
                ),
                ValueListenableBuilder(
                  valueListenable: viewmodel.readyBattleTagLoading,
                  builder: (context, value, child) => WButton(
                    isDisable: viewmodel.isSuccess(tag: viewmodel.readyBattleTag),
                    isLoading: value,
                    child: viewmodel.isSuccess(tag: viewmodel.readyBattleTag)
                        ? Text(
                            "waiting_for_your_opponent".tr(),
                            style: AppTextStyle.font15W500Normal.copyWith(color: AppColors.white),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(Assets.icons.battle),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "start".tr(),
                                style: AppTextStyle.font13W500Normal
                                    .copyWith(color: AppColors.white, fontSize: 14),
                              )
                            ],
                          ),
                    onTap: () {
                      viewmodel.readyBattle();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Center countDownTimer() {
    return Center(
      child: DottedBorder(
          borderType: BorderType.RRect,
          dashPattern: const [
            8,
            8,
          ],
          radius: const Radius.circular(1000),
          color: AppColors.blue.withValues(alpha: 0.15),
          strokeWidth: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: ValueListenableBuilder(
            valueListenable: viewmodel.seconds,
            builder: (context, value, child) => Text(
              "$value",
              style: AppTextStyle.font28W600Normal.copyWith(fontSize: 42, color: AppColors.blue),
            ),
          )),
    );
  }
}
